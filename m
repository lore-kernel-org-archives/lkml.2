Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab2HAASp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 20:18:45 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:52283 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab2HAASo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 20:18:44 -0400
Date: Tue, 31 Jul 2012 17:18:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Avi Kivity <avi@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: Testing tracer wakeup_rt: .. no entries found ..FAILED!
Message-ID: <20120801001811.GX2422@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1343663105.3847.7.camel@fedora>
 <20120731121759.GA17822@localhost>
 <5017D19B.5080806@redhat.com>
 <1343738627.27983.30.camel@gandalf.stny.rr.com>
 <5017D4AB.3090107@redhat.com>
 <1343740419.27983.33.camel@gandalf.stny.rr.com>
 <20120731234336.GA5526@localhost>
 <1343778699.27983.70.camel@gandalf.stny.rr.com>
 <20120731235705.GW2422@linux.vnet.ibm.com>
 <1343779778.27983.73.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343779778.27983.73.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080100-2398-0000-0000-00000905DD52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 08:09:38PM -0400, Steven Rostedt wrote:
> On Tue, 2012-07-31 at 16:57 -0700, Paul E. McKenney wrote:
> 
> > > What was the next lines? I bet you it was "PASSED". Which means it did
> > > not fail. This is the second bug you found that has to do with RCU being
> > > called in 'idle'. The one that Paul posted a patch for.
> > 
> > Though it needs another patch to actually use it in the right place...
> 
> Right. Something like this:

Looks good to me!

							Thanx, Paul

> -- Steve
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 5638104..d915638 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -631,7 +631,12 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
> 
>  	memcpy(max_data->comm, tsk->comm, TASK_COMM_LEN);
>  	max_data->pid = tsk->pid;
> -	max_data->uid = task_uid(tsk);
> +	/*
> +	 * task_uid() calls rcu_read_lock, but this can be called
> +	 * outside of RCU state monitoring (irq going back to idle).
> +	 */ 
> +	RCU_NONIDLE(max_data->uid = task_uid(tsk));
> +
>  	max_data->nice = tsk->static_prio - 20 - MAX_RT_PRIO;
>  	max_data->policy = tsk->policy;
>  	max_data->rt_priority = tsk->rt_priority;
> 
> 

