Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab0LPRif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 12:38:35 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:47020 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854Ab0LPRic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 12:38:32 -0500
Subject: [PATCH 3/9] Revert "x86/PCI: allocate space from the end of a region,
	not the beginning"
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Adam Belay <abelay@mit.edu>
Date: Thu, 16 Dec 2010 10:38:31 -0700
Message-ID: <20101216173830.8185.85826.stgit@bob.kio>
In-Reply-To: <20101216173614.8185.19462.stgit@bob.kio>
References: <20101216173614.8185.19462.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This reverts commit dc9887dc02e37bcf83f4e792aa14b07782ef54cf.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 arch/x86/pci/i386.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)


diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index c4bb261..8379c2c 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -65,21 +65,16 @@ pcibios_align_resource(void *data, const struct resource *res,
 			resource_size_t size, resource_size_t align)
 {
 	struct pci_dev *dev = data;
-	resource_size_t start = round_down(res->end - size + 1, align);
+	resource_size_t start = res->start;
 
 	if (res->flags & IORESOURCE_IO) {
-
-		/*
-		 * If we're avoiding ISA aliases, the largest contiguous I/O
-		 * port space is 256 bytes.  Clearing bits 9 and 10 preserves
-		 * all 256-byte and smaller alignments, so the result will
-		 * still be correctly aligned.
-		 */
-		if (!skip_isa_ioresource_align(dev))
-			start &= ~0x300;
+		if (skip_isa_ioresource_align(dev))
+			return start;
+		if (start & 0x300)
+			start = (start + 0x3ff) & ~0x3ff;
 	} else if (res->flags & IORESOURCE_MEM) {
 		if (start < BIOS_END)
-			start = res->end;	/* fail; no space */
+			start = BIOS_END;
 	}
 	return start;
 }

