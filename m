Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933630Ab1DNR6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:58:25 -0400
Received: from mail.windriver.com ([147.11.1.11]:41963 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964938Ab1DNR6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:18 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Arjan van de Ven <arjan@linux.kernel.org>, Len Brown <lenb@kernel.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.hl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 154/209] x86, hotplug: Move WBINVD back outside the play_dead loop
Date: Thu, 14 Apr 2011 13:55:12 -0400
Message-Id: <1302803767-9715-41-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@linux.intel.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit a68e5c94f7d3dd64fef34dd5d97e365cae4bb42a upstream.

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/smpboot.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index d528e75..b283dbf 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1399,9 +1399,9 @@ static inline void mwait_play_dead(void)
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
@@ -1410,11 +1410,10 @@ static inline void mwait_play_dead(void)
 
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
-- 
1.7.4.4

