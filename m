Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab0JNXSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 19:18:48 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:34079 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567Ab0JNXSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 19:18:43 -0400
Subject: [PATCH v4 4/6] x86/PCI: allocate space from the end of a region,
	not the beginning
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Bob Picco <bpicco@redhat.com>, Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-pci@vger.kernel.org,
        "Horst H. von Brand" <vonbrand@inf.utfsm.cl>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Stefan Becker <chemobejk@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Leann Ogasawara <leann.ogasawara@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 14 Oct 2010 17:18:42 -0600
Message-ID: <20101014231842.536.35121.stgit@bob.kio>
In-Reply-To: <20101014231804.536.62138.stgit@bob.kio>
References: <20101014231804.536.62138.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Allocate from the end of a region, not the beginning.

For example, if we need to allocate 0x800 bytes for a device on bus
0000:00 given these resources:

    [mem 0xbff00000-0xdfffffff] PCI Bus 0000:00
      [mem 0xc0000000-0xdfffffff] PCI Bus 0000:02

the available space at [mem 0xbff00000-0xbfffffff] is passed to the
alignment callback (pcibios_align_resource()).  Prior to this patch, we
would put the new 0x800 byte resource at the beginning of that available
space, i.e., at [mem 0xbff00000-0xbff007ff].

With this patch, we put it at the end, at [mem 0xbffff800-0xbfffffff].

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=16228#c41
Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 arch/x86/pci/i386.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)


diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 5525309..826140a 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -65,16 +65,21 @@ pcibios_align_resource(void *data, const struct resource *res,
 			resource_size_t size, resource_size_t align)
 {
 	struct pci_dev *dev = data;
-	resource_size_t start = res->start;
+	resource_size_t start = round_down(res->end - size + 1, align);
 
 	if (res->flags & IORESOURCE_IO) {
-		if (skip_isa_ioresource_align(dev))
-			return start;
-		if (start & 0x300)
-			start = (start + 0x3ff) & ~0x3ff;
+
+		/*
+		 * If we're avoiding ISA aliases, the largest contiguous I/O
+		 * port space is 256 bytes.  Clearing bits 9 and 10 preserves
+		 * all 256-byte and smaller alignments, so the result will
+		 * still be correctly aligned.
+		 */
+		if (!skip_isa_ioresource_align(dev))
+			start &= ~0x300;
 	} else if (res->flags & IORESOURCE_MEM) {
 		if (start < BIOS_END)
-			start = BIOS_END;
+			start = res->end;	/* fail; no space */
 	}
 	return start;
 }

