Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933524Ab1J1VwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 17:52:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933453Ab1J1VsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 17:48:24 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH -v2 02/16] PCI: ARM: convert pcibios_set_master() to a
	non-inlined function
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux@arm.linux.org.uk, vapier@gentoo.org,
        dhowells@redhat.com, ysato@users.sourceforge.jp, tony.luck@intel.com,
        fenghua.yu@intel.com, monstr@monstr.eu, ralf@linux-mips.org,
        benh@kernel.crashing.org, paulus@samba.org, lethal@linux-sh.org,
        davem@davemloft.net, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        tglx@linutronix.de, mingo@redhat.com, chris@zankel.net,
        linux-kernel@vger.kernel.org
Date: Fri, 28 Oct 2011 15:47:42 -0600
Message-ID: <20111028214742.20088.62574.stgit@amt.stowe>
In-Reply-To: <20111028214726.20088.30551.stgit@amt.stowe>
References: <20111028214726.20088.30551.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Myron Stowe <mstowe@redhat.com>

This patch converts ARM's architecture-specific inlined
'pcibios_set_master()' routine to a non-inlined function.  This will
allow follow on patches to create a generic 'pcibios_set_master()'
function using the '__weak' attribute which can be used by all
architectures as a default which, if necessary, can then be over-
ridden by architecture-specific code.

Converting 'pci_bios_set_master()' to a non-inlined function will allow
ARM's 'pcibios_set_master()' implementation to remain architecture-
specific after the generic version is introduced and thus, not change
current behavior.

Note that ARM also has a non-inlined 'pcibios_set_master()' that is
used if CONFIG_PCI_HOST_ITE8152 is defined.  This patch does not
change any behavior here either.

No functional change.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 arch/arm/common/it8152.c   |    3 +++
 arch/arm/include/asm/pci.h |   12 ------------
 arch/arm/kernel/bios32.c   |    7 +++++++
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/arm/common/it8152.c b/arch/arm/common/it8152.c
index a7934ba..b892432 100644
--- a/arch/arm/common/it8152.c
+++ b/arch/arm/common/it8152.c
@@ -326,6 +326,9 @@ err0:
  */
 unsigned int pcibios_max_latency = 255;
 
+/* ITE bridge requires setting latency timer to avoid early bus access
+   termination by PCI bus master devices
+*/
 void pcibios_set_master(struct pci_dev *dev)
 {
 	u8 lat;
diff --git a/arch/arm/include/asm/pci.h b/arch/arm/include/asm/pci.h
index 2b1f245..da337ba 100644
--- a/arch/arm/include/asm/pci.h
+++ b/arch/arm/include/asm/pci.h
@@ -31,18 +31,6 @@ static inline int pci_proc_domain(struct pci_bus *bus)
 }
 #endif /* CONFIG_PCI_DOMAINS */
 
-#ifdef CONFIG_PCI_HOST_ITE8152
-/* ITE bridge requires setting latency timer to avoid early bus access
-   termination by PIC bus mater devices
-*/
-extern void pcibios_set_master(struct pci_dev *dev);
-#else
-static inline void pcibios_set_master(struct pci_dev *dev)
-{
-	/* No special bus mastering setup handling */
-}
-#endif
-
 static inline void pcibios_penalize_isa_irq(int irq, int active)
 {
 	/* We don't do dynamic PCI IRQ allocation */
diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
index d6df359..d8457c6 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -572,6 +572,13 @@ void __init pci_common_init(struct hw_pci *hw)
 	}
 }
 
+#ifndef CONFIG_PCI_HOST_ITE8152
+void pcibios_set_master(struct pci_dev *dev)
+{
+	/* No special bus mastering setup handling */
+}
+#endif
+
 char * __init pcibios_setup(char *str)
 {
 	if (!strcmp(str, "debug")) {

