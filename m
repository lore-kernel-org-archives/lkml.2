Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199Ab1DLOzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:55:08 -0400
Received: from kroah.org ([198.145.64.141]:57482 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932093Ab1DLOhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:37:51 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:51 2011
Message-Id: <20110412143550.930494030@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yinghai Lu <yinghai@kernel.org>, Mike Waychison <mikew@google.com>,
        Wim Van Sebroeck <wim@iguana.be>
Subject: [028/105] watchdog: sp5100_tco.c: Check if firmware has set correct value in tcobase.
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit 90d241edd13bdeef70f264b569f7e150bf23621e upstream.

Stefano found SP5100 TCO watchdog driver using wrong address.

[    9.148536] SP5100 TCO timer: SP5100 TCO WatchDog Timer Driver v0.01
[    9.148628] DEBUG __ioremap_caller WARNING address=b8fe00 size=8 valid=1 reserved=1

and e820 said that range is RAM.

We should check if we can use that reading out. BIOS could just program wrong address there.

Reported-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by:Yinghai Lu <yinghai@kernel.org>
Acked-by: Mike Waychison <mikew@google.com>
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/watchdog/sp5100_tco.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/watchdog/sp5100_tco.c
+++ b/drivers/watchdog/sp5100_tco.c
@@ -42,6 +42,7 @@
 #define PFX TCO_MODULE_NAME ": "
 
 /* internal variables */
+static u32 tcobase_phys;
 static void __iomem *tcobase;
 static unsigned int pm_iobase;
 static DEFINE_SPINLOCK(tco_lock);	/* Guards the hardware */
@@ -305,10 +306,18 @@ static unsigned char __devinit sp5100_tc
 	/* Low three bits of BASE0 are reserved. */
 	val = val << 8 | (inb(SP5100_IO_PM_DATA_REG) & 0xf8);
 
+	if (!request_mem_region_exclusive(val, SP5100_WDT_MEM_MAP_SIZE,
+								"SP5100 TCO")) {
+		printk(KERN_ERR PFX "mmio address 0x%04x already in use\n",
+			val);
+		goto unreg_region;
+	}
+	tcobase_phys = val;
+
 	tcobase = ioremap(val, SP5100_WDT_MEM_MAP_SIZE);
 	if (tcobase == 0) {
 		printk(KERN_ERR PFX "failed to get tcobase address\n");
-		goto unreg_region;
+		goto unreg_mem_region;
 	}
 
 	/* Enable watchdog decode bit */
@@ -346,7 +355,8 @@ static unsigned char __devinit sp5100_tc
 	/* Done */
 	return 1;
 
-	iounmap(tcobase);
+unreg_mem_region:
+	release_mem_region(tcobase_phys, SP5100_WDT_MEM_MAP_SIZE);
 unreg_region:
 	release_region(pm_iobase, SP5100_PM_IOPORTS_SIZE);
 exit:
@@ -401,6 +411,7 @@ static int __devinit sp5100_tco_init(str
 
 exit:
 	iounmap(tcobase);
+	release_mem_region(tcobase_phys, SP5100_WDT_MEM_MAP_SIZE);
 	release_region(pm_iobase, SP5100_PM_IOPORTS_SIZE);
 	return ret;
 }
@@ -414,6 +425,7 @@ static void __devexit sp5100_tco_cleanup
 	/* Deregister */
 	misc_deregister(&sp5100_tco_miscdev);
 	iounmap(tcobase);
+	release_mem_region(tcobase_phys, SP5100_WDT_MEM_MAP_SIZE);
 	release_region(pm_iobase, SP5100_PM_IOPORTS_SIZE);
 }
 


