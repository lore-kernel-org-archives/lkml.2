Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781Ab1K3Lp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 06:45:29 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43617 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757742Ab1K3Lp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 06:45:26 -0500
MIME-Version: 1.0
X-Originating-IP: [46.116.19.40]
In-Reply-To: <20111129151607.GE30966@redhat.com>
References: <1322569886-13055-1-git-send-email-ohad@wizery.com>
 <20111129131110.GC19157@redhat.com> <CAK=WgbZoGYVyKt=XXvnPVdh0koSBJC0zcgkLaYRkmjwBLOFA-A@mail.gmail.com>
 <20111129151607.GE30966@redhat.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 30 Nov 2011 13:45:05 +0200
Message-ID: <CAK=WgbZK+k4uuyMPHUfr_PMyrR5ceRTvuDRpmhXfgwpSUOPw0g@mail.gmail.com>
Subject: Re: [RFC] virtio: use mandatory barriers for remote processor vdevs
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 5:16 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> This mentions iommu - is there a need to use dma api to let
> the firmware acess the rings? Or does it have access to all
> of memory?

IOMMU may or may not be used, it really depends on the hardware (my
personal SoC does employ one, while others don't).

The vrings are created in non-cacheable memory, which is allocated
using dma_alloc_coherent, but that isn't necessarily controlling the
remote processor access to the memory (a notable example is an
iommu-less remote processor which can directly access the physical
memory).

> Is there cache snooping? If yes access from an external device
> typically works mostly in the same way as smp ...

No, nothing fancy like that. Every processor has its own cache, with
no coherency protocol. The remote processor should really be treated
as a device, and not as a processor that is part of an SMP
configuration, and we must prohibit both the compiler and the CPU from
reordering memory operations.

> So you put virtio rings in MMIO memory?

I'll be precise: the vrings are created in non-cacheable memory, which
both processors have access to.

> Could you please give a couple of examples of breakage?

Sure. Basically, the order of the vring memory operations appear
differently to the observing processor. For example, avail->idx gets
updated before the new entry is put in the available array...

Thanks,
Ohad.
