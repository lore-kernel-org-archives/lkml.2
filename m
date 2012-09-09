Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab2IIIYA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 04:24:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:45248 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab2IIIXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 04:23:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,394,1344236400"; 
   d="scan'208";a="219912929"
Date: Sun, 9 Sep 2012 16:23:46 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Toshiaki Yamane <yamanetoshi@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Peter =?utf-8?B?SMO8d2U=?= <PeterHuewe@gmx.de>,
        Willy Tarreau <w@1wt.eu>, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Staging: panel: fix spinlock trylock failure on UP
Message-ID: <20120909082346.GA13582@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use spin_lock_irq() to quiet warning: 

         [    8.232324] BUG: spinlock trylock failure on UP on CPU#0, reboot/85
         [    8.234138]  lock: c161c760, .magic: dead4ead, .owner: reboot/85, .owner_cpu: 0
         [    8.236132] Pid: 85, comm: reboot Not tainted 3.4.0-rc7-00656-g82163ed #5
         [    8.237965] Call Trace:
         [    8.238648]  [<c13dfd20>] ? printk+0x18/0x1a
         [    8.239827]  [<c122a5e0>] spin_dump+0x80/0xd0
         [    8.241016]  [<c122a652>] spin_bug+0x22/0x30
         [    8.242181]  [<c122a93b>] do_raw_spin_trylock+0x5b/0x70
         [    8.243611]  [<c13e8bae>] _raw_spin_trylock+0xe/0x60
         [    8.244975]  [<c1392230>] ? keypad_send_key.constprop.9+0xe0/0xe0
 ==>     [    8.246638]  [<c13922ea>] panel_scan_timer+0xba/0x570
         [    8.248019]  [<c1392230>] ? keypad_send_key.constprop.9+0xe0/0xe0
         [    8.249689]  [<c102f6f5>] run_timer_softirq+0x1e5/0x370
         [    8.251191]  [<c102f645>] ? run_timer_softirq+0x135/0x370
         [    8.252718]  [<c1392230>] ? keypad_send_key.constprop.9+0xe0/0xe0
         [    8.254462]  [<c102a592>] __do_softirq+0xc2/0x1c0
         [    8.255758]  [<c102a4d0>] ? local_bh_enable_ip+0x130/0x130
         [    8.257228]  <IRQ>  [<c102a855>] ? irq_exit+0x65/0x70
         [    8.258647]  [<c1013ff9>] ? smp_apic_timer_interrupt+0x49/0x80
         [    8.260226]  [<c13e96c1>] ? apic_timer_interrupt+0x31/0x38
         [    8.261737]  [<c12700e0>] ? drm_vm_open_locked+0x70/0xb0
         [    8.263166]  [<c122489a>] ? delay_tsc+0x1a/0x30
         [    8.264452]  [<c12248c9>] ? __delay+0x9/0x10
         [    8.265621]  [<c12248ec>] ? __const_udelay+0x1c/0x20
 ==>     [    8.266967]  [<c139136c>] ? lcd_clear_fast_p8+0x9c/0xe0
         [    8.268386]  [<c1391a66>] ? lcd_write+0x226/0x810
         [    8.269653]  [<c1367900>] ? md_set_readonly+0xc0/0xc0
         [    8.271013]  [<c122a9ed>] ? do_raw_spin_unlock+0x9d/0xe0
         [    8.272470]  [<c1392a98>] ? panel_lcd_print+0x38/0x40
         [    8.273837]  [<c1392ace>] ? panel_notify_sys+0x2e/0x60
         [    8.275224]  [<c1046634>] ? notifier_call_chain+0x84/0xb0
         [    8.276754]  [<c10469ce>] ? __blocking_notifier_call_chain+0x3e/0x60
         [    8.278576]  [<c1046a0a>] ? blocking_notifier_call_chain+0x1a/0x20
         [    8.280267]  [<c1036a14>] ? kernel_restart_prepare+0x14/0x40
         [    8.281901]  [<c1036a8e>] ? kernel_restart+0xe/0x50
         [    8.283216]  [<c1036ce9>] ? sys_reboot+0x149/0x1e0
         [    8.284532]  [<c10b3fb3>] ? handle_pte_fault+0x93/0xd70
         [    8.285956]  [<c1019e35>] ? do_page_fault+0x215/0x5e0
         [    8.287330]  [<c101a113>] ? do_page_fault+0x4f3/0x5e0
         [    8.288704]  [<c1045ac6>] ? up_read+0x16/0x30
         [    8.289890]  [<c101a113>] ? do_page_fault+0x4f3/0x5e0
         [    8.291252]  [<c10d4486>] ? iterate_supers+0x86/0xd0
         [    8.292615]  [<c122a9ed>] ? do_raw_spin_unlock+0x9d/0xe0
         [    8.294049]  [<c13e8dcd>] ? _raw_spin_unlock+0x1d/0x20
         [    8.295449]  [<c10d44ab>] ? iterate_supers+0xab/0xd0
         [    8.296795]  [<c10fb620>] ? __sync_filesystem+0xa0/0xa0
         [    8.298199]  [<c13e9b03>] ? sysenter_do_call+0x12/0x37
         [    8.306899] Restarting system.
         [    8.307747] machine restart

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 drivers/staging/panel/panel.c |   44 ++++++++++++++++----------------
 1 file changed, 22 insertions(+), 22 deletions(-)

