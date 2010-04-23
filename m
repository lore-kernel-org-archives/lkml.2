Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab0DWDi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 23:38:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52466 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754117Ab0DWDi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 23:38:57 -0400
Message-ID: <4BD11596.90900@cn.fujitsu.com>
Date: Fri, 23 Apr 2010 11:35:50 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/10] KVM MMU: don't write-protect if have new mapping
 to unsync page
References: <4BCFE581.8050305@cn.fujitsu.com> <4BCFE8F0.7010509@cn.fujitsu.com> <20100422192947.GA2280@amt.cnet>
In-Reply-To: <20100422192947.GA2280@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Marcelo Tosatti wrote:

>>  	role = vcpu->arch.mmu.base_role;
>> @@ -1332,12 +1336,16 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>>  	hlist_for_each_entry_safe(sp, node, tmp, bucket, hash_link)
>>  		if (sp->gfn == gfn) {
>>  			if (sp->unsync)
>> -				if (kvm_sync_page(vcpu, sp))
>> -					continue;
>> +				unsync_sp = sp;
> 

Hi Marcelo,

Thanks for your comments, maybe the changlog is not clear, please allow
me explain here.

Two cases maybe happen in kvm_mmu_get_page() function:

- one case is, the goal sp is already in cache, if the sp is unsync,
  we only need update it to assure this mapping is valid, but not
  mark it sync and not write-protect sp->gfn since it not broke unsync
  rule(one shadow page for a gfn)

- another case is, the goal sp not existed, we need create a new sp
  for gfn, i.e, gfn (may)has another shadow page, to keep unsync rule,
  we should sync(mark sync and write-protect) gfn's unsync shadow page.
  After enabling multiple unsync shadows, we sync those shadow pages
  only when the new sp not allow to become unsync(also for the unsyc
  rule, the new rule is: allow all pte page become unsync)

> 
> I don't see a reason why you can't create a new mapping to an unsync
> page. The code already creates shadow pte entries using unsync
> pagetables.

Do you means the case 2? In the original code, it unsync-ed gfn's unsync
page first regardless it's whether broke unsync rule:

|	hlist_for_each_entry_safe(sp, node, tmp, bucket, hash_link)
|		if (sp->gfn == gfn) {
|			if (sp->unsync)
|				if (kvm_sync_page(vcpu, sp))

And, my English is poor, sorry if i misunderstand your comment :-(

Xiao
