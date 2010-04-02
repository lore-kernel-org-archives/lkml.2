Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab0DBWlj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 18:41:39 -0400
Received: from p01c11o142.mxlogic.net ([208.65.144.65]:46586 "EHLO
	p01c11o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515Ab0DBWle convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 18:41:34 -0400
X-MXL-Hash: 4bb6729e2988c40a-e4ed9ec2088395b57db8a0070e2fe71b8ff42056
X-MXL-Hash: 4bb6729b257fb99d-d861baed7052832f35c4e552713b68ed9bacd068
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>
CC: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
Date: Fri, 2 Apr 2010 17:41:25 -0500
Subject: RE: BUG: physmap modprobe & rmmod
Thread-Topic: BUG: physmap modprobe & rmmod
Thread-Index: AcrSrvrpGOM+Z0x0Rc25T1vnD0oVHAAAH+vgAAFOs2A=
Message-ID: <0D753D10438DA54287A00B0270842697636A7E9D2C@AUSP01VMBX24.collaborationhost.net>
References: <20100402134058.c4682716.randy.dunlap@oracle.com>
	<20100402144727.2c80a6b2.randy.dunlap@oracle.com>
 <0D753D10438DA54287A00B0270842697636A7E9CF1@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <0D753D10438DA54287A00B0270842697636A7E9CF1@AUSP01VMBX24.collaborationhost.net>
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
X-AnalysisOut: [JaFUi5eYvXHw==:17 a=i00gxMtYAAAA:8 a=JfrnYn6hAAAA:8 a=C3wB]
X-AnalysisOut: [KfkCCAMuZZXFDB8A:9 a=HlEF60PEM3inU4L1ln0A:7 a=iYgxBEknBRlQ]
X-AnalysisOut: [KZNyK1L0AvFBIvQA:4 a=CjuIK1q_8ugA:10 a=x1WnkoZAwusA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 02, 2010 3:16 PM, H Hartley Sweeten wrote:
> On Friday, April 02, 2010 2:47 PM, Randy Dunlap wrote:
>>> 2.6.34-rc2 kernel:
>>> 
>>> Boot up on a common PC, then: modprobe physmap ; rmmod physmap
>>> and bang.
>
> [snip]
>
>> This is with close to an allmodconfig on x86_64, including:
>> 
>> CONFIG_MTD_PHYSMAP=m
>> CONFIG_MTD_PHYSMAP_COMPAT=y
>> CONFIG_MTD_PHYSMAP_START=0x8000000
>> CONFIG_MTD_PHYSMAP_LEN=0
>> CONFIG_MTD_PHYSMAP_BANKWIDTH=2
>
> That's probably the cause of the BUG.
>
> If your not run-time calling physmap_configure(), your resource will
> be created as:
>
> static struct physmap_flash_data physmap_flash_data = {
>	.width		= CONFIG_MTD_PHYSMAP_BANKWIDTH,
> };
>
> static struct resource physmap_flash_resource = {
>	.start		= CONFIG_MTD_PHYSMAP_START,
>	.end		= CONFIG_MTD_PHYSMAP_START + CONFIG_MTD_PHYSMAP_LEN - 1,
>	.flags		= IORESOURCE_MEM,
> };
>
> In other words:
>
> static struct physmap_flash_data physmap_flash_data = {
>	.width		= 2,
> };
>
> static struct resource physmap_flash_resource = {
>	.start		= 0x8000000,
>	.end		= 0x8000000 + 0 - 1,
>	.flags		= IORESOURCE_MEM,
> };

I traced this down to kernel/resource.c.  When __request_resource
is finally called, because of the platform_device_register, it ends
up returning a conflict due to:

	resource_size_t start = new->start;
	resource_size_t end = new->end;
	struct resource *tmp, **p;

	if (end < start)
		return root;

This ends up causing an -EBUSY error code.  The patch below should
be correct to fix this.

I changed the commit message a bit.

---

mtd/maps/physmap: catch failure to register MTD_PHYSMAP_COMPAT device

If the default Kconfig values are used with MTD_PHYSMAP_COMPAT you end
up with a resource where end < start.  This causes __request_resource to
return a conflict which then returns an -EBUSY error code.  The current
physmap.c code just assumes that the platfom_device_register will always
succeed.

Catch this failure during the physmap_init and propogate the error.

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

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
