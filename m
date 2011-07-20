Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab1GTVHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 17:07:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912Ab1GTVHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 17:07:06 -0400
Date: Wed, 20 Jul 2011 17:07:04 -0400
From: Don Zickus <dzickus@redhat.com>
To: ZAK Magnus <zakmagnus@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Track hard and soft "short lockups" or "stalls."
Message-ID: <20110720210704.GF3400@redhat.com>
References: <1310760670-32232-1-git-send-email-zakmagnus@google.com>
 <20110718122820.GB1808@redhat.com>
 <CAAuSN9106qmYF27oRrfUBtqwOmSQgDJWwv3iz_NmTTuYNEymHA@mail.gmail.com>
 <20110720154124.GS3765@redhat.com>
 <CAAuSN9362PvjiJCQti=GAKGjZNnptV3e9Ot0kBpo40b8L7u0mA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAuSN9362PvjiJCQti=GAKGjZNnptV3e9Ot0kBpo40b8L7u0mA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 12:41:39PM -0700, ZAK Magnus wrote:
> > I then count to 10 seconds to make sure the timer is within reason.
> >
> > So I did the above test and noticed the panic looked funny because it spit
> > out the
> >
> > new worst hard stall seen on CPU#0: 3 interrupts missed
> >
> > and then
> >
> > new worst hard stall seen on CPU#0: 4 interrupts missed
> >
> > and then finally the HARDLOCKUP message
> >
> > I am not sure that is what we want as it confuses people as to where the
> > panic really is.
> Are the stack traces very different? I don't understand in what sense
> it's confusing.

The fact that there are 3 of them telling me the samething.  Most people
look at the first stack trace to figure out what is going on and will just
notice the warning.  They might completely miss the HARDLOCKUP message on
the third stack trace down.

It just looked odd when I ran it the first time.  I feel like I would
constantly be trying to educate people on why we do it like that.

> 
> > What if you moved the 'update_hardstall()' to just underneath the zero'ing
> > out of the hrtimer_interrupts_missed?  This only then prints out the
> > interrupts missed line when you know the end point.  And avoids printing
> > it all together in the case of a true HARDLOCKUP.  Like the patch below
> >
> > diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> > index 7d37cc2..ba41a74 100644
> > --- a/kernel/watchdog.c
> > +++ b/kernel/watchdog.c
> > @@ -238,13 +238,14 @@ static int is_hardlockup(int this_cpu)
> >
> >        if (hrint_saved == hrint)
> >                ints_missed = per_cpu(hrtimer_interrupts_missed, this_cpu)++;
> > -       else
> > +       else {
> >                __this_cpu_write(hrtimer_interrupts_missed, 0);
> > +               update_hardstall(ints_missed, this_cpu);
> > +       }
> >
> >        if (ints_missed >= hardlockup_thresh)
> >                return 1;
> >
> > -       update_hardstall(ints_missed, this_cpu);
> >        return 0;
> >  }
> >  #endif
> >
> > The softlockup case probably needs the same.
> >
> > Thoughts?
> I don't think that exact patch would work (wouldn't it cause
> update_hardstall to only ever be called with 0 as its first argument?)
> but I hope I still understand what you're saying. You're saying stalls
> should only be recorded once they're finished, right? I don't know if
> this is the best approach. If we wait until interrupts stop being
> missed, it means the code could have exited whatever section caused
> the stall to begin with. Maybe your data indicates otherwise, but I
> would think this means the stack trace would not really be

Crap.  good point.

> informative. It's one thing to know a stall occurs, but its occurrence
> is generally reflective of a bug or a suboptimal section, so it would
> be good to know where that is in order to try and fix it.
> 
> For soft stalls, I think the same is true. Also, since the soft lockup
> system just relies on checking a timestamp compared to now, it can't
> know how long a stall was after it has already finished. The hard
> system only knows because it keeps a running count of the number of
> failed checks. An additional timestamp could be introduced and the
> difference between the two retroactively checked in order to reproduce
> this, but the stack trace issue would still apply. Also, while not
> hugely complex, the change would be more significant than the sort
> your patch presents.
> 
> The bottom line is that I think catching a stall in progress is the
> most informative thing to do, and I don't understand the downsides of
> doing so. Could you please explain them?
> 
> On another note, I'm working on a patch on top of this one which would
> change the hard lockup system to be more like the soft lockup system.
> It would use a timestamp as well, so it can have a more exact read on
> how long the timer has been delayed. This adds resolution and gets rid
> of that problem where it can only report missed = 3 or 4. Any
> preliminary comments? Or should I just put the patch up before
> discussing it?

That might work.  I would have to see the patch.  What clock would you use
to read the time?  I don't think you can use 'now' if interrupts are
disabled.

Cheers,
Don

