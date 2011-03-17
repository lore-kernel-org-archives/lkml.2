Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab1CQDBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 23:01:40 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27699 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab1CQDBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 23:01:37 -0400
Message-ID: <4D817973.7000407@kernel.org>
Date: Wed, 16 Mar 2011 20:01:07 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Mike Waychison <mikew@google.com>, Wim Van Sebroeck <wim@iguana.be>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        linux-watchdog@vger.kernel.org, Priyanka Gupta <priyankag@google.com>
Subject: [PATCH -v3] watchdog, SP5100: Check if firmware has set correct value
 in tcobase.
References: <alpine.DEB.2.00.1103111201470.2968@kaball-desktop> <20110311222129.GA3168@dumpdata.com> <alpine.DEB.2.00.1103161150010.3382@kaball-desktop> <alpine.DEB.2.00.1103161442210.3382@kaball-desktop> <4D80F992.10603@kernel.org> <alpine.DEB.2.00.1103161757040.3382@kaball-desktop> <4D812180.5030102@kernel.org> <AANLkTimNva3c_-kGA+JLCPZgrKAbwqLKaN559cwTh7cq@mail.gmail.com> <4D812919.30706@kernel.org> <20110317022331.GA3528@dumpdata.com>
In-Reply-To: <20110317022331.GA3528@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D817986.0003,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Stefano found SP5100 TCO watchdog driver using wrong address.

[    9.148536] SP5100 TCO timer: SP5100 TCO WatchDog Timer Driver v0.01
[    9.148628] DEBUG __ioremap_caller WARNING address=b8fe00 size=8 valid=1 reserved=1

and e820 said that range is RAM.

We should check if we can use that reading out. BIOS could just program wrong address there.

-v2: Mike pointed out one path need one release.
-v3: corrected logic checking with request_mem_region_exclusive()
      Found by Konrad.


Reported-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by:Yinghai Lu <yinghai@kernel.org>
Acked-by: Mike Waychison <mikew@google.com>
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

---
  drivers/watchdog/sp5100_tco.c |   14 ++++++++++++--
  1 file changed, 12 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/watchdog/sp5100_tco.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/sp5100_tco.c
+++ linux-2.6/drivers/watchdog/sp5100_tco.c
@@ -42,6 +42,7 @@
  #define PFX TCO_MODULE_NAME ": "
  
  /* internal variables */
+static u32 tcobase_phys;
  static void __iomem *tcobase;
  static unsigned int pm_iobase;
  static DEFINE_SPINLOCK(tco_lock);	/* Guards the hardware */
@@ -305,10 +306,16 @@ static unsigned char __devinit sp5100_tc
  	/* Low three bits of BASE0 are reserved. */
  	val = val << 8 | (inb(SP5100_IO_PM_DATA_REG) & 0xf8);
  
+	if (!request_mem_region_exclusive(val, SP5100_WDT_MEM_MAP_SIZE, "SP5100 TCO")) {
+		printk(KERN_ERR PFX "mmio address 0x%04x already in use\n", val);
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
@@ -346,7 +353,8 @@ static unsigned char __devinit sp5100_tc
  	/* Done */
  	return 1;
  
-	iounmap(tcobase);
+unreg_mem_region:
+	release_mem_region(tcobase_phys, SP5100_WDT_MEM_MAP_SIZE);
  unreg_region:
  	release_region(pm_iobase, SP5100_PM_IOPORTS_SIZE);
  exit:
@@ -401,6 +409,7 @@ static int __devinit sp5100_tco_init(str
  
  exit:
  	iounmap(tcobase);
+	release_mem_region(tcobase_phys, SP5100_WDT_MEM_MAP_SIZE);
  	release_region(pm_iobase, SP5100_PM_IOPORTS_SIZE);
  	return ret;
  }
@@ -414,6 +423,7 @@ static void __devexit sp5100_tco_cleanup
  	/* Deregister */
  	misc_deregister(&sp5100_tco_miscdev);
  	iounmap(tcobase);
+	release_mem_region(tcobase_phys, SP5100_WDT_MEM_MAP_SIZE);
  	release_region(pm_iobase, SP5100_PM_IOPORTS_SIZE);
  }
  
