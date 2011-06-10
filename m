Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759Ab1FJEVD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 00:21:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62151 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab1FJEVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 00:21:01 -0400
Message-ID: <4DF19C24.9010007@cn.fujitsu.com>
Date: Fri, 10 Jun 2011 12:23:00 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 10/15] KVM: MMU: lockless walking shadow page table
References: <4DEE205E.8000601@cn.fujitsu.com> <4DEE21E2.8000301@cn.fujitsu.com> <20110609200945.GK2285@linux.vnet.ibm.com>
In-Reply-To: <20110609200945.GK2285@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-10 12:20:44,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-10 12:20:46,
	Serialize complete at 2011-06-10 12:20:46
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2011 04:09 AM, Paul E. McKenney wrote:
> On Tue, Jun 07, 2011 at 09:04:34PM +0800, Xiao Guangrong wrote:
>> Using rcu to protect shadow pages table to be freed, so we can safely walk it,
>> it should run fast and is needed by mmio page fault
> 
> A couple of question below.

Thanks for your review!

>> +	if (atomic_read(&kvm->arch.reader_counter)) {
> 
> This is the slowpath to be executed if there are currently readers
> in kvm->arch.reader_counter(), correct?
> 

Yes, we will free the pages in RCU context if it is in kvm->arch.reader_counter

>> +		free_mmu_pages_unlock_parts(invalid_list);
>> +		sp = list_first_entry(invalid_list, struct kvm_mmu_page, link);
>> +		list_del_init(invalid_list);
>> +		call_rcu(&sp->rcu, free_invalid_pages_rcu);
>> +		return;
>> +	}
> 
> OK, so it also looks like kvm->arch.reader_counter could transition from
> zero to non-zero at this point due to a concurrent call from a reader in
> the kvm_mmu_walk_shadow_page_lockless() function.  Does the following code
> avoid messing up the reader?  If so, why bother with the slowpath above?
> 

Actually, we have split the free operation to two steps, the first step is
kvm_mmu_prepare_zap_page(), it isolates the page from shadow page table, so
after call it, we can not get the page from the shadow page table, and the
later steps is kvm_mmu_commit_zap_page(), it frees the page.

kvm_mmu_walk_shadow_page_lockless() get the page from shadow page table,
so, even if kvm->arch.reader_counter transition from zero to non-zero in
the fallowing code, we can sure the page is not used by
kvm_mmu_walk_shadow_page_lockless(), so we can free the page directly.
