Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab1GENAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 09:00:25 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:37131 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756367Ab1GENAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 09:00:23 -0400
X-IronPort-AV: E=Sophos;i="4.65,479,1304308800"; 
   d="scan'208";a="153527743"
From: Ian Campbell <ian.campbell@citrix.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Brian Gerst <brgerst@gmail.com>, Jan Beulich <JBeulich@novell.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Campbell <ian.campbell@citrix.com>, x86@kernel.org
Subject: [PATCH 2/3] x86: make 64 bit ret_from_fork a little more similar to 32 bit
Date: Tue, 5 Jul 2011 14:00:13 +0100
Message-ID: <1309870814-14181-2-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <20110705111525.GR17941@sun>
References: <20110705111525.GR17941@sun>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 64 bit version resets EFLAGS before calling schedule_tail() and
therefore leaves EFLAGS.IF clear. 32 bit resets EFLAGS after calling
schedule_tail() and therefore leaves EFLAGS.IF set. I don't think
there is any practical difference between the two approaches since
interrupts are actually reenabled within schedule_tail
(schedule_tail->finish_task_switch->finish_lock_switch->raw_spin_unlock_irq->...->local_irq_enable)
so arbitrarily pick the 32 bit version and make 64 bit look like that.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: x86@kernel.org
---
 arch/x86/kernel/entry_64.S |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b50d142..9c28bd5 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -394,13 +394,14 @@ END(save_paranoid)
 ENTRY(ret_from_fork)
 	DEFAULT_FRAME
 
-	LOCK ; btr $TIF_FORK,TI_flags(%r8)
 
-	pushq_cfi $0x0002
-	popfq_cfi				# reset kernel eflags
+	LOCK ; btr $TIF_FORK,TI_flags(%r8)
 
 	call schedule_tail			# rdi: 'prev' task parameter
 
+	pushq_cfi $0x0202
+	popfq_cfi				# reset kernel eflags
+
 	GET_THREAD_INFO(%rcx)
 
 	RESTORE_REST
-- 
1.7.2.5

