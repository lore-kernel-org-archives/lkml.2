Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab1K3Xlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 18:41:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab1K3Xlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 18:41:42 -0500
Date: Thu, 1 Dec 2011 01:43:18 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC] virtio: use mandatory barriers for remote processor vdevs
Message-ID: <20111130234318.GC31069@redhat.com>
References: <1322569886-13055-1-git-send-email-ohad@wizery.com>
 <20111129131110.GC19157@redhat.com>
 <CAK=WgbZoGYVyKt=XXvnPVdh0koSBJC0zcgkLaYRkmjwBLOFA-A@mail.gmail.com>
 <20111129151607.GE30966@redhat.com>
 <CAK=WgbZK+k4uuyMPHUfr_PMyrR5ceRTvuDRpmhXfgwpSUOPw0g@mail.gmail.com>
 <20111130145958.GE21413@redhat.com>
 <CAK=WgbYyFdLftE_kp2_JOThVhn-FzGsDqVqKn0Jwm2teQyZBNA@mail.gmail.com>
 <20111130161555.GB25812@redhat.com>
 <CAK=WgbazBq4GVo16sZsrZirgMYbwMcWtPaqn90c6d9Phr0gh3A@mail.gmail.com>
 <CAK=WgbbZH3ZFzbwwyVBGEvwHPbogDW6+Kb_1pRam2jj5oJHuDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK=WgbbZH3ZFzbwwyVBGEvwHPbogDW6+Kb_1pRam2jj5oJHuDA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 01:27:10AM +0200, Ohad Ben-Cohen wrote:
> On Wed, Nov 30, 2011 at 6:24 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> > On Wed, Nov 30, 2011 at 6:15 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> >> How are the rings mapped? normal memory, right?
> >
> > No, device memory.
> 
> Ok, I have more info.
> 
> Originally remoteproc was mapping the rings using ioremap, and that
> meant ARM Device memory.
> 
> Recently, though, we moved to CMA (allocating memory for the rings via
> dma_alloc_coherent), and that isn't Device memory anymore: it's
> uncacheable Normal memory (on ARM v6+).

And these accesses need to be ordered with DSB? Or DMB?

> We still require mandatory barriers though: one very reproducible
> problem I personally face is that the avail index doesn't get updated
> before the kick.

Aha! The *kick* really is MMIO. So I think we do need a mandatory barrier
before the kick.  Maybe we need it for virtio-pci as well
(not on kvm, naturally :) Off-hand this seems to belong in the transport
layer but need to think about it.

> As a result, the remote processor misses a buffer
> that was just added (the kick wakes it up only to find that the avail
> index wasn't changed yet). In this case, it probably happens because
> the mailbox, used to kick the remote processor, is mapped as Device
> memory, and therefore the kick can be reordered before the updates to
> the ring  can be observed.
> 
> I did get two additional reports about reordering issues, on different
> setups than my own, and which I can't personally reproduce: the one
> I've described earlier (avail index gets updated before the avail
> array) and one in the receive path (reading a used buffer which we
> already read). I couldn't personally verify those, but both issues
> were reported to be gone when mandatory barriers were used.

Hmm. So it's a hint that something is wrong with memory
but not what's wrong exactly.

> I expect those reports only to increase: the diversity of platforms
> that are now looking into adopting virtio for this kind of
> inter-process communication is quite huge, with several different
> architectures and even more hardware implementations on the way (not
> only ARM).
> 
> Thanks,
> Ohad.

Right. We need to be very careful with memory,
it's a tricky field. One known problem with virtio
is its insistance on using native endian-ness
for some fields. If power is used, we'll have to fix this.

-- 
MST
