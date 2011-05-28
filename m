Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab1E1U5F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 16:57:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43349 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab1E1U5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 16:57:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=HnUqe+QhFmh1r2AwKsTYa7OYKtaUZuxokfiZa4cGI1sxXCn/lKzNRs6tNA+d13ePaX
         Y4mZe5fN+raskns5JMBXPh1Qs+1g/rob5Q4GXP75RvD/PesOr7IaVoN7/IAt40wCCxGy
         0yVZZno64NcZzb1v77tO+0/1Z5fJU6cPEo9bQ=
Date: Sun, 29 May 2011 00:57:01 +0400
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>, David Rientjes <rientjes@google.com>,
        Samuel Ortiz <samuel@sortiz.org>
Subject: IrDA driver fails on PXA255
Message-ID: <20110528205701.GA1788@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

Since a197b59ae6e8bee56fcef37ea2482dc08414e2ac (mm: fail GFP_DMA
allocations when ZONE_DMA is not configured), pxaficp_ir.c driver fails
to probe: pxa_irda_init_iobuf asks for a buffer with GFP_KERNEL |
GFP_DMA flags, which fail nicely with the following trace:

------------[ cut here ]------------
WARNING: at mm/page_alloc.c:2251
__alloc_pages_nodemask+0xa0/0x5ac()
Modules linked in:
[<c00385b0>] (unwind_backtrace+0x0/0xf0) from [<c0050b1c>] (warn_slowpath_common+0x4c/0x64)
[<c0050b1c>] (warn_slowpath_common+0x4c/0x64) from [<c0050b4c>] (warn_slowpath_null+0x18/0x1c)
[<c0050b4c>] (warn_slowpath_null+0x18/0x1c) from [<c00908ec>] (__alloc_pages_nodemask+0xa0/0x5ac)
[<c00908ec>] (__alloc_pages_nodemask+0xa0/0x5ac) from [<c0090e74>] (__get_free_pages+0x10/0x3c)
[<c0090e74>] (__get_free_pages+0x10/0x3c) from [<c01d608c>] (pxa_irda_init_iobuf+0x18/0x48)
[<c01d608c>] (pxa_irda_init_iobuf+0x18/0x48) from [<c01d61d8>] (pxa_irda_probe+0x11c/0x32c)
[<c01d61d8>] (pxa_irda_probe+0x11c/0x32c) from [<c019474c>] (platform_drv_probe+0x14/0x18)
[<c019474c>] (platform_drv_probe+0x14/0x18) from [<c0193508>] (really_probe+0xa0/0x158)
[<c0193508>] (really_probe+0xa0/0x158) from [<c019360c>] (driver_probe_device+0x4c/0x64)
[<c019360c>] (driver_probe_device+0x4c/0x64) from [<c0193684>] (__driver_attach+0x60/0x84)
[<c0193684>] (__driver_attach+0x60/0x84) from [<c0192d78>] (bus_for_each_dev+0x48/0x84)
[<c0192d78>] (bus_for_each_dev+0x48/0x84) from [<c01926b8>] (bus_add_driver+0xa8/0x220)
[<c01926b8>] (bus_add_driver+0xa8/0x220) from [<c0193c7c>] (driver_register+0xac/0x13c)
[<c0193c7c>] (driver_register+0xac/0x13c) from [<c0033440>] (do_one_initcall+0x94/0x16c)
[<c0033440>] (do_one_initcall+0x94/0x16c) from [<c00083f4>] (kernel_init+0x94/0x140)
[<c00083f4>] (kernel_init+0x94/0x140) from [<c00348d0>] (kernel_thread_exit+0x0/0x8)
---[ end trace 0b8bf08f70147098 ]---

And then I get:

pxa2xx-ir: probe of pxa2xx-ir failed with error -12

Of course one can ask for a buffer w/o GFP_DMA (see attachment), but I
ain't sure that it's correct.

-- 
With best wishes
Dmitry


