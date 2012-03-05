Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488Ab2CEOF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:05:59 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34668 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378Ab2CENxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:12 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 14/68] TTY: remove unneeded tty->index checks
Date: Mon,  5 Mar 2012 14:52:01 +0100
Message-Id: <1330955575-26641-15-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking if tty->index is in bounds is not needed. The tty has the
index set in the initial open. This is done in get_tty_driver. And it
can be only in interval <0,driver->num).

So remove the tests which check exactly this interval. Some are
left untouched as they check against the current backing device count.
(Leaving apart that the check is racy in most of the cases.)

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/ia64/hp/sim/simserial.c        |    9 +++------
 arch/xtensa/platforms/iss/console.c |    8 ++------
 drivers/char/pcmcia/synclink_cs.c   |    2 +-
 drivers/isdn/capi/capi.c            |    3 +--
 drivers/isdn/gigaset/common.c       |    2 --
 drivers/isdn/i4l/isdn_tty.c         |    7 ++-----
 drivers/s390/char/con3215.c         |    8 ++------
 drivers/tty/amiserial.c             |   10 +++-------
 drivers/tty/cyclades.c              |    6 +-----
 drivers/tty/hvc/hvcs.c              |   24 ++++++++++--------------
 drivers/tty/hvc/hvsi.c              |    5 +----
 drivers/tty/isicom.c                |    2 --
 drivers/tty/mxser.c                 |    2 --
 drivers/tty/rocket.c                |    6 +++---
 drivers/tty/serial/68328serial.c    |    9 ++-------
 drivers/tty/serial/crisv10.c        |   15 +++------------
 drivers/tty/synclink.c              |    2 +-
 drivers/tty/synclink_gt.c           |    2 +-
 drivers/tty/synclinkmp.c            |    2 +-
 drivers/usb/gadget/u_serial.c       |    3 ---
 net/irda/ircomm/ircomm_tty.c        |    6 +-----
 21 files changed, 38 insertions(+), 95 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index 9c9c634..164b73d 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -760,13 +760,10 @@ errout:
 static int rs_open(struct tty_struct *tty, struct file * filp)
 {
 	struct async_struct	*info;
-	int			retval, line;
+	int			retval;
 	unsigned long		page;
 
-	line = tty->index;
-	if ((line < 0) || (line >= NR_PORTS))
-		return -ENODEV;
-	retval = get_async_struct(line, &info);
+	retval = get_async_struct(tty->index, &info);
 	if (retval)
 		return retval;
 	tty->driver_data = info;
@@ -911,7 +908,7 @@ simrs_init (void)
 	if (!ia64_platform_is("hpsim"))
 		return -ENODEV;
 
-	hp_simserial_driver = alloc_tty_driver(1);
+	hp_simserial_driver = alloc_tty_driver(NR_PORTS);
 	if (!hp_simserial_driver)
 		return -ENOMEM;
 
diff --git a/arch/xtensa/platforms/iss/console.c b/arch/xtensa/platforms/iss/console.c
index 247e9d4..19a802a 100644
--- a/arch/xtensa/platforms/iss/console.c
+++ b/arch/xtensa/platforms/iss/console.c
@@ -68,11 +68,6 @@ static void rs_poll(unsigned long);
 
 static int rs_open(struct tty_struct *tty, struct file * filp)
 {
-	int line = tty->index;
-
-	if ((line < 0) || (line >= SERIAL_MAX_NUM_LINES))
-		return -ENODEV;
-
 	spin_lock(&timer_lock);
 
 	if (tty->count == 1) {
@@ -101,6 +96,7 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 {
 	spin_lock(&timer_lock);
 	if (tty->count == 1)
+		/* this will cause a deadlock if the timer ticks right now */
 		del_timer_sync(&serial_timer);
 	spin_unlock(&timer_lock);
 }
@@ -210,7 +206,7 @@ static const struct tty_operations serial_ops = {
 
 int __init rs_init(void)
 {
-	serial_driver = alloc_tty_driver(1);
+	serial_driver = alloc_tty_driver(SERIAL_MAX_NUM_LINES);
 
 	printk ("%s %s\n", serial_name, serial_version);
 
diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index c3bcb12..f6453df 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -2484,7 +2484,7 @@ static int mgslpc_open(struct tty_struct *tty, struct file * filp)
 
 	/* verify range of specified line number */
 	line = tty->index;
-	if ((line < 0) || (line >= mgslpc_device_count)) {
+	if (line >= mgslpc_device_count) {
 		printk("%s(%d):mgslpc_open with invalid line #%d.\n",
 			__FILE__,__LINE__,line);
 		return -ENODEV;
diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index 41a5644..df8fd88 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -1013,8 +1013,7 @@ static const struct file_operations capi_fops =
 static int
 capinc_tty_install(struct tty_driver *driver, struct tty_struct *tty)
 {
-	int idx = tty->index;
-	struct capiminor *mp = capiminor_get(idx);
+	struct capiminor *mp = capiminor_get(tty->index);
 	int ret = tty_standard_install(driver, tty);
 
 	if (ret == 0)
diff --git a/drivers/isdn/gigaset/common.c b/drivers/isdn/gigaset/common.c
index e55aabf..db6e434 100644
--- a/drivers/isdn/gigaset/common.c
+++ b/drivers/isdn/gigaset/common.c
@@ -1051,8 +1051,6 @@ static struct cardstate *gigaset_get_cs_by_minor(unsigned minor)
 
 struct cardstate *gigaset_get_cs_by_tty(struct tty_struct *tty)
 {
-	if (tty->index < 0 || tty->index >= tty->driver->num)
-		return NULL;
 	return gigaset_get_cs_by_minor(tty->index + tty->driver->minor_start);
 }
 
diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index 89a2887..3831abd 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -1590,12 +1590,9 @@ static int
 isdn_tty_open(struct tty_struct *tty, struct file *filp)
 {
 	modem_info *info;
-	int retval, line;
+	int retval;
 
-	line = tty->index;
-	if (line < 0 || line >= ISDN_MAX_CHANNELS)
-		return -ENODEV;
-	info = &dev->mdm.info[line];
+	info = &dev->mdm.info[tty->index];
 	if (isdn_tty_paranoia_check(info, tty->name, "isdn_tty_open"))
 		return -ENODEV;
 	if (!try_module_get(info->owner)) {
diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index 176e07c..4f9f1dc 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -933,13 +933,9 @@ console_initcall(con3215_init);
 static int tty3215_open(struct tty_struct *tty, struct file * filp)
 {
 	struct raw3215_info *raw;
-	int retval, line;
+	int retval;
 
-	line = tty->index;
-	if ((line < 0) || (line >= NR_3215))
-		return -ENODEV;
-
-	raw = raw3215[line];
+	raw = raw3215[tty->index];
 	if (raw == NULL)
 		return -ENODEV;
 
diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index b42f00d..7532862 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -1768,13 +1768,9 @@ static int get_async_struct(int line, struct async_struct **ret_info)
 static int rs_open(struct tty_struct *tty, struct file * filp)
 {
 	struct async_struct	*info;
-	int 			retval, line;
+	int retval;
 
-	line = tty->index;
-	if ((line < 0) || (line >= NR_PORTS)) {
-		return -ENODEV;
-	}
-	retval = get_async_struct(line, &info);
+	retval = get_async_struct(tty->index, &info);
 	if (retval) {
 		return retval;
 	}
@@ -1964,7 +1960,7 @@ static int __init amiga_serial_probe(struct platform_device *pdev)
 	struct serial_state * state;
 	int error;
 
-	serial_driver = alloc_tty_driver(1);
+	serial_driver = alloc_tty_driver(NR_PORTS);
 	if (!serial_driver)
 		return -ENOMEM;
 
diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
index 98a1b8b..765d1a9 100644
--- a/drivers/tty/cyclades.c
+++ b/drivers/tty/cyclades.c
@@ -1515,13 +1515,9 @@ static void cy_shutdown(struct cyclades_port *info, struct tty_struct *tty)
 static int cy_open(struct tty_struct *tty, struct file *filp)
 {
 	struct cyclades_port *info;
-	unsigned int i, line;
+	unsigned int i, line = tty->index;
 	int retval;
 
-	line = tty->index;
-	if (tty->index < 0 || NR_PORTS <= line)
-		return -ENODEV;
-
 	for (i = 0; i < NR_CARDS; i++)
 		if (line < cy_card[i].first_line + cy_card[i].nports &&
 				line >= cy_card[i].first_line)
diff --git a/drivers/tty/hvc/hvcs.c b/drivers/tty/hvc/hvcs.c
index da0aa47..d237591 100644
--- a/drivers/tty/hvc/hvcs.c
+++ b/drivers/tty/hvc/hvcs.c
@@ -1090,27 +1090,23 @@ static int hvcs_enable_device(struct hvcs_struct *hvcsd, uint32_t unit_address,
  */
 static struct hvcs_struct *hvcs_get_by_index(int index)
 {
-	struct hvcs_struct *hvcsd = NULL;
+	struct hvcs_struct *hvcsd;
 	unsigned long flags;
 
 	spin_lock(&hvcs_structs_lock);
-	/* We can immediately discard OOB requests */
-	if (index >= 0 && index < HVCS_MAX_SERVER_ADAPTERS) {
-		list_for_each_entry(hvcsd, &hvcs_structs, next) {
-			spin_lock_irqsave(&hvcsd->lock, flags);
-			if (hvcsd->index == index) {
-				kref_get(&hvcsd->kref);
-				spin_unlock_irqrestore(&hvcsd->lock, flags);
-				spin_unlock(&hvcs_structs_lock);
-				return hvcsd;
-			}
+	list_for_each_entry(hvcsd, &hvcs_structs, next) {
+		spin_lock_irqsave(&hvcsd->lock, flags);
+		if (hvcsd->index == index) {
+			kref_get(&hvcsd->kref);
 			spin_unlock_irqrestore(&hvcsd->lock, flags);
+			spin_unlock(&hvcs_structs_lock);
+			return hvcsd;
 		}
-		hvcsd = NULL;
+		spin_unlock_irqrestore(&hvcsd->lock, flags);
 	}
-
 	spin_unlock(&hvcs_structs_lock);
-	return hvcsd;
+
+	return NULL;
 }
 
 /*
diff --git a/drivers/tty/hvc/hvsi.c b/drivers/tty/hvc/hvsi.c
index 60bc451..a7488b7 100644
--- a/drivers/tty/hvc/hvsi.c
+++ b/drivers/tty/hvc/hvsi.c
@@ -737,14 +737,11 @@ static int hvsi_open(struct tty_struct *tty, struct file *filp)
 {
 	struct hvsi_struct *hp;
 	unsigned long flags;
-	int line = tty->index;
 	int ret;
 
 	pr_debug("%s\n", __func__);
 
-	if (line < 0 || line >= hvsi_count)
-		return -ENODEV;
-	hp = &hvsi_ports[line];
+	hp = &hvsi_ports[tty->index];
 
 	tty->driver_data = hp;
 
diff --git a/drivers/tty/isicom.c b/drivers/tty/isicom.c
index b3a28b5..03c1497 100644
--- a/drivers/tty/isicom.c
+++ b/drivers/tty/isicom.c
@@ -849,8 +849,6 @@ static struct tty_port *isicom_find_port(struct tty_struct *tty)
 	unsigned int board;
 	int line = tty->index;
 
-	if (line < 0 || line > PORT_COUNT-1)
-		return NULL;
 	board = BOARD(line);
 	card = &isi_card[board];
 
diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index 260d031..17ff377 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -1010,8 +1010,6 @@ static int mxser_open(struct tty_struct *tty, struct file *filp)
 	line = tty->index;
 	if (line == MXSER_PORTS)
 		return 0;
-	if (line < 0 || line > MXSER_PORTS)
-		return -ENODEV;
 	info = &mxser_boards[line / MXSER_PORTS_PER_BOARD].ports[line % MXSER_PORTS_PER_BOARD];
 	if (!info->ioaddr)
 		return -ENODEV;
diff --git a/drivers/tty/rocket.c b/drivers/tty/rocket.c
index b088e1e..777d5f9 100644
--- a/drivers/tty/rocket.c
+++ b/drivers/tty/rocket.c
@@ -892,12 +892,12 @@ static int rp_open(struct tty_struct *tty, struct file *filp)
 {
 	struct r_port *info;
 	struct tty_port *port;
-	int line = 0, retval;
+	int retval;
 	CHANNEL_t *cp;
 	unsigned long page;
 
-	line = tty->index;
-	if (line < 0 || line >= MAX_RP_PORTS || ((info = rp_table[line]) == NULL))
+	info = rp_table[tty->index];
+	if (info == NULL)
 		return -ENXIO;
 	port = &info->port;
 	
diff --git a/drivers/tty/serial/68328serial.c b/drivers/tty/serial/68328serial.c
index a88ef97..7398390 100644
--- a/drivers/tty/serial/68328serial.c
+++ b/drivers/tty/serial/68328serial.c
@@ -1190,14 +1190,9 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 int rs_open(struct tty_struct *tty, struct file * filp)
 {
 	struct m68k_serial	*info;
-	int 			retval, line;
-
-	line = tty->index;
-	
-	if (line >= NR_PORTS || line < 0) /* we have exactly one */
-		return -ENODEV;
+	int retval;
 
-	info = &m68k_soft[line];
+	info = &m68k_soft[tty->index];
 
 	if (serial_paranoia_check(info, tty->name, "rs_open"))
 		return -ENODEV;
diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
index 1dfba7b..23d7916 100644
--- a/drivers/tty/serial/crisv10.c
+++ b/drivers/tty/serial/crisv10.c
@@ -4105,20 +4105,11 @@ static int
 rs_open(struct tty_struct *tty, struct file * filp)
 {
 	struct e100_serial	*info;
-	int 			retval, line;
+	int 			retval;
 	unsigned long           page;
 	int                     allocated_resources = 0;
 
-	/* find which port we want to open */
-	line = tty->index;
-
-	if (line < 0 || line >= NR_PORTS)
-		return -ENODEV;
-
-	/* find the corresponding e100_serial struct in the table */
-	info = rs_table + line;
-
-	/* don't allow the opening of ports that are not enabled in the HW config */
+	info = rs_table + tty->index;
 	if (!info->enabled)
 		return -ENODEV;
 
@@ -4131,7 +4122,7 @@ rs_open(struct tty_struct *tty, struct file * filp)
 	tty->driver_data = info;
 	info->port.tty = tty;
 
-	info->port.tty->low_latency = (info->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
+	tty->low_latency = !!(info->flags & ASYNC_LOW_LATENCY);
 
 	if (!tmp_buf) {
 		page = get_zeroed_page(GFP_KERNEL);
diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
index 2b2988c..8e518da 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -3381,7 +3381,7 @@ static int mgsl_open(struct tty_struct *tty, struct file * filp)
 
 	/* verify range of specified line number */	
 	line = tty->index;
-	if ((line < 0) || (line >= mgsl_device_count)) {
+	if (line >= mgsl_device_count) {
 		printk("%s(%d):mgsl_open with invalid line #%d.\n",
 			__FILE__,__LINE__,line);
 		return -ENODEV;
diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index 32f8eda..34b1a3c 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -654,7 +654,7 @@ static int open(struct tty_struct *tty, struct file *filp)
 	unsigned long flags;
 
 	line = tty->index;
-	if ((line < 0) || (line >= slgt_device_count)) {
+	if (line >= slgt_device_count) {
 		DBGERR(("%s: open with invalid line #%d.\n", driver_name, line));
 		return -ENODEV;
 	}
diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
index ddabb61..4fb6c4b 100644
--- a/drivers/tty/synclinkmp.c
+++ b/drivers/tty/synclinkmp.c
@@ -721,7 +721,7 @@ static int open(struct tty_struct *tty, struct file *filp)
 	unsigned long flags;
 
 	line = tty->index;
-	if ((line < 0) || (line >= synclinkmp_device_count)) {
+	if (line >= synclinkmp_device_count) {
 		printk("%s(%d): open with invalid line #%d.\n",
 			__FILE__,__LINE__,line);
 		return -ENODEV;
diff --git a/drivers/usb/gadget/u_serial.c b/drivers/usb/gadget/u_serial.c
index 490b01d..6c23938 100644
--- a/drivers/usb/gadget/u_serial.c
+++ b/drivers/usb/gadget/u_serial.c
@@ -725,9 +725,6 @@ static int gs_open(struct tty_struct *tty, struct file *file)
 	struct gs_port	*port;
 	int		status;
 
-	if (port_num < 0 || port_num >= n_ports)
-		return -ENXIO;
-
 	do {
 		mutex_lock(&ports[port_num].lock);
 		port = ports[port_num].port;
diff --git a/net/irda/ircomm/ircomm_tty.c b/net/irda/ircomm/ircomm_tty.c
index 828f886..6b9d5a0 100644
--- a/net/irda/ircomm/ircomm_tty.c
+++ b/net/irda/ircomm/ircomm_tty.c
@@ -365,16 +365,12 @@ static int ircomm_tty_block_til_ready(struct ircomm_tty_cb *self,
 static int ircomm_tty_open(struct tty_struct *tty, struct file *filp)
 {
 	struct ircomm_tty_cb *self;
-	unsigned int line;
+	unsigned int line = tty->index;
 	unsigned long	flags;
 	int ret;
 
 	IRDA_DEBUG(2, "%s()\n", __func__ );
 
-	line = tty->index;
-	if (line >= IRCOMM_TTY_PORTS)
-		return -ENODEV;
-
 	/* Check if instance already exists */
 	self = hashbin_lock_find(ircomm_tty, line, NULL);
 	if (!self) {
-- 
1.7.9.2


