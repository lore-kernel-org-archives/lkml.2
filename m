Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab0LGOyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 09:54:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32846 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab0LGOyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 09:54:44 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=IwdOIZWHzdQA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VnNF1IyMAAAA:8 a=Smh6JsAMrhLJakGDwXsA:9 a=ruqE8m8GrzaxiBQShdcA:7 a=s4TWCG-QofqXeklV5L3pS6DzxrcA:4 a=PUjeQqilurYA:10 a=PaPosJs4WP6g_snw:21 a=MF2tqxG_tO9f8I6t:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/6] trace syscalls: Remove redundant syscall_nr checks
From: Steven Rostedt <rostedt@goodmis.org>
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: Avantika Mathur <mathur@linux.vnet.ibm.com>,
        Jason Baron <jbaron@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1291696151-4336-3-git-send-email-imunsie@au1.ibm.com>
References: <1291696151-4336-1-git-send-email-imunsie@au1.ibm.com>
	 <1291696151-4336-3-git-send-email-imunsie@au1.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 07 Dec 2010 09:54:42 -0500
Message-ID: <1291733682.16223.244.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-07 at 15:29 +1100, Ian Munsie wrote:
> From: Ian Munsie <imunsie@au1.ibm.com>
> 
> With the ftrace events now checking if the syscall_nr is valid upon
> initialisation, there is no need to verify it when registering and
> unregistering the events, so remove the check.

I still like to keep these checks. I don't mind redundant checks that
are in slow paths, as they may catch a bug on a change in the future.

What you could do is change these to:

	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))

-- Steve

> 
> Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
> ---
>  kernel/trace/trace_syscalls.c |    9 +--------
>  1 files changed, 1 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index 14f4c02..5e34b49 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -367,8 +367,6 @@ int reg_event_syscall_enter(struct ftrace_event_call *call)
>  	int num;
>  
>  	num = ((struct syscall_metadata *)call->data)->syscall_nr;
> -	if (num < 0 || num >= NR_syscalls)
> -		return -ENOSYS;
>  	mutex_lock(&syscall_trace_lock);
>  	if (!sys_refcount_enter)
>  		ret = register_trace_sys_enter(ftrace_syscall_enter, NULL);
> @@ -385,8 +383,6 @@ void unreg_event_syscall_enter(struct ftrace_event_call *call)
>  	int num;
>  
>  	num = ((struct syscall_metadata *)call->data)->syscall_nr;
> -	if (num < 0 || num >= NR_syscalls)
> -		return;
>  	mutex_lock(&syscall_trace_lock);
>  	sys_refcount_enter--;
>  	clear_bit(num, enabled_enter_syscalls);
> @@ -401,8 +397,7 @@ int reg_event_syscall_exit(struct ftrace_event_call *call)
>  	int num;
>  
>  	num = ((struct syscall_metadata *)call->data)->syscall_nr;
> -	if (num < 0 || num >= NR_syscalls)
> -		return -ENOSYS;
> +
>  	mutex_lock(&syscall_trace_lock);
>  	if (!sys_refcount_exit)
>  		ret = register_trace_sys_exit(ftrace_syscall_exit, NULL);
> @@ -419,8 +414,6 @@ void unreg_event_syscall_exit(struct ftrace_event_call *call)
>  	int num;
>  
>  	num = ((struct syscall_metadata *)call->data)->syscall_nr;
> -	if (num < 0 || num >= NR_syscalls)
> -		return;
>  	mutex_lock(&syscall_trace_lock);
>  	sys_refcount_exit--;
>  	clear_bit(num, enabled_exit_syscalls);


