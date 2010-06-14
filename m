Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab0FNPfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 11:35:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab0FNPfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 11:35:02 -0400
Message-ID: <4C164C22.1050503@redhat.com>
Date: Mon, 14 Jun 2010 18:34:58 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: balbir@linux.vnet.ibm.com, kvm <kvm@vger.kernel.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/T/D][PATCH 2/2] Linux/Guest cooperative unmapped page cache
 control
References: <20100608155140.3749.74418.sendpatchset@L34Z31A.ibm.com>	 <20100608155153.3749.31669.sendpatchset@L34Z31A.ibm.com>	 <4C10B3AF.7020908@redhat.com> <20100610142512.GB5191@balbir.in.ibm.com>	 <1276214852.6437.1427.camel@nimitz>	 <20100611045600.GE5191@balbir.in.ibm.com> <4C15E3C8.20407@redhat.com>	 <20100614084810.GT5191@balbir.in.ibm.com> <1276528376.6437.7176.camel@nimitz>
In-Reply-To: <1276528376.6437.7176.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 06:12 PM, Dave Hansen wrote:
> On Mon, 2010-06-14 at 14:18 +0530, Balbir Singh wrote:
>    
>> 1. A slab page will not be freed until the entire page is free (all
>> slabs have been kfree'd so to speak). Normal reclaim will definitely
>> free this page, but a lot of it depends on how frequently we are
>> scanning the LRU list and when this page got added.
>>      
> You don't have to be freeing entire slab pages for the reclaim to have
> been useful.  You could just be making space so that _future_
> allocations fill in the slab holes you just created.  You may not be
> freeing pages, but you're reducing future system pressure.
>    

Depends.  If you've evicted something that will be referenced soon, 
you're increasing system pressure.

> If unmapped page cache is the easiest thing to evict, then it should be
> the first thing that goes when a balloon request comes in, which is the
> case this patch is trying to handle.  If it isn't the easiest thing to
> evict, then we _shouldn't_ evict it.
>    

Easy to evict is just one measure.  There's benefit (size of data 
evicted), cost to refill (seeks, cpu), and likelihood that the cost to 
refill will be incurred (recency).

It's all very complicated.  We need better information to make these 
decisions.  For one thing, I'd like to see age information tied to 
objects.  We may have two pages that were referenced in wildly different 
times be next to each other in LRU order.  We have many LRUs, but no 
idea of the relative recency of the tails of those LRUs.

If each page or object had an age, we could scale those ages by the 
benefit from reclaim and cost to refill and make a better decision as to 
what to evict first.  But of course page->age means increasing sizeof 
struct page, and we can only approximate its value by scanning the 
accessed bit, not determine it accurately (unlike the other objects 
managed by the cache).

-- 
error compiling committee.c: too many arguments to function

