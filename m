Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab1K2N5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 08:57:43 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49353 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854Ab1K2N5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 08:57:41 -0500
MIME-Version: 1.0
X-Originating-IP: [46.116.19.40]
In-Reply-To: <20111129131110.GC19157@redhat.com>
References: <1322569886-13055-1-git-send-email-ohad@wizery.com> <20111129131110.GC19157@redhat.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 29 Nov 2011 15:57:19 +0200
Message-ID: <CAK=WgbZoGYVyKt=XXvnPVdh0koSBJC0zcgkLaYRkmjwBLOFA-A@mail.gmail.com>
Subject: Re: [RFC] virtio: use mandatory barriers for remote processor vdevs
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 3:11 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> On Tue, Nov 29, 2011 at 02:31:26PM +0200, Ohad Ben-Cohen wrote:
>> Virtio is using memory barriers to control the ordering of
>> references to the vrings on SMP systems. When the guest is compiled
>> with SMP support, virtio is only using SMP barriers in order to
>> avoid incurring the overhead involved with mandatory barriers.
>>
>> Lately, though, virtio is being increasingly used with inter-processor
>> communication scenarios too, which involve running two (separate)
>> instances of operating systems on two (separate) processors, each of
>> which might either be UP or SMP.
>
> Is that using virtio-mmio?

No, I'm using this:

https://lkml.org/lkml/2011/10/25/139

> Sorry, could you pls explain what are 'two external processors'?
> I think I know that if two x86 CPUs in an SMP system run kernels built
> in an SMP configuration, smp_*mb barriers are enough.

Sure:

My setup is not SMP-based; it's two separate processors running in AMP
configuration. The processors have completely different architectures,
are not cache coherent, and only simply share some memory, which is
used for communications using virtio as the shared memory "wire"
protocol (i.e. we're not even doing virtualization: we have Linux on
one processor, and some RTOS on another processor, and they use virtio
to send and receive buffers).

So it's not SMP effects we're controlling; we're pretty much doing
MMIO and must use mandatory barriers (otherwise we see breakage).

> Is an extra branch faster or slower than reverting d57ed95?

Sorry, unfortunately I have no way to measure this, as I don't have
any virtualization/x86 setup. I'm developing on ARM SoCs, where
virtualization hardware is coming, but not here yet.

> One wonders how the remote side knows enough to set this flag?

The remote side is a dedicated firmware loaded in order to boot the
other processor, so it really is intimate with the platform and its
requirements (and it publishes the virtio device features for every
supported virtio device).

>> Though I also wonder how big really is the perforamnce gain of d57ed95 ?
>
> Want to check and tell us?

Sorry, as I said, I have no way to do that... Any chance you did some
measurements back then when d57ed95 was introduced ?

I just guessed it did improve performance, otherwise you probably
wouldn't have bothered. But if not, then reverting it is surely
preferable to adding more complexity.

Thanks!
Ohad.
