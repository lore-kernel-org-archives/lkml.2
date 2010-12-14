Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759685Ab0LNTwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 14:52:17 -0500
Received: from smtp.falooley.org ([66.180.170.91]:37173 "EHLO
	smtp.falooley.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757418Ab0LNTwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 14:52:16 -0500
Date: Tue, 14 Dec 2010 11:51:24 -0800
From: Jason Lunz <lunz@acm.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>, David Woodhouse <dwmw2@infradead.org>,
        atom ota <atomota@sleepyhammer.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        Jeff Dike <jdike@addtoit.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, Rob Landley <rob@landley.net>
Subject: Re: [PATCH] mtd: allow mtd and jffs2 when ARCH=um
Message-ID: <20101214195124.GA6010@falooley.org>
References: <22c797d00709272118i33d32b9dy93d5f5ec8f8edd30@mail.gmail.com>
 <20071024011712.GA3762@falooley.org>
 <1193208689.26096.48.camel@pmac.infradead.org>
 <20071227181524.GA19051@falooley.org>
 <20071228174853.GA4252@uranus.ravnborg.org>
 <20101207072919.GA8511@falooley.org>
 <AANLkTineLxHdcDKZEUGiqVNAauSX_xyQrs49kKaqhiWo@mail.gmail.com>
 <20101207182012.GA10546@falooley.org>
 <1292343878.2538.80.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292343878.2538.80.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, Dec 14, 2010 at 06:24:38PM +0200, Artem Bityutskiy wrote:
> But I think your solution is a bit dirty, because it adds a great deal
> of little 'if HAS_IOMEM' and '#ifdef CONFIG_HAS_IOMEM' to many places.
> This is error-prone.

The intent of that patch was to allow as much of the mtd subsystem to
compile as possible. My thinking was to try and rectify the fact that
uml has gone without mtd (and hence jffs2) support for years even though
much of it works just fine. I think the entire subsystem being marked
BROKEN in kconfig kept anyone from experimenting with it.

The patch I sent was actually a reaction to feedback I got from Sam
Ravnborg on my last attempt (um, three years ago :/ ) in which he
suggested pushing down the ifdefs closer to their points of use. But I
agree, the minimal version has a much smaller footprint.

The version below still meets the goal of allowing jffs2-on-block2mtd
usage under uml but is much smaller because only the mtd core is
included. Compile-tested on i386, x86_64, um/i386, and um/x86_64.

> Instead, you should solve this problem in UML code. I do not know how,
> but may be you can add readb/writeb there which actually do nothing or
> print a scary warning, or do BUG(), and let things which use them just
> fail run-time.

Something like this could work, but it would be error-prone for anyone
else who attempts using iomem-requiring drivers on uml. Instead of
getting obvious compile failures we'd have broken drivers that BUG() or
emit scary warnings. That doesn't seem to me like an improvement.

Jason

--

Allow parts of drivers/mtd to compile on uml by pushing the HAS_IOMEM
dependencies down closer to the parts of mtd that actually need it.
This allows enough of mtd to build to let jffs2 be used on uml.

Signed-off-by: Jason Lunz <lunz@acm.org>
---
 arch/um/Kconfig.rest    |    4 +---
 drivers/mtd/Kconfig     |    7 +++++--
 drivers/mtd/Makefile    |    3 ++-
 drivers/mtd/mtdchar.c   |    4 ++++
 include/linux/mtd/map.h |   18 +++++++++---------
 5 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/arch/um/Kconfig.rest b/arch/um/Kconfig.rest
index 0ccad0f..e34f399 100644
--- a/arch/um/Kconfig.rest
+++ b/arch/um/Kconfig.rest
@@ -28,9 +28,7 @@ source "drivers/scsi/Kconfig"
 
 source "drivers/md/Kconfig"
 
-if BROKEN
-	source "drivers/mtd/Kconfig"
-endif
+source "drivers/mtd/Kconfig"
 
 source "drivers/leds/Kconfig"
 
diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
index 1e2cbf5..7537654 100644
--- a/drivers/mtd/Kconfig
+++ b/drivers/mtd/Kconfig
@@ -1,6 +1,5 @@
 menuconfig MTD
 	tristate "Memory Technology Device (MTD) support"
-	depends on HAS_IOMEM
 	help
 	  Memory Technology Devices are flash, RAM and similar chips, often
 	  used for solid state file systems on embedded devices. This option
@@ -307,7 +306,7 @@ config SSFDC
 
 config SM_FTL
 	tristate "SmartMedia/xD new translation layer"
-	depends on EXPERIMENTAL && BLOCK
+	depends on EXPERIMENTAL && BLOCK && HAS_IOMEM
 	select MTD_BLKDEVS
 	select MTD_NAND_ECC
 	help
@@ -330,6 +329,8 @@ config MTD_OOPS
 	  To use, add console=ttyMTDx to the kernel command line,
 	  where x is the MTD device number to use.
 
+if HAS_IOMEM
+
 source "drivers/mtd/chips/Kconfig"
 
 source "drivers/mtd/maps/Kconfig"
@@ -342,6 +343,8 @@ source "drivers/mtd/onenand/Kconfig"
 
 source "drivers/mtd/lpddr/Kconfig"
 
+endif # HAS_IOMEM
+
 source "drivers/mtd/ubi/Kconfig"
 
 endif # MTD
diff --git a/drivers/mtd/Makefile b/drivers/mtd/Makefile
index 760abc5..74a03bd 100644
--- a/drivers/mtd/Makefile
+++ b/drivers/mtd/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_MTD_OOPS)		+= mtdoops.o
 nftl-objs		:= nftlcore.o nftlmount.o
 inftl-objs		:= inftlcore.o inftlmount.o
 
