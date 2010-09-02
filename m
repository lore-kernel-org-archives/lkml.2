Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab0IBXLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 19:11:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44444 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365Ab0IBXLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 19:11:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Colin Cross <ccross@android.com>
Subject: Re: [PATCH] PM: Prevent waiting forever on asynchronous resume after abort
Date: Fri, 3 Sep 2010 01:09:40 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, "Greg Kroah-Hartman" <gregkh@suse.de>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <AANLkTim7UM80MrwKoAz3hUFrqL2Fbyw6XS=X89PXRc2Q@mail.gmail.com> <Pine.LNX.4.44L0.1009021723460.1311-100000@iolanthe.rowland.org> <AANLkTin_-y2nsXhH+mXv=bku=WXO7VhfvknYwtLhURfv@mail.gmail.com>
In-Reply-To: <AANLkTin_-y2nsXhH+mXv=bku=WXO7VhfvknYwtLhURfv@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009030109.40816.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 03, 2010, Colin Cross wrote:
> On Thu, Sep 2, 2010 at 2:34 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Thu, 2 Sep 2010, Colin Cross wrote:
> >
> >> That would work, but I still don't see why it's better.  With either
> >> of your changes, the power.completion variable is storing state, and
> >> not just used for notification.  However, the exact meaning of that
> >> state is unclear, especially during the transition from an aborted
> >> suspend to resume, and the state is duplicating power.status.  Setting
> >> it to complete in dpm_prepare is especially confusing, because at that
> >> point nothing is completed, it hasn't even been started.
> >
> > The state being waited for varies from time to time and is only
> > partially related to power.status.  Instead of using a completion I
> > suppose we could have used a new "transition_complete" variable
> > together with a waitqueue.  Would you prefer that?  It's effectively
> > the same thing as a completion, but without the nice packaging already
> > provided by the kernel.
> No, that doesn't change anything.  What I'd prefer to see is a
> wait_for_condition on the desired state of the parent.  As is,
> power.completion means one thing during suspend (the device has
> started, but not finished, suspending), and a different thing during
> resume (the device has not finished resuming, and may not have started
> resuming).  That difference is exactly what caused the bug - the
> completion has to be set on init so that it is set before the device
> starts suspend.

Not really.  The bug is there, because my analysis of the suspend error code
path was wrong.  Sorry about that, but it has nothing to do with the "different
meaning" of the completions during suspend and resume.

The completions here are simply used to enforce a specific ordering of
operations, nothing more.  They have no meaning beyond that.

> I'll send the complete_all on init patch, as it's the only way to fix
> the problem given the current implementation of dpm_wait.

Great, thanks.

Rafael
