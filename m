Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740Ab0JZCpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:45:47 -0400
Received: from mail.perches.com ([173.55.12.10]:3567 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756432Ab0JZCoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:44:34 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/10] drivers/input/serio/i8042: Use pr_<level>, pr_fmt.  Fix dbg and __FILE__ use
Date: Mon, 25 Oct 2010 19:44:24 -0700
Message-Id: <63a8deabb7c8167128d0415998692d15279ecb8c.1288059486.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.90.gd4c43
In-Reply-To: <cover.1288059486.git.joe@perches.com>
References: <cover.1288059486.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Standardized message logging prefixes.
Removed \n from dbg macro, added \n to each dbg call site.
A couple of uses of dbg already had a \n.
Removed direct use of __FILE__ from dbg, converted to pr_fmt(fmt)
Added non-debug printf argument verification of dbg calls
Removed "i8042.c" from printks, converted to pr_<level>

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/input/serio/i8042.c |   94 ++++++++++++++++++++-----------------------
 drivers/input/serio/i8042.h |   19 +++++---
 2 files changed, 56 insertions(+), 57 deletions(-)

diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 18db5a8..61ef34a 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -10,6 +10,8 @@
  * the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/types.h>
 #include <linux/delay.h>
 #include <linux/module.h>
@@ -225,8 +227,8 @@ static int i8042_flush(void)
 		udelay(50);
 		data = i8042_read_data();
 		i++;
-		dbg("%02x <- i8042 (flush, %s)", data,
-			str & I8042_STR_AUXDATA ? "aux" : "kbd");
+		dbg("%02x <- i8042 (flush, %s)\n",
+		    data, str & I8042_STR_AUXDATA ? "aux" : "kbd");
 	}
 
 	spin_unlock_irqrestore(&i8042_lock, flags);
@@ -253,32 +255,32 @@ static int __i8042_command(unsigned char *param, int command)
 	if (error)
 		return error;
 
-	dbg("%02x -> i8042 (command)", command & 0xff);
+	dbg("%02x -> i8042 (command)\n", command & 0xff);
 	i8042_write_command(command & 0xff);
 
 	for (i = 0; i < ((command >> 12) & 0xf); i++) {
 		error = i8042_wait_write();
 		if (error)
 			return error;
-		dbg("%02x -> i8042 (parameter)", param[i]);
+		dbg("%02x -> i8042 (parameter)\n", param[i]);
 		i8042_write_data(param[i]);
 	}
 
 	for (i = 0; i < ((command >> 8) & 0xf); i++) {
 		error = i8042_wait_read();
 		if (error) {
-			dbg("     -- i8042 (timeout)");
+			dbg("     -- i8042 (timeout)\n");
 			return error;
 		}
 
 		if (command == I8042_CMD_AUX_LOOP &&
 		    !(i8042_read_status() & I8042_STR_AUXDATA)) {
-			dbg("     -- i8042 (auxerr)");
+			dbg("     -- i8042 (auxerr)\n");
 			return -1;
 		}
 
 		param[i] = i8042_read_data();
-		dbg("%02x <- i8042 (return)", param[i]);
+		dbg("%02x <- i8042 (return)\n", param[i]);
 	}
 
 	return 0;
@@ -309,7 +311,7 @@ static int i8042_kbd_write(struct serio *port, unsigned char c)
 	spin_lock_irqsave(&i8042_lock, flags);
 
 	if (!(retval = i8042_wait_write())) {
-		dbg("%02x -> i8042 (kbd-data)", c);
+		dbg("%02x -> i8042 (kbd-data)\n", c);
 		i8042_write_data(c);
 	}
 
@@ -355,17 +357,14 @@ static void i8042_port_close(struct serio *serio)
 
 	i8042_ctr &= ~irq_bit;
 	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR))
-		printk(KERN_WARNING
-			"i8042.c: Can't write CTR while closing %s port.\n",
-			port_name);
+		pr_warn("Can't write CTR while closing %s port\n", port_name);
 
 	udelay(50);
 
 	i8042_ctr &= ~disable_bit;
 	i8042_ctr |= irq_bit;
 	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR))
