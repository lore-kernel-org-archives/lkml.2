Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab2FMDLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 23:11:34 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:38814 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab2FMDLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 23:11:33 -0400
Message-ID: <4FD804D7.5000802@linux.vnet.ibm.com>
Date: Wed, 13 Jun 2012 11:11:19 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 5/9] KVM: MMU: introduce SPTE_MMU_WRITEABLE bit
References: <4FC470C7.5040700@linux.vnet.ibm.com> <4FC4716A.8030304@linux.vnet.ibm.com> <20120611233212.GA29573@amt.cnet> <4FD6A833.6060206@linux.vnet.ibm.com> <20120613020103.GB3119@amt.cnet>
In-Reply-To: <20120613020103.GB3119@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12061217-0260-0000-0000-000001555AA9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2012 10:01 AM, Marcelo Tosatti wrote:

> On Tue, Jun 12, 2012 at 10:23:47AM +0800, Xiao Guangrong wrote:
>> On 06/12/2012 07:32 AM, Marcelo Tosatti wrote:
>>
>>> On Tue, May 29, 2012 at 02:49:14PM +0800, Xiao Guangrong wrote:
>>>> This bit indicates whether the spte can be writable on MMU, that means
>>>> the corresponding gpte is writable and the corresponding gfn is not
>>>> protected by shadow page protection
>>>
>>> Why is this still necessary, now that only sptes of direct shadow pages 
>>> are updated locklessly? 
>>>
>>
>>
>> Yes, but it is still needed, for nested npt/ept, we need protect
>> the nested page tables.
> 
> Sure, but shadowed L1 nested pagetables are not direct shadow pages.
> 
> They are shadows of L1 nested pagetables. 
> 
> Checking sp->direct should be enough (instead of the flags).
> 

Hi Marcelo,

I think it is not enough, for example:

- In host (L0), spte1 is pointing to gfn1, spte1 is a direct spte.

- in L1, L1 guest is using gfn1 in L1's ept page table for L2 guest,
  so, in host, we have a indirect spte (named spte2) whose sp->gfn = gfn1.

Since spte2 is a indirect spte, we need protect it, so, we walk all gfn1's
rmaps, spte1 will be found, then, we write-protect on spte1 to track L1
modifying gfn1.

In this case, spte1 is direct but need write-protect. :)

