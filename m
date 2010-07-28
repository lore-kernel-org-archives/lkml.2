Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab0G1Sir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 14:38:47 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:12619 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973Ab0G1Sip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 14:38:45 -0400
Date: Wed, 28 Jul 2010 12:38:43 -0600
From: dann frazier <dannf@hp.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, Thomas Mingarelli <thomas.mingarelli@hp.com>
Subject: Re: [PATCH 12/15] Construct status message w/ kasprintf and emit
 it with dev_info
Message-ID: <20100728183843.GD22656@ldl.fc.hp.com>
References: <1280274663-9160-1-git-send-email-dannf@hp.com>
 <1280274663-9160-13-git-send-email-dannf@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280274663-9160-13-git-send-email-dannf@hp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 05:51:00PM -0600, dann frazier wrote:
> Constructing the string dynamically w/ kasprintf will make it easier to
> ifdef-out parts of it. Also, this is for a device, so let's use
> dev_info.

A coworker caught a silly mistake in this one - I missed
freeing the buf allocated by kasprintf.

Here's a fixed patch.



Construct status message w/ kasprintf and emit it with dev_info

Constructing the string dynamically w/ kasprintf will make it easier to
ifdef-out parts of it. Also, this is for a device, so let's use dev_info.
    
Signed-off-by: dann frazier <dannf@hp.com>

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index f46e4f2..f03078d 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -658,6 +658,7 @@ static int __devinit hpwdt_init_one(struct pci_dev *dev,
 					const struct pci_device_id *ent)
 {
 	int retval;
+	char *buf;
 
 	/*
 	 * Check if we can do NMI sourcing or not
@@ -741,14 +742,17 @@ static int __devinit hpwdt_init_one(struct pci_dev *dev,
 		goto error_misc_register;
 	}
 
-	printk(KERN_INFO
-		"hp Watchdog Timer Driver: %s"
-		", timer margin: %d seconds (nowayout=%d)"
-		", allow kernel dump: %s (default = 0/OFF)"
-		", priority: %s (default = 0/LAST).\n",
-		HPWDT_VERSION, soft_margin, nowayout,
-		(allow_kdump == 0) ? "OFF" : "ON",
-		(priority == 0) ? "LAST" : "FIRST");
+	buf = kasprintf(GFP_KERNEL, "hp Watchdog Timer Driver: %s"
+			", timer margin: %d seconds (nowayout=%d)"
+			", allow kernel dump: %s (default = 0/OFF)"
+			", priority: %s (default = 0/LAST)",
+			HPWDT_VERSION, soft_margin, nowayout,
+			(allow_kdump == 0) ? "OFF" : "ON",
+			(priority == 0) ? "LAST" : "FIRST");
+	if (!buf)
+		goto error_nomem;
+	dev_info(&dev->dev, "%s.\n", buf);
+	kfree(buf);
 
 	return 0;
 
@@ -761,6 +765,7 @@ error_get_cru:
 	pci_iounmap(dev, pci_mem_addr);
 error_pci_iomap:
 	pci_disable_device(dev);
+error_nomem:
 	return retval;
 }
 
