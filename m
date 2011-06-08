Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab1FHI4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 04:56:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58887 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752429Ab1FHI4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 04:56:51 -0400
Message-ID: <4DEF39CB.4020109@cn.fujitsu.com>
Date: Wed, 08 Jun 2011 16:58:51 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 04/15] KVM: MMU: cache mmio info on page fault path
References: <4DEE205E.8000601@cn.fujitsu.com> <4DEE20EE.7060000@cn.fujitsu.com> <4FA0E9B8-FBB6-49BD-916C-239599136604@suse.de>
In-Reply-To: <4FA0E9B8-FBB6-49BD-916C-239599136604@suse.de>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-08 16:56:37,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-08 16:56:38,
	Serialize complete at 2011-06-08 16:56:38
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2011 04:22 PM, Alexander Graf wrote:

>> +static int vcpu_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
>> +			   gpa_t *gpa, struct x86_exception *exception,
>> +			   bool write)
>> +{
>> +	u32 access = (kvm_x86_ops->get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
>> +
>> +	if (vcpu_match_mmio_gva(vcpu, gva) &&
>> +	      check_write_user_access(vcpu, write, access,
>> +	      vcpu->arch.access)) {
>> +		*gpa = vcpu->arch.mmio_gfn << PAGE_SHIFT |
>> +					(gva & (PAGE_SIZE - 1));
>> +		return 1;
> 

Hi Alexander,

Thanks for your review!

> Hrm. Let me try to understand what you're doing.
> 
> Whenever a guest issues an MMIO, it triggers an #NPF or #PF and then we walk either the NPT or the guest PT to resolve the GPA to the fault and send off an MMIO.
> Within that path, you remember the GVA->GPA mapping for the last MMIO request. If the next MMIO request is on the same GVA and kernel/user permissions still apply, you simply bypass the resolution. So far so good.
> 

In this patch, we also introduced vcpu_clear_mmio_info() that clears mmio cache info on the vcpu,
and it is called when guest flush tlb (reload CR3 or INVLPG). 

> Now, what happens when the GVA is not identical to the GVA it was before? It's probably a purely theoretic case, but imagine the following:
> 
>   1) guest issues MMIO on GVA 0x1000 (GPA 0x1000)
>   2) guest remaps page 0x1000 to GPA 0x2000
>   3) guest issues MMIO on GVA 0x1000
> 

If guest modify the page structure, base on x86 tlb rules, we should flush tlb to ensure the cpu use
the new mapping.

When you remap GVA 0x1000 to 0x2000, you should flush tlb, then mmio cache info is cleared, so the later
access is right.

> That would break with your current implementation, right? It sounds pretty theoretic, but imagine the following:
> 
>   1) guest user space 1 maps MMIO region A to 0x1000
>   2) guest user space 2 maps MMIO region B to 0x1000
>   3) guest user space 1 issues MMIO on 0x1000
>   4) context switch; going to user space 2
>   5) user space 2 issues MMIO on 0x1000
> 

Also, when context switched, CR3 is reloaded, mmio cache info can be cleared too. right? :-)
