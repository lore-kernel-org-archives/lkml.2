Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab0HaPOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 11:14:44 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35701 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309Ab0HaPOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 11:14:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VoR/8RWyaWzEZh8uPVdyEtohy9AgH4qyxmocIqx6ILnGP0nvas8OrtrR5C9BwhN0eX
         M0odugZ16xTnJ3BQwTf0Vl3hir0MZCh7LlX5q3TnUVR5+nLRTTOrkQ9sxtcOz20EdAb6
         1mZce0ZrPz2vT+PZfx3IgUVrvxiA0dZKVdm8w=
Date: Tue, 31 Aug 2010 17:14:41 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Blanchard <anton@samba.org>, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing/trace_stack: Fix stack trace on ppc64
Message-ID: <20100831151439.GC5259@nowhere>
References: <20100825013238.GE28360@kryten> <1283218310.1377.50.camel@gandalf.stny.rr.com> <20100831142111.GA5259@nowhere> <1283266722.1377.80.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283266722.1377.80.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 10:58:42AM -0400, Steven Rostedt wrote:
> Hmm, I never saw the tip-bot reply :-(
> 
> I guess it only sends to the Cc tags.
> 
> -- Steve
> 
> 


We were in the commit Cc tags but somehow they didn't make it in the email
tags.

Here is the tip-bot email:

---
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
--
To unsubscribe from this list: send the line "unsubscribe linux-tip-commits" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


