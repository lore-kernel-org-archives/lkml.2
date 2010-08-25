Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab0HYM6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 08:58:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:58648 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab0HYM6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 08:58:33 -0400
Date: Wed, 25 Aug 2010 12:58:09 GMT
From: tip-bot for Anton Blanchard <anton@samba.org>
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100825013238.GE28360@kryten>
References: <20100825013238.GE28360@kryten>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing/trace_stack: Fix stack trace on ppc64
Message-ID: <tip-151772dbfad4dbe81721e40f9b3d588ea77bb7aa@git.kernel.org>
Git-Commit-ID: 151772dbfad4dbe81721e40f9b3d588ea77bb7aa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 25 Aug 2010 12:58:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  151772dbfad4dbe81721e40f9b3d588ea77bb7aa
Gitweb:     http://git.kernel.org/tip/151772dbfad4dbe81721e40f9b3d588ea77bb7aa
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Wed, 25 Aug 2010 11:32:38 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Aug 2010 13:08:48 +0200

tracing/trace_stack: Fix stack trace on ppc64

save_stack_trace() stores the instruction pointer, not the
function descriptor. On ppc64 the trace stack code currently
dereferences the instruction pointer and shows 8 bytes of
instructions in our backtraces:

 # cat /sys/kernel/debug/tracing/stack_trace
        Depth    Size   Location    (26 entries)
        -----    ----   --------
  0)     5424     112   0x6000000048000004
  1)     5312     160   0x60000000ebad01b0
  2)     5152     160   0x2c23000041c20030
  3)     4992     240   0x600000007c781b79
  4)     4752     160   0xe84100284800000c
  5)     4592     192   0x600000002fa30000
  6)     4400     256   0x7f1800347b7407e0
  7)     4144     208   0xe89f0108f87f0070
  8)     3936     272   0xe84100282fa30000

Since we aren't dealing with function descriptors, use %pS
instead of %pF to fix it:

 # cat /sys/kernel/debug/tracing/stack_trace
        Depth    Size   Location    (26 entries)
        -----    ----   --------
  0)     5424     112   ftrace_call+0x4/0x8
  1)     5312     160   .current_io_context+0x28/0x74
  2)     5152     160   .get_io_context+0x48/0xa0
  3)     4992     240   .cfq_set_request+0x94/0x4c4
  4)     4752     160   .elv_set_request+0x60/0x84
  5)     4592     192   .get_request+0x2d4/0x468
  6)     4400     256   .get_request_wait+0x7c/0x258
  7)     4144     208   .__make_request+0x49c/0x610
  8)     3936     272   .generic_make_request+0x390/0x434

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: rostedt@goodmis.org
Cc: fweisbec@gmail.com
LKML-Reference: <20100825013238.GE28360@kryten>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_stack.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 056468e..a6b7e0e 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -249,7 +249,7 @@ static int trace_lookup_stack(struct seq_file *m, long i)
 {
 	unsigned long addr = stack_dump_trace[i];
 
-	return seq_printf(m, "%pF\n", (void *)addr);
+	return seq_printf(m, "%pS\n", (void *)addr);
 }
 
 static void print_disabled(struct seq_file *m)
