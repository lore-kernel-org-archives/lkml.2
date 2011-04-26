Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab1DZO01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 10:26:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57632 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756426Ab1DZO0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 10:26:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
Date: Tue, 26 Apr 2011 16:26:19 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <201104212129.17013.arnd@arndb.de> <20110421130930.4be9e9e1@jbarnes-desktop>
In-Reply-To: <20110421130930.4be9e9e1@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104261626.20152.arnd@arndb.de>
X-Provags-ID: V02:K0:1JKpf5UIEqO+bGax4Ypq9Pwq9trxpwghgPQhcy4EOGp
 cd+VQd52214111qAv+zHt7iF6UPNacyDA075r4SxjzjPZERmnl
 RPccdxf6/bfnnqFbJFcLqIkmWs/7dtjPqtLP1cDS5RjyzSnAMx
 m4qz0L9+8XIJAirELqhlFA0KCa7scR+VYhopd6qcCxixrP55dU
 zCbCLRh1f2kTybXlhv02Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 April 2011, Jesse Barnes wrote:
> On Thu, 21 Apr 2011 21:29:16 +0200
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > I think the recent discussions on linaro-mm-sig and the BoF last week
> > at ELC have been quite productive, and at least my understanding
> > of the missing pieces has improved quite a bit. This is a list of
> > things that I think need to be done in the kernel. Please complain
> > if any of these still seem controversial:
> > 
> > 1. Fix the arm version of dma_alloc_coherent. It's in use today and
> >    is broken on modern CPUs because it results in both cached and
> >    uncached mappings. Rebecca suggested different approaches how to
> >    get there.
> > 
> > 2. Implement dma_alloc_noncoherent on ARM. Marek pointed out
> >    that this is needed, and it currently is not implemented, with
> >    an outdated comment explaining why it used to not be possible
> >    to do it.
> > 
> > 3. Convert ARM to use asm-generic/dma-mapping-common.h. We need
> >    both IOMMU and direct mapped DMA on some machines.
> 
> I don't think the DMA mapping and allocation APIs are sufficient for
> high performance graphics at least.  It's fairly common to allocate a
> bunch of buffers necessary to render a scene, build up a command buffer
> that references them, then hand the whole thing off to the kernel to
> execute at once on the GPU.  That allows for a lot of extra efficiency,
> since it allows you to batch the MMU binding until execution occurs (or
> even put it off entirely until the page is referenced by the GPU in the
> case of faulting support).  It's also necessary to avoid livelocks
> between two clients trying to render; if mapping is incremental on both
> sides, it's possible that neither will be able to make forward
> progress due to IOMMU space exhaustion.
> 
> So that argues for separating allocation from mapping both on the user
> side (which I think everyone agrees on) as well as on the kernel side,
> both for CPU access (which some drivers won't need) and for GPU access.

I don't thing that this argument has anything to do with what the
underlying API should be, right? I can see this built on top of either
the dma-mapping headers with extensions to map potentially uncached
pages, and with the iommu API. Neither way would however save us from
implementing the three items listed above.

It's certainly a good point to note that we should have a way to
allocate pages for a device without mapping them into any address
space right away. My feeling is still that the dma mapping API is
the right place for this, because it is the only part of the kernel
that has knowledge about whether a device needs uncached memory for
coherent access, under what constraints it can map noncontiguous
memory into its own address space, and what its addressing capabilities
are (dma mask).

	Arnd
