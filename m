Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab1EWNdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 09:33:01 -0400
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:52324 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753499Ab1EWNc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 09:32:58 -0400
X-AuditID: 1209190d-b7bdeae0000004f8-03-4dda61cc1351
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@amd64.org>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v5 3/8] x86-64: Don't generate cmov in vread_tsc
Date: Mon, 23 May 2011 09:31:26 -0400
Message-Id: <561280649519de41352fcb620684dfb22bad6bac.1306156808.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306156808.git.luto@mit.edu>
References: <cover.1306156808.git.luto@mit.edu>
In-Reply-To: <cover.1306156808.git.luto@mit.edu>
References: <cover.1306156808.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsUixG6nrnsm8Zavwbw17BYX2y6yWfRdOcpu
	ceTadyC3cRuLxZzzLSwW+96fZbO4vGsOm8WWS82sFps3TWW2eNT3lt3ix4bHrA7cHt2PPjF6
	XHnK4bFl5U0mj1ttf5g95u/8yOixc9Zddo9NqzrZPN6dO8fucWLGbxaPz5vkAriiuGxSUnMy
	y1KL9O0SuDKeNq9iLFjMUzH12ySmBsYPnF2MnBwSAiYSk9ZcYYSwxSQu3FvPBmILCexjlLg3
	S6CLkQvI3sAocWF+OxOE84xJ4tGtWWBVbAIqEh1LHwAlODhEBIQklt6tA6lhFljLLLGvezFY
	XFjAQWLZoxKQchYBVYlPKxeBhXkFgiR6TgVB7FWQuHJlHguIzSlgIDF/90kWiBv0JSYdXYpT
	fAKjwAJGhlWMsim5Vbq5iZk5xanJusXJiXl5qUW6Rnq5mSV6qSmlmxhBMcApybuD8d1BpUOM
	AhyMSjy8izRv+gqxJpYVV+YeYpTkYFIS5XWJv+UrxJeUn1KZkVicEV9UmpNafIhRgoNZSYS3
	QfuGrxBvSmJlVWpRPkxKmoNFSZx3pqS6r5BAemJJanZqakFqEUxWhoNDSYJXExjrQoJFqemp
	FWmZOSUIaSYOTpDhPEDDg0BqeIsLEnOLM9Mh8qcYdTmm3v59gFGIJS8/L1VKnDcOpEgApCij
	NA9uDix1vWIUB3pLmDcApIoHmPbgJr0CWsIEtETi702QJSWJCCmpBsYdu3dlLTkTaGi87P9C
	hckvhTQmdrxw450VFGi62b55W0LLOsHfVSr/r9fdqP/6b3X5JL7aCy1hvxbXrDgRtzUh89DE
	r3etXuqE/Dm2+KdassCT7j3ZTckfr3sWc7/Z47gsRjto1wL3KTN49n7elqjRGjXx88KL/6Mj
	Ra9N2aT5993V9bH3u7kUlViKMxINtZiLihMBtKj3mjgDAAA=
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
index 1e62442..24249a5 100644
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

