Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab1DSRuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 13:50:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:39327 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378Ab1DSRuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 13:50:13 -0400
Date: Tue, 19 Apr 2011 17:49:23 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-7b70bd3441437b7bc04fc9d321e17c8ed0e8f958@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, tony.luck@intel.com, rja@sgi.com,
        akpm@linux-foundation.org, Nagananda.Chumbalkar@hp.com,
        tglx@linutronix.de, prarit@redhat.com, mingo@elte.hu,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, tony.luck@intel.com, rja@sgi.com,
        akpm@linux-foundation.org, Nagananda.Chumbalkar@hp.com,
        tglx@linutronix.de, prarit@redhat.com, borislav.petkov@amd.com,
        mingo@elte.hu
In-Reply-To: <1303135222-17118-1-git-send-email-bp@amd64.org>
References: <1303135222-17118-1-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mce] x86, MCE: Do not taint when handling correctable errors
Git-Commit-ID: 7b70bd3441437b7bc04fc9d321e17c8ed0e8f958
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Apr 2011 17:49:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7b70bd3441437b7bc04fc9d321e17c8ed0e8f958
Gitweb:     http://git.kernel.org/tip/7b70bd3441437b7bc04fc9d321e17c8ed0e8f958
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Mon, 18 Apr 2011 16:00:21 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 19 Apr 2011 19:14:13 +0200

x86, MCE: Do not taint when handling correctable errors

Correctable errors are considered something rather normal on
modern hardware these days. Even more importantly, correctable
errors mean exactly that - they've been corrected by the
hardware - and there's no need to taint the kernel since
execution hasn't been compromised so far.

Also, drop tainting in the thermal throttling code for a similar
reason: crossing a thermal threshold does not mean corruption.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Acked-by: Tony Luck <tony.luck@intel.com>
Acked-by: Nagananda Chumbalkar <Nagananda.Chumbalkar@hp.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1303135222-17118-1-git-send-email-bp@amd64.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mcheck/mce.c         |    1 -
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    3 ---
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 3385ea2..68e2303 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -590,7 +590,6 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		if (!(flags & MCP_DONTLOG) && !mce_dont_log_ce) {
 			mce_log(&m);
 			atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, &m);
-			add_taint(TAINT_MACHINE_CHECK);
 		}
 
 		/*
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 6f8c5e9..5846a79 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -187,8 +187,6 @@ static int therm_throt_process(bool new_event, int event, int level)
 				this_cpu,
 				level == CORE_LEVEL ? "Core" : "Package",
 				state->count);
-
-		add_taint(TAINT_MACHINE_CHECK);
 		return 1;
 	}
 	if (old_event) {
@@ -393,7 +391,6 @@ static void unexpected_thermal_interrupt(void)
 {
 	printk(KERN_ERR "CPU%d: Unexpected LVT thermal interrupt!\n",
 			smp_processor_id());
-	add_taint(TAINT_MACHINE_CHECK);
 }
 
 static void (*smp_thermal_vector)(void) = unexpected_thermal_interrupt;
