Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab0FNRfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 13:35:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754814Ab0FNRfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 13:35:06 -0400
Message-ID: <4C1659F8.3090300@redhat.com>
Date: Mon, 14 Jun 2010 19:34:00 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: balbir@linux.vnet.ibm.com, kvm <kvm@vger.kernel.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/T/D][PATCH 2/2] Linux/Guest cooperative unmapped page cache
 control
References: <20100608155140.3749.74418.sendpatchset@L34Z31A.ibm.com>	 <20100608155153.3749.31669.sendpatchset@L34Z31A.ibm.com>	 <4C10B3AF.7020908@redhat.com> <20100610142512.GB5191@balbir.in.ibm.com>	 <1276214852.6437.1427.camel@nimitz>	 <20100611045600.GE5191@balbir.in.ibm.com> <4C15E3C8.20407@redhat.com>	 <20100614084810.GT5191@balbir.in.ibm.com> <4C16233C.1040108@redhat.com>	 <20100614125010.GU5191@balbir.in.ibm.com> <4C162846.7030303@redhat.com>	 <1276529596.6437.7216.camel@nimitz>  <4C164E63.2020204@redhat.com> <1276530932.6437.7259.camel@nimitz>
In-Reply-To: <1276530932.6437.7259.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 06:55 PM, Dave Hansen wrote:
> On Mon, 2010-06-14 at 18:44 +0300, Avi Kivity wrote:
>    
>> On 06/14/2010 06:33 PM, Dave Hansen wrote:
>>      
>>> At the same time, I see what you're trying to do with this.  It really
>>> can be an alternative to ballooning if we do it right, since ballooning
>>> would probably evict similar pages.  Although it would only work in idle
>>> guests, what about a knob that the host can turn to just get the guest
>>> to start running reclaim?
>>>        
>> Isn't the knob in this proposal the balloon?  AFAICT, the idea here is
>> to change how the guest reacts to being ballooned, but the trigger
>> itself would not change.
>>      
> I think the patch was made on the following assumptions:
> 1. Guests will keep filling their memory with relatively worthless page
>     cache that they don't really need.
> 2. When they do this, it hurts the overall system with no real gain for
>     anyone.
>
> In the case of a ballooned guest, they _won't_ keep filling memory.  The
> balloon will prevent them.  So, I guess I was just going down the path
> of considering if this would be useful without ballooning in place.  To
> me, it's really hard to justify _with_ ballooning in place.
>    

There are two decisions that need to be made:

- how much memory a guest should be given
- given some guest memory, what's the best use for it

The first question can perhaps be answered by looking at guest I/O rates 
and giving more memory to more active guests.  The second question is 
hard, but not any different than running non-virtualized - except if we 
can detect sharing or duplication.  In this case, dropping a duplicated 
page is worthwhile, while dropping a shared page provides no benefit.

How the patch helps answer either question, I'm not sure.  I don't think 
preferential dropping of unmapped page cache is the answer.

>> My issue is that changing the type of object being preferentially
>> reclaimed just changes the type of workload that would prematurely
>> suffer from reclaim.  In this case, workloads that use a lot of unmapped
>> pagecache would suffer.
>>
>> btw, aren't /proc/sys/vm/swapiness and vfs_cache_pressure similar knobs?
>>      
> Those tell you how to balance going after the different classes of
> things that we can reclaim.
>
> Again, this is useless when ballooning is being used.  But, I'm thinking
> of a more general mechanism to force the system to both have MemFree
> _and_ be acting as if it is under memory pressure.
>    

If there is no memory pressure on the host, there is no reason for the 
guest to pretend it is under pressure.  If there is memory pressure on 
the host, it should share the pain among its guests by applying the 
balloon.  So I don't think voluntarily dropping cache is a good direction.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

