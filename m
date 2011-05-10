Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686Ab1EJOQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 10:16:00 -0400
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:55653 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932648Ab1EJOP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 10:15:58 -0400
X-AuditID: 12074424-b7bc6ae000005a77-90-4dc9489dc8ef
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@suse.de>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v3 3/6] x86-64: Don't generate cmov in vread_tsc
Date: Tue, 10 May 2011 10:15:05 -0400
Message-Id: <77d140f33d15ac5310f7ff2018d161324b3ea1ac.1305035945.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305035945.git.luto@mit.edu>
References: <cover.1305035945.git.luto@mit.edu>
In-Reply-To: <cover.1305035945.git.luto@mit.edu>
References: <cover.1305035945.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsUixG6nojvX46Svwfe/MhYX2y6yWfRdOcpu
	ceTad3aLOedbWCz2vT/LZnF51xw2iy2Xmlkt1k59w2KxedNUZotHfW/ZLX5seMzqwO1x5SmH
	x5aVN5k8brX9YfaYv/Mjo8fOWXfZPTat6mTzeHfuHLvHiRm/WTw2n672+LxJLoArissmJTUn
	syy1SN8ugSuj69wv9oLFPBXvmzaxNzB+4Oxi5OSQEDCRuNzQzwJhi0lcuLeerYuRi0NIYB+j
	xIHPkxghnA1AzpwV7BDOMyaJ7r6HzCAtbAIqEh1LHzB1MXJwiAgISSy9WwcSZhZYzCzx9b4T
	iC0s4CDRueYEK4jNIqAqMW/3NLByXoEgiX9HWSEWK0hcuTIP7AhOAQOJt4f/sYHYQgL6EouW
	HsMpPoFRYAEjwypG2ZTcKt3cxMyc4tRk3eLkxLy81CJdc73czBK91JTSTYzgGHBR2cHYfEjp
	EKMAB6MSD28Z4wlfIdbEsuLK3EOMkhxMSqK8l11O+grxJeWnVGYkFmfEF5XmpBYfYpTgYFYS
	4Z33E6icNyWxsiq1KB8mJc3BoiTOO09S3VdIID2xJDU7NbUgtQgmK8PBoSTBKw+MdSHBotT0
	1Iq0zJwShDQTByfIcB6g4YfcgWp4iwsSc4sz0yHypxh1Oaa3NR9gFGLJy89LlRLn1QYZJABS
	lFGaBzcHlrpeMYoDvSXMywVSxQNMe3CTXgEtYQJaYr4B5IPikkSElFQD4/zywH8bnBNnnZx/
	xT/uyoSJ84tX6Pu7vH2dzcMs/mO6uaT7n5aMz9e/TnrL2Z1xMdLgZ+h5pnMvcsK92LUdpHLL
	29atOpiyUGXS2uCX32blv3a6UyL5if/4xsn52Vx1JxmMvfd1tc1jrWspUp9zjf/D7NXXmW6o
	BWesVXhe8n5mRYPkrjkx4UosxRmJhlrMRcWJACU0Ce44AwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vread_tsc checks whether rdtsc returns something less than
cycle_last, which is an extremely predictable branch.  GCC likes
to generate a cmov anyway, which is several cycles slower than
a predicted branch.  This saves a couple of nanoseconds.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/kernel/tsc.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 7cabdae..db4c6e6 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -767,6 +767,7 @@ static cycle_t read_tsc(struct clocksource *cs)
 static cycle_t __vsyscall_fn vread_tsc(void)
 {
 	cycle_t ret;
+	u64 last;
 
 	/*
 	 * Empirically, a fence (of type that depends on the CPU)
@@ -778,8 +779,21 @@ static cycle_t __vsyscall_fn vread_tsc(void)
 	rdtsc_barrier();
 	ret = (cycle_t)vget_cycles();
 
-	return ret >= VVAR(vsyscall_gtod_data).clock.cycle_last ?
-		ret : VVAR(vsyscall_gtod_data).clock.cycle_last;
+	last = VVAR(vsyscall_gtod_data).clock.cycle_last;
+
+	if (likely(ret >= last))
+		return ret;
+
+	/*
+	 * GCC likes to generate cmov here, but this branch is extremely
+	 * predictable (it's just a funciton of time and the likely is
+	 * very likely) and there's a data dependence, so force GCC
+	 * to generate a branch instead.  I don't barrier() because
+	 * we don't actually need a barrier, and if this function
+	 * ever gets inlined it will generate worse code.
+	 */
+	asm volatile ("");
+	return last;
 }
 #endif
 
-- 
1.7.5.1

