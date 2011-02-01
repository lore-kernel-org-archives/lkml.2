Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab1BAEw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 23:52:57 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:33481 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664Ab1BAEw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 23:52:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ajgTxGBvRAqSvQzWXv7dILtwwS29gkY9pLvkgWnsyekiGrkGG64sSg4BVLCH06LPQn
         4F0DJi4mSvfADF4D0+J3bpUtyzTO8+xbf1HCw/v3sAJSkhVgrZ04LgSoFIbcKdv/p85B
         HzOsSdTOvqzkC5QrqfiFukMyPmheX62G0Wf6c=
Message-ID: <4D4791D6.8060100@lwfinger.net>
Date: Mon, 31 Jan 2011 22:53:42 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: b44 driver causes panic when using swiotlb
References: <4D478EDC.4070004@lwfinger.net>
In-Reply-To: <4D478EDC.4070004@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2011 10:41 PM, Larry Finger wrote:
> From: Robert Hancock
> Date: Mon Jan 31 2011 - 22:22:32 EST
> 
>     * Next message: Amit Shah: "Re: [PATCH 1/3] tty: move hvc drivers to
> drivers/tty/hvc/"
>     * Previous message: Grant Likely: "Re: [RFC][PATCH] Power domains for
> platform bus type"
>     * In reply to: FUJITA Tomonori: "Re: b44 driver causes panic when using swiotlb"
>     * Messages sorted by: [ date ] [ thread ] [ subject ] [ author ]
> 
> On 01/31/2011 07:28 PM, FUJITA Tomonori wrote:
> 
>     On Mon, 31 Jan 2011 18:54:21 -0600
>     Robert Hancock<hancockrwd@xxxxxxxxx> wrote:
> 
>         On 01/31/2011 10:36 AM, Andi Kleen wrote:
> 
>             On Mon, Jan 31, 2011 at 10:54:12AM -0500, Chuck Ebbert wrote:
> 
>                 The b44 driver is triggering this panic in swiotlb_map_page():
> 
>                 if (!dma_capable(dev, dev_addr, size))
>                 panic("map_single: bounce buffer is not DMA'ble");
> 
>                 The kernel log says the bounce buffers are at 0xdb400000, but
> b44 can
>                 only do DMA to the first 1GB of memory:
> 
> 
>             b44 needs to use GFP_DMA then and do its own custom bouncing.
>             The standard pci_map_* bounce buffering is only designed for at least
>             32bit capable devices.
> 
> 
>         That seems wrong - it's a documented API and that restriction isn't
>         documented. Either it should comply with the request or return a failure
>         if it can't accomodate it, not just blow up internally. There's no
>         reason the driver should have to deal with this on its own.
> 
>         In this case the DMA mapping code should really be falling back to
>         GFP_DMA automatically if the IOMMU aperture is outside the DMA mask of
>         the device.
> 
> 
>     swiotlb allocates the bounce buffer when a system boots up. We can't
>     allocate much in GFP_DMA. swiotlb uses somewhere under 4GB. So it
>     can't help devices that have odd dma_mask (that is, except for 4GB).
> 
>     Unfortunately, Such device needs to do own custom bouncing or needs
>     their subsystem to does that.
> 
>     Some ideas to implement something that works for such device were
>     discussed. Seems that the conclusion is that it's doesn't worth making
>     the common code complicated for such minor and insane devices.
> 
> 
> I don't think this is the only device that has sub-32-bit DMA restrictions, this
> will just lead to a bunch of duplicated code. In particular, how is LPC DMA
> supposed to work?
> 
> At the very least we should be allowing the driver to deal with the failure
> instead of panicing the system. Otherwise we are just leaving a land mine for
> people to trip over.

Some devices driven by b43legacy and b43 only support 30-bit DMA, which is what
I suspect b44 handles. The b43* drivers use a bounce buffer. If a generic
mechanism were created, those 2 would use it.

Larry
