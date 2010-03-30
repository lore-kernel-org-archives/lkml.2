Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab0C3RdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 13:33:16 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:57936 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab0C3RdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 13:33:14 -0400
Message-ID: <4BB23594.1090506@oracle.com>
Date: Tue, 30 Mar 2010 10:32:04 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Jean-Francois Moine <moinejf@free.fr>,
       Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH -next] gspca: fix build for INPUT=m or INPUT=n
References: <20100330191834.f2009292.sfr@canb.auug.org.au>
In-Reply-To: <20100330191834.f2009292.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4BB235D1.00B4:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Handle case of GSPCA=m, INPUT=m when building gspca core;
also handle case of INPUT=n by using stubs.

drivers/media/video/gspca/gspca.c:662: error: implicit declaration of function 'gspca_input_destroy_urb'
drivers/media/video/gspca/gspca.c:668: error: implicit declaration of function 'gspca_input_create_urb'
drivers/media/video/gspca/gspca.c:2284: error: implicit declaration of function 'gspca_input_connect'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/video/gspca/gspca.c |   23 ++++++++++++++++++-----
 drivers/media/video/gspca/gspca.h |    6 +++---
 2 files changed, 21 insertions(+), 8 deletions(-)

--- linux-next-20100330.orig/drivers/media/video/gspca/gspca.c
+++ linux-next-20100330/drivers/media/video/gspca/gspca.c
@@ -40,7 +40,7 @@
 
 #include "gspca.h"
 
-#ifdef CONFIG_INPUT
+#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
 #include <linux/input.h>
 #include <linux/usb/input.h>
 #endif
@@ -115,7 +115,7 @@ static const struct vm_operations_struct
 /*
  * Input and interrupt endpoint handling functions
  */
-#ifdef CONFIG_INPUT
+#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
 static void int_irq(struct urb *urb)
 {
 	struct gspca_dev *gspca_dev = (struct gspca_dev *) urb->context;
@@ -279,6 +279,19 @@ static void gspca_input_destroy_urb(stru
 		usb_free_urb(urb);
 	}
 }
+#else
+static inline void gspca_input_destroy_urb(struct gspca_dev *gspca_dev)
+{
+}
+
+static inline void gspca_input_create_urb(struct gspca_dev *gspca_dev)
+{
+}
+
+static inline int gspca_input_connect(struct gspca_dev *dev)
+{
+	return 0;
+}
 #endif
 
 /* get the current input frame buffer */
@@ -2310,7 +2323,7 @@ int gspca_dev_probe(struct usb_interface
 
 	return 0;
 out:
-#ifdef CONFIG_INPUT
+#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
 	if (gspca_dev->input_dev)
 		input_unregister_device(gspca_dev->input_dev);
 #endif
@@ -2329,7 +2342,7 @@ EXPORT_SYMBOL(gspca_dev_probe);
 void gspca_disconnect(struct usb_interface *intf)
 {
 	struct gspca_dev *gspca_dev = usb_get_intfdata(intf);
-#ifdef CONFIG_INPUT
+#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
 	struct input_dev *input_dev;
 #endif
 
@@ -2343,7 +2356,7 @@ void gspca_disconnect(struct usb_interfa
 		wake_up_interruptible(&gspca_dev->wq);
 	}
 
-#ifdef CONFIG_INPUT
+#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
 	gspca_input_destroy_urb(gspca_dev);
 	input_dev = gspca_dev->input_dev;
 	if (input_dev) {
--- linux-next-20100330.orig/drivers/media/video/gspca/gspca.h
+++ linux-next-20100330/drivers/media/video/gspca/gspca.h
@@ -130,7 +130,7 @@ struct sd_desc {
 	cam_reg_op get_register;
 #endif
 	cam_ident_op get_chip_ident;
-#ifdef CONFIG_INPUT
+#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
 	cam_int_pkt_op int_pkt_scan;
 	/* other_input makes the gspca core create gspca_dev->input even when
 	   int_pkt_scan is NULL, for cams with non interrupt driven buttons */
@@ -158,7 +158,7 @@ struct gspca_dev {
 	struct module *module;		/* subdriver handling the device */
 	struct usb_device *dev;
 	struct file *capt_file;		/* file doing video capture */
-#ifdef CONFIG_INPUT
+#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
 	struct input_dev *input_dev;
 	char phys[64];			/* physical device path */
 #endif
@@ -171,7 +171,7 @@ struct gspca_dev {
 #define USB_BUF_SZ 64
 	__u8 *usb_buf;				/* buffer for USB exchanges */
 	struct urb *urb[MAX_NURBS];
-#ifdef CONFIG_INPUT
+#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
 	struct urb *int_urb;
 #endif
 
