Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab0FCHBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 03:01:30 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57538 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab0FCHB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 03:01:28 -0400
Date: Thu, 3 Jun 2010 09:01:26 +0200
From: Jens Axboe <jaxboe@fusionio.com>
To: "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
Message-ID: <20100603070126.GJ3564@kernel.dk>
References: <20100524070552.GR23411@kernel.dk> <AANLkTikogQtGpO9c94A7YSmP8zdyM8dZBrwJf1nwlR4j@mail.gmail.com> <20100524173551.GU23411@kernel.dk> <AANLkTimDJjHWKISxnLax3r200Db8OQp_lMKOx14ONgkS@mail.gmail.com> <20100524175649.GV23411@kernel.dk> <AANLkTim_yrRZG6v1tMPgefeaaI-nUa35Q-mLQpuXWJ1p@mail.gmail.com> <20100601074534.GL1660@kernel.dk> <AANLkTinGfonivZvofBkMzv53IJZeKbFAEMVpv96BiJ30@mail.gmail.com> <20100603061039.GD3564@kernel.dk> <AANLkTint7OJvmTn7d7bqTJzsCxV-VlVT46PQWVH-m73g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTint7OJvmTn7d7bqTJzsCxV-VlVT46PQWVH-m73g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03 2010, Michael Kerrisk wrote:
> Hi Jens,
> 
> On Thu, Jun 3, 2010 at 8:10 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
> > On Wed, Jun 02 2010, Michael Kerrisk wrote:
> >> On Tue, Jun 1, 2010 at 9:45 AM, Jens Axboe <axboe@kernel.dk> wrote:
> >> > On Thu, May 27 2010, Michael Kerrisk wrote:
> >> >> Jens,
> >> >>
> >> >> On Mon, May 24, 2010 at 7:56 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> >> >> > On Mon, May 24 2010, Michael Kerrisk wrote:
> >> >> >> On Mon, May 24, 2010 at 7:35 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> >> >> >> > On Mon, May 24 2010, Michael Kerrisk wrote:
> >> >> >> >> > Right, that looks like a thinko.
> >> >> >> >> >
> >> >> >> >> > I'll submit a patch changing it to bytes and the agreed API and fix this
> >> >> >> >> > -Eerror. Thanks for your comments and suggestions!
> >> >> >> >>
> >> >> >> >> Thanks. And of course you are welcome. (Please CC linux-api@vger on
> >> >> >> >> this patche (and all patches that change the API/ABI.)
> >> >> >> >
> >> >> >> > The first change is this:
> >> >> >> >
> >> >> >> > http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=0191f8697bbdfefcd36e7b8dc3eeddfe82893e4b
> >> >> >> >
> >> >> >> > and the one dealing with the pages vs bytes API is this:
> >> >> >> >
> >> >> >> > http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=b9598db3401282bb27b4aef77e3eee12015f7f29
> >> >> >> >
> >> >> >> > Not tested yet, will do so before sending in of course.
> >> >> >>
> >> >> >> Eyeballing it quickly, these changes look right.
> >> >> >
> >> >> > Good, thanks.
> >> >> >
> >> >> >> Do you have some test programs you can make available?
> >> >> >
> >> >> > Actually I don't, I test it by modifying fio's splice engine to set/get
> >> >> > the pipe size and test the resulting transfers.
> >> >>
> >> >> An afterthought. Do there not also need to be fixes to the /proc
> >> >> interfaces. I don't think they were included in your revised patches.
> >> >
> >> > I think the proc part can be sanely left in pages, since it's just a
> >> > memory limiter.
> >>
> >> I can't see any advantage to using two different units for these
> >> closely related APIs, and it does seem like it could be a source of
> >> confusion. Similar APIs that I can think of like RLIMIT_MEMLOCK and
> >> shmget() SHMMAX that impose per-process memory-related limits use
> >> bytes. Best to be consistent, don't you think?
> >
> > But they are different interfaces.  I think the 'pass in required size,
> > return actual size' where actual size is >= required size makes sense
> > for the syscall part, but for an "admin" interface it is more logical to
> > deal in pages. Perhaps that's just me and the average admin does not
> > agree. So while it's just detail, it's also an interface so has some
> > importance. And if there's consensus that bytes is a cleaner interface
> > on the proc side as well, then lets change it.
> 
> I'll add one more datapoint to those that I already mentioned.
> RLIMIT_STACK and RLIMIT_DATA (getrlimit()) is also expressed in bytes.
> 
> There was only one vaguely related limit that I could find that
> measured things in pages. Consider these two System V shared memory
> limits:
> 
> SHMMAX
> This is the maximum size (in bytes) of a shared memory segment.
> 
> SHMALL
> This is a system-wide limit on the total number of pages of shared memory.
> 
> But in a way this almost confirms my point. SHMMAX is a limit the
> governs the behavior of individual processes (like your /proc file),
> while SHMALL is a limit that governs the behavior of the system as a
> whole. There is a (sort of) logic to using bytes for one and pages for
> the other.
> 
> I think that I've said all I need to say on the topic. I'm inclined to
> think yours /proc file should use bytes, since it seems consistent
> with other simialr APIs. Others may confirm, or someone else mught
> have a different insight.

I'll commit a patch to change it to bytes.

> PS I hope you are going to set the lower limit for the /proc file to
> 4096B (a page) (?).

Yes, I think I'll do that as a separate patch up front.

-- 
Jens Axboe

