Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab0EVNYK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 09:24:10 -0400
Received: from nexus.tmp.com.br ([200.255.204.22]:1907 "EHLO nexus.tmp.com.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222Ab0EVNYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 09:24:06 -0400
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 May 2010 09:24:06 EDT
Date: Sat, 22 May 2010 10:17:14 -0300
From: Durval Menezes <durval@tmp.com.br>
To: linux-kernel@vger.kernel.org
Subject: [2.6.32.13 patch] compiling with GCC3, and why I think that's still relevant
Message-ID: <20100522101714.N3117@tmp.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Mailer: Mutt 1.0i
X-URL: http://www.tmp.com.br
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Below please find a patch to enable compilation of the stock 2.6.32.13
linux kernel using GCC3; With it, I have been able to compile and run
that kernel without any problems on my Thinkpad R60 laptop, running an
otherwise almost-standard RHEL4.8.

Regarding the recent discussion about support for compiling the kernel
with GCC3 on x86, I would like to add my opinion that, if it's not too
costly in terms of development effort, then it's something worth keeping.
I for one keep many machines running older distros with more modern
kernels, and I suspect that my situation is far from being uncommon.

Best Regards,
-- 
   Durval Menezes (durval AT tmp DOT com DOT br, http://www.tmp.com.br/)

#Sat May 22 08:09:02 BRT 2010
#Fixes for some source files on Linux 2.6.32.12 so t will compile with gcc3
#(more specifically, gcc 3.4.6 which comes with RHEL/CentOS 4.8)
# -- Durval Menezes (durval AT tmp DOT com DOT br)

--- ./drivers/media/dvb/frontends/lgs8gxx.c.orig-20100521	2009-12-03 01:51:21.000000000 -0200
+++ ./drivers/media/dvb/frontends/lgs8gxx.c	2010-05-21 08:35:35.000000000 -0300
@@ -199,7 +199,8 @@
 
 	val = freq;
 	if (freq != 0) {
-		val *= (u64)1 << 32;
+		// val *= (u64)1 << 32;
+		val <<= 32;
 		if (if_clk != 0)
 			do_div(val, if_clk);
 		v32 = val & 0xFFFFFFFF;
@@ -246,7 +247,8 @@
 
 	val = v32;
 	val *= priv->config->if_clk_freq;
-	val /= (u64)1 << 32;
+	// val /= (u64)1 << 32;
+	val >>= 32;
 	dprintk("AFC = %u kHz\n", (u32)val);
 	return 0;
 }
--- ./drivers/message/fusion/mptsas.c.orig-20100507	2009-12-03 01:51:21.000000000 -0200
+++ ./drivers/message/fusion/mptsas.c	2010-05-07 15:01:00.000000000 -0300
@@ -1,3 +1,8 @@
+/* 2010/05/07 moved mptsas_set_rphy() function definition  from after
+**	to before function mptsas_port_delete() (Durval Menezes, instructed by
+**	http://mekaananth.blogspot.com/2009/09/how-to-compile-linux-kernel-2631.html)
+*/
+
 /*
  *  linux/drivers/message/fusion/mptsas.c
  *      For use with LSI PCI chip/adapter(s)
@@ -436,6 +441,23 @@
 		return 0;
 }
 
+static inline void
+mptsas_set_rphy(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info, struct sas_rphy *rphy)
+{
+	if (phy_info->port_details) {
+		phy_info->port_details->rphy = rphy;
+		dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT "sas_rphy_add: rphy=%p\n",
+		    ioc->name, rphy));
+	}
+
+	if (rphy) {
+		dsaswideprintk(ioc, dev_printk(KERN_DEBUG,
+		    &rphy->dev, MYIOC_s_FMT "add:", ioc->name));
+		dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT "rphy=%p release=%p\n",
+		    ioc->name, rphy, rphy->dev.release));
+	}
+}
+
 /* no mutex */
 static void
 mptsas_port_delete(MPT_ADAPTER *ioc, struct mptsas_portinfo_details * port_details)
@@ -474,23 +496,6 @@
 		return NULL;
 }
 
-static inline void
-mptsas_set_rphy(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info, struct sas_rphy *rphy)
-{
-	if (phy_info->port_details) {
-		phy_info->port_details->rphy = rphy;
-		dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT "sas_rphy_add: rphy=%p\n",
-		    ioc->name, rphy));
-	}
-
-	if (rphy) {
-		dsaswideprintk(ioc, dev_printk(KERN_DEBUG,
-		    &rphy->dev, MYIOC_s_FMT "add:", ioc->name));
-		dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT "rphy=%p release=%p\n",
-		    ioc->name, rphy, rphy->dev.release));
-	}
-}
-
 static inline struct sas_port *
 mptsas_get_port(struct mptsas_phyinfo *phy_info)
 {
--- ./drivers/staging/quatech_usb2/quatech_usb2.c.orig-20100510	2009-12-03 01:51:21.000000000 -0200
+++ ./drivers/staging/quatech_usb2/quatech_usb2.c	2010-05-21 08:09:41.000000000 -0300
@@ -271,6 +271,30 @@
 			 unsigned short stop);
 
 /* implementation functions, roughly in order of use, are here */
