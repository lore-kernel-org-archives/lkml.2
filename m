Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab0EOImK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 04:42:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:60539 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163Ab0EOImG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 04:42:06 -0400
Date: Sat, 15 May 2010 08:41:02 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, a.p.zijlstra@chello.nl, gorcunov@gmail.com,
       fweisbec@gmail.com, jaswinderlinux@gmail.com, ming.m.lin@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, a.p.zijlstra@chello.nl, gorcunov@gmail.com,
       fweisbec@gmail.com, jaswinderlinux@gmail.com, ming.m.lin@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100514190815.GG13509@lenovo>
References: <20100514190815.GG13509@lenovo>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, perf: P4 PMU - fix counters management logic
Message-ID: <tip-1ff3d7d79204612ebe2e611d2592f8898908ca00@git.kernel.org>
Git-Commit-ID: 1ff3d7d79204612ebe2e611d2592f8898908ca00
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 15 May 2010 08:41:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1ff3d7d79204612ebe2e611d2592f8898908ca00
Gitweb:     http://git.kernel.org/tip/1ff3d7d79204612ebe2e611d2592f8898908ca00
Author:     Cyrill Gorcunov <gorcunov@gmail.com>
AuthorDate: Fri, 14 May 2010 23:08:15 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 15 May 2010 08:38:55 +0200

x86, perf: P4 PMU - fix counters management logic

Jaswinder reported this #GP:

 |
 | Message from syslogd@ht at May 14 09:39:32 ...
 | kernel:[  314.908612] EIP: [<c100ccca>]
 | x86_perf_event_set_period+0x19d/0x1b2 SS:ESP 0068:edac3d70
 |

Ming has narrowed it down to a comparision issue
between arguments with different sizes and
signs. As result event index reached a wrong
value which in turn led to a GP fault.

At the same time it was found that p4_next_cntr
has broken logic and should return the counter
index only if it was not yet borrowed for
another event.

Reported-by: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Reported-by: Lin Ming <ming.m.lin@intel.com>
Bisected-by: Lin Ming <ming.m.lin@intel.com>
Tested-by: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20100514190815.GG13509@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_p4.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index cb875b1..424fc8d 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -18,7 +18,7 @@
 struct p4_event_bind {
 	unsigned int opcode;			/* Event code and ESCR selector */
 	unsigned int escr_msr[2];		/* ESCR MSR for this event */
-	unsigned char cntr[2][P4_CNTR_LIMIT];	/* counter index (offset), -1 on abscence */
+	char cntr[2][P4_CNTR_LIMIT];		/* counter index (offset), -1 on abscence */
 };
 
 struct p4_cache_event_bind {
@@ -747,11 +747,11 @@ static int p4_get_escr_idx(unsigned int addr)
 static int p4_next_cntr(int thread, unsigned long *used_mask,
 			struct p4_event_bind *bind)
 {
-	int i = 0, j;
+	int i, j;
 
 	for (i = 0; i < P4_CNTR_LIMIT; i++) {
-		j = bind->cntr[thread][i++];
-		if (j == -1 || !test_bit(j, used_mask))
+		j = bind->cntr[thread][i];
+		if (j != -1 && !test_bit(j, used_mask))
 			return j;
 	}
 
