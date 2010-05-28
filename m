Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab0E1A14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 20:27:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37791 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab0E1A1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 20:27:55 -0400
X-Authority-Analysis: v=1.1 cv=muTmBHIsIIrvj5np50lvqqEF3x9MmSj/zDSU9q1ni6E= c=1 sm=0 a=ins4zMs19JUA:10 a=uEzv4HemXiYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=t7CeM3EgAAAA:8 a=Mb5HO21E1NDS6Nk59MoA:9 a=pXJvQ7u7EOxi69O8JhoA:7 a=qe5kZtBdsNVDBzOPIqEjluC19hMA:4 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=2e6ZYRoF4I4A:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] ftrace,kdb: Allow dumping a specific cpu's buffer with
 ftdump
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1275002073-16516-1-git-send-email-jason.wessel@windriver.com>
References: <1275002073-16516-1-git-send-email-jason.wessel@windriver.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 27 May 2010 20:27:52 -0400
Message-ID: <1275006472.22648.558.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 18:14 -0500, Jason Wessel wrote:
> In systems with more than one processor it is desriable to look at the
> per cpu trace buffers.
> 
> CC: Frederic Weisbecker <fweisbec@gmail.com>

> CC: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> ---
>  kernel/trace/trace_kdb.c |   37 +++++++++++++++++++++++++++----------
>  1 files changed, 27 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/trace/trace_kdb.c b/kernel/trace/trace_kdb.c
> index 44cbda2..7b8ecd7 100644
> --- a/kernel/trace/trace_kdb.c
> +++ b/kernel/trace/trace_kdb.c
> @@ -17,7 +17,7 @@
>  #include "trace.h"
>  #include "trace_output.h"
>  
> -static void ftrace_dump_buf(int skip_lines)
> +static void ftrace_dump_buf(int skip_lines, long cpu_file)
>  {
>  	/* use static because iter can be a bit big for the stack */
>  	static struct trace_iterator iter;
> @@ -44,13 +44,20 @@ static void ftrace_dump_buf(int skip_lines)
>  	iter.iter_flags |= TRACE_FILE_LAT_FMT;
>  	iter.pos = -1;
>  
> -	for_each_tracing_cpu(cpu) {
> -		iter.buffer_iter[cpu] =
> +	if (cpu_file == TRACE_PIPE_ALL_CPU) {
> +		for_each_tracing_cpu(cpu) {
> +			iter.buffer_iter[cpu] =
>  			ring_buffer_read_prepare(iter.tr->buffer, cpu);
> -		ring_buffer_read_start(iter.buffer_iter[cpu]);
> -		tracing_iter_reset(&iter, cpu);
> +			ring_buffer_read_start(iter.buffer_iter[cpu]);
> +			tracing_iter_reset(&iter, cpu);
> +		}
> +	} else {
> +		iter.cpu_file = cpu_file;
> +		iter.buffer_iter[cpu_file] =
> +			ring_buffer_read_prepare(iter.tr->buffer, cpu_file);
> +		ring_buffer_read_start(iter.buffer_iter[cpu_file]);
> +		tracing_iter_reset(&iter, cpu_file);
>  	}
> -
>  	if (!trace_empty(&iter))
>  		trace_find_next_entry_inc(&iter);
>  	while (!trace_empty(&iter)) {
> @@ -91,9 +98,10 @@ out:
>  static int kdb_ftdump(int argc, const char **argv)
>  {
>  	int skip_lines = 0;
> +	long cpu_file;
>  	char *cp;
>  
> -	if (argc > 1)
> +	if (argc > 2)
>  		return KDB_ARGCOUNT;
>  
>  	if (argc) {
> @@ -102,8 +110,17 @@ static int kdb_ftdump(int argc, const char **argv)
>  			skip_lines = 0;
>  	}
>  
> +	if (argc == 2) {
> +		cpu_file = simple_strtol(argv[2], &cp, 0);
> +		if (*cp || cpu_file >= NR_CPUS || cpu_file < 0 ||
> +		    !cpu_online(cpu_file))
> +			return KDB_BADINT;
> +	} else {
> +		cpu_file = TRACE_PIPE_ALL_CPU;
> +	}
> +
>  	kdb_trap_printk++;
> -	ftrace_dump_buf(skip_lines);
> +	ftrace_dump_buf(skip_lines, cpu_file);
>  	kdb_trap_printk--;
>  
>  	return 0;
> @@ -111,8 +128,8 @@ static int kdb_ftdump(int argc, const char **argv)
>  
>  static __init int kdb_ftrace_register(void)
>  {
> -	kdb_register_repeat("ftdump", kdb_ftdump, "", "Dump ftrace log",
> -			    0, KDB_REPEAT_NONE);
> +	kdb_register_repeat("ftdump", kdb_ftdump, "[skip_#lines] [cpu]",
> +			    "Dump ftrace log", 0, KDB_REPEAT_NONE);
>  	return 0;
>  }
>  


