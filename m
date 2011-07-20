Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab1GTRaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 13:30:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:58071 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879Ab1GTRaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 13:30:06 -0400
Date: Wed, 20 Jul 2011 17:29:33 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-d110235d2c331c4f79e0879f51104be79e17a469@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
        mingo@redhat.com, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1311180177.29152.57.camel@twins>
References: <1311180177.29152.57.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Avoid creating superfluous NUMA domains on non-NUMA systems
Git-Commit-ID: d110235d2c331c4f79e0879f51104be79e17a469
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 20 Jul 2011 17:29:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d110235d2c331c4f79e0879f51104be79e17a469
Gitweb:     http://git.kernel.org/tip/d110235d2c331c4f79e0879f51104be79e17a469
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 20 Jul 2011 18:42:57 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 20 Jul 2011 18:54:33 +0200

sched: Avoid creating superfluous NUMA domains on non-NUMA systems

When creating sched_domains, stop when we've covered the entire
target span instead of continuing to create domains, only to
later find they're redundant and throw them away again.

This avoids single node systems from touching funny NUMA
sched_domain creation code and reduces the risks of the new
SD_OVERLAP code.

Requested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Anton Blanchard <anton@samba.org>
Cc: mahesh@linux.vnet.ibm.com
Cc: benh@kernel.crashing.org
Cc: linuxppc-dev@lists.ozlabs.org
Link: http://lkml.kernel.org/r/1311180177.29152.57.camel@twins
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 921adf6..14168c4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7436,6 +7436,8 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 			sd = build_sched_domain(tl, &d, cpu_map, attr, sd, i);
 			if (tl->flags & SDTL_OVERLAP || sched_feat(FORCE_SD_OVERLAP))
 				sd->flags |= SD_OVERLAP;
+			if (cpumask_equal(cpu_map, sched_domain_span(sd)))
+				break;
 		}
 
 		while (sd->child)
