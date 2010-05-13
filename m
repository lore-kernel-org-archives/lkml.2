Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759549Ab0EMWr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 18:47:27 -0400
Received: from crca.org.au ([74.207.252.120]:46088 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075Ab0EMWrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 18:47:24 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4BEC8173.4070500@crca.org.au>
Date: Fri, 14 May 2010 08:47:15 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Matt Reimer <mattjreimer@gmail.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while
 userspace is frozen?
References: <AANLkTimW3wLEt-DIRirHic1ZN1Z0k1t3TavwaCxTh_QL@mail.gmail.com>	<Pine.LNX.4.44L0.1005131752160.1731-100000@iolanthe.rowland.org> <AANLkTimBxoCCeT_ns30JTIGKqgkiRIvKTf4LfE3mopkS@mail.gmail.com>
In-Reply-To: <AANLkTimBxoCCeT_ns30JTIGKqgkiRIvKTf4LfE3mopkS@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 14/05/10 08:20, Matt Reimer wrote:
> On Thu, May 13, 2010 at 2:54 PM, Alan Stern<stern@rowland.harvard.edu>  wrote:
>> On Thu, 13 May 2010, Matt Reimer wrote:
>>
>>> So how does the attached patch look?
>>>
>>> Matt
>>>
>>>
>>>  From 20d8340471eb05aa54af1349f4ddccecd9c230c6 Mon Sep 17 00:00:00 2001
>>> From: Matt Reimer<mreimer@sdgsystems.com>
>>> Date: Thu, 13 May 2010 14:36:54 -0700
>>> Subject: [PATCH] fs: prevent hang on suspend/resume when MMC/SD card present
>>>
>>> Devices can come and go from the MMC/SD bus during suspend or resume,
>>> when the writeback thread is frozen, resulting in a hang. So thaw the
>>> writeback thread in del_gendisk() to prevent the hang.
>>
>> I don't see anything wrong with the patch itself, but I dislike the
>> description.  Devices can come and go from any hotpluggable bus, not
>> just MMC/SD.  That just happens to be the first place the problem was
>> observed.
>
> Good point. How about this?
>
> Matt
>
>> From 813bd223e5a2fa577b9e64ddf12654a93d0aab8b Mon Sep 17 00:00:00 2001
> From: Matt Reimer<mreimer@sdgsystems.com>
> Date: Thu, 13 May 2010 14:36:54 -0700
> Subject: [PATCH] fs: prevent hang on suspend/resume when MMC/SD card present
>
> Devices can come and go bus during suspend or resume, when the
> writeback thread is frozen, resulting in a hang. Prevent the hang
> by thawing the writeback thread in del_gendisk().
>
> Signed-off-by: Matt Reimer<mreimer@sdgsystems.com>
> ---
>   fs/partitions/check.c |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/fs/partitions/check.c b/fs/partitions/check.c
> index e238ab2..b303919 100644
> --- a/fs/partitions/check.c
> +++ b/fs/partitions/check.c
> @@ -666,6 +666,8 @@ void del_gendisk(struct gendisk *disk)
>          struct disk_part_iter piter;
>          struct hd_struct *part;
>
> +       thaw_process(disk->queue->backing_dev_info.wb.task);
> +
>          /* invalidate stuff */
>          disk_part_iter_init(&piter, disk,
>                               DISK_PITER_INCL_EMPTY | DISK_PITER_REVERSE);
>

Why not just make it unfreezeable to start with?

Regards,

Nigel
