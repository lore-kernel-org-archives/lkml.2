Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab0FLClv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 22:41:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61038 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751982Ab0FLClt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 22:41:49 -0400
Message-ID: <4C12F319.6010401@cn.fujitsu.com>
Date: Sat, 12 Jun 2010 10:38:17 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 4/7] KVM: MMU: don't mark pte notrap if it's just sync
 transient
References: <4C1239EE.3090904@cn.fujitsu.com> <4C123ABA.3000601@cn.fujitsu.com> <20100611201420.GD12317@amt.cnet>
In-Reply-To: <20100611201420.GD12317@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Marcelo Tosatti wrote:
> On Fri, Jun 11, 2010 at 09:31:38PM +0800, Xiao Guangrong wrote:
>> If the sync-sp just sync transient, don't mark its pte notrap
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h |    2 +-
>>  arch/x86/kvm/mmu.c              |   11 ++++-------
>>  arch/x86/kvm/paging_tmpl.h      |    5 +++--
>>  3 files changed, 8 insertions(+), 10 deletions(-)
> 
> Xiao,
> 
> Can you explain the reasoning for this? 
> 

Marcelo,

In the kvm_sync_page_transient() path, the sp is keep unsync and sp->gfn is not
write protected, we can't set 'spte == shadow_notrap_nonpresent_pte' if the 
'gpte.p == 0' in this case.

It's because if 'gpte.p == 0', when guest change the gpte's mapping, it's no need
to flush tlb(p == 0 means the mapping is not in tlb), if we set spte to
'shadow_notrap_nonpresent_pte', we will miss the chance to update the mapping, also
a incorrect #PF will pass to guest directly, may cause guest crash.

And, this is the reasoning we do mmu_convert_notrap() in kvm_sync_page_transient()
before, this patch just avoid this unnecessary workload. :-)

