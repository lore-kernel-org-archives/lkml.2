Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab0FACdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 22:33:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59780 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752898Ab0FACdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 22:33:03 -0400
Message-ID: <4C04708F.1090405@cn.fujitsu.com>
Date: Tue, 01 Jun 2010 10:29:35 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/5] KVM: MMU: split the operations of kvm_mmu_zap_page()
References: <4C025BDC.1020304@cn.fujitsu.com> <4C025C24.9010200@cn.fujitsu.com> <4C026543.20608@redhat.com> <4C031B5D.3000502@cn.fujitsu.com> <4C039816.5090101@redhat.com>
In-Reply-To: <4C039816.5090101@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
  
> 
> It would be better to rewrite kvm_mmu_zap_page() in terms of
> prepare/commit in the patch so we don't have two copies of the same
> thing (also easier to review).

OK, i'll do it in the next version.

> 
> 
> 
> 
>>> This is a good idea, but belongs in a separate patch?  We can use it to
>>> reclaim invalid pages before allocating new ones.
>>>
>>>      
>> This patch is very simple and kvm_mmu_commit_zap_page() function
>> should depend on
>> kvm->arch.invalid_mmu_pages, so i think we on need separate this
>> patch, your opinion? :-)
>>
>>    
> 
> How about passing the list as a parameter to prepare() and commit()?  If
> the lifetime of the list is just prepare/commit, it shouldn't be a global.
> 

Does below example code show your meaning correctly?

+	struct list_head free_list = LIST_HEAD_INIT(&free_list);

	hlist_for_each_entry_safe(sp, node, nn, bucket, hash_link) {
		if (sp->gfn == gfn && !sp->role.direct
		    && !sp->role.invalid) {
			pgprintk("%s: zap %lx %x\n",
				 __func__, gfn, sp->role.word);
+			kvm_mmu_prepare_zap_page(kvm, sp, &free_list);
		}
	}
+	kvm_mmu_commit_zap_page(kvm, &free_list);


Thanks,
Xiao


