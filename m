Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab2DERzG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 13:55:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46938 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab2DERzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 13:55:03 -0400
Message-ID: <4F7DDC6C.90304@gmail.com>
Date: Fri, 06 Apr 2012 01:54:52 +0800
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 08/13] KVM: MMU: fask check whether page is writable
References: <4F742951.7080003@linux.vnet.ibm.com> <4F742A74.1050304@linux.vnet.ibm.com> <4F7879A1.2020301@redhat.com>
In-Reply-To: <4F7879A1.2020301@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi,

Thanks very much for your review!

Sorry for the delay reply since i was on vacation.

On 04/01/2012 11:52 PM, Avi Kivity wrote:

> On 03/29/2012 11:25 AM, Xiao Guangrong wrote:
>> Using PTE_LIST_WRITE_PROTECT bit in rmap store the write-protect status to
>> avoid unnecessary shadow page walking
>>
>> Also if no shadow page is indirect, the page is write-free
>>
>>
>> @@ -2262,6 +2291,9 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
>>  	}
>>  	if (need_unsync)
>>  		kvm_unsync_pages(vcpu, gfn);
>> +
>> +	*rmap &= ~PTE_LIST_WRITE_PROTECT;
>> +
>>
> 
> So what are the rules for PTE_LIST_WRITE_PROTECT?  Is is a cache for the
> mmu_need_write_protect?
> 
> I'd like to understand it, I guess it can be set while write protection
> is unneeded, and cleared on the next check?
> 


Yes, it is used as a cache for mmu_need_write_protect.

When the gfn is protected by sync sp or read-only host page we set this bit,
and it is be cleared when the sp become unsync or host page becomes writable.

> Maybe split into two functions, one the normal mmu_need_write_protect
> (but renamed) and a new mmu_need_write_protect(), with locked and
> unlocked variants, calling the old one.
> 


Okay, i will split it by introducing a new function named mmu_unsync_gfn_sp
which checks whether sp can become unsync and unsync sp if it is allowed under
the protection of mmu-lock.

