Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab1EXCmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 22:42:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47523 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057Ab1EXCmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 22:42:12 -0400
Date: Tue, 24 May 2011 04:41:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20110524024148.GA18967@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-urgent-for-linus

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (1):
      perf tools: Fix sample type size calculation in 32 bits archs

Jesper Juhl (1):
      profile: Use vzalloc() rather than vmalloc() & memset()


 kernel/profile.c        |    6 ++----
 tools/perf/util/event.c |    2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/profile.c b/kernel/profile.c
index 66f841b..14c9f87 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -126,11 +126,9 @@ int __ref profile_init(void)
 	if (prof_buffer)
 		return 0;
 
-	prof_buffer = vmalloc(buffer_bytes);
-	if (prof_buffer) {
-		memset(prof_buffer, 0, buffer_bytes);
+	prof_buffer = vzalloc(buffer_bytes);
+	if (prof_buffer)
 		return 0;
-	}
 
 	free_cpumask_var(prof_cpu_mask);
 	return -ENOMEM;
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 252b72a..6635fcd 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -42,7 +42,7 @@ int perf_sample_size(u64 sample_type)
 	int i;
 
 	for (i = 0; i < 64; i++) {
-		if (mask & (1UL << i))
+		if (mask & (1ULL << i))
 			size++;
 	}
 
