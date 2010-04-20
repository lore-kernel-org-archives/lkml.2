Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab0DTJcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 05:32:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588Ab0DTJcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 05:32:05 -0400
Message-ID: <4BCD748E.7080007@redhat.com>
Date: Tue, 20 Apr 2010 12:31:58 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Peter Zijlstra <peterz@infradead.org>, Glauber Costa <glommer@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>	 <1271356648-5108-2-git-send-email-glommer@redhat.com>	 <4BC8CA52.4090703@goop.org> <1271673545.1674.743.camel@laptop>	 <4BCC3584.1050501@redhat.com> <1271675100.1674.818.camel@laptop>	 <4BCC3A3E.9070909@redhat.com>	 <20100419142158.GD14158@mothafucka.localdomain>	 <4BCC69D5.3050209@redhat.com> <1271688411.1488.248.camel@laptop> <4BCC8246.9040202@goop.org>
In-Reply-To: <4BCC8246.9040202@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 07:18 PM, Jeremy Fitzhardinge wrote:
> On 04/19/2010 07:46 AM, Peter Zijlstra wrote:
>    
>> What avi says! :-)
>>
>> On a 32bit machine a 64bit read are two 32bit reads, so
>>
>>    last = last_value;
>>
>> becomes:
>>
>>    last.high = last_value.high;
>>    last.low  = last_vlue.low;
>>
>> (or the reverse of course)
>>
>> Now imagine a write getting interleaved with that ;-)
>>
>>      
> You could explicitly do:
>
> 	do {
> 		h = last.high;
> 		barrier();
> 		l = last.low;
> 		barrier();
> 	} while (last.high != h);
>
>
> This works because we expect last to be always increasing, so the only
> worry is low wrapping and incrementing high, and is more efficient than
> making the read fully atomic (the write is still cmpxchg64).  But it's
> pretty ugly to open code just for 32b architectures; its something that
> might be useful to turn into a general abstraction (monotonic_read_64
> FTW!).  I already have code like this in the Xen time code, so I could
> make immediate use of it.
>    

I don't think this is worthwhile - the cmpxchg is not that expensive on 
most kvm capable hosts (the exception is the Pentium D).

btw, do you want this code in pvclock.c, or shall we keep it kvmclock 
specific?

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

