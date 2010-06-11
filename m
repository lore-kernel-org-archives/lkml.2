Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204Ab0FKMWB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 08:22:01 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62335 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab0FKMV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 08:21:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=cLf3RVbCQ07e1hB5UUDHGV/KZTTSMv2lCR8L2svNye8sSEQmwuNBGbngOems4rQNdP
         gPGbebUsuOa+cbNGuKmHZReC4eeENmyOHR6iBTstUuxGmpkHw3gW6KGv3qt7vVRb2WSf
         IEDcizqwTB/TQ06i2Wlu5oD0rNljo1ksS5ykc=
From: =?UTF-8?q?Henri=20H=C3=A4kkinen?= <henuxd@gmail.com>
To: gregkh@suse.de, peterhuewe@gmx.de, julia@diku.dk, w@1wt.eu,
       sudhakar.raj@ti.com, henuxd@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging:panel: Fixed coding conventions.
Date: Fri, 11 Jun 2010 15:21:49 +0300
Message-Id: <1276258909-20838-1-git-send-email-henuxd@gmail.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed many coding convention issues as reported by checkpatch.pl tool.
Many of the cleanups were hacky due to deeply nasted control structures.
The module should be cleaned up and worked on more.

Signed-off-by: Henri Häkkinen <henuxd@gmail.com>
---
 drivers/staging/panel/panel.c |  446 ++++++++++++++++++++++++++---------------
 1 files changed, 289 insertions(+), 157 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 9ca0e9e..33f1814 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -68,11 +68,15 @@
 #define LCD_MAXBYTES		256	/* max burst write */
 
 #define KEYPAD_BUFFER		64
-#define INPUT_POLL_TIME		(HZ/50)	/* poll the keyboard this every second */
-#define KEYPAD_REP_START	(10)	/* a key starts to repeat after this times INPUT_POLL_TIME */
-#define KEYPAD_REP_DELAY	(2)	/* a key repeats this times INPUT_POLL_TIME */
+#define INPUT_POLL_TIME		(HZ/50)	/* poll the keyboard this every
+					   second */
+#define KEYPAD_REP_START	(10)	/* a key starts to repeat after
+					   this times INPUT_POLL_TIME */
+#define KEYPAD_REP_DELAY	(2)	/* a key repeats this times
+					   INPUT_POLL_TIME */
 
-#define FLASH_LIGHT_TEMPO	(200)	/* keep the light on this times INPUT_POLL_TIME for each flash */
+#define FLASH_LIGHT_TEMPO	(200)	/* keep the light on this times
+					   INPUT_POLL_TIME for each flash */
 
 /* converts an r_str() input to an active high, bits string : 000BAOSE */
 #define PNL_PINPUT(a)		((((unsigned char)(a)) ^ 0x7F) >> 3)
@@ -84,7 +88,8 @@
 #define PNL_PERRORP		0x08	/* direct input, active low */
 
 #define PNL_PBIDIR		0x20	/* bi-directional ports */
-#define PNL_PINTEN		0x10	/* high to read data in or-ed with data out */
+#define PNL_PINTEN		0x10	/* high to read data in or-ed
+					   with data out */
 #define PNL_PSELECP		0x08	/* inverted output, active low */
 #define PNL_PINITP		0x04	/* direct output, active low */
 #define PNL_PAUTOLF		0x02	/* inverted output, active low */
@@ -123,7 +128,8 @@
 #define LCD_FLAG_N		0x0040	/* 2-rows mode */
 #define LCD_FLAG_L		0x0080	/* backlight enabled */
 
-#define LCD_ESCAPE_LEN		24	/* 24 chars max for an LCD escape command */
+#define LCD_ESCAPE_LEN		24	/* 24 chars max for an LCD
+					   escape command */
 #define LCD_ESCAPE_CHAR	27	/* use char 27 for escape command */
 
 /* macros to simplify use of the parallel port */
@@ -134,8 +140,10 @@
 #define w_dtr(x, y)     do { parport_write_data((x)->port, (y)); } while (0)
 
 /* this defines which bits are to be used and which ones to be ignored */
-static __u8 scan_mask_o;	/* logical or of the output bits involved in the scan matrix */
-static __u8 scan_mask_i;	/* logical or of the input bits involved in the scan matrix */
+static __u8 scan_mask_o;	/* logical or of the output bits involved
+				   in the scan matrix */
+static __u8 scan_mask_i;	/* logical or of the input bits involved
+				   in the scan matrix */
 
 typedef __u64 pmask_t;
 
