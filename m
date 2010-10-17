Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab0JQLig (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 07:38:36 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:40667 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab0JQLif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 07:38:35 -0400
Date: Sun, 17 Oct 2010 13:38:32 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jens Axboe <jaxboe@fusionio.com>
cc: Dan Carpenter <error27@gmail.com>, kernel-janitors@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        cbe-oss-dev@lists.ozlabs.org
Subject: [PATCH] block: Turn bvec_k{un,}map_irq() into static inline
 functions
Message-ID: <alpine.DEB.2.00.1010171335400.919@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert bvec_k{un,}map_irq() from macros to static inline functions if
!CONFIG_HIGHMEM, so we can easier detect mistakes like the one fixed in
93055c31045a2d5599ec613a0c6cdcefc481a460 ("ps3disk: passing wrong variable to
bvec_kunmap_irq()")

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Compile-tested on m68k only. Not on ppc64 with the old ps3disk.

 include/linux/bio.h |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 5274103..fa5d49e 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -346,8 +346,15 @@ static inline void bvec_kunmap_irq(char *buffer, unsigned long *flags)
 }
 
 #else
-#define bvec_kmap_irq(bvec, flags)	(page_address((bvec)->bv_page) + (bvec)->bv_offset)
-#define bvec_kunmap_irq(buf, flags)	do { *(flags) = 0; } while (0)
+static inline char *bvec_kmap_irq(struct bio_vec *bvec, unsigned long *flags)
+{
+	return page_address(bvec->bv_page) + bvec->bv_offset;
+}
+
+static inline void bvec_kunmap_irq(char *buffer, unsigned long *flags)
+{
+	*flags = 0;
+}
 #endif
 
 static inline char *__bio_kmap_irq(struct bio *bio, unsigned short idx,
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
