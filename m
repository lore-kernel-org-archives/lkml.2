Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab2BIQp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 11:45:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab2BIQp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 11:45:27 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] Use NUMA node cpu mask in irq affinity [v2]
Date: Thu,  9 Feb 2012 11:44:57 -0500
Message-Id: <1328805897-16359-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The irq affinity files (/proc/irq/.../smp_affinity) contain a mask that is u
to "pin" an irq to a set of cpus.  On boot this set is currently all cpus.
This can be incorrect as ACPI SRAT may tell us that a specific device or
bus is attached to a particular node and it's cpus.

When setting up the irq affinity we should take into account the NUMA node
cpu mask by and'ing it into the irq's affinity mask.

[v2]: Thomas and Yinghai pointed out that it is possible that the mask is
empty after and'ing in the NUMA node's cpumask.  The code now checks to see
if the mask will be empty before applying the NUMA node's cpumask.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index a9a9dbe..3064f2f 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -301,6 +301,13 @@ setup_affinity(unsigned int irq, struct irq_desc *desc, struct cpumask *mask)
 	}
 
 	cpumask_and(mask, cpu_online_mask, set);
+	if (desc->irq_data.node != -1) {
+		const struct cpumask *nodemask =
+					   cpumask_of_node(desc->irq_data.node);
+		/* make sure at least one of the cpus in nodemask is online */
+		if (cpumask_intersects(mask, nodemask))
+			cpumask_and(mask, mask, nodemask);
+	}
 	ret = chip->irq_set_affinity(&desc->irq_data, mask, false);
 	switch (ret) {
 	case IRQ_SET_MASK_OK:
-- 
1.7.1

