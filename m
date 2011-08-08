Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab1HHUXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 16:23:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40667 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753669Ab1HHUXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 16:23:46 -0400
Date: Mon, 8 Aug 2011 16:23:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Per Forlin <per.forlin@linaro.org>
cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linaro-dev@lists.linaro.org>
Subject: Re: [PATCH] usb: gadget: storage_common: make FSG_NUM_BUFFERS variable
 size
In-Reply-To: <CAJ0pr19=YHs9At=xXta-9Fro7QYAwpk=5e8SHWaRYgj8+iDKyQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1108081616470.1944-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Aug 2011, Per Forlin wrote:

> On 8 August 2011 20:45, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Mon, 8 Aug 2011, Per Forlin wrote:
> >
> >> > Okay, 6% is a worthwhile improvement, though not huge.  Did you try 6
> >> > or 8 buffers?  I bet going beyond 4 makes very little difference.
> >> >
> >> On my board 4 buffers are enough. More buffers will make no difference.
> >>
> >> Background study
> >> I started by running dd to measure performance on my target side.
> >> Simply to measure what would be the maximum bandwidth, 20MiB/s on my
> >> board. Then I started the gadget mass storage on the device and run
> >> the sae test from the PC host side, 18.7 MiB/s. I guessed this might
> >> be due to serialized cache handling. I tested to remove the dma_map
> >> call (replaced it with virt_to_dma). This is just a dummy test to see
> >> if this is causing the performance drop. Without dma_map I get
> >> 20MiB/s. It appears that the loss is due to dma_map call. The dma_map
> >> only adds latency for the first request.
> >
> > What exactly do you mean by "first request"?
> When both buffers are empty. The first request are filled up by vfs
> and then prepared. This first time there are no ongoing transfer over
> USB therefore this cost more, since it can't run in parallel with
> ongoing transfer. Every time the to buffers run empty there is an
> extra cost for the first request in the next series of requests. The
> reason for not getting data from vfs in time I don't know.

Okay, that makes sense.  But what connection does this have with
dma_map?  Don't you also have situations where both buffers are empty
when you replace dma_map with virt_to_dma?

> Instead of getting refill from vfs smoothly the refills comes in
> burst. VFS fills up the two buffers, then USB manage to transmit all
> two buffers before VFS refills new data. Roughly 20% of the times VFS
> fills up data in time before USB has consumed it all. 80% of the times
> USB manage to consume all data before VFS refills data in the buffers.
> The reason for the burst like affects are probably due to power save,
> which add latency in the system.

> This is true. In my system the buffer doesn't get filled up before the
> previous has finished. With 4 buffers it works fine.

Adding buffers to smooth out the bursty VFS behavior is a reasonable
thing to do.  But you should improve the patch description and the
comments; the real reason for reduced throughput is VFS's behavior.  
Something like what you just wrote here would be fine.

And reduce the maximum number of buffers to 4.  When you've made those 
changes, I'll Ack the patch.

Alan Stern

