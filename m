Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab1AKWH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 17:07:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44392 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584Ab1AKWHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 17:07:24 -0500
Date: Wed, 12 Jan 2011 09:07:07 +1100
From: NeilBrown <neilb@suse.de>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
        stable@kernel.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Change wait_for_completion_*_timeout()
 to return a signed long
Message-ID: <20110112090707.4a794483@notabene.brown>
In-Reply-To: <20110111214457.GD28537@fieldses.org>
References: <20110105125016.64ccab0e@notabene.brown>
	<tip-6bf4123760a5aece6e4829ce90b70b6ffd751d65@git.kernel.org>
	<20110111214457.GD28537@fieldses.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jan 2011 16:44:58 -0500 "J. Bruce Fields" <bfields@fieldses.org>
wrote:

> Doesn't this belong in 2.6.37.y as well?

Yes indeed!
I should have tagged it for Cc:stable@kernel.org in the first place.  I had
been meaning to forward it to stable@kernel.org, but you beat me to it!

Thanks,
NeilBrown


> 
> --b.
> 
> On Wed, Jan 05, 2011 at 02:07:12PM +0000, tip-bot for NeilBrown wrote:
> > Commit-ID:  6bf4123760a5aece6e4829ce90b70b6ffd751d65
> > Gitweb:     http://git.kernel.org/tip/6bf4123760a5aece6e4829ce90b70b6ffd751d65
> > Author:     NeilBrown <neilb@suse.de>
> > AuthorDate: Wed, 5 Jan 2011 12:50:16 +1100
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Wed, 5 Jan 2011 14:15:50 +0100
> > 
> > sched: Change wait_for_completion_*_timeout() to return a signed long
> > 
> > wait_for_completion_*_timeout() can return:
> > 
> >    0: if the wait timed out
> >  -ve: if the wait was interrupted
> >  +ve: if the completion was completed.
> > 
> > As they currently return an 'unsigned long', the last two cases
> > are not easily distinguished which can easily result in buggy
> > code, as is the case for the recently added
> > wait_for_completion_interruptible_timeout() call in
> > net/sunrpc/cache.c
> > 
> > So change them both to return 'long'.  As MAX_SCHEDULE_TIMEOUT
> > is LONG_MAX, a large +ve return value should never overflow.
> > 
> > Signed-off-by: NeilBrown <neilb@suse.de>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: J.  Bruce Fields <bfields@fieldses.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > LKML-Reference: <20110105125016.64ccab0e@notabene.brown>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  include/linux/completion.h |    8 ++++----
> >  kernel/sched.c             |    4 ++--
> >  2 files changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/include/linux/completion.h b/include/linux/completion.h
> > index 36d57f7..51494e6 100644
> > --- a/include/linux/completion.h
> > +++ b/include/linux/completion.h
> > @@ -81,10 +81,10 @@ extern int wait_for_completion_interruptible(struct completion *x);
> >  extern int wait_for_completion_killable(struct completion *x);
> >  extern unsigned long wait_for_completion_timeout(struct completion *x,
> >  						   unsigned long timeout);
> > -extern unsigned long wait_for_completion_interruptible_timeout(
> > -			struct completion *x, unsigned long timeout);
> > -extern unsigned long wait_for_completion_killable_timeout(
> > -			struct completion *x, unsigned long timeout);
> > +extern long wait_for_completion_interruptible_timeout(
> > +	struct completion *x, unsigned long timeout);
> > +extern long wait_for_completion_killable_timeout(
> > +	struct completion *x, unsigned long timeout);
> >  extern bool try_wait_for_completion(struct completion *x);
> >  extern bool completion_done(struct completion *x);
> >  
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index f2f914e..114a0de 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -4395,7 +4395,7 @@ EXPORT_SYMBOL(wait_for_completion_interruptible);
> >   * This waits for either a completion of a specific task to be signaled or for a
> >   * specified timeout to expire. It is interruptible. The timeout is in jiffies.
> >   */
> > -unsigned long __sched
> > +long __sched
> >  wait_for_completion_interruptible_timeout(struct completion *x,
> >  					  unsigned long timeout)
> >  {
> > @@ -4428,7 +4428,7 @@ EXPORT_SYMBOL(wait_for_completion_killable);
> >   * signaled or for a specified timeout to expire. It can be
> >   * interrupted by a kill signal. The timeout is in jiffies.
> >   */
> > -unsigned long __sched
> > +long __sched
> >  wait_for_completion_killable_timeout(struct completion *x,
> >  				     unsigned long timeout)
> >  {

