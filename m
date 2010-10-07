Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224Ab0JGBKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 21:10:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:25068 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab0JGBKg (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 6 Oct 2010 21:10:36 -0400
Date: Wed, 6 Oct 2010 21:09:13 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 15/22] x86: Copy-n-paste arch_teardown_msi_irqs from
 msi.c to io_apic.c.
Message-ID: <20101007010913.GA22093@dumpdata.com>
References: <1286216015-9710-1-git-send-email-konrad.wilk@oracle.com>
 <1286216015-9710-16-git-send-email-konrad.wilk@oracle.com>
 <alpine.LFD.2.00.1010051055470.2556@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1010051055470.2556@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 05, 2010 at 11:07:36AM +0200, Thomas Gleixner wrote:
> On Mon, 4 Oct 2010, Konrad Rzeszutek Wilk wrote:
> 
> > In preparation for non-privileged domains to disable PCI devices'
> > MSI/MSIx, we need to augment arch_teardown_msi_irqs to make
> > a call to the privileged domain (patch to follow).
> 
> Can't we find a more clever solution than just copying stuff around ?

Thanks for suggestion. Based on your idea, this is the patch I've rigged up.
I've also included a different re-implementation of the next patch
that would utilize this (x86-Introduce-x86_msi_ops). Tested successfully on x86.
Cross-compiling on PPC, PPC64, and IA64 shows no failure.

Is it OK if I put you as the Author of this?

>From a9d8656100c0c389fe59dcd5e98380f6ef7bcd93 Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 6 Oct 2010 16:05:35 -0400
Subject: [PATCH 1/2] msi: Introduce default_[teardown|setup]_msi_irqs with fallback.

Introduce an override for the arch_[teardown|setup]_msi_irqs
that can be utilized to fallback to the default arch_* code.

If a platform wants to utilize the code paths defined
in driver/pci/msi.c it has to define HAVE_DEFAULT_MSI_TEARDOWN_IRQS
or HAVE_DEFAULT_MSI_SETUP_IRQS. Otherwise the old mechanism
of over-ridding the arch_* works fine.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/pci/msi.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 69b7be3..e57bfa9 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -35,7 +35,12 @@ int arch_msi_check_device(struct pci_dev *dev, int nvec, int type)
 #endif
 
 #ifndef arch_setup_msi_irqs
-int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+# define arch_setup_msi_irqs default_setup_msi_irqs
+# define HAVE_DEFAULT_MSI_SETUP_IRQS
+#endif
+
+#ifdef HAVE_DEFAULT_MSI_SETUP_IRQS
+int default_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
 	struct msi_desc *entry;
 	int ret;
@@ -60,7 +65,12 @@ int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 #endif
 
 #ifndef arch_teardown_msi_irqs
