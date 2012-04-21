Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab2DUDZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 23:25:00 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:53619 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab2DUDY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 23:24:59 -0400
Message-ID: <4F922886.5060807@gmail.com>
Date: Sat, 21 Apr 2012 11:24:54 +0800
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 2/9] KVM: MMU: abstract spte write-protect
References: <4F911B74.4040305@linux.vnet.ibm.com> <4F911BAB.6000206@linux.vnet.ibm.com> <20120420213319.GA13817@amt.cnet>
In-Reply-To: <20120420213319.GA13817@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2012 05:33 AM, Marcelo Tosatti wrote:


>>  static bool
>>  __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level)
>>  {
>> @@ -1050,24 +1078,13 @@ __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level)
>>
>>  	for (sptep = rmap_get_first(*rmapp, &iter); sptep;) {
>>  		BUG_ON(!(*sptep & PT_PRESENT_MASK));
>> -		rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);
>> -
>> -		if (!is_writable_pte(*sptep)) {
>> -			sptep = rmap_get_next(&iter);
>> -			continue;
>> -		}
>> -
>> -		if (level == PT_PAGE_TABLE_LEVEL) {
>> -			mmu_spte_update(sptep, *sptep & ~PT_WRITABLE_MASK);
>> -			sptep = rmap_get_next(&iter);
>> -		} else {
>> -			BUG_ON(!is_large_pte(*sptep));
>> -			drop_spte(kvm, sptep);
>> -			--kvm->stat.lpages;
> 
> It is preferable to remove all large sptes including read-only ones, the


It can cause page faults even if read memory on these large sptse.

Actually, Avi suggested that make large writable spte to be readonly
(not dropped) on this path.

> current behaviour, then to verify that no read->write transition can
> occur in fault paths (fault paths which are increasing in number).


Yes, the small spte also has issue (find a write-protected spte in
fault paths). Later, the second part of this patchset will introduce
rmap.WRITE_PROTECTED bit, then we can do the fast check before calling
fast page fault.

