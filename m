Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab1HLTTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 15:19:13 -0400
Received: from mx2.parallels.com ([64.131.90.16]:56843 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754234Ab1HLTTJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 15:19:09 -0400
Message-ID: <4E457C9E.7060002@parallels.com>
Date: Fri, 12 Aug 2011 16:18:54 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <containers@lists.linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@parallels.com>,
        David Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 3/4] limit nr_dentries per superblock
References: <1312504544-1108-1-git-send-email-glommer@parallels.com>  <1312504544-1108-4-git-send-email-glommer@parallels.com> <1313157412.2354.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
In-Reply-To: <1313157412.2354.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [187.25.233.177]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2011 10:56 AM, Eric Dumazet wrote:
> Le vendredi 05 août 2011 à 04:35 +0400, Glauber Costa a écrit :
>> This patch lays the foundation for us to limit the dcache size.
>> Each super block can have only a maximum amount of dentries under its
>> sub-tree. Allocation fails if we we're over limit and the cache
>> can't be pruned to free up space for the newcomers.
>>
>> Signed-off-by: Glauber Costa<glommer@parallels.com>
>> CC: Dave Chinner<david@fromorbit.com>
>> ---
>>   fs/dcache.c        |   25 +++++++++++++++++++++++++
>>   fs/super.c         |    1 +
>>   include/linux/fs.h |    1 +
>>   3 files changed, 27 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/dcache.c b/fs/dcache.c
>> index ac19d24..52a0faf 100644
>> --- a/fs/dcache.c
>> +++ b/fs/dcache.c
>> @@ -1180,6 +1180,28 @@ void shrink_dcache_parent(struct dentry * parent)
>>   }
>>   EXPORT_SYMBOL(shrink_dcache_parent);
>>
>> +static int dcache_mem_check(struct super_block *sb)
>> +{
>> +	int i;
>> +	int nr_dentry;
>> +	struct shrink_control sc = {
>> +		.gfp_mask = GFP_KERNEL,
>> +	};
>> +
>> +	do {
>> +		nr_dentry = 0;
>> +		for_each_possible_cpu(i)
>> +			nr_dentry += per_cpu(*sb->s_nr_dentry, i);
>
> You seriously want to call this for every __d_alloc() invocation,
> even if s_nr_dentry_max is the default value (INT_MAX) ?

Well, I guess that special-casing INT_MAX is a good thing.
I can include it in the next submission, I like it. Thanks.

> On a 4096 cpu machine, it will be _very_ slow.
>
> A percpu_counter would be the thing to consider, since you can avoid the
> for_each_possible_cpu(i) loop if percpu_counter_read() is smaller than
> sb->s_nr_dentry_max.
>
> Check how its done in include/net/tcp.h, tcp_too_many_orphans()

Yeah, I guess I could do that. In fact, my first series used 
percpu_counters, and then I switched. But looking back, percpu_counters
are indeed more suitable. The goal back then was trying to avoid 
percpu_counter_add, but as it is right now, we trade it for an even 
worse thing.

Thank you for your comments.
