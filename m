Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab1KUUDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 15:03:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36097 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab1KUUDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 15:03:22 -0500
X-Authority-Analysis: v=2.0 cv=KcRQQHkD c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=OQnieflinJEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=20KFwNOVAAAA:8 a=qv0v0rZe6_nNnugHD4YA:9 a=o-kGGtEW9FGMmrSmacIA:7 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: Q: tracing: can we change trace_signal_generate() signature?
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20111121191920.GA24883@redhat.com>
References: <20111121191920.GA24883@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Nov 2011 15:03:19 -0500
Message-ID: <1321905799.20742.20.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 20:19 +0100, Oleg Nesterov wrote:
> Hello,
> 
> Is it possible to change trace_signal_generate()'s args or this
> is the part of the kernel ABI?

As Linus said. It's only part of the ABI if a tool is using it. If you
change it and no one complains, then it should be good to go.

> 
> We have the "feature request". The customer wants to know was the
> signal delivered or not, and why. We could add another trace_()
> into __send_signal() but this looks ugly to me.
> 
> So. Can't we add
> 
> 	enum {
> 		TRACE_SIGNAL_DELIVERED,
> 		TRACE_SIGNAL_IGNORED_OR_BLOCKED,
> 		TRACE_SIGNAL_ALREADY_PENDING,
> 	}
> 
> and move trace_signal_generate() to the end of __send_signal()
> with the additional argument(s) to avoid the new tracepoint?
> 
> If yes, then can't we also kill trace_signal_overflow_fail()
> and trace_signal_lose_info()? We can simply add more
> TRACE_SIGNAL_'s instead, this certainly looks better imho.

Again, if no tool relies on it, it should be fine.

If we were finally able to get a library for tools to read tracepoints,
then we could add and move them around with no issue.

> 
> IOW. Ignoring the changes in include/trace/events/signal.h,
> can the patch below work or the changes like this are not
> allowed?

I say change it and see who screams.

> 
> See also https://bugzilla.redhat.com/show_bug.cgi?id=738720
> 
> Thanks,
> 
> Oleg.
> 
> 
> --- x/kernel/signal.c
> +++ x/kernel/signal.c
> @@ -1019,19 +1019,27 @@ static inline int legacy_queue(struct sigpending *signals, int sig)
>  	return (sig < SIGRTMIN) && sigismember(&signals->signal, sig);
>  }
>  
> +enum {
> +	TRACE_SIGNAL_DELIVERED,
> +	TRACE_SIGNAL_IGNORED_OR_BLOCKED,
> +	TRACE_SIGNAL_ALREADY_PENDING,
> +	TRACE_SIGNAL_OVERFLOW_FAIL,
> +	TRACE_SIGNAL_LOSE_INFO,
> +};
> +
>  static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
>  			int group, int from_ancestor_ns)
>  {
>  	struct sigpending *pending;
>  	struct sigqueue *q;
>  	int override_rlimit;
> -
> -	trace_signal_generate(sig, info, t);
> +	int ret = 0, result;
>  
>  	assert_spin_locked(&t->sighand->siglock);
>  
> +	result = TRACE_SIGNAL_IGNORED_OR_BLOCKED;
>  	if (!prepare_signal(sig, t, from_ancestor_ns))
> -		return 0;
> +		goto ret;
>  
>  	pending = group ? &t->signal->shared_pending : &t->pending;
>  	/*
> @@ -1039,8 +1047,11 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
>  	 * exactly one non-rt signal, so that we can get more
>  	 * detailed information about the cause of the signal.
>  	 */
> +	result = TRACE_SIGNAL_ALREADY_PENDING;
>  	if (legacy_queue(pending, sig))
> -		return 0;
> +		goto ret;
> +
> +	result = TRACE_SIGNAL_DELIVERED;
>  	/*
>  	 * fast-pathed signals for kernel-internal things like SIGSTOP
>  	 * or SIGKILL.
> @@ -1095,14 +1106,15 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
>  			 * signal was rt and sent by user using something
>  			 * other than kill().
>  			 */
> -			trace_signal_overflow_fail(sig, group, info);
> -			return -EAGAIN;
> +			result = TRACE_SIGNAL_OVERFLOW_FAIL;
> +			ret = -EAGAIN;
> +			goto ret;
>  		} else {
>  			/*
>  			 * This is a silent loss of information.  We still
>  			 * send the signal, but the *info bits are lost.
>  			 */
> -			trace_signal_lose_info(sig, group, info);
> +			result = TRACE_SIGNAL_LOSE_INFO;

Hmm, all this result manipulation added for tracing that doesn't occur
in 99.99% of all machines?

-- Steve


>  		}
>  	}
>  
> @@ -1110,7 +1122,9 @@ out_set:
>  	signalfd_notify(t, sig);
>  	sigaddset(&pending->signal, sig);
>  	complete_signal(sig, t, group);
> -	return 0;
> +ret:
> +	trace_signal_generate(sig, info, t, group, result);
> +	return ret;
>  }
>  
>  static int send_signal(int sig, struct siginfo *info, struct task_struct *t,


