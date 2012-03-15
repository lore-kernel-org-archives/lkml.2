Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161232Ab2COSmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 14:42:32 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55722 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161044Ab2COSmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 14:42:31 -0400
Message-ID: <1331836868.2215.43.camel@aks>
Subject: Re: [RFC 1/2] kvm: host-side changes for tmem on KVM
From: Akshay Karle <akshay.a.karle@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, Dan Magenheimer <dan.magenheimer@oracle.com>,
        kvm@vger.kernel.org, ashu tripathi <er.ashutripathi@gmail.com>,
        nishant gulhane <nishant.s.gulhane@gmail.com>,
        Shreyas Mahure <shreyas.mahure@gmail.com>,
        amarmore2006 <amarmore2006@gmail.com>,
        mahesh mohan <mahesh6490@gmail.com>
Date: Fri, 16 Mar 2012 00:11:08 +0530
In-Reply-To: <20120315165400.GL30250@phenom.dumpdata.com>
References: <1331225648.2585.27.camel@aks>
	 <20120315165400.GL30250@phenom.dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Working at host:
>> Once the guest exits to the kvm host, the host determines that the guest exited
>> to perform some tmem operation(done at kvm_emulate_hypercall)and then
>> we use zcache to implement this required operations(performed by kvm_pv_tmem_op).
>
> Do you need any modifications to the Kconfig file to reflect the KVM dependency?

Yeah, the Kconfig of zcache now needs to be modified to reflect the KVM and the KVM_INTEL or
KVM_AMD dependency. The Kconfig can also be modified to support tmem for the guest kernels,
as the zcache code is not at all used in the guest, only the kvm-tmem, cleancache and
frontswap(if present) code is used in the guest. But, in the host its necessary to enable zcache.
So the Kconfig can be modified to have the following new field:
"Transcendent memory support for kvm guests".... Which would compile just the kvm-tmem code.
And we can add Cleancache and Frontswap as dependencies(similar to zcache).

But it should be made sure that the host kernel has zcache enabled..

>> diff -Napur vanilla/linux-3.1.5/arch/x86/kvm/x86.c linux-3.1.5//arch/x86/kvm/x86.c
>> --- vanilla/linux-3.1.5/arch/x86/kvm/x86.c	2011-12-09 22:27:05.000000000 +0530
>> +++ linux-3.1.5//arch/x86/kvm/x86.c	2012-03-05 14:09:41.652006083 +0530
>> @@ -5267,6 +5267,10 @@ int kvm_emulate_hypercall(struct kvm_vcp
>>  	case KVM_HC_MMU_OP:
>>  		r = kvm_pv_mmu_op(vcpu, a0, hc_gpa(vcpu, a1, a2), &ret);
>>  		break;
>> +	case KVM_HC_TMEM:
>> +		r = kvm_pv_tmem_op(vcpu, a0, &ret);
>> +		ret = ret - 1000;
>
> That is rather odd. Why the subtraction of 1000?

The reason for the subtraction is that the kvm hypercalls were able to return only negative
values. Any return of non-negative value resulted in guest kernel panic. We couldn't figure
out why? Suggestions to remove this would help improvise..
We could've just returned -ret but when the tmem_op returned 0 it wouldn't work so the,
ret - 1000.

>> @@ -669,7 +670,6 @@ static struct zv_hdr *zv_create(struct x
>>       int chunks = (alloc_size + (CHUNK_SIZE - 1)) >> CHUNK_SHIFT;
>>       int ret;
>>  
>> -     BUG_ON(!irqs_disabled());
>
> Can you explain why?

Zcache is by default used in the non-virtualized environment for page compression. Whenever
a page is to be evicted from the page cache the spin_lock_irq is held on the page mapping.
To ensure that this is done, the BUG_ON(!irqs_disabled()) was used.
But now the situation is different, we are using zcache functions for kvm VM's.
So if any page of the guest is to be evicted the irqs should be disabled in just that
guest and not the host, so we removed the BUG_ON(!irqs_disabled()); line.

>> @@ -1934,10 +1993,19 @@ static int __init no_frontswap(char *s)
>>  
>>  __setup("nofrontswap", no_frontswap);
>>  
>> +static int kvm_tmem_enabled = 0;
>
> No need to declare it zero. Don't we want to have it running by default?
> So the function below would be 'disable_kvm' instead of enabling it?

This can be enabled by default only if the Kconfig was modified as described above.
As the user may not want tmem enabled by default we chose to keep it zero.
>> +
>> +static int __init enable_kvm_tmem(char *s)
>> +{
>> +	kvm_tmem_enabled = 1;
>> +	return 1;
>> +}
>> +
>> +__setup("kvmtmem", enable_kvm_tmem);
>> +
>>  static int __init zcache_init(void)
>>  {
>>  	int ret = 0;
>> -
>>  #ifdef CONFIG_SYSFS
>>  	ret = sysfs_create_group(mm_kobj, &zcache_attr_group);
>>  	if (ret) {