-void arch_teardown_msi_irqs(struct pci_dev *dev)
+# define arch_teardown_msi_irqs default_teardown_msi_irqs
+# define HAVE_DEFAULT_MSI_TEARDOWN_IRQS
+#endif
+
+#ifdef HAVE_DEFAULT_MSI_TEARDOWN_IRQS
+void default_teardown_msi_irqs(struct pci_dev *dev)
 {
 	struct msi_desc *entry;
 
-- 
1.7.0.4



and:


>From f180620f523b0c2b377fa6600b5444abc714903f Mon Sep 17 00:00:00 2001
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Date: Wed, 6 Oct 2010 16:12:28 -0400
Subject: [PATCH 2/2] x86: Introduce x86_msi_ops

Introduce an x86 specific indirect mechanism to setup MSIs.
The MSI setup functions become function pointers in an x86_msi_ops
struct, that defaults to the implementation in io_apic.c and msi.c.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 arch/x86/include/asm/pci.h      |   27 +++++++++++++++++++++++++--
 arch/x86/include/asm/x86_init.h |    9 +++++++++
 arch/x86/kernel/apic/io_apic.c  |    4 ++--
 arch/x86/kernel/x86_init.c      |    6 ++++++
 4 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index d395540..5a93f36 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -7,6 +7,7 @@
 #include <linux/string.h>
 #include <asm/scatterlist.h>
 #include <asm/io.h>
+#include <asm/x86_init.h>
 
 #ifdef __KERNEL__
 
@@ -94,8 +95,30 @@ static inline void early_quirks(void) { }
 
 extern void pci_iommu_alloc(void);
 
-/* MSI arch hook */
-#define arch_setup_msi_irqs arch_setup_msi_irqs
+/* MSI arch specific hooks */
+static inline int x86_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+{
+	return x86_msi.setup_msi_irqs(dev, nvec, type);
+}
+
+static inline void x86_teardown_msi_irqs(struct pci_dev *dev)
+{
+	x86_msi.teardown_msi_irqs(dev);
+}
+
+static inline void x86_teardown_msi_irq(unsigned int irq)
+{
+	x86_msi.teardown_msi_irq(irq);
+}
+#define arch_setup_msi_irqs x86_setup_msi_irqs
+#define arch_teardown_msi_irqs x86_teardown_msi_irqs
+#define arch_teardown_msi_irq x86_teardown_msi_irq
+/* implemented in arch/x86/kernel/apic/io_apic. */
+int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
+void native_teardown_msi_irq(unsigned int irq);
+/* default to the implementation in drivers/lib/msi.c */
+#define HAVE_DEFAULT_MSI_TEARDOWN_IRQS
+void default_teardown_msi_irqs(struct pci_dev *dev);
 
 #define PCI_DMA_BUS_IS_PHYS (dma_ops->is_phys)
 
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index baa579c..64642ad 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -154,9 +154,18 @@ struct x86_platform_ops {
 	int (*i8042_detect)(void);
 };
 
+struct pci_dev;
+
+struct x86_msi_ops {
+	int (*setup_msi_irqs)(struct pci_dev *dev, int nvec, int type);
+	void (*teardown_msi_irq)(unsigned int irq);
+	void (*teardown_msi_irqs)(struct pci_dev *dev);
+};
+
 extern struct x86_init_ops x86_init;
 extern struct x86_cpuinit_ops x86_cpuinit;
 extern struct x86_platform_ops x86_platform;
+extern struct x86_msi_ops x86_msi;
 
 extern void x86_init_noop(void);
 extern void x86_init_uint_noop(unsigned int unused);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 4c9b2b9..1bfc6d1 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3533,7 +3533,7 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 	return 0;
 }
 
-int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
 	unsigned int irq;
 	int ret, sub_handle;
@@ -3594,7 +3594,7 @@ error:
 	return ret;
 }
 
-void arch_teardown_msi_irq(unsigned int irq)
+void native_teardown_msi_irq(unsigned int irq)
 {
 	destroy_irq(irq);
 }
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index cd6da6b..2398392 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -6,6 +6,7 @@
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/module.h>
+#include <linux/pci.h>
 
 #include <asm/bios_ebda.h>
 #include <asm/paravirt.h>
@@ -99,3 +100,8 @@ struct x86_platform_ops x86_platform = {
 };
 
 EXPORT_SYMBOL_GPL(x86_platform);
+struct x86_msi_ops x86_msi = {
+	.setup_msi_irqs = native_setup_msi_irqs,
+	.teardown_msi_irq = native_teardown_msi_irq,
+	.teardown_msi_irqs = default_teardown_msi_irqs,
+};
-- 
1.7.0.4


--Kj7319i9nmIyA2yE
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-msi-Introduce-default_-teardown-setup-_msi_irqs-with.patch"

>From a9d8656100c0c389fe59dcd5e98380f6ef7bcd93 Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 6 Oct 2010 16:05:35 -0400
Subject: [PATCH 1/2] msi: Introduce default_[teardown|setup]_msi_irqs with fallback.

Introduce an override for the arch_[teardown|setup]_msi_irqs
that can be utilized to fallback to the default arch_* code.

If a platform wants to utilize the code paths defined
in driver/pci/msi.c it has to define HAVE_DEFAULT_MSI_TEARDOWN_IRQS
or HAVE_DEFAULT_MSI_SETUP_IRQS. Otherwise the old mechanism
of over-ridding the arch_* works fine.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/pci/msi.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 69b7be3..e57bfa9 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -35,7 +35,12 @@ int arch_msi_check_device(struct pci_dev *dev, int nvec, int type)
 #endif
 
 #ifndef arch_setup_msi_irqs
-int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+# define arch_setup_msi_irqs default_setup_msi_irqs
+# define HAVE_DEFAULT_MSI_SETUP_IRQS
+#endif
+
+#ifdef HAVE_DEFAULT_MSI_SETUP_IRQS
+int default_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
 	struct msi_desc *entry;
 	int ret;
@@ -60,7 +65,12 @@ int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 #endif
 
 #ifndef arch_teardown_msi_irqs
