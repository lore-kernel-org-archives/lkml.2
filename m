Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab2BLBUF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 20:20:05 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33026 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042Ab2BLBUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 20:20:03 -0500
Date: Sat, 11 Feb 2012 17:19:58 -0800
From: mark gross <markgross@thegnar.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <greg@linuxfoundation.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 0/8] PM: Implement autosleep and "wake locks"
Message-ID: <20120212011958.GA18742@gs62>
Reply-To: markgross@thegnar.org
References: <201202070200.55505.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201202070200.55505.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 07, 2012 at 02:00:55AM +0100, Rafael J. Wysocki wrote:
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
> 
> [3/8] - This is something we can do no problem, although completely optional
>   without the autosleep feature.  Rather necessary with it, though.
> 
> [4/8] - This kind of reintroduces my original idea of using a wait queue for
>   waiting until there are no wakeup events in progress.  Alan convinced me that
>   it would be better to poll the counter to prevent wakeup_source_deactivate()
>   from having to call wake_up_all() occasionally (that may be costly in fast
>   paths), but then quite some people told me that the wait queue migh be
>   better.  I think that the polling will make much less sense with autosleep
>   and user space "wake locks".  Anyway, [4/8] is something we can do without
>   those things too.
> 
> The patches above were given Sign-off-by tags, because I think they make some
> sense regardless of the features introcuded by the remaining patches that in
> turn are total RFC.
> 
> [5/8] - This changes wakeup source statistics so that they are more similar to
>   the statistics collected for wakelocks on Android.  The file those statistics
>   may be read from is still located in debugfs, though (I don't think it
>   belongs to proc and its name is different from the analogous Android's file
>   name anyway).  It could be done without autosleep, but then it would be a bit
>   pointless.  BTW, this changes interfaces that _in_ _theory_ may be used by
>   someone, but I'm not aware of anyone using them.  If you are one, I'll be
>   pleased to learn about that, so please tell me who you are. :-)
> 
> [6/8] - Autosleep implementation.  I think the changelog explains the idea
>   quite well and the code is really nothing special.  It doesn't really add
>   anything new to the kernel in terms of infrastructure etc., it just uses
>   the existing stuff to implement an alternative method of triggering system
>   sleep transitions.  Note, though, that the interface here is different
>   from the Android's one, because Android actually modifies /sys/power/state
>   to trigger something called "early suspend" (that is never going to be
>   implemented in the "stock" kernel as long as I have any influence on it) and
>   we simply can't do that in the mainline.
dude early suspend is the hallmark of enlightend coding for implementing
a kernel / user mode handshake to user mode when the display is turned
off.  How can you not like that shit?

> 
> [7/8] - This adds a wakeup source statistics that only makes sense with
>   autosleep and (I believe) is analogous to the Android's prevent_suspend_time
>   statistics.  Nothing really special, but I didn't want
>   wakeup_source_activate/deactivate() to take a common lock to avoid
>   congestion.
> 
> [8/8] - This adds a user space interface to create, activate and deactivate
>   wakeup sources.  Since the files it consists of are called wake_lock and
>   wake_unlock, to follow Android, the objects the wakeup sources are wrapped
>   into are called "wakelocks" (for added confusion).  Since the interface
>   doesn't provide any means to destroy those "wakelocks", I added a garbage
>   collection mechanism to get rid of the unused ones, if any.  I also tought
>   it might be a good idea to put a limit on the number of those things that
>   user space can operate simultaneously, so I did that too.
> 
> All in all, it's not as much code as I thought it would be and it seems to be
> relatively simple (which rises the question why the Android people didn't
> even _try_ to do something like this instead of slapping the "real" wakelocks
> onto the kernel FWIW).  IMHO it doesn't add anything really new to the kernel,
> except for the user space interfaces that should be maintainable.  At least I
> think I should be able to maintain them. :-)
> 
> All of the above has been tested very briefly on my test-bed Mackerel board
> and it quite obviously requires more thorough testing, but first I need to know
> if it makes sense to spend any more time on it.
> 
> IOW, I need to know your opinions!
my opinion is "sigh".

FWIW we need to bring Android wakelocks into the main line so we can fix
them WRT wake event notification handling.  But, I'll have to take a
look at the patches to see if I still have heart burn over the race
between wake sources and wake lock dropping in kernel mode.

/me goes and looks now....

--mark

> 
> Thanks,
> Rafael
> 
