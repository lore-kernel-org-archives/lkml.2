Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab0JVT4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:56:46 -0400
Received: from adsl-99-30-218-25.dsl.aus2tx.sbcglobal.net ([99.30.218.25]:44348
	"EHLO gw.microgate.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab0JVT4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:56:45 -0400
Subject: [PATCH] synclink_gt add extended sync feature
From: Paul Fulghum <paulkf@microgate.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 22 Oct 2010 14:56:07 -0500
Message-Id: <1287777367.19916.2.camel@x2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for extended byte synchronous mode feature of hardware.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>

--- a/include/linux/synclink.h	2010-10-21 14:08:50.000000000 -0500
+++ b/include/linux/synclink.h	2010-10-22 14:34:23.000000000 -0500
@@ -126,6 +126,7 @@
 #define MGSL_MODE_BISYNC	4
 #define MGSL_MODE_RAW		6
 #define MGSL_MODE_BASE_CLOCK    7
+#define MGSL_MODE_XSYNC         8
 
 #define MGSL_BUS_TYPE_ISA	1
 #define MGSL_BUS_TYPE_EISA	2
@@ -290,6 +291,10 @@ struct gpio_desc {
 #define MGSL_IOCSGPIO		_IOW(MGSL_MAGIC_IOC,16,struct gpio_desc)
 #define MGSL_IOCGGPIO		_IOR(MGSL_MAGIC_IOC,17,struct gpio_desc)
 #define MGSL_IOCWAITGPIO	_IOWR(MGSL_MAGIC_IOC,18,struct gpio_desc)
+#define MGSL_IOCSXSYNC		_IO(MGSL_MAGIC_IOC, 19)
+#define MGSL_IOCGXSYNC		_IO(MGSL_MAGIC_IOC, 20)
+#define MGSL_IOCSXCTRL		_IO(MGSL_MAGIC_IOC, 21)
+#define MGSL_IOCGXCTRL		_IO(MGSL_MAGIC_IOC, 22)
 
 #ifdef __KERNEL__
 /* provide 32 bit ioctl compatibility on 64 bit systems */
--- a/drivers/char/synclink_gt.c	2010-10-21 14:08:37.000000000 -0500
+++ b/drivers/char/synclink_gt.c	2010-10-22 14:35:22.000000000 -0500
@@ -301,6 +301,8 @@ struct slgt_info {
 	unsigned int rx_pio;
 	unsigned int if_mode;
 	unsigned int base_clock;
+	unsigned int xsync;
+	unsigned int xctrl;
 
 	/* device status */
 
@@ -405,6 +407,8 @@ static MGSL_PARAMS default_params = {
 #define TDCSR 0x94 /* tx DMA control/status */
 #define RDDAR 0x98 /* rx DMA descriptor address */
 #define TDDAR 0x9c /* tx DMA descriptor address */
+#define XSR   0x40 /* extended sync pattern */
+#define XCR   0x44 /* extended control */
 
 #define RXIDLE      BIT14
 #define RXBREAK     BIT14
@@ -517,6 +521,10 @@ static int  set_interface(struct slgt_in
 static int  set_gpio(struct slgt_info *info, struct gpio_desc __user *gpio);
 static int  get_gpio(struct slgt_info *info, struct gpio_desc __user *gpio);
 static int  wait_gpio(struct slgt_info *info, struct gpio_desc __user *gpio);
+static int  get_xsync(struct slgt_info *info, int __user *if_mode);
+static int  set_xsync(struct slgt_info *info, int if_mode);
+static int  get_xctrl(struct slgt_info *info, int __user *if_mode);
+static int  set_xctrl(struct slgt_info *info, int if_mode);
 
 /*
  * driver functions
@@ -1077,6 +1085,14 @@ static int ioctl(struct tty_struct *tty,
 		return get_gpio(info, argp);
 	case MGSL_IOCWAITGPIO:
 		return wait_gpio(info, argp);
+	case MGSL_IOCGXSYNC:
+		return get_xsync(info, argp);
+	case MGSL_IOCSXSYNC:
+		return set_xsync(info, (int)arg);
+	case MGSL_IOCGXCTRL:
+		return get_xctrl(info, argp);
+	case MGSL_IOCSXCTRL:
+		return set_xctrl(info, (int)arg);
 	}
 	mutex_lock(&info->port.mutex);
 	switch (cmd) {
@@ -1207,6 +1223,8 @@ static long slgt_compat_ioctl(struct tty
 	case MGSL_IOCGGPIO:
 	case MGSL_IOCWAITGPIO:
 	case TIOCGICOUNT:
+	case MGSL_IOCGXSYNC:
+	case MGSL_IOCGXCTRL:
 		rc = ioctl(tty, file, cmd, (unsigned long)(compat_ptr(arg)));
 		break;
 
@@ -1216,6 +1234,8 @@ static long slgt_compat_ioctl(struct tty
 	case MGSL_IOCTXABORT:
 	case TIOCMIWAIT:
 	case MGSL_IOCSIF:
+	case MGSL_IOCSXSYNC:
+	case MGSL_IOCSXCTRL:
 		rc = ioctl(tty, file, cmd, arg);
 		break;
 	}
@@ -1956,6 +1976,7 @@ static void bh_handler(struct work_struc
 			case MGSL_MODE_RAW:
 			case MGSL_MODE_MONOSYNC:
 			case MGSL_MODE_BISYNC:
+			case MGSL_MODE_XSYNC:
 				while(rx_get_buf(info));
 				break;
 			}
@@ -2881,6 +2902,69 @@ static int set_interface(struct slgt_inf
 	return 0;
 }
 
+static int get_xsync(struct slgt_info *info, int __user *xsync)
+{
+	DBGINFO(("%s get_xsync=%x\n", info->device_name, info->xsync));
+	if (put_user(info->xsync, xsync))
+		return -EFAULT;
+	return 0;
+}
+
+/*
+ * set extended sync pattern (1 to 4 bytes) for extended sync mode
+ *
+ * sync pattern is contained in least significant bytes of value
+ * most significant byte of sync pattern is oldest (1st sent/detected)
+ */
+static int set_xsync(struct slgt_info *info, int xsync)
+{
+	unsigned long flags;
+
+	DBGINFO(("%s set_xsync=%x)\n", info->device_name, xsync));
+	spin_lock_irqsave(&info->lock, flags);
+	info->xsync = xsync;
+	wr_reg32(info, XSR, xsync);
+	spin_unlock_irqrestore(&info->lock, flags);
+	return 0;
+}
+
+static int get_xctrl(struct slgt_info *info, int __user *xctrl)
+{
+	DBGINFO(("%s get_xctrl=%x\n", info->device_name, info->xctrl));
+	if (put_user(info->xctrl, xctrl))
+		return -EFAULT;
+	return 0;
+}
+
+/*
+ * set extended control options
+ *
+ * xctrl[31:19] reserved, must be zero
+ * xctrl[18:17] extended sync pattern length in bytes
+ *              00 = 1 byte  in xsr[7:0]
+ *              01 = 2 bytes in xsr[15:0]
+ *              10 = 3 bytes in xsr[23:0]
+ *              11 = 4 bytes in xsr[31:0]
+ * xctrl[16]    1 = enable terminal count, 0=disabled
+ * xctrl[15:0]  receive terminal count for fixed length packets
+ *              value is count minus one (0 = 1 byte packet)
+ *              when terminal count is reached, receiver
+ *              automatically returns to hunt mode and receive
+ *              FIFO contents are flushed to DMA buffers with
+ *              end of frame (EOF) status
+ */
+static int set_xctrl(struct slgt_info *info, int xctrl)
+{
+	unsigned long flags;
+
+	DBGINFO(("%s set_xctrl=%x)\n", info->device_name, xctrl));
+	spin_lock_irqsave(&info->lock, flags);
+	info->xctrl = xctrl;
+	wr_reg32(info, XCR, xctrl);
+	spin_unlock_irqrestore(&info->lock, flags);
+	return 0;
+}
+
 /*
  * set general purpose IO pin state and direction
  *
@@ -3760,7 +3844,9 @@ module_exit(slgt_exit);
 #define CALC_REGADDR() \
 	unsigned long reg_addr = ((unsigned long)info->reg_addr) + addr; \
 	if (addr >= 0x80) \
-		reg_addr += (info->port_num) * 32;
+		reg_addr += (info->port_num) * 32; \
+	else if (addr >= 0x40)	\
+		reg_addr += (info->port_num) * 16;
 
 static __u8 rd_reg8(struct slgt_info *info, unsigned int addr)
 {
@@ -4179,7 +4265,13 @@ static void sync_mode(struct slgt_info *
 
 	/* TCR (tx control)
 	 *
-	 * 15..13  mode, 000=HDLC 001=raw 010=async 011=monosync 100=bisync
+	 * 15..13  mode
+	 *         000=HDLC/SDLC
+	 *         001=raw bit synchronous
+	 *         010=asynchronous/isochronous
+	 *         011=monosync byte synchronous
+	 *         100=bisync byte synchronous
+	 *         101=xsync byte synchronous
 	 * 12..10  encoding
 	 * 09      CRC enable
 	 * 08      CRC32
@@ -4194,6 +4286,9 @@ static void sync_mode(struct slgt_info *
 	val = BIT2;
 
 	switch(info->params.mode) {
+	case MGSL_MODE_XSYNC:
+		val |= BIT15 + BIT13;
+		break;
 	case MGSL_MODE_MONOSYNC: val |= BIT14 + BIT13; break;
 	case MGSL_MODE_BISYNC:   val |= BIT15; break;
 	case MGSL_MODE_RAW:      val |= BIT13; break;
@@ -4248,7 +4343,13 @@ static void sync_mode(struct slgt_info *
 
 	/* RCR (rx control)
 	 *
-	 * 15..13  mode, 000=HDLC 001=raw 010=async 011=monosync 100=bisync
+	 * 15..13  mode
+	 *         000=HDLC/SDLC
+	 *         001=raw bit synchronous
+	 *         010=asynchronous/isochronous
+	 *         011=monosync byte synchronous
+	 *         100=bisync byte synchronous
+	 *         101=xsync byte synchronous
 	 * 12..10  encoding
 	 * 09      CRC enable
 	 * 08      CRC32
@@ -4260,6 +4361,9 @@ static void sync_mode(struct slgt_info *
 	val = 0;
 
 	switch(info->params.mode) {
+	case MGSL_MODE_XSYNC:
+		val |= BIT15 + BIT13;
+		break;
 	case MGSL_MODE_MONOSYNC: val |= BIT14 + BIT13; break;
 	case MGSL_MODE_BISYNC:   val |= BIT15; break;
 	case MGSL_MODE_RAW:      val |= BIT13; break;
@@ -4676,6 +4780,7 @@ static bool rx_get_buf(struct slgt_info 
 	switch(info->params.mode) {
 	case MGSL_MODE_MONOSYNC:
 	case MGSL_MODE_BISYNC:
+	case MGSL_MODE_XSYNC:
 		/* ignore residue in byte synchronous modes */
 		if (desc_residue(info->rbufs[i]))
 			count--;


