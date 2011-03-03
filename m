Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab1CCC1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 21:27:23 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:38687 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab1CCC1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 21:27:21 -0500
Message-ID: <4D6EFC4B.30505@ce.jp.nec.com>
Date: Thu, 03 Mar 2011 11:26:19 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] Fix mapping->writeback_index to point to the last written
 page
References: <4D676067.8050200@ce.jp.nec.com> <20110302221808.GG7496@quack.suse.cz>
In-Reply-To: <20110302221808.GG7496@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

thank you for the comments.

On 03/03/11 07:18, Jan Kara wrote:
> On Fri 25-02-11 16:55:19, Jun'ichi Nomura wrote:
>> I think it's intended for sequential writer.
>   Not exactly. The code is meant so that background writeback gets to
> writing the end of a file which gets continuously dirtied (if we always
> started at the beginning, nr_to_write could always get to 0 before we reach
> end of the file).

Ah, ok. Thanks.
My patch doesn't break the above goal.

>> Otherwise, the last written page was left dirty until the writeback
>> wraps around.
>>
>> I.e. if the sequential dirtier has written on pagecache as '*'s below:
>>
>>    |*******|*******|****---|-------|-------|     ( |---| is a page )
>>
>> then, writeback happens:
>>
>>    |-------|-------|-------|-------|-------|
>>
>> and the dirtier continues:
>>
>>    |-------|-------|----***|*******|*****--|
>>                    A       B
>>
>> Next writeback should start from page A, not B.
>   Yes, this is downside of our current scheme. Have you actually observed
> it in practice or is it mostly a theoretic concern?

Half practical, half theoretic.
It has been observed with a real application, which uses a big ring file.

I took a trace with a test program for example:

[1st writeback session]
       ...
       flush-8:0-2743  4571: block_bio_queue: 8,0 W 94898514 + 8
       flush-8:0-2743  4571: block_bio_queue: 8,0 W 94898522 + 8
       flush-8:0-2743  4571: block_bio_queue: 8,0 W 94898530 + 8
       flush-8:0-2743  4571: block_bio_queue: 8,0 W 94898538 + 8
       flush-8:0-2743  4571: block_bio_queue: 8,0 W 94898546 + 8
     kworker/0:1-11    4571: block_rq_issue: 8,0 W 0 () 94898514 + 40
>>     flush-8:0-2743  4571: block_bio_queue: 8,0 W 94898554 + 8
>>     flush-8:0-2743  4571: block_rq_issue: 8,0 W 0 () 94898554 + 8

[2nd writeback session after 35sec]
       flush-8:0-2743  4606: block_bio_queue: 8,0 W 94898562 + 8
       flush-8:0-2743  4606: block_bio_queue: 8,0 W 94898570 + 8
       flush-8:0-2743  4606: block_bio_queue: 8,0 W 94898578 + 8
       ...
     kworker/0:1-11    4606: block_rq_issue: 8,0 W 0 () 94898562 + 640
     kworker/0:1-11    4606: block_rq_issue: 8,0 W 0 () 94899202 + 72
       ...
       flush-8:0-2743  4606: block_bio_queue: 8,0 W 94899962 + 8
       flush-8:0-2743  4606: block_bio_queue: 8,0 W 94899970 + 8
       flush-8:0-2743  4606: block_bio_queue: 8,0 W 94899978 + 8
       flush-8:0-2743  4606: block_bio_queue: 8,0 W 94899986 + 8
       flush-8:0-2743  4606: block_bio_queue: 8,0 W 94899994 + 8
     kworker/0:1-11    4606: block_rq_issue: 8,0 W 0 () 94899962 + 40
>>     flush-8:0-2743  4606: block_bio_queue: 8,0 W 94898554 + 8
>>     flush-8:0-2743  4606: block_rq_issue: 8,0 W 0 () 94898554 + 8

The 1st writeback ended at block 94898562. (94898554+8)
The 2nd writeback started there.
However, since the last page at the 1st writeback was just redirtied,
the 2nd writeback looped back to block 94898554 after sequentially
submitting blocks from 94898562 to 94900001.

1 extra seek which could be avoided.
I haven't seen fatal problem with the latest kernel, though.

With older kernels (before 2.6.29, without commit 31a12666),
kupdate leaves the dirty pages like spots until the application wraps
around the ring. (It could take hours to days.)
That led me to this code.

> But as I'm thinking about it, it wouldn't harm our original aim to do
> what you propose and it can help this relatively common case. So I think
> it's a good idea. Fengguang, what do you think?

--
Jun'ichi Nomura, NEC Corporation 
