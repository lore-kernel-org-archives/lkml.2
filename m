Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab0ICAgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 20:36:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44554 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444Ab0ICAgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 20:36:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Colin Cross <ccross@android.com>
Subject: Re: [PATCH] PM: Prevent waiting forever on asynchronous resume after abort
Date: Fri, 3 Sep 2010 02:35:00 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, "Greg Kroah-Hartman" <gregkh@suse.de>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <AANLkTim7UM80MrwKoAz3hUFrqL2Fbyw6XS=X89PXRc2Q@mail.gmail.com> <201009030109.40816.rjw@sisk.pl> <AANLkTinbgShA+m3sdXrYAvW7ctCExp+fZv5EMuYSMLiE@mail.gmail.com>
In-Reply-To: <AANLkTinbgShA+m3sdXrYAvW7ctCExp+fZv5EMuYSMLiE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009030235.00270.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 03, 2010, Colin Cross wrote:
> On Thu, Sep 2, 2010 at 4:09 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday, September 03, 2010, Colin Cross wrote:
> >> On Thu, Sep 2, 2010 at 2:34 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> >> > On Thu, 2 Sep 2010, Colin Cross wrote:
> >> >
> >> >> That would work, but I still don't see why it's better.  With either
> >> >> of your changes, the power.completion variable is storing state, and
> >> >> not just used for notification.  However, the exact meaning of that
> >> >> state is unclear, especially during the transition from an aborted
> >> >> suspend to resume, and the state is duplicating power.status.  Setting
> >> >> it to complete in dpm_prepare is especially confusing, because at that
> >> >> point nothing is completed, it hasn't even been started.
> >> >
> >> > The state being waited for varies from time to time and is only
> >> > partially related to power.status.  Instead of using a completion I
> >> > suppose we could have used a new "transition_complete" variable
> >> > together with a waitqueue.  Would you prefer that?  It's effectively
> >> > the same thing as a completion, but without the nice packaging already
> >> > provided by the kernel.
> >> No, that doesn't change anything.  What I'd prefer to see is a
> >> wait_for_condition on the desired state of the parent.  As is,
> >> power.completion means one thing during suspend (the device has
> >> started, but not finished, suspending), and a different thing during
> >> resume (the device has not finished resuming, and may not have started
> >> resuming).  That difference is exactly what caused the bug - the
> >> completion has to be set on init so that it is set before the device
> >> starts suspend.
> >
> > Not really.  The bug is there, because my analysis of the suspend error code
> > path was wrong.  Sorry about that, but it has nothing to do with the "different
> > meaning" of the completions during suspend and resume.
> >
> > The completions here are simply used to enforce a specific ordering of
> > operations, nothing more.  They have no meaning beyond that.
>
> The completion variable maintains state.

So what?  Locks also maintain state.

> It has meaning whether or not you want it to.  Leaving it as a completion
> variable requires that you manage that state, which is difficult considering
> there is no documentation and no clear idea in the code of exactly when that
> state is set or clear.

Please run "git show 5af84b82701a96be4b033aaa51d86c72e2ded061" and read the
changelog.  It's described in there quite clearly (I think).

> It would be much cleaner to use a wait queue, and use
> wait_on_condition to wait for the device to be in the desired state.

Well, in fact that was used in one version of the patchset that introduced
asynchronous suspend-resume, but it was rejected by Linus, because it was
based on non-standard synchronization.  The Linus' argument, that I agreed
with, was that standard snychronization constructs, such as locks or
completions, were guaranteed to work accross different architectures and thus
were simply _safer_ to use than open-coded synchronization that you seem to be
preferring.

Completions simply allowed us to get the desired behavior with the least
effort and that's why we used them.

Thanks,
Rafael
