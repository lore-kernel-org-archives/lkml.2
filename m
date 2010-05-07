Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab0EGIw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 04:52:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63860 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754589Ab0EGIwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 04:52:25 -0400
Message-ID: <4BE3D4C2.4070906@cn.fujitsu.com>
Date: Fri, 07 May 2010 16:52:18 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>
CC: Joerg Roedel <joro@8bytes.org>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org, Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [RFC PATCH] kvm: calculate correct gfn for small host pages which
 emulates large guest pages
References: <4BD97AC1.8070704@cn.fujitsu.com> <4BDA4342.9070603@cn.fujitsu.com>
In-Reply-To: <4BDA4342.9070603@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan wrote:
> Lai Jiangshan wrote:
>> RFC, because maybe I missing something with the old code.
>>
>> Frome: Lai Jiangshan <laijs@cn.fujitsu.com>
>>
>> In Document/kvm/mmu.txt:
>>   gfn:
>>     Either the guest page table containing the translations shadowed by this
>>     page, or the base page frame for linear translations. See role.direct.
>>
>> But in function FNAME(fetch)(), sp->gfn is incorrect when one of following
>> situations occurred:
>>  1) guest is 32bit paging and guest uses pse-36 and the guest PDE maps
>>     a 4-MByte page(backed by 4k host pages) and bits 20:13 of the guest PDE
>>     is not equals to 0.
>>  2) guest is long mode paging and the guest PDPTE maps a 1-GByte page
>>     (backed by 4k or 2M host pages)
>>
> 
> Resend this patch with the changelog changed.
> 
> As Marcelo Tosatti and Gui Jianfeng points out, 
> FNAME(fetch)() miss quadrant on 4mb large page emulation with shadow.
> 
> Subject: [PATCH] kvm: calculate correct gfn for small host pages which emulates large guest pages
> 
> In Document/kvm/mmu.txt:
>   gfn:
>     Either the guest page table containing the translations shadowed by this
>     page, or the base page frame for linear translations. See role.direct.
> 
> But in function FNAME(fetch)(), sp->gfn is incorrect when one of following
> situations occurred:
>  1) guest is 32bit paging and the guest PDE maps a 4-MByte page
>     (backed by 4k host pages), FNAME(fetch)() miss handling the quadrant.
> 
>     And if guest use pse-36, "table_gfn = gpte_to_gfn(gw->ptes[level - delta]);"
>     is incorrect.
>  2) guest is long mode paging and the guest PDPTE maps a 1-GByte page
>     (backed by 4k or 2M host pages).
> 
> So we fix it to suit to the document and suit to the code which
> requires sp->gfn correct when sp->role.direct=1.
> 
> We use the goal mapping gfn(gw->gfn) to calculate the base page frame
> for linear translations, it is simple and easy to be understood.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---

Could you add these:

Reported-by: Marcelo Tosatti <mtosatti@redhat.com>
Reported-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

Thanks.
Lai.

PS.
The whole patches includes:
[PATCH] kvm mmu: reduce 50% memory usage
[PATCH] kvm: calculate correct gfn for small host pages which emulates large guest pages
[PATCH] kvm, tdp: calculate correct base gfn for non-DIR level
[PATCH] kvm: update document of gfns

