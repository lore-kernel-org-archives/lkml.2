Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab1HWKxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 06:53:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61768 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752446Ab1HWKxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 06:53:34 -0400
Message-ID: <4E53872B.3070407@cn.fujitsu.com>
Date: Tue, 23 Aug 2011 18:55:39 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 11/11] KVM: MMU: improve write flooding detected
References: <4E4A10E8.5090705@cn.fujitsu.com> <4E4A1257.5080204@cn.fujitsu.com> <20110823080024.GA2297@amt.cnet>
In-Reply-To: <20110823080024.GA2297@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-23 18:52:31,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-23 18:52:31,
	Serialize complete at 2011-08-23 18:52:31
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcelo,

On 08/23/2011 04:00 PM, Marcelo Tosatti wrote:
> On Tue, Aug 16, 2011 at 02:46:47PM +0800, Xiao Guangrong wrote:
>> Detecting write-flooding does not work well, when we handle page written, if
>> the last speculative spte is not accessed, we treat the page is
>> write-flooding, however, we can speculative spte on many path, such as pte
>> prefetch, page synced, that means the last speculative spte may be not point
>> to the written page and the written page can be accessed via other sptes, so
>> depends on the Accessed bit of the last speculative spte is not enough
> 
> Yes, a stale last_speculative_spte is possible, but is this fact a
> noticeable problem in practice?
> 
> Was this detected by code inspection?
> 

I detected this because: i noticed some shadow page is zapped by
write-flooding but it is accessed soon, it causes the shadow page zapped
and alloced again and again(very frequently).

Another reason is that: in current code, write-flooding is little complex
and it stuffs code in many places, actually, write-flooding is only needed for
shadow page/nested guest, so i want to simplify it and wrap its code up.

>> -	}
>> +	if (spte && !(*spte & shadow_accessed_mask))
>> +		sp->write_flooding_count++;
>> +	else
>> +		sp->write_flooding_count = 0;
> 
> This relies on the sptes being created by speculative means
> or by pressure on the host clearing the accessed bit for the
> shadow page to be zapped. 
> 
> There is no guarantee that either of these is true for a given
> spte.
> 
> And if the sptes do not have accessed bit set, any nonconsecutive 3 pte
> updates will zap the page.
> 

Please note we clear 'sp->write_flooding_count' when it is accessed from
shadow page cache (in kvm_mmu_get_page), it means if any spte of sp generates
#PF, the fooding count can be reset.

And, i think there are not problems since: if the spte without accssed bit is
written frequently, it means the guest page table is accessed infrequently or
during the writing, the guest page table is not accessed, in this time, zapping
this shadow page is not bad.

Comparing the old way, the advantage of it is good for zapping upper shadow page,
for example, in the old way:
if a gfn is used as PDE for a task, later, the gfn is freed and used as PTE for
the new task, so we have two shadow pages in the host, one sp1.level = 2 and the
other sp2.level = 1. So, when we detect write-flooding, the vcpu->last_pte_updated
always point to sp2.pte. As sp2 is used for the new task, we always detected both
shadow pages are bing used, but actually, sp1 is not used by guest anymore.

> Back to the first question, what is the motivation for this heuristic
> change? Do you have any numbers?
> 

Yes, i have done the quick test:

before this patch:
2m56.561
2m50.651
2m51.220
2m52.199
2m48.066

After this patch:
2m51.194
2m55.980
2m50.755
2m47.396
2m46.807

It shows the new way is little better than the old way.
