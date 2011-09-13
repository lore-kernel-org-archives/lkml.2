Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab1IMKV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 06:21:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53617 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751131Ab1IMKV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 06:21:58 -0400
Message-ID: <4E6F2F54.4030004@cn.fujitsu.com>
Date: Tue, 13 Sep 2011 18:24:20 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 01/11] KVM: MMU: avoid pte_list_desc running out in
 kvm_mmu_pte_write
References: <4E5C4C20.3000403@cn.fujitsu.com> <4E6F2790.4020602@redhat.com>
In-Reply-To: <4E6F2790.4020602@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-13 18:20:38,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-13 18:20:39,
	Serialize complete at 2011-09-13 18:20:39
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2011 05:51 PM, Avi Kivity wrote:
> On 08/30/2011 05:34 AM, Xiao Guangrong wrote:
>> kvm_mmu_pte_write is unsafe since we need to alloc pte_list_desc in the
>> function when spte is prefetched, unfortunately, we can not know how many
>> spte need to be prefetched on this path, that means we can use out of the
>> free  pte_list_desc object in the cache, and BUG_ON() is triggered, also some
>> path does not fill the cache, such as INS instruction emulated that does not
>> trigger page fault
>>
>> @@ -3716,10 +3735,6 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u32 error_code,
>>           goto out;
>>       }
>>
>> -    r = mmu_topup_memory_caches(vcpu);
>> -    if (r)
>> -        goto out;
>> -
>>       er = x86_emulate_instruction(vcpu, cr2, 0, insn, insn_len);
>>
> 
> Suppose we are out of memory, can't this get us in an endless loop?
> 
> return -ENOMEM breaks as out (and kills the guest, likely).
> 

If memory is not enough, we just clear sptes on pte_write path(not prefetch spte),
the later page fault path can return -1 to let guest crash. Hmm?

