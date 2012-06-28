Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab2F1U5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 16:57:35 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:48125 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab2F1U5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 16:57:33 -0400
X-SMTPAUTH-GN: [zoltan.kelemen@privat.utfors.se]
X-SENDER-IP: [78.82.105.213]
X-LISTENER: [smtp.glocalnet.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAE/E7E9OUmnV/2dsb2JhbAANOLoEAQxRATwWGAMCAQIBTAwBBQIBAYYNuyqLNwGGCQOOR5lPgVQHAg
X-IronPort-AV: E=Sophos;i="4.77,494,1336341600"; 
   d="scan'208";a="368034142"
Message-ID: <4FECC539.8040303@digisec.se>
Date: Thu, 28 Jun 2012 22:57:29 +0200
From: Zoltan Kelemen <zoltan@digisec.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: willy@meta-x.org, gregkh@linuxfoundation.org
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] staging:panel: Rewrite for fixing synchronization issues
Content-Type: multipart/mixed;
 boundary="------------000109060009070808040106"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000109060009070808040106
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


--------------000109060009070808040106
Content-Type: text/plain;
 name="panel-patch1"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="panel-patch1"

Partial rewrite of panel driver to make it more robust. The old code contains
problems potentially leading to kernel oops, deadlocks and memory leaks.

The patch contains the following changes:
* Handle asynchronous attach/detach to/from parport.
* Proper synchronization of multiple opens to same device.
* Proper disabling of softirqs when locking pprt from user context.
* Replaced interruptible_sleep_on in keypad_read to avoid race conditions.
* Changed to del_timer_sync to make sure timer function finishes before
  unloading module.
* Added owner to file_operations to avoid module being unloaded with dangling
  opens.
* Check status of user-mode memory write in keypad_read.
* Check for and handle errors in keypad_init.
* Properly free memory for logical_inputs to avoid memory leak on unload.

Signed-off-by: Zoltan Kelemen <zoltan@digisec.se>
----
diff -ru linux-next/drivers/staging/panel/panel.c panel-patch1/drivers/staging/panel/panel.c
--- linux-next/drivers/staging/panel/panel.c	2012-06-27 05:03:21.000000000 +0200
+++ panel-patch1/drivers/staging/panel/panel.c	2012-06-28 11:49:21.034467337 +0200
@@ -1,6 +1,7 @@
 /*
  * Front panel driver for Linux
  * Copyright (C) 2000-2008, Willy Tarreau <w@1wt.eu>
+ * Partially rewritten 2012, Zoltan Kelemen <zoltan@digisec.se>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -21,14 +22,9 @@
  * Several profiles are provided for commonly found LCD+keypad modules on the
  * market, such as those found in Nexcom's appliances.
  *
- * FIXME:
- *      - the initialization/deinitialization process is very dirty and should
- *        be rewritten. It may even be buggy.
- *
  * TODO:
  *	- document 24 keys keyboard (3 rows of 8 cols, 32 diodes + 2 inputs)
  *      - make the LCD a part of a virtual screen of Vx*Vy
- *	- make the inputs list smp-safe
  *      - change the keyboard to a double mapping : signals -> key_id -> values
  *        so that applications can change values without knowing signals
  *
@@ -62,7 +58,7 @@
 #define LCD_MINOR		156
 #define KEYPAD_MINOR		185
 
-#define PANEL_VERSION		"0.9.5"
+#define PANEL_VERSION		"0.9.6"
 
 #define LCD_MAXBYTES		256	/* max burst write */
 
@@ -70,6 +66,7 @@
 
 /* poll the keyboard this every second */
 #define INPUT_POLL_TIME		(HZ/50)
+
 /* a key starts to repeat after this times INPUT_POLL_TIME */
 #define KEYPAD_REP_START	(10)
 /* a key repeats this times INPUT_POLL_TIME */
@@ -129,7 +126,7 @@
 #define LCD_FLAG_L		0x0080	/* backlight enabled */
 
 #define LCD_ESCAPE_LEN		24	/* max chars for LCD escape command */
-#define LCD_ESCAPE_CHAR	27	/* use char 27 for escape command */
+#define LCD_ESCAPE_CHAR		27	/* use char 27 for escape command */
 
 /* macros to simplify use of the parallel port */
 #define r_ctr(x)        (parport_read_control((x)->port))
@@ -138,12 +135,6 @@
 #define w_ctr(x, y)     do { parport_write_control((x)->port, (y)); } while (0)
 #define w_dtr(x, y)     do { parport_write_data((x)->port, (y)); } while (0)
 
-/* this defines which bits are to be used and which ones to be ignored */
-/* logical or of the output bits involved in the scan matrix */
-static __u8 scan_mask_o;
-/* logical or of the input bits involved in the scan matrix */
-static __u8 scan_mask_i;
-
 typedef __u64 pmask_t;
 
 enum input_type {
@@ -183,8 +174,6 @@
 	} u;
 };
 
-LIST_HEAD(logical_inputs);	/* list of all defined logical inputs */
-
 /* physical contacts history
  * Physical contacts are a 45 bits string of 9 groups of 5 bits each.
  * The 8 lower groups correspond to output bits 0 to 7, and the 9th group
@@ -196,6 +185,9 @@
  * <-----unused------><gnd><d07><d06><d05><d04><d03><d02><d01><d00>
  */
 
+/*
+ * Group of keypad variables accessed only from timer function.
+ */
 /* what has just been read from the I/O ports */
 static pmask_t phys_read;
 /* previous phys_read */
@@ -207,25 +199,67 @@
 /* 0 means that at least one logical signal needs be computed */
 static char inputs_stable;
 
-/* these variables are specific to the keypad */
+/*
+ * Group of keypad variables shared between timer/process context code,
+ * protected by a spinlock. Keypresses are stored at the write end of the
+ * circular buffer, when the keypad device is open.
+ */
+static DEFINE_SPINLOCK(keypad_lock);
+static int keypad_open_cnt;
 static char keypad_buffer[KEYPAD_BUFFER];
-static int keypad_buflen;
 static int keypad_start;