-obj-y		+= chips/ lpddr/ maps/ devices/ nand/ onenand/ tests/
+obj-y			+= tests/
+obj-$(CONFIG_HAS_IOMEM)	+= chips/ lpddr/ maps/ devices/ nand/ onenand/
 
 obj-$(CONFIG_MTD_UBI)		+= ubi/
diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 4759d82..a434354 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -1075,6 +1075,7 @@ static unsigned long mtd_get_unmapped_area(struct file *file,
 /*
  * set up a mapping for shared memory segments
  */
+#ifdef CONFIG_HAS_IOMEM
 static int mtd_mmap(struct file *file, struct vm_area_struct *vma)
 {
 #ifdef CONFIG_MMU
@@ -1113,6 +1114,7 @@ static int mtd_mmap(struct file *file, struct vm_area_struct *vma)
 	return vma->vm_flags & VM_SHARED ? 0 : -ENOSYS;
 #endif
 }
+#endif
 
 static const struct file_operations mtd_fops = {
 	.owner		= THIS_MODULE,
@@ -1125,7 +1127,9 @@ static const struct file_operations mtd_fops = {
 #endif
 	.open		= mtd_open,
 	.release	= mtd_close,
+#ifdef CONFIG_HAS_IOMEM
 	.mmap		= mtd_mmap,
+#endif
 #ifndef CONFIG_MMU
 	.get_unmapped_area = mtd_get_unmapped_area,
 #endif
diff --git a/include/linux/mtd/map.h b/include/linux/mtd/map.h
index a9e6ba4..3d9f7e0 100644
--- a/include/linux/mtd/map.h
+++ b/include/linux/mtd/map.h
@@ -388,6 +388,15 @@ static inline map_word map_word_ff(struct map_info *map)
 	return r;
 }
 
+#ifdef CONFIG_MTD_COMPLEX_MAPPINGS
+#define map_read(map, ofs) (map)->read(map, ofs)
+#define map_copy_from(map, to, from, len) (map)->copy_from(map, to, from, len)
+#define map_write(map, datum, ofs) (map)->write(map, datum, ofs)
+#define map_copy_to(map, to, from, len) (map)->copy_to(map, to, from, len)
+
+extern void simple_map_init(struct map_info *);
+#define map_is_linear(map) (map->phys != NO_XIP)
+
 static inline map_word inline_map_read(struct map_info *map, unsigned long ofs)
 {
 	map_word r;
@@ -440,15 +449,6 @@ static inline void inline_map_copy_to(struct map_info *map, unsigned long to, co
 	memcpy_toio(map->virt + to, from, len);
 }
 
-#ifdef CONFIG_MTD_COMPLEX_MAPPINGS
-#define map_read(map, ofs) (map)->read(map, ofs)
-#define map_copy_from(map, to, from, len) (map)->copy_from(map, to, from, len)
-#define map_write(map, datum, ofs) (map)->write(map, datum, ofs)
-#define map_copy_to(map, to, from, len) (map)->copy_to(map, to, from, len)
-
-extern void simple_map_init(struct map_info *);
-#define map_is_linear(map) (map->phys != NO_XIP)
-
 #else
 #define map_read(map, ofs) inline_map_read(map, ofs)
 #define map_copy_from(map, to, from, len) inline_map_copy_from(map, to, from, len)
-- 
1.7.2.3

