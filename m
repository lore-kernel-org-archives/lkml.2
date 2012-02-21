Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317Ab2BUXga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 18:36:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35797 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab2BUXfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 18:35:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [RFC][PATCH 0/7] PM: Implement autosleep and "wake locks", take 2
Date: Wed, 22 Feb 2012 00:31:45 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        markgross@thegnar.org, Matthew Garrett <mjg@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <201202070200.55505.rjw@sisk.pl>
In-Reply-To: <201202070200.55505.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201202220031.46219.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After the feedback so far I've decided to follow up with a refreshed patchset.
The first two patches from the previous one went to linux-pm/linux-next
and I included the recent evdev patch from Arve (with some modifications)
to this patchset for completness.

On Tuesday, February 07, 2012, Rafael J. Wysocki wrote:
> Hi all,
> 
> This series tests the theory that the easiest way to sell a once rejected
> feature is to advertise it under a different name.
> 
> Well, there actually are two different features, although they are closely
> related to each other.  First, patch [6/8] introduces a feature that allows
> the kernel to trigger system suspend (or more generally a transition into
> a sleep state) whenever there are no active wakeup sources (no, they aren't
> called wakelocks).  It is called "autosleep" here, but it was called a few
> different names in the past ("opportunistic suspend" was probably the most
> popular one).  Second, patch [8/8] introduces "wake locks" that are,
> essentially, wakeup sources which may be created and manipulated by user
> space.  Using them user space may control the autosleep feature introduced
> earlier.
> 
> This also is a kind of a proof of concept for the people who wanted me to
> show a kernel-based implementation of automatic suspend, so there you go.
> Please note, however, that it is done so that the user space "wake locks"
> interface is compatible with Android in support of its user space.  I don't
> really like this interface, but since the Android's user space seems to rely
> on it, I'm fine with using it as is.  YMMV.
> 
> Let me say a few words about every patch in the series individually.
> 
> [1/8] - This really is a bug fix, so it's v3.4 material.  Nobody has stepped
>   on this bug so far, but it should be fixed anyway.
> 
> [2/8] - This is a freezer cleanup, worth doing anyway IMO, so v3.4 material too.

The above two are in linux-pm/linux-next now.  There are a few more fixes
related to wakeup sources in there and the patches below are based on that
branch.

> [3/8] - This is something we can do no problem, although completely optional
>   without the autosleep feature.  Rather necessary with it, though.

Now [1/7] - Look for wakeup events in later stages of device suspend.

> [4/8] - This kind of reintroduces my original idea of using a wait queue for
>   waiting until there are no wakeup events in progress.  Alan convinced me that
>   it would be better to poll the counter to prevent wakeup_source_deactivate()
>   from having to call wake_up_all() occasionally (that may be costly in fast
>   paths), but then quite some people told me that the wait queue migh be
>   better.  I think that the polling will make much less sense with autosleep
>   and user space "wake locks".  Anyway, [4/8] is something we can do without
>   those things too.

Now [2/7] - Use wait queue to signal "no wakeup events in progress"

  With a couple of improvements suggested by Neil.

> The patches above were given Sign-off-by tags, because I think they make some
> sense regardless of the features introcuded by the remaining patches that in
> turn are total RFC.

This time all of the patches are signed-off and include the requisite
documentation changes (hopefully, I haven't forgotten about anything).

> [5/8] - This changes wakeup source statistics so that they are more similar to
>   the statistics collected for wakelocks on Android.  The file those statistics
>   may be read from is still located in debugfs, though (I don't think it
>   belongs to proc and its name is different from the analogous Android's file
>   name anyway).  It could be done without autosleep, but then it would be a bit
>   pointless.  BTW, this changes interfaces that _in_ _theory_ may be used by
>   someone, but I'm not aware of anyone using them.  If you are one, I'll be
>   pleased to learn about that, so please tell me who you are. :-)

Now [3/7] - Change wakeup source statistics to follow Android.

  Rebased and reworked in accordance with the Arve's feedback.

[4/7] - Add ioctl to block suspend while event queue is not empty.

  Originally posted by Arve as http://marc.info/?l=linux-pm&m=132711288825973&w=4
  Reworked and with modified changelog (I wonder what Dmity thinks about this).

  It has some minor problems (for example, in some situations the queue wakeup
  source may be activated for events that are not coming from a wakeup device),
  but I think it's simple enough, at least for illustration.  The ioctls
  introduced here will be used by Android user space anyway, although perhaps
  under different names, AFAICS.

> [6/8] - Autosleep implementation.  I think the changelog explains the idea
>   quite well and the code is really nothing special.  It doesn't really add
>   anything new to the kernel in terms of infrastructure etc., it just uses
>   the existing stuff to implement an alternative method of triggering system
>   sleep transitions.  Note, though, that the interface here is different
>   from the Android's one, because Android actually modifies /sys/power/state
>   to trigger something called "early suspend" (that is never going to be
>   implemented in the "stock" kernel as long as I have any influence on it) and
>   we simply can't do that in the mainline.

Now [5/7] - Implement opportunistic sleep

  Rebased and simplified (most notably, I've dropped the "main" wakeup source,
  since it wasn't really necessary).

> [7/8] - This adds a wakeup source statistics that only makes sense with
>   autosleep and (I believe) is analogous to the Android's prevent_suspend_time
>   statistics.  Nothing really special, but I didn't want
>   wakeup_source_activate/deactivate() to take a common lock to avoid
>   congestion.

Now [6/7] - Add "prevent autosleep time" statistics to wakeup sources.

  Rebased.

> [8/8] - This adds a user space interface to create, activate and deactivate
>   wakeup sources.  Since the files it consists of are called wake_lock and
>   wake_unlock, to follow Android, the objects the wakeup sources are wrapped
>   into are called "wakelocks" (for added confusion).  Since the interface
>   doesn't provide any means to destroy those "wakelocks", I added a garbage
>   collection mechanism to get rid of the unused ones, if any.  I also tought
>   it might be a good idea to put a limit on the number of those things that
>   user space can operate simultaneously, so I did that too.

Now [7/7] - Add user space interface for manipulating wakeup sources.

> All of the above has been tested very briefly on my test-bed Mackerel board
> and it quite obviously requires more thorough testing, but first I need to know
> if it makes sense to spend any more time on it.

The above is still accurate, but I also verified that the patches don't break
my PC test boxes (at least as long as the new features aren't used ;-)).

Thanks,
Rafael

