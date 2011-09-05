Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693Ab1IECdb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 22:33:31 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50513 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab1IECdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 22:33:24 -0400
Date: Mon, 5 Sep 2011 11:33:15 +0900
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: matthltc@us.ibm.com, rjw@sisk.pl, paul@paulmenage.org,
        containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] freezer: kill unused set_freezable_with_signal()
Message-ID: <20110905023315.GB9807@htj.dyndns.org>
References: <1314988070-12244-1-git-send-email-tj@kernel.org>
 <1314988070-12244-7-git-send-email-tj@kernel.org>
 <20110904184626.GA30101@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110904184626.GA30101@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Sun, Sep 04, 2011 at 08:46:26PM +0200, Oleg Nesterov wrote:
> > @@ -72,10 +72,6 @@ bool __refrigerator(bool check_kthr_stop)
> >  		schedule();
> >  	}
> >
> > -	spin_lock_irq(&current->sighand->siglock);
> > -	recalc_sigpending(); /* We sent fake signal, clean it up */
> > -	spin_unlock_irq(&current->sighand->siglock);
> > -
> 
> Why? This recalc_sigpending() makes sense imho. Otherwise the user-space
> tasks (almost) always return with TIF_SIGPENDING. May be we can do this
> under "if (PF_KTRHREAD)".

PF_KTHREAD no longer gets TIF_SIGPENDING set, so...

> For example. Suppose the user-space task does wait_event_freezable()...
> 
> Hmm. OTOH, wait_event_freezable() looks wrong anyway... So probably
> this doesn't matter. ptrace_stop/get_signal_to_deliver doesn't need
> this, probably we do not care about the other callers.

Can you elaborate on it being wrong?  Do you mean the possibility of
leaking spurious TIF_SIGPENDING?

> It seems, a lot of get_signal_to_deliver() calles also call
> try_to_freeze() for no reason.

Yeap, it doesn't really matter.  In most cases userland tasks would
get parked in the signal delivery path anyway and if a task is deep in
the kernel, it should and usually does hit syscall restart path.
Except for few special cases (maybe some of unfailable NFS calls),
there'userland tasks shouldn't take try_to_freeze() path outside of
signal delivery / job control path.

Also, in general, I don't think it's a good idea to add non-trivial
optimization like above to code path which is as cold as it gets
without any backing data.  The PM freezer used to busy loop until all
tasks enter refrigerator.  Nobody cares whether some tasks enter
signal delivery path one more time.

> So, yes, I am starting to think this change is fine too ;)

Yeay. :)

Thanks.

-- 
tejun
