Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab2LLJnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 04:43:14 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:6113 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab2LLJnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 04:43:12 -0500
X-IronPort-AV: E=Sophos;i="4.84,265,1355097600"; 
   d="scan'208";a="81333"
Message-ID: <50C84F2F.4080302@citrix.com>
Date: Wed, 12 Dec 2012 10:32:31 +0100
From: =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH v3] llist: add a safe version of llist_for_each_entry
References: <1355187084.7216.102.camel@yhuang-dev>  <1355225157-23609-1-git-send-email-roger.pau@citrix.com> <1355272642.7216.144.camel@yhuang-dev>
In-Reply-To: <1355272642.7216.144.camel@yhuang-dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/12 01:37, Huang Ying wrote:
> On Tue, 2012-12-11 at 12:25 +0100, Roger Pau Monne wrote:
>> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
>> Cc: Huang Ying <ying.huang@intel.com>
>> Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>
>> ---
>> Changes since v2:
>>  * Allow to pass a NULL node as the first entry of deleted list
>>    entries.
>> ---
>>  include/linux/llist.h |   27 +++++++++++++++++++++++++++
>>  1 files changed, 27 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/llist.h b/include/linux/llist.h
>> index a5199f6..4e0aec1 100644
>> --- a/include/linux/llist.h
>> +++ b/include/linux/llist.h
>> @@ -125,6 +125,33 @@ static inline void init_llist_head(struct llist_head *list)
>>  	     (pos) = llist_entry((pos)->member.next, typeof(*(pos)), member))
>>  
>>  /**
>> + * llist_for_each_entry_safe - safely iterate over some deleted entries of
>> + *                             lock-less list of given type
>> + * @pos:	the type * to use as a loop cursor.
>> + * @n:		the &struct llist_node to use as a temporary loop cursor
> 
> In list_for_each_entry_safe, n is type *, why not follow that?

Thanks for the review, yes I just saw it, I was using llist_node because
I didn't need a type *, but I agree that it's best to stick with
list_for_each_entry_safe interface. Will send v4....

> 
> Best Regards,
> Huang Ying
> 
>> + * @node:	the fist entry of deleted list entries.
>> + * @member:	the name of the llist_node with the struct.
>> + *
>> + * In general, some entries of the lock-less list can be traversed
>> + * safely only after being removed from list, so start with an entry
>> + * instead of list head.
>> + *
>> + * If being used on entries deleted from lock-less list directly, the
>> + * traverse order is from the newest to the oldest added entry.  If
>> + * you want to traverse from the oldest to the newest, you must
>> + * reverse the order by yourself before traversing.
>> + *
>> + * n is used to store a reference to the next item llist_node, so
>> + * pos can be freed while iterating.
>> + */
>> +#define llist_for_each_entry_safe(pos, n, node, member)		\
>> +	for ((pos) = llist_entry((node), typeof(*(pos)), member),	\
>> +	     (n) = (&(pos)->member != NULL) ? (pos)->member.next : NULL;\
>> +	     &(pos)->member != NULL;					\
>> +	     (pos) = llist_entry(n, typeof(*(pos)), member),		\
>> +	     (n) = (&(pos)->member != NULL) ? (pos)->member.next : NULL)
>> +
>> +/**
>>   * llist_empty - tests whether a lock-less list is empty
>>   * @head:	the list to test
>>   *
> 
> 

