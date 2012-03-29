Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640Ab2C2Jyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 05:54:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34235 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327Ab2C2Jyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 05:54:44 -0400
Date: Thu, 29 Mar 2012 02:54:21 -0700
From: tip-bot for Prarit Bhargava <prarit@redhat.com>
Message-ID: <tip-241fc640be783f903e74b6d9c68481c01873f758@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, nhorman@tuxdriver.com, tglx@linutronix.de,
        prarit@redhat.com, rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, nhorman@tuxdriver.com, tglx@linutronix.de,
        prarit@redhat.com, rientjes@google.com
In-Reply-To: <1332788538-17425-1-git-send-email-prarit@redhat.com>
References: <1332788538-17425-1-git-send-email-prarit@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq:
  Respect NUMA node affinity in setup_irq_irq affinity()
Git-Commit-ID: 241fc640be783f903e74b6d9c68481c01873f758
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 29 Mar 2012 02:54:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  241fc640be783f903e74b6d9c68481c01873f758
Gitweb:     http://git.kernel.org/tip/241fc640be783f903e74b6d9c68481c01873f758
Author:     Prarit Bhargava <prarit@redhat.com>
AuthorDate: Mon, 26 Mar 2012 15:02:18 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 29 Mar 2012 11:31:53 +0200

genirq: Respect NUMA node affinity in setup_irq_irq affinity()

We respect node affinity of devices already in the irq descriptor
allocation, but we ignore it for the initial interrupt affinity
setup, so the interrupt might be routed to a different node.

Restrict the default affinity mask to the node on which the irq
descriptor is allocated.

[ tglx: Massaged changelog ]

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Link: http://lkml.kernel.org/r/1332788538-17425-1-git-send-email-prarit@redhat.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index bf606a5..89a3ea8 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -282,7 +282,7 @@ setup_affinity(unsigned int irq, struct irq_desc *desc, struct cpumask *mask)
 {
 	struct irq_chip *chip = irq_desc_get_chip(desc);
 	struct cpumask *set = irq_default_affinity;
-	int ret;
+	int ret, node = desc->irq_data.node;
 
 	/* Excludes PER_CPU and NO_BALANCE interrupts */
 	if (!irq_can_set_affinity(irq))
@@ -301,6 +301,13 @@ setup_affinity(unsigned int irq, struct irq_desc *desc, struct cpumask *mask)
 	}
 
 	cpumask_and(mask, cpu_online_mask, set);
+	if (node != NUMA_NO_NODE) {
+		const struct cpumask *nodemask = cpumask_of_node(node);
+
+		/* make sure at least one of the cpus in nodemask is online */
+		if (cpumask_intersects(mask, nodemask))
+			cpumask_and(mask, mask, nodemask);
+	}
 	ret = chip->irq_set_affinity(&desc->irq_data, mask, false);
 	switch (ret) {
 	case IRQ_SET_MASK_OK:
