Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab0IBNX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 09:23:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:51432 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012Ab0IBNX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 09:23:26 -0400
Message-ID: <4C7FA531.7060300@kernel.org>
Date: Thu, 02 Sep 2010 15:22:57 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
CC: Mike Snitzer <snitzer@redhat.com>, jaxboe@fusionio.com,
        j-nomura@ce.jp.nec.com, jamie@shareable.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-raid@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH UPDATED 4/5] dm: implement REQ_FLUSH/FUA support for request-based
 dm
References: <1283162296-13650-1-git-send-email-tj@kernel.org> <1283162296-13650-5-git-send-email-tj@kernel.org> <20100830132836.GB5283@redhat.com> <4C7BB932.1070405@kernel.org> <4C7BD202.4040700@kernel.org> <4C7DFD8F.6070200@ct.jp.nec.com>
In-Reply-To: <4C7DFD8F.6070200@ct.jp.nec.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 02 Sep 2010 13:23:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/01/2010 09:15 AM, Kiyoshi Ueda wrote:
> I don't see any obvious problem on this patch.
> However, I hit a NULL pointer dereference below when I use a mpath
> device with barrier option of ext3.  I'm investigating the cause now.
> (Also I'm not sure the cause of the hang which Mike is hitting yet.)
> 
> I tried on the commit 28dd53b26d362c16234249bad61db8cbd9222d0b of
> git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git flush-fua.
> 
>     # mke2fs -j /dev/mapper/mpatha
>     # mount -o barrier=1 /dev/mapper/mpatha /mnt/0
>     # dd if=/dev/zero of=/mnt/0/a bs=512 count=1
>     # sync

Hmm... I'm trying to reproduce this problem but hasn't been successful
yet.

> BUG: unable to handle kernel NULL pointer dereference at 0000000000000078
> IP: [<ffffffffa0070ec3>] scsi_finish_command+0xa3/0x120 [scsi_mod]

Can you please ask gdb which source line this is?

> Also, I have one comment below on this patch.
> 
>> @@ -2619,9 +2458,8 @@ int dm_suspend(struct mapped_device *md,
>>  	up_write(&md->io_lock);
>>
>>  	/*
>> -	 * Request-based dm uses md->wq for barrier (dm_rq_barrier_work) which
>> -	 * can be kicked until md->queue is stopped.  So stop md->queue before
>> -	 * flushing md->wq.
>> +	 * Stop md->queue before flushing md->wq in case request-based
>> +	 * dm defers requests to md->wq from md->queue.
>>  	 */
>>  	if (dm_request_based(md))
>>  		stop_queue(md->queue);
> 
> Request-based dm doesn't use md->wq now, so you can just remove
> the comment above.

I sure can remove it but md->wq already has most stuff necessary to
process deferred requests and when someone starts using it, having the
comment there about the rather delicate ordering would definitely be
helpful, so I suggest keeping the comment.

Thanks.

-- 
tejun

