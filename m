Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab0DBWRF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 18:17:05 -0400
Received: from p01c12o144.mxlogic.net ([208.65.145.67]:49045 "EHLO
	p01c12o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab0DBWQ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 18:16:57 -0400
X-MXL-Hash: 4bb66cd9530f52d3-bb6d65cc93703fd0d897d8276b5cdd54c4b809ba
X-MXL-Hash: 4bb66cd42dff1e01-16a2b73bb0cc890613e9095077c8ad43306707a3
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>
CC: David Woodhouse <dwmw2@infradead.org>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Date: Fri, 2 Apr 2010 17:16:27 -0500
Subject: RE: BUG: physmap modprobe & rmmod
Thread-Topic: BUG: physmap modprobe & rmmod
Thread-Index: AcrSrvrpGOM+Z0x0Rc25T1vnD0oVHAAAH+vg
Message-ID: <0D753D10438DA54287A00B0270842697636A7E9CF1@AUSP01VMBX24.collaborationhost.net>
References: <20100402134058.c4682716.randy.dunlap@oracle.com>
 <20100402144727.2c80a6b2.randy.dunlap@oracle.com>
In-Reply-To: <20100402144727.2c80a6b2.randy.dunlap@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010040101)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.180]
X-AnalysisOut: [v=1.0 c=1 a=VphdPIyG4kEA:10 a=kj9zAlcOel0A:10 a=38uLcFpo6n]
X-AnalysisOut: [JaFUi5eYvXHw==:17 a=i00gxMtYAAAA:8 a=GgcTZRFqIW8b2UqNVbAA:]
X-AnalysisOut: [9 a=ZHTJMDathjNmkwNySr4A:7 a=iwt-rlhAmAK0i3JyYeUgq3-KgzYA:]
X-AnalysisOut: [4 a=CjuIK1q_8ugA:10 a=x1WnkoZAwusA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 02, 2010 2:47 PM, Randy Dunlap wrote:
>> 2.6.34-rc2 kernel:
>> 
>> Boot up on a common PC, then: modprobe physmap ; rmmod physmap
>> and bang.

[snip]

> This is with close to an allmodconfig on x86_64, including:
> 
> CONFIG_MTD_PHYSMAP=m
> CONFIG_MTD_PHYSMAP_COMPAT=y
> CONFIG_MTD_PHYSMAP_START=0x8000000
> CONFIG_MTD_PHYSMAP_LEN=0
> CONFIG_MTD_PHYSMAP_BANKWIDTH=2

That's probably the cause of the BUG.

If your not run-time calling physmap_configure(), your resource will
be created as:

static struct physmap_flash_data physmap_flash_data = {
	.width		= CONFIG_MTD_PHYSMAP_BANKWIDTH,
};

static struct resource physmap_flash_resource = {
	.start		= CONFIG_MTD_PHYSMAP_START,
	.end		= CONFIG_MTD_PHYSMAP_START + CONFIG_MTD_PHYSMAP_LEN - 1,
	.flags		= IORESOURCE_MEM,
};

In other words:

static struct physmap_flash_data physmap_flash_data = {
	.width		= 2,
};

static struct resource physmap_flash_resource = {
	.start		= 0x8000000,
	.end		= 0x8000000 + 0 - 1,
	.flags		= IORESOURCE_MEM,
};

I don't think your even getting into the physmap_flash_probe routine.
Your probably getting the BUG after:

	platform_device_register(&physmap_flash);

Which eventually gets to platform_device_add which is giving you the
message:

> [  127.869454] physmap-flash.0: failed to claim resource 0

Try this patch to see if it fixes your BUG.

---

mtd/maps/physmap: catch failure to register MTD_PHYSMAP_COMPAT device

If the default Kconfig values are used with MTD_PHYSMAP_COMPAT you end
up with a IORESOURCE_MEM of 0 size.  This causes platform_device_add
to fail during the platform_device_register call.

Catch this failure during the physmap_init.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/drivers/mtd/maps/physmap.c b/drivers/mtd/maps/physmap.c
index d9603f7..426461a 100644
--- a/drivers/mtd/maps/physmap.c
+++ b/drivers/mtd/maps/physmap.c
@@ -264,8 +264,11 @@ static int __init physmap_init(void)
 
 	err = platform_driver_register(&physmap_flash_driver);
 #ifdef CONFIG_MTD_PHYSMAP_COMPAT
-	if (err == 0)
-		platform_device_register(&physmap_flash);
+	if (err == 0) {
+		err = platform_device_register(&physmap_flash);
+		if (err)
+			platform_driver_unregister(&physmap_flash_driver);
+	}
 #endif
 
 	return err;
