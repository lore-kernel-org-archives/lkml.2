Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab2IUCTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 22:19:11 -0400
Received: from davicom.com.tw ([202.39.11.22]:38150 "EHLO mail.davicom.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755888Ab2IUCTI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 22:19:08 -0400
X-Greylist: delayed 1710 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Sep 2012 22:19:07 EDT
From: "Michael Chen" <michael_chen@mail.davicom.com.tw>
To: "'Arnd Bergmann'" <arnd@arndb.de>, "'Jonathan Corbet'" <corbet@lwn.net>
Cc: =?big5?B?J0FsbGVuIEh1YW5nICgitsCwtq7mIikn?= 
	<allen_huang@davicom.com.tw>,
        <linux-kernel@vger.kernel.org>,
        "'Joseph Chang'" <joseph_chang@mail.davicom.com.tw>,
        =?big5?B?J7xCpLi0vChSdXNzZWxsIExpdSkn?= 
	<russell_liu@davicom.com.tw>
Subject: RE: Davicom DM9000C driver
Date: Fri, 21 Sep 2012 09:49:23 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook, Build 11.0.5510
In-Reply-To: <201209201102.33650.arnd@arndb.de>
thread-index: Ac2XHuiNSsCAdOETQNK8cwdHv3ocJQAeL8CQ
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
Message-Id: <20120921014605.706975F94D@mail.davicom.com.tw>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Arnd and Linux Expert,

First of all, appreciate you all for your efforts on our DM9000C driver. 

Davicom Semiconductor Inc. is a fabless IC design house, located in Taiwan.
DM9000C is 10/100Mbps Ethernet IC with ISA-like interface.

Meanwhile, to facilitate the coming works with you efficiently, the key
members at Davicom side will be:
Mr. Allen Huang, PM
Mr. Russell Liu, Sr. FAE
Mr. Joseph Chang, Sr. Software Manager

Look forward to your guidance to make our product driver conform Linux.

Thanks.

BR,
Michael Chen
Director
Davicom Semiconductor Inc.
www.davicom.com.tw

-----Original Message-----
From: Arnd Bergmann [mailto:arnd@arndb.de] 
Sent: Thursday, September 20, 2012 7:03 PM
To: Jonathan Corbet
Cc: Allen Huang ("¶À°¶®æ"); linux-kernel@vger.kernel.org; 'Michael Chen';
'Charles'; 'Joseph Chang'
Subject: Re: Davicom DM9000C driver

On Thursday 20 September 2012, Arnd Bergmann wrote:
> On Wednesday 19 September 2012, Jonathan Corbet wrote:
> > On Wed, 19 Sep 2012 13:58:08 +0800
> > Allen Huang (¶À°¶®æ)  <allen_huang@davicom.com.tw> wrote:
> > 
> > > I'm Allen Huang from Davicom. We are hereby opensourcing the linux
> > > driver for our DM9000C. 
> > 
> > That is great, but please read the development process documentation on
> > how best to submit something like this.  We would much rather see a
patch
> > (inline, not as an attachment) to facilitate the review.
> 
> More importantly, the patch should be against the version that is
> already present in the kernel as drivers/net/ethernet/davicom/dm9000.c,
> which appears to be mostly the same as the version that is submitted
> here.
> 
> So while all the comments on the driver are valuable, they also apply
> to the code we already have since 2005.

For fun, I've also tracked down the version that the new submission is
branched from, it's 2.6.29 with a small number of bug fixes that
are in later version. Here is the diff against the 2.6.29 version
of the driver. There are a few changes to the PHY handling that
are not also upstream in 3.6. It's probably worth submitting them
separately with a good explanation why they are required.

	Arnd

diff --git a/drivers/net/dm9000.c b/drivers/net/dm9000.c
index 254ec62..2cd4f0b 100644
--- a/drivers/net/dm9000.c
+++ b/drivers/net/dm9000.c
@@ -17,6 +17,13 @@
  * Additional updates, Copyright:
  *	Ben Dooks <ben@simtec.co.uk>
  *	Sascha Hauer <s.hauer@pengutronix.de>
+ *  
+ * 2010.07.20 V_R1 1.Write PHY Reg27 = 0xE100
+ *								 2.Just
enable PHY once after GPIO setting in dm9000_init_dm9000()
+ *								 3.Remove
power down PHY in dm9000_shutdown()
+ * 2010.07.20 V_R2 1.Delay 20ms after PHY power on
+ *								 2.Reset PHY
after PHY power on in dm9000_init_dm9000()
+ * 2012.06.05 KT2.6.31_R2 1. Add the solution to fix the power-on FIFO data
bytes shift issue! (Wr NCR 0x03)
  */
 
 #include <linux/module.h>
@@ -25,6 +32,7 @@
 #include <linux/etherdevice.h>
 #include <linux/init.h>
 #include <linux/skbuff.h>
+#include <linux/version.h>
 #include <linux/spinlock.h>
 #include <linux/crc32.h>
 #include <linux/mii.h>
@@ -45,7 +53,7 @@
 #define DM9000_PHY		0x40	/* PHY address 0x01 */
 
 #define CARDNAME	"dm9000"
-#define DRV_VERSION	"1.31"
+#define DRV_VERSION	"2.6.31"
 
 /*
  * Transmit timeout, default 5 seconds.
@@ -126,6 +134,10 @@ typedef struct board_info {
 	u32		msg_enable;
 } board_info_t;
 
+static void
+dm9000_phy_write(struct net_device *dev,
+		 int phyaddr_unused, int reg, int value);
+
 /* debug code */
 
 #define dm9000_dbg(db, lev, msg...) do {		\
@@ -556,6 +568,18 @@ static void dm9000_show_carrier(board_info_t *db,
 		dev_info(db->dev, "%s: link down\n", ndev->name);
 }
 
+
+static unsigned char dm9000_type_to_char(enum dm9000_type type)
+{
+	switch (type) {
+	case TYPE_DM9000E: return 'e';
+	case TYPE_DM9000A: return 'a';
+	case TYPE_DM9000B: return 'b';
+	}
+
+	return '?';
+}
+
 static void
 dm9000_poll_work(struct work_struct *w)
 {
@@ -563,8 +587,11 @@ dm9000_poll_work(struct work_struct *w)
 	board_info_t *db = container_of(dw, board_info_t, phy_poll);
 	struct net_device *ndev = db->ndev;
 
-	if (db->flags & DM9000_PLATF_SIMPLE_PHY &&
-	    !(db->flags & DM9000_PLATF_EXT_PHY)) {
+//JJ2
+//	if (db->flags & DM9000_PLATF_SIMPLE_PHY &&
+//	    !(db->flags & DM9000_PLATF_EXT_PHY)) {
+//  =
+		if(1){						
 		unsigned nsr = dm9000_read_locked(db, DM9000_NSR);
 		unsigned old_carrier = netif_carrier_ok(ndev) ? 1 : 0;
 		unsigned new_carrier;
@@ -572,6 +599,12 @@ dm9000_poll_work(struct work_struct *w)
 		new_carrier = (nsr & NSR_LINKST) ? 1 : 0;
 
 		if (old_carrier != new_carrier) {
+			
+			if (new_carrier)
+			  printk(KERN_INFO "[dm9000%c %s Ethernet Driver,
V%s]: Link-Up!!\n",dm9000_type_to_char(db->type), CARDNAME, DRV_VERSION);
//JJ2
+			else
+			  printk(KERN_INFO "[%s Ethernet Driver, V%s]:
Link-Down!!\n", CARDNAME, DRV_VERSION); //JJ2
+			
 			if (netif_msg_link(db))
 				dm9000_show_carrier(db, new_carrier, nsr);
 
@@ -609,16 +642,7 @@ dm9000_release_board(struct platform_device *pdev,
struct board_info *db)
 	kfree(db->addr_req);
 }
 
-static unsigned char dm9000_type_to_char(enum dm9000_type type)
-{
-	switch (type) {
-	case TYPE_DM9000E: return 'e';
-	case TYPE_DM9000A: return 'a';
-	case TYPE_DM9000B: return 'b';
-	}
 
-	return '?';
-}
 
 /*
  *  Set DM9000 multicast address
@@ -686,12 +710,17 @@ dm9000_init_dm9000(struct net_device *dev)
 	db->io_mode = ior(db, DM9000_ISR) >> 6;	/* ISR bit7:6 keeps I/O mode
*/
 
 	/* GPIO0 on pre-activate PHY */
-	iow(db, DM9000_GPR, 0);	/* REG_1F bit0 activate phyxcer */
+//V_R1	iow(db, DM9000_GPR, 0);	/* REG_1F bit0 activate phyxcer */
 	iow(db, DM9000_GPCR, GPCR_GEP_CNTL);	/* Let GPIO0 output */
 	iow(db, DM9000_GPR, 0);	/* Enable PHY */
+        mdelay(20);  //V_R2
+
+	dm9000_phy_write(dev, 0, 0, 0x8000); //V_R2 reset PHY
+        mdelay (20);
+
 
-	if (db->flags & DM9000_PLATF_EXT_PHY)
-		iow(db, DM9000_NCR, NCR_EXT_PHY);
+//	if (db->flags & DM9000_PLATF_EXT_PHY)
+//		iow(db, DM9000_NCR, NCR_EXT_PHY);
 
 	/* Program operating register */
 	iow(db, DM9000_TCR, 0);	        /* TX Polling clear */
@@ -718,6 +747,8 @@ dm9000_init_dm9000(struct net_device *dev)
 	db->tx_pkt_cnt = 0;
 	db->queue_pkt_len = 0;
 	dev->trans_start = 0;
+	
+	dm9000_phy_write(dev, 0, 27, 0xE100); //V_R1
 }
 
 /* Our watchdog timed out. Called by the networking layer */
@@ -732,6 +763,7 @@ static void dm9000_timeout(struct net_device *dev)
 	spin_lock_irqsave(&db->lock, flags);
 
 	netif_stop_queue(dev);
+	printk(KERN_INFO "[%s Ethernet Driver, V%s]: Timeout!!\n", CARDNAME,
DRV_VERSION); //JJ1
 	dm9000_reset(db);
 	dm9000_init_dm9000(dev);
 	/* We can accept TX packets again */
@@ -888,6 +920,7 @@ dm9000_rx(struct net_device *dev)
 				if (netif_msg_rx_err(db))
 					dev_dbg(db->dev, "fifo error\n");
 				dev->stats.rx_fifo_errors++;
+				printk(KERN_INFO "[%s Ethernet Driver, V%s]:
FIFO Over Flow!!\n", CARDNAME, DRV_VERSION); //JJ1
 			}
 			if (rxhdr.RxStatus & RSR_CE) {
 				if (netif_msg_rx_err(db))
@@ -974,7 +1007,7 @@ static irqreturn_t dm9000_interrupt(int irq, void
*dev_id)
 	/* Restore previous register address */
 	writeb(reg_save, db->io_addr);
 
-	spin_unlock_irqrestore(&db->lock, flags);
+	 spin_unlock_irqrestore(&db->lock, flags);
 
 	return IRQ_HANDLED;
 }
@@ -1140,7 +1173,7 @@ dm9000_shutdown(struct net_device *dev)
 
 	/* RESET device */
 	dm9000_phy_write(dev, 0, MII_BMCR, BMCR_RESET);	/* PHY RESET */
-	iow(db, DM9000_GPR, 0x01);	/* Power-Down PHY */
+//V_R1	iow(db, DM9000_GPR, 0x01);	/* Power-Down PHY */
 	iow(db, DM9000_IMR, IMR_PAR);	/* Disable all interrupt */
 	iow(db, DM9000_RCR, 0x00);	/* Disable RX */
 }
@@ -1172,6 +1205,22 @@ dm9000_stop(struct net_device *ndev)
 
 #define res_size(_r) (((_r)->end - (_r)->start) + 1)
 
+static const struct net_device_ops dm9000_netdev_ops = {
+         .ndo_open = dm9000_open,
+         .ndo_stop = dm9000_stop,
+         .ndo_start_xmit = dm9000_start_xmit,
+         .ndo_tx_timeout = dm9000_timeout,
+         .ndo_set_multicast_list = dm9000_hash_table,
+         .ndo_do_ioctl = dm9000_ioctl,
+         .ndo_change_mtu = eth_change_mtu,
+         .ndo_validate_addr = eth_validate_addr,
+         .ndo_set_mac_address = eth_mac_addr,
+    #ifdef CONFIG_NET_POLL_CONTROLLER
+         .ndo_poll_controller = dm9000_poll_controller,
+    #endif
+};
+
+
 /*
  * Search DM9000 board, allocate space and register it
  */
@@ -1197,7 +1246,7 @@ dm9000_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 
 	dev_dbg(&pdev->dev, "dm9000_probe()\n");
-
+	 ndev->netdev_ops = &dm9000_netdev_ops;
 	/* setup board info structure */
 	db = netdev_priv(ndev);
 	memset(db, 0, sizeof(*db));
@@ -1260,6 +1309,8 @@ dm9000_probe(struct platform_device *pdev)
 	/* fill in parameters for net-dev structure */
 	ndev->base_addr = (unsigned long)db->io_addr;
 	ndev->irq	= db->irq_res->start;
+	//Stone add
+	printk("[dm9] %s ndev->irq=%x \n",__func__,ndev->irq);
 
 	/* ensure at least we have a default set of IO routines */
 	dm9000_set_io(db, iosize);
@@ -1297,7 +1348,9 @@ dm9000_probe(struct platform_device *pdev)
 	db->flags |= DM9000_PLATF_SIMPLE_PHY;
 #endif
 
-	dm9000_reset(db);
+//Stone add
+//	dm9000_reset(db);
+  iow(db, DM9000_NCR, 0x03);
 
 	/* try multiple times, DM9000 sometimes gets the read wrong */
 	for (i = 0; i < 8; i++) {
@@ -1306,10 +1359,18 @@ dm9000_probe(struct platform_device *pdev)
 		id_val |= (u32)ior(db, DM9000_PIDL) << 16;
 		id_val |= (u32)ior(db, DM9000_PIDH) << 24;
 
+		printk("[dm9].%d read id 0x%08x\n", i+1, id_val);
+		
 		if (id_val == DM9000_ID)
 			break;
 		dev_err(db->dev, "read wrong id 0x%08x\n", id_val);
 	}
+	
+	printk(KERN_INFO "[%s Ethernet Driver, V%s]: KV= %d.%d.%d !!\n",
CARDNAME, DRV_VERSION,  //JJ1 
+	                            (LINUX_VERSION_CODE>>16 & 0xff),
+	                            (LINUX_VERSION_CODE>>8 & 0xff),
+	                            (LINUX_VERSION_CODE & 0xff) ); //#define
KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))
+	printk(KERN_INFO "[%s Ethernet Driver, V%s]: ChipID= 0x%x !!\n",
CARDNAME, DRV_VERSION, id_val ); // JJ1
 
 	if (id_val != DM9000_ID) {
 		dev_err(db->dev, "wrong id: 0x%08x\n", id_val);
@@ -1321,6 +1382,7 @@ dm9000_probe(struct platform_device *pdev)
 
 	id_val = ior(db, DM9000_CHIPR);
 	dev_dbg(db->dev, "dm9000 revision 0x%02x\n", id_val);
+	printk(KERN_INFO "[DM9000]dm9000 revision 0x%02x\n", id_val); //V_R1
 
 	switch (id_val) {
 	case CHIPR_DM9000A:
@@ -1338,7 +1400,12 @@ dm9000_probe(struct platform_device *pdev)
 
 	/* driver system function */
 	ether_setup(ndev);
-
+	
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31)
+			ndev->netdev_ops = &dm9000_netdev_ops; // new kernel
2.6.31 
+			ndev->watchdog_timeo	=
msecs_to_jiffies(watchdog);	
+	 		ndev->ethtool_ops	 = &dm9000_ethtool_ops;
+#else
 	ndev->open		 = &dm9000_open;
 	ndev->hard_start_xmit    = &dm9000_start_xmit;
 	ndev->tx_timeout         = &dm9000_timeout;
@@ -1347,6 +1414,8 @@ dm9000_probe(struct platform_device *pdev)
 	ndev->set_multicast_list = &dm9000_hash_table;
 	ndev->ethtool_ops	 = &dm9000_ethtool_ops;
 	ndev->do_ioctl		 = &dm9000_ioctl;
+#endif
+
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	ndev->poll_controller	 = &dm9000_poll_controller;
@@ -1376,8 +1445,16 @@ dm9000_probe(struct platform_device *pdev)
 		/* try reading from mac */
 		
 		mac_src = "chip";
+
+		static unsigned char mac_addr[6] =
{0x00,0x11,0x22,0x33,0x44,0x55};
+		static unsigned char mac_tmp[6] = {0xff,0xff,0xff,0xff,0xff,
0xff};
 		for (i = 0; i < 6; i++)
 			ndev->dev_addr[i] = ior(db, i+DM9000_PAR);
+
+		// Mark Chang 20100521
+		// -------------------
+		if (!memcmp(ndev->dev_addr, mac_tmp, 6))
+			memcpy(ndev->dev_addr, mac_addr, 6);
 	}
 
 	if (!is_valid_ether_addr(ndev->dev_addr))
diff --git a/drivers/net/dm9000.h b/drivers/net/dm9000.h
index ba25cf5..81dc979 100644
--- a/drivers/net/dm9000.h
+++ b/drivers/net/dm9000.h
@@ -46,7 +46,7 @@
 #define DM9000_SMCR            0x2F
 
 #define CHIPR_DM9000A	       0x19
-#define CHIPR_DM9000B	       0x1B
+#define CHIPR_DM9000B	       0x1A  //V_R1 0x1B
 
 #define DM9000_MRCMDX          0xF0
 #define DM9000_MRCMD           0xF2

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

