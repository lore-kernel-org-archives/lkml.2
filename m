Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab2C3FLE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 01:11:04 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:35834 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab2C3FLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 01:11:01 -0400
Message-ID: <4F75405F.3050803@linux.vnet.ibm.com>
Date: Fri, 30 Mar 2012 13:10:55 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 08/13] KVM: MMU: fask check whether page is writable
References: <4F742951.7080003@linux.vnet.ibm.com> <4F742A74.1050304@linux.vnet.ibm.com> <4F74847A.1030809@redhat.com>
In-Reply-To: <4F74847A.1030809@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12032918-9264-0000-0000-000001273B86
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 11:49 PM, Avi Kivity wrote:

> On 03/29/2012 11:25 AM, Xiao Guangrong wrote:
>> Using PTE_LIST_WRITE_PROTECT bit in rmap store the write-protect status to
>> avoid unnecessary shadow page walking
> 
> Does kvm_set_pte_rmapp() need adjustment?
> 


Yes, in kvm_set_pte_rmapp(), if the page is host write-protected, it will
set this bit:

static void host_page_write_protect(u64 *spte, unsigned long *rmapp)
{
	if (!(*spte & SPTE_HOST_WRITEABLE) &&
	      !(*rmapp & PTE_LIST_WRITE_PROTECT))
		*rmapp |= PTE_LIST_WRITE_PROTECT;
}

It is very useful for fast page fault path to avoid useless shadow
page table waling if KSM is enabled.

>> Also if no shadow page is indirect, the page is write-free
>>
>>
>> +	if (!vcpu->kvm->arch.indirect_shadow_pages)
>> +		return 0;
>> +
> Best in its own little patch.
> 

Okay, will split it into a little patch.

