Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab0LQE2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 23:28:46 -0500
Received: from smtp.falooley.org ([66.180.170.91]:53167 "EHLO
	smtp.falooley.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab0LQE2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 23:28:45 -0500
Date: Thu, 16 Dec 2010 20:27:59 -0800
From: Jason Lunz <lunz@acm.org>
To: Anatolij Gustschin <agust@denx.de>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        atom ota <atomota@sleepyhammer.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>, Jeff Dike <jdike@addtoit.com>,
        lkml <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
        Rob Landley <rob@landley.net>, David Woodhouse <dwmw2@infradead.org>
Subject: mtd: fix CONFIG_MTD_COMPLEX_MAPPINGS=n compile
Message-ID: <20101217042759.GA3148@falooley.org>
References: <20071024011712.GA3762@falooley.org>
 <1193208689.26096.48.camel@pmac.infradead.org>
 <20071227181524.GA19051@falooley.org>
 <20071228174853.GA4252@uranus.ravnborg.org>
 <20101207072919.GA8511@falooley.org>
 <AANLkTineLxHdcDKZEUGiqVNAauSX_xyQrs49kKaqhiWo@mail.gmail.com>
 <20101207182012.GA10546@falooley.org>
 <1292343878.2538.80.camel@localhost>
 <20101214195124.GA6010@falooley.org>
 <20101216230110.65156c55@wker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101216230110.65156c55@wker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 11:01:10PM +0100, Anatolij Gustschin wrote:
> This change breaks compiling when CONFIG_MTD_COMPLEX_MAPPINGS is not
> defined in the kernel configuration. Please fix!

Sorry, sloppy of me. This reverts all changes to mtd.h while keeping the
ability to compile mtd on ARCH=um, with the exception mtdchar.

Jason

--

Revert hiding of inline_map_* functions in linux/mtd.h, and mark
MTD_CHAR as incompatible with uml until a better solution can be found
there.

Signed-off-by: Jason Lunz <lunz@acm.org>

---
 drivers/mtd/Kconfig     |    1 +
 include/linux/mtd/map.h |   18 +++++++++---------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
index 7537654..51471a5 100644
--- a/drivers/mtd/Kconfig
+++ b/drivers/mtd/Kconfig
@@ -174,6 +174,7 @@ comment "User Modules And Translation Layers"
 
 config MTD_CHAR
 	tristate "Direct char device access to MTD devices"
+	depends on HAS_IOMEM
 	help
 	  This provides a character device for each MTD device present in
 	  the system, allowing the user to read and write directly to the
diff --git a/include/linux/mtd/map.h b/include/linux/mtd/map.h
index 3d9f7e0..a9e6ba4 100644
--- a/include/linux/mtd/map.h
+++ b/include/linux/mtd/map.h
@@ -388,15 +388,6 @@ static inline map_word map_word_ff(struct map_info *map)
 	return r;
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
 static inline map_word inline_map_read(struct map_info *map, unsigned long ofs)
 {
 	map_word r;
@@ -449,6 +440,15 @@ static inline void inline_map_copy_to(struct map_info *map, unsigned long to, co
 	memcpy_toio(map->virt + to, from, len);
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
 #else
 #define map_read(map, ofs) inline_map_read(map, ofs)
 #define map_copy_from(map, to, from, len) inline_map_copy_from(map, to, from, len)
-- 
1.7.2.3