+static inline void qt2_set_dev_private(struct usb_serial *serial,
+		struct quatech2_dev *data)
+{
+	usb_set_serial_data(serial, (void *)data);
+}
+
+static inline struct quatech2_port *qt2_get_port_private(struct usb_serial_port
+		*port)
+{
+	return (struct quatech2_port *)usb_get_serial_port_data(port);
+}
+
+static inline void qt2_set_port_private(struct usb_serial_port *port,
+		struct quatech2_port *data)
+{
+	usb_set_serial_port_data(port, (void *)data);
+}
+
+static inline struct quatech2_dev *qt2_get_dev_private(struct usb_serial
+		*serial)
+{
+	return (struct quatech2_dev *)usb_get_serial_data(serial);
+}
+
 static int qt2_calc_num_ports(struct usb_serial *serial)
 {
 	int num_ports;
@@ -1358,29 +1382,6 @@
 	return 0;
 }
 
-static inline struct quatech2_port *qt2_get_port_private(struct usb_serial_port
-		*port)
-{
-	return (struct quatech2_port *)usb_get_serial_port_data(port);
-}
-
-static inline void qt2_set_port_private(struct usb_serial_port *port,
-		struct quatech2_port *data)
-{
-	usb_set_serial_port_data(port, (void *)data);
-}
-
-static inline struct quatech2_dev *qt2_get_dev_private(struct usb_serial
-		*serial)
-{
-	return (struct quatech2_dev *)usb_get_serial_data(serial);
-}
-static inline void qt2_set_dev_private(struct usb_serial *serial,
-		struct quatech2_dev *data)
-{
-	usb_set_serial_data(serial, (void *)data);
-}
-
 static int qt2_openboxchannel(struct usb_serial *serial, __u16
 		Uart_Number, struct qt2_status_data *status)
 {
--- ./drivers/staging/rt3090/config.mk.orig-20100521	2009-12-03 01:51:21.000000000 -0200
+++ ./drivers/staging/rt3090/config.mk	2010-05-21 08:14:25.000000000 -0300
@@ -87,7 +87,7 @@
 HAS_ANTENNA_DIVERSITY_SUPPORT=y
 #################################################
 
-WFLAGS := -DAGGREGATION_SUPPORT -DPIGGYBACK_SUPPORT -DWMM_SUPPORT  -DLINUX -Wall -Wstrict-prototypes -Wno-trigraphs -Wpointer-sign
+WFLAGS := -DAGGREGATION_SUPPORT -DPIGGYBACK_SUPPORT -DWMM_SUPPORT  -DLINUX -Wall -Wstrict-prototypes -Wno-trigraphs 
 
 ifeq ($(HAS_KTHREAD_SUPPORT),y)
 WFLAGS += -DKTHREAD_SUPPORT
