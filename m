Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab0DSCaZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 22:30:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:44629 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab0DSCaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 22:30:24 -0400
Date: Sun, 18 Apr 2010 19:29:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] tracing: Dump either the oops's cpu source or all
 cpus buffers
Message-Id: <20100418192902.f3fad119.randy.dunlap@oracle.com>
In-Reply-To: <1271639740-11653-1-git-send-regression-fweisbec@gmail.com>
References: <1271623810-23700-1-git-send-regression-fweisbec@gmail.com>
	<1271639740-11653-1-git-send-regression-fweisbec@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090206.4BCBC021.0114:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Apr 2010 03:15:40 +0200 Frederic Weisbecker wrote:

>  Documentation/kernel-parameters.txt |    6 +++-
>  Documentation/trace/ftrace.txt      |    6 +++-
>  drivers/char/sysrq.c                |    2 +-
>  include/linux/ftrace.h              |    4 ++-
>  include/linux/kernel.h              |   11 ++++++-
>  kernel/trace/trace.c                |   51 ++++++++++++++++++++++++++--------
>  6 files changed, 61 insertions(+), 19 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index e4cbca5..f6c68e8 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -789,8 +789,12 @@ and is between 256 and 4096 characters. It is defined in the file
>  			as early as possible in order to facilitate early
>  			boot debugging.
>  
> -	ftrace_dump_on_oops
> +	ftrace_dump_on_oops[=orig_cpu]
>  			[FTRACE] will dump the trace buffers on oops.
> +			If no parameter is passed, ftrace will dump
> +			every cpu buffers, but if you pass orig_cpu, it will

			buffers of all CPUs,

> +			dump only the buffer of the cpu that triggered the

			                            CPU

> +			oops.
>  
>  	ftrace_filter=[function-list]
>  			[FTRACE] Limit the functions traced by the function
> diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
> index 03485bf..d242bc0 100644
> --- a/Documentation/trace/ftrace.txt
> +++ b/Documentation/trace/ftrace.txt
> @@ -1337,12 +1337,14 @@ ftrace_dump_on_oops must be set. To set ftrace_dump_on_oops, one
>  can either use the sysctl function or set it via the proc system
>  interface.
>  
> -  sysctl kernel.ftrace_dump_on_oops=1
> +  sysctl kernel.ftrace_dump_on_oops=n
>  
>  or
>  
> -  echo 1 > /proc/sys/kernel/ftrace_dump_on_oops
> +  echo n > /proc/sys/kernel/ftrace_dump_on_oops
>  
> +If n = 1, ftrace will dump every cpu buffers, if n = 2 ftrace will

                              buffers of all CPUs,

> +only dump the buffer of the cpu that triggered the oops.

                               CPU

>  
>  Here's an example of such a dump after a null pointer
>  dereference in a kernel module:
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index bed83ca..4252ffe 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -117,9 +117,12 @@ static cpumask_var_t __read_mostly	tracing_buffer_mask;
>   *
>   * It is default off, but you can enable it with either specifying
>   * "ftrace_dump_on_oops" in the kernel command line, or setting
> - * /proc/sys/kernel/ftrace_dump_on_oops to true.
> + * /proc/sys/kernel/ftrace_dump_on_oops
> + * Set 1 if you want to dump every cpu buffers

                                buffers of all CPUs

> + * Set 2 if you want to dump the buffer of the cpu that triggered oops

                                                  CPU

>   */
> -int ftrace_dump_on_oops;
> +
> +enum ftrace_dump_mode ftrace_dump_on_oops;
>  
>  static int tracing_set_tracer(const char *buf);
>  
> @@ -4429,12 +4442,25 @@ static void __ftrace_dump(bool disable_tracing)
>  	/* don't look at user memory in panic mode */
>  	trace_flags &= ~TRACE_ITER_SYM_USEROBJ;
>  
> -	printk(KERN_TRACE "Dumping ftrace buffer:\n");
> -
>  	/* Simulate the iterator */
>  	iter.tr = &global_trace;
>  	iter.trace = current_trace;
> -	iter.cpu_file = TRACE_PIPE_ALL_CPU;
> +
> +	switch (oops_dump_mode) {
> +	case DUMP_ALL:
> +		iter.cpu_file = TRACE_PIPE_ALL_CPU;
> +		break;
> +	case DUMP_ORIG:
> +		iter.cpu_file = raw_smp_processor_id();
> +		break;
> +	case DUMP_NONE:
> +		goto out_enable;
> +	default:
> +		printk(KERN_TRACE "Bad dumping mode, switching to all cpu dump\n");

		                                                      CPUs

> +		iter.cpu_file = TRACE_PIPE_ALL_CPU;
> +	}
> +
> +	printk(KERN_TRACE "Dumping ftrace buffer:\n");
>  
>  	/*
>  	 * We need to stop all tracing on all CPUS to read the


---
~Randy
