Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872Ab1FPTd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 15:33:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:16519 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757771Ab1FPTdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 15:33:24 -0400
Date: Thu, 16 Jun 2011 12:31:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Sedat Dilek <sedat.dilek@googlemail.com>, linux-geode@lists.infradead.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH] gx1fb: Fix section mismatch warnings
Message-Id: <20110616123119.6ca873fa.randy.dunlap@oracle.com>
In-Reply-To: <20110106063906.GB15340@linux-sh.org>
References: <1294018289-3911-1-git-send-email-sedat.dilek@gmail.com>
	<20110106063906.GB15340@linux-sh.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090205.4DFA5A7A.01B4:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jan 2011 15:39:07 +0900 Paul Mundt wrote:

> The problem seems to be because gx1fb_probe is annotated __init. In the
> PCI case you want it to be __devinit, and you're also going to want to
> annotate the remove function as __devexit and wrap it up with a
> __devexit_p().
> --

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix a chain of section mismatches in geode driver, beginning with:

WARNING: drivers/video/geode/gx1fb.o(.data+0x70): Section mismatch in reference from the variable gx1fb_driver to the function .init.text:gx1fb_probe()
The variable gx1fb_driver references
the function __init gx1fb_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

Making the changes that Paul pointed out resulted in a few more
changes being needed, so they are all included here.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/video/geode/gx1fb_core.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- lnx-30-rc3.orig/drivers/video/geode/gx1fb_core.c
+++ lnx-30-rc3/drivers/video/geode/gx1fb_core.c
@@ -29,7 +29,7 @@ static int  crt_option = 1;
 static char panel_option[32] = "";
 
 /* Modes relevant to the GX1 (taken from modedb.c) */
-static const struct fb_videomode __initdata gx1_modedb[] = {
+static const struct fb_videomode __devinitdata gx1_modedb[] = {
 	/* 640x480-60 VESA */
 	{ NULL, 60, 640, 480, 39682,  48, 16, 33, 10, 96, 2,
 	  0, FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
@@ -195,7 +195,7 @@ static int gx1fb_blank(int blank_mode, s
 	return par->vid_ops->blank_display(info, blank_mode);
 }
 
-static int __init gx1fb_map_video_memory(struct fb_info *info, struct pci_dev *dev)
+static int __devinit gx1fb_map_video_memory(struct fb_info *info, struct pci_dev *dev)
 {
 	struct geodefb_par *par = info->par;
 	unsigned gx_base;
@@ -268,7 +268,7 @@ static struct fb_ops gx1fb_ops = {
 	.fb_imageblit	= cfb_imageblit,
 };
 
-static struct fb_info * __init gx1fb_init_fbinfo(struct device *dev)
+static struct fb_info * __devinit gx1fb_init_fbinfo(struct device *dev)
 {
 	struct geodefb_par *par;
 	struct fb_info *info;
@@ -318,7 +318,7 @@ static struct fb_info * __init gx1fb_ini
 	return info;
 }
 
-static int __init gx1fb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+static int __devinit gx1fb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct geodefb_par *par;
 	struct fb_info *info;
@@ -382,7 +382,7 @@ static int __init gx1fb_probe(struct pci
 	return ret;
 }
 
-static void gx1fb_remove(struct pci_dev *pdev)
+static void __devexit gx1fb_remove(struct pci_dev *pdev)
 {
 	struct fb_info *info = pci_get_drvdata(pdev);
 	struct geodefb_par *par = info->par;
@@ -441,7 +441,7 @@ static struct pci_driver gx1fb_driver = 
 	.name		= "gx1fb",
 	.id_table	= gx1fb_id_table,
 	.probe		= gx1fb_probe,
-	.remove		= gx1fb_remove,
+	.remove		= __devexit_p(gx1fb_remove),
 };
 
 static int __init gx1fb_init(void)
@@ -456,7 +456,7 @@ static int __init gx1fb_init(void)
 	return pci_register_driver(&gx1fb_driver);
 }
 
-static void __exit gx1fb_cleanup(void)
+static void __devexit gx1fb_cleanup(void)
 {
 	pci_unregister_driver(&gx1fb_driver);
 }