-static char keypressed;
-static wait_queue_head_t keypad_read_wait;
+static int keypad_buflen;
+
+/* Wait queue shared by process/timer context used for blocked reads */
+static DECLARE_WAIT_QUEUE_HEAD(keypad_read_wait);
+
+/*
+ * Keypad variables initialized once when attaching to parallel port, there-
+ * after used as readonly or updated only from timer function.
+ */
+static int keypad_initialized;       /* Nonzero when vars below initialized */
+static LIST_HEAD(logical_inputs);    /* List of all defined logical inputs */
+static __u8 scan_mask_o;             /* Output bits involved in scan matrix */
+static __u8 scan_mask_i;             /* Input bits involved in scan matrix */
+static int keypressed;               /* Key pressed (light backlight) */
+
+/* LCD vars used from timer */
+static int light_tempo;              /* Time left before backlight off */
+static int backlight_on;             /* Nonzero when backlight is on */
+static struct timer_list scan_timer; /* Timer used for keypad scanning */
+static int timer_running;            /* Nonzero when timer enabled */
 
-/* lcd-specific variables */
+/*
+ * Group of parallel-port-related variables. They are protected in process
+ * context with a mutex.
+ *
+ * The system basically has two states: port available (pprt != NULL) and port
+ * unavailable (pprt == NULL). When the port is available all globals are
+ * initialized and valid and the timer function may be running. When port is
+ * unavailable the timer is not running and most globals are undefined.
+ */
+static DEFINE_MUTEX(port_mutex);     /* Protects variables below */
+static struct pardevice *pprt;       /* Non-NULL when port is available */
+static unsigned long int lcd_flags;  /* Contains the LCD config state */
+static unsigned long int lcd_addr_x; /* Contains the LCD X offset */
+static unsigned long int lcd_addr_y; /* Contains the LCD Y offset */
+static char lcd_must_clear;          /* Clear display on next device open */
+static char lcd_escape[LCD_ESCAPE_LEN+1]; /* Current escape sequence */
+static int lcd_escape_len;           /* >=0 = escape cmd len, -1 no escape */
+
+/*
+ * Protects port accesses between timer/process context code and the variables
+ * below.
+ */
+static DEFINE_SPINLOCK(pprt_lock);
+static int backlight_flash;          /* Turn on backlight for short time */
+static int force_backlight_on;       /* Nonzero to lock backlight on */
 
-/* contains the LCD config state */
-static unsigned long int lcd_flags;
-/* contains the LCD X offset */
-static unsigned long int lcd_addr_x;
-/* contains the LCD Y offset */
-static unsigned long int lcd_addr_y;
-/* current escape sequence, 0 terminated */
-static char lcd_escape[LCD_ESCAPE_LEN + 1];
-/* not in escape state. >=0 = escape cmd len */
-static int lcd_escape_len = -1;
+static unsigned long lcd_is_open;    /* Nonzero if LCD device opened */
+
+static void (*lcd_write_cmd) (int);
+static void (*lcd_write_data) (int);
+static void (*lcd_clear_fast) (void);
 
 /*
  * Bit masks to convert LCD signals to parallel port outputs.
@@ -401,27 +435,6 @@
 
 #endif /* DEFAULT_PROFILE == 0 */
 
-/* global variables */
-static int keypad_open_cnt;	/* #times opened */
-static int lcd_open_cnt;	/* #times opened */
-static struct pardevice *pprt;
-
-static int lcd_initialized;
-static int keypad_initialized;
-
-static int light_tempo;
-
-static char lcd_must_clear;
-static char lcd_left_shift;
-static char init_in_progress;
-
-static void (*lcd_write_cmd) (int);
-static void (*lcd_write_data) (int);
-static void (*lcd_clear_fast) (void);
-
-static DEFINE_SPINLOCK(pprt_lock);
-static struct timer_list scan_timer;
-
 MODULE_DESCRIPTION("Generic parallel port LCD/Keypad driver");
 
 static int parport = -1;
@@ -609,7 +622,7 @@
 	unsigned char da; /* serial LCD data */
 } bits;
 
-static void init_scan_timer(void);
+static void start_scan_timer(void);
 
 /* sets data port bits according to current signals values */
 static int set_data_bits(void)
@@ -667,7 +680,7 @@
  *   out(dport, in(dport) & d_val[2] | d_val[signal_state])
  *   out(cport, in(cport) & c_val[2] | c_val[signal_state])
  */
-void pin_to_bits(int pin, unsigned char *d_val, unsigned char *c_val)
+static void pin_to_bits(int pin, unsigned char *d_val, unsigned char *c_val)
 {
 	int d_bit, c_bit, inv;
 
@@ -748,45 +761,74 @@
 	}
 }
 
