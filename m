Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761788Ab2DLCgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 22:36:23 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49826 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756642Ab2DLCgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 22:36:21 -0400
X-AuditID: 9c930179-b7b2cae000000ca1-53-4f863fa365e1
Message-ID: <4F863FA1.3090707@kernel.org>
Date: Thu, 12 Apr 2012 11:36:17 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mmc,gmane.comp.handhelds.android.kernel,gmane.linux.kernel.mm,gmane.linux.kernel
To: Arnd Bergmann <arnd@arndb.de>
CC: linaro-kernel@lists.linaro.org, android-kernel@googlegroups.com,
        linux-mm@kvack.org, "Luca Porzio (lporzio)" <lporzio@micron.com>,
        Alex Lemberg <alex.lemberg@sandisk.com>, linux-kernel@vger.kernel.org,
        Saugata Das <saugata.das@linaro.org>,
        Venkatraman S <venkat@linaro.org>, Yejin Moon <yejin.moon@samsung.com>,
        Hyojin Jeong <syr.jeong@samsung.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Subject: Re: swap on eMMC and other flash
References: <201203301744.16762.arnd@arndb.de> <201204100832.52093.arnd@arndb.de> <20120411095418.GA2228@barrios> <201204111557.14153.arnd@arndb.de>
In-Reply-To: <201204111557.14153.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2012 12:57 AM, Arnd Bergmann wrote:
> On Wednesday 11 April 2012, Minchan Kim wrote:
>> On Tue, Apr 10, 2012 at 08:32:51AM +0000, Arnd Bergmann wrote:
>>>>
>>>> I should have written more general term. I means write amplication but
>>>> WAF(Write Amplication Factor) is more popular. :(
>>>
>>> D'oh. Thanks for the clarification. Note that the entire idea of increasing the
>>> swap cluster size to the erase block size is to *reduce* write amplification:
>>>
>>> If we pick arbitrary swap clusters that are part of an erase block (or worse,
>>> span two partial erase blocks), sending a discard for one cluster does not
>>> allow the device to actually discard an entire erase block. Consider the best
>>> possible scenario where we have a 1MB cluster and 2MB erase blocks, all
>>> naturally aligned. After we have written the entire swap device once, all
>>> blocks are marked as used in the device, but some are available for reuse
>>> in the kernel. The swap code picks a cluster that is currently unused and
>>> sends a discard to the device, then fills the cluster with new pages.
>>> After that, we pick another swap cluster elsewhere. The erase block now
>>> contains 50% new and 50% old data and has to be garbage collected, so the
>>> device writes 2MB of data  to anther erase block. So, in order to write 1MB,
>>> the device has written 3MB and the write amplification factor is 3. Using
>>> 8MB erase blocks, it would be 9.
>>>
>>> If we do the active compaction and increase the cluster size to the erase
>>> block size, there is no write amplification inside of the device (and no
>>> stalls from the garbage collection, which are the other concern), and
>>> we only need to write a few blocks again that are still valid in a cluster
>>> at the time we want to reuse it. On an ideal device, the write amplification
>>> for active compaction should be exactly the same as what we get when we
>>> write a cluster while some of the data in it is still valid and we skip
>>> those pages, while some devices might now like having to gc themselves.
>>> Doing the compaction in software means we have to spend CPU cycles on it,
>>> but we get to choose when it happens and don't have to block on the device
>>> during GC.
>>
>> Thanks for detail explanation.
>> At least, we need active compaction to avoid GC completely when we can't find
>> empty cluster and there are lots of hole.
>> Indirection layer we discussed last LSF/MM could help slot change by
>> compaction easily.
>> I think way to find empty cluster should be changed because current linear scan
>> is not proper for bigger cluster size.
>>
>> I am looking forward to your works!
>>
>> P.S) I'm afraid this work might raise endless war, again which host can do well VS
>> device can do well. If we can work out, we don't need costly eMMC FTL, just need
>> dumb bare nand, controller and simple firmware.
>
> IMHO, we should only distinguish between dumb and smart devices, defined as follows:
>
> 1. smart devices behave like all but the extremely cheap SSDs. They are optimized
> for 4KB random I/O, and the erase block size is not visible because there is
> a write cache and a flexible controller between the block device abstraction
> and the raw flash.
>
> 2. dumb devices have very visible effects that stem from a simplistic remapping
> layer that translates logical erase block numbers into physical erase blocks,
> and only a fixed number of those can be written at the same time before forcing
> GC. Writes smaller than page size are strongly discouraged here. There is no
> RAM to cache writes in the controller, but we still expect these devices to
> have a reasonable wear levelling policy.  This covers almost all of today's
> eMMC, SD, USB and CF as well as some cheap ATA SSD.

Such dumb devices have disadvantage as follows,
Some user expect it manage to do itself and some user don't expect it so 
someone like you will add smart features on host to remove GC but 
someone still believes that eMMC by itself will do enough so that he can 
use any FSes on it.

Conflict happens.

Although we can solve several problems to use eMMC as swap, other 
partition could be used for any FSes which are not aware of eMMC 
characteristic. It could cause GC in eMMC internal although it work out 
eMMC as swap so long latency when we use it as swap could be happened.

>
> A third category is of course spinning rust, but I think with the distinction
> for solid state media above, we have a pretty good grip on all existing
> media. As eMMC and UFS evolve over time, we might want to stick them into the
> first category, but I don't think we need more categories.
>
> 	Arnd
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

