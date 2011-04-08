Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab1DHBDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 21:03:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:35018 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757142Ab1DHBDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 21:03:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,320,1299484800"; 
   d="scan'208";a="625292510"
Message-ID: <4D9E5EED.7030301@intel.com>
Date: Fri, 08 Apr 2011 09:03:41 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110303 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -v2 2/4] lib, Add lock-less NULL terminated single list
References: <1302139746-1030-1-git-send-email-ying.huang@intel.com> <1302139746-1030-3-git-send-email-ying.huang@intel.com> <20110407183034.GA6104@Krystal>
In-Reply-To: <20110407183034.GA6104@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mathieu,

Thanks for review.

On 04/08/2011 02:30 AM, Mathieu Desnoyers wrote:
> * Huang Ying (ying.huang@intel.com) wrote:
[snip]
>> +/**
>> + * llist_for_each - iterate over some deleted entries of a lock-less list
>> + * @pos:     the &struct llist_node to use as a loop cursor
>> + * @node:    the first entry of deleted list entries
>> + *
>> + * In general, some entries of the lock-less list can be traversed
>> + * safely only after being deleted from list, so start with an entry
>> + * instead of list head.
>> + *
>> + * If being used on entries deleted from lock-less list directly, the
>> + * traverse order is from the newest to the oldest added entry.  If
>> + * you want to traverse from the oldest to the newest, you must
>> + * reverse the order by yourself before traversing.
>> + */
>> +#define llist_for_each(pos, node)                    \
>> +     for (pos = (node); pos; pos = pos->next)
> 
> I know list.h has the same lack of ( ) around "pos" in the for_each
> iterator, but shouldn't we add some around it to ensure that especially
> (pos)->next uses the right operator prececence ? e.g.
> 
>         for ((pos) = (node); pos; (pos) = (pos)->next)
> 
> maybe there is some reason for not putting parenthesis there that I am
> missing, but I'm asking anyway.

Don't know either.  But I think there should be no harm to add
parenthesis here.  Will change this and similar code in patch.

[snip]
>> +/**
>> + * llist_empty - tests whether a lock-less list is empty
>> + * @head:    the list to test
>> + *
>> + * Not guaranteed to be accurate or up to date.  Just a quick way to
>> + * test whether the list is empty without deleting something from the
>> + * list.
>> + */
>> +static inline int llist_empty(const struct llist_head *head)
>> +{
>> +     return head->first == NULL;
> 
> Would it make sense to do:
> 
>  return ACCESS_ONCE(head->first) == NULL;
> 
> instead ? Otherwise the compiler can choose to keep the result around in
> registers without re-reading (e.g. busy waiting loop).

Although I think that llist_empty() in a loop is not the typical usage
model, adding ACCESS_ONCE can support that better without other harm.  I
will change this.

[snip]
>> + * The basic atomic operation of this list is cmpxchg on long.  On
>> + * architectures that don't have NMI-safe cmpxchg implementation, the
>> + * list can NOT be used in NMI handler.  So code uses the list in NMI
>> + * handler should depend on CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG.
>> + *
>> + * Copyright 2010 Intel Corp.
> 
> 2010, 2011

Will change this.

[snip]
>> +/**
>> + * llist_add - add a new entry
>> + * @new:     new entry to be added
>> + * @head:    the head for your lock-less list
>> + */
>> +void llist_add(struct llist_node *new, struct llist_head *head)
>> +{
>> +     struct llist_node *entry;
>> +
>> +#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
>> +     BUG_ON(in_nmi());
>> +#endif
>> +
>> +     do {
>> +             entry = head->first;
>> +             new->next = entry;
>> +             cpu_relax();
>> +     } while (cmpxchg(&head->first, entry, new) != entry);
> 
> Could be turned into:
> 
> struct llist_node *entry, *old_entry;
> 
> entry = head->first;
> 
> do {
>         old_entry = entry;
>         new->next = entry;
>         cpu_relax();
> } while ((entry = cmpxchg(&head->first, old_entry, new)) != old_entry);
> 
> It should generate more compact code, and slightly faster retry.

Yes. Will change this and similar code in patch.

Best Regards,
Huang Ying
