Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab1BPAXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:23:21 -0500
Received: from kroah.org ([198.145.64.141]:49315 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757544Ab1BPAXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:23:03 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:42 2011
Message-Id: <20110216001442.530563260@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [174/272] ARM: initrd: disable initrd if passed address overlaps reserved region
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit b0a2679d27408d97ce31e5f800b44227d3388b84 upstream.

Disable the initrd if the passed address already overlaps the reserved
region.  This avoids oopses on Netwinders when NeTTrom tells the kernel
that an initrd is located at mem+4MB, but this overlaps the BSS,
resulting in the kernels in-use BSS being freed.

This should be applied to v2.6.37-stable.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mm/init.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -297,6 +297,12 @@ void __init arm_memblock_init(struct mem
 	memblock_reserve(__pa(_stext), _end - _stext);
 #endif
 #ifdef CONFIG_BLK_DEV_INITRD
+	if (phys_initrd_size &&
+	    memblock_is_region_reserved(phys_initrd_start, phys_initrd_size)) {
+		pr_err("INITRD: 0x%08lx+0x%08lx overlaps in-use memory region - disabling initrd\n",
+		       phys_initrd_start, phys_initrd_size);
+		phys_initrd_start = phys_initrd_size = 0;
+	}
 	if (phys_initrd_size) {
 		memblock_reserve(phys_initrd_start, phys_initrd_size);
 


