Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030795Ab2GLTty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 15:49:54 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:44182 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030782Ab2GLTtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 15:49:50 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: Stevie Trujillo <stevie.trujillo@gmail.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: mount -o loop with truncated dosdisk.img uses 100% cpu and can't be killed
References: <20120712162828.3f561315@localhost>
	<1342106206.2156.2.camel@iscandar.digidescorp.com>
	<87k3y8yed3.fsf@devron.myhome.or.jp>
	<1342121986.2156.20.camel@iscandar.digidescorp.com>
Date: Fri, 13 Jul 2012 04:49:47 +0900
In-Reply-To: <1342121986.2156.20.camel@iscandar.digidescorp.com> (Steven
	J. Magnani's message of "Thu, 12 Jul 2012 14:39:46 -0500")
Message-ID: <87fw8wyd2c.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Steven J. Magnani" <steve@digidescorp.com> writes:

>> The following patch fixes it? If it fix, there are some options to check
>> it.
>> 
>> a) Check it like this patch and warn.
>> b) (a), but without warn.
>> c) Check it in init_page_buffers() and return -EIO or such
>> 
>> Well, anyway, Cc to Jens.
>> 
>> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>> ---
>> 
>>  fs/buffer.c |    7 +++++++
>>  1 file changed, 7 insertions(+)
>> 
>> diff -puN fs/buffer.c~debug fs/buffer.c
>> --- tux3fs/fs/buffer.c~debug	2012-07-13 04:10:40.000000000 +0900
>> +++ tux3fs-hirofumi/fs/buffer.c	2012-07-13 04:11:50.000000000 +0900
>> @@ -1055,6 +1055,13 @@ __getblk_slow(struct block_device *bdev,
>>  		dump_stack();
>>  		return NULL;
>>  	}
>> +	if (block >= blkdev_max_block(I_BDEV(bdev->bd_inode))) {
>> +		printk(KERN_ERR "getblk(): block %llu, end_block %llu\n",
>> +		       (unsigned long long)block,
>> +		       (unsigned long long)blkdev_max_block(I_BDEV(bdev->bd_inode)));
>> +		dump_stack();
>> +		return NULL;
>> +	}
>>  
>>  	for (;;) {
>>  		struct buffer_head * bh;
>> _
>
> This fixes the hang, but I'm not sure dump_stack() is a good idea. I get
> almost 100 lines of stack dumps and error messages in my kernel log.
> Also, I was a little surprised to see that mount completes successfully.

So, it sounds like the good choice would be (b) or (c). Well, I guess
Jens would choose what to do.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
