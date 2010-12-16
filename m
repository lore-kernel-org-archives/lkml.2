Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025Ab0LPRjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 12:39:07 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:25787 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003Ab0LPRjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 12:39:04 -0500
Subject: [PATCH 9/9] x86: avoid high BIOS area when allocating address space
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Adam Belay <abelay@mit.edu>
Date: Thu, 16 Dec 2010 10:39:02 -0700
Message-ID: <20101216173901.8185.56176.stgit@bob.kio>
In-Reply-To: <20101216173614.8185.19462.stgit@bob.kio>
References: <20101216173614.8185.19462.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This prevents allocation of the last 2MB before 4GB.

The experiment described here shows Windows 7 ignoring the last 1MB:
https://bugzilla.kernel.org/show_bug.cgi?id=23542#c27

This patch ignores the top 2MB instead of just 1MB because H. Peter Anvin
says "There will be ROM at the top of the 32-bit address space; it's a fact
of the architecture, and on at least older systems it was common to have a
shadow 1 MiB below."

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 arch/x86/include/asm/e820.h |    3 +++
 arch/x86/kernel/resource.c  |    3 ++-
 2 files changed, 5 insertions(+), 1 deletions(-)


diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index 5be1542..e99d55d 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -72,6 +72,9 @@ struct e820map {
 #define BIOS_BEGIN		0x000a0000
 #define BIOS_END		0x00100000
 
+#define BIOS_ROM_BASE		0xffe00000
+#define BIOS_ROM_END		0xffffffff
+
 #ifdef __KERNEL__
 /* see comment in arch/x86/kernel/e820.c */
 extern struct e820map e820;
diff --git a/arch/x86/kernel/resource.c b/arch/x86/kernel/resource.c
index 89638af..2a26819 100644
--- a/arch/x86/kernel/resource.c
+++ b/arch/x86/kernel/resource.c
@@ -37,10 +37,11 @@ static void remove_e820_regions(struct resource *avail)
 
 void arch_remove_reservations(struct resource *avail)
 {
-	/* Trim out BIOS area (low 1MB) and E820 regions */
+	/* Trim out BIOS areas (low 1MB and high 2MB) and E820 regions */
 	if (avail->flags & IORESOURCE_MEM) {
 		if (avail->start < BIOS_END)
 			avail->start = BIOS_END;
+		resource_clip(avail, BIOS_ROM_BASE, BIOS_ROM_END);
 
 		remove_e820_regions(avail);
 	}