-/* turn the backlight on or off */
-static void lcd_backlight(int on)
+
+/*
+ * Lock/unlock parallel port for use between timer/process context. Used by
+ * most low-level functions accessing the port. Assumed that caller is
+ * process context since we disable softirqs. The timer function locks the port
+ * itself and only calls unlocked functions.
+ */
+static void lock_pprt(void)
+{
+	spin_lock_bh(&pprt_lock);
+}
+
+static void unlock_pprt(void)
+{
+	spin_unlock_bh(&pprt_lock);
+}
+
+
+/* turn the backlight on or off. assumes caller grabbed the spin lock */
+static void lcd_backlight_unlocked(int on)
 {
 	if (lcd_bl_pin == PIN_NONE)
 		return;
 
-	/* The backlight is activated by setting the AUTOFEED line to +5V  */
-	spin_lock(&pprt_lock);
+	/* The backlight is activated by setting the backlight line */
 	bits.bl = on;
+	backlight_on = on;
 	panel_set_bits();
-	spin_unlock(&pprt_lock);
+}
+
+/*
+ * Turn backlight on from process context. Remember backlight setting, if
+ * enabled here it is not turned off when expired in the timer.
+ */
+static void lcd_backlight(int on)
+{
+	lock_pprt();
+	lcd_backlight_unlocked(on);
+	force_backlight_on = on;
+	unlock_pprt();
 }
 
 /* send a command to the LCD panel in serial mode */
 static void lcd_write_cmd_s(int cmd)
 {
-	spin_lock(&pprt_lock);
+	lock_pprt();
 	lcd_send_serial(0x1F);	/* R/W=W, RS=0 */
 	lcd_send_serial(cmd & 0x0F);
 	lcd_send_serial((cmd >> 4) & 0x0F);
 	udelay(40);		/* the shortest command takes at least 40 us */
-	spin_unlock(&pprt_lock);
+	unlock_pprt();
 }
 
 /* send data to the LCD panel in serial mode */
 static void lcd_write_data_s(int data)
 {
-	spin_lock(&pprt_lock);
+	lock_pprt();
 	lcd_send_serial(0x5F);	/* R/W=W, RS=1 */
 	lcd_send_serial(data & 0x0F);
 	lcd_send_serial((data >> 4) & 0x0F);
 	udelay(40);		/* the shortest data takes at least 40 us */
-	spin_unlock(&pprt_lock);
+	unlock_pprt();
 }
 
 /* send a command to the LCD panel in 8 bits parallel mode */
 static void lcd_write_cmd_p8(int cmd)
 {
-	spin_lock(&pprt_lock);
+	lock_pprt();
 	/* present the data to the data port */
 	w_dtr(pprt, cmd);
 	udelay(20);	/* maintain the data during 20 us before the strobe */
@@ -802,13 +844,13 @@
 	set_ctrl_bits();
 
 	udelay(120);	/* the shortest command takes at least 120 us */
-	spin_unlock(&pprt_lock);
+	unlock_pprt();
 }
 
 /* send data to the LCD panel in 8 bits parallel mode */
 static void lcd_write_data_p8(int data)
 {
-	spin_lock(&pprt_lock);
+	lock_pprt();
 	/* present the data to the data port */
 	w_dtr(pprt, data);
 	udelay(20);	/* maintain the data during 20 us before the strobe */
@@ -824,27 +866,27 @@
 	set_ctrl_bits();
 
 	udelay(45);	/* the shortest data takes at least 45 us */
-	spin_unlock(&pprt_lock);
+	unlock_pprt();
 }
 
 /* send a command to the TI LCD panel */
 static void lcd_write_cmd_tilcd(int cmd)
 {
-	spin_lock(&pprt_lock);
+	lock_pprt();
 	/* present the data to the control port */
 	w_ctr(pprt, cmd);
 	udelay(60);
-	spin_unlock(&pprt_lock);
+	unlock_pprt();
 }
 
 /* send data to the TI LCD panel */
 static void lcd_write_data_tilcd(int data)
 {
-	spin_lock(&pprt_lock);
+	lock_pprt();
 	/* present the data to the data port */
 	w_dtr(pprt, data);
 	udelay(60);
-	spin_unlock(&pprt_lock);
+	unlock_pprt();
 }
 
 static void lcd_gotoxy(void)
@@ -877,14 +919,14 @@
 	lcd_addr_x = lcd_addr_y = 0;
 	lcd_gotoxy();
 
-	spin_lock(&pprt_lock);
+	lock_pprt();
 	for (pos = 0; pos < lcd_height * lcd_hwidth; pos++) {
 		lcd_send_serial(0x5F);	/* R/W=W, RS=1 */
 		lcd_send_serial(' ' & 0x0F);
 		lcd_send_serial((' ' >> 4) & 0x0F);
 		udelay(40);	/* the shortest data takes at least 40 us */
 	}
-	spin_unlock(&pprt_lock);
+	unlock_pprt();
 
 	lcd_addr_x = lcd_addr_y = 0;
 	lcd_gotoxy();
@@ -897,7 +939,7 @@
 	lcd_addr_x = lcd_addr_y = 0;
 	lcd_gotoxy();
 
-	spin_lock(&pprt_lock);
+	lock_pprt();
 	for (pos = 0; pos < lcd_height * lcd_hwidth; pos++) {
 		/* present the data to the data port */
 		w_dtr(pprt, ' ');
@@ -919,7 +961,7 @@
 		/* the shortest data takes at least 45 us */
 		udelay(45);
 	}
-	spin_unlock(&pprt_lock);
+	unlock_pprt();
 
 	lcd_addr_x = lcd_addr_y = 0;
 	lcd_gotoxy();
@@ -932,14 +974,14 @@
 	lcd_addr_x = lcd_addr_y = 0;
 	lcd_gotoxy();
 
-	spin_lock(&pprt_lock);
+	lock_pprt();
 	for (pos = 0; pos < lcd_height * lcd_hwidth; pos++) {
 		/* present the data to the data port */
 		w_dtr(pprt, ' ');
 		udelay(60);
 	}
 
-	spin_unlock(&pprt_lock);
+	unlock_pprt();
 
 	lcd_addr_x = lcd_addr_y = 0;
 	lcd_gotoxy();
@@ -995,12 +1037,13 @@
 }
 
 /*
- * These are the file operation function for user access to /dev/lcd
+ * These are the file operation functions for user access to /dev/lcd
  * This function can also be called from inside the kernel, by
  * setting file and ppos to NULL.
  *
  */
 
+/* Called with port mutex held and port being available */
 static inline int handle_lcd_special_code(void)
 {
 	/* LCD special codes */
@@ -1044,13 +1087,10 @@
 		lcd_flags &= ~LCD_FLAG_L;
 		processed = 1;
 		break;
-	case '*':
-		/* flash back light using the keypad timer */
-		if (scan_timer.function != NULL) {
-			if (light_tempo == 0 && ((lcd_flags & LCD_FLAG_L) == 0))
-				lcd_backlight(1);
-			light_tempo = FLASH_LIGHT_TEMPO;
-		}
+	case '*':	/* Flash back light using the keypad timer */
+		lock_pprt();
+		backlight_flash = 1;
+		unlock_pprt();
 		processed = 1;
 		break;
 	case 'f':	/* Small Font */
@@ -1088,12 +1128,10 @@
 		processed = 1;
 		break;
 	case 'L':	/* shift display left */
-		lcd_left_shift++;
 		lcd_write_cmd(0x18);
 		processed = 1;
 		break;
 	case 'R':	/* shift display right */
-		lcd_left_shift--;
 		lcd_write_cmd(0x1C);
 		processed = 1;
 		break;
@@ -1109,7 +1147,6 @@
 	}
 	case 'I':	/* reinitialize display */
 		lcd_init_display();
