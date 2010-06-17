Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677Ab0FQIXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 04:23:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932514Ab0FQIXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 04:23:33 -0400
Message-ID: <4C19DB7D.5020508@redhat.com>
Date: Thu, 17 Jun 2010 11:23:25 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC][PATCH 4/9] create aggregate kvm_total_used_mmu_pages value
References: <20100615135518.BC244431@kernel.beaverton.ibm.com>	 <20100615135523.25D24A73@kernel.beaverton.ibm.com>	 <4C188FC0.3050306@redhat.com> <1276707300.6437.17429.camel@nimitz>
In-Reply-To: <1276707300.6437.17429.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 07:55 PM, Dave Hansen wrote:
> On Wed, 2010-06-16 at 11:48 +0300, Avi Kivity wrote:
>    
>>> +static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
>>> +{
>>> +     kvm->arch.n_used_mmu_pages += nr;
>>> +     kvm_total_used_mmu_pages += nr;
>>>
>>>        
>> Needs an atomic operation, since there's no global lock here.  To avoid
>> bouncing this cacheline around, make the variable percpu and make
>> readers take a sum across all cpus.  Side benefit is that you no longer
>> need an atomic but a local_t, which is considerably cheaper.
>>      
> We do have the stuff in:
>
> 	include/linux/percpu_counter.h
>
> the downside being that they're not precise and they're *HUGE* according
> to the comment. :)
>
> It's actually fairly difficult to do a counter which is precise,
> scalable, and works well for small CPU counts when NR_CPUS is large.  Do
> you mind if we just stick with a plain atomic_t for now?
>    

Do we really need something precise?

I'm not excited by adding a global atomic.  So far nothing in the kvm 
hot paths depends on global shared memory (though we have lots of per-vm 
shared memory).

Can we perhaps query the kmem_cache for a representation of the amount 
of objects?

-- 
error compiling committee.c: too many arguments to function

