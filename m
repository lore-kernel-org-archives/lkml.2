Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758371Ab1DMK6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 06:58:37 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:30781
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751155Ab1DMK6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 06:58:36 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJL7TD-02-3CX-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>, <mingo@elte.hu>
CC: <brgerst@gmail.com>, <tglx@linutronix.de>, <suresh.b.siddha@intel.com>,
        <eranian@google.com>, <robert.richter@amd.com>,
        <Andreas.Herrmann3@amd.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [PATCH] x86, xsave: fix non-lazy allocation of the xsave area
Date: Wed, 13 Apr 2011 12:58:21 +0200
Message-ID: <1302692301-695807-1-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20110407153029.GU13@escobedo.osrc.amd.com>
References: <20110407153029.GU13@escobedo.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A single static xsave area just for init is not enough, since there are
more user processes that are directly executed by kernel threads. Use
fpu_alloc(), and SIGKILL the process if that fails.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/x86/include/asm/i387.h |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 989c0ac..833b6f1 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -329,15 +329,12 @@ static inline void fpu_copy(struct fpu *dst, struct fpu *src)
 }
 
 extern void fpu_finit(struct fpu *fpu);
-static union thread_xstate __init_xstate, *init_xstate = &__init_xstate;
 
 static inline void fpu_clear(struct fpu *fpu)
 {
-	if (!fpu_allocated(fpu)) {
-		BUG_ON(init_xstate == NULL);
-		fpu->state = init_xstate;
-		init_xstate = NULL;
-	}
+	if (!fpu_allocated(fpu) && fpu_alloc(fpu))
+		do_group_exit(SIGKILL);
+
 	memset(fpu->state, 0, xstate_size);
 	fpu_finit(fpu);
 	set_used_math();
-- 
1.5.6.5