-		lcd_left_shift = 0;
 		processed = 1;
 		break;
 	case 'G': {
@@ -1211,36 +1248,27 @@
 				      | ((lcd_flags & LCD_FLAG_F) ? 4 : 0)
 				      | ((lcd_flags & LCD_FLAG_N) ? 8 : 0));
 		/* check wether L flag was changed */
-		else if ((oldflags ^ lcd_flags) & (LCD_FLAG_L)) {
-			if (lcd_flags & (LCD_FLAG_L))
-				lcd_backlight(1);
-			else if (light_tempo == 0)
-				/* switch off the light only when the tempo
-				   lighting is gone */
-				lcd_backlight(0);
-		}
+		else if ((oldflags ^ lcd_flags) & (LCD_FLAG_L))
+			lcd_backlight((lcd_flags & LCD_FLAG_L) ? 1 : 0);
 	}
 
 	return processed;
 }
 
-static ssize_t lcd_write(struct file *file,
-			 const char *buf, size_t count, loff_t *ppos)
+
+static ssize_t lcd_write_unlocked(struct file *file,
+				  const char *buf, size_t count, loff_t *ppos)
 {
 	const char *tmp = buf;
 	char c;
 
 	for (; count-- > 0; (ppos ? (*ppos)++ : 0), ++tmp) {
-		if (!in_interrupt() && (((count + 1) & 0x1f) == 0))
-			/* let's be a little nice with other processes
-			   that need some CPU */
-			schedule();
-
 		if (ppos == NULL && file == NULL)
 			/* let's not use get_user() from the kernel ! */
 			c = *tmp;
-		else if (get_user(c, tmp))
+		else if (get_user(c, tmp)) {
 			return -EFAULT;
+		}
 
 		/* first, we'll test if we're in escape mode */
 		if ((c != '\n') && lcd_escape_len >= 0) {
@@ -1334,29 +1362,67 @@
 	return tmp - buf;
 }
 
-static int lcd_open(struct inode *inode, struct file *file)
+
+static ssize_t lcd_write(struct file *file,
+			 const char *buf, size_t count, loff_t *ppos)
 {
-	if (lcd_open_cnt)
-		return -EBUSY;	/* open only once at a time */
+	ssize_t ret;
+
+	/* Protect access to the port and check that it's still available */
+	mutex_lock(&port_mutex);
 
-	if (file->f_mode & FMODE_READ)	/* device is write-only */
+	if (pprt == NULL) {
+		mutex_unlock(&port_mutex);
+		return -ENODEV;
+	}
+
+	ret = lcd_write_unlocked(file, buf, count, ppos);
+
+	mutex_unlock(&port_mutex);
+
+	return ret;
+}
+
+
+static int lcd_open(struct inode *inode, struct file *file)
+{
+	/* Device is write-only */
+	if (file->f_mode & FMODE_READ)
 		return -EPERM;
 
+	/* Only one open allowed at a time */
+	if (test_and_set_bit(0, &lcd_is_open))
+		return -EBUSY;
+
+	mutex_lock(&port_mutex);
+
+	/* Check for port still being available */
+	if (!pprt) {
+		mutex_unlock(&port_mutex);
+		return -ENODEV;
+	}
+
+	lcd_escape_len = -1;
+
+	/* Clear display if needed */
 	if (lcd_must_clear) {
 		lcd_clear_display();
 		lcd_must_clear = 0;
 	}
-	lcd_open_cnt++;
+
+	mutex_unlock(&port_mutex);
+
 	return nonseekable_open(inode, file);
 }
 
 static int lcd_release(struct inode *inode, struct file *file)
 {
-	lcd_open_cnt--;
+	clear_bit(0, &lcd_is_open);
 	return 0;
 }
 
 static const struct file_operations lcd_fops = {
+	.owner   = THIS_MODULE,
 	.write   = lcd_write,
 	.open    = lcd_open,
 	.release = lcd_release,
@@ -1369,15 +1435,29 @@
 	&lcd_fops
 };
 
+/*
+ * Print LCD messages, assumes caller has taken port mutex and checked that
+ * the port is available.
+ */
+static void panel_lcd_print_unlocked(char *s)
+{
+	lcd_write_unlocked(NULL, s, strlen(s), NULL);
+}
+
+
 /* public function usable from the kernel for any purpose */
-void panel_lcd_print(char *s)
+static void panel_lcd_print(char *s)
 {
-	if (lcd_enabled && lcd_initialized)
-		lcd_write(NULL, s, strlen(s), NULL);
+	mutex_lock(&port_mutex);
+
+	if (pprt)
+		panel_lcd_print_unlocked(s);
+
+	mutex_unlock(&port_mutex);
 }
 
-/* initialize the LCD driver */
-void lcd_init(void)
+/* Initialize LCD driver module globals */
+static void lcd_init_globals(void)
 {
 	switch (lcd_type) {
 	case LCD_TYPE_OLD:
@@ -1536,9 +1616,6 @@
 	else
 		lcd_char_conv = NULL;
 
-	if (lcd_bl_pin != PIN_NONE)
-		init_scan_timer();
-
 	pin_to_bits(lcd_e_pin, lcd_bits[LCD_PORT_D][LCD_BIT_E],
 		    lcd_bits[LCD_PORT_C][LCD_BIT_E]);
 	pin_to_bits(lcd_rs_pin, lcd_bits[LCD_PORT_D][LCD_BIT_RS],
@@ -1551,21 +1628,24 @@
 		    lcd_bits[LCD_PORT_C][LCD_BIT_CL]);
 	pin_to_bits(lcd_da_pin, lcd_bits[LCD_PORT_D][LCD_BIT_DA],
 		    lcd_bits[LCD_PORT_C][LCD_BIT_DA]);
+}
 
-	/* before this line, we must NOT send anything to the display.
-	 * Since lcd_init_display() needs to write data, we have to
-	 * enable mark the LCD initialized just before. */
-	lcd_initialized = 1;
+/* Do LCD panel initialization. Caller must hold port mutex */
+static void lcd_init(void)
+{
 	lcd_init_display();
 
+	lcd_escape_len = -1;
+
 	/* display a short message */
 #ifdef CONFIG_PANEL_CHANGE_MESSAGE
 #ifdef CONFIG_PANEL_BOOT_MESSAGE
-	panel_lcd_print("\x1b[Lc\x1b[Lb\x1b[L*" CONFIG_PANEL_BOOT_MESSAGE);
+	panel_lcd_print_unlocked("\x1b[Lc\x1b[Lb\x1b[L*"
+				 CONFIG_PANEL_BOOT_MESSAGE);
 #endif
 #else
-	panel_lcd_print("\x1b[Lc\x1b[Lb\x1b[L*Linux-" UTS_RELEASE "\nPanel-"
-			PANEL_VERSION);
+	panel_lcd_print_unlocked("\x1b[Lc\x1b[Lb\x1b[L*Linux-" UTS_RELEASE
+				 "\nPanel-" PANEL_VERSION);
 #endif
 	lcd_addr_x = lcd_addr_y = 0;
 	/* clear the display on the next device opening */
@@ -1573,6 +1653,14 @@
 	lcd_gotoxy();
 }
 
+
+/* Do LCD panel cleanup. Caller must hold port mutex */
+static void lcd_cleanup(void)
+{
+	panel_lcd_print_unlocked("\x0cLCD driver " PANEL_VERSION
+				 "\nstopped.\x1b[Lc\x1b[Lb\x1b[L-");
+}
+
 /*
  * These are the file operation function for user access to /dev/keypad
  */
@@ -1580,53 +1668,88 @@
 static ssize_t keypad_read(struct file *file,
 			   char *buf, size_t count, loff_t *ppos)
 {
+	static char key_buf[KEYPAD_BUFFER];
+	int i;
 
-	unsigned i = *ppos;
-	char *tmp = buf;
+	if (count == 0)
+		return 0;
+
+	/*
+	 * In case data is available in the global buffer, copy it to our local
+	 * buffer. This is needed since we can't copy to the user buffer while
+	 * holding the spinlock. Our local buffer can be static since there can
+	 * only be one opener of the device.
+	 *
+	 * In case there is no data available, we put the process on a wait
+	 * queue. It will be woken up when data arrives.
+	 */
+	spin_lock_bh(&keypad_lock);
+
+	while (keypad_buflen == 0) {
+		spin_unlock_bh(&keypad_lock);
 
-	if (keypad_buflen == 0) {
 		if (file->f_flags & O_NONBLOCK)
 			return -EAGAIN;
 
-		interruptible_sleep_on(&keypad_read_wait);
-		if (signal_pending(current))
-			return -EINTR;
+		if (wait_event_interruptible(keypad_read_wait,
+					     (keypad_buflen != 0)))
+			return -ERESTARTSYS;
+
+		spin_lock_bh(&keypad_lock);
 	}
 
-	for (; count-- > 0 && (keypad_buflen > 0);
-	     ++i, ++tmp, --keypad_buflen) {
-		put_user(keypad_buffer[keypad_start], tmp);
+	for (i = 0; (size_t) i < count && i < keypad_buflen; i++) {
+		key_buf[i] = keypad_buffer[keypad_start];
 		keypad_start = (keypad_start + 1) % KEYPAD_BUFFER;
 	}
-	*ppos = i;
+	keypad_buflen -= i;
 
-	return tmp - buf;
+	spin_unlock_bh(&keypad_lock);
+
+	if (copy_to_user(buf, key_buf, i))
+		return -EFAULT;
+
+	(*ppos) += (loff_t) i;
+
+	return (ssize_t) i;
 }
 
 static int keypad_open(struct inode *inode, struct file *file)
 {
-
-	if (keypad_open_cnt)
-		return -EBUSY;	/* open only once at a time */
+	int r;
 
 	if (file->f_mode & FMODE_WRITE)	/* device is read-only */
 		return -EPERM;
 
-	keypad_buflen = 0;	/* flush the buffer on opening */
-	keypad_open_cnt++;
-	return 0;
+	spin_lock_bh(&keypad_lock);
+
+	if (keypad_open_cnt)
+		r = -EBUSY;		/* open only once at a time */
+	else {
+		keypad_open_cnt++;
+		keypad_buflen = 0;	/* flush the buffer on opening */
+		keypad_start = 0;
+		r = 0;
+	}
+
+	spin_unlock_bh(&keypad_lock);
+
+	return r;
 }
 
 static int keypad_release(struct inode *inode, struct file *file)
 {
+	spin_lock_bh(&keypad_lock);
 	keypad_open_cnt--;
+	spin_unlock_bh(&keypad_lock);
 	return 0;
 }
 
 static const struct file_operations keypad_fops = {
-	.read    = keypad_read,		/* read */
-	.open    = keypad_open,		/* open */
-	.release = keypad_release,	/* close */
+	.owner   = THIS_MODULE,
+	.read    = keypad_read,
+	.open    = keypad_open,
+	.release = keypad_release,
 	.llseek  = default_llseek,
 };
 
@@ -1638,17 +1761,23 @@
 
 static void keypad_send_key(char *string, int max_len)
 {
-	if (init_in_progress)
-		return;
+	int wake = 0;
 
 	/* send the key to the device only if a process is attached to it. */
+	spin_lock(&keypad_lock);
+
 	if (keypad_open_cnt > 0) {
 		while (max_len-- && keypad_buflen < KEYPAD_BUFFER && *string) {
 			keypad_buffer[(keypad_start + keypad_buflen++) %
 				      KEYPAD_BUFFER] = *string++;
 		}
-		wake_up_interruptible(&keypad_read_wait);
+		wake = 1;
 	}
+
+	spin_unlock(&keypad_lock);
+
+	if (wake)
+		wake_up_interruptible(&keypad_read_wait);
 }
 
 /* this function scans all the bits involving at least one logical signal,
@@ -1660,6 +1789,8 @@
  * reads will be kept as they previously were in their logical form (phys_prev).
  * A signal which has just switched will have a 1 in
  * (phys_read ^ phys_read_prev).
+ *
+ * Assumes caller holds port spinlock.
  */
 static void phys_scan_contacts(void)
 {
@@ -1838,9 +1969,8 @@
 	struct logical_input *input;
 
 #if 0
-	printk(KERN_DEBUG
-	       "entering panel_process_inputs with pp=%016Lx & pc=%016Lx\n",
-	       phys_prev, phys_curr);
+	pr_debug("entering panel_process_inputs with pp=%016Lx & pc=%016Lx\n",
+		 phys_prev, phys_curr);
 #endif
 
 	keypressed = 0;
@@ -1889,45 +2019,64 @@
 
 static void panel_scan_timer(void)
 {
-	if (keypad_enabled && keypad_initialized) {
-		if (spin_trylock(&pprt_lock)) {
-			phys_scan_contacts();
-
-			/* no need for the parport anymore */
-			spin_unlock(&pprt_lock);
-		}
+	/* If keypad available scan keys and send to waiting process */
+	if (keypad_initialized) {
+		spin_lock(&pprt_lock);
+		phys_scan_contacts();
+		spin_unlock(&pprt_lock);
 
 		if (!inputs_stable || phys_curr != phys_prev)
 			panel_process_inputs();
 	}
 
-	if (lcd_enabled && lcd_initialized) {
-		if (keypressed) {
-			if (light_tempo == 0 && ((lcd_flags & LCD_FLAG_L) == 0))
-				lcd_backlight(1);
+	/* Turn backlight on/off if available */
+	if (lcd_enabled && lcd_bl_pin != PIN_NONE) {
+		spin_lock(&pprt_lock);
+
+		if (backlight_flash || keypressed) {
+			backlight_flash = 0;
+			if (light_tempo == 0 && !backlight_on)
+				lcd_backlight_unlocked(1);
 			light_tempo = FLASH_LIGHT_TEMPO;
 		} else if (light_tempo > 0) {
 			light_tempo--;
-			if (light_tempo == 0 && ((lcd_flags & LCD_FLAG_L) == 0))
-				lcd_backlight(0);
+			if (light_tempo == 0 && backlight_on &&
+			    !force_backlight_on) {
+				lcd_backlight_unlocked(0);
+			}
 		}
+
+		spin_unlock(&pprt_lock);
 	}
 
 	mod_timer(&scan_timer, jiffies + INPUT_POLL_TIME);
 }
 
-static void init_scan_timer(void)
+/* Start scan timer, assuming timer is not running */
+static void start_scan_timer(void)
 {
-	if (scan_timer.function != NULL)
-		return;		/* already started */
+	light_tempo = 0;
 
 	init_timer(&scan_timer);
 	scan_timer.expires = jiffies + INPUT_POLL_TIME;
 	scan_timer.data = 0;
-	scan_timer.function = (void *)&panel_scan_timer;
+	scan_timer.function = (void *) &panel_scan_timer;
 	add_timer(&scan_timer);
+	timer_running = 1;
+}
+
+/*
+ * Stop scan timer and wait for it to finish. Assumes that timer is running.
+ * Note that we don't bother waking up any processes in the wait queue, since
+ * we shouldn't have come here with dangling opens to the keypad.
+ */
+static void stop_scan_timer(void)
+{
+	del_timer_sync(&scan_timer);
+	timer_running = 0;
 }
 
+
 /* converts a name of the form "({BbAaPpSsEe}{01234567-})*" to a series of bits.
  * if <omask> or <imask> are non-null, they will be or'ed with the bits
  * corresponding to out and in bits respectively.
@@ -1979,22 +2128,22 @@
 
 /* tries to bind a key to the signal name <name>. The key will send the
  * strings <press>, <repeat>, <release> for these respective events.
- * Returns the pointer to the new key if ok, NULL if the key could not be bound.
+ * Returns 0 on success or negative error code. Updates the logical_inputs,
+ * scan_mask_i and scan_mask_o globals.
  */
-static struct logical_input *panel_bind_key(char *name, char *press,
-					    char *repeat, char *release)
+static int panel_bind_key(char *name, char *press, char *repeat, char *release)
 {
 	struct logical_input *key;
 
 	key = kzalloc(sizeof(struct logical_input), GFP_KERNEL);
 	if (!key) {
-		printk(KERN_ERR "panel: not enough memory\n");
-		return NULL;
+		pr_err("panel: not enough memory\n");
+		return -ENOMEM;
 	}
 	if (!input_name2mask(name, &key->mask, &key->value, &scan_mask_i,
 			     &scan_mask_o)) {
 		kfree(key);
-		return NULL;
+		return -EINVAL;
 	}
 
 	key->type = INPUT_TYPE_KBD;
@@ -2003,15 +2152,15 @@
 	key->fall_time = 1;
 
 #if 0
-	printk(KERN_DEBUG "bind: <%s> : m=%016Lx v=%016Lx\n", name, key->mask,
-	       key->value);
+	pr_debug("bind: <%s> : m=%016Lx v=%016Lx\n", name, key->mask,
+		 key->value);
 #endif
 	strncpy(key->u.kbd.press_str, press, sizeof(key->u.kbd.press_str));
 	strncpy(key->u.kbd.repeat_str, repeat, sizeof(key->u.kbd.repeat_str));
 	strncpy(key->u.kbd.release_str, release,
 		sizeof(key->u.kbd.release_str));
 	list_add(&key->list, &logical_inputs);
-	return key;
+	return 0;
 }
 
 #if 0
@@ -2031,7 +2180,7 @@
 
 	callback = kmalloc(sizeof(struct logical_input), GFP_KERNEL);
 	if (!callback) {
-		printk(KERN_ERR "panel: not enough memory\n");
+		pr_err("panel: not enough memory\n");
 		return NULL;
 	}
 	memset(callback, 0, sizeof(struct logical_input));
@@ -2052,23 +2201,46 @@
 }
 #endif
 
-static void keypad_init(void)
+/* Free memory for keypad variables. Assumes that timer function doesn't run */
+static void keypad_cleanup(void)
+{
+	struct logical_input *p, *next;
+
+	list_for_each_entry_safe(p, next, &logical_inputs, list) {
+		list_del(&p->list);
+		kfree(p);
+	}
+
+	keypad_initialized = 0;
+}
+
+
+/*
+ * Allocate and initialize keypad variables. Assumes that timer function
+ * doesn't run. Returns 0 on success or negative error code.
+ */
+static int keypad_init(void)
 {
 	int keynum;
-	init_waitqueue_head(&keypad_read_wait);
-	keypad_buflen = 0;	/* flushes any eventual noisy keystroke */
+	int r;
 
-	/* Let's create all known keys */
+	scan_mask_o = scan_mask_i = 0;
 
+	/* Let's create all known keys */
 	for (keynum = 0; keypad_profile[keynum][0][0]; keynum++) {
-		panel_bind_key(keypad_profile[keynum][0],
-			       keypad_profile[keynum][1],
-			       keypad_profile[keynum][2],
-			       keypad_profile[keynum][3]);
+		r = panel_bind_key(keypad_profile[keynum][0],
+				   keypad_profile[keynum][1],
+				   keypad_profile[keynum][2],
+				   keypad_profile[keynum][3]);
+		if (r < 0) {
+			keypad_cleanup();
+			return r;
+		}
+
 	}
 
-	init_scan_timer();
 	keypad_initialized = 1;
+	return 0;
 }
 
 /**************************************************/
@@ -2078,7 +2250,7 @@
 static int panel_notify_sys(struct notifier_block *this, unsigned long code,
 			    void *unused)
 {
-	if (lcd_enabled && lcd_initialized) {
+	if (lcd_enabled) {
 		switch (code) {
 		case SYS_DOWN:
 			panel_lcd_print
@@ -2089,7 +2261,8 @@
 			    ("\x0cSystem Halted.\x1b[Lc\x1b[Lb\x1b[L+");
 			break;
 		case SYS_POWER_OFF:
-			panel_lcd_print("\x0cPower off.\x1b[Lc\x1b[Lb\x1b[L+");
+			panel_lcd_print
+			    ("\x0cPower off.\x1b[Lc\x1b[Lb\x1b[L+");
 			break;
 		default:
 			break;
@@ -2106,85 +2279,141 @@
 
 static void panel_attach(struct parport *port)
 {
+	struct pardevice *portdev;
+	int r;
+
+	/*
+	 * If this is the port we wanted, attempt to claim the port for
+	 * ourselves.
+	 */
 	if (port->number != parport)
 		return;
 
-	if (pprt) {
-		printk(KERN_ERR
-		       "panel_attach(): port->number=%d parport=%d, "
-		       "already registered !\n",
-		       port->number, parport);
+	portdev = parport_register_device(port, "panel", NULL, NULL, NULL, 0,
+					  NULL);
+	if (portdev == NULL) {
+		pr_err("Panel: Failed to register with parport%d.\n", parport);
 		return;
 	}
 
-	pprt = parport_register_device(port, "panel", NULL, NULL,  /* pf, kf */
-				       NULL,
-				       /*PARPORT_DEV_EXCL */
-				       0, (void *)&pprt);
-	if (pprt == NULL) {
-		pr_err("panel_attach(): port->number=%d parport=%d, "
-		       "parport_register_device() failed\n",
-		       port->number, parport);
+	if (parport_claim(portdev)) {
+		pr_err("Panel: Failed to claim parport%d.\n", parport);
+		parport_unregister_device(portdev);
 		return;
 	}
 
-	if (parport_claim(pprt)) {
-		printk(KERN_ERR
-		       "Panel: could not claim access to parport%d. "
-		       "Aborting.\n", parport);
-		goto err_unreg_device;
+	/*
+	 * Port successfully owned, update global state and initialize LCD if
+	 * enabled.
+	 */
+	mutex_lock(&port_mutex);
+
+	if (pprt) {
+		mutex_unlock(&port_mutex);
+		pr_err("Panel: Parport%d already registered.\n", parport);
+		parport_release(portdev);
+		parport_unregister_device(portdev);
+		return;
 	}
 
-	/* must init LCD first, just in case an IRQ from the keypad is
-	 * generated at keypad init
-	 */
-	if (lcd_enabled) {
+	pprt = portdev;
+
+	if (lcd_enabled)
 		lcd_init();
-		if (misc_register(&lcd_dev))
-			goto err_unreg_device;
-	}
 
+	mutex_unlock(&port_mutex);
+
+	pr_info("Panel: registered on parport%d (io=0x%lx).\n", parport,
+		port->base);
+
+	/*
+	 * Port and LCD initialized. After this point we keep ownership of the
+	 * port in all cases. It will only be released in detach.
+	 */
+
+	/*
+	 * Initialize keypad and timer. Start timer only if keypad is enabled
+	 * or an LCD with backlight support is enabled.
+	 *
+	 * We can do this without any locking since they only need to be
+	 * synchronized with detach, and parport makes sure that detach is not
+	 * called while we are in attach.
+	 */
 	if (keypad_enabled) {
-		keypad_init();
-		if (misc_register(&keypad_dev))
-			goto err_lcd_unreg;
+		r = keypad_init();
+		if (r < 0)
+			pr_err("Panel: error %d initializing keypad.\n", r);
 	}
-	return;
 
-err_lcd_unreg:
-	if (lcd_enabled)
-		misc_deregister(&lcd_dev);
-err_unreg_device:
-	parport_unregister_device(pprt);
-	pprt = NULL;
+	if (keypad_initialized || (lcd_enabled && (lcd_bl_pin != PIN_NONE)))
+		start_scan_timer();
+
+	/* Finally attempt to register misc devices for LCD/keypad */
+	if (lcd_enabled) {
+		r = misc_register(&lcd_dev);
+		if (r < 0)
+			pr_err("Panel: error %d registering LCD dev.\n", r);
+	}
+
+	if (keypad_initialized) {
+		r = misc_register(&keypad_dev);
+		if (r < 0)
+			pr_err("Panel: error %d registering keypad dev.\n", r);
+	}
 }
 
 static void panel_detach(struct parport *port)
 {
+	struct pardevice *portdev;
+
+	/*
+	 * Quick check for our port. Note that it is safe to access pprt
+	 * without a lock in this case since it can not change under us
+	 * (parport synchronizes multiple calls to attach/detach).
+	 */
 	if (port->number != parport)
 		return;
 
-	if (!pprt) {
-		printk(KERN_ERR
-		       "panel_detach(): port->number=%d parport=%d, "
-		       "nothing to unregister.\n",
-		       port->number, parport);
+	if (!pprt || pprt->port != port) {
+		pr_err("Panel: Nothing to unregister for parport%d.\n",
+		       parport);
 		return;
 	}
 
-	if (keypad_enabled && keypad_initialized) {
+	/* Detach is for our port. Stop timer and free keypad variables. */
+	if (timer_running)
+		stop_scan_timer();
+
+	if (keypad_initialized)
+		keypad_cleanup();
+
+	/* Unregister misc devices if registered */
+	if (!list_empty(&keypad_dev.list)) {
 		misc_deregister(&keypad_dev);
-		keypad_initialized = 0;
+		INIT_LIST_HEAD(&keypad_dev.list);
 	}
 
-	if (lcd_enabled && lcd_initialized) {
+	if (!list_empty(&lcd_dev.list)) {
 		misc_deregister(&lcd_dev);
-		lcd_initialized = 0;
+		INIT_LIST_HEAD(&lcd_dev.list);
 	}
 
-	parport_release(pprt);
-	parport_unregister_device(pprt);
+	/* Finally release the port */
+	mutex_lock(&port_mutex);
+
+	if (lcd_enabled)
+		lcd_cleanup();
+
+	portdev = pprt;
 	pprt = NULL;
+
+	mutex_unlock(&port_mutex);
+
+	parport_release(portdev);
+	parport_unregister_device(portdev);
+
+	pr_info("Panel: deregistered from parport%d (io=0x%lx).\n", parport,
+		port->base);
 }
 
 static struct parport_driver panel_driver = {
@@ -2193,8 +2422,12 @@
 	.detach = panel_detach,
 };
 
-/* init function */
-int panel_init(void)
+/*
+ * Initialize global variables from configuration. These are initialized when
+ * the module is loaded and remain constant until panel_cleanup is called when
+ * the module is unloaded.
+ */
+static void panel_init_globals(void)
 {
 	/* for backwards compatibility */
 	if (keypad_type < 0)
@@ -2269,78 +2502,62 @@
 	case KEYPAD_TYPE_NEXCOM:
 		keypad_profile = nexcom_keypad_profile;
 		break;
-	default:
-		keypad_profile = NULL;
-		break;
 	}
 
-	/* tells various subsystems about the fact that we are initializing */
-	init_in_progress = 1;
+	lcd_init_globals();
+}
 
-	if (parport_register_driver(&panel_driver)) {
-		printk(KERN_ERR
-		       "Panel: could not register with parport. Aborting.\n");
-		return -EIO;
-	}
+static int __init panel_init_module(void)
+{
+	int r;
+
+	panel_init_globals();
 
+	/* Used to check with list_empty if devices were registered */
+	INIT_LIST_HEAD(&lcd_dev.list);
+	INIT_LIST_HEAD(&keypad_dev.list);
+
+	/* We have nothing to do if neither lcd nor keypad enabled */
 	if (!lcd_enabled && !keypad_enabled) {
-		/* no device enabled, let's release the parport */
-		if (pprt) {
-			parport_release(pprt);
-			parport_unregister_device(pprt);
-			pprt = NULL;
-		}
-		parport_unregister_driver(&panel_driver);
-		printk(KERN_ERR "Panel driver version " PANEL_VERSION
-		       " disabled.\n");
+		pr_err("Panel driver version " PANEL_VERSION " disabled.\n");
 		return -ENODEV;
 	}
 
+	/*
+	 * Register with parport. From this point the code must be prepared to
+	 * handle attach/detach. parport notifies us immediately about existing
+	 * ports.
+	 */
+	r = parport_register_driver(&panel_driver);
+	if (r) {
+		pr_err("Panel: could not register with parport. Aborting.\n");
+		return r;
+	}
+
 	register_reboot_notifier(&panel_notifier);
 
-	if (pprt)
-		printk(KERN_INFO "Panel driver version " PANEL_VERSION
-		       " registered on parport%d (io=0x%lx).\n", parport,
-		       pprt->port->base);
-	else
-		printk(KERN_INFO "Panel driver version " PANEL_VERSION
-		       " not yet registered\n");
-	/* tells various subsystems about the fact that initialization
-	   is finished */
-	init_in_progress = 0;
-	return 0;
-}
+	/*
+	 * We might already have found our port (the typical case). Inform the
+	 * user if the port was not yet found. Note that it is safe to access
+	 * the port variable without the lock in this special case.
+	 */
+	pr_info("Panel driver version " PANEL_VERSION " loaded.\n");
+	if (!pprt)
+		pr_info("Waiting for parallel port to become available.\n");
 
-static int __init panel_init_module(void)
-{
-	return panel_init();
+	return 0;
 }
 
 static void __exit panel_cleanup_module(void)
 {
 	unregister_reboot_notifier(&panel_notifier);
 
-	if (scan_timer.function != NULL)
-		del_timer(&scan_timer);
-
-	if (pprt != NULL) {
-		if (keypad_enabled) {
-			misc_deregister(&keypad_dev);
-			keypad_initialized = 0;
-		}
-
-		if (lcd_enabled) {
-			panel_lcd_print("\x0cLCD driver " PANEL_VERSION
-					"\nunloaded.\x1b[Lc\x1b[Lb\x1b[L-");
-			misc_deregister(&lcd_dev);
-			lcd_initialized = 0;
-		}
-
-		/* TODO: free all input signals */
-		parport_release(pprt);
-		parport_unregister_device(pprt);
-		pprt = NULL;
-	}
+	/*
+	 * The unregister function makes sure that detach is called for all
+	 * ports, and that detach has finished running before returning here.
+	 * Therefore there is not much for us to do here since detach handles
+	 * all cleanup for the port.
+	 */
 	parport_unregister_driver(&panel_driver);
 }
 

--------------000109060009070808040106--
