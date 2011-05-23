Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab1EWNcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 09:32:52 -0400
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:63688 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754357Ab1EWNcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 09:32:50 -0400
X-AuditID: 1209190d-b7bdeae0000004f8-e9-4dda61c4d05c
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
Subject: [PATCH v5 2/8] x86-64: Remove unnecessary barrier in vread_tsc
Date: Mon, 23 May 2011 09:31:25 -0400
Message-Id: <1c158b9d74338aa5361f96dd473d0e6a58235302.1306156808.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306156808.git.luto@mit.edu>
References: <cover.1306156808.git.luto@mit.edu>
In-Reply-To: <cover.1306156808.git.luto@mit.edu>
References: <cover.1306156808.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsUixG6nrnsk8ZavwfbPxhYX2y6yWfRdOcpu
	ceTad3aLi43bWCzmnG9hsdj3/iybxeVdc9gstlxqZrXYvGkqs8WjvrfsFj82PGZ14PbofvSJ
	0ePKUw6PLStvMnncavvD7DF/50dGj52z7rJ7bFrVyebx7tw5do8TM36zeHzeJBfAFcVlk5Ka
	k1mWWqRvl8CVcfDfIfaCTTwVW25eZmpg/MXZxcjJISFgIvFn/g52CFtM4sK99WxdjFwcQgL7
	GCUWLd7JDuFsYJQ4eX8RlPOMSWLvnTlMIC1sAioSHUsfANkcHCICQhJL79aB1DALrGWW2Ne9
	GKxGWMBdYsWeE6wgNouAqsSL98/YQGxegSCJH8sXsUCsVpC4cmUemM0pYCAxf/dJMFtIQF9i
	0tGlOMUnMAosYGRYxSibklulm5uYmVOcmqxbnJyYl5dapGukl5tZopeaUrqJERQJnJK8Oxjf
	HVQ6xCjAwajEw7tI86avEGtiWXFl7iFGSQ4mJVFel/hbvkJ8SfkplRmJxRnxRaU5qcWHGCU4
	mJVEeBu0b/gK8aYkVlalFuXDpKQ5WJTEeWdKqvsKCaQnlqRmp6YWpBbBZGU4OJQkeDWBES8k
	WJSanlqRlplTgpBm4uAEGc4DNDwIpIa3uCAxtzgzHSJ/ilGXY+rt3wcYhVjy8vNSpcR540CK
	BECKMkrz4ObAEtgrRnGgt4R5A0CqeIDJD27SK6AlTEBLJP7eBFlSkoiQkmpgZGU86z3xbG7E
	e7eM02udd3zN+eZw5vzTuOzu+5tqVzT4iV8yUZ7l8Etn1uQfp2sPG99Waz4Xo+jBdfPC2qlt
	L4+1ObIqhAX/n78m/uenqT08TftP2nvO88/3vizAeOePZ7WWnapIv6hSaGv25Nb/ifZCcrr5
	c5+u3cf/4s+EIKs+sV1m/9MuKLEUZyQaajEXFScCAE/Bq2E7AwAA
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
index db697b8..1e62442 100644
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