@@ -161,14 +169,17 @@ struct logical_input {
 	__u8 rise_timer, fall_timer, high_timer;
 
 	union {
-		struct {	/* this structure is valid when type == INPUT_TYPE_STD */
+		struct {	/* this structure is valid when
+				   type == INPUT_TYPE_STD */
 			void (*press_fct) (int);
 			void (*release_fct) (int);
 			int press_data;
 			int release_data;
 		} std;
-		struct {	/* this structure is valid when type == INPUT_TYPE_KBD */
-			/* strings can be full-length (ie. non null-terminated) */
+		struct {	/* this structure is valid when
+				   type == INPUT_TYPE_KBD */
+			/* strings can be full-length
+			   (ie. non null-terminated) */
 			char press_str[sizeof(void *) + sizeof(int)];
 			char repeat_str[sizeof(void *) + sizeof(int)];
 			char release_str[sizeof(void *) + sizeof(int)];
@@ -190,9 +201,11 @@ LIST_HEAD(logical_inputs);	/* list of all defined logical inputs */
  */
 static pmask_t phys_read;	/* what has just been read from the I/O ports */
 static pmask_t phys_read_prev;	/* previous phys_read */
-static pmask_t phys_curr;	/* stabilized phys_read (phys_read|phys_read_prev) */
+static pmask_t phys_curr;	/* stabilized phys_read
+				   (phys_read|phys_read_prev) */
 static pmask_t phys_prev;	/* previous phys_curr */
-static char inputs_stable;	/* 0 means that at least one logical signal needs be computed */
+static char inputs_stable;	/* 0 means that at least one logical
+				   signal needs be computed */
 
 /* these variables are specific to the keypad */
 static char keypad_buffer[KEYPAD_BUFFER];
@@ -205,7 +218,8 @@ static wait_queue_head_t keypad_read_wait;
 static unsigned long int lcd_flags;	/* contains the LCD config state */
 static unsigned long int lcd_addr_x;	/* contains the LCD X offset */
 static unsigned long int lcd_addr_y;	/* contains the LCD Y offset */
-static char lcd_escape[LCD_ESCAPE_LEN + 1];	/* current escape sequence, 0 terminated */
+static char lcd_escape[LCD_ESCAPE_LEN + 1];	/* current escape sequence,
+						   0 terminated */
 static int lcd_escape_len = -1;	/* not in escape state. >=0 = escape cmd len */
 
 /*
@@ -436,11 +450,13 @@ MODULE_PARM_DESC(keypad_enabled, "Deprecated option, use keypad_type instead");
 static int lcd_type = -1;
 module_param(lcd_type, int, 0000);
 MODULE_PARM_DESC(lcd_type,
-		 "LCD type: 0=none, 1=old //, 2=serial ks0074, 3=hantronix //, 4=nexcom //, 5=compiled-in");
+		 "LCD type: 0=none, 1=old //, 2=serial ks0074, "
+		 "3=hantronix //, 4=nexcom //, 5=compiled-in");
 
 static int lcd_proto = -1;
 module_param(lcd_proto, int, 0000);
-MODULE_PARM_DESC(lcd_proto, "LCD communication: 0=parallel (//), 1=serial,"
+MODULE_PARM_DESC(lcd_proto,
+		"LCD communication: 0=parallel (//), 1=serial,"
 		"2=TI LCD Interface");
 
 static int lcd_charset = -1;
@@ -450,12 +466,14 @@ MODULE_PARM_DESC(lcd_charset, "LCD character set: 0=standard, 1=KS0074");
 static int keypad_type = -1;
 module_param(keypad_type, int, 0000);
 MODULE_PARM_DESC(keypad_type,
-		 "Keypad type: 0=none, 1=old 6 keys, 2=new 6+1 keys, 3=nexcom 4 keys");
+		 "Keypad type: 0=none, 1=old 6 keys, 2=new 6+1 keys, "
+		 "3=nexcom 4 keys");
 
 static int profile = DEFAULT_PROFILE;
 module_param(profile, int, 0000);
 MODULE_PARM_DESC(profile,
-		 "1=16x2 old kp; 2=serial 16x2, new kp; 3=16x2 hantronix; 4=16x2 nexcom; default=40x2, old kp");
+		 "1=16x2 old kp; 2=serial 16x2, new kp; 3=16x2 hantronix; "
+		 "4=16x2 nexcom; default=40x2, old kp");
 
 /*
  * These are the parallel port pins the LCD control signals are connected to.
@@ -469,32 +487,38 @@ MODULE_PARM_DESC(profile,
 static int lcd_e_pin  = PIN_NOT_SET;
 module_param(lcd_e_pin, int, 0000);
 MODULE_PARM_DESC(lcd_e_pin,
-		 "# of the // port pin connected to LCD 'E' signal, with polarity (-17..17)");
+		 "# of the // port pin connected to LCD 'E' signal, "
+		 "with polarity (-17..17)");
 
 static int lcd_rs_pin = PIN_NOT_SET;
 module_param(lcd_rs_pin, int, 0000);
 MODULE_PARM_DESC(lcd_rs_pin,
-		 "# of the // port pin connected to LCD 'RS' signal, with polarity (-17..17)");
+		 "# of the // port pin connected to LCD 'RS' signal, "
+		 "with polarity (-17..17)");
 
 static int lcd_rw_pin = PIN_NOT_SET;
 module_param(lcd_rw_pin, int, 0000);
 MODULE_PARM_DESC(lcd_rw_pin,
-		 "# of the // port pin connected to LCD 'RW' signal, with polarity (-17..17)");
+		 "# of the // port pin connected to LCD 'RW' signal, "
+		 "with polarity (-17..17)");
 
 static int lcd_bl_pin = PIN_NOT_SET;
 module_param(lcd_bl_pin, int, 0000);
 MODULE_PARM_DESC(lcd_bl_pin,
-		 "# of the // port pin connected to LCD backlight, with polarity (-17..17)");
+		 "# of the // port pin connected to LCD backlight, "
+		 "with polarity (-17..17)");
 
 static int lcd_da_pin = PIN_NOT_SET;
 module_param(lcd_da_pin, int, 0000);
 MODULE_PARM_DESC(lcd_da_pin,
-		 "# of the // port pin connected to serial LCD 'SDA' signal, with polarity (-17..17)");
+		 "# of the // port pin connected to serial LCD 'SDA' "
+		 "signal, with polarity (-17..17)");
 
 static int lcd_cl_pin = PIN_NOT_SET;
 module_param(lcd_cl_pin, int, 0000);
 MODULE_PARM_DESC(lcd_cl_pin,
-		 "# of the // port pin connected to serial LCD 'SCL' signal, with polarity (-17..17)");
+		 "# of the // port pin connected to serial LCD 'SCL' "
+		 "signal, with polarity (-17..17)");
 
 static unsigned char *lcd_char_conv;
 
@@ -572,7 +596,8 @@ static char (*keypad_profile)[4][9] = old_keypad_profile;
 
 /* FIXME: this should be converted to a bit array containing signals states */
 static struct {
-	unsigned char e;	/* parallel LCD E   (data latch on falling edge) */
+	unsigned char e;	/* parallel LCD E
+				   (data latch on falling edge) */
 	unsigned char rs;	/* parallel LCD RS  (0 = cmd, 1 = data) */
 	unsigned char rw;	/* parallel LCD R/W (0 = W, 1 = R) */
 	unsigned char bl;	/* parallel LCD backlight (0 = off, 1 = on) */
@@ -698,7 +723,8 @@ static void long_sleep(int ms)
 	}
 }
 
-/* send a serial byte to the LCD panel. The caller is responsible for locking if needed. */
+/* send a serial byte to the LCD panel. The caller is responsible for locking
+   if needed. */
 static void lcd_send_serial(int byte)
 {
 	int bit;
@@ -711,7 +737,8 @@ static void lcd_send_serial(int byte)
 		panel_set_bits();
 		bits.da = byte & 1;
 		panel_set_bits();
-		udelay(2);	/* maintain the data during 2 us before CLK up */
+		udelay(2);	/* maintain the data during 2 us
+				   before CLK up */
 		bits.cl = BIT_SET;	/* CLK high */
 		panel_set_bits();
 		udelay(1);	/* maintain the strobe during 1 us */
@@ -760,7 +787,8 @@ static void lcd_write_cmd_p8(int cmd)
 	spin_lock(&pprt_lock);
 	/* present the data to the data port */
 	w_dtr(pprt, cmd);
-	udelay(20);		/* maintain the data during 20 us before the strobe */
+	udelay(20);		/* maintain the data during 20 us
+				   before the strobe */
 
 	bits.e = BIT_SET;
 	bits.rs = BIT_CLR;
@@ -782,7 +810,8 @@ static void lcd_write_data_p8(int data)
 	spin_lock(&pprt_lock);
 	/* present the data to the data port */
 	w_dtr(pprt, data);
-	udelay(20);		/* maintain the data during 20 us before the strobe */
+	udelay(20);		/* maintain the data during 20 us
+				   before the strobe */
 
 	bits.e = BIT_SET;
 	bits.rs = BIT_SET;
@@ -822,7 +851,8 @@ static void lcd_gotoxy(void)
 {
 	lcd_write_cmd(0x80	/* set DDRAM address */
 		      | (lcd_addr_y ? lcd_hwidth : 0)
-		      /* we force the cursor to stay at the end of the line if it wants to go farther */
+		      /* we force the cursor to stay at the end of the
+			 line if it wants to go farther */
 		      | ((lcd_addr_x < lcd_bwidth) ? lcd_addr_x &
 			 (lcd_hwidth - 1) : lcd_bwidth - 1));
 }
@@ -871,7 +901,8 @@ static void lcd_clear_fast_p8(void)
 	for (pos = 0; pos < lcd_height * lcd_hwidth; pos++) {
 		/* present the data to the data port */
 		w_dtr(pprt, ' ');
-		udelay(20);	/* maintain the data during 20 us before the strobe */
+		udelay(20);	/* maintain the data during 20 us
+				   before the strobe */
 
 		bits.e = BIT_SET;
 		bits.rs = BIT_SET;
@@ -954,7 +985,8 @@ static void lcd_init_display(void)
 
 	long_sleep(10);
 
-	lcd_write_cmd(0x06);	/* entry mode set : increment, cursor shifting */
+	lcd_write_cmd(0x06);	/* entry mode set : increment,
+				   cursor shifting */
 
 	lcd_clear_display();
 }
@@ -975,53 +1007,67 @@ static ssize_t lcd_write(struct file *file,
 
 	for (; count-- > 0; (ppos ? (*ppos)++ : 0), ++tmp) {
 		if (!in_interrupt() && (((count + 1) & 0x1f) == 0))
-			schedule();	/* let's be a little nice with other processes that need some CPU */
+			schedule();	/* let's be a little nice with
+					   other processes that need some CPU */
 
 		if (ppos == NULL && file == NULL)
-			c = *tmp;	/* let's not use get_user() from the kernel ! */
+			c = *tmp;	/* let's not use get_user() from
+					   the kernel ! */
 		else if (get_user(c, tmp))
 			return -EFAULT;
 
 		/* first, we'll test if we're in escape mode */
-		if ((c != '\n') && lcd_escape_len >= 0) {	/* yes, let's add this char to the buffer */
+		if ((c != '\n') && lcd_escape_len >= 0) {
+			/* yes, let's add this char to the buffer */
 			lcd_escape[lcd_escape_len++] = c;
 			lcd_escape[lcd_escape_len] = 0;
 		} else {
-			lcd_escape_len = -1;	/* aborts any previous escape sequence */
+			lcd_escape_len = -1;	/* aborts any previous escape
+						   sequence */
 
 			switch (c) {
-			case LCD_ESCAPE_CHAR:	/* start of an escape sequence */
+			case LCD_ESCAPE_CHAR:
+				/* start of an escape sequence */
 				lcd_escape_len = 0;
 				lcd_escape[lcd_escape_len] = 0;
 				break;
 			case '\b':	/* go back one char and clear it */
 				if (lcd_addr_x > 0) {
-					if (lcd_addr_x < lcd_bwidth)	/* check if we're not at the end of the line */
-						lcd_write_cmd(0x10);	/* back one char */
+					if (lcd_addr_x < lcd_bwidth)
+						/* check if we're not at the
+						   end of the line */
+						lcd_write_cmd(0x10); /* back one
+									char */
 					lcd_addr_x--;
 				}
-				lcd_write_data(' ');	/* replace with a space */
-				lcd_write_cmd(0x10);	/* back one char again */
+				lcd_write_data(' ');	/* replace with
+							   a space */
+				lcd_write_cmd(0x10);	/* back one char
+							   again */
 				break;
 			case '\014':	/* quickly clear the display */
 				lcd_clear_fast();
 				break;
-			case '\n':	/* flush the remainder of the current line and go to the
-					   beginning of the next line */
+			case '\n':
+				/* flush the remainder of the current line and
+				   go to the beginning of the next line */
 				for (; lcd_addr_x < lcd_bwidth; lcd_addr_x++)
 					lcd_write_data(' ');
 				lcd_addr_x = 0;
 				lcd_addr_y = (lcd_addr_y + 1) % lcd_height;
 				lcd_gotoxy();
 				break;
-			case '\r':	/* go to the beginning of the same line */
+			case '\r':
+				/* go to the beginning of the same line */
 				lcd_addr_x = 0;
 				lcd_gotoxy();
 				break;
-			case '\t':	/* print a space instead of the tab */
+			case '\t':
+				/* print a space instead of the tab */
 				lcd_print(' ');
 				break;
-			default:	/* simply print this char */
+			default:
+				/* simply print this char */
 				lcd_print(c);
 				break;
 			}
@@ -1030,20 +1076,26 @@ static ssize_t lcd_write(struct file *file,
 		/* now we'll see if we're in an escape mode and if the current
 		   escape sequence can be understood.
 		 */
-		if (lcd_escape_len >= 2) {	/* minimal length for an escape command */
-			int processed = 0;	/* 1 means the command has been processed */
+		if (lcd_escape_len >= 2) {	/* minimal length for an
+						   escape command */
+			int processed = 0;	/* 1 means the command has
+						   been processed */
 
-			if (!strcmp(lcd_escape, "[2J")) {	/* Clear the display */
-				lcd_clear_fast();	/* clear display */
+			if (!strcmp(lcd_escape, "[2J")) {
+				/* Clear the display */
+				lcd_clear_fast();
 				processed = 1;
-			} else if (!strcmp(lcd_escape, "[H")) {	/* Cursor to home */
+			} else if (!strcmp(lcd_escape, "[H")) {
+				/* Cursor to home */
 				lcd_addr_x = lcd_addr_y = 0;
 				lcd_gotoxy();
 				processed = 1;
 			}
 			/* codes starting with ^[[L */
 			else if ((lcd_escape_len >= 3) &&
-				 (lcd_escape[0] == '[') && (lcd_escape[1] == 'L')) {	/* LCD special codes */
+				 (lcd_escape[0] == '[') &&
+				 (lcd_escape[1] == 'L')) {
+				/* LCD special codes */
 
 				char *esc = lcd_escape + 2;
 				int oldflags = lcd_flags;
@@ -1082,7 +1134,9 @@ static ssize_t lcd_write(struct file *file,
 					lcd_flags &= ~LCD_FLAG_L;
 					processed = 1;
 					break;
-				case '*':	/* flash back light using the keypad timer */
+				case '*':
+					/* flash back light using the keypad
+					   timer */
 					if (scan_timer.function != NULL) {
 						if (light_tempo == 0
 						    && ((lcd_flags & LCD_FLAG_L)
@@ -1111,7 +1165,9 @@ static ssize_t lcd_write(struct file *file,
 				case 'l':	/* Shift Cursor Left */
 					if (lcd_addr_x > 0) {
 						if (lcd_addr_x < lcd_bwidth)
-							lcd_write_cmd(0x10);	/* back one char if not at end of line */
+							/* back one char if
+							   not at end of line */
+							lcd_write_cmd(0x10);
 						lcd_addr_x--;
 					}
 					processed = 1;
@@ -1119,8 +1175,12 @@ static ssize_t lcd_write(struct file *file,
 
 				case 'r':	/* shift cursor right */
 					if (lcd_addr_x < lcd_width) {
-						if (lcd_addr_x < (lcd_bwidth - 1))
-							lcd_write_cmd(0x14);	/* allow the cursor to pass the end of the line */
+						if (lcd_addr_x <
+						    (lcd_bwidth - 1))
+							/* allow the cursor to
+							   pass the end of the
+							   line */
+							lcd_write_cmd(0x14);
 						lcd_addr_x++;
 					}
 					processed = 1;
@@ -1140,9 +1200,12 @@ static ssize_t lcd_write(struct file *file,
 
 				case 'k':{	/* kill end of line */
 						int x;
-						for (x = lcd_addr_x; x < lcd_bwidth; x++)
+						for (x = lcd_addr_x;
+						     x < lcd_bwidth; x++)
 							lcd_write_data(' ');
-						lcd_gotoxy();	/* restore cursor position */
+
+						/* restore cursor position */
+						lcd_gotoxy();
 						processed = 1;
 						break;
 					}
@@ -1152,12 +1215,19 @@ static ssize_t lcd_write(struct file *file,
 					processed = 1;
 					break;
 
-				case 'G':	/* Generator : LGcxxxxx...xx; */  {
-						/* must have <c> between '0' and '7', representing the numerical
-						 * ASCII code of the redefined character, and <xx...xx> a sequence
-						 * of 16 hex digits representing 8 bytes for each character. Most
-						 * LCDs will only use 5 lower bits of the 7 first bytes.
-						 */
+				case 'G':
+					{
+						/* Generator : LGcxxxxx...xx;
+						 * must have <c> between '0'
+						 * and '7', representing the
+						 * numerical ASCII code of the
+						 * redefined character, and
+						 * <xx...xx> a sequence of 16
+						 * hex digits representing 8
+						 * bytes for each character.
+						 * Most LCDs will only use 5
+						 * lower bits of the 7 first
+						 * bytes. */
 
 						unsigned char cgbytes[8];
 						unsigned char cgaddr;
@@ -1182,12 +1252,21 @@ static ssize_t lcd_write(struct file *file,
 						value = 0;
 						while (*esc && cgoffset < 8) {
 							shift ^= 4;
-							if (*esc >= '0' && *esc <= '9')
-								value |= (*esc - '0') << shift;
-							else if (*esc >= 'A' && *esc <= 'Z')
-								value |= (*esc - 'A' + 10) << shift;
-							else if (*esc >= 'a' && *esc <= 'z')
-								value |= (*esc - 'a' + 10) << shift;
+							if (*esc >= '0' &&
+							    *esc <= '9')
+								value |=
+								  (*esc - '0')
+								  << shift;
+							else if (*esc >= 'A' &&
+								 *esc <= 'Z')
+								value |=
+								  (*esc - 'A' +
+								   10) << shift;
+							else if (*esc >= 'a' &&
+								 *esc <= 'z')
+								value |=
+								  (*esc - 'a' +
+								   10) << shift;
 							else {
 								esc++;
 								continue;
@@ -1201,11 +1280,15 @@ static ssize_t lcd_write(struct file *file,
 							esc++;
 						}
 
-						lcd_write_cmd(0x40 | (cgaddr * 8));
-						for (addr = 0; addr < cgoffset; addr++)
+						lcd_write_cmd(0x40 |
+							(cgaddr * 8));
+						for (addr = 0; addr < cgoffset;
+						     addr++)
 							lcd_write_data(cgbytes[addr]);
 
-						lcd_gotoxy();	/* ensures that we stop writing to CGRAM */
+						/* ensures that we stop
+						   writing to CGRAM */
+						lcd_gotoxy();
 						processed = 1;
 						break;
 					}
@@ -1246,34 +1329,45 @@ static ssize_t lcd_write(struct file *file,
 
 				/* Check wether one flag was changed */
 				if (oldflags != lcd_flags) {
-					/* check wether one of B,C,D flags was changed */
+					/* check wether one of B,C,D flags was
+					   changed */
 					if ((oldflags ^ lcd_flags) &
-					    (LCD_FLAG_B | LCD_FLAG_C | LCD_FLAG_D))
+					    (LCD_FLAG_B | LCD_FLAG_C |
+					     LCD_FLAG_D))
 						/* set display mode */
 						lcd_write_cmd(0x08 |
-							      ((lcd_flags & LCD_FLAG_D) ? 4 : 0) |
-							      ((lcd_flags & LCD_FLAG_C) ? 2 : 0) |
-							      ((lcd_flags & LCD_FLAG_B) ? 1 : 0));
-					/* check wether one of F,N flags was changed */
+							((lcd_flags &
+							LCD_FLAG_D) ? 4 : 0) |
+							((lcd_flags &
+							LCD_FLAG_C) ? 2 : 0) |
+							((lcd_flags &
+							LCD_FLAG_B) ? 1 : 0));
+					/* check wether one of F,N flags
+					   was changed */
 					else if ((oldflags ^ lcd_flags) &
 						 (LCD_FLAG_F | LCD_FLAG_N))
 						lcd_write_cmd(0x30 |
-							      ((lcd_flags & LCD_FLAG_F) ? 4 : 0) |
-							      ((lcd_flags & LCD_FLAG_N) ? 8 : 0));
+							((lcd_flags &
+							LCD_FLAG_F) ? 4 : 0) |
+							((lcd_flags &
+							LCD_FLAG_N) ? 8 : 0));
 					/* check wether L flag was changed */
 					else if ((oldflags ^ lcd_flags) &
 						 (LCD_FLAG_L)) {
 						if (lcd_flags & (LCD_FLAG_L))
 							lcd_backlight(1);
-						else if (light_tempo == 0)	/* switch off the light only when the tempo lighting is gone */
+						else if (light_tempo == 0)
+							/* switch off the light
+							   only when the tempo
+							   lighting is gone */
 							lcd_backlight(0);
 					}
 				}
 			}
 
 			/* LCD special escape codes */
-			/* flush the escape sequence if it's been processed or if it is
-			   getting too long. */
+			/* flush the escape sequence if it's been processed
+			   or if it is getting too long. */
 			if (processed || (lcd_escape_len >= LCD_ESCAPE_LEN))
 				lcd_escape_len = -1;
 		}		/* escape codes */
@@ -1304,7 +1398,7 @@ static int lcd_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static struct file_operations lcd_fops = {
+static const struct file_operations lcd_fops = {
 	.write   = lcd_write,
 	.open    = lcd_open,
 	.release = lcd_release,
@@ -1395,7 +1489,8 @@ void lcd_init(void)
 			lcd_charset = DEFAULT_LCD_CHARSET;
 		/* default geometry will be set later */
 		break;
-	case LCD_TYPE_HANTRONIX:	/* parallel mode, 8 bits, hantronix-like */
+	case LCD_TYPE_HANTRONIX:	/* parallel mode, 8 bits,
+					   hantronix-like */
 	default:
 		if (lcd_proto < 0)
 			lcd_proto = LCD_PROTO_PARALLEL;
@@ -1511,7 +1606,8 @@ void lcd_init(void)
 			PANEL_VERSION);
 #endif
 	lcd_addr_x = lcd_addr_y = 0;
-	lcd_must_clear = 1;	/* clear the display on the next device opening */
+	lcd_must_clear = 1;	/* clear the display on the next
+				   device opening */
 	lcd_gotoxy();
 }
 
@@ -1535,7 +1631,8 @@ static ssize_t keypad_read(struct file *file,
 			return -EINTR;
 	}
 
-	for (; count-- > 0 && (keypad_buflen > 0); ++i, ++tmp, --keypad_buflen) {
+	for (; count-- > 0 && (keypad_buflen > 0);
+	     ++i, ++tmp, --keypad_buflen) {
 		put_user(keypad_buffer[keypad_start], tmp);
 		keypad_start = (keypad_start + 1) % KEYPAD_BUFFER;
 	}
@@ -1564,7 +1661,7 @@ static int keypad_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static struct file_operations keypad_fops = {
+static const struct file_operations keypad_fops = {
 	.read    = keypad_read,		/* read */
 	.open    = keypad_open,		/* open */
 	.release = keypad_release,	/* close */
@@ -1591,14 +1688,15 @@ static void keypad_send_key(char *string, int max_len)
 	}
 }
 
-/* this function scans all the bits involving at least one logical signal, and puts the
- * results in the bitfield "phys_read" (one bit per established contact), and sets
- * "phys_read_prev" to "phys_read".
+/* this function scans all the bits involving at least one logical signal,
+ * and puts the results in the bitfield "phys_read" (one bit per established
+ * contact), and sets "phys_read_prev" to "phys_read".
  *
- * Note: to debounce input signals, we will only consider as switched a signal which is
- * stable across 2 measures. Signals which are different between two reads will be kept
- * as they previously were in their logical form (phys_prev). A signal which has just
- * switched will have a 1 in (phys_read ^ phys_read_prev).
+ * Note: to debounce input signals, we will only consider as switched a signal
+ * which is stable across 2 measures. Signals which are different between two
+ * reads will be kept as they previously were in their logical form (phys_prev).
+ * A signal which has just switched will have a 1 in
+ * (phys_read ^ phys_read_prev).
  */
 static void phys_scan_contacts(void)
 {
@@ -1611,21 +1709,28 @@ static void phys_scan_contacts(void)
 	phys_read_prev = phys_read;
 	phys_read = 0;		/* flush all signals */
 
-	oldval = r_dtr(pprt) | scan_mask_o;	/* keep track of old value, with all outputs disabled */
-	w_dtr(pprt, oldval & ~scan_mask_o);	/* activate all keyboard outputs (active low) */
-	bitmask = PNL_PINPUT(r_str(pprt)) & scan_mask_i;	/* will have a 1 for each bit set to gnd */
+	oldval = r_dtr(pprt) | scan_mask_o;	/* keep track of old value,
+						   with all outputs disabled */
+	w_dtr(pprt, oldval & ~scan_mask_o);	/* activate all keyboard
+						   outputs (active low) */
+	bitmask = PNL_PINPUT(r_str(pprt)) & scan_mask_i; /* will have a 1 for
+							    each bit set to
+							    gnd */
 	w_dtr(pprt, oldval);	/* disable all matrix signals */
 
 	/* now that all outputs are cleared, the only active input bits are
 	 * directly connected to the ground
 	 */
-	gndmask = PNL_PINPUT(r_str(pprt)) & scan_mask_i;	/* 1 for each grounded input */
+	gndmask = PNL_PINPUT(r_str(pprt)) & scan_mask_i; /* 1 for each
+							    grounded input */
 
-	phys_read |= (pmask_t) gndmask << 40;	/* grounded inputs are signals 40-44 */
+	phys_read |= (pmask_t) gndmask << 40;	/* grounded inputs are
+						   signals 40-44 */
 
 	if (bitmask != gndmask) {
-		/* since clearing the outputs changed some inputs, we know that some
-		 * input signals are currently tied to some outputs. So we'll scan them.
+		/* since clearing the outputs changed some inputs, we know
+		 * that some input signals are currently tied to some outputs.
+		 * So we'll scan them.
 		 */
 		for (bit = 0; bit < 8; bit++) {
 			bitval = 1 << bit;
@@ -1639,7 +1744,8 @@ static void phys_scan_contacts(void)
 		}
 		w_dtr(pprt, oldval);	/* disable all outputs */
 	}
-	/* this is easy: use old bits when they are flapping, use new ones when stable */
+	/* this is easy: use old bits when they are flapping,
+	 * use new ones when stable */
 	phys_curr =
 	    (phys_prev & (phys_read ^ phys_read_prev)) | (phys_read &
 							  ~(phys_read ^
@@ -1666,10 +1772,12 @@ static void panel_process_inputs(void)
 		case INPUT_ST_LOW:
 			if ((phys_curr & input->mask) != input->value)
 				break;
-			/* if all needed ones were already set previously, this means that
-			 * this logical signal has been activated by the releasing of
-			 * another combined signal, so we don't want to match.
-			 * eg: AB -(release B)-> A -(release A)-> 0 : don't match A.
+			/* if all needed ones were already set previously,
+			 * this means that this logical signal has been
+			 * activated by the releasing of another combined
+			 * signal, so we don't want to match.
+			 * eg: AB -(release B)-> A -(release A)-> 0 :
+			 *     don't match A.
 			 */
 			if ((phys_prev & input->mask) == input->value)
 				break;
@@ -1692,22 +1800,26 @@ static void panel_process_inputs(void)
 		case INPUT_ST_HIGH:
 #if 0
 			/* FIXME:
-			 * this is an invalid test. It tries to catch transitions from single-key
-			 * to multiple-key, but doesn't take into account the contacts polarity.
-			 * The only solution to the problem is to parse keys from the most complex
-			 * to the simplest combinations, and mark them as 'caught' once a combination
+			 * this is an invalid test. It tries to catch
+			 * transitions from single-key to multiple-key, but
+			 * doesn't take into account the contacts polarity.
+			 * The only solution to the problem is to parse keys
+			 * from the most complex to the simplest combinations,
+			 * and mark them as 'caught' once a combination
 			 * matches, then unmatch it for all other ones.
 			 */
 
 			/* try to catch dangerous transitions cases :
 			 * someone adds a bit, so this signal was a false
-			 * positive resulting from a transition. We should invalidate
-			 * the signal immediately and not call the release function.
-			 * eg: 0 -(press A)-> A -(press B)-> AB : don't match A's release.
+			 * positive resulting from a transition. We should
+			 * invalidate the signal immediately and not call the
+			 * release function.
+			 * eg: 0 -(press A)-> A -(press B)-> AB :
+			 *     don't match A's release.
 			 */
 			if (((phys_prev & input->mask) == input->value)
 			    && ((phys_curr & input->mask) > input->value)) {
-				input->state = INPUT_ST_LOW;	/* invalidate */
+				input->state = INPUT_ST_LOW; /* invalidate */
 				break;
 			}
 #endif
@@ -1717,21 +1829,20 @@ static void panel_process_inputs(void)
 				    && (input->high_timer == 0)) {
 					input->high_timer++;
 					if (input->u.std.press_fct != NULL)
-						input->u.std.press_fct(input->u.
-								       std.
-								       press_data);
+						input->u.std.
+							press_fct(input->u.std.
+								  press_data);
 				} else if (input->type == INPUT_TYPE_KBD) {
-					keypressed = 1;	/* will turn on the light */
+					/* will turn on the light */
+					keypressed = 1;
 
 					if (input->high_timer == 0) {
 						if (input->u.kbd.press_str[0])
 							keypad_send_key(input->
-									u.kbd.
-									press_str,
-									sizeof
-									(input->
-									 u.kbd.
-									 press_str));
+								u.kbd.press_str,
+								sizeof(input->
+								u.kbd.
+								press_str));
 					}
 
 					if (input->u.kbd.repeat_str[0]) {
@@ -1740,14 +1851,13 @@ static void panel_process_inputs(void)
 							input->high_timer -=
 							    KEYPAD_REP_DELAY;
 							keypad_send_key(input->
-									u.kbd.
-									repeat_str,
-									sizeof
-									(input->
-									 u.kbd.
-									 repeat_str));
+							   u.kbd.repeat_str,
+							   sizeof(input->u.kbd.
+							   repeat_str));
 						}
-						inputs_stable = 0;	/* we will need to come back here soon */
+						/* we will need to come back
+						   here soon */
+						inputs_stable = 0;
 					}
 
 					if (input->high_timer < 255)
@@ -1755,7 +1865,8 @@ static void panel_process_inputs(void)
 				}
 				break;
 			} else {
-				/* else signal falling down. Let's fall through. */
+				/* else signal falling down.
+				   Let's fall through. */
 				input->state = INPUT_ST_FALLING;
 				input->fall_timer = 0;
 			}
@@ -1772,14 +1883,22 @@ static void panel_process_inputs(void)
 
 			if ((phys_curr & input->mask) == input->value) {
 				if (input->type == INPUT_TYPE_KBD) {
-					keypressed = 1;	/* will turn on the light */
+					/* will turn on the light */
+					keypressed = 1;
 
 					if (input->u.kbd.repeat_str[0]) {
-						if (input->high_timer >= KEYPAD_REP_START)
-							input->high_timer -= KEYPAD_REP_DELAY;
-						keypad_send_key(input->u.kbd.repeat_str,
-								sizeof(input->u.kbd.repeat_str));
-						inputs_stable = 0;	/* we will need to come back here soon */
+						if (input->high_timer >=
+						    KEYPAD_REP_START)
+							input->high_timer -=
+							KEYPAD_REP_DELAY;
+						keypad_send_key(input->u.kbd.
+								repeat_str,
+								sizeof(input->
+								u.kbd.
+								repeat_str));
+						/* we will need to come back
+						   here soon */
+						inputs_stable = 0;
 					}
 
 					if (input->high_timer < 255)
@@ -1791,12 +1910,16 @@ static void panel_process_inputs(void)
 				/* call release event */
 				if (input->type == INPUT_TYPE_STD) {
 					if (input->u.std.release_fct != NULL)
-						input->u.std.release_fct(input->u.std.release_data);
+						input->u.std.
+							release_fct(input->u.
+							std.release_data);
 
 				} else if (input->type == INPUT_TYPE_KBD) {
 					if (input->u.kbd.release_str[0])
-						keypad_send_key(input->u.kbd.release_str,
-								sizeof(input->u.kbd.release_str));
+						keypad_send_key(input->u.kbd.
+							release_str,
+							sizeof(input->u.kbd.
+								release_str));
 				}
 
 				input->state = INPUT_ST_LOW;
@@ -1815,7 +1938,8 @@ static void panel_scan_timer(void)
 	if (keypad_enabled && keypad_initialized) {
 		if (spin_trylock(&pprt_lock)) {
 			phys_scan_contacts();
-			spin_unlock(&pprt_lock);	/* no need for the parport anymore */
+			spin_unlock(&pprt_lock);	/* no need for the
+							   parport anymore */
 		}
 
 		if (!inputs_stable || phys_curr != phys_prev)
@@ -1850,8 +1974,8 @@ static void init_scan_timer(void)
 }
 
 /* converts a name of the form "({BbAaPpSsEe}{01234567-})*" to a series of bits.
- * if <omask> or <imask> are non-null, they will be or'ed with the bits corresponding
- * to out and in bits respectively.
+ * if <omask> or <imask> are non-null, they will be or'ed with the bits
+ * corresponding to out and in bits respectively.
  * returns 1 if ok, 0 if error (in which case, nothing is written).
  */
 static int input_name2mask(char *name, pmask_t *mask, pmask_t *value,
@@ -1864,7 +1988,8 @@ static int input_name2mask(char *name, pmask_t *mask, pmask_t *value,
 	om = im = m = v = 0ULL;
 	while (*name) {
 		int in, out, bit, neg;
-		for (in = 0; (in < sizeof(sigtab)) && (sigtab[in] != *name); in++)
+		for (in = 0; (in < sizeof(sigtab)) &&
+			     (sigtab[in] != *name); in++)
 			;
 		if (in >= sizeof(sigtab))
 			return 0;	/* input name not found */
@@ -1936,7 +2061,8 @@ static struct logical_input *panel_bind_key(char *name, char *press,
 /* tries to bind a callback function to the signal name <name>. The function
  * <press_fct> will be called with the <press_data> arg when the signal is
  * activated, and so on for <release_fct>/<release_data>
- * Returns the pointer to the new signal if ok, NULL if the signal could not be bound.
+ * Returns the pointer to the new signal if ok, NULL if the signal could not
+ * be bound.
  */
 static struct logical_input *panel_bind_callback(char *name,
 						 void (*press_fct) (int),
@@ -2028,24 +2154,26 @@ static void panel_attach(struct parport *port)
 
 	if (pprt) {
 		printk(KERN_ERR
-		       "panel_attach(): port->number=%d parport=%d, already registered !\n",
+		       "panel_attach(): port->number=%d parport=%d, "
+		       "already registered !\n",
 		       port->number, parport);
 		return;
 	}
 
-	pprt = parport_register_device(port, "panel", NULL, NULL,	/* pf, kf */
+	pprt = parport_register_device(port, "panel", NULL, NULL,  /* pf, kf */
 				       NULL,
 				       /*PARPORT_DEV_EXCL */
 				       0, (void *)&pprt);
 
 	if (parport_claim(pprt)) {
 		printk(KERN_ERR
-		       "Panel: could not claim access to parport%d. Aborting.\n",
-		       parport);
+		       "Panel: could not claim access to parport%d. "
+		       "Aborting.\n", parport);
 		return;
 	}
 
-	/* must init LCD first, just in case an IRQ from the keypad is generated at keypad init */
+	/* must init LCD first, just in case an IRQ from the keypad is
+	   generated at keypad init */
 	if (lcd_enabled) {
 		lcd_init();
 		misc_register(&lcd_dev);
@@ -2064,7 +2192,8 @@ static void panel_detach(struct parport *port)
 
 	if (!pprt) {
 		printk(KERN_ERR
-		       "panel_detach(): port->number=%d parport=%d, nothing to unregister.\n",
+		       "panel_detach(): port->number=%d parport=%d, "
+		       "nothing to unregister.\n",
 		       port->number, parport);
 		return;
 	}
@@ -2127,13 +2256,15 @@ int panel_init(void)
 		if (lcd_type < 0)
 			lcd_type = LCD_TYPE_KS0074;
 		break;
-	case PANEL_PROFILE_HANTRONIX:	/* 8 bits, 2*16 hantronix-like, no keypad */
+	case PANEL_PROFILE_HANTRONIX:	/* 8 bits, 2*16 hantronix-like,
+					   no keypad */
 		if (keypad_type < 0)
 			keypad_type = KEYPAD_TYPE_NONE;
 		if (lcd_type < 0)
 			lcd_type = LCD_TYPE_HANTRONIX;
 		break;
-	case PANEL_PROFILE_NEXCOM:	/* generic 8 bits, 2*16, nexcom keypad, eg. Nexcom. */
+	case PANEL_PROFILE_NEXCOM:	/* generic 8 bits, 2*16, nexcom keypad,
+					   eg. Nexcom. */
 		if (keypad_type < 0)
 			keypad_type = KEYPAD_TYPE_NEXCOM;
 		if (lcd_type < 0)
@@ -2195,7 +2326,8 @@ int panel_init(void)
 	else
 		printk(KERN_INFO "Panel driver version " PANEL_VERSION
 		       " not yet registered\n");
-	/* tells various subsystems about the fact that initialization is finished */
+	/* tells various subsystems about the fact that initialization
+	   is finished */
 	init_in_progress = 0;
 	return 0;
 }
-- 
1.5.6.5