-		printk(KERN_ERR "i8042.c: Can't reactivate %s port.\n",
-			port_name);
+		pr_err("Can't reactivate %s port\n", port_name);
 
 	/*
 	 * See if there is any data appeared while we were messing with
@@ -456,7 +455,8 @@ static irqreturn_t i8042_interrupt(int irq, void *dev_id)
 	str = i8042_read_status();
 	if (unlikely(~str & I8042_STR_OBF)) {
 		spin_unlock_irqrestore(&i8042_lock, flags);
-		if (irq) dbg("Interrupt %d, without any data", irq);
+		if (irq)
+			dbg("Interrupt %d, without any data\n", irq);
 		ret = 0;
 		goto out;
 	}
@@ -469,7 +469,8 @@ static irqreturn_t i8042_interrupt(int irq, void *dev_id)
 
 		dfl = 0;
 		if (str & I8042_STR_MUXERR) {
-			dbg("MUX error, status is %02x, data is %02x", str, data);
+			dbg("MUX error, status is %02x, data is %02x\n",
+			    str, data);
 /*
  * When MUXERR condition is signalled the data register can only contain
  * 0xfd, 0xfe or 0xff if implementation follows the spec. Unfortunately
@@ -512,7 +513,7 @@ static irqreturn_t i8042_interrupt(int irq, void *dev_id)
 	port = &i8042_ports[port_no];
 	serio = port->exists ? port->serio : NULL;
 
-	dbg("%02x <- i8042 (interrupt, %d, %d%s%s)",
+	dbg("%02x <- i8042 (interrupt, %d, %d%s%s)\n",
 	    data, port_no, irq,
 	    dfl & SERIO_PARITY ? ", bad parity" : "",
 	    dfl & SERIO_TIMEOUT ? ", timeout" : "");
@@ -540,7 +541,7 @@ static int i8042_enable_kbd_port(void)
 	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR)) {
 		i8042_ctr &= ~I8042_CTR_KBDINT;
 		i8042_ctr |= I8042_CTR_KBDDIS;
-		printk(KERN_ERR "i8042.c: Failed to enable KBD port.\n");
+		pr_err("Failed to enable KBD port\n");
 		return -EIO;
 	}
 
@@ -559,7 +560,7 @@ static int i8042_enable_aux_port(void)
 	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR)) {
 		i8042_ctr &= ~I8042_CTR_AUXINT;
 		i8042_ctr |= I8042_CTR_AUXDIS;
-		printk(KERN_ERR "i8042.c: Failed to enable AUX port.\n");
+		pr_err("Failed to enable AUX port\n");
 		return -EIO;
 	}
 
@@ -641,7 +642,7 @@ static int __init i8042_check_mux(void)
 	if (i8042_set_mux_mode(true, &mux_version))
 		return -1;
 
-	printk(KERN_INFO "i8042.c: Detected active multiplexing controller, rev %d.%d.\n",
+	pr_info("Detected active multiplexing controller, rev %d.%d\n",
 		(mux_version >> 4) & 0xf, mux_version & 0xf);
 
 /*
@@ -651,7 +652,7 @@ static int __init i8042_check_mux(void)
 	i8042_ctr &= ~I8042_CTR_AUXINT;
 
 	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR)) {
-		printk(KERN_ERR "i8042.c: Failed to disable AUX port, can't use MUX.\n");
+		pr_err("Failed to disable AUX port, can't use MUX\n");
 		return -EIO;
 	}
 
@@ -676,8 +677,8 @@ static irqreturn_t __init i8042_aux_test_irq(int irq, void *dev_id)
 	str = i8042_read_status();
 	if (str & I8042_STR_OBF) {
 		data = i8042_read_data();
-		dbg("%02x <- i8042 (aux_test_irq, %s)",
-			data, str & I8042_STR_AUXDATA ? "aux" : "kbd");
+		dbg("%02x <- i8042 (aux_test_irq, %s)\n",
+		    data, str & I8042_STR_AUXDATA ? "aux" : "kbd");
 		if (i8042_irq_being_tested &&
 		    data == 0xa5 && (str & I8042_STR_AUXDATA))
 			complete(&i8042_aux_irq_delivered);
@@ -770,8 +771,8 @@ static int __init i8042_check_aux(void)
  */
 
 	if (i8042_toggle_aux(false)) {
-		printk(KERN_WARNING "Failed to disable AUX port, but continuing anyway... Is this a SiS?\n");
-		printk(KERN_WARNING "If AUX port is really absent please use the 'i8042.noaux' option.\n");
+		pr_warn("Failed to disable AUX port, but continuing anyway... Is this a SiS?\n");
+		pr_warn("If AUX port is really absent please use the 'i8042.noaux' option.\n");
 	}
 
 	if (i8042_toggle_aux(true))
