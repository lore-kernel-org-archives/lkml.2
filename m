Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab1DVMXB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 08:23:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:57140 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446Ab1DVMW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 08:22:57 -0400
Date: Fri, 22 Apr 2011 12:22:36 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-q9rtru7b7840tws75xzboapv@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, gorcunov@openvz.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
        rostedt@goodmis.org, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, gorcunov@openvz.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
        rostedt@goodmis.org, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: Update/fix Intel Nehalem cache events
Git-Commit-ID: f4929bd37208540c2c6f416e9035ff1938f2dbc6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Apr 2011 12:22:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f4929bd37208540c2c6f416e9035ff1938f2dbc6
Gitweb:     http://git.kernel.org/tip/f4929bd37208540c2c6f416e9035ff1938f2dbc6
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 22 Apr 2011 13:39:56 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 22 Apr 2011 13:50:27 +0200

perf, x86: Update/fix Intel Nehalem cache events

Change the Nehalem cache events to use retired memory instruction counters
(similar to Westmere), this greatly improves the provided stats.

Using:

main ()
{
        int i;

        for (i = 0; i < 1000000000; i++) {
                asm("mov (%%rsp), %%rbx;"
                    "mov %%rbx, (%%rsp);" : : : "rbx");
        }
}

We find:

 $ perf stat --repeat 10 -e instructions:u -e l1-dcache-loads:u -e l1-dcache-stores:u ./loop_1b_loads+stores
  Performance counter stats for './loop_1b_loads+stores' (10 runs):
      4,000,081,056 instructions:u           #      0.000 IPC ( +-   0.000% )
      4,999,502,846 l1-dcache-loads:u          ( +-   0.008% )
      1,000,034,832 l1-dcache-stores:u         ( +-   0.000% )
         1.565184942  seconds time elapsed   ( +-   0.005% )

The 5b is surprising - we'd expect 1b:

 $ perf stat --repeat 10 -e instructions:u -e r10b:u -e l1-dcache-stores:u ./loop_1b_loads+stores
  Performance counter stats for './loop_1b_loads+stores' (10 runs):
      4,000,081,054 instructions:u           #      0.000 IPC ( +-   0.000% )
      1,000,021,961 r10b:u                     ( +-   0.000% )
      1,000,030,951 l1-dcache-stores:u         ( +-   0.000% )
         1.565055422  seconds time elapsed   ( +-   0.003% )

Which this patch thus fixes.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Link: http://lkml.kernel.org/n/tip-q9rtru7b7840tws75xzboapv@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 586cced..43fa20b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -391,12 +391,12 @@ static __initconst const u64 nehalem_hw_cache_event_ids
 {
  [ C(L1D) ] = {
 	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0f40, /* L1D_CACHE_LD.MESI            */
-		[ C(RESULT_MISS)   ] = 0x0140, /* L1D_CACHE_LD.I_STATE         */
+		[ C(RESULT_ACCESS) ] = 0x010b, /* MEM_INST_RETIRED.LOADS       */
+		[ C(RESULT_MISS)   ] = 0x0151, /* L1D.REPL                     */
 	},
 	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0f41, /* L1D_CACHE_ST.MESI            */
-		[ C(RESULT_MISS)   ] = 0x0141, /* L1D_CACHE_ST.I_STATE         */
+		[ C(RESULT_ACCESS) ] = 0x020b, /* MEM_INST_RETURED.STORES      */
+		[ C(RESULT_MISS)   ] = 0x0251, /* L1D.M_REPL                   */
 	},
 	[ C(OP_PREFETCH) ] = {
 		[ C(RESULT_ACCESS) ] = 0x014e, /* L1D_PREFETCH.REQUESTS        */
