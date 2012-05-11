Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760905Ab2EKTT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 15:19:26 -0400
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:58773 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760781Ab2EKTTV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 15:19:21 -0400
MIME-Version: 1.0
In-Reply-To: <4FA9BE10.1030007@kernel.org>
References: <1336054995-22988-1-git-send-email-svenkatr@ti.com>
 <4FA8CF5E.1070202@kernel.org> <CANfBPZ-d-0FqY8Gruv+KDNoL3+FoQ68JEnxya5PydhY80x8yhA@mail.gmail.com>
 <4FA9BE10.1030007@kernel.org>
From: "S, Venkatraman" <svenkatr@ti.com>
Date: Sat, 12 May 2012 00:48:57 +0530
Message-ID: <CANfBPZ9jHfX6tyrOx=9E+L+Z0JzXMqjMYK++Q53C4TJFSujoGg@mail.gmail.com>
Subject: Re: [PATCHv2 00/16] [FS, MM, block, MMC]: eMMC High Priority
 Interrupt Feature
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mmc@vger.kernel.org, cjb@laptop.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd.bergmann@linaro.org,
        alex.lemberg@sandisk.com, ilan.smith@sandisk.com, lporzio@micron.com,
        rmk+kernel@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 6:15 AM, Minchan Kim <minchan@kernel.org> wrote:
> On 05/09/2012 01:31 AM, S, Venkatraman wrote:
>
>> On Tue, May 8, 2012 at 1:16 PM, Minchan Kim <minchan@kernel.org> wrote:
>>> On 05/03/2012 11:22 PM, Venkatraman S wrote:
>>>
>>>> Standard eMMC (Embedded MultiMedia Card) specification expects to execute
>>>> one request at a time. If some requests are more important than others, they
>>>> can't be aborted while the flash procedure is in progress.
>>>>
>>>> New versions of the eMMC standard (4.41 and above) specfies a feature
>>>> called High Priority Interrupt (HPI). This enables an ongoing transaction
>>>> to be aborted using a special command (HPI command) so that the card is ready
>>>> to receive new commands immediately. Then the new request can be submitted
>>>> to the card, and optionally the interrupted command can be resumed again.
>>>>
>>>> Some restrictions exist on when and how the command can be used. For example,
>>>> only write and write-like commands (ERASE) can be preempted, and the urgent
>>>> request must be a read.
>>>>
>>>> In order to support this in software,
>>>> a) At the top level, some policy decisions have to be made on what is
>>>> worth preempting for.
>>>>       This implementation uses the demand paging requests and swap
>>>> read requests as potential reads worth preempting an ongoing long write.
>>>>       This is expected to provide improved responsiveness for smarphones
>>>> with multitasking capabilities - example would be launch a email application
>>>> while a video capture session (which causes long writes) is ongoing.
>>>
>>>
>>> Do you have a number to prove it's really big effective?
>>
>> What type of benchmarks would be appropriate to post ?
>> As you know, the response time of a card would vary depending on
>> whether the flash device
>> has enough empty blocks to write into and doesn't have to resort to GC during
>> write requests.
>> Macro benchmarks like iozone etc would be inappropriate here, as they won't show
>> the latency effects of individual write requests hung up doing page
>> reclaim, which happens
>> once in a while.
>
>
> We don't have such special benchmark so you need time to think how to prove it.
> IMHO, you can use run-many-x-apps.sh which checks elapsed time to activate programs
> by posting by Wu long time ago.
>
> http://www.spinics.net/lists/linux-mm/msg09653.html
>
> Of course, your eMMC is used above 80~90% for triggering GC stress and
> your memory should be used up by dirty pages to happen reclaim.
>
>
>>>
>>> What I have a concern is when we got low memory situation.
>>> Then, writing speed for page reclaim is important for response.
>>> If we allow read preempt write and write is delay, it means read path takes longer time to
>>> get a empty buffer pages in reclaim. In such case, it couldn't be good.
>>>
>>
>> I agree. But when writes are delayed anyway as it exceeds
>> hpi_time_threshold (the window
>> available for invoking HPI), it means that the device is in GC mode
>> and either read or write
>> could be equally delayed.  Note that even in case of interrupting a
>> write, a single block write
>> (which usually is too short to be interrupted, as designed) is
>> sufficient for doing a page reclaim,
>> and further write requests (including multiblock) would not be subject
>> to HPI, as they will
>> complete within the average time.
>
>
> My point is that it would be better for read to not preempt write-for-page_reclaim.
> And we can identify it by PG_reclaim. You can get the idea.
>
> Anyway, HPI is only feature of a device of many storages and you are requiring modification
> of generic layers although it's not big. So for getting justification and attracting many
> core guys(MM,FS,BLOCK), you should provide data at least.
>
Hi Kim,
 Apologies for a delayed response. I am studying your suggestions and
will get back with
some changes and also some profiling data.
Regards,
Venkat.
