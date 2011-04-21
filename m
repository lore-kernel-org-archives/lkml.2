Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab1DUVw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 17:52:26 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57275 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab1DUVwZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 17:52:25 -0400
MIME-Version: 1.0
In-Reply-To: <20110421130930.4be9e9e1@jbarnes-desktop>
References: <201104212129.17013.arnd@arndb.de>
	<20110421130930.4be9e9e1@jbarnes-desktop>
Date: Thu, 21 Apr 2011 16:52:24 -0500
Message-ID: <BANLkTim5umALqafjA2e88UCLzMp9LQu3_Q@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
From: Zach Pfeffer <zach.pfeffer@linaro.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Arnd Bergmann <arnd@arndb.de> wrote:
>
>> I think the recent discussions on linaro-mm-sig and the BoF last week
>> at ELC have been quite productive, and at least my understanding
>> of the missing pieces has improved quite a bit. This is a list of
>> things that I think need to be done in the kernel. Please complain
>> if any of these still seem controversial:
>>
>> 1. Fix the arm version of dma_alloc_coherent. It's in use today and
>>    is broken on modern CPUs because it results in both cached and
>>    uncached mappings. Rebecca suggested different approaches how to
>>    get there.
>>
>> 2. Implement dma_alloc_noncoherent on ARM. Marek pointed out
>>    that this is needed, and it currently is not implemented, with
>>    an outdated comment explaining why it used to not be possible
>>    to do it.
>>
>> 3. Convert ARM to use asm-generic/dma-mapping-common.h. We need
>>    both IOMMU and direct mapped DMA on some machines.
>
> I don't think the DMA mapping and allocation APIs are sufficient for
> high performance graphics at least.  It's fairly common to allocate a
> bunch of buffers necessary to render a scene, build up a command buffer
> that references them, then hand the whole thing off to the kernel to
> execute at once on the GPU.  That allows for a lot of extra efficiency,
> since it allows you to batch the MMU binding until execution occurs (or
> even put it off entirely until the page is referenced by the GPU in the
> case of faulting support).  It's also necessary to avoid livelocks
> between two clients trying to render; if mapping is incremental on both
> sides, it's possible that neither will be able to make forward
> progress due to IOMMU space exhaustion.
>
> So that argues for separating allocation from mapping both on the user
> side (which I think everyone agrees on) as well as on the kernel side,
> both for CPU access (which some drivers won't need) and for GPU access.

I agree with Jesse that the separation of mapping from allocation is
central to the current usage models. I realize most people didn't like
VCMM, but it provided an abstraction for this - if software can handle
the multiple mapper approach in a rational way across ARM than we can
solve a lot of problems with all the map and unmap current solutions
and we don't have to hack in coherency.

>
> --
> Jesse Barnes, Intel Open Source Technology Center
>
> _______________________________________________
> Linaro-mm-sig mailing list
> Linaro-mm-sig@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-mm-sig
>
