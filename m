Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab1FIUvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 16:51:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:54749 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab1FIUvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 16:51:05 -0400
Subject: Re: [PATCH 1/3] printk: Release console_sem after logbuf_lock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        efault@gmx.de, Arne Jansen <lists@die-jansens.de>
In-Reply-To: <20110609202707.GA28951@elte.hu>
References: <20110609130647.937204592@chello.nl>
	 <20110609131307.493181962@chello.nl>
	 <20110609130617.f8aca966.akpm@linux-foundation.org>
	 <20110609202707.GA28951@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Jun 2011 22:54:43 +0200
Message-ID: <1307652883.2497.1028.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-09 at 22:27 +0200, Ingo Molnar wrote:

> > > @@ -1271,8 +1273,8 @@ void console_unlock(void)
> > >  	if (unlikely(exclusive_console))
> > >  		exclusive_console = NULL;
> > >  
> > > -	up(&console_sem);
> > >  	spin_unlock_irqrestore(&logbuf_lock, flags);
> > > +	up(&console_sem);
> > >  	if (wake_klogd)
> > >  		wake_up_klogd();
> > >  }
> > 
> > I have a horrible feeling that I put the up() inside logbuf_lock for
> > Special And Cunning Reasons.  But I'm struggling to work out what they
> > might have been and my archives only go back to October 2000(!).
> > 
> > Hate it when that happens.
> 
> Heh, here's what i told Peter two days ago when i saw that chunk:
> 
>   => Subject: printk: Release console_sem after logbuf_lock
>   => i have some vague memories about some sort of complication in that area ...
>   => but don't remember the specifics
>   => only a 'there be dragons' mental marker

Right, my reply was that I couldn't convince myself unlock order could
make a difference, but clearly I can easily have missed something
subtle.

> and i have to say that when i found a boot lockup during testing i 
> was not surprised very much :)

But you found a lockup on the second patch, not this one.

Also, this patch is important for #3, where we want to take logbuf_lock
under the semaphore internal lock, that too would preclude us doing that
up() in the old location.



