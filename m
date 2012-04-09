Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab2DIHpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 03:45:41 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13102 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab2DIHpj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 03:45:39 -0400
X-AuditID: cbfee61b-b7baeae000004fa7-6a-4f8291d15f4a
From: =?utf-8?B?7KCV7Zqo7KeE?= <syr.jeong@samsung.com>
To: "'Minchan Kim'" <minchan@kernel.org>,
        "'Alex Lemberg'" <Alex.Lemberg@sandisk.com>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>, linaro-kernel@lists.linaro.org,
        "'Rik van Riel'" <riel@redhat.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Luca Porzio (lporzio)'" <lporzio@micron.com>, linux-mm@kvack.org,
        kernel-team@android.com, "'Yejin Moon'" <yejin.moon@samsung.com>,
        "'Hugh Dickins'" <hughd@google.com>,
        "'Yaniv Iarovici'" <Yaniv.Iarovici@sandisk.com>, cpgs@samsung.com
References: <201203301744.16762.arnd@arndb.de>
 <201204021145.43222.arnd@arndb.de>
 <alpine.LSU.2.00.1204020734560.1847@eggly.anvils>
 <201204021455.25029.arnd@arndb.de>
 <D70D75BB1A02CA42A3E28AA542D282303A0661B561@MILMBMIPV3.sdcorp.global.sandisk.com>
 <4F8245EA.6000600@kernel.org>
In-reply-to: <4F8245EA.6000600@kernel.org>
Subject: RE: swap on eMMC and other flash
Date: Mon, 09 Apr 2012 16:37:53 +0900
Message-id: <006f01cd1623$ac4a2860$04de7920$%jeong@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac0V9o+pMJMxJhgZTKqCyP72aEIHUQAFLGUg
Content-language: ko
DLP-Filter: Pass
X-Brightmail-Tracker: AAAAAQAAAZE=
X-CFilter-Loop: Reflected
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minchan

How are you doing?

Regarding time to issue Discard/Trim :
eMMC point of view, I believe that the immediate Discard/Trim CMD after deleting/freezing a SWAP cluster is always better for all of general eMMC implementation.

Regarding swap page size:
Actually, I can't guarantee the optimal size of different eMMC in the industry, because it depends on NAND page size an firmware implementation inside eMMC. In case of SAMSUNG eMMC, 8KB page size and 512KB block size(erase unit) is current implementation.
I think that the multiple of 8KB page size align with 512KB is good for SAMSUNG eMMC.
If swap system use 512KB page and issue Discard/Trim align with 512KB, eMMC make best performance as of today. However, large page size in swap partition may not best way in Linux system level.
I'm not sure that the best page size between Swap system and eMMC device.

Best Regards
Hyojin
-----Original Message-----
From: Minchan Kim [mailto:minchan@kernel.org] 
Sent: Monday, April 09, 2012 11:14 AM
To: Alex Lemberg
Cc: Arnd Bergmann; linaro-kernel@lists.linaro.org; Rik van Riel; linux-mmc@vger.kernel.org; linux-kernel@vger.kernel.org; Luca Porzio (lporzio); linux-mm@kvack.org; Hyojin Jeong; kernel-team@android.com; Yejin Moon; Hugh Dickins; Yaniv Iarovici
Subject: Re: swap on eMMC and other flash

2012-04-08 오후 10:50, Alex Lemberg 쓴 글:

> Hi Arnd,
> 
> Regarding time to issue discard/TRIM commands:
> It would be advised to issue the discard command immediately after deleting/freeing a SWAP cluster (i.e. as soon as it becomes available).


Is it still good with page size, not cluster size?

> 
> Regarding SWAP page size:
> Working with as large as SWAP pages as possible would be recommended (preferably 64KB). Also, writing in a sequential manner as much as possible while swapping large quantities of data is also advisable.
> 
> SWAP pages and corresponding transactions should be aligned to the SWAP page size (i.e. 64KB above), the alignment should correspond to the physical storage "LBA 0", i.e. to the first LBA of the storage device (and not to a logical/physical partition).
> 



I have a curiosity on above comment is valid on Samsung and other eMMC.
Hyojin, Could you answer?


> Thanks,
> Alex
> 
>> -----Original Message-----
>> From: Arnd Bergmann [mailto:arnd@arndb.de]
>> Sent: Monday, April 02, 2012 5:55 PM
>> To: Hugh Dickins
>> Cc: linaro-kernel@lists.linaro.org; Rik van Riel; linux- 
>> mmc@vger.kernel.org; Alex Lemberg; linux-kernel@vger.kernel.org; Luca 
>> Porzio (lporzio); linux-mm@kvack.org; Hyojin Jeong; kernel- 
>> team@android.com; Yejin Moon
>> Subject: Re: swap on eMMC and other flash
>>
>> On Monday 02 April 2012, Hugh Dickins wrote:
>>> On Mon, 2 Apr 2012, Arnd Bergmann wrote:
>>>>
>>>> Another option would be batched discard as we do it for file
>> systems:
>>>> occasionally stop writing to swap space and scanning for areas that 
>>>> have become available since the last discard, then send discard 
>>>> commands for those.
>>>
>>> I'm not sure whether you've missed "swapon --discard", which 
>>> switches on discard_swap_cluster() just before we allocate from a 
>>> new cluster; or whether you're musing that it's no use to you 
>>> because you want to repurpose the swap cluster to match erase block: 
>>> I'm mentioning it in case you missed that it's already there (but 
>>> few use it, since even done at that scale it's often more trouble than it's worth).
>>
>> I actually argued that discard_swap_cluster is exactly the right 
>> thing to do, especially when clusters match erase blocks on the less 
>> capable devices like SD cards.
>>
>> Luca was arguing that on some hardware there is no point in ever 
>> submitting a discard just before we start reusing space, because at 
>> that point it the hardware already discards the old data by 
>> overwriting the logical addresses with new blocks, while issuing a 
>> discard on all blocks as soon as they become available would make a 
>> bigger difference. I would be interested in hearing from Hyojin Jeong 
>> and Alex Lemberg what they think is the best time to issue a discard, 
>> because they would know about other hardware than Luca.
>>
>>       Arnd
> 
> PLEASE NOTE: The information contained in this electronic mail message is intended only for the use of the designated recipient(s) named above. If the reader of this message is not the intended recipient, you are hereby notified that you have received this message in error and that any review, dissemination, distribution, or copying of this message is strictly prohibited. If you have received this communication in error, please notify the sender by telephone or e-mail (as shown above) immediately and destroy any and all copies of this message in your possession (whether hard copies or electronically stored copies).
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in the body 
> to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign 
> http://stopthemeter.ca/ Don't email: <a href=ilto:"dont@kvack.org"> 
> email@kvack.org </a>
> 



--
Kind regards,
Minchan Kim

