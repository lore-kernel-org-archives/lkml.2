Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab3AHABV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 19:01:21 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:63612 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290Ab3AHABU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 19:01:20 -0500
Date: Mon, 7 Jan 2013 16:01:16 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu
Subject: Re: [PATCH 25/32] aio: use xchg() instead of completion_lock
Message-ID: <20130108000116.GK26407@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
 <1356573611-18590-28-git-send-email-koverstreet@google.com>
 <20130103153414.23b0b913.akpm@linux-foundation.org>
 <20130107232115.GF26407@google.com>
 <20130107153524.eb2f1223.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130107153524.eb2f1223.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 03:35:24PM -0800, Andrew Morton wrote:
> On Mon, 7 Jan 2013 15:21:15 -0800
> Kent Overstreet <koverstreet@google.com> wrote:
> 
> > On Thu, Jan 03, 2013 at 03:34:14PM -0800, Andrew Morton wrote:
> > > On Wed, 26 Dec 2012 18:00:04 -0800
> > > Kent Overstreet <koverstreet@google.com> wrote:
> > > 
> > > > So, for sticking kiocb completions on the kioctx ringbuffer, we need a
> > > > lock - it unfortunately can't be lockless.
> > > > 
> > > > When the kioctx is shared between threads on different cpus and the rate
> > > > of completions is high, this lock sees quite a bit of contention - in
> > > > terms of cacheline contention it's the hottest thing in the aio
> > > > subsystem.
> > > > 
> > > > That means, with a regular spinlock, we're going to take a cache miss
> > > > to grab the lock, then another cache miss when we touch the data the
> > > > lock protects - if it's on the same cacheline as the lock, other cpus
> > > > spinning on the lock are going to be pulling it out from under us as
> > > > we're using it.
> > > > 
> > > > So, we use an old trick to get rid of this second forced cache miss -
> > > > make the data the lock protects be the lock itself, so we grab them both
> > > > at once.
> > > 
> > > Boy I hope you got that right.
> > > 
> > > Did you consider using bit_spin_lock() on the upper bit of `tail'? 
> > > We've done that in other places and we at least know that it works. 
> > > And it has the optimisations for CONFIG_SMP=n, understands
> > > CONFIG_DEBUG_SPINLOCK, has arch-specific optimisations, etc.
> > 
> > I hadn't thought of that - I think it'd suffer from the same problem as
> > a regular spinlock, where you grab the lock, then go to grab your data
> > but a different CPU grabbed the cacheline you need...
> 
> Either you didn't understand my suggestion or I didn't understand your
> patch :(

Safest bet to blame me :p

> I'm suggesting that we use the msot significant bit *of the data* as
> that data's lock.  Obviously, all uses of that data would then mask that
> bit out.

Yeah, I got that.

> That way, the data will be brought into CPU cache when the lock is
> acquired.  And when other CPUs attempt to acquire the lock, they won't
> steal the cacheline.
> 
> This is assuming that an unsuccessful test_and_set_bit_lock() won't
> grab the cacheline, which is hopefully true but I don't know.  If this
> turns out to be false then we could add a test_bit() loop to
> bit_spin_lock(), or perhaps rework bit_spin_lock() to not do the
> test_and_set_bit_lock() unless test_bit() has just returned 0.

I was assuming it would grab the cacheline, but I could easily be
mistaken about that. I know spinning unsuccesfully on a spinlock will
grab the cacheline, I would _think_ both test_and_set_bit_lock() and
test_bit() would as well but since I haven't yet benchmarked or profiled
it I could just be making stuff up.

I'll try it out.

> > But the lock debugging would be nice. It'd probably work to make
> > something generic like bit_spinlock() that also returns some value - or,
> > the recent patches for making spinlocks back off will also help with
> > this problem. So maybe between that and batch completion this patch
> > could be dropped at some point.
> > 
> > So, yeah. The code's plenty tested and I went over the barriers, it
> > already had all the needed barriers due to the ringbuffer... and I've
> > done this sort of thing elsewhere too. But it certaintly is a hack and I
> > wouldn't be sad to see it go.
> 
> Yes, there are a lot of issues with adding a new locking primitive and
> in some ways they get worse when they're open-coded like this.  If
> there's any way at all of using a standard lock instead of KentLocks
> then we should do this.

Yeah, that's certainly true. Honestly, the performance improvements from
this trick were noticable but nothing like the rest of the patch series
- I really wouldn't complain if we just dropped this.

Oh, and bit_spin_lock() doesn't have an _irqsave() variant, bleh.
