Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360Ab0EGL6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 07:58:36 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:38258 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab0EGL6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 07:58:35 -0400
Date: Fri, 7 May 2010 13:58:10 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Oliver Neukum <oneukum@suse.de>
Cc: Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>,
       alsa-devel@alsa-project.org, Greg KH <gregkh@suse.de>,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, iommu@lists.linux-foundation.org,
       Andi Kleen <andi@firstfloor.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Pedro Ribeiro <pedrib@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [alsa-devel] USB transfer_buffer allocations on 64bit systems
Message-ID: <20100507115810.GN30801@buzzloop.caiaq.de>
References: <g2h74fd948d1004141820ladc1941eo732d059dd678df0a@mail.gmail.com>
 <4BE3E1B9.5020602@ladisch.de>
 <201005071342.34923.oneukum@suse.de>
 <201005071347.56993.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005071347.56993.oneukum@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 01:47:56PM +0200, Oliver Neukum wrote:
> Am Freitag, 7. Mai 2010 13:42:34 schrieb Oliver Neukum:
> > Am Freitag, 7. Mai 2010 11:47:37 schrieb Clemens Ladisch:
> > > > In the particular case of audio drivers, though, the contents of the
> > > > buffers are likely to change after the submission. What we do here
> > > > is that we map the audio stream buffers which are used by ALSA to
> > > > the output URBs, so they're filled asychronously. Once the buffer is
> > > > actually sent out on the bus, it is believed to contain proper audio
> > > > date. If it doesn't, that's due to too tight audio timing or other
> > > > problems. This breaks once buffers are magically bounced in the
> > > > background.
> > > 
> > > At least the audio class and ua101 drivers don't do this and fill the
> > > buffers before they are submitted.
> > > 
> > > > So - long story short: these audio buffers need to be DMA coherent.
> > > 
> > > Does the USB API actually guarantee that all controllers use DMA, i.e.,
> > > that the buffers can be filled after submission?
> > 
> > No, you must not touch buffers after submission. This does not even
> > work if we use DMA, because on some architectures this violates
> > guarantees to the dma primitives. It cannot be done.

We do such tricks on other OS where IRQ latency as high as some tens
of milliseconds. So we queue EHCI transfers well in advance and update
access their contents (for both input and output) from audio context.
I considered implementing this idea to the Linux USB audio driver as
well.

> Or to be precise it could be done with coherent memory, but you'd risk
> transfering partially updated buffers, as you cannot know when DMA will
> be done and we don't guarantee that DMA will be done right as we transfer.

If the memory is coherent, it should be possible. And if buffers are
only partially updated, the audio buffer scheduling is too tight. IOW,
the configured buffer size of audio clients in userspace is too small.

This is OT now I believe, I will start another thread for this topic
once I have something to show.

Thanks,
Daniel
