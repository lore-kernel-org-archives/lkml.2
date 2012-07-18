Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840Ab2GRAMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:12:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51439 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757786Ab2GRAMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:12:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Nicolas Pitre <nico@linaro.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 04/23] mtd: nandsim: dont open code a do_div helper
Date: Tue, 17 Jul 2012 17:11:57 -0700
Message-Id: <20120717232329.541601946@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120717232329.276003806@linuxfoundation.org>
References: <20120717232455.GA5994@kroah.com>
 <20120717232329.276003806@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>

commit 596fd46268634082314b3af1ded4612e1b7f3f03 upstream.

We don't need to open code the divide function, just use div_u64 that
already exists and do the same job. While this is a straightforward
clean up, there is more to that, the real motivation for this.

While building on a cross compiling environment in armel, using gcc
4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5), I was getting the following build
error:

ERROR: "__aeabi_uldivmod" [drivers/mtd/nand/nandsim.ko] undefined!

After investigating with objdump and hand built assembly version
generated with the compiler, I narrowed __aeabi_uldivmod as being
generated from the divide function. When nandsim.c is built with
-fno-inline-functions-called-once, that happens when
CONFIG_DEBUG_SECTION_MISMATCH is enabled, the do_div optimization in
arch/arm/include/asm/div64.h doesn't work as expected with the open
coded divide function: even if the do_div we are using doesn't have a
constant divisor, the compiler still includes the else parts of the
optimized do_div macro, and translates the divisions there to use
__aeabi_uldivmod, instead of only calling __do_div_asm -> __do_div64 and
optimizing/removing everything else out.

So to reproduce, gcc 4.6 plus CONFIG_DEBUG_SECTION_MISMATCH=y and
CONFIG_MTD_NAND_NANDSIM=m should do it, building on armel.

After this change, the compiler does the intended thing even with
-fno-inline-functions-called-once, and optimizes out as expected the
constant handling in the optimized do_div on arm. As this also avoids a
build issue, I'm marking for Stable, as I think is applicable for this
case.

Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/nandsim.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/drivers/mtd/nand/nandsim.c
+++ b/drivers/mtd/nand/nandsim.c
@@ -28,7 +28,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/vmalloc.h>
-#include <asm/div64.h>
+#include <linux/math64.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/string.h>
@@ -547,12 +547,6 @@ static char *get_partition_name(int i)
 	return kstrdup(buf, GFP_KERNEL);
 }
 
-static uint64_t divide(uint64_t n, uint32_t d)
-{
-	do_div(n, d);
-	return n;
-}
-
 /*
  * Initialize the nandsim structure.
  *
@@ -581,7 +575,7 @@ static int init_nandsim(struct mtd_info
 	ns->geom.oobsz    = mtd->oobsize;
 	ns->geom.secsz    = mtd->erasesize;
 	ns->geom.pgszoob  = ns->geom.pgsz + ns->geom.oobsz;
-	ns->geom.pgnum    = divide(ns->geom.totsz, ns->geom.pgsz);
+	ns->geom.pgnum    = div_u64(ns->geom.totsz, ns->geom.pgsz);
 	ns->geom.totszoob = ns->geom.totsz + (uint64_t)ns->geom.pgnum * ns->geom.oobsz;
 	ns->geom.secshift = ffs(ns->geom.secsz) - 1;
 	ns->geom.pgshift  = chip->page_shift;
@@ -924,7 +918,7 @@ static int setup_wear_reporting(struct m
 
 	if (!rptwear)
 		return 0;
-	wear_eb_count = divide(mtd->size, mtd->erasesize);
+	wear_eb_count = div_u64(mtd->size, mtd->erasesize);
 	mem = wear_eb_count * sizeof(unsigned long);
 	if (mem / sizeof(unsigned long) != wear_eb_count) {
 		NS_ERR("Too many erase blocks for wear reporting\n");


