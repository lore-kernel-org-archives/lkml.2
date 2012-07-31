Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab2GaUaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 16:30:35 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:43630 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab2GaUae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 16:30:34 -0400
Message-ID: <50184085.5000806@gmail.com>
Date: Tue, 31 Jul 2012 22:31:01 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120730 Thunderbird/14.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com
Subject: Re: [RFC 1/4] hashtable: introduce a small and naive hashtable
References: <1343757920-19713-1-git-send-email-levinsasha928@gmail.com> <1343757920-19713-2-git-send-email-levinsasha928@gmail.com> <20120731182330.GD21292@google.com>
In-Reply-To: <20120731182330.GD21292@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 08:23 PM, Tejun Heo wrote:
> Hello, Sasha.
> 
> On Tue, Jul 31, 2012 at 08:05:17PM +0200, Sasha Levin wrote:
>> +#define HASH_INIT(name)							\
>> +({									\
>> +	int __i;							\
>> +	for (__i = 0 ; __i < HASH_SIZE(name) ; __i++)			\
>> +		INIT_HLIST_HEAD(&name[__i]);				\
>> +})
> 
> Why use macro?
> 
>> +#define HASH_ADD(name, obj, key)					\
>> +	hlist_add_head(obj, &name[					\
>> +		hash_long((unsigned long)key, HASH_BITS(name))]);
> 
> Ditto.

No special reason, I'll modify both to be functions.

>> +#define HASH_GET(name, key, type, member, cmp_fn)			\
>> +({									\
>> +	struct hlist_node *__node;					\
>> +	typeof(key) __key = key;					\
>> +	type *__obj = NULL;						\
>> +	hlist_for_each_entry(__obj, __node, &name[			\
>> +			hash_long((unsigned long) __key,		\
>> +			HASH_BITS(name))], member)			\
>> +		if (cmp_fn(__obj, __key))				\
>> +			break;						\
>> +	__obj;								\
>> +})
> 
> Wouldn't it be simpler to have something like the following
> 
> 	hash_for_each_possible_match(pos, hash, key)
> 
> and let the caller handle the actual comparison?  Callbacks often are
> painful to use and I don't think the above dancing buys much.

I thought about that, but if you look at the 3 modules I've converted to use this hashtable, I think that the option to provide a callback worked pretty well for all of them, and in my opinion in those cases it looks better than iterating over entries in the code.

Would it make sense to have both methods?

>> +#define HASH_DEL(obj, member)						\
>> +	hlist_del(&obj->member)
> 
> @obj is struct hlist_node in HASH_ADD and the containing type here?
> Most in-kernel generic data containers implement just the container
> itself and let the caller handle the conversions between container
> node and the containing object.  I think it would better not to
> deviate from that.

Agreed, will fix.

>> +#define HASH_FOR_EACH(bkt, node, name, obj, member)			\
>> +	for (bkt = 0; bkt < HASH_SIZE(name); bkt++)			\
>> +		hlist_for_each_entry(obj, node, &name[i], member)
> 
> Why in caps?  Most for_each macros are in lower case.

No special reason, will fix that as well.

Thanks for the review Tejun!

> Thanks.
> 

