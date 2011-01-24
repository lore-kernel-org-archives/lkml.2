Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab1AXTJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 14:09:26 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:38321 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384Ab1AXTJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 14:09:25 -0500
X-ASG-Debug-ID: 1295896162-01de290b79f6700001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D3DCE5D.9090708@fusionio.com>
Date: Mon, 24 Jan 2011 20:09:17 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH 10/10] fs: make aio plug
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>	<1295659049-2688-11-git-send-email-jaxboe@fusionio.com> <x497hdugp32.fsf@segfault.boston.devel.redhat.com>
X-ASG-Orig-Subj: Re: [PATCH 10/10] fs: make aio plug
In-Reply-To: <x497hdugp32.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1295896162
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.4348 1.0000 0.0000
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.53327
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-24 18:59, Jeff Moyer wrote:
> Jens Axboe <jaxboe@fusionio.com> writes:
> 
>> From: Shaohua Li <shaohua.li@intel.com>
>>
>> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
>> Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
>> ---
>>  fs/aio.c |    4 ++++
>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/aio.c b/fs/aio.c
>> index c5ea494..1476bed 100644
>> --- a/fs/aio.c
>> +++ b/fs/aio.c
>> @@ -1660,6 +1660,7 @@ long do_io_submit(aio_context_t ctx_id, long nr,
>>  	long ret = 0;
>>  	int i;
>>  	struct hlist_head batch_hash[AIO_BATCH_HASH_SIZE] = { { 0, }, };
>> +	struct blk_plug plug;
>>  
>>  	if (unlikely(nr < 0))
>>  		return -EINVAL;
>> @@ -1676,6 +1677,8 @@ long do_io_submit(aio_context_t ctx_id, long nr,
>>  		return -EINVAL;
>>  	}
>>  
>> +	blk_start_plug(&plug);
>> +
>>  	/*
>>  	 * AKPM: should this return a partial result if some of the IOs were
>>  	 * successfully submitted?
>> @@ -1698,6 +1701,7 @@ long do_io_submit(aio_context_t ctx_id, long nr,
>>  		if (ret)
>>  			break;
>>  	}
>> +	blk_finish_plug(&plug);
>>  	aio_batch_free(batch_hash);
> 
> I'm pretty sure you want blk_finish_plug to run after aio_batch_free.

You mean to cover the iput()? That's not a bad idea, if that ends up
writing it out. I did a few read tests here and confirmed it's sending
down batches of whatever number is submitted.

-- 
Jens Axboe

