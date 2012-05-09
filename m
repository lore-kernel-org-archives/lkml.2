Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455Ab2EIKfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 06:35:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39298 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab2EIKfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 06:35:45 -0400
Date: Wed, 9 May 2012 03:35:32 -0700
From: tip-bot for Igor Mammedov <imammedo@redhat.com>
Message-ID: <tip-30b4e9eb783d94e9f5d503b15eb31720679ae1c7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        imammedo@redhat.com, liuj97@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        imammedo@redhat.com, tglx@linutronix.de, liuj97@gmail.com
In-Reply-To: <1336559908-32533-1-git-send-email-imammedo@redhat.com>
References: <1336559908-32533-1-git-send-email-imammedo@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched:
  Fix KVM and ia64 boot crash due to sched_groups circular linked list assumption
Git-Commit-ID: 30b4e9eb783d94e9f5d503b15eb31720679ae1c7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 09 May 2012 03:35:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  30b4e9eb783d94e9f5d503b15eb31720679ae1c7
Gitweb:     http://git.kernel.org/tip/30b4e9eb783d94e9f5d503b15eb31720679ae1c7
Author:     Igor Mammedov <imammedo@redhat.com>
AuthorDate: Wed, 9 May 2012 12:38:28 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 May 2012 12:27:35 +0200

sched: Fix KVM and ia64 boot crash due to sched_groups circular linked list assumption

If we have one cpu that failed to boot and boot cpu gave up on
waiting for it and then another cpu is being booted, kernel
might crash with following OOPS:

   BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
   IP: [<ffffffff812c3630>] __bitmap_weight+0x30/0x80
   Call Trace:
       [<ffffffff8108b9b6>] build_sched_domains+0x7b6/0xa50

The crash happens in init_sched_groups_power() that expects
sched_groups to be circular linked list. However it is not
always true, since sched_groups preallocated in __sdt_alloc are
initialized in build_sched_groups and it may exit early

        if (cpu != cpumask_first(sched_domain_span(sd)))
                return 0;

without initializing sd->groups->next field.

Fix bug by initializing next field right after sched_group was
allocated.

Also-Reported-by: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Igor Mammedov <imammedo@redhat.com>
Cc: a.p.zijlstra@chello.nl
Cc: pjt@google.com
Cc: seto.hidetoshi@jp.fujitsu.com
Link: http://lkml.kernel.org/r/1336559908-32533-1-git-send-email-imammedo@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0533a68..e5212ae 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6382,6 +6382,8 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
 			if (!sg)
 				return -ENOMEM;
 
+			sg->next = sg;
+
 			*per_cpu_ptr(sdd->sg, j) = sg;
 
 			sgp = kzalloc_node(sizeof(struct sched_group_power),
