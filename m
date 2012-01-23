Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab2AWVIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 16:08:13 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63033 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab2AWVIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 16:08:05 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org, Milton Miller <miltonm@bga.com>,
        benh@kernel.crashing.org, Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFCv2 01/14] irq_domain: add documentation and MAINTAINERS entry.
Date: Mon, 23 Jan 2012 14:07:37 -0700
Message-Id: <1327352870-14687-2-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1327352870-14687-1-git-send-email-grant.likely@secretlab.ca>
References: <1327352870-14687-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation for irq_domain library which will be created in subsequent
patches.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/IRQ-domain.txt |  113 ++++++++++++++++++++++++++++++++++++++++++
 MAINTAINERS                  |    9 +++
 2 files changed, 122 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/IRQ-domain.txt

diff --git a/Documentation/IRQ-domain.txt b/Documentation/IRQ-domain.txt
new file mode 100644
index 0000000..247f32a
--- /dev/null
+++ b/Documentation/IRQ-domain.txt
@@ -0,0 +1,113 @@
+irq_domain interrupt number mapping library
+
+The current design of the Linux kernel uses a single large number
+space where each separate IRQ source is assigned a different number.
+This is simple when there is only one interrupt controller, but in
+systems with controllers the kernel must ensure that each one does not
+get assigned overlapping allocations of Linux irq numbers.
+
+The irq_alloc_desc*() and irq_free_desc*() API provides allocation of
+irq numbers, but it doesn't provide any support for reverse mapping of
+the controller-local irq (hwirq) number into the Linux irq number
+space.
+
+The irq_domain library adds mapping between hwirq and irq numbers on
+top of the irq_alloc_desc*() API.  An irq_domain to manage mapping is
+preferred over interrupt controller drivers open coding their own
+reverse mapping scheme.
+
+irq_domain also implements translation from Device Tree interrupt
+specifiers to hwirq numbers, and can be easily extended to support
+other irq topology data sources.
+
+=== irq_domain usage ===
+An interrupt controller driver creates and registers an irq_domain by
+calling one of the irq_domain_add_*() functions (each mapping method
+has a different allocator function, more on that later).  The function
+will return a pointer to the irq_domain on success.  It must provide
+the allocator function with an irq_domain_ops structure with the .map
+callback populated as a minimum.
+
+In most cases, the irq_domain will begin empty without any mappings
+between hwirq and irq numbers.  Mappings are added to the irq_domain
+by calling irq_create_mapping() which accepts the irq_domain and a
+hwirq number as arguments.  If a mapping for the hwirq doesn't already
+exist then it will allocate a new linux irq_desc, associate it with
+the hwirq, and call the .map() callback so the driver can perform any
+required hardware setup.
+
+When an interrupt is received, irq_find_mapping() function should
+be used to find the Linux irq number from the hwirq number.
+
+If the driver has the Linux irq number or the irq_data pointer, and
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
+the hwirq, and the irq number is stored in the table.
+
+The Linear map is a good choice when the maximum number of hwirqs is
+fixed and a relatively small number (~ < 256).  The advantages of this
+map are fixed time lookup for irq numbers, and irq_descs are only
+allocated for in-use irqs.  The disadvantage is that the table must be
+as large as the largest possible hwirq number.
+
+The majority of drivers should use the linear map.
+
+==== Tree ====
+irq_domain_add_tree()
+
+The irq_domain maintains a radix tree map from hwirq numbers to linux
+irqs.  When an hwirq is mapped, and irq_desc is allocated and the
+hwirq is used as the lookup key for the radix tree.
+
+The tree map is a good choice if the hwirq number can be very large
+since it doesn't need to allocate a table as large as the largest
+hwirq number.  The disadvantage is that hwirq to irq number lookup is
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
+Linux irq number into the hardware itself so that no mapping is
+required.  Calling irq_create_direct_mapping() will allocate a linux
+irq number and call the .map() callback so that driver can program the
+Linux irq number into the hardware.
+
+Most drivers cannot use this mapping.
+
+==== Legacy ====
+irq_domain_add_legacy()
+irq_domain_add_legacy_isa()
+
+The Legacy mapping is a special case for drivers that already have a
+range of irq_descs allocated for the hwirqs.  It is used when the
+driver cannot be immediately converted to use the linear mapping, such
+as when the driver is used in a system with fixed irq number
+assignments, as is typical in many embedded system board files.
+
+The legacy map assumes a contiguous range of irq numbers has already
+been allocated for the controller and that the irq number can be
+calculated by adding a fixed offset to the hwirq number, and
+visa-versa.  The disadvantage is that it requires the interrupt
+controller to manage irq allocations and it requires an irq_desc to be
+allocated for every hwirq, even if it is unused.
+
+Drivers should only use the legacy map if they have fixed irq mappings
+(#define IRQ_* in embedded board files).  For example, ISA controllers
+mapped to Linux irqs 0-15 would use the legacy map.
diff --git a/MAINTAINERS b/MAINTAINERS
index 89b70df..d308f0f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3626,6 +3626,15 @@ S:	Maintained
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
1.7.5.4

