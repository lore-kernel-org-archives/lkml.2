Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934129Ab1ETRf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 13:35:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:17701 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828Ab1ETRfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 13:35:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,243,1304319600"; 
   d="scan'208";a="439888682"
Message-ID: <4DD6A678.6090801@linux.intel.com>
Date: Fri, 20 May 2011 10:35:52 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: richard -rw- weinberger <richard.weinberger@gmail.com>,
        =?ISO-8859-15?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: kernel 2.6.39 (user mode linux) crashes (2.6.38 works fine)
References: <201105191526.31904.toralf.foerster@gmx.de>	 <201105192218.18261.toralf.foerster@gmx.de>	 <20110519204342.GA10792@home.goodmis.org>	 <201105200937.15322.toralf.foerster@gmx.de>	 <BANLkTik0oz6ppJvRpufaaiBL1pqcAxNHuA@mail.gmail.com>	 <4DD68EDF.4030301@linux.intel.com> <1305907458.1465.23.camel@gandalf.stny.rr.com>
In-Reply-To: <1305907458.1465.23.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/20/2011 09:04 AM, Steven Rostedt wrote:
> On Fri, 2011-05-20 at 08:55 -0700, Darren Hart wrote:
> 
>> I suspect Toralf is hitting the WARN_ON in __unqueue_futex:
>>
>> 	if (WARN_ON(!q->lock_ptr || !spin_is_locked(q->lock_ptr)
>> 			|| plist_node_empty(&q->list)))
>>
>> Toralf, can you instrument that let us know which of conditions is
>> triggering the WARN_ON? Something like the following should be adequate
>> to get you the line number. I suspect it is plist_node_empty give the
>> git bisect results you reported.
>>
>>
>> diff --git a/kernel/futex.c b/kernel/futex.c
>> index abd5324..7f31bca 100644
>> --- a/kernel/futex.c
>> +++ b/kernel/futex.c
>> @@ -782,8 +782,11 @@ static void __unqueue_futex(struct futex_q *q)
>>  {
>>  	struct futex_hash_bucket *hb;
>>
>> -	if (WARN_ON(!q->lock_ptr || !spin_is_locked(q->lock_ptr)
>> -			|| plist_node_empty(&q->list)))
>> +	if (WARN_ON(!q->lock_ptr))
>> +		return;
>> +	if (!spin_is_locked(q->lock_ptr))
>> +		return;
>> +	if (plist_node_empty(&q->list))
>>  		return;
>>
> 

Whoops, there should have been WARN_ON's in all the if blocks... duh.

> Wait! This is where we need the WARN_ON_SMP(), do we have that patch in?

Hrm, I thought he said he was on 2.6.39-rc-something. Those patches went
in pre 2.6.39-rc1 according to gitk.

> 
> I think UML is UP, and that spin_is_locked() will always return false.
> 
> -- Steve
> 
> 

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
