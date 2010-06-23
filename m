Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab0FWPQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 11:16:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47272 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab0FWPQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 11:16:47 -0400
X-Authority-Analysis: v=1.1 cv=zLGBfXKW/yOQN1c4qTdQUWouaSiWOaUUjRgOJi1LSJI= c=1 sm=0 a=VT3f0z-SXmYA:10 a=yQWWgrYGNuUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=XMks3MzYvKDOQ8yePNkA:9 a=F7xT-reSfErCYt-4KDgA:7 a=EzP48Fp8-FcQJvIPPiRxLcIV1qMA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 08/40] tracing: remove syscall bitmaps in preparation
 for compat support
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Jason Baron <jbaron@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>, Ingo Molnar <mingo@elte.hu>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
In-Reply-To: <1277287401-28571-9-git-send-email-imunsie@au1.ibm.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
	 <1277287401-28571-9-git-send-email-imunsie@au1.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 23 Jun 2010 11:16:44 -0400
Message-ID: <1277306204.9181.43.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-23 at 20:02 +1000, Ian Munsie wrote:
> From: Jason Baron <jbaron@redhat.com>
> 
> In preparation for compat syscall tracing support, let's store the enabled
> syscalls, with the struct syscall_metadata itself. That way we don't duplicate
> enabled information when the compat table points to an entry in the regular
> syscall table. Also, allows us to remove the bitmap data structures completely.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
> ---
>  include/linux/syscalls.h      |    8 +++++++
>  include/trace/syscall.h       |    4 +++
>  kernel/trace/trace_syscalls.c |   42 +++++++++++++++++++---------------------
>  3 files changed, 32 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 86f082b..755d05b 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -163,6 +163,10 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>  		.nb_args 	= nb,				\
>  		.types		= types_##sname,		\
>  		.args		= args_##sname,			\
> +		.ftrace_enter	= 0,				\
> +		.ftrace_exit	= 0,				\
> +		.perf_enter	= 0,				\
> +		.perf_exit	= 0,				\

I really hate this change!

You just removed a nice compressed bitmap (1 bit per syscall) to add 4
bytes per syscall. On my box I have 308 syscalls being traced. That was
308 bits per bitmask = 39 bytes * 2 = 78 * 2 (perf and ftrace) = 156.

Now we have 8 bytes per syscall (enter and exit), which is 1232 bytes.

Thus this change added 1076 bytes.

This may not seem as much, but the change is not worth 1K. Can't we just
add another bitmask or something for the compat case?

I also hate the moving of ftrace and perf internal data to an external
interface.

-- Steve

>  		.enter_event	= &event_enter_##sname,		\
>  		.exit_event	= &event_exit_##sname,		\
>  		.enter_fields	= LIST_HEAD_INIT(__syscall_meta_##sname.enter_fields), \
> @@ -179,6 +183,10 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>  		.name 		= "sys_"#sname,			\
>  		.syscall_nr	= -1,	/* Filled in at boot */	\
>  		.nb_args 	= 0,				\
> +		.ftrace_enter	= 0,				\
> +		.ftrace_exit	= 0,				\
> +		.perf_enter	= 0,				\
> +		.perf_exit	= 0,				\
>  		.enter_event	= &event_enter__##sname,	\
>  		.exit_event	= &event_exit__##sname,		\
>  		.enter_fields	= LIST_HEAD_INIT(__syscall_meta__##sname.enter_fields), \


