Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab2BYUjz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 15:39:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42228 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080Ab2BYUjx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 15:39:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [RFC][PATCH 0/7] PM: Implement autosleep and "wake locks", take2
Date: Sat, 25 Feb 2012 21:43:52 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <201202070200.55505.rjw@sisk.pl> <201202250021.36738.rjw@sisk.pl> <CAMP5Xge1=4QJOq7tVJNvrXopYVBRuPE0yq4yDtcutp7RJkuUNg@mail.gmail.com>
In-Reply-To: <CAMP5Xge1=4QJOq7tVJNvrXopYVBRuPE0yq4yDtcutp7RJkuUNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202252143.53271.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, February 25, 2012, Arve Hjønnevåg wrote:
> On Fri, Feb 24, 2012 at 3:21 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday, February 24, 2012, Srivatsa S. Bhat wrote:
> >> On 02/24/2012 03:02 AM, Rafael J. Wysocki wrote:
> >>
> >> > On Thursday, February 23, 2012, Rafael J. Wysocki wrote:
> >> >> On Thursday, February 23, 2012, Srivatsa S. Bhat wrote:
> >> >>> On 02/23/2012 03:40 AM, Rafael J. Wysocki wrote:
> > [...]
> >> >>>
> >> >>> By the way, I am just curious.. how difficult will this make it for userspace
> >> >>> to disable autosleep? I mean, would a trylock mean that the user has to keep
> >> >>> fighting until he finally gets a chance to disable autosleep?
> >> >>
> >> >> That's a good point, so I think it may be a good idea to do
> >> >> mutex_lock_interruptible() in pm_autosleep_set_state() instead.
> >> >
> >> > Now that I think of it, perhaps it's a good idea to just make
> >> > pm_autosleep_lock() do mutex_lock_interruptible() _and_ make
> >> > pm_autosleep_set_state() use pm_autosleep_lock().
> >> >
> >> > What do you think?
> >> >
> >>
> >>
> >> Well, I don't think mutex_lock_interruptible() would help us much..
> >> Consider what would happen, if we use it:
> >>
> >> * pm-suspend got initiated as part of autosleep. Acquired autosleep lock.
> >> * Userspace is about to get frozen.
> >> * Now, the user tries to write "off" to autosleep. And hence, he is waiting
> >>   for autosleep lock, interruptibly.
> >> * The freezer sent a fake signal to all userspace processes and hence
> >>   this process also got interrupted.. it is no longer waiting on autosleep
> >>   lock - it got the signal and returned, and got frozen.
> >>   (And when the userspace gets thawed later, this process won't have the
> >>    autosleep lock - which is a different (but yet another) problem).
> >>
> >> So ultimately the only thing we achieved is to ensure that freezing of
> >> userspace goes smoothly. But the user process could not succeed in
> >> disabling autosleep. Of course we can work around that by having the
> >> mutex_lock_interruptible() in a loop and so on, but that gets very
> >> ugly pretty soon.
> >>
> >> So, I would suggest the following solution:
> >>
> >> We want to achieve 2 things here:
> >>  a. A user process trying to write to /sys/power/state or
> >>     /sys/power/autosleep should not cause freezing failures.
> >>  b. When a user process writes "off" to autosleep, the suspend/hibernate
> >>     attempt that is on-going, if any, must be immediately aborted, to give
> >>     the user the feeling that his preference has been noticed and respected.
> >>
> >> And to achieve this, we note that a user process can write "off" to autosleep
> >> only until the userspace gets frozen. No chance after that.
> >>
> >> So, let's do this:
> >> 1. Drop the autosleep lock before entering pm-suspend/hibernate.
> >> 2. This means, a user process can get hold of this lock and successfully
> >>    disable autosleep a moment after we initiated suspend, but before userspace
> >>    got frozen fully.
> >> 3. So, to respect the user's wish, we add a check immediately after the
> >>    freezing of userspace is complete - we check if the user disabled autosleep
> >>    and bail out, if he did. Otherwise, we continue and suspend the machine.
> >>
> >> IOW, this is like hitting 2 birds with one stone ;-)
> >> We don't hold autosleep lock throughout suspend/hibernate, but still react
> >> instantly when the user disables autosleep. And of course, freezing of tasks
> >> won't fail, ever! :-)
> >
> > Well, you essentially are postulating to restore the "interface" wakeup source
> > that was present in the previous version of this patch and that I dropped in
> > order to simplify the code.
> >
> > I guess I can do that ...
> >
> 
> If this wakeup source is reported as active whenever user-space has
> not requested suspend that would be useful in the stats. It does not
> look like your original patch did this however,

No, it didn't.

> but you could have a
> main wakeup-source that you release when any form of suspend is
> requested and activate when turning off auto suspend or returning from
> a one-shot suspend operation.

I honestly don't think I can do that and handle the /sys/power/wakeup_count
 -> /sys/power/state handoff (which is used by OLPC, as we've learnt recently)
sanely at the same time.  OTOH, I don't want CONFIG_AUTOSLEEP to disable that
interface entirely, because things like that basically prevent people from
trying alternative features, which is essential to us for "interesting
feedback" reasons.

So, my "main" wakeup source is only going to register the number of times user
space has (successfully) written to /sysp/power/autosleep (please have a look
at the updated patch I'm going to send in a reply to Srivatsa in a little
while).

Thanks,
Rafael
