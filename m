Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057Ab2DJL64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 07:58:56 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:41709 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab2DJL6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 07:58:54 -0400
Message-ID: <4F842074.1050108@linux.vnet.ibm.com>
Date: Tue, 10 Apr 2012 19:58:44 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 00/13] KVM: MMU: fast page fault
References: <4F742951.7080003@linux.vnet.ibm.com> <4F82E04E.6000900@redhat.com>	<20120409175829.GB21894@amt.cnet> <4F8329D3.7000605@gmail.com>	<20120409194614.GB23053@amt.cnet> <4F840DD2.3090101@redhat.com> <20120410204031.ffb5b976225ac9fe6dae474e@gmail.com>
In-Reply-To: <20120410204031.ffb5b976225ac9fe6dae474e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12041001-5140-0000-0000-0000010AC1D1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2012 07:40 PM, Takuya Yoshikawa wrote:

> On Tue, 10 Apr 2012 13:39:14 +0300
> Avi Kivity <avi@redhat.com> wrote:
> 
>> On 04/09/2012 10:46 PM, Marcelo Tosatti wrote:
>>> Perhaps the mmu_lock hold times by get_dirty are a large component here?
>>> If that can be alleviated, not only RO->RW faults benefit.
>>>
>>>
>>
>> Currently the longest holder in normal use is probably reading the dirty
>> log and write protecting the shadow page tables.
>>
>> We could fix that by switching to O(1) write protection
>> (write-protecting PML4Es instead of PTEs).  It would be interesting to
>> combine O(1) write protection with lockless write-enabling.
>>
> 
> As Marcelo suggested during reviewing srcu-less dirty logging, we can
> mitigate the get_dirty's mmu_lock hold time problem cleanly, locally in
> get_dirty_log(), by using cond_resched_lock() -- although we need to
> introduce cond_rescheck_lock_cb() to conditionally flush TLB.
> 


Although it can reduce the contention but it is not reduce the overload
of dirty-log.


> I have already started that work.
> 
> Actually I introduced rmap based get_dirty for that kind of fine-grained
> contention control.
> 


I do not think this way is better that O(1). Avi has explained the reason
for many times, and i agree with that. :)

> I think we should do our best not to affect mmu so much just for the
> limited time of live migration.
> 


No, i do not really agree with that.

We really can get great benefit from O(1) especially if lockless write-protect
is introduced for O(1), live migration is very useful for cloud computing
architecture to balance the overload on all nodes.

And no reason to disallow us touch the code of MMU, yes, it needs simply
but it does not means stop the development of MMU.

For another hander, the mechanism like your to improve dirty-log also need
introduce lots of code and it does not make MMU clearer. :)