@@ -819,7 +820,7 @@ static int __init i8042_check_aux(void)
  * AUX IRQ was never delivered so we need to flush the controller to
  * get rid of the byte we put there; otherwise keyboard may not work.
  */
-		dbg("     -- i8042 (aux irq test timeout)");
+		dbg("     -- i8042 (aux irq test timeout)\n");
 		i8042_flush();
 		retval = -1;
 	}
@@ -845,7 +846,7 @@ static int __init i8042_check_aux(void)
 static int i8042_controller_check(void)
 {
 	if (i8042_flush() == I8042_BUFFER_SIZE) {
-		printk(KERN_ERR "i8042.c: No controller found.\n");
+		pr_err("No controller found\n");
 		return -ENODEV;
 	}
 
@@ -864,15 +865,15 @@ static int i8042_controller_selftest(void)
 	do {
 
 		if (i8042_command(&param, I8042_CMD_CTL_TEST)) {
-			printk(KERN_ERR "i8042.c: i8042 controller self test timeout.\n");
+			pr_err("i8042 controller self test timeout\n");
 			return -ENODEV;
 		}
 
 		if (param == I8042_RET_CTL_TEST)
 			return 0;
 
-		printk(KERN_ERR "i8042.c: i8042 controller selftest failed. (%#x != %#x)\n",
-			param, I8042_RET_CTL_TEST);
+		pr_err("i8042 controller selftest failed. (%#x != %#x)\n",
+		       param, I8042_RET_CTL_TEST);
 		msleep(50);
 	} while (i++ < 5);
 
@@ -883,8 +884,7 @@ static int i8042_controller_selftest(void)
 	 * and user will still get a working keyboard. This is especially
 	 * important on netbooks. On other arches we trust hardware more.
 	 */
-	printk(KERN_INFO
-		"i8042: giving up on controller selftest, continuing anyway...\n");
+	pr_info("giving up on controller selftest, continuing anyway...\n");
 	return 0;
 #else
 	return -EIO;
@@ -909,8 +909,7 @@ static int i8042_controller_init(void)
 
 	do {
 		if (n >= 10) {
-			printk(KERN_ERR
-				"i8042.c: Unable to get stable CTR read.\n");
+			pr_err("Unable to get stable CTR read\n");
 			return -EIO;
 		}
 
@@ -918,8 +917,7 @@ static int i8042_controller_init(void)
 			udelay(50);
 
 		if (i8042_command(&ctr[n++ % 2], I8042_CMD_CTL_RCTR)) {
-			printk(KERN_ERR
-				"i8042.c: Can't read CTR while initializing i8042.\n");
+			pr_err("Can't read CTR while initializing i8042\n");
 			return -EIO;
 		}
 
@@ -943,7 +941,7 @@ static int i8042_controller_init(void)
 		if (i8042_unlock)
 			i8042_ctr |= I8042_CTR_IGNKEYLOCK;
 		else
-			printk(KERN_WARNING "i8042.c: Warning: Keylock active.\n");
+			pr_warn("Warning: Keylock active\n");
 	}
 	spin_unlock_irqrestore(&i8042_lock, flags);
 
@@ -970,7 +968,7 @@ static int i8042_controller_init(void)
  */
 
 	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR)) {
-		printk(KERN_ERR "i8042.c: Can't write CTR while initializing i8042.\n");
+		pr_err("Can't write CTR while initializing i8042\n");
 		return -EIO;
 	}
 
@@ -1000,7 +998,7 @@ static void i8042_controller_reset(void)
 	i8042_ctr &= ~(I8042_CTR_KBDINT | I8042_CTR_AUXINT);
 
 	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR))
-		printk(KERN_WARNING "i8042.c: Can't write CTR while resetting.\n");
+		pr_warn("Can't write CTR while resetting\n");
 
 /*
  * Disable MUX mode if present.
@@ -1021,7 +1019,7 @@ static void i8042_controller_reset(void)
  */
 
 	if (i8042_command(&i8042_initial_ctr, I8042_CMD_CTL_WCTR))
-		printk(KERN_WARNING "i8042.c: Can't restore CTR.\n");
+		pr_warn("Can't restore CTR\n");
 }
 
 
