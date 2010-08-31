Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab0HaBbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 21:31:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34429 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756465Ab0HaBbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 21:31:52 -0400
X-Authority-Analysis: v=1.1 cv=h9FjAN2ougM9pVhvDq3M6+cWFo1DP5/t8S/Ny2XAPyw= c=1 sm=0 a=fCqi14YzsQAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=hGzw-44bAAAA:8 a=nqPaPJlex8g0bLkBDgwA:9 a=Bc5qiVryrp0BNtxIo-oA:7 a=W3WLFa-381Wor87zxRuJ8_RhpRMA:4 a=PUjeQqilurYA:10 a=dowx1zmaLagA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] tracing/trace_stack: Fix stack trace on ppc64
From: Steven Rostedt <rostedt@goodmis.org>
To: Anton Blanchard <anton@samba.org>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20100825013238.GE28360@kryten>
References: <20100825013238.GE28360@kryten>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 30 Aug 2010 21:31:50 -0400
Message-ID: <1283218310.1377.50.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-25 at 11:32 +1000, Anton Blanchard wrote:
> save_stack_trace() stores the instruction pointer, not the function
> descriptor. On ppc64 the trace stack code currently dereferences the
> instruction pointer and shows 8 bytes of instructions in our backtraces:
> 
> # cat /sys/kernel/debug/tracing/stack_trace
>         Depth    Size   Location    (26 entries)
>         -----    ----   --------
>   0)     5424     112   0x6000000048000004
>   1)     5312     160   0x60000000ebad01b0
>   2)     5152     160   0x2c23000041c20030
>   3)     4992     240   0x600000007c781b79
>   4)     4752     160   0xe84100284800000c
>   5)     4592     192   0x600000002fa30000
>   6)     4400     256   0x7f1800347b7407e0
>   7)     4144     208   0xe89f0108f87f0070
>   8)     3936     272   0xe84100282fa30000
> 
> Since we aren't dealing with function descriptors, use %pS instead of %pF
> to fix it:
> 
> # cat /sys/kernel/debug/tracing/stack_trace
>         Depth    Size   Location    (26 entries)
>         -----    ----   --------
>   0)     5424     112   ftrace_call+0x4/0x8
>   1)     5312     160   .current_io_context+0x28/0x74
>   2)     5152     160   .get_io_context+0x48/0xa0
>   3)     4992     240   .cfq_set_request+0x94/0x4c4
>   4)     4752     160   .elv_set_request+0x60/0x84
>   5)     4592     192   .get_request+0x2d4/0x468
>   6)     4400     256   .get_request_wait+0x7c/0x258
>   7)     4144     208   .__make_request+0x49c/0x610
>   8)     3936     272   .generic_make_request+0x390/0x434
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>

Thanks, I'll test this to make sure it doesn't break x86, and then push
it into a stable/-rc patch queue.

-- Steve

> ---
> 
> Index: powerpc.git/kernel/trace/trace_stack.c
> ===================================================================
> --- powerpc.git.orig/kernel/trace/trace_stack.c	2010-08-25 11:03:52.337982567 +1000
> +++ powerpc.git/kernel/trace/trace_stack.c	2010-08-25 11:03:55.018371055 +1000
> @@ -249,7 +249,7 @@ static int trace_lookup_stack(struct seq
>  {
>  	unsigned long addr = stack_dump_trace[i];
>  
> -	return seq_printf(m, "%pF\n", (void *)addr);
> +	return seq_printf(m, "%pS\n", (void *)addr);
>  }
>  
>  static void print_disabled(struct seq_file *m)


