Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933117Ab1CXWRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 18:17:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:48124 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754863Ab1CXWRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 18:17:08 -0400
Subject: [BUG] pgprot_noncached() is -NOT- safe for mapping vmalloc buffers
 into userspace
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: tiwai@suse.de
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-arch@vger.kernel.org, Matthew Evans <matt.evans@au1.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Mar 2011 09:16:48 +1100
Message-ID: <1301005008.2402.453.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi !

While working on endian-fixing xHCI with Matt (CC), we discovered the
source of our problems with usb-audio on a board we were working on.

c32d977b8157bf67cdf47729ce7dd054a26eb534
"ALSA: pcm - Call pgprot_noncached() for vmalloc'ed buffers"

I'm afraid that this is totally bogus :-)

I don't know on what arch it is safe to have the same memory be mapped
cachable in the kernel (and accessed via this cached mapping) and
non-cachable in userspace, but I can confidently say that wherever it
works it does so by accident.

In the case of usb-audio, what we observed is that the user application
was writing samples using an uncached mapping, so directly to memory,
which does -not- invalidate conflicting cache lines on the way, an the
kernel would then memcpy those data to the USB buffers using a cached
mapping (vmalloc) and essentially get stale stuff from the cache instead
of the real samples.

Worse, on some processors, it's actually -illegal- to create (and even
more to -access-) a conflicting mapping of a page of memory, ie, have it
mapped cached somewhere and uncached somewhere else. It will lockup some
processors and afaik, some x86 as well.

In fact, cache coherent architectures often don't support mapping memory
uncached -at-all- so something like snd_pcm_lib_mmap_noncached()
shouldn't exist, or at least be under arch control. There's no case
where it's "always safe". There will almost always be a cache alias in
the linear mapping unless special arch specific sauce has been applied.

Now, there's another problem on top of that, which is that
snd_pcm_default_mmap() will not work properly the "other way around" on
powerpc, where the mapping -needs- to be uncached bcs you are running on
a non cache coherent embedded CPU and trying to mmap DMA memory, but
that's something that needs fixing inside powerpc by properly defining
dma_mmap_coherent() & ARCH_HAS_DMA_MMAP_COHERENT (I thought we had added
it a while back but it's not upstream, patch must have got lost). We
must also make sure we don't go down that path for vmalloc memory
though.

Cheers,
Ben.


