Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab1DUSvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 14:51:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50923 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381Ab1DUSvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 14:51:15 -0400
Date: Thu, 21 Apr 2011 20:51:13 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jens Axboe <JAxboe@fusionio.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39-rc4 BUG: unable to handle kernel NULL pointer dereference
 at 0000000c IP: cfq_insert_request+0x1d/0x3f5
Message-ID: <20110421185112.GA4796@tiehlicka.suse.cz>
References: <20110420125824.GA3507@tiehlicka.suse.cz>
 <4DAEDBEB.7060904@fusionio.com>
 <20110420132903.GA13554@tiehlicka.suse.cz>
 <4DAF18DF.9080205@fusionio.com>
 <20110421071642.GA3556@tiehlicka.suse.cz>
 <5F35AAD2-8277-44BD-86B6-B1D7B816071E@kernel.dk>
 <BANLkTinYv+YW6HVCodsWcCKwMmdZFsXPRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinYv+YW6HVCodsWcCKwMmdZFsXPRA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 21-04-11 07:38:57, Linus Torvalds wrote:
> On Thu, Apr 21, 2011 at 12:25 AM, Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> I am going to bisect, let's see if I can find anything.
> >
> > Thanks, that would be great!
> 
> I'd expect it to be very timing-dependent, and thus could easily be
> triggered (or hidden) by unrelated changes.
> 
> Just happening to have a request added to the elevator at _just_ the
> same moment that another CPU is changing it and getting rid of the
> data structures for the old one.

And it really looks like a timing issue. I have bisected down to
e710d7d5a9cab1041b7a3cf9e655b75d92786857. I had to skip[1] some commits
due to compile errors [2].
At first it looked quite promising because I was able to boot after I
reverted that patch but then I have tried to revert it on top of rc4
(2f666bcf757cb72549f360ef6da02f03620a48b6) and saw the same problem
again.

So I do not think that bisecting will help here.

---
[1] git bisect log
git bisect start
# bad: [2f666bcf757cb72549f360ef6da02f03620a48b6] Merge branch 'drm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6
git bisect bad 2f666bcf757cb72549f360ef6da02f03620a48b6
# good: [a6360dd37e1a144ed11e6548371bade559a1e4df] Linux 2.6.39-rc3
git bisect good a6360dd37e1a144ed11e6548371bade559a1e4df
# bad: [fdfc552abe2c465ab91b84fb65f36d86c6737ab4] Merge branches 'core-fixes-for-linus', 'perf-fixes-for-linus', 'sched-fixes-for-linus', 'timer-fixes-for-linus' and 'x86-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect bad fdfc552abe2c465ab91b84fb65f36d86c6737ab4
# bad: [01eda2e0c0cf035308308a19581e4979285b51ec] kstrtox: fix compile warnings in test
git bisect bad 01eda2e0c0cf035308308a19581e4979285b51ec
# bad: [aaa119a3d4e0b7421c82ae3fbe288e65d0f3485f] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6
git bisect bad aaa119a3d4e0b7421c82ae3fbe288e65d0f3485f
# bad: [d77d9597ad8f2bd381a5168005a21e82df6f18eb] Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86
git bisect bad d77d9597ad8f2bd381a5168005a21e82df6f18eb
# good: [08a0799d5736f1494ef35d386570d177447acbfb] acer-wmi: Fix capitalisation of GUID in module alias
git bisect good 08a0799d5736f1494ef35d386570d177447acbfb
# skip: [be85bccaa5aa5a11dcaf85f9e945ffefd253f631] Revert "vfs: Export file system uuid via /proc/<pid>/mountinfo"
git bisect skip be85bccaa5aa5a11dcaf85f9e945ffefd253f631
# skip: [95042f9eb78a8d9a17455e2ef263f2f310ecef15] vm: fix mlock() on stack guard page
git bisect skip 95042f9eb78a8d9a17455e2ef263f2f310ecef15
# bad: [0bba01695b74fdd2f9286243bb39f88544d81401] vfs: Re-introduce s_uuid in the superblock
git bisect bad 0bba01695b74fdd2f9286243bb39f88544d81401
# good: [16ad56972ca3161eb97583897f17c1ead0c4ebd0] Merge branch 'stable/bug-fixes-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen
git bisect good 16ad56972ca3161eb97583897f17c1ead0c4ebd0
# skip: [0d88f6e804c824454b5ed0d3034ed3dcf7467a87] nfs: don't call __mark_inode_dirty while holding i_lock
git bisect skip 0d88f6e804c824454b5ed0d3034ed3dcf7467a87
# skip: [e328f05dd6c528fcc9eb6da157dd865dfe611352] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6
git bisect skip e328f05dd6c528fcc9eb6da157dd865dfe611352
# bad: [e710d7d5a9cab1041b7a3cf9e655b75d92786857] mfd: Fetch cell pointer from platform_device->mfd_cell
git bisect bad e710d7d5a9cab1041b7a3cf9e655b75d92786857

[2] 
fs/ext3/super.c: In function 'ext3_fill_super':
fs/ext3/super.c:1946:2: error: 'struct super_block' has no member named 's_uuid'
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
