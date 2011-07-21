Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab1GUOvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 10:51:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab1GUOvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 10:51:16 -0400
Date: Thu, 21 Jul 2011 10:51:12 -0400
From: Don Zickus <dzickus@redhat.com>
To: ZAK Magnus <zakmagnus@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Track hard and soft "short lockups" or "stalls."
Message-ID: <20110721145112.GA24016@redhat.com>
References: <1310760670-32232-1-git-send-email-zakmagnus@google.com>
 <20110718122820.GB1808@redhat.com>
 <CAAuSN9106qmYF27oRrfUBtqwOmSQgDJWwv3iz_NmTTuYNEymHA@mail.gmail.com>
 <20110720154124.GS3765@redhat.com>
 <CAAuSN9362PvjiJCQti=GAKGjZNnptV3e9Ot0kBpo40b8L7u0mA@mail.gmail.com>
 <20110720210704.GF3400@redhat.com>
 <CAAuSN90cv8iz+EMaVP5QQREs8sQC+m4u55nMLOFXKuFXxpX8Cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAuSN90cv8iz+EMaVP5QQREs8sQC+m4u55nMLOFXKuFXxpX8Cw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 02:15:02PM -0700, ZAK Magnus wrote:
> On Wed, Jul 20, 2011 at 2:07 PM, Don Zickus <dzickus@redhat.com> wrote:
> > On Wed, Jul 20, 2011 at 12:41:39PM -0700, ZAK Magnus wrote:
> >> Are the stack traces very different? I don't understand in what sense
> >> it's confusing.
> >
> > The fact that there are 3 of them telling me the samething.  Most people
> > look at the first stack trace to figure out what is going on and will just
> > notice the warning.  They might completely miss the HARDLOCKUP message on
> > the third stack trace down.
> >
> > It just looked odd when I ran it the first time.  I feel like I would
> > constantly be trying to educate people on why we do it like that.
> Oh, okay. So, maybe the stall warnings should say something like, "a
> lockup might happen soon?" Would that help? I don't know.

Perhaps just changing the wording might help with the confusion.  After
reading below it might be hard to restrict the dump_stack to only the
highest stall (as opposed to printing each new worst hardstall as it
increments to a hardlockup).

> 
> >> I don't think that exact patch would work (wouldn't it cause
> >> update_hardstall to only ever be called with 0 as its first argument?)
> >> but I hope I still understand what you're saying. You're saying stalls
> >> should only be recorded once they're finished, right? I don't know if
> >> this is the best approach. If we wait until interrupts stop being
> >> missed, it means the code could have exited whatever section caused
> >> the stall to begin with. Maybe your data indicates otherwise, but I
> >> would think this means the stack trace would not really be
> >
> > Crap.  good point.
> Which part, exactly?

The part about losing the stalled section when the code resets the missed
interrupts back to 0.

> 
> >> informative. It's one thing to know a stall occurs, but its occurrence
> >> is generally reflective of a bug or a suboptimal section, so it would
> >> be good to know where that is in order to try and fix it.
> >>
> >> For soft stalls, I think the same is true. Also, since the soft lockup
> >> system just relies on checking a timestamp compared to now, it can't
> >> know how long a stall was after it has already finished. The hard
> >> system only knows because it keeps a running count of the number of
> >> failed checks. An additional timestamp could be introduced and the
> >> difference between the two retroactively checked in order to reproduce
> >> this, but the stack trace issue would still apply. Also, while not
> >> hugely complex, the change would be more significant than the sort
> >> your patch presents.
> >>
> >> The bottom line is that I think catching a stall in progress is the
> >> most informative thing to do, and I don't understand the downsides of
> >> doing so. Could you please explain them?
> >>
> >> On another note, I'm working on a patch on top of this one which would
> >> change the hard lockup system to be more like the soft lockup system.
> >> It would use a timestamp as well, so it can have a more exact read on
> >> how long the timer has been delayed. This adds resolution and gets rid
> >> of that problem where it can only report missed = 3 or 4. Any
> >> preliminary comments? Or should I just put the patch up before
> >> discussing it?
> >
> > That might work.  I would have to see the patch.  What clock would you use
> > to read the time?  I don't think you can use 'now' if interrupts are
> > disabled.
> Okay, I will send it when it seems ready. For the timestamp, I was
> just using the get_timestamp function that's defined in the file,
> which calls cpu_clock(). Is there a better way?

Oh right.  I forgot Peter created some abstraction called cpu_clock().
That should work I suppose, it's NMI safe according to various code
comments.  I just wonder if the clock gets updated if interrupts are
accidentally disabled for a long time.  Though TSC doesn't care on x86
about interrupts.

Cheers,
Don
