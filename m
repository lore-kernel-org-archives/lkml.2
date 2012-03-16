Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032545Ab2CPHa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 03:30:56 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:58665 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032330Ab2CPHax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 03:30:53 -0400
Message-ID: <4F62EC25.5060306@linux.vnet.ibm.com>
Date: Fri, 16 Mar 2012 15:30:45 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: avi@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] KVM: Switch to srcu-less get_dirty_log()
References: <20120301193007.04b2db8e.yoshikawa.takuya@oss.ntt.co.jp> <20120301193316.96682d60.yoshikawa.takuya@oss.ntt.co.jp> <4F62C9B4.7060804@linux.vnet.ibm.com> <20120316155511.70455b4a.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120316155511.70455b4a.yoshikawa.takuya@oss.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12031521-1396-0000-0000-000000D32566
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 02:55 PM, Takuya Yoshikawa wrote:

> On Fri, 16 Mar 2012 13:03:48 +0800
> Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:
> 
>> For my quickly review, mmu_lock can not protect everything, if the guest page
> 
> Yes and ...
> 
>> is written out of the shadow page/ept table, dirty page will be lost.
> 
> No.
> 
>>
>> There is a example:
>>
>>              CPU A                                   CPU  B
>> guest page is written by write-emulation
>>
>>                                                   hold mmu-lock and see dirty-bitmap
>>                                                   is not be changed, then migration is
>>                                                   completed.
> 
> We do not allow this break.
> 


Hmm? what can avoid this? Could you please point it out?


>>
>> call mark_page_dirty() to set dirty_bit map
>>
>>
>> Right?
> 
> 
> As you pointed out, we cannot assume mutual exclusion by mmu_lock.
> That is why we are using atomic bitmap operations: xchg and set_bit.
> 
> In this sense we are at least guaranteed to get the dirty page
> information in dirty_bitmap - the current one or next one.
> 


The problem is the guest page is written before dirty-bitmap is set,
we may log the dirty page in this window like above case...

> So what we should care about is to not miss the information written in
> the next bitmap at the time we actually migrate the guest.
> 


Actually, the way log dirty page in MMU page-table is tricky:

set dirty-bitmap

allow spte to be writeable

page can be written

That means we always set dirty-bitmap _before_ page become dirty that is
the reason why your bitmap-way can work.

> Actually the userspace stops the guest at the final stage and then send the
> remaining pages found in the bitmap.  So the above break between write and
> mark_page_dirty() cannot happen IIUC.
> 


Maybe i'd better firstly understand why "We do not allow this break" :)


