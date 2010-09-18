Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab0IRANb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 20:13:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:56352 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302Ab0IRANa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 20:13:30 -0400
Date: Sat, 18 Sep 2010 00:13:05 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        asit.k.mallick@intel.com, a.p.zijlstra@chello.hl,
        arjan@linux.kernel.org, lenb@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com, venki@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        asit.k.mallick@intel.com, arjan@linux.kernel.org,
        a.p.zijlstra@chello.hl, lenb@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com, venki@google.com
In-Reply-To: <tip-ea53069231f9317062910d6e772cca4ce93de8c8@git.kernel.org>
References: <tip-ea53069231f9317062910d6e772cca4ce93de8c8@git.kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/idle] x86, hotplug: Move WBINVD back outside the play_dead loop
Message-ID: <tip-a68e5c94f7d3dd64fef34dd5d97e365cae4bb42a@git.kernel.org>
Git-Commit-ID: a68e5c94f7d3dd64fef34dd5d97e365cae4bb42a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 18 Sep 2010 00:13:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a68e5c94f7d3dd64fef34dd5d97e365cae4bb42a
Gitweb:     http://git.kernel.org/tip/a68e5c94f7d3dd64fef34dd5d97e365cae4bb42a
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 17 Sep 2010 17:06:46 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 17 Sep 2010 17:10:23 -0700

x86, hotplug: Move WBINVD back outside the play_dead loop

On processors with hyperthreading, when only one thread is offlined
the other thread can cause a spurious wakeup on the idled thread.  We
do not want to re-WBINVD when that happens.

Ideally, we should simply skip WBINVD unless we're the last thread on
a particular core to shut down, but there might be similar issues
elsewhere in the system.

Thus, revert to previous behavior of only WBINVD outside the loop.
Partly as a result, remove the mb()'s around it: they are not
necessary since wbinvd() is a serializing instruction, but they were
intended to make sure the compiler didn't do any funny loop
optimizations.

Reported-by: Asit Mallick <asit.k.mallick@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Arjan van de Ven <arjan@linux.kernel.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.hl>
LKML-Reference: <tip-ea53069231f9317062910d6e772cca4ce93de8c8@git.kernel.org>
---
 arch/x86/kernel/smpboot.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 07bf423..55c80ffb 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1422,9 +1422,9 @@ static inline void mwait_play_dead(void)
 			(highest_subcstate - 1);
 	}
 
+	wbinvd();
+
 	while (1) {
-		mb();
-		wbinvd();
 		__monitor(&current_thread_info()->flags, 0, 0);
 		mb();
 		__mwait(eax, 0);
@@ -1433,11 +1433,10 @@ static inline void mwait_play_dead(void)
 
 static inline void hlt_play_dead(void)
 {
+	if (current_cpu_data.x86 >= 4)
+		wbinvd();
+
 	while (1) {
-		mb();
-		if (current_cpu_data.x86 >= 4)
-			wbinvd();
-		mb();
 		native_halt();
 	}
 }
