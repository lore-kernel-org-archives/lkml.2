Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab0DNOt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 10:49:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755898Ab0DNOtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 10:49:55 -0400
Date: Wed, 14 Apr 2010 07:46:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tobias <mailing54@plzk.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.34-rc4
In-Reply-To: <4BC57F10.8080002@plzk.org>
Message-ID: <alpine.LFD.2.00.1004140733310.15116@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004121859480.3647@i5.linux-foundation.org> <4BC57F10.8080002@plzk.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Apr 2010, Tobias wrote:
> 
> -rc4 does not boot on my MacBook v2.1. Unfortunately, I can not add much info
> on what happens since it's all happening really fast. Last thing I can really
> see is that KMS takes over (?), outputs a few lines which look ok, last line
> being something about ata. Here the boot stops.
> 
> Before the switch to KMS I can briefly see something what's probably a
> stacktrace, like < ?blabla >. Only words I could recognize were "?acpi" and
> "mutex".
> 
> Config is from make localyesconfig, based on rc3 which is running fine (beside
> the occasional flickering/screen corruption drm/i915 seems to be famous for ;)
> ).
> 
> Please excuse layman's terms and let me know if I there is anything I can do
> to produce a helpful error message.

The absolutely most helpful thing you could do (and it really isn't that 
complex, just somewhat time-consuming) is to do a "git bisect" to figure 
out exactly where it started.

"git bisect" is really simple to run, and since you know a start-point and 
an end-point, and they aren't even all _that_ far away from each other, 
it's going to be reasonably quick.

The fact that you have tested only -rc release kernels makes me suspect 
you aren't a git user, but don't worry, it's really quite easy. 

Just make sure you have git installed (most distros have it, so a "yum 
install git-core" or something like that should do it), and then do

	# get the kernel repo
	git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
	cd linux-2.6

	# start bisecting
	git bisect start
	git bisect good v2.6.34-rc3
	git bisect bad v2.6.34-rc4

and git will look at the good/bad pair you told it, and try to find a 
mid-point between the two. It will say something like this:

	Bisecting: 288 revisions left to test after this (roughly 8 steps)
	[14e71e4fb94c340273534a6d7f210aa82a3ca717] Merge git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog

which just means that there were roughly 2*288=576 commits (584 to be 
exact - since history isn't linear, it couldn't find an _exact_ mid-point) 
between -rc3 and -rc4, and it has checked out a midpoint for you to try.

Now, just compile that kernel version, install it, and try to boot it.

If it works, you tell git so with "git bisect good" and it will pick a new 
kernel for you to test (now half-way between that _new_ good kernel and 
the bad kernel). And if it _doesn't_ work, just tell git so with "git 
bisect bad", and it will pick another kernel for you to test.

You'll end up having to test maybe nine or ten kernels, but then git will 
tell you exactly which commit caused your problem.

Alternatively, if you find the process really tedious (I admit that it is 
tedious, but the nice thing is that it's straightforward and doesn't 
require you to know what the bug is) and don't have the time or energy to 
test nine or ten kernels, if you can do a bisect of even just four or five 
kernels and then post the resulting ".git/BISECT_LOG" file, that will 
already help a lot. It will narrow down the 584 commits down to just a 
fraction (if you test 5 bisect-points, it should narrow it down to roughly 
~20 commits or so: each bisect point roughly splits the thing in half).

			Linus