@@ -1045,14 +1043,14 @@ static long i8042_panic_blink(int state)
 	led = (state) ? 0x01 | 0x04 : 0;
 	while (i8042_read_status() & I8042_STR_IBF)
 		DELAY;
-	dbg("%02x -> i8042 (panic blink)", 0xed);
+	dbg("%02x -> i8042 (panic blink)\n", 0xed);
 	i8042_suppress_kbd_ack = 2;
 	i8042_write_data(0xed); /* set leds */
 	DELAY;
 	while (i8042_read_status() & I8042_STR_IBF)
 		DELAY;
 	DELAY;
-	dbg("%02x -> i8042 (panic blink)", led);
+	dbg("%02x -> i8042 (panic blink)\n", led);
 	i8042_write_data(led);
 	DELAY;
 	return delay;
@@ -1068,9 +1066,7 @@ static void i8042_dritek_enable(void)
 
 	error = i8042_command(&param, 0x1059);
 	if (error)
-		printk(KERN_WARNING
-			"Failed to enable DRITEK extension: %d\n",
-			error);
+		pr_warn("Failed to enable DRITEK extension: %d\n", error);
 }
 #endif
 
@@ -1105,10 +1101,10 @@ static int i8042_controller_resume(bool force_reset)
 	i8042_ctr |= I8042_CTR_AUXDIS | I8042_CTR_KBDDIS;
 	i8042_ctr &= ~(I8042_CTR_AUXINT | I8042_CTR_KBDINT);
 	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR)) {
-		printk(KERN_WARNING "i8042: Can't write CTR to resume, retrying...\n");
+		pr_warn("Can't write CTR to resume, retrying...\n");
 		msleep(50);
 		if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR)) {
-			printk(KERN_ERR "i8042: CTR write retry failed\n");
+			pr_err("CTR write retry failed\n");
 			return -EIO;
 		}
 	}
@@ -1121,9 +1117,7 @@ static int i8042_controller_resume(bool force_reset)
 
 	if (i8042_mux_present) {
 		if (i8042_set_mux_mode(true, NULL) || i8042_enable_mux_ports())
-			printk(KERN_WARNING
-				"i8042: failed to resume active multiplexor, "
-				"mouse won't work.\n");
+			pr_warn("failed to resume active multiplexor, mouse won't work\n");
 	} else if (i8042_ports[I8042_AUX_PORT_NO].serio)
 		i8042_enable_aux_port();
 
@@ -1268,7 +1262,7 @@ static void __init i8042_register_ports(void)
 
 	for (i = 0; i < I8042_NUM_PORTS; i++) {
 		if (i8042_ports[i].serio) {
-			printk(KERN_INFO "serio: %s at %#lx,%#lx irq %d\n",
+			pr_info("%s at %#lx,%#lx irq %d\n",
 				i8042_ports[i].serio->name,
 				(unsigned long) I8042_DATA_REG,
 				(unsigned long) I8042_COMMAND_REG,
diff --git a/drivers/input/serio/i8042.h b/drivers/input/serio/i8042.h
index cbc1beb..f510950 100644
--- a/drivers/input/serio/i8042.h
+++ b/drivers/input/serio/i8042.h
@@ -89,15 +89,20 @@
 #ifdef DEBUG
 static unsigned long i8042_start_time;
 #define dbg_init() do { i8042_start_time = jiffies; } while (0)
-#define dbg(format, arg...) 							\
-	do { 									\
-		if (i8042_debug)						\
-			printk(KERN_DEBUG __FILE__ ": " format " [%d]\n" ,	\
-	 			## arg, (int) (jiffies - i8042_start_time));	\
-	} while (0)
+#define dbg(format, arg...)						\
+do {									\
+	if (i8042_debug)						\
+		printk(KERN_DEBUG pr_fmt(format "[%d]"),		\
+		       ##arg, (int)(jiffies - i8042_start_time));	\
+} while (0)
+
 #else
 #define dbg_init() do { } while (0)
-#define dbg(format, arg...) do {} while (0)
+#define dbg(format, arg...)						\
+do {									\
+	if (0)								\
+		printk(KERN_DEBUG pr_fmt(format), ##arg);		\
+} while (0)
 #endif
 
 #endif /* _I8042_H */
-- 
1.7.3.dirty

