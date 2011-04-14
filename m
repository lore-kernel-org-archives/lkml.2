Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964905Ab1DNSNW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:13:22 -0400
Received: from mail.windriver.com ([147.11.1.11]:41973 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964943Ab1DNR6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:19 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Arjan van de Ven <arjan@linux.kernel.org>, Len Brown <lenb@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 155/209] x86, hotplug: In the MWAIT case of play_dead, CLFLUSH the cache line
Date: Thu, 14 Apr 2011 13:55:13 -0400
Message-Id: <1302803767-9715-42-git-send-email-paul.gortmaker@windriver.com>
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

commit ce5f68246bf2385d6174856708d0b746dc378f20 upstream.

When we're using MWAIT for play_dead, explicitly CLFLUSH the cache
line before executing MONITOR.  This is a potential workaround for the
Xeon 7400 erratum AAI65 after having a spurious wakeup and returning
around the loop.  "Potential" here because it is not certain that that
erratum could actually trigger; however, the CLFLUSH should be
harmless.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Acked-by: Venkatesh Pallipadi <venki@google.com>
Cc: Asit Mallick <asit.k.mallick@intel.com>
Cc: Arjan van de Ven <arjan@linux.kernel.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/smpboot.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index b283dbf..9a4fdc5 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1371,9 +1371,12 @@ static inline void mwait_play_dead(void)
 	unsigned int highest_cstate = 0;
 	unsigned int highest_subcstate = 0;
 	int i;
+	void *mwait_ptr;
 
 	if (!cpu_has(&current_cpu_data, X86_FEATURE_MWAIT))
 		return;
+	if (!cpu_has(&current_cpu_data, X86_FEATURE_CLFLSH))
+		return;
 	if (current_cpu_data.cpuid_level < CPUID_MWAIT_LEAF)
 		return;
 
@@ -1399,10 +1402,25 @@ static inline void mwait_play_dead(void)
 			(highest_subcstate - 1);
 	}
 
+	/*
+	 * This should be a memory location in a cache line which is
+	 * unlikely to be touched by other processors.  The actual
+	 * content is immaterial as it is not actually modified in any way.
+	 */
+	mwait_ptr = &current_thread_info()->flags;
+
 	wbinvd();
 
 	while (1) {
-		__monitor(&current_thread_info()->flags, 0, 0);
+		/*
+		 * The CLFLUSH is a workaround for erratum AAI65 for
+		 * the Xeon 7400 series.  It's not clear it is actually
+		 * needed, but it should be harmless in either case.
+		 * The WBINVD is insufficient due to the spurious-wakeup
+		 * case where we return around the loop.
+		 */
+		clflush(mwait_ptr);
+		__monitor(mwait_ptr, 0, 0);
 		mb();
 		__mwait(eax, 0);
 	}
-- 
1.7.4.4

