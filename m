Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab0K2Sh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 13:37:27 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:40868 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab0K2Sh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 13:37:26 -0500
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Nov 2010 13:37:26 EST
Subject: [PATCH] x86/PCI: never allocate PCI space from the last 1M below 4G
To: "H. Peter Anvin" <hpa@zytor.com>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg@redhat.com>
Date: Mon, 29 Nov 2010 11:30:09 -0700
Message-ID: <20101129183009.11256.33739.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The last 1M before 4G contains the processor restart vector and usually
the system ROM.  We don't know the actual ROM size; I chose 1M because
that's how much Windows 7 appears to avoid.

Without this check, we can allocate PCI space that will never work.  On
Matthew's HP 2530p, we put the Intel GTT "Flush Page" at the very last
page, which causes a spontaneous power-off:

  pci_root PNP0A08:00: host bridge window [mem 0xfee01000-0xffffffff]
  fffff000-ffffffff : Intel Flush Page (assigned by intel-gtt)

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=23542
Reported-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 arch/x86/include/asm/e820.h |    3 +++
 arch/x86/pci/i386.c         |   10 +++++++++-
 2 files changed, 12 insertions(+), 1 deletions(-)


diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index 5be1542..c1e908f 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -72,6 +72,9 @@ struct e820map {
 #define BIOS_BEGIN		0x000a0000
 #define BIOS_END		0x00100000
 
+#define BIOS_ROM_BASE		0xfff00000
+#define BIOS_ROM_END		0x100000000ULL
+
 #ifdef __KERNEL__
 /* see comment in arch/x86/kernel/e820.c */
 extern struct e820map e820;
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index c4bb261..6890241 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -65,8 +65,14 @@ pcibios_align_resource(void *data, const struct resource *res,
 			resource_size_t size, resource_size_t align)
 {
 	struct pci_dev *dev = data;
-	resource_size_t start = round_down(res->end - size + 1, align);
+	resource_size_t start, end = res->end;
 
+	/* Make sure we don't allocate from the last 1M before 4G */
+	if (res->flags & IORESOURCE_MEM) {
+		if (end >= BIOS_ROM_BASE && end < BIOS_ROM_END)
+			end = BIOS_ROM_BASE - 1;
+	}
+	start = round_down(end - size + 1, align);
 	if (res->flags & IORESOURCE_IO) {
 
 		/*
@@ -80,6 +86,8 @@ pcibios_align_resource(void *data, const struct resource *res,
 	} else if (res->flags & IORESOURCE_MEM) {
 		if (start < BIOS_END)
 			start = res->end;	/* fail; no space */
+		if (start >= BIOS_ROM_BASE && start < BIOS_ROM_END)
+			start = ALIGN(BIOS_ROM_END, align);
 	}
 	return start;
 }

