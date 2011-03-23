Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275Ab1CWXhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 19:37:25 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:38182 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933061Ab1CWXhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 19:37:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkUEAHMhik15LK5JgWdsb2JhbACEQ6EBFQEBFiYliE2qGZB3DYEag0t3BA
Date: Thu, 24 Mar 2011 10:36:48 +1100
From: Dave Chinner <david@fromorbit.com>
To: sedat.dilek@gmail.com
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: vfs: inode lock breakup
Message-ID: <20110323233647.GG26611@dastard>
References: <1300793023-3775-1-git-send-email-david@fromorbit.com>
 <AANLkTimi97y2=t8srkgOpfjt7WF5ZroR_W=0mGpEgE96@mail.gmail.com>
 <20110323062939.GJ15270@dastard>
 <AANLkTikyFVRuXMvnvSqgcQacJVAZtSXq+CgXowDOw2pL@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikyFVRuXMvnvSqgcQacJVAZtSXq+CgXowDOw2pL@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 08:53:19AM +0100, Sedat Dilek wrote:
> On Wed, Mar 23, 2011 at 7:29 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Tue, Mar 22, 2011 at 07:17:04PM +0100, Sedat Dilek wrote:
> >> On Tue, Mar 22, 2011 at 12:23 PM, Dave Chinner <david@fromorbit.com> wrote:
> >> > Hi Al,
> >> >
> >> > The following patches are the inode_lock breakup series originally
> >> > derived from Nick Piggin's vfs-scale tree. I've kind of been sitting
> >> > on them until the dcache_lock breakup and rcu path-walk has had some
> >> > time to be shaken out. The patch ѕet is pretty much unchanged from
> >> > the last round of review last last year - all I've done to bring it
> >> > up to date is forward port it and run it through some testing on XFS
> >> > and ext4.
> >> >
> >> > I know it's late in the .39 merge window, but I hope you'll consider
> >> > it if the patches are still acceptable(*). Otherwise I'm happy to take
> >> > the time to get it right for .40.
> >> >
> >> > Cheers,
> >> >
> >> > Dave.
> >> >
> >> > (*) The series can also be found here:
> >> >
> >> >  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev.git inode-scale
> >> >
> >> > Dave Chinner (8):
> >> >      fs: protect inode->i_state with inode->i_lock
> >> >      fs: factor inode disposal
> >> >      fs: Lock the inode LRU list separately
> >> >      fs: remove inode_lock from iput_final and prune_icache
> >> >      fs: move i_sb_list out from under inode_lock
> >> >      fs: move i_wb_list out from under inode_lock
> >> >      fs: rename inode_lock to inode_hash_lock
> >> >      fs: pull inode->i_lock up out of writeback_single_inode
> >> >
> >> [...]
> >>
> >> Hi,
> >>
> >> I have tested this patch-series on top of linux-next (next-20110322)
> >> by running xfstests-dev (built from git).
> >>
> >> My sdb2 partition (on an external 1GBytes USB-2.0 hdd) was formatted
> >> and mounted as ext4-fs .
> >
> > If you really want to use xfstests to produce some system stress,
> > you'd do better to use an XFS filesystem ;)
> >
> 
> First, I was riddling why I could not install xfstests-dev to an
> individual $PREFIX and waste(?) some time into looking into the
> configure* files - dbtest.c failed building by not setting correct
> $libgdbm (normal build via make is OK).
> Then I saw the hardcoded /var/lib/ as INSTALL_PATH... and didn't
> wanted dig deeper.
> I overflew the README, but that file needs a bit of more hints.

xfstests has never really been packaged as a standaone package, so
the build/configure system is a bit grotesque in places. It kind of
assumes that you've already installed everything you need manually
on your test box.

If someone wants to fix that all up so it can be packaged as .rpm
and .deb packages with aal the correct dependencies, then patches
are welcome...

> I can do some XFS testing if you wish.

No big deal, I was just pointing out that ext4 coverage of the test
suite is limited compared to the XFS coverage...

> The numbers in the result say nothing to me as I can't compare them
> with other systems.
> It's like putting the hand in a glass of water and wild speculating
> the temperature.
> You can say cold or warm if you have a 2nd glass with different temperature.
> 
> So, it might be worth to add a file (name: benchmark.txt?) with some results?

I don't see any real point - the output is pass/fail for each test
with and inidcation of the failure. If you want to dig deeperr into
the failures, it points at where to look.

> >> The check-log is attached (not sure how to interpret the errors and failures).
> >
> > Nothing indicates an unknown failure...
> >
> >> 001 5s ... 4s
> >> 002 1s ... 1s
> >> 003    [not run] not suitable for this filesystem type: ext4
> >> 004    [not run] not suitable for this filesystem type: ext4
> >> 005    - output mismatch (see 005.out.bad)
> >> --- 005.out   2011-03-22 17:47:03.861226933 +0100
> >> +++ 005.out.bad       2011-03-22 18:47:58.847277538 +0100
> >> @@ -1,7 +1,7 @@
> >>  QA output created by 005
> >>  *** touch deep symlinks
> >>
> >> -ELOOP returned.  Good.
> >> +No ELOOP?  Unexpected!
> >>
> >>  *** touch recusive symlinks
> >
> > This is a result of Al fixing the max nested loop depth very early
> > on in .39, so the test needs to run to deeper nesting depths to
> > produce ELOOP. So it's a test problem, not a bug.
> >
> >> 197    [not run] not suitable for this filesystem type: ext4
> >> 198    [failed, exit status 127] - output mismatch (see 198.out.bad)
> >> --- 198.out   2011-03-22 17:47:03.917226229 +0100
> >> +++ 198.out.bad       2011-03-22 19:04:12.591035920 +0100
> >> @@ -1,2 +1,3 @@
> >>  QA output created by 198
> >>  Silence is golden.
> >> +./198: line 54: /home/sd/src/xfstests-dev/xfstests-dev/src/aio-dio-regress/aiodio_sparse2: No such file or directory
> >
> > You need to install libaio and friends so that the binary is
> > built. We probably need to add a "requires_aio" test option to
> > detect this situation and not_run the test gracefully.
> >
> 
> Yupp, the build-/configure-system could be enhanced in that case.
> (I add "Notes to myself" see my P.S. to remember what I did and what I missed.)

Well, it's not a configure system issue - it's that the test itself
doesn't correctly detect what was built.....

> BTW, are changes/updates to xfstests-dev announced somewhere (like ML)?

The XFS mailing list (xfs@oss.sgi.com) is used for development and
release announcements. And there's usually information in
Christoph's monthly XFS summary that he posts to -fsdevel and LKML.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
