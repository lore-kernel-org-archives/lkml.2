Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab2CMOJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 10:09:46 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36775 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab2CMOJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 10:09:43 -0400
From: Jiang Liu <liuj97@gmail.com>
Cc: Liu Jiang <jiang.liu@huawei.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org (open list), chenkeping@huawei.com
Subject: [PATCH] IA64: fix ISA IRQ trigger model and polarity setting
Date: Tue, 13 Mar 2012 22:07:09 +0800
Message-Id: <1331647629-11550-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Jiang <jiang.liu@huawei.com>

This bug interfered with another bug in QLA FC driver has caused big
trouble to us during the past month when validating a 32P Poulson
system with plenty of IO devices. Hope it could find its way into the
mainstream kernel. Thanks!

---

When handling Interrupt Source Override in MADT table, the default
ISA IRQ trigger model and poliarity should be edge-rising.
Current IA64 implmentation doesn't follow the specification and
set default ISA IRQ trigger model as level-low. With that wrong
configuration and when system runs out of interrupt vectors,
it will cause vector sharing among edge triggered ISA IRQ and
level triggered PCI IRQ, then interrupt storm. So change the code
to follow the specification.

Signed-off-by: Liu Jiang <jiang.liu@huawei.com>
---
 arch/ia64/kernel/acpi.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index bfb4d01..18c33d6 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -349,11 +349,11 @@ acpi_parse_int_src_ovr(struct acpi_subtable_header * header,
 
 	iosapic_override_isa_irq(p->source_irq, p->global_irq,
 				 ((p->inti_flags & ACPI_MADT_POLARITY_MASK) ==
-				  ACPI_MADT_POLARITY_ACTIVE_HIGH) ?
-				 IOSAPIC_POL_HIGH : IOSAPIC_POL_LOW,
+				  ACPI_MADT_POLARITY_ACTIVE_LOW) ?
+				 IOSAPIC_POL_LOW : IOSAPIC_POL_HIGH,
 				 ((p->inti_flags & ACPI_MADT_TRIGGER_MASK) ==
-				 ACPI_MADT_TRIGGER_EDGE) ?
-				 IOSAPIC_EDGE : IOSAPIC_LEVEL);
+				 ACPI_MADT_TRIGGER_LEVEL) ?
+				 IOSAPIC_LEVEL : IOSAPIC_EDGE);
 	return 0;
 }
 
-- 
1.7.1

