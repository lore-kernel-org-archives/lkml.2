Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab1HYHiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 03:38:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63171 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab1HYHit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 03:38:49 -0400
Message-ID: <4E55FC88.4040300@cn.fujitsu.com>
Date: Thu, 25 Aug 2011 15:40:56 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 11/11] KVM: MMU: improve write flooding detected
References: <4E4A10E8.5090705@cn.fujitsu.com> <4E4A1257.5080204@cn.fujitsu.com> <20110823080024.GA2297@amt.cnet> <4E53872B.3070407@cn.fujitsu.com> <20110823123818.GB4261@amt.cnet> <4E53D620.9030304@cn.fujitsu.com> <20110823190939.GA10220@amt.cnet> <4E540AB4.6060905@cn.fujitsu.com> <20110824200540.GA19804@amt.cnet> <20110825020424.GA2542@amt.cnet>
In-Reply-To: <20110825020424.GA2542@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-25 15:37:52,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-25 15:37:53,
	Serialize complete at 2011-08-25 15:37:53
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2011 10:04 AM, Marcelo Tosatti wrote:

>>> Yes, in this case, the sp is not zapped, but it is hardly to know the gfn
>>> is not used as gpte just depends on writing, for example, the guest can
>>> change the mapping address or the status bit, and so on...The sp can be
>>> zapped if the guest write it again(on the same address), i think it is
>>> acceptable, anymore, it is just the speculative way to zap the unused
>>> shadow page...your opinion?
>>
>> It could increase the flood count independently of the accessed bit of
>> the spte being updated, zapping after 3 attempts as it is now.
>>
>> But additionally reset the flood count if the gpte appears to be valid
>> (points to an existant gfn if the present bit is set, or if its zeroed).
> 
> Well not zero, as thats a common pattern for non ptes.
> 

Hi Marcelo,

Maybe it is not good i think, for some reasons:
- checking gfn valid which it is pointed by gpte is high overload,
  it needs to call gfn_to_hva to walk memslots, especially. kvm_mmu_pte_write
  is called very frequently on shadow mmu.

- MMIO gfn is not an existent gfn, but it is valid pointed by gpte

- we can check the reserved bits in the gpte to check whether it is valid a
  gpte, but for some paging modes, all bits are valid.(for example, non-PAE mode)

- it can not work if the gfn has multiple shadow pages, for example:
  if the gfn was used as PDE, later it is used as PTE, then we have two shadow
  pages: sp1.level = 2, sp2.level = 1, sp1 can not be zapped even even though it
  is not used anymore.

- sometime, we need to zap the shadow page even though the gpte is written validly:
  if the gpte is written frequently but infrequently accessed, we do better zap the
  shadow page to let it is writable(write it directly without #PF) and map it when it
  is accessed, one example is from Avi, the guest OS may update many gptes at one time
  after one page fault.
