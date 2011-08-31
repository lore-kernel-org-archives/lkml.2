Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab1HaJWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 05:22:53 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:48741 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab1HaJWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 05:22:47 -0400
X-IronPort-AV: E=Sophos;i="4.68,306,1312171200"; 
   d="scan'208";a="161255062"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
CC: Cyrill Gorcunov <gorcunov@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pekka Enberg <penberg@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Ian Campbell <ian.campbell@citrix.com>, x86@kernel.org
Subject: [PATCH 2/2] x86: make 32 bit ret_from_fork a little more similar to 64 bit
Date: Wed, 31 Aug 2011 10:22:40 +0100
Message-ID: <1314782560-19146-2-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1314782541.28989.37.camel@zakaz.uk.xensource.com>
References: <1314782541.28989.37.camel@zakaz.uk.xensource.com>
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
index f3f6f53..8b8794b 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -300,12 +300,12 @@
 
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

