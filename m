Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab1GGUgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 16:36:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36671 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab1GGUgl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 16:36:41 -0400
Subject: jump_label defaults (was Re: [patch 00/17] CFS Bandwidth Control
 v7.1)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jason Baron <jbaron@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@openvz.org>, Hu Tao <hutao@cn.fujitsu.com>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <20110707181535.GD2536@redhat.com>
References: <20110707053036.173186930@google.com>
	 <20110707112302.GB8227@elte.hu> <1310049528.3282.583.camel@twins>
	 <20110707145159.GD19193@elte.hu> <1310050482.3282.584.camel@twins>
	 <20110707145620.GF19193@elte.hu> <20110707162344.GB2536@redhat.com>
	 <1310059220.3282.591.camel@twins>  <20110707181535.GD2536@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 07 Jul 2011 22:36:14 +0200
Message-ID: <1310070974.3282.678.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[resend because I somehow managed to wreck the lkml address]

On Thu, 2011-07-07 at 14:15 -0400, Jason Baron wrote:
> We don't have to wait until jump_label_init() to make it take effect.
> 
> We could introduce something like: static_branch_default_false(&foo),
> and static_branch_default_true(&foo), which are set at compile time. I
> was waiting for a real world example before introducing it, but if this
> would solve your issue,  we can look at it. 

Hrm,. I can't seem to make that work, damn CPP for not being recursive.

The thing in question is the below patch, I'd need something like:

sed -ie 's/1)/true)' -e 's/0)/false)/' kernel/sched_features.h

#define SCHED_FEAT(name, enabled)	\
	#define static_branch_##name static_branch_default_##enabled
#include "sched_features.h"
#undef SCHED_FEAT

so that I can then do:

#define sched_feat(x)	\
	static_branch_##x(&sched_feat_keys[__SCHED_FEAT_##x]))

Otherwise there's no way to get the default thing related to x.

Also, it still needs an initializer for jump_label_key to get in the
correct state.

---
Subject: sched: Use jump_labels for sched_feat
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Jul 06 14:20:14 CEST 2011

static_branch() is disabled by default, but more sched_feat are enabled
by default, so invert the logic. Fixup the few stragglers on
late_initcall().

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-10afjk8n3eu30jytrhdpaluc@git.kernel.org
---
 kernel/sched.c |   33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -71,6 +71,7 @@
 #include <linux/ctype.h>
 #include <linux/ftrace.h>
 #include <linux/slab.h>
+#include <linux/jump_label.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -691,6 +692,7 @@ int runqueue_is_locked(int cpu)
 
 enum {
 #include "sched_features.h"
+	__SCHED_FEAT_NR
 };
 
 #undef SCHED_FEAT
@@ -710,16 +712,17 @@ const_debug unsigned int sysctl_sched_fe
 
 static __read_mostly char *sched_feat_names[] = {
 #include "sched_features.h"
-	NULL
 };
 
 #undef SCHED_FEAT
 
+static struct jump_label_key sched_feat_keys[__SCHED_FEAT_NR];
+
 static int sched_feat_show(struct seq_file *m, void *v)
 {
 	int i;
 
-	for (i = 0; sched_feat_names[i]; i++) {
+	for (i = 0; i < __SCHED_FEAT_NR; i++) {
 		if (!(sysctl_sched_features & (1UL << i)))
 			seq_puts(m, "NO_");
 		seq_printf(m, "%s ", sched_feat_names[i]);
@@ -752,17 +755,22 @@ sched_feat_write(struct file *filp, cons
 		cmp += 3;
 	}
 
-	for (i = 0; sched_feat_names[i]; i++) {
+	for (i = 0; i < __SCHED_FEAT_NR; i++) {
 		if (strcmp(cmp, sched_feat_names[i]) == 0) {
-			if (neg)
+			if (neg) {
 				sysctl_sched_features &= ~(1UL << i);
-			else
+				if (!jump_label_enabled(&sched_feat_keys[i]))
+					jump_label_inc(&sched_feat_keys[i]);
+			} else {
 				sysctl_sched_features |= (1UL << i);
+				if (jump_label_enabled(&sched_feat_keys[i]))
+					jump_label_dec(&sched_feat_keys[i]);
+			}
 			break;
 		}
 	}
 
-	if (!sched_feat_names[i])
+	if (i == __SCHED_FEAT_NR)
 		return -EINVAL;
 
 	*ppos += cnt;
@@ -785,6 +793,13 @@ static const struct file_operations sche
 
 static __init int sched_init_debug(void)
 {
+	int i;
+
+	for (i = 0; i < __SCHED_FEAT_NR; i++) {
+		if (!(sysctl_sched_features & (1UL << i)))
+			jump_label_inc(&sched_feat_keys[i]);
+	}
+
 	debugfs_create_file("sched_features", 0644, NULL, NULL,
 			&sched_feat_fops);
 
@@ -792,10 +807,14 @@ static __init int sched_init_debug(void)
 }
 late_initcall(sched_init_debug);
 
-#endif
+#define sched_feat(x) (!static_branch(&sched_feat_keys[__SCHED_FEAT_##x]))
+
+#else /* CONFIG_SCHED_DEBUG */
 
 #define sched_feat(x) (sysctl_sched_features & (1UL << __SCHED_FEAT_##x))
 
+#endif /* CONFIG_SCHED_DEBUG */
+
 /*
  * Number of tasks to iterate in a single balance run.
  * Limited because this is done with IRQs disabled.


