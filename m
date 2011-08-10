Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab1HJQ3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 12:29:35 -0400
Received: from smtp.citrix.com ([66.165.176.89]:33961 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753407Ab1HJQ3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 12:29:34 -0400
X-IronPort-AV: E=Sophos;i="4.67,351,1309752000"; 
   d="scan'208";a="15580621"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Pekka Enberg <penberg@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Brian Gerst <brgerst@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 2/2] x86: make 32 bit ret_from_fork a little more similar to 64 bit
Date: Wed, 10 Aug 2011 17:29:22 +0100
Message-ID: <1312993762-22774-2-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1312993743.26263.268.camel@zakaz.uk.xensource.com>
References: <1312993743.26263.268.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 64 bit version resets EFLAGS before calling schedule_tail() and
therefore leaves EFLAGS.IF clear. 32 bit resets EFLAGS after calling
schedule_tail() and therefore leaves EFLAGS.IF set.

Since the 64 bit version seems more obviously correct (although I think both
are actually right) make the 32 bit version look like that.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: x86@kernel.org
---
 arch/x86/kernel/entry_32.S |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 5c1a9197..c134617 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -299,12 +299,12 @@
 
 ENTRY(ret_from_fork)
 	CFI_STARTPROC
+	pushl_cfi $0x0002		# Reset kernel eflags
+	popfl_cfi
 	pushl_cfi %eax
 	call schedule_tail
 	GET_THREAD_INFO(%ebp)
 	popl_cfi %eax
-	pushl_cfi $0x0202		# Reset kernel eflags
-	popfl_cfi
 	jmp syscall_exit
 	CFI_ENDPROC
 END(ret_from_fork)
-- 
1.7.2.5

