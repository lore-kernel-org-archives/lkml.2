Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab2GASqK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:46:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35037 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab2GASqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:46:08 -0400
Date: Sun, 1 Jul 2012 11:45:37 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Zdenek Kabelac <zkabelac@redhat.com>
cc: Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>,
        Joe Thornber <ejt@redhat.com>,
        LVM general discussion and development 
	<linux-lvm@redhat.com>,
        amwang@redhat.com, Alasdair G Kergon <agk@redhat.com>,
        linux-kernel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
Subject: Re: Regression with FALLOC_FL_PUNCH_HOLE in 3.5-rc kernel
In-Reply-To: <4FF04950.30503@redhat.com>
Message-ID: <alpine.LSU.2.00.1207011112250.1799@eggly.anvils>
References: <4FEEE5E5.5060800@redhat.com> <alpine.LSU.2.00.1206301217590.1728@eggly.anvils> <4FEF66C4.20001@redhat.com> <alpine.LSU.2.00.1206301541280.1919@eggly.anvils> <4FF04950.30503@redhat.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jul 2012, Zdenek Kabelac wrote:
> Dne 1.7.2012 01:10, Hugh Dickins napsal(a):
> > On Sat, 30 Jun 2012, Zdenek Kabelac wrote:
> > > Dne 30.6.2012 21:55, Hugh Dickins napsal(a):
> > > > On Sat, 30 Jun 2012, Zdenek Kabelac wrote:
> > > > > 
> > > > > When I've used 3.5-rc kernels - I've noticed kernel deadlocks.
> > > > > Ooops log included. After some experimenting - reliable way to hit
> > > > > this
> > > > > oops
> > > > > is to run lvm test suite for 10 minutes. Since 3.5 merge window does
> > > > > not
> > > > > included anything related to this oops I've went for bisect.
> > > > 
> > > > Thanks a lot for reporting, and going to such effort to find
> > > > a reproducible testcase that you could bisect on.
> > > > 
> > > > > 
> > > > > Game result is commit: 3f31d07571eeea18a7d34db9af21d2285b807a17
> > > > > 
> > > > > mm/fs: route MADV_REMOVE to FALLOC_FL_PUNCH_HOLE
> > > > 
> > > > But this leaves me very puzzled.
> > > > 
> > > > Is the "lvm test suite" what I find at
> > > > git.fedorahosted.org/git/lvm2.git
> > > > under tests/ ?
> > > 
> > > Yes - that's it -
> > > 
> > >   make
> > > as root:
> > >   cd test
> > >   make check_local
> > > 
> > > (inside test subdirectory should be enough, if not - just report any
> > > problem)
> > > 
> > > > If you have something else running at the same time, which happens to
> > > > use
> > > > madvise(,,MADV_REMOVE) on a filesystem which the commit above now
> > > > enables
> > > > it on (I guess ext4 from the =y in your config), then I suppose we
> > > > should
> > > > start searching for improper memory freeing or scribbling in its
> > > > holepunch
> > > > support: something that might be corrupting the dm_region in your oops.
> > > 
> > > What the test is doing - it creates file in  LVM_TEST_DIR (default is
> > > /tmp)

I ran "LVM_TEST_DIR=/tmp make check_local":
without that it appeared to be using a subdirectory made under test/.

And being a year or two out of date in my userspace, and unfamiliar with
the syntax and whereabouts of lvm.conf, it was easiest for me to hack
lib/config/defaults.h to #define DEFAULT_ISSUE_DISCARDS 1
after I spotted a warning message about issue_discards.

> > > and using loop device to simulate device (small size - it should fit
> > > bellow
> > > 200MB)
> > > 
> > > Within this file second layer through virtual DM devices is created and
> > > simulates various numbers of PV devices to play with.
> > 
> > This sounds much easier to set up than I was expecting:
> > thanks for the info, I'll try it later on today.

Sorry, I never reached it yesterday, but arrived there this morning.

> > 
> > > 
> > > So since everything now support TRIM - such operations should be passed
> > > down to the backend file - which probably triggers the path.
> > 
> > What filesystem do you have for /tmp?

