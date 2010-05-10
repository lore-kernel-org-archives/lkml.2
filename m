Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621Ab0EJOeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 10:34:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47419 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab0EJOee (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 10 May 2010 10:34:34 -0400
Date: Mon, 10 May 2010 10:31:32 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: Clemens Ladisch <clemens@ladisch.de>, alsa-devel@alsa-project.org,
       USB list <linux-usb@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Greg KH <gregkh@suse.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, iommu@lists.linux-foundation.org,
       Andi Kleen <andi@firstfloor.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Pedro Ribeiro <pedrib@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [alsa-devel] USB transfer_buffer allocations on 64bit systems
Message-ID: <20100510143132.GB29517@phenom.dumpdata.com>
References: <g2h74fd948d1004141820ladc1941eo732d059dd678df0a@mail.gmail.com> <Pine.LNX.4.44L0.1004151114490.1562-100000@iolanthe.rowland.org> <t2r74fd948d1004191716l49dedc2p25a27da39bcc614a@mail.gmail.com> <20100507074855.GF30801@buzzloop.caiaq.de> <4BE3E1B9.5020602@ladisch.de> <20100507102408.GM30801@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507102408.GM30801@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4BE8193B.0033:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 12:24:08PM +0200, Daniel Mack wrote:
> On Fri, May 07, 2010 at 11:47:37AM +0200, Clemens Ladisch wrote:
> > Daniel Mack wrote:
> > > The problem is again (summarized):
> > > 
> > > On 64bit machines, with 4GB or more, the allocated buffers for USB
> > > transfers might be beyond the 32bit boundary. In this case, the IOMMU
> > > should take care and install DMA bounce buffer to copy over the buffer
> > > before the transfer actually happens. The problem is, however, that this
> > > copy mechanism takes place when the URB with its associated buffer is
> > > submitted, not when the EHCI will actually do the transfer.
> > > 
> > > In the particular case of audio drivers, though, the contents of the
> > > buffers are likely to change after the submission. What we do here
> > > is that we map the audio stream buffers which are used by ALSA to
> > > the output URBs, so they're filled asychronously. Once the buffer is
> > > actually sent out on the bus, it is believed to contain proper audio
> > > date. If it doesn't, that's due to too tight audio timing or other
> > > problems. This breaks once buffers are magically bounced in the
> > > background.
> > 
> > At least the audio class and ua101 drivers don't do this and fill the
> > buffers before they are submitted.
> 
> Gnaa, you're right. I _thought_ my code does it the way I described, but
> what I wrote is how I _wanted_ to do it, not how it's currently done. I
> have a plan to change this in the future.
> 
> So unfortunately, that doesn't explain it either. Sorry for the noise.

Well, you might be on the right track. You see, when you do any DMA API
operation (say pci_map_page), you might end up with _two_ DMA addresses.
One that you get from doing 'virt_to_phys' for your buffer (which might
be above the 4GB mark), and another from the 'pci_map_page' (which can
be the virt_to_phys of your buffer or it can be the DMA address of the
SWIOTLB). If you don't submit the _right_ DMA address or sync after the
DMA transfer (so the SWIOTLB would do its memcpy to your allocated
buffer DMA address), you could end up having the data it the SWIOTLB buffer,
and check data in your kzalloc buffer and notice that nothing is there
(and if it hadn't called pci_dma_sync.. before the check).

But this obviously would not happen if you buffer is allocated with the
GFP_DMA32.

I am not familiar with the USB stack so it might be doing this correctly
already...
