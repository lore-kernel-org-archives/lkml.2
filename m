Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab0LQVCJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 16:02:09 -0500
Received: from cantor.suse.de ([195.135.220.2]:42880 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755351Ab0LQVCH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 16:02:07 -0500
Date: Sat, 18 Dec 2010 08:01:58 +1100
From: Neil Brown <neilb@suse.de>
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: reproducer for DM on MD flush deadlock? (was: Re: [PULL
 REQUEST] md bug fixes)
Message-ID: <20101218080158.58e17c21@notabene.brown>
In-Reply-To: <AANLkTi=H3-GrEZVWzmHyHvyx93HU6x=t_n6TBqCiEwxX@mail.gmail.com>
References: <AANLkTi=H3-GrEZVWzmHyHvyx93HU6x=t_n6TBqCiEwxX@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Dec 2010 13:13:47 -0500 Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, Dec 14, 2010 at 2:22 AM, Neil Brown <neilb@suse.de> wrote:
> >
> >
> > Hi Linus,
> >  here are a few bug fixes for md.
> >  Some of the patches are actually clean-up rather than bug-fix,
> >  but I that make the bugfix simpler to review.
> >
> > Thanks,
> > NeilBrown
> >
> >
> > The following changes since commit 6313e3c21743cc88bb5bd8aa72948ee1e83937b6:
> >
> >  Merge branches 'x86-fixes-for-linus', 'perf-fixes-for-linus' and 'sched-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2010-12-08 06:40:59 -0800)
> >
> > are available in the git repository at:
> >
> >  git://neil.brown.name/md/ for-linus
> >
> > NeilBrown (5):
> >      md: remove handling of flush_pending in md_submit_flush_data
> >      md: move code in to submit_flushes.
> >      md: fix possible deadlock in handling flush requests.
> 
> Hi Neil,
> 
> Thanks for fixing this DM on MD flush issue.  But my attempts to
> reproduce it have been unsuccessful.
> 
> I've tried ext4 w/ barriers to a DM device above a 2 member MD RAID1.
> The DM device has a table with 2 linear targets to the same md0
> device:
> 
> # dmsetup table
> multiple_targets: 0 24576 linear 9:0 2048
> multiple_targets: 24576 49152 linear 9:0 26624
> 
> No amount of IO with flushes has enabled me to hit a deadlock (in
> md_flush_request,  md_write_start, etc).
> 
> Do you have a simple reproducer for this issue?

No.  I think the issue is very sensitive to the exact placement of the border
between the two dm targets.  You need to be able to produce a flush request
that crosses that border.

So to reproduce it I would:

 Create an ext4 filesystem of some known size.
 Impose some simple easily reproducible load and use e.g. blktrace to gets a
 log of the flush requests.
 Choose on such request that is larger than a sector and note it's location
 Create a DM device of the same size with two targets on md devices where the
 first target ends in the middle of where the flush request was
 Repeat the above sequence on the dm device.  That should result in a flush
 request overlapping both targets and thus triggering the issue.

NeilBrown