--Qxx1br4bt0+wmkIi
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-pxa-don-t-ask-for-a-buffer-from-DMA-zone.patch"

>From 18f033175030a1d42cf58b4930682a35de3e7412 Mon Sep 17 00:00:00 2001
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Date: Sun, 29 May 2011 00:53:29 +0400
Subject: [PATCH] pxa: don't ask for a buffer from DMA zone

PXA don't have special DMA zone. And since
197b59ae6e8bee56fcef37ea2482dc08414e2ac (mm: fail GFP_DMA allocations
when ZONE_DMA is not configured) allocation with GFP_DMA set will fail
with a trace like this:

------------[ cut here ]------------
WARNING: at mm/page_alloc.c:2251
__alloc_pages_nodemask+0xa0/0x5ac()
Modules linked in:
[<c00385b0>] (unwind_backtrace+0x0/0xf0) from [<c0050b1c>] (warn_slowpath_common+0x4c/0x64)
[<c0050b1c>] (warn_slowpath_common+0x4c/0x64) from [<c0050b4c>] (warn_slowpath_null+0x18/0x1c)
[<c0050b4c>] (warn_slowpath_null+0x18/0x1c) from [<c00908ec>] (__alloc_pages_nodemask+0xa0/0x5ac)
[<c00908ec>] (__alloc_pages_nodemask+0xa0/0x5ac) from [<c0090e74>] (__get_free_pages+0x10/0x3c)
[<c0090e74>] (__get_free_pages+0x10/0x3c) from [<c01d608c>] (pxa_irda_init_iobuf+0x18/0x48)
[<c01d608c>] (pxa_irda_init_iobuf+0x18/0x48) from [<c01d61d8>] (pxa_irda_probe+0x11c/0x32c)
[<c01d61d8>] (pxa_irda_probe+0x11c/0x32c) from [<c019474c>] (platform_drv_probe+0x14/0x18)
[<c019474c>] (platform_drv_probe+0x14/0x18) from [<c0193508>] (really_probe+0xa0/0x158)
[<c0193508>] (really_probe+0xa0/0x158) from [<c019360c>] (driver_probe_device+0x4c/0x64)
[<c019360c>] (driver_probe_device+0x4c/0x64) from [<c0193684>] (__driver_attach+0x60/0x84)
[<c0193684>] (__driver_attach+0x60/0x84) from [<c0192d78>] (bus_for_each_dev+0x48/0x84)
[<c0192d78>] (bus_for_each_dev+0x48/0x84) from [<c01926b8>] (bus_add_driver+0xa8/0x220)
[<c01926b8>] (bus_add_driver+0xa8/0x220) from [<c0193c7c>] (driver_register+0xac/0x13c)
[<c0193c7c>] (driver_register+0xac/0x13c) from [<c0033440>] (do_one_initcall+0x94/0x16c)
[<c0033440>] (do_one_initcall+0x94/0x16c) from [<c00083f4>] (kernel_init+0x94/0x140)
[<c00083f4>] (kernel_init+0x94/0x140) from [<c00348d0>] (kernel_thread_exit+0x0/0x8)
---[ end trace 0b8bf08f70147098 ]---

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 drivers/net/irda/pxaficp_ir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/irda/pxaficp_ir.c b/drivers/net/irda/pxaficp_ir.c
index 001ed0a..a5ebaef 100644
--- a/drivers/net/irda/pxaficp_ir.c
+++ b/drivers/net/irda/pxaficp_ir.c
@@ -805,7 +805,7 @@ static int pxa_irda_resume(struct platform_device *_dev)
 
 static int pxa_irda_init_iobuf(iobuff_t *io, int size)
 {
-	io->head = kmalloc(size, GFP_KERNEL | GFP_DMA);
+	io->head = kmalloc(size, GFP_KERNEL);
 	if (io->head != NULL) {
 		io->truesize = size;
 		io->in_frame = FALSE;
-- 
1.7.4.4


--Qxx1br4bt0+wmkIi--
