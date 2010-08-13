Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934607Ab0HMQU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 12:20:57 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:37400 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761746Ab0HMQU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 12:20:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=J2vR5VXJftrQKrEyxgBSR6mWIHqAjk1y+xzrxrjbcMqHWuox+0/nz4feOf0QnsEB0+lGP+7QaoeJ8R3w4I4JLY+0QGzOmnkuf0UKlEf5DLp5gqg21JcHUFLpnRmOLTjM;
Date: Fri, 13 Aug 2010 09:20:20 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Brian Swetland <swetland@google.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        "Ted Ts'o" <tytso@mit.edu>, Alan Stern <stern@rowland.harvard.edu>,
        paulmck@linux.vnet.ibm.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        david@lang.hm, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, arve@android.com, mjg59@srcf.ucam.org,
        pavel@ucw.cz, florian@mickler.org, peterz@infradead.org,
        tglx@linutronix.de, menage@google.com, david-b@pacbell.net,
        James.Bottomley@suse.de, arjan@infradead.org, swmike@swm.pp.se,
        galibert@pobox.com, dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100813092020.41290f1f@virtuousgeek.org>
In-Reply-To: <201008130528.21887.rjw@sisk.pl>
References: <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
	<AANLkTimjfU2zu4reEVdOwWwtFHPQ33_Gna6xS2XHRG-h@mail.gmail.com>
	<20100812125712.48b7fc26@virtuousgeek.org>
	<201008130528.21887.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Aug 2010 05:28:21 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Thursday, August 12, 2010, Jesse Barnes wrote:
> > On Thu, 12 Aug 2010 12:19:34 -0700
> > Brian Swetland <swetland@google.com> wrote:
> > > Question though -- has every feature ever added to the kernel been a
> > > feature that there's pre-existing usage of?  Seems like a chicken and
> > > egg problem.  Also, some people seem to think there's value in being
> > > able to build kernels "out of the box" that work with the Android
> > > userspace -- given that there are a few devices out there that have
> > > that userspace on 'em.
> > 
> > We generally try to merge new features like this along with code that
> > uses said feature, but there are always exceptions.  We've merged code
> > one release or more before the new code gets used for example, which is
> > fine IMO.  What we don't want to see is some new drop of code added and
> > abandoned, but you already knew that.
> > 
> > At any rate, if Felipe is the only one arguing against including
> > suspend blockers in the kernel, you're probably in good shape.  Based
> > on my (rather cursory I admit) evaluation of this thread, it seems like
> > reasonable people agree that there's a place for a suspend blocker like
> > API in the kernel, and that dynamic power management is also highly
> > desirable.  So where's the git pull request already? :)
> 
> In fact my patch going in that direction has been merged already and that
> code will likely be extended to cover some needs and cases I didn't have in
> mind when I was preparing it.

Yeah, I like what you've done with dynamic power management, really
good stuff (the approach is very similar to the one I used for vblank
interrupt management in the drm layer).

Ted's point about providing the user with a way of knowing which apps
are blocking things is a good one though, and doesn't seem too hard to
add.  It might even be possible to do it largely with scripts wrapping
fuser and such.

> However, having discussed the whole issue for many times and reconsidered it
> thoroughly, I think that it's inappropriate to identify the suspend blockers
> (or wakelocks) framework with the opportunistic suspend feature as proposed in
> the original submission of the "suspend blockers" patchset.  IMO they really
> are not the same thing and while the suspend blockers framework is used by
> Android to implement opportunistic suspend, I don't really believe this is the
> right approach.
> 
> We really need something similar to suspend blockers to avoid races between
> a suspend process and wakeup events, but it isn't necessary to provide user
> space with an interface allowing it to use these things directly.  Such an
> interface is only necessary in the specific implementation in which the system
> is suspended as soon as the number of "active" suspend blockers goes down to
> zero.  Arguably, though, this isn't the only possible way to implement a
> mechanism allowing the system to be suspended automatically when it appears
> to be inactive.
> 
> Namely, one can use a user space power manager for this purpose and actually
> the OLPC project has been doing that successfully for some time, which clearly
> demonstrates that the Android approach to this problem is not the only one
> possible.  Moreover, the kernel's system suspend (or hibernate for that matter)
> code has not been designed to be started from within the kernel.  It's been
> designed to allow a privileged user space process to request the kernel to
> put the system into a sleep state at any given time regardless of what the
> other user space processes are doing.  While it can be started from within the
> kernel, this isn't particularly nice and, in the Android case, starting it from
> within the kernel requires permission from multiple user space processes
> (given by not taking suspend blockers these processes are allowed to use).

Yes, I see your point.  But I actually think this is a fairly minor
distinction.  In one case, a privileged app decides when to suspend the
system, in the other case, one or more of several privileged apps
decide when a suspend should not be allowed to occur.  It's just a
matter of where you want to put the code and where you want the
complexity.  In general, we try to keep such complexity out of the
kernel, but not always; there are compelling cases for putting
complexity in the kernel to provide uniformity and flexibility (e.g.
application state save/restore vs. system-wide checkpoints, the former
preserves the "if it can be done outside the kernel, it should be",
while the latter provides much greater flexibility and avoids the need
to port applications to potentially incompatible or unportable state
saves/restore libraries).

-- 
Jesse Barnes, Intel Open Source Technology Center
