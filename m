Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab1FIU1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 16:27:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43707 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755887Ab1FIU1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 16:27:15 -0400
Date: Thu, 9 Jun 2011 22:27:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        efault@gmx.de, Arne Jansen <lists@die-jansens.de>
Subject: Re: [PATCH 1/3] printk: Release console_sem after logbuf_lock
Message-ID: <20110609202707.GA28951@elte.hu>
References: <20110609130647.937204592@chello.nl>
 <20110609131307.493181962@chello.nl>
 <20110609130617.f8aca966.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110609130617.f8aca966.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 09 Jun 2011 15:06:48 +0200
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > Release console_sem after unlocking the logbuf_lock so that we don't
> > generate wakeups while holding logbuf_lock. This avoids some lock
> > inversion troubles once we remove the lockdep_off bits between
> > logbuf_lock and rq->lock (prints while holding rq->lock vs doing
> > wakeups while holding logbuf_lock).
> > 
> > There's of course still an actual deadlock where the printk()s under
> > rq->lock will issue a wakeup from the up() call.
> > 
> > ...
> >
> > @@ -1271,8 +1273,8 @@ void console_unlock(void)
> >  	if (unlikely(exclusive_console))
> >  		exclusive_console = NULL;
> >  
> > -	up(&console_sem);
> >  	spin_unlock_irqrestore(&logbuf_lock, flags);
> > +	up(&console_sem);
> >  	if (wake_klogd)
> >  		wake_up_klogd();
> >  }
> 
> I have a horrible feeling that I put the up() inside logbuf_lock for
> Special And Cunning Reasons.  But I'm struggling to work out what they
> might have been and my archives only go back to October 2000(!).
> 
> Hate it when that happens.

Heh, here's what i told Peter two days ago when i saw that chunk:

  => Subject: printk: Release console_sem after logbuf_lock
  => i have some vague memories about some sort of complication in that area ...
  => but don't remember the specifics
  => only a 'there be dragons' mental marker

and i have to say that when i found a boot lockup during testing i 
was not surprised very much :)

Thanks,

	Ingo
