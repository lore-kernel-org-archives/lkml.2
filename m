Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967978Ab2ERKXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:23:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42222 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967944Ab2ERKXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:23:35 -0400
Date: Fri, 18 May 2012 03:23:06 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-d8oko7nje416ubwoy7u0cjrj@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, pjt@google.com,
        cl@linux.com, riel@redhat.com, akpm@linux-foundation.org,
        bharata.rao@gmail.com, aarcange@redhat.com, Lee.Schermerhorn@hp.com,
        suresh.b.siddha@intel.com, danms@us.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        cl@linux.com, riel@redhat.com, bharata.rao@gmail.com,
        akpm@linux-foundation.org, Lee.Schermerhorn@hp.com,
        aarcange@redhat.com, danms@us.ibm.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] mm/mpol: Make MPOL_LOCAL a real policy
Git-Commit-ID: 03ed7b538ca08b982be2d5893a696bdce573665c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:23:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  03ed7b538ca08b982be2d5893a696bdce573665c
Gitweb:     http://git.kernel.org/tip/03ed7b538ca08b982be2d5893a696bdce573665c
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 19 Mar 2012 18:54:52 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 17 May 2012 14:06:13 +0200

mm/mpol: Make MPOL_LOCAL a real policy

Make MPOL_LOCAL a real and exposed policy such that applications that
relied on the previous default behaviour can explicitly request it.

Requested-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Paul Turner <pjt@google.com>
Cc: Dan Smith <danms@us.ibm.com>
Cc: Bharata B Rao <bharata.rao@gmail.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-d8oko7nje416ubwoy7u0cjrj@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/mempolicy.h |    1 +
 mm/mempolicy.c            |    9 ++++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 7c727a9..a51e5db 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -20,6 +20,7 @@ enum {
 	MPOL_PREFERRED,
 	MPOL_BIND,
 	MPOL_INTERLEAVE,
+	MPOL_LOCAL,
 	MPOL_MAX,	/* always last member of enum */
 };
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 82d209b..a7516db 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -269,6 +269,10 @@ static struct mempolicy *mpol_new(unsigned short mode, unsigned short flags,
 			     (flags & MPOL_F_RELATIVE_NODES)))
 				return ERR_PTR(-EINVAL);
 		}
+	} else if (mode == MPOL_LOCAL) {
+		if (!nodes_empty(*nodes))
+			return ERR_PTR(-EINVAL);
+		mode = MPOL_PREFERRED;
 	} else if (nodes_empty(*nodes))
 		return ERR_PTR(-EINVAL);
 	policy = kmem_cache_alloc(policy_cache, GFP_KERNEL);
@@ -2260,7 +2264,6 @@ void numa_default_policy(void)
  * "local" is pseudo-policy:  MPOL_PREFERRED with MPOL_F_LOCAL flag
  * Used only for mpol_parse_str() and mpol_to_str()
  */
-#define MPOL_LOCAL MPOL_MAX
 static const char * const policy_modes[] =
 {
 	[MPOL_DEFAULT]    = "default",
@@ -2313,12 +2316,12 @@ int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
 	if (flags)
 		*flags++ = '\0';	/* terminate mode string */
 
-	for (mode = 0; mode <= MPOL_LOCAL; mode++) {
+	for (mode = 0; mode < MPOL_MAX; mode++) {
 		if (!strcmp(str, policy_modes[mode])) {
 			break;
 		}
 	}
-	if (mode > MPOL_LOCAL)
+	if (mode >= MPOL_MAX)
 		goto out;
 
 	switch (mode) {
