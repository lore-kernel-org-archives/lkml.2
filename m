Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772Ab0FQIn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 04:43:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932715Ab0FQIny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 04:43:54 -0400
Message-ID: <4C19E023.2040403@redhat.com>
Date: Thu, 17 Jun 2010 11:43:15 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC][PATCH 4/9] create aggregate kvm_total_used_mmu_pages value
References: <20100615135518.BC244431@kernel.beaverton.ibm.com>	 <20100615135523.25D24A73@kernel.beaverton.ibm.com>	 <4C188FC0.3050306@redhat.com> <1276700761.6437.16878.camel@nimitz>
In-Reply-To: <1276700761.6437.16878.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 06:06 PM, Dave Hansen wrote:
>
>
>>> +static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
>>> +{
>>> +	kvm->arch.n_used_mmu_pages += nr;
>>> +	kvm_total_used_mmu_pages += nr;
>>>
>>>        
>> Needs an atomic operation, since there's no global lock here.  To avoid
>> bouncing this cacheline around, make the variable percpu and make
>> readers take a sum across all cpus.  Side benefit is that you no longer
>> need an atomic but a local_t, which is considerably cheaper.
>>      
> That's a good point.  All of the modifications are done under locks, but
> the fast path isn't any more.  I'll fix it up.
>
>    

Note, even before you moved the shrinker out of the lock, this was a 
problem.  kvm_mod_used_mmu_pages() is called not just from the shrinker 
code, we zap pages for other reasons as well.

-- 
error compiling committee.c: too many arguments to function

