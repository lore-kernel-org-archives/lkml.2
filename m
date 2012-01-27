Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab2A0LQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 06:16:12 -0500
Received: from ozlabs.org ([203.10.76.45]:56735 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951Ab2A0LQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 06:16:10 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Oleg Nesterov <oleg@redhat.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + kmod-avoid-deadlock-by-recursive-kmod-call.patch added to -mm tree
In-Reply-To: <20120126175612.GA24011@redhat.com>
References: <20120126175612.GA24011@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 27 Jan 2012 13:25:47 +1030
Message-ID: <87ipjxdfbg.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jan 2012 18:56:12 +0100, Oleg Nesterov <oleg@redhat.com> wrote:
> > @@ -449,6 +460,16 @@ int call_usermodehelper_exec(struct subp
> >  		retval = -EBUSY;
> >  		goto out;
> >  	}
> > +	/*
> > +	 * Worker thread must not wait for khelper thread at below
> > +	 * wait_for_completion() if the thread was created with CLONE_VFORK
> > +	 * flag, for khelper thread is already waiting for the thread at
> > +	 * wait_for_completion() in do_fork().
> > +	 */
> > +	if (wait != UMH_NO_WAIT && current == kmod_thread_locker) {
> > +		retval = -EBUSY;
> > +		goto out;
> > +	}
> 
> So, this is because khelper_wq's max_active == 1.
> 
> Can't we simply kill khelper_wq and use system_unbound_wq instead?

I'd prefer that, because then we'd hit the existing "too many modprobes"
check.

Thanks,
Rusty.
