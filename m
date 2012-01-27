Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab2A0Oi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:38:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755071Ab2A0Oi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:38:56 -0500
Date: Fri, 27 Jan 2012 15:32:34 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + kmod-avoid-deadlock-by-recursive-kmod-call.patch added to
	-mm tree
Message-ID: <20120127143234.GA13056@redhat.com>
References: <20120126175612.GA24011@redhat.com> <87ipjxdfbg.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ipjxdfbg.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27, Rusty Russell wrote:
>
> On Thu, 26 Jan 2012 18:56:12 +0100, Oleg Nesterov <oleg@redhat.com> wrote:
> > > @@ -449,6 +460,16 @@ int call_usermodehelper_exec(struct subp
> > >  		retval = -EBUSY;
> > >  		goto out;
> > >  	}
> > > +	/*
> > > +	 * Worker thread must not wait for khelper thread at below
> > > +	 * wait_for_completion() if the thread was created with CLONE_VFORK
> > > +	 * flag, for khelper thread is already waiting for the thread at
> > > +	 * wait_for_completion() in do_fork().
> > > +	 */
> > > +	if (wait != UMH_NO_WAIT && current == kmod_thread_locker) {
> > > +		retval = -EBUSY;
> > > +		goto out;
> > > +	}
> >
> > So, this is because khelper_wq's max_active == 1.
> >
> > Can't we simply kill khelper_wq and use system_unbound_wq instead?
>
> I'd prefer that, because then we'd hit the existing "too many modprobes"
> check.

Hmm. Why? I mean, why do you think that s/khelper_wq/system_unbound_wq/
leads to recursive __request_module's ?

Note that that this patch (which adds kmod_thread_locker) can not limit
the recursive modprobe loop.


OK, yes, with system_unbound_wq we can hit this warning if we have
max_modprobes UMH_WAIT_EXEC's resulting in __request_module at the
same time, but probably this is good?

I guess I missed something, could you explain? Just curious.

Oleg.

