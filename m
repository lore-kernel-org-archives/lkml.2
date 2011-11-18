Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab1KRGnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 01:43:11 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59639 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab1KRGnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 01:43:10 -0500
Message-ID: <4EC5FE6A.3080003@openvz.org>
Date: Fri, 18 Nov 2011 10:42:50 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20111010 Iceape/2.0.14
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mm: account reaped page cache on inode cache pruning
References: <20111116134713.8933.34389.stgit@zurg> <20111117162322.1c3e3d05.akpm@linux-foundation.org>
In-Reply-To: <20111117162322.1c3e3d05.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 16 Nov 2011 17:47:13 +0300
> Konstantin Khlebnikov<khlebnikov@openvz.org>  wrote:
>
>> Inode cache pruning indirectly reclaims page-cache by invalidating mapping pages.
>> Let's account them into reclaim-state to notice this progress in memory reclaimer.
>>
>> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
>> ---
>>   fs/inode.c |    2 ++
>>   1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/inode.c b/fs/inode.c
>> index ee4e66b..1f6c48d 100644
>> --- a/fs/inode.c
>> +++ b/fs/inode.c
>> @@ -692,6 +692,8 @@ void prune_icache_sb(struct super_block *sb, int nr_to_scan)
>>   	else
>>   		__count_vm_events(PGINODESTEAL, reap);
>>   	spin_unlock(&sb->s_inode_lru_lock);
>> +	if (current->reclaim_state)
>> +		current->reclaim_state->reclaimed_slab += reap;
>>
>>   	dispose_list(&freeable);
>>   }
>
> hm, yes, I suppose we should.
>
> It seems to be cheating to use the "reclaimed_slab" field for this.
> Perhaps it would be cleaner to add an additional field to reclaim_state
> for non-slab pages which were also reclaimed.  That's a cosmetic thing
> and I guess we don't need to go that far, not sure...

Do we really need separate on-stack reclaim_state structure with single field?
Maybe replace it with single long (or even unsigned int) .reclaimed_pages field on task_struct
and account reclaimed pages unconditionally.

>
>

