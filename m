Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab2B0BC6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 20:02:58 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65075 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab2B0BC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 20:02:57 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of udknight@gmail.com designates 10.43.53.1 as permitted sender) smtp.mail=udknight@gmail.com; dkim=pass header.i=udknight@gmail.com
Date: Mon, 27 Feb 2012 09:02:45 +0800
From: Wang YanQing <udknight@gmail.com>
To: spock@gentoo.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        x86@kernel.org, hpa@linux.intel.com
Subject: [PATCH 1/2] x86:add function to check BIOS whether NX
Message-ID: <20120227010245.GB4019@udknight>
Mail-Followup-To: Wang YanQing <Udknight@gmail.com>, spock@gentoo.org,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	x86@kernel.org, hpa@linux.intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Although we don't want any RWX memory in system,
but there are still some may need it, for example
uvesafb, so we give them this function to check
and ajust themself.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 arch/x86/include/asm/pci.h |    1 +
 arch/x86/mm/pageattr.c     |    2 +-
 arch/x86/pci/pcbios.c      |   11 +++++++++++
 3 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index df75d07..31d657b 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -66,6 +66,7 @@ extern unsigned long pci_mem_start;
 #define PCIBIOS_MIN_CARDBUS_IO	0x4000
 
 extern int pcibios_enabled;
+extern int check_pcibios_enabled(void);
 void pcibios_config_init(void);
 struct pci_bus *pcibios_scan_root(int bus);
 
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index e1ebde3..b1fb064 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -260,7 +260,7 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 	 * PCI BIOS based config access (CONFIG_PCI_GOBIOS) support.
 	 */
 #ifdef CONFIG_PCI_BIOS
-	if (pcibios_enabled && within(pfn, BIOS_BEGIN >> PAGE_SHIFT, BIOS_END >> PAGE_SHIFT))
+	if (check_pcibios_enabled() && within(pfn, BIOS_BEGIN >> PAGE_SHIFT, BIOS_END >> PAGE_SHIFT))
 		pgprot_val(forbidden) |= _PAGE_NX;
 #endif
 
diff --git a/arch/x86/pci/pcbios.c b/arch/x86/pci/pcbios.c
index da8fe05..86e0674 100644
--- a/arch/x86/pci/pcbios.c
+++ b/arch/x86/pci/pcbios.c
@@ -28,6 +28,17 @@
 
 int pcibios_enabled;
 
+/*
+  Although we don't want any RWX memory in system,
+  but there are still some may need it, so we give
+  them this function to check and ajust themself.
+*/
+int check_pcibios_enabled()
+{
+	return pcibios_enabled;
+}
+EXPORT_SYMBOL(check_pcibios_enabled);
+
 /* According to the BIOS specification at:
  * http://members.datafast.net.au/dft0802/specs/bios21.pdf, we could
  * restrict the x zone to some pages and make it ro. But this may be
-- 
1.7.3.4

