Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030608Ab2B2KKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 05:10:05 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:39639 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629Ab2B2KKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 05:10:02 -0500
Date: Wed, 29 Feb 2012 19:16:23 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Avi Kivity <avi@redhat.com>
Cc: mtosatti@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 3/4] KVM: Switch to srcu-less get_dirty_log()
Message-Id: <20120229191623.d1edb0aa.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <4F4DEEFA.6000506@redhat.com>
References: <20120223203300.241510a6.yoshikawa.takuya@oss.ntt.co.jp>
	<20120223203541.f51c11c9.yoshikawa.takuya@oss.ntt.co.jp>
	<4F4CBEAA.5030708@redhat.com>
	<20120229164934.745d08f5.yoshikawa.takuya@oss.ntt.co.jp>
	<4F4DEEFA.6000506@redhat.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@redhat.com> wrote:

> Okay.  But note you don't need the alignment check; simply allocate the
> array aligned, and a multiple of 16 bytes, in the first place.

OKay, then we can do something like:

	for each (x = bitmap[i], y = bitmap[i+1])
		if (!x && !y)
			continue
		else if ...
			cmpxchg16b or 8b
		...

I will try later.

> > In addition, we should care about the new API.  It is not decided about
> > what kind of range can be ordered.  I think restricting the range to be
> > long size aligned is natural.  Do you have any plan?
> 
> Not really.  But the current changes are all internal and don't affect
> the user API.

Then I will do my best to improve the performance now!

> > __ffs is really fast compared to other APIs.
> 
> You could do something like this
> 
>     for (i = 0; i < bitmap_size_in_longs; ++i) {
>         mask = bitmap[i];
>         if (!mask)
>                continue;
>         for (j = __ffs(mask); mask; mask &= mask - 1, j = __ffs(mask))
>                 handle i * BITS_PER_LONG + j;
>     }
> 
> This gives you the speed of __ffs() but without working on zero bits.

Yes, I will do this in v2.

> > We may see partial display updates if we do not hold the mmu_lock during
> > xchg loop: it is possible that pages near the end of the framebuffer alone
> > gets updated sometimes - I noticed this problem when I fixed the TLB flush
> > issue.
> 
> I don't understand why this happens.

Because only mmu_lock protects the bitmap for VGA.

xchg i = 1
xchg i = 2
...
xchg i = N

We cannot get a complete snapshot without mmu_lock; if the guest faults on
the Nth page during xchg'ing i = 1, 2, ... then the i = N alone will
become newer.

But others will be updated by the next call, so the problem is restricted:
maybe not noticeable.

> > Not a big problem but still maybe-noticeable change, so I think we should
> > do it separately with some comments if needed.
> 
> Well if it's noticable on the framebuffer it's also noticable with live
> migration.  We could do it later, but we need to really understand it first.

About live migration, we do not mind whether the bitmap is a complete snapshot.
In addition, we cannot do anything because the emulator can access the bitmap
without mmu_lock.

What we are doing is calling GET_DIRTY_LOG slot by slot: so already the
result is not a snapshot at all.

In the end, at the last stage, we will stop the guest and get a complete snapshot.

> > In addition, we do not want to scan the dirty bitmap twice.  Using the
> > bits value soon after it is read into a register seems to be the fastest.
> 
> Probably.
> 
> > BTW, I also want to decide the design of the new API at this chance.
> 
> Let's wait with that.  We're adding APIs too quickly.  Let's squeeze
> everything we can out of the current APIs.

I agree with you of course.

At the same time, we cannot say anything without actually implementing
sample userspace programs.

So I want to see how much improvement the proposed API can achieve.

I thought this might be a good GSoC project but ...


Takuya
