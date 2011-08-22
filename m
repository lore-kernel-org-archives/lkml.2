Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab1HVUTB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 16:19:01 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52945 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753668Ab1HVUTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 16:19:00 -0400
Message-ID: <4E52BA31.4030203@cn.fujitsu.com>
Date: Tue, 23 Aug 2011 04:21:05 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 03/11] KVM: x86: retry non-page-table writing instruction
References: <4E4A10E8.5090705@cn.fujitsu.com> <4E4A113F.5090404@cn.fujitsu.com> <20110822195929.GA2662@amt.cnet>
In-Reply-To: <20110822195929.GA2662@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-23 04:17:58,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-23 04:17:58,
	Serialize complete at 2011-08-23 04:17:58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2011 03:59 AM, Marcelo Tosatti wrote:

>> +	if (!vcpu->arch.mmu.direct_map && !mmu_is_nested(vcpu))
>> +		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2, NULL);
> 
> Why write? 
> 

Since the fault is caused by page table written, and the 'gpa' can
be written after instruction is retied.

>> +	kvm_mmu_unprotect_page(vcpu->kvm, gpa >> PAGE_SHIFT);
>> +
>> +	/*
>> +	 * The shadow pages have been zapped, then we call the page
>> +	 * fault path to change the mapping to writable.
>> +	 */
>> +	vcpu->arch.mmu.page_fault(vcpu, cr2, PFERR_WRITE_MASK, true);
> 
> I don't see why is this necessary. Just allowing the instruction to
> proceed should be enough?
> 

It used to avoid later VM-exit, since we will retry the instruction
but the mapped is still read-only. So we can it to let the mapping become
writable to avoid page fault again.
