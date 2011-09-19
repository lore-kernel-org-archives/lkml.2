Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab1ISUyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 16:54:33 -0400
Received: from yuna.grokhost.net ([87.117.228.63]:48125 "EHLO
	yuna.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab1ISUyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 16:54:32 -0400
Message-ID: <4E77AC03.3030206@bootc.net>
Date: Mon, 19 Sep 2011 21:54:27 +0100
From: Chris Boot <bootc@bootc.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: adam radford <aradford@gmail.com>
CC: James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Woodhouse, David" <david.woodhouse@intel.com>,
        lkml <linux-kernel@vger.kernel.org>, Adam Radford <linuxraid@lsi.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: iommu_iova leak [inside 3w-9xxx]
References: <4E734467.3040703@bootc.net> <1316256305.24257.25.camel@shinybook.infradead.org> <AD4B8103-C98F-4BC5-9F7F-496D220781F3@bootc.net> <3A4FADE6-3653-46C5-B225-8200F9DCE35B@bootc.net> <CAHtARFHfxpU1JKu4092ZshvhsrRY-hx_pfnL3_+T32B3ncgWvg@mail.gmail.com> <B4A636AC-B127-42DD-BC8C-419D07A83FBD@bootc.net> <1316353140.12001.15.camel@shinybook.infradead.org> <1316354509.27722.1.camel@dabdike> <B008530A-B1B1-49D2-A3B4-9CD929D948FB@bootc.net> <1316355934.27722.6.camel@dabdike> <1316357780.27722.9.camel@dabdike> <CAHtARFFNj1XD6PFnquNRdt6xwK6pKygH3YibSjLoT_u=P=yceA@mail.gmail.com>
In-Reply-To: <CAHtARFFNj1XD6PFnquNRdt6xwK6pKygH3YibSjLoT_u=P=yceA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/09/2011 20:26, adam radford wrote:
> On Sun, Sep 18, 2011 at 7:56 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com>  wrote:
>> On Sun, 2011-09-18 at 18:25 +0400, James Bottomley wrote:
>>> On Sun, 2011-09-18 at 15:05 +0100, Chris Boot wrote:
>>>>> Hardly ... all it's saying is that twa_exit doesn't wait for pending I/O
>>>>> to complete, so when you remove the module it tears down in the middle
>>>>> of an I/O.  A bug, yes, but it's not indicative of any sort of leak in
>>>>> the maps/unmaps.
>>>>
>>>> James,
>>>>
>>>> I don't think that's the case - I had unmounted all filesystems, deactivated all volume groups, and performed a sync before waiting a few seconds and running rmmod. Next time I'll also 'echo 1>  /sys/block/sdX/device/delete' if that's helpful.
>>> Actually, I take all that back: the driver has a bug in QUEUE_FULL
>>> handling: twa_scsi_queue() calls twa_scsiop_execute_scsi(), which maps
>>> the dma buffer, but if the card responds QUEUE_FULL it just returns
>>> SCSI_MLQUEUE_HOST_BUSY without ever unmapping.  That leg in the code
>>> frees the request but also doesn't unmap it.  In fact any error return
>>> from twa_scsiop_execute_scsi() seems to have the same problem (but
>>> QUEUE_FULL is the only silent one).
>>>
>>> I trust Adam will fix this.
>> Actually, while Adam's mulling this, try the following.  It should at
>> least confirm we're on the right track.
>>
>> James
>>
>> ---
>>
>> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
>> index b7bd5b0..3868ab2 100644
>> --- a/drivers/scsi/3w-9xxx.c
>> +++ b/drivers/scsi/3w-9xxx.c
>> @@ -1800,10 +1800,12 @@ static int twa_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
>>         switch (retval) {
>>         case SCSI_MLQUEUE_HOST_BUSY:
>>                 twa_free_request_id(tw_dev, request_id);
>> +               twa_unmap_scsi_data(tw_dev, request_id);
>>                 break;
>>         case 1:
>>                 tw_dev->state[request_id] = TW_S_COMPLETED;
>>                 twa_free_request_id(tw_dev, request_id);
>> +               twa_unmap_scsi_data(tw_dev, request_id);
>>                 SCpnt->result = (DID_ERROR<<  16);
>>                 done(SCpnt);
>>                 retval = 0;
>>
>>
>>
> James,
>
> Your patch looks correct.
>
> Acked-by: Adam Radford<aradford@gmail.com>
>
> -Adam

Reported-by: Chris Boot <bootc@bootc.net>
Tested-by: Chris Boot <bootc@bootc.net>

-- 
Chris Boot
bootc@bootc.net

