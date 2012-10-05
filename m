Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab2JENG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 09:06:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34721 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab2JENGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 09:06:54 -0400
Date: Fri, 5 Oct 2012 06:06:34 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-i0egmq9r7tzocxo5pmc8jbfi@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        akpm@linux-foundation.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        fengguang.wu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, akpm@linux-foundation.org, tglx@linutronix.de,
        fengguang.wu@intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] mm/mpol:
  Fix potential buffer overflow in mpol_parse_str()
Git-Commit-ID: b9fb9910378947a2b7d58ca75d805b907929e001
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 06:06:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b9fb9910378947a2b7d58ca75d805b907929e001
Gitweb:     http://git.kernel.org/tip/b9fb9910378947a2b7d58ca75d805b907929e001
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 1 Oct 2012 15:12:16 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 5 Oct 2012 14:00:30 +0200

mm/mpol: Fix potential buffer overflow in mpol_parse_str()

Wu reported an Smatch error:

+ mm/mempolicy.c:2426 mpol_parse_str() error: buffer overflow 'policy_modes' 5 <= 5

Fix it by growing the array to the right size, but avoid it being a
valid string for mpol_parse_str() because its not an effective policy.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-i0egmq9r7tzocxo5pmc8jbfi@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/mempolicy.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 7b4ff19..e59756a 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2514,7 +2514,8 @@ static const char * const policy_modes[] =
 	[MPOL_PREFERRED]  = "prefer",
 	[MPOL_BIND]       = "bind",
 	[MPOL_INTERLEAVE] = "interleave",
-	[MPOL_LOCAL]      = "local"
+	[MPOL_LOCAL]      = "local",
+	[MPOL_NOOP]	  = "noop",	/* should not actually be used */
 };
 
 
@@ -2565,7 +2566,7 @@ int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
 			break;
 		}
 	}
-	if (mode >= MPOL_MAX)
+	if (mode >= MPOL_MAX || mode == MPOL_NOOP)
 		goto out;
 
 	switch (mode) {
