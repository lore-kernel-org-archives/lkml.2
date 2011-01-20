Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab1ATRf5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 12:35:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057Ab1ATRf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 12:35:57 -0500
Date: Thu, 20 Jan 2011 18:28:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Q: perf_event && task->ptrace_bps[]
Message-ID: <20110120172810.GA6809@redhat.com>
References: <20101108145647.GA3426@redhat.com> <20110117203459.GA32700@redhat.com> <20110118184234.GA1808@nowhere> <20110119153746.GA32563@redhat.com> <20110119200536.GC1772@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119200536.GC1772@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19, Frederic Weisbecker wrote:
>
> On Wed, Jan 19, 2011 at 04:37:46PM +0100, Oleg Nesterov wrote:
> >
> > I think we can reuse perf_event_mutex for this. Not very good too,
> > but simple. But this depends on what can we do under this mutex...
>
> That could work. I feel a bit uncomfortable to use a perf related
> mutex for that though. I can't figure out any deadlock with the current
> state, but if we are going to use that solution, perf events will be
> created/destroyed/disabled/enabled under that mutex.

No, I didn't mean create/destroy under that mutex, but

> Dunno, that doesn't seem to be a good use of perf_event_mutex.

I agree anyway.

> OTOH I can drop
> more of them for the no-running-breakpoint case from thread_struct
> in a subsequent task.

Hmm. Can't understand what do you mean. Just curious, could you explain?

> Note the problem touches more archs than x86. Basically every
> arch that use breakpoint use a similar scheme that must be fixed.

Yes. Perhaps we should try to unify some code... Say, can't we move
->ptrace_bps[] to task_struct?


> +void ptrace_put_breakpoints(struct task_struct *tsk)
> +{
> +	if (!atomic_dec_return(&tsk->ptrace_bp_refcnt))
> +		flush_ptrace_hw_breakpoint(tsk);

(minor nit, atomic_dec_and_test() looks more natural)


I think the patch is correct and should fix the problem.

Thanks!

Oleg.