--- linux.orig/drivers/staging/panel/panel.c	2012-09-09 09:55:49.534161723 +0800
+++ linux/drivers/staging/panel/panel.c	2012-09-09 16:19:56.509417982 +0800
@@ -757,38 +757,38 @@ static void lcd_backlight(int on)
 		return;
 
 	/* The backlight is activated by setting the AUTOFEED line to +5V  */
-	spin_lock(&pprt_lock);
+	spin_lock_irq(&pprt_lock);
 	bits.bl = on;
 	panel_set_bits();
-	spin_unlock(&pprt_lock);
+	spin_unlock_irq(&pprt_lock);
 }
 
 /* send a command to the LCD panel in serial mode */
 static void lcd_write_cmd_s(int cmd)
 {
-	spin_lock(&pprt_lock);
+	spin_lock_irq(&pprt_lock);
 	lcd_send_serial(0x1F);	/* R/W=W, RS=0 */
 	lcd_send_serial(cmd & 0x0F);
 	lcd_send_serial((cmd >> 4) & 0x0F);
 	udelay(40);		/* the shortest command takes at least 40 us */
-	spin_unlock(&pprt_lock);
+	spin_unlock_irq(&pprt_lock);
 }
 
 /* send data to the LCD panel in serial mode */
 static void lcd_write_data_s(int data)
 {
-	spin_lock(&pprt_lock);
+	spin_lock_irq(&pprt_lock);
 	lcd_send_serial(0x5F);	/* R/W=W, RS=1 */
 	lcd_send_serial(data & 0x0F);
 	lcd_send_serial((data >> 4) & 0x0F);
 	udelay(40);		/* the shortest data takes at least 40 us */
-	spin_unlock(&pprt_lock);
+	spin_unlock_irq(&pprt_lock);
 }
 
 /* send a command to the LCD panel in 8 bits parallel mode */
 static void lcd_write_cmd_p8(int cmd)
 {
-	spin_lock(&pprt_lock);
+	spin_lock_irq(&pprt_lock);
 	/* present the data to the data port */
 	w_dtr(pprt, cmd);
 	udelay(20);	/* maintain the data during 20 us before the strobe */
@@ -804,13 +804,13 @@ static void lcd_write_cmd_p8(int cmd)
 	set_ctrl_bits();
 
 	udelay(120);	/* the shortest command takes at least 120 us */
-	spin_unlock(&pprt_lock);
+	spin_unlock_irq(&pprt_lock);
 }
 
 /* send data to the LCD panel in 8 bits parallel mode */
 static void lcd_write_data_p8(int data)
 {
-	spin_lock(&pprt_lock);
+	spin_lock_irq(&pprt_lock);
 	/* present the data to the data port */
 	w_dtr(pprt, data);
 	udelay(20);	/* maintain the data during 20 us before the strobe */
@@ -826,27 +826,27 @@ static void lcd_write_data_p8(int data)
 	set_ctrl_bits();
 
 	udelay(45);	/* the shortest data takes at least 45 us */
-	spin_unlock(&pprt_lock);
+	spin_unlock_irq(&pprt_lock);
 }
 
 /* send a command to the TI LCD panel */
 static void lcd_write_cmd_tilcd(int cmd)
 {
-	spin_lock(&pprt_lock);
+	spin_lock_irq(&pprt_lock);
 	/* present the data to the control port */
 	w_ctr(pprt, cmd);
 	udelay(60);
-	spin_unlock(&pprt_lock);
+	spin_unlock_irq(&pprt_lock);
 }
 
 /* send data to the TI LCD panel */
 static void lcd_write_data_tilcd(int data)
 {
-	spin_lock(&pprt_lock);
+	spin_lock_irq(&pprt_lock);
 	/* present the data to the data port */
 	w_dtr(pprt, data);
 	udelay(60);
-	spin_unlock(&pprt_lock);
+	spin_unlock_irq(&pprt_lock);
 }
 
 static void lcd_gotoxy(void)
