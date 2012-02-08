Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab2BHUsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 15:48:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275Ab2BHUsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 15:48:36 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH] Use NUMA node cpu mask in irq affinity
Date: Wed,  8 Feb 2012 15:48:33 -0500
Message-Id: <1328734113-3608-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The irq affinity files (/proc/irq/.../smp_affinity) contain a mask that is used
to "pin" an irq to a set of cpus.  On boot this set is currently all cpus.
This can be incorrect as ACPI SRAT may tell us that a specific device or
bus is attached to a particular node and it's cpus.

When setting up the irq affinity we should take into account the NUMA node
cpu mask by and'ing it into the irq's affinity mask.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
---
 kernel/irq/manage.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index a9a9dbe..2fb3469 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -301,6 +301,8 @@ setup_affinity(unsigned int irq, struct irq_desc *desc, struct cpumask *mask)
 	}
 
 	cpumask_and(mask, cpu_online_mask, set);
+	if (desc->irq_data.node != -1)
+		cpumask_and(mask, mask, cpumask_of_node(desc->irq_data.node));
 	ret = chip->irq_set_affinity(&desc->irq_data, mask, false);
 	switch (ret) {
 	case IRQ_SET_MASK_OK:
-- 
1.7.1

