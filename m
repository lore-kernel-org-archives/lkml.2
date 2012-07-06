Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab2GFGU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 02:20:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48976 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab2GFGUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 02:20:55 -0400
Date: Thu, 5 Jul 2012 23:20:39 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-xxrt0a1zronm1sm36obwc2vy@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, fweisbec@gmail.com, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Fix USER/KERNEL tagging of samples
Git-Commit-ID: ce5c1fe9a9e059b5c58f0a7e2a3e687d0efac815
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 05 Jul 2012 23:20:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ce5c1fe9a9e059b5c58f0a7e2a3e687d0efac815
Gitweb:     http://git.kernel.org/tip/ce5c1fe9a9e059b5c58f0a7e2a3e687d0efac815
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 20 Jun 2012 11:11:38 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jul 2012 20:59:07 +0200

perf/x86: Fix USER/KERNEL tagging of samples

Several perf interrupt handlers (PEBS,IBS,BTS) re-write regs->ip but
do not update the segment registers. So use an regs->ip based test
instead of an regs->cs/regs->flags based test.

Reported-and-tested-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/n/tip-xxrt0a1zronm1sm36obwc2vy@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index c4706cf..6ef9d41 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1863,7 +1863,7 @@ unsigned long perf_misc_flags(struct pt_regs *regs)
 		else
 			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
 	} else {
-		if (user_mode(regs))
+		if (!kernel_ip(regs->ip))
 			misc |= PERF_RECORD_MISC_USER;
 		else
 			misc |= PERF_RECORD_MISC_KERNEL;