-void arch_teardown_msi_irqs(struct pci_dev *dev)
+# define arch_teardown_msi_irqs default_teardown_msi_irqs
+# define HAVE_DEFAULT_MSI_TEARDOWN_IRQS
+#endif
+
+#ifdef HAVE_DEFAULT_MSI_TEARDOWN_IRQS
+void default_teardown_msi_irqs(struct pci_dev *dev)
 {
 	struct msi_desc *entry;
 
-- 
1.7.0.4


--Kj7319i9nmIyA2yE
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-x86-Introduce-x86_msi_ops.patch"

>From f180620f523b0c2b377fa6600b5444abc714903f Mon Sep 17 00:00:00 2001
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Date: Wed, 6 Oct 2010 16:12:28 -0400
Subject: [PATCH 2/2] x86: Introduce x86_msi_ops

Introduce an x86 specific indirect mechanism to setup MSIs.
The MSI setup functions become function pointers in an x86_msi_ops
struct, that defaults to the implementation in io_apic.c and msi.c.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 arch/x86/include/asm/pci.h      |   27 +++++++++++++++++++++++++--
 arch/x86/include/asm/x86_init.h |    9 +++++++++
 arch/x86/kernel/apic/io_apic.c  |    4 ++--
 arch/x86/kernel/x86_init.c      |    6 ++++++
 4 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index d395540..5a93f36 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -7,6 +7,7 @@
 #include <linux/string.h>
 #include <asm/scatterlist.h>
 #include <asm/io.h>
+#include <asm/x86_init.h>
 
 #ifdef __KERNEL__
 
@@ -94,8 +95,30 @@ static inline void early_quirks(void) { }
 
 extern void pci_iommu_alloc(void);
 
-/* MSI arch hook */
-#define arch_setup_msi_irqs arch_setup_msi_irqs
+/* MSI arch specific hooks */
+static inline int x86_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+{
+	return x86_msi.setup_msi_irqs(dev, nvec, type);
+}
+
+static inline void x86_teardown_msi_irqs(struct pci_dev *dev)
+{
+	x86_msi.teardown_msi_irqs(dev);
+}
+
+static inline void x86_teardown_msi_irq(unsigned int irq)
+{
+	x86_msi.teardown_msi_irq(irq);
+}
+#define arch_setup_msi_irqs x86_setup_msi_irqs
+#define arch_teardown_msi_irqs x86_teardown_msi_irqs
+#define arch_teardown_msi_irq x86_teardown_msi_irq
+/* implemented in arch/x86/kernel/apic/io_apic. */
+int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
+void native_teardown_msi_irq(unsigned int irq);
+/* default to the implementation in drivers/lib/msi.c */
+#define HAVE_DEFAULT_MSI_TEARDOWN_IRQS
+void default_teardown_msi_irqs(struct pci_dev *dev);
 
 #define PCI_DMA_BUS_IS_PHYS (dma_ops->is_phys)
 
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index baa579c..64642ad 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -154,9 +154,18 @@ struct x86_platform_ops {
 	int (*i8042_detect)(void);
 };
 
+struct pci_dev;
+
+struct x86_msi_ops {
+	int (*setup_msi_irqs)(struct pci_dev *dev, int nvec, int type);
+	void (*teardown_msi_irq)(unsigned int irq);
+	void (*teardown_msi_irqs)(struct pci_dev *dev);
+};
+
 extern struct x86_init_ops x86_init;
 extern struct x86_cpuinit_ops x86_cpuinit;
 extern struct x86_platform_ops x86_platform;
+extern struct x86_msi_ops x86_msi;
 
 extern void x86_init_noop(void);
 extern void x86_init_uint_noop(unsigned int unused);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 4c9b2b9..1bfc6d1 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3533,7 +3533,7 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 	return 0;
 }
 
-int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
 	unsigned int irq;
 	int ret, sub_handle;
@@ -3594,7 +3594,7 @@ error:
 	return ret;
 }
 
-void arch_teardown_msi_irq(unsigned int irq)
+void native_teardown_msi_irq(unsigned int irq)
 {
 	destroy_irq(irq);
 }
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index cd6da6b..2398392 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -6,6 +6,7 @@
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/module.h>
+#include <linux/pci.h>
 
 #include <asm/bios_ebda.h>
 #include <asm/paravirt.h>
@@ -99,3 +100,8 @@ struct x86_platform_ops x86_platform = {
 };
 
 EXPORT_SYMBOL_GPL(x86_platform);
+struct x86_msi_ops x86_msi = {
+	.setup_msi_irqs = native_setup_msi_irqs,
+	.teardown_msi_irq = native_teardown_msi_irq,
+	.teardown_msi_irqs = default_teardown_msi_irqs,
+};
-- 
1.7.0.4


--Kj7319i9nmIyA2yE--
