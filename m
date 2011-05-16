Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab1EPQEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 12:04:38 -0400
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:60262 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756554Ab1EPQE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 12:04:27 -0400
X-AuditID: 12074422-b7b0eae000007f48-02-4dd14b149ca8
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
Subject: [PATCH v4 2/6] x86-64: Remove unnecessary barrier in vread_tsc
Date: Mon, 16 May 2011 12:00:59 -0400
Message-Id: <c52fc8684d6177051e6f5dc32c6466f0fc637375.1305560561.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305560561.git.luto@mit.edu>
References: <cover.1305560561.git.luto@mit.edu>
In-Reply-To: <cover.1305560561.git.luto@mit.edu>
References: <cover.1305560561.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsUixCmqrSvifdHX4NgnCYuLbRfZLPquHGW3
	OHLtO7vFxcZtLBZzzrewWOx7f5bN4vKuOWwWWy41s1ps3jSV2eJR31t2ix8bHrM6cHt0P/rE
	6HHlKYfHlpU3mTxutf1h9pi/8yOjx85Zd9k9Nq3qZPN4d+4cu8eJGb9ZPD5vkgvgiuKySUnN
	ySxLLdK3S+DK+N/DWrCJp2LrcuUGxl+cXYycHBICJhIrWxezQdhiEhfurQezhQT2MUrcnK3f
	xcgFZG9glNgx7SkLhPOMSeLtsWusIFVsAioSHUsfMHUxcnCICAhJLL1bB1LDLLCWWWJf92Im
	kBphAXeJG99ngNksAqoSa0/NZgGp5xUIkni/2AZisYLElSvzWEBsTgEDie2HtzBDHKEv0bXm
	PyMu8QmMAgsYGVYxyqbkVunmJmbmFKcm6xYnJ+blpRbpmurlZpbopaaUbmIERQC7i9IOxp8H
	lQ4xCnAwKvHw/nG66CvEmlhWXJl7iFGSg0lJlNfAFSjEl5SfUpmRWJwRX1Sak1p8iFGCg1lJ
	hPdM/QVfId6UxMqq1KJ8mJQ0B4uSOO8cSXVfIYH0xJLU7NTUgtQimKwMB4eSBK+yF9BQwaLU
	9NSKtMycEoQ0EwcnyHAeoOGeIDW8xQWJucWZ6RD5U4y6HJ8fHTrAKMSSl5+XKiXO6w9SJABS
	lFGaBzcHlrheMYoDvSXMWwtSxQNMenCTXgEtYQJasuoUyAfFJYkIKakGxt7NiaJFCSrP+vSX
	pd7M9T/1vHbZtZzEeffPlgu6K6kkuZy36T3nNj174aLLZltvX+65ta+VY8qE16an+NLMZq7m
	+h6nMrko7fruBZLtRk7TyrXmRH4P/G3cdql/MWvfPuuc4riEzWfbqndMqlsgL6uqEP56ap+h
	Q+n2x9+Cciav01YPjkzap8RSnJFoqMVcVJwIADl6d9w3AwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RDTSC is completely unordered on modern Intel and AMD CPUs.  The
Intel manual says that lfence;rdtsc causes all previous instructions
to complete before the tsc is read, and the AMD manual says to use
mfence;rdtsc to do the same thing.

>From a decent amount of testing [1] this is enough to make rdtsc
be ordered with respect to subsequent loads across a wide variety
of CPUs.

On Sandy Bridge (i7-2600), this improves a loop of
clock_gettime(CLOCK_MONOTONIC) by more than 5 ns/iter.

[1] https://lkml.org/lkml/2011/4/18/350

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/kernel/tsc.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index bc46566..7cabdae 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -769,13 +769,14 @@ static cycle_t __vsyscall_fn vread_tsc(void)
 	cycle_t ret;
 
 	/*
-	 * Surround the RDTSC by barriers, to make sure it's not
-	 * speculated to outside the seqlock critical section and
-	 * does not cause time warps:
+	 * Empirically, a fence (of type that depends on the CPU)
+	 * before rdtsc is enough to ensure that rdtsc is ordered
+	 * with respect to loads.  The various CPU manuals are unclear
+	 * as to whether rdtsc can be reordered with later loads,
+	 * but no one has ever seen it happen.
 	 */
 	rdtsc_barrier();
 	ret = (cycle_t)vget_cycles();
-	rdtsc_barrier();
 
 	return ret >= VVAR(vsyscall_gtod_data).clock.cycle_last ?
 		ret : VVAR(vsyscall_gtod_data).clock.cycle_last;
-- 
1.7.5.1

