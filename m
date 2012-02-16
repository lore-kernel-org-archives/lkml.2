Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab2BPJKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 04:10:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63358 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136Ab2BPJJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 04:09:37 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v5 01/27] irq_domain: add documentation and MAINTAINERS entry.
Date: Thu, 16 Feb 2012 02:09:02 -0700
Message-Id: <1329383368-12122-2-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation for irq_domain library which will be created in subsequent
patches.

v4: editorial changes

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Reviewed-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Milton Miller <miltonm@bga.com>
Tested-by: Olof Johansson <olof@lixom.net>
---
 Documentation/IRQ-domain.txt |  117 ++++++++++++++++++++++++++++++++++++++++++
 MAINTAINERS                  |    9 +++
 2 files changed, 126 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/IRQ-domain.txt

diff --git a/Documentation/IRQ-domain.txt b/Documentation/IRQ-domain.txt
new file mode 100644
index 0000000..27dcaab
--- /dev/null
+++ b/Documentation/IRQ-domain.txt
@@ -0,0 +1,117 @@
+irq_domain interrupt number mapping library
+
+The current design of the Linux kernel uses a single large number
+space where each separate IRQ source is assigned a different number.
+This is simple when there is only one interrupt controller, but in
+systems with multiple interrupt controllers the kernel must ensure
+that each one gets assigned non-overlapping allocations of Linux
+IRQ numbers.
+
+The irq_alloc_desc*() and irq_free_desc*() APIs provide allocation of
+irq numbers, but they don't provide any support for reverse mapping of
+the controller-local IRQ (hwirq) number into the Linux IRQ number
+space.
+
+The irq_domain library adds mapping between hwirq and IRQ numbers on
+top of the irq_alloc_desc*() API.  An irq_domain to manage mapping is
+preferred over interrupt controller drivers open coding their own
+reverse mapping scheme.
+
+irq_domain also implements translation from Device Tree interrupt
+specifiers to hwirq numbers, and can be easily extended to support
+other IRQ topology data sources.
+
+=== irq_domain usage ===
+An interrupt controller driver creates and registers an irq_domain by
+calling one of the irq_domain_add_*() functions (each mapping method
+has a different allocator function, more on that later).  The function
+will return a pointer to the irq_domain on success.  The caller must
+provide the allocator function with an irq_domain_ops structure with
+the .map callback populated as a minimum.
+
+In most cases, the irq_domain will begin empty without any mappings
+between hwirq and IRQ numbers.  Mappings are added to the irq_domain
+by calling irq_create_mapping() which accepts the irq_domain and a
+hwirq number as arguments.  If a mapping for the hwirq doesn't already
+exist then it will allocate a new Linux irq_desc, associate it with
+the hwirq, and call the .map() callback so the driver can perform any
+required hardware setup.
+
+When an interrupt is received, irq_find_mapping() function should
+be used to find the Linux IRQ number from the hwirq number.
+
+If the driver has the Linux IRQ number or the irq_data pointer, and
+needs to know the associated hwirq number (such as in the irq_chip
+callbacks) then it can be directly obtained from irq_data->hwirq.
+
+=== Types of irq_domain mappings ===
+There are several mechanisms available for reverse mapping from hwirq
+to Linux irq, and each mechanism uses a different allocation function.
+Which reverse map type should be used depends on the use case.  Each
+of the reverse map types are described below:
+
+==== Linear ====
+irq_domain_add_linear()
+
+The linear reverse map maintains a fixed size table indexed by the
+hwirq number.  When a hwirq is mapped, an irq_desc is allocated for
+the hwirq, and the IRQ number is stored in the table.
+
+The Linear map is a good choice when the maximum number of hwirqs is
+fixed and a relatively small number (~ < 256).  The advantages of this
+map are fixed time lookup for IRQ numbers, and irq_descs are only
+allocated for in-use IRQs.  The disadvantage is that the table must be
+as large as the largest possible hwirq number.
+
+The majority of drivers should use the linear map.
+
+==== Tree ====
+irq_domain_add_tree()
+
+The irq_domain maintains a radix tree map from hwirq numbers to Linux
+IRQs.  When an hwirq is mapped, an irq_desc is allocated and the
+hwirq is used as the lookup key for the radix tree.
+
+The tree map is a good choice if the hwirq number can be very large
+since it doesn't need to allocate a table as large as the largest
+hwirq number.  The disadvantage is that hwirq to IRQ number lookup is
+dependent on how many entries are in the table.
+
+Very few drivers should need this mapping.  At the moment, powerpc
+iseries is the only user.
+
+==== No Map ===-
+irq_domain_add_nomap()
+
+The No Map mapping is to be used when the hwirq number is
+programmable in the hardware.  In this case it is best to program the
+Linux IRQ number into the hardware itself so that no mapping is
+required.  Calling irq_create_direct_mapping() will allocate a Linux
+IRQ number and call the .map() callback so that driver can program the
+Linux IRQ number into the hardware.
+
+Most drivers cannot use this mapping.
+
+==== Legacy ====
+irq_domain_add_legacy()
+irq_domain_add_legacy_isa()
+
+The Legacy mapping is a special case for drivers that already have a
+range of irq_descs allocated for the hwirqs.  It is used when the
+driver cannot be immediately converted to use the linear mapping.  For
+example, many embedded system board support files use a set of #defines
+for IRQ numbers that are passed to struct device registrations.  In that
+case the Linux IRQ numbers cannot be dynamically assigned and the legacy
+mapping should be used.
+
+The legacy map assumes a contiguous range of IRQ numbers has already
+been allocated for the controller and that the IRQ number can be
+calculated by adding a fixed offset to the hwirq number, and
+visa-versa.  The disadvantage is that it requires the interrupt
+controller to manage IRQ allocations and it requires an irq_desc to be
+allocated for every hwirq, even if it is unused.
+
+The legacy map should only be used if fixed IRQ mappings must be
+supported.  For example, ISA controllers would use the legacy map for
+mapping Linux IRQs 0-15 so that existing ISA drivers get the correct IRQ
+numbers.
diff --git a/MAINTAINERS b/MAINTAINERS
index 9a648eb..57dd0f5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3640,6 +3640,15 @@ S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/core
 F:	kernel/irq/
 
+IRQ DOMAINS (IRQ NUMBER MAPPING LIBRARY)
+M:	Benjamin Herrenschmidt <benh@kernel.crashing.org>
+M:	Grant Likely <grant.likely@secretlab.ca>
+T:	git git://git.secretlab.ca/git/linux-2.6.git irqdomain/next
+S:	Maintained
+F:	Documentation/IRQ-domain.txt
+F:	include/linux/irqdomain.h
+F:	kernel/irq/irqdomain.c
+
 ISAPNP
 M:	Jaroslav Kysela <perex@perex.cz>
 S:	Maintained
-- 
1.7.9