>From your later remarks, I inferred tmpfs.

> > 
> > If tmpfs, then it will make much more sense if we assume your bisection
> > endpoint was off by one.  Your bisection log was not quite complete;
> > and even if it did appear to converge on the commit you cite, you might
> > have got (un)lucky when testing the commit before it, and concluded
> > "good" when more attempts would have said "bad".
> > 
> > The commit before, 83e4fa9c16e4af7122e31be3eca5d57881d236fe
> > "tmpfs: support fallocate FALLOC_FL_PUNCH_HOLE", would be a
> > much more likely first bad commit if your /tmp is on tmpfs:
> > that does indeed wire up loop to pass TRIM down to tmpfs by
> > fallocate - that indeed played a part in my own testing.
> > 
> > Whereas if your /tmp is on ext4, loop has been passing TRIM down
> > with fallocate since v3.0.  And whichever, madvise(,,MADV_REMOVE)
> > should be completely irrelevant.
> 
> While I've been aware of the fact that tmpfs was enhanced with trim support -
> I've not tried to run on real ext4 filesystem since for my tests I'm using
> tmpfs for quite some time to safe rewrites of SSD :)
> 
> So now I've checked with real ext4 - and the bug is there as well
> so I've went back - it crashes on 3.4, 3.3 and 3.2 as well.
> 
> 3.1 is the first kernel which does survive (checked 5 repeated runs)

Very useful research, thank you.

> 
> And you are correct, the first commit which causes crash really is
> 83e4fa9c16e4af  when I use  tmpfs as backend storage - the problem why I've
> missed to properly identify this commit in my bisect is that crash usually
> happens on the second pass of the lvm test suite 'make check_local' execution
> - and I've been running test just once. To be sure I've run 5 run passes on
> 3.4.0-08568-gec9516f - which is OK, but 3.4.0-08569-g83e4fa9 is crashing
> usually on second run, with commit 3f31d07571e  the crash always happens in
> the first pass.
> 
> I've also checked some rawhide kernel vmlinuz-3.5.0-0.rc2.git0.1.fc18.x86_64
> and it's crashing as well - so it's probably not uniqueness of my config.
> 
> So is there any primary suspect in 3.2 which is worth to check - or I need
> another day to play another bisect game ?

No need for a further bisect: 3.2 is when the disard/trim/fallocate
support went into drivers/block/loop.c, so these tests would be unable
to show if DM was right or wrong before then.

> 
> > 
> > > 
> > > > I'll be surprised if that is the case, but it's something that you can
> > > > easily check by inserting a WARN_ON(1) in mm/madvise.c
> > > > madvise_remove():
> > > > that should tell us what process is using it.
> > > 
> > > I could try that if that will help.
> > 
> > That would help, if you're very sure of your bisection endpoint;
> > but if your /tmp is on tmpfs, then I do think it's more likely
> > that you've actually found a bug in the commit before.
> 
> the only thing which could be tricky is  udev support
> (by default it's not enabled ---enable-udev_sync)
> However Debian based distros are distributing their own rules, which are not
> 100% compatible with upstream and create some unpredictable issues,
> where the slowness is the least problem.)
> 
> If you have Fedora Rawhide with latest lvm2 installed - you should get pretty
> well configured system for running test dir   (unfortunately there is no way
> to virtualize udev...)

I don't have Fedora Rawhide on, but after hacking ISSUE_DISCARDS
I did quickly crash around where you expected; though in my case
it was in dm_rh_dec() called from mirror_end_io().

But I've not taken it any further than that.  You've shown that it's
as much a problem with ext4 as with tmpfs, and has been a problem
ever since these tests' use of discard reached DM.

I think it's fair to assume that there's something wrong with DM's
handling of REQ_DISCARD.  (Perhaps it was all correct when written,
but I think there has been a series of modifications to REQ_DISCARD
handling in the block layer, it's been rather troublesome.)

I've added a few people to the Cc, innocents fingered by git blame
on some REQ_DISCARD lines in drivers/md.  But I'll back out myself:
I'm not short of other things to look at, and have little to offer
in drivers/md.

Hugh
