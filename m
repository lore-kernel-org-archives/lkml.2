Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758980Ab2EIMa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 08:30:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51919 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757155Ab2EIMaz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 08:30:55 -0400
Message-ID: <1336566644.2527.33.camel@twins>
Subject: Re: [PATCH] sched_groups are expected to be circular linked list,
 make it so right after allocation
From: Peter Zijlstra <peterz@infradead.org>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Jiang Liu <liuj97@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, pjt@google.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com
Date: Wed, 09 May 2012 14:30:44 +0200
In-Reply-To: <1336566096.2527.30.camel@twins>
References: <1336559908-32533-1-git-send-email-imammedo@redhat.com>
	 <4FAA452A.1070909@gmail.com> <4FAA588B.5010404@redhat.com>
	 <1336564330.2527.23.camel@twins> <4FAA5BFB.40309@redhat.com>
	 <1336566096.2527.30.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 14:21 +0200, Peter Zijlstra wrote:
> Does something like the below give any clues as to how we got there?

New version that checks we include the right cpu in build_sched_domain()
too.. on a related note, we should add a printk-%p modifier for cpulist,
this cpulist_scnprintf() stuff gets annoying.

---
 include/linux/sched.h |    9 +++++++++
 kernel/sched/core.c   |   26 ++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 714fa99..416aad9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1041,6 +1041,15 @@ struct sched_domain {
 	unsigned long span[0];
 };
 
+static inline char *sched_domain_name(struct sched_domain *sd)
+{
+#ifdef CONFIG_SCHED_DEBUG
+	return sd->name;
+#else
+	return "";
+#endif
+}
+
 static inline struct cpumask *sched_domain_span(struct sched_domain *sd)
 {
 	return to_cpumask(sd->span);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7b77e3b..2884134 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6072,6 +6072,22 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 		last = sg;
 		last->next = first;
 	}
+	if (!groups) {
+		char str[256];
+
+		printk(KERN_ERR "sched: Topology is hosed for CPU-%d!!\n", cpu);
+		cpulist_scnprintf(str, sizeof(str), sched_domain_span(sd));
+		printk(KERN_ERR "sched: domain: %s %s\n", sched_domain_name(sd), str);
+		
+		sg = first;
+		if (sg) do {
+			cpulist_scnprintf(str, sizeof(str), sched_group_cpus(sg));
+			printk(KERN_ERR "sched:  group: %s\n", str);
+			sg = sg->next;
+		} while (sg != first);
+
+		BUG();
+	}
 	sd->groups = groups;
 
 	return 0;
@@ -6440,6 +6456,16 @@ struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
 
 	set_domain_attribute(sd, attr);
 	cpumask_and(sched_domain_span(sd), cpu_map, tl->mask(cpu));
+	if (!cpumask_test_cpu(cpu, sched_domain_span(sd))) {
+		char str[256];
+		cpulist_scnprintf(str, sizeof(str), cpu_map);
+		printk(KERN_ERR "sched: Bonkers domain doesn't include its own cpu: %d %s\n",
+				cpu, str);
+		cpulist_scnprintf(str, sizeof(str), tl->mask(cpu));
+		printk(KERN_ERR "sched: Bonkers domain doesn't include its own cpu: %d %s\n",
+				cpu, str);
+		WARN(1);
+	}
 	if (child) {
 		sd->level = child->level + 1;
 		sched_domain_level_max = max(sched_domain_level_max, sd->level);

