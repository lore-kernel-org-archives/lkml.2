Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab1HHUp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 16:45:28 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:34006 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab1HHUpZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 16:45:25 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1108081616470.1944-100000@iolanthe.rowland.org>
References: <CAJ0pr19=YHs9At=xXta-9Fro7QYAwpk=5e8SHWaRYgj8+iDKyQ@mail.gmail.com>
	<Pine.LNX.4.44L0.1108081616470.1944-100000@iolanthe.rowland.org>
Date: Mon, 8 Aug 2011 22:45:24 +0200
Message-ID: <CAJ0pr1-C+bY0wxHJGga89yU-rHA6bG2jfK9j=equB9nvMUNymQ@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget: storage_common: make FSG_NUM_BUFFERS
 variable size
From: Per Forlin <per.forlin@linaro.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 August 2011 22:23, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 8 Aug 2011, Per Forlin wrote:
>
>> On 8 August 2011 20:45, Alan Stern <stern@rowland.harvard.edu> wrote:
>> > On Mon, 8 Aug 2011, Per Forlin wrote:
>> >
>> >> > Okay, 6% is a worthwhile improvement, though not huge.  Did you try 6
>> >> > or 8 buffers?  I bet going beyond 4 makes very little difference.
>> >> >
>> >> On my board 4 buffers are enough. More buffers will make no difference.
>> >>
>> >> Background study
>> >> I started by running dd to measure performance on my target side.
>> >> Simply to measure what would be the maximum bandwidth, 20MiB/s on my
>> >> board. Then I started the gadget mass storage on the device and run
>> >> the sae test from the PC host side, 18.7 MiB/s. I guessed this might
>> >> be due to serialized cache handling. I tested to remove the dma_map
>> >> call (replaced it with virt_to_dma). This is just a dummy test to see
>> >> if this is causing the performance drop. Without dma_map I get
>> >> 20MiB/s. It appears that the loss is due to dma_map call. The dma_map
>> >> only adds latency for the first request.
>> >
>> > What exactly do you mean by "first request"?
>> When both buffers are empty. The first request are filled up by vfs
>> and then prepared. This first time there are no ongoing transfer over
>> USB therefore this cost more, since it can't run in parallel with
>> ongoing transfer. Every time the to buffers run empty there is an
>> extra cost for the first request in the next series of requests. The
>> reason for not getting data from vfs in time I don't know.
>
> Okay, that makes sense.  But what connection does this have with
> dma_map?  Don't you also have situations where both buffers are empty
> when you replace dma_map with virt_to_dma?
>
All I do here is to remove the cost of dma_map in order to verify if
dma_map is the one responsible for the delay. If the performance is
good without dma_map I know the extra cost is due to dma_map running
in serial instead of parallel. If the performance would be bad even
without dma_map something else is causing it. It doesn't affect how
the VFS feeds data to the buffers.

>> Instead of getting refill from vfs smoothly the refills comes in
>> burst. VFS fills up the two buffers, then USB manage to transmit all
>> two buffers before VFS refills new data. Roughly 20% of the times VFS
>> fills up data in time before USB has consumed it all. 80% of the times
>> USB manage to consume all data before VFS refills data in the buffers.
>> The reason for the burst like affects are probably due to power save,
>> which add latency in the system.
>
>> This is true. In my system the buffer doesn't get filled up before the
>> previous has finished. With 4 buffers it works fine.
>
> Adding buffers to smooth out the bursty VFS behavior is a reasonable
> thing to do.  But you should improve the patch description and the
> comments; the real reason for reduced throughput is VFS's behavior.
> Something like what you just wrote here would be fine.
I agree. The main reason is to compensate for bursty VFS behavior.

>
> And reduce the maximum number of buffers to 4.  When you've made those
> changes, I'll Ack the patch.
I'll do.

Thanks for your time and patience,
Per
