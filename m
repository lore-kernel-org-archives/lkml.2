Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab1I0S2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 14:28:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60590 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab1I0S2K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 14:28:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?ISO-8859-1?Q?H=E5vard?= Skinnemoen <hskinnemoen@gmail.com>
Cc: Arvid Brodin <arvid.brodin@enea.com>, linux-kernel@vger.kernel.org,
        linux-embedded@vger.kernel.org,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: Re: dma_unmap_single() lacking cache sync on some archs?
Date: Tue, 27 Sep 2011 20:27:28 +0200
Message-ID: <2071463.ueDZJJtM1L@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.0.0-rc1nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <CAF8ieYUPcer2ZwaOi6YbiZQPeDBFukT2_dPStH10G_15Rh1fpw@mail.gmail.com>
References: <4E81BDEE.2080601@enea.com> <CAF8ieYUPcer2ZwaOi6YbiZQPeDBFukT2_dPStH10G_15Rh1fpw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:/tAdN/cN1ktwAWB3MDEoTsG922hWslS5HAKE+UFwNqB
 Xj3BAeTSS7PFHdYjyaQZI9vx3WBA5Tbx9bKjPqmTVI3zzYyX1b
 a+eq4xfColAQ+2Te0iY2UsCIKbv7OPOVkbplG081XqdWSmodQI
 FTD2tnp/Cx6cuEywbMDI0Mweyp8UHY5qUyxvhbPqwp0Xv92CMf
 nTKbpDvq0RQahnLNN9UKNBuZPfXQkP6hcvRB60IWde9vtNX56t
 PqOzKhwveSl9Lxgx1EzHLYshTqY0W2h418C4FcE1gJ/SfWCE/w
 gd29ram/lEklsjP2ASHYzybRJ8UFdzD/p3ZIihQV5nsY96bAxF
 xj+vSlWZTlnl2tI+STjg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 September 2011 09:55:02 Håvard Skinnemoen wrote:
> 
> On Tue, Sep 27, 2011 at 5:13 AM, Arvid Brodin <arvid.brodin@enea.com> wrote:
> > [Resending with CC to affected parties]
> >
> > Hi,
> >
> > I would expect cache synchronization for DMA_TO_DEVICE and DMA_BIDIRECTIONAL
> > when dma_map_single() is called, and for DMA_FROM_DEVICE and DMA_BIDIRECTIONAL
> > when dma_unmap_single() is called.
> >
> > However, on some architechtures (at least avr32, blackfin, ...), cache
> > synchronization only happens when dma_map_single() is called (and then
> > irrespective of DMA direction). dma_unmap_single() is a no-op for these archs.
> >
> > See e.g. http://lxr.linux.no/#linux+v3.0.4/arch/avr32/include/asm/dma-mapping.h#L117
> >
> > Isn't this a bug?
> 
> I don't think so. What do other architectures do?
> 
> We always need to sync before the transfer because if there is dirty
> data in the cache, it might get written to RAM during the transfer,
> which would be bad. Then, since the relevant cache lines are already
> clean and invalid, and the CPU is not allowed to access the buffer
> during the transfer, there's no need to sync again when the transfer
> is complete.

On some architectures, e.g. ARMv6 and higher, a speculative prefetch might
cause cache lines to be read again while an inbound DMA is on its way.
On those architectures you need to discard cache lines before reading from
the buffer. In fact also for DMA_FROM_DEVICE you need to flush or invalidate
the cache for the buffer before the transfer and invalidate the cache again
after the transfer.

Most architectures however do not require this.

	Arnd
