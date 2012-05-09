Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749Ab2EIMVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 08:21:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51875 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527Ab2EIMVw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 08:21:52 -0400
Message-ID: <1336566096.2527.30.camel@twins>
Subject: Re: [PATCH] sched_groups are expected to be circular linked list,
 make it so right after allocation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Jiang Liu <liuj97@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, pjt@google.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com
Date: Wed, 09 May 2012 14:21:36 +0200
In-Reply-To: <4FAA5BFB.40309@redhat.com>
References: <1336559908-32533-1-git-send-email-imammedo@redhat.com>
	  <4FAA452A.1070909@gmail.com> <4FAA588B.5010404@redhat.com>
	 <1336564330.2527.23.camel@twins> <4FAA5BFB.40309@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 13:58 +0200, Igor Mammedov wrote:
> On 05/09/2012 01:52 PM, Peter Zijlstra wrote:
> > On Wed, 2012-05-09 at 13:44 +0200, Igor Mammedov wrote:
> >> This patch fixes only build_sched_groups path, but there is another fail path
> >> that results in below OOPS.
> >> build_overlap_sched_groups() may exit without setting groups and later it will crash
> >> init_sched_groups_power as well.
> >
> > if that allocation fails? Or is there another fail path?
> 
> build_overlap_sched_groups(struct sched_domain *sd, int cpu)
> ...
>                  if (cpumask_test_cpu(cpu, sg_span))
>                          groups = sg;
> ...
> 
> above test fails and leaves local var groups set to NULL
> and before exit there is:
> 
>    sd->groups = groups;
> 
> which resets sd->groups to NULL 

Cute! So we're building groups for @cpu, for a domain on the same @cpu,
but none of the groups actually span this @cpu. This would imply the
domain doesn't actually contain @cpu.

> and I'm not sure if it is correct at all to skip this
> assignment if groups == NULL. 

It would avoid exploding, but nothing in the above situation is anywhere
near correct.

Does something like the below give any clues as to how we got there?

---
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1043,6 +1043,15 @@ struct sched_domain {
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
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5993,6 +5993,22 @@ build_overlap_sched_groups(struct sched_
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

