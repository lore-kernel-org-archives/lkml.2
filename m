Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab1HHTeE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 15:34:04 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62081 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab1HHTeC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 15:34:02 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1108081430140.1944-100000@iolanthe.rowland.org>
References: <CAJ0pr1-DVAiu7Z_Rcumkwji1+=D4Sw2d4GMFsZa-9KCJ06FauA@mail.gmail.com>
	<Pine.LNX.4.44L0.1108081430140.1944-100000@iolanthe.rowland.org>
Date: Mon, 8 Aug 2011 21:34:00 +0200
Message-ID: <CAJ0pr19=YHs9At=xXta-9Fro7QYAwpk=5e8SHWaRYgj8+iDKyQ@mail.gmail.com>
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

On 8 August 2011 20:45, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 8 Aug 2011, Per Forlin wrote:
>
>> > Okay, 6% is a worthwhile improvement, though not huge.  Did you try 6
>> > or 8 buffers?  I bet going beyond 4 makes very little difference.
>> >
>> On my board 4 buffers are enough. More buffers will make no difference.
>>
>> Background study
>> I started by running dd to measure performance on my target side.
>> Simply to measure what would be the maximum bandwidth, 20MiB/s on my
>> board. Then I started the gadget mass storage on the device and run
>> the sae test from the PC host side, 18.7 MiB/s. I guessed this might
>> be due to serialized cache handling. I tested to remove the dma_map
>> call (replaced it with virt_to_dma). This is just a dummy test to see
>> if this is causing the performance drop. Without dma_map I get
>> 20MiB/s. It appears that the loss is due to dma_map call. The dma_map
>> only adds latency for the first request.
>
> What exactly do you mean by "first request"?
When both buffers are empty. The first request are filled up by vfs
and then prepared. This first time there are no ongoing transfer over
USB therefore this cost more, since it can't run in parallel with
ongoing transfer. Every time the to buffers run empty there is an
extra cost for the first request in the next series of requests. The
reason for not getting data from vfs in time I don't know.

> Your test showed an extra latency of about 0.4 seconds when using
> dma_map.  All that latency comes from a single request (the first one)?
> That doesn't sound right.
>
This "first request scenario" I refer to happens very often.

>> Studying the flow of buffers I can see, both buffers are filled with
>> data from vfs, then both are transmitted over USB, burst like
>> behaviour.
>
> Actually the first buffer is filled from VFS, then it is transmitted
> over USB.  While the transmission is in progress, the second buffer is
> filled from VFS.  Each time a transmission ends, the next buffer is
> queued for transmission -- unless it hasn't been filled yet, in which
> case it is queued when it gets filled.
>
> What do you mean by "burst like behavior"?
>
Instead of getting refill from vfs smoothly the refills comes in
burst. VFS fills up the two buffers, then USB manage to transmit all
two buffers before VFS refills new data. Roughly 20% of the times VFS
fills up data in time before USB has consumed it all. 80% of the times
USB manage to consume all data before VFS refills data in the buffers.
The reason for the burst like affects are probably due to power save,
which add latency in the system.

>>  More buffers will add "smoothness" and prevent the bursts
>> to affect performance negatively. With 4 buffers, there were very few
>> cases when all 4 buffers were empty during a transfer
>
> In what sense do the bursts affect performance?  It makes sense that
> having all the buffers empty from time to time would reduce throughput.
> But as long as each buffer gets filled and queued before the previous
> buffer has finished transmitting, it shouldn't matter how "bursty" the
> behavior is.
>
This is true. In my system the buffer doesn't get filled up before the
previous has finished. With 4 buffers it works fine.

Thanks,
Per
