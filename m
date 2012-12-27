Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab2L0WlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 17:41:11 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:35668 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab2L0WlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 17:41:09 -0500
Message-ID: <50DCCE5A.4000805@oracle.com>
Date: Thu, 27 Dec 2012 17:40:26 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        Joonsoo Kim <js1304@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm, bootmem: panic in bootmem alloc functions even
 if slab is available
References: <1356293711-23864-1-git-send-email-sasha.levin@oracle.com> <1356293711-23864-2-git-send-email-sasha.levin@oracle.com> <alpine.DEB.2.00.1212271423210.18214@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1212271423210.18214@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2012 05:25 PM, David Rientjes wrote:
> On Sun, 23 Dec 2012, Sasha Levin wrote:
> 
>> diff --git a/mm/bootmem.c b/mm/bootmem.c
>> index 1324cd7..198a92f 100644
>> --- a/mm/bootmem.c
>> +++ b/mm/bootmem.c
>> @@ -763,9 +763,6 @@ void * __init ___alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
>>  void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
>>  				   unsigned long align, unsigned long goal)
>>  {
>> -	if (WARN_ON_ONCE(slab_is_available()))
>> -		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
>> -
>>  	return  ___alloc_bootmem_node(pgdat, size, align, goal, 0);
>>  }
>>  
> 
> All you're doing is removing the fallback if this happens to be called 
> with slab_is_available().  It's still possible that the slab allocator can 
> successfully allocate the memory, though.  So it would be rather 
> unfortunate to start panicking in a situation that used to only emit a 
> warning.
> 
> Why can't you panic only kzalloc_node() returns NULL and otherwise just 
> return the allocated memory?

That's exactly what happens with the patch. Note that in the current upstream
version there are several slab checks scattered all over.

In this case for example, I'm removing it from __alloc_bootmem_node(), but the
first code line of__alloc_bootmem_node_nopanic() is:

        if (WARN_ON_ONCE(slab_is_available()))
                return kzalloc(size, GFP_NOWAIT);

So the current behaviour is still preserved, but the code is simplified to
have only one place that allocates memory (both from the slab and from bootmem),
instead of having slab allocations sprinkled all over.


Thanks,
Sasha
