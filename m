Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030247Ab2CBPM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 10:12:59 -0500
Received: from mga03.intel.com ([143.182.124.21]:44389 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758388Ab2CBPM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 10:12:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="113841024"
Message-ID: <4F50E376.3030000@intel.com>
Date: Fri, 02 Mar 2012 23:12:54 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: jeremy@goop.org, "asit.k.mallick@intel.com" <asit.k.mallick@intel.com>,
        "x86@kernel.org" <x86@kernel.org>, tglx@linutronix.de,
        Andi Kleen <ak@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [RFC patch] cmpxchg_double: remove local variables to get better
 performance
References: <1330677063.21053.1532.camel@debian> <4F5098B80200007800075F33@nat28.tlf.novell.com> <1330678843.21053.1553.camel@debian> <4F509CE30200007800075F84@nat28.tlf.novell.com>
In-Reply-To: <4F509CE30200007800075F84@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2012 05:11 PM, Jan Beulich wrote:

>>>> On 02.03.12 at 10:00, Alex Shi <alex.shi@intel.com> wrote:
>> Yes, we can use cast for intermediate data. And actually, current kernel
>> has live mis-used case on cmpxchg(), that I plan to point out too. 
>>
>> -- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -203,12 +203,12 @@ static bool make_all_cpus_request(struct kvm *kvm, 
>> unsigned int req)
>>
>>  void kvm_flush_remote_tlbs(struct kvm *kvm)
>>  {
>> -       int dirty_count = kvm->tlbs_dirty;
>> +       long dirty_count = kvm->tlbs_dirty;
>>
>>         smp_mb();
>>         if (make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH))
>>                 ++kvm->stat.remote_tlb_flush;
>> -       cmpxchg(&kvm->tlbs_dirty, dirty_count, 0);
>> +       cmpxchg(&kvm->tlbs_dirty, dirty_count, 0L);
> 
> Indeed - the cmpxchg would fail if the value doesn't fit. But this is not
> to say that in certain cases it isn't valid to pass an int for the second
> and/or third argument. (And quite likely the issue here is theoretical
> only anyway.)


It may cause potential issue, if it is tlbs_dirty mis-used here, not
dirty_count. If so, it may cause data damage.

> 
> In particular, requiring an L suffix here on literals should be avoided.


Even the each macro may save 0x40 bytes text, and bring more 10%
execution speed?

> 
> Jan
> 
>>  }
> 
> 


