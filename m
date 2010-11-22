Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab0KVKOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 05:14:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53882 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab0KVKOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 05:14:08 -0500
Message-ID: <4CEA436D.8050202@cn.fujitsu.com>
Date: Mon, 22 Nov 2010 18:18:21 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 5/6] KVM: MMU: abstract invalid guest pte mapping
References: <4CE63CF4.80502@cn.fujitsu.com> <4CE63DB3.9010100@cn.fujitsu.com> <4CEA37A6.8040204@redhat.com>
In-Reply-To: <4CEA37A6.8040204@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-22 18:14:24,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-22 18:14:24,
	Serialize complete at 2010-11-22 18:14:24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/22/2010 05:28 PM, Avi Kivity wrote:

>> +static bool FNAME(map_invalid_gpte)(struct kvm_vcpu *vcpu,
>> +                    struct kvm_mmu_page *sp, u64 *spte,
>> +                    pt_element_t gpte)
> 
> It's really only for speculative maps, the name should reflect that.
> 

OK, i'll use speculative_map_invalid_gpte or speculative_map_gpte
instead.

> Why restrict to invalid gptes?  Won't it work for valid gptes as well? 
> Maybe you'll need an extra code path for update_pte() which already
> knows the pfn.
> 

Um. i did it in the in the previous version, but it needs a callback to
get pfn since get pfn is very different on update_pte / prefetch_pte /
sync_page paths. the codes seems more complicated.

Maybe we can get pfn first and call FNAME(map_vaild_gpte) later, but
it can add little little overload on prefetch_pte path.

>> +{
>> +    u64 nonpresent = shadow_trap_nonpresent_pte;
>> +
>> +    if (is_rsvd_bits_set(&vcpu->arch.mmu, gpte, PT_PAGE_TABLE_LEVEL))
>> +        goto no_present;
>> +
>> +    if (!is_present_gpte(gpte)) {
>> +        if (!sp->unsync)
>> +            nonpresent = shadow_notrap_nonpresent_pte;
>> +        goto no_present;
>> +    }
> 
> I think the order is reversed.  If !is_present_gpte(), it doesn't matter
> if reserved bits are set or not.
> 

if !is_present_gpte() && is_rsvd_bits_set, then we may mark the spte notrap,
so the guest will detect #PF with PFEC.P=PEFC.RSVD=0, but the appropriate PFEC
is PFEC.P=0 && PEFC.RSVD=1 ?
