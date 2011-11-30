Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab1K3X1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 18:27:34 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45718 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab1K3X1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 18:27:32 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.53.1]
In-Reply-To: <CAK=WgbazBq4GVo16sZsrZirgMYbwMcWtPaqn90c6d9Phr0gh3A@mail.gmail.com>
References: <1322569886-13055-1-git-send-email-ohad@wizery.com>
 <20111129131110.GC19157@redhat.com> <CAK=WgbZoGYVyKt=XXvnPVdh0koSBJC0zcgkLaYRkmjwBLOFA-A@mail.gmail.com>
 <20111129151607.GE30966@redhat.com> <CAK=WgbZK+k4uuyMPHUfr_PMyrR5ceRTvuDRpmhXfgwpSUOPw0g@mail.gmail.com>
 <20111130145958.GE21413@redhat.com> <CAK=WgbYyFdLftE_kp2_JOThVhn-FzGsDqVqKn0Jwm2teQyZBNA@mail.gmail.com>
 <20111130161555.GB25812@redhat.com> <CAK=WgbazBq4GVo16sZsrZirgMYbwMcWtPaqn90c6d9Phr0gh3A@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 1 Dec 2011 01:27:10 +0200
Message-ID: <CAK=WgbbZH3ZFzbwwyVBGEvwHPbogDW6+Kb_1pRam2jj5oJHuDA@mail.gmail.com>
Subject: Re: [RFC] virtio: use mandatory barriers for remote processor vdevs
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 6:24 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> On Wed, Nov 30, 2011 at 6:15 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
>> How are the rings mapped? normal memory, right?
>
> No, device memory.

Ok, I have more info.

Originally remoteproc was mapping the rings using ioremap, and that
meant ARM Device memory.

Recently, though, we moved to CMA (allocating memory for the rings via
dma_alloc_coherent), and that isn't Device memory anymore: it's
uncacheable Normal memory (on ARM v6+).

We still require mandatory barriers though: one very reproducible
problem I personally face is that the avail index doesn't get updated
before the kick. As a result, the remote processor misses a buffer
that was just added (the kick wakes it up only to find that the avail
index wasn't changed yet). In this case, it probably happens because
the mailbox, used to kick the remote processor, is mapped as Device
memory, and therefore the kick can be reordered before the updates to
the ring  can be observed.

I did get two additional reports about reordering issues, on different
setups than my own, and which I can't personally reproduce: the one
I've described earlier (avail index gets updated before the avail
array) and one in the receive path (reading a used buffer which we
already read). I couldn't personally verify those, but both issues
were reported to be gone when mandatory barriers were used.

I expect those reports only to increase: the diversity of platforms
that are now looking into adopting virtio for this kind of
inter-process communication is quite huge, with several different
architectures and even more hardware implementations on the way (not
only ARM).

Thanks,
Ohad.
