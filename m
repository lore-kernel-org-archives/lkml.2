Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab1HHSLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 14:11:40 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49894 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab1HHSLj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 14:11:39 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1108081020070.1944-100000@iolanthe.rowland.org>
References: <1312762934-4884-1-git-send-email-per.forlin@linaro.org>
	<Pine.LNX.4.44L0.1108081020070.1944-100000@iolanthe.rowland.org>
Date: Mon, 8 Aug 2011 20:11:38 +0200
Message-ID: <CAJ0pr1-DVAiu7Z_Rcumkwji1+=D4Sw2d4GMFsZa-9KCJ06FauA@mail.gmail.com>
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

On 8 August 2011 16:34, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 8 Aug 2011, Per Forlin wrote:
>
>> FSG_NUM_BUFFERS is set to 2 as default.
>> Usually 2 buffers are enough to establish a good
>> double buffering pipeline. But when dealing with expensive
>> request preparation (i.e. dma_map) there may be benefits of
>> increasing the number of buffers. There is an extra cost for
>> every first request, the others are prepared in parallell with
>> an ongoing transfer. Every time all buffers are consumed there is
>> an additional cost for the next first request. Increasing the number
>> of buffers decreases the risk of running out of buffers.
>
> The reasoning here is not clear.  Throughput is limited on the device
> side mostly by the time required to prepare the buffer, transfer the
> data, and copy the data to/from the backing storage.  Using more
> buffers won't affect this directly.  Putting this another way, if the
> time required to prepare a buffer and copy the data is longer than the
> time needed to transfer the data over the USB link, the throughput
> won't be optimal no matter how many buffers you use.
>
> On the other hand, adding buffers will smooth out irregularities and
> latencies caused by scheduling delays when other tasks are running at
> the same time.  Still, I would expect the benefit to be fairly small
> and to diminish rapidly as more buffers are added.
>
>> Test set up
>>  * Running dd on the host reading from the mass storage device
>>  * cmdline: dd if=/dev/sdb of=/dev/null bs=4k count=$((256*100))
>>  * Caches are dropped on the host and on the device before each run
>>
>> Measurements on a Snowball board with ondemand_govenor active.
>>
>> FSG_NUM_BUFFERS 2
>> 104857600 bytes (105 MB) copied, 5.62173 s, 18.7 MB/s
>> 104857600 bytes (105 MB) copied, 5.61811 s, 18.7 MB/s
>> 104857600 bytes (105 MB) copied, 5.57817 s, 18.8 MB/s
>> 104857600 bytes (105 MB) copied, 5.57769 s, 18.8 MB/s
>> 104857600 bytes (105 MB) copied, 5.59654 s, 18.7 MB/s
>> 104857600 bytes (105 MB) copied, 5.58948 s, 18.8 MB/s
>>
>> FSG_NUM_BUFFERS 4
>> 104857600 bytes (105 MB) copied, 5.26839 s, 19.9 MB/s
>> 104857600 bytes (105 MB) copied, 5.2691 s, 19.9 MB/s
>> 104857600 bytes (105 MB) copied, 5.2711 s, 19.9 MB/s
>> 104857600 bytes (105 MB) copied, 5.27174 s, 19.9 MB/s
>> 104857600 bytes (105 MB) copied, 5.27261 s, 19.9 MB/s
>> 104857600 bytes (105 MB) copied, 5.27135 s, 19.9 MB/s
>> 104857600 bytes (105 MB) copied, 5.27249 s, 19.9 MB/s
>
> Okay, 6% is a worthwhile improvement, though not huge.  Did you try 6
> or 8 buffers?  I bet going beyond 4 makes very little difference.
>
On my board 4 buffers are enough. More buffers will make no difference.

Background study
I started by running dd to measure performance on my target side.
Simply to measure what would be the maximum bandwidth, 20MiB/s on my
board. Then I started the gadget mass storage on the device and run
the sae test from the PC host side, 18.7 MiB/s. I guessed this might
be due to serialized cache handling. I tested to remove the dma_map
call (replaced it with virt_to_dma). This is just a dummy test to see
if this is causing the performance drop. Without dma_map I get
20MiB/s. It appears that the loss is due to dma_map call. The dma_map
only adds latency for the first request.

Studying the flow of buffers I can see, both buffers are filled with
data from vfs, then both are transmitted over USB, burst like
behaviour. More buffers will add "smoothness" and prevent the bursts
to affect performance negatively. With 4 buffers, there were very few
cases when all 4 buffers were empty during a transfer

>> There may not be one optimal number for all boards. That is the
>> reason for adding the number to Kconfig,
>>
>> Signed-off-by: Per Forlin <per.forlin@linaro.org>
>> ---
>>  drivers/usb/gadget/Kconfig          |   15 +++++++++++++++
>>  drivers/usb/gadget/storage_common.c |    4 ++--
>>  2 files changed, 17 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
>> index 029e288..bbd17f3 100644
>> --- a/drivers/usb/gadget/Kconfig
>> +++ b/drivers/usb/gadget/Kconfig
>> @@ -96,6 +96,21 @@ config USB_GADGET_VBUS_DRAW
>>          This value will be used except for system-specific gadget
>>          drivers that have more specific information.
>>
>> +config USB_GADGET_STORAGE_NUM_BUFFERS
>> +     int "Number of storage pipline buffers"
>> +     range 2 64
>
> 64 is definitely way into the overkill range.  I'd be very tempted to
> leave the maximum set at 4.  You might even consider setting it to 4
> always -- although each buffer requires 16 KB of contiguous kernel
> memory so minimizing the number of buffers is always desirable.
I agree, 64 is not a realistic number. Max 4 is fine with me.

>
> Alan Stern
>
>
