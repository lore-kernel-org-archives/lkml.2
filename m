Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762Ab0LNAuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 19:50:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36595 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757983Ab0LNAuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 19:50:23 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=kwUP-EQ6x2wA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=2TqYCPFLtvIFBJJXcEkA:9 a=EcJYKQq1JoHYQZmBRy4A:7 a=PIGx9NqBIGV52XOG2rZH3vnLIOsA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH][GIT PULL] x86: Remove unlikey()'s from sched_switch
 segment tests
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 13 Dec 2010 19:50:21 -0500
Message-ID: <1292287821.5015.1784.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo or Thomas,

Please pull the latest unlikely/x86 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
unlikely/x86


Steven Rostedt (1):
      x86: Remove unlikey()'s from sched_switch segment tests

----
 arch/x86/kernel/process_64.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)
---------------------------
commit 6ddd9593268de1cc4438e5f2e680887af292f350
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Mon Dec 6 16:04:10 2010 -0500

    x86: Remove unlikey()'s from sched_switch segment tests
    
    On a 64bit distro, the chances of having a process using segment registers
    is very unlikely. But if the userspace is 32bit running on top of
    a 64bit kernel (very common), then this will be very likely that
    processes have segment registers in use.
    
    Running on my main desktop (which is a 32bit userspace on top of
    a 64bit kernel) the annotated branch profiler showed the following:
    
     correct incorrect  %        Function             File              Line
     ------- ---------  -        --------             ----              ----
    25522442 304125815  92 __switch_to               process_64.c         408
    25522430 304123341  92 __switch_to               process_64.c         412
    25743877 303891250  92 __switch_to               process_64.c         464
    
    Instead of punishing 32bit userspace systems with an unlikely, just remove
    the unlikely and let gcc optimize for what it thinks is good and let
    the branch prediction (hopefully) work.
    
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index b3d7a3a..22de90c 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -405,11 +405,11 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 * This won't pick up thread selector changes, but I guess that is ok.
 	 */
 	savesegment(es, prev->es);
-	if (unlikely(next->es | prev->es))
+	if (next->es | prev->es)
 		loadsegment(es, next->es);
 
 	savesegment(ds, prev->ds);
-	if (unlikely(next->ds | prev->ds))
+	if (next->ds | prev->ds)
 		loadsegment(ds, next->ds);
 
 
@@ -461,7 +461,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 		wrmsrl(MSR_FS_BASE, next->fs);
 	prev->fsindex = fsindex;
 
-	if (unlikely(gsindex | next->gsindex | prev->gs)) {
+	if (gsindex | next->gsindex | prev->gs) {
 		load_gs_index(next->gsindex);
 		if (gsindex)
 			prev->gs = 0;


