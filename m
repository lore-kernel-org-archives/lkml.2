Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197Ab1CDBqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 20:46:00 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:59649 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759156Ab1CDBp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 20:45:59 -0500
Message-ID: <4D70443A.1010602@ce.jp.nec.com>
Date: Fri, 04 Mar 2011 10:45:30 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Wu Fengguang <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Fix mapping->writeback_index to point to the last written
 page
References: <4D676067.8050200@ce.jp.nec.com> <20110302221808.GG7496@quack.suse.cz> <4D6EFC4B.30505@ce.jp.nec.com> <20110303133119.GA16562@localhost> <20110303140802.GA27751@quack.suse.cz>
In-Reply-To: <20110303140802.GA27751@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/11 23:08, Jan Kara wrote:
> On Thu 03-03-11 21:31:19, Wu Fengguang wrote:
>> On Thu, Mar 03, 2011 at 10:26:19AM +0800, Jun'ichi Nomura wrote:
>>         >        flush-8:0-2743  4606: block_bio_queue: 8,0 W 94899962 + 8
>>         >        flush-8:0-2743  4606: block_bio_queue: 8,0 W 94899970 + 8
>>         >        flush-8:0-2743  4606: block_bio_queue: 8,0 W 94899978 + 8
>>         >        flush-8:0-2743  4606: block_bio_queue: 8,0 W 94899986 + 8
>>         >        flush-8:0-2743  4606: block_bio_queue: 8,0 W 94899994 + 8
>> ==>     >      kworker/0:1-11    4606: block_rq_issue: 8,0 W 0 () 94899962 + 40
>>         > >>     flush-8:0-2743  4606: block_bio_queue: 8,0 W 94898554 + 8
>> ==>     > >>     flush-8:0-2743  4606: block_rq_issue: 8,0 W 0 () 94898554 + 8
>>
>> I'd expect the wrapped around 94898554+8 to be merged with 94899962+8.
>   How could they be merged? They are not continguous...
> 
>> Why kworker/0:1-11 is submitting the request early? And the second
>> request is submitted by flush-8:0-2743.
>   I'm not sure about that either - but I think that kworker is submitting
> the work when unplug happens while flush ends up doing it when the queue is
> alredy unplugged.

Yes. For the above case, it was unplug.

For other cases, the reason was max_sectors.
Before writeback wraps around, the request has already grown to
max_sectors size (~512KB) and doesn't accept new merge.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
