Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931Ab1IBBOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 21:14:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:29763 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932809Ab1IBBO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 21:14:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,316,1312182000"; 
   d="scan'208";a="47872384"
Message-ID: <4E602DF2.809@intel.com>
Date: Fri, 02 Sep 2011 09:14:26 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110820 Iceowl/1.0b2 Icedove/3.1.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH -mm 1/2] irq_work, Use llist in irq_work
References: <1314681384-20881-1-git-send-email-ying.huang@intel.com>			 <1314681384-20881-2-git-send-email-ying.huang@intel.com>		 <1314785405.23993.21.camel@twins> <4E5EE409.3060102@intel.com>		 <4E5EFA08.30205@intel.com> <1314863927.7945.11.camel@twins>	 <4E5F48D1.801@intel.com> <1314871035.7945.14.camel@twins>
In-Reply-To: <1314871035.7945.14.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2011 05:57 PM, Peter Zijlstra wrote:
> On Thu, 2011-09-01 at 16:56 +0800, Huang Ying wrote:
>> Something as follow with llist_empty() seems not work.
>>
>>   empty = llist_empty(irq_work_list);
>>   llist_add(&work->llnode, irq_work_list);
>>   if (empty)
>>           arch_irq_work_raise();
>>
>> Because irq_work IRQ handler or timer IRQ handler may be executed just
>> before "llist_add(&work->llnode, irq_work_list)", so that, although
>> "empty == false", arch_irq_work_raise() still should be executed.
> 
> Right, I was thinking:
> 
> 	llist_add(&work->llist, irq_work_list);
> 	if (llist_empty(&work->llist))
> 		arch_irq_work_raise();
> 
> And then ran into the difference between llist_node and llist_head. Now
> we could sort that by introducing llist_next() and write it like:
> 
> 	if (!llist_next(&work->list))
> 		arch_irq_work_raise();
> 

This reveals some implementation details of llist.  But it will reveal
some implementation details to make llist_add() return whether list is
empty before adding as Mathieu pointed out.  So I think something like
this or just to check work->list->next should be acceptable.

Best Regards,
Huang Ying
