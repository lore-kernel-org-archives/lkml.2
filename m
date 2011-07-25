Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab1GYKDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 06:03:21 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:37834 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab1GYKDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 06:03:14 -0400
X-IronPort-AV: E=Sophos;i="4.67,259,1309752000"; 
   d="scan'208";a="156516503"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
CC: Pekka Enberg <penberg@kernel.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Ian Campbell <ian.campbell@citrix.com>, x86@kernel.org
Subject: [PATCH 2/3] x86: make 64 bit ret_from_fork a little more similar to 32 bit
Date: Mon, 25 Jul 2011 11:03:06 +0100
Message-ID: <1311588187-20079-2-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1311587883.27940.20.camel@cthulhu.hellion.org.uk>
References: <1311587883.27940.20.camel@cthulhu.hellion.org.uk>
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
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Acked-by: Cyrill Gorcunov <gorcunov@gmail.com>
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

