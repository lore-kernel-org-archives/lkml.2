Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab2B2McY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 07:32:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757314Ab2B2McX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 07:32:23 -0500
Message-ID: <4F4E1999.3060303@redhat.com>
Date: Wed, 29 Feb 2012 14:27:05 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: mtosatti@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 3/4] KVM: Switch to srcu-less get_dirty_log()
References: <20120223203300.241510a6.yoshikawa.takuya@oss.ntt.co.jp> <20120223203541.f51c11c9.yoshikawa.takuya@oss.ntt.co.jp> <4F4CBEAA.5030708@redhat.com> <20120229164934.745d08f5.yoshikawa.takuya@oss.ntt.co.jp> <4F4DEEFA.6000506@redhat.com> <20120229191623.d1edb0aa.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120229191623.d1edb0aa.yoshikawa.takuya@oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/29/2012 12:16 PM, Takuya Yoshikawa wrote:
> > > We may see partial display updates if we do not hold the mmu_lock during
> > > xchg loop: it is possible that pages near the end of the framebuffer alone
> > > gets updated sometimes - I noticed this problem when I fixed the TLB flush
> > > issue.
> > 
> > I don't understand why this happens.
>
> Because only mmu_lock protects the bitmap for VGA.
>
> xchg i = 1
> xchg i = 2
> ...
> xchg i = N
>
> We cannot get a complete snapshot without mmu_lock; if the guest faults on
> the Nth page during xchg'ing i = 1, 2, ... then the i = N alone will
> become newer.

Ah, so there is no data corruption (missed dirty bits), just the display
is updated inconsistently?

I don't think we can get a consistent snapshot anyway, since the guest
can update the framebuffer while userspace is processing it.

>
> But others will be updated by the next call, so the problem is restricted:
> maybe not noticeable.
>
> > > Not a big problem but still maybe-noticeable change, so I think we should
> > > do it separately with some comments if needed.
> > 
> > Well if it's noticable on the framebuffer it's also noticable with live
> > migration.  We could do it later, but we need to really understand it first.
>
> About live migration, we do not mind whether the bitmap is a complete snapshot.
> In addition, we cannot do anything because the emulator can access the bitmap
> without mmu_lock.
>
> What we are doing is calling GET_DIRTY_LOG slot by slot: so already the
> result is not a snapshot at all.
>
> In the end, at the last stage, we will stop the guest and get a complete snapshot.

Understood.  I don't think we can get a consistent vga snapshot without
stopping the guest, and even then, it depends on how the guest updates
the framebuffer.

>
> > > In addition, we do not want to scan the dirty bitmap twice.  Using the
> > > bits value soon after it is read into a register seems to be the fastest.
> > 
> > Probably.
> > 
> > > BTW, I also want to decide the design of the new API at this chance.
> > 
> > Let's wait with that.  We're adding APIs too quickly.  Let's squeeze
> > everything we can out of the current APIs.
>
> I agree with you of course.
>
> At the same time, we cannot say anything without actually implementing
> sample userspace programs.
>
> So I want to see how much improvement the proposed API can achieve.
>
> I thought this might be a good GSoC project but ...

It may be too involved for GSoC, the issues are difficult.

-- 
error compiling committee.c: too many arguments to function