@@ -879,14 +879,14 @@ static void lcd_clear_fast_s(void)
 	lcd_addr_x = lcd_addr_y = 0;
 	lcd_gotoxy();
 
-	spin_lock(&pprt_lock);
+	spin_lock_irq(&pprt_lock);
 	for (pos = 0; pos < lcd_height * lcd_hwidth; pos++) {
 		lcd_send_serial(0x5F);	/* R/W=W, RS=1 */
 		lcd_send_serial(' ' & 0x0F);
 		lcd_send_serial((' ' >> 4) & 0x0F);
 		udelay(40);	/* the shortest data takes at least 40 us */
 	}
-	spin_unlock(&pprt_lock);
+	spin_unlock_irq(&pprt_lock);
 
 	lcd_addr_x = lcd_addr_y = 0;
 	lcd_gotoxy();
@@ -899,7 +899,7 @@ static void lcd_clear_fast_p8(void)
 	lcd_addr_x = lcd_addr_y = 0;
 	lcd_gotoxy();
 
-	spin_lock(&pprt_lock);
+	spin_lock_irq(&pprt_lock);
 	for (pos = 0; pos < lcd_height * lcd_hwidth; pos++) {
 		/* present the data to the data port */
 		w_dtr(pprt, ' ');
@@ -921,7 +921,7 @@ static void lcd_clear_fast_p8(void)
 		/* the shortest data takes at least 45 us */
 		udelay(45);
 	}
-	spin_unlock(&pprt_lock);
+	spin_unlock_irq(&pprt_lock);
 
 	lcd_addr_x = lcd_addr_y = 0;
 	lcd_gotoxy();
@@ -934,14 +934,14 @@ static void lcd_clear_fast_tilcd(void)
 	lcd_addr_x = lcd_addr_y = 0;
 	lcd_gotoxy();
 
-	spin_lock(&pprt_lock);
+	spin_lock_irq(&pprt_lock);
 	for (pos = 0; pos < lcd_height * lcd_hwidth; pos++) {
 		/* present the data to the data port */
 		w_dtr(pprt, ' ');
 		udelay(60);
 	}
 
-	spin_unlock(&pprt_lock);
+	spin_unlock_irq(&pprt_lock);
 
 	lcd_addr_x = lcd_addr_y = 0;
 	lcd_gotoxy();
@@ -1886,11 +1886,11 @@ static void panel_process_inputs(void)
 static void panel_scan_timer(void)
 {
 	if (keypad_enabled && keypad_initialized) {
-		if (spin_trylock(&pprt_lock)) {
+		if (spin_trylock_irq(&pprt_lock)) {
 			phys_scan_contacts();
 
 			/* no need for the parport anymore */
-			spin_unlock(&pprt_lock);
+			spin_unlock_irq(&pprt_lock);
 		}
 
 		if (!inputs_stable || phys_curr != phys_prev)
