Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab0JCTrd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 15:47:33 -0400
Received: from mail.agmk.net ([91.192.224.71]:46627 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707Ab0JCTrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 15:47:32 -0400
From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
To: Valdis.Kletnieks@vt.edu
Subject: Re: git bisect selects commit outside initial bisect range?
Date: Sun, 3 Oct 2010 21:47:23 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35.6-1; KDE/4.5.1; x86_64; ; )
Cc: Andreas Schwab <schwab@linux-m68k.org>, linux-kernel@vger.kernel.org
References: <201009272051.33882.pluto@agmk.net> <m2fwwv7wx2.fsf@igel.home> <32106.1285624307@localhost>
In-Reply-To: <32106.1285624307@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201010032147.24197.pluto@agmk.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 September 2010 23:51:47 Valdis.Kletnieks@vt.edu wrote:
> On Mon, 27 Sep 2010 22:29:13 +0200, Andreas Schwab said:
> > PaweÅ Sikora <pluto@agmk.net> writes:
> > 
> > > i've started git bisect between good-v2.6.34 and bad-v2.6.35-rc1
> > > and after few steps git-bisect jumps to commit before v2.6.34.
> > >
> > > [~/src/linux/linux-2.6]$ make kernelrelease
> > > 2.6.34-rc6-00551-g7a6cb0d
> > >
> > > is it normal that bisect selects next step outside initial range?
> > 
> > It's not outside the range:
> > 
> > $ git rev-list v2.6.34..v2.6.35-rc1 | grep ^7a6cb0d
> > 7a6cb0d5497418599d2125b670926b75e673861c
> > 
> > 7a6cb0d is a commit in a branch reachable from v2.6.35-rc1 but not from
> > v2.6.34.
> 
> I think he was confused because that commit is in an section of the tree
> that was committed to a maintainer tree before 2.6.34 - so when he boots
> the resulting kernel it says 2.6.33-rc3-mumble or similar.  I know it threw
> me for a loop the first few times it happened.
> 
> Pawel: What's happened is you're looking at a commit that got into a maintainer
> tree *before* 2.6.34 came out (so the top-level Makefile *at that time in that
> tree* said 2.6.33-mumble or something), but the maintainer fed it into Linus's
> tree in the merge window *after* 2.6.34 shipped.  Yes, it's bizarre, but that's
> how git deals with it.  If you look at the graph produced by 'git bisect
> visualize' it makes a bit more sense.

thank you very much for explanation!

now i have more complicated problem with bisecting :(
on v2.6.34 kernel kde4 compositing effects works fine on my radeon RV370.
on v2.6.35 i'm observing some blinking during effects composition.

with git-bisect i found some bad (in case of screen blinkng) commit:

[http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=59534f
 Merge branch 'drm-for-2.6.35' of git://git.kernel.org/pub/scm/linux/kernel/git...]

and earlier branches with good commits:

[http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=ac3ee8
 Merge branch 'dbg-early-merge' of git://git.kernel.org/pub/scm/linux/kernel/git/jwes]

[http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=a7c542
 drm/i915: Fix out of tree builds]

[http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=61dd98
 drm/edid: Fix 1024x768@85Hz]

right after ^61dd98 there is a small change:

[http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=bc35af
 drm/radeon/kms: add query for crtc hw id from crtc id to get info V2]

which causes xserver hangup (100% cpu-hog) on my machine and after this point
i can't really test another git-bisect commit due to xserver hangup.
can i somehow kick-off the ^61dd98 commit from further bisecting to avoid bug masking?

BR,
Pawel.
