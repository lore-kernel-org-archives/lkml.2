Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab1A0Oa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 09:30:26 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:42964 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab1A0OaZ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Thu, 27 Jan 2011 09:30:25 -0500
Message-Id: <4D418F8D020000780002EC8F@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 27 Jan 2011 14:30:21 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Xiaowei Yang" <xiaowei.yang@huawei.com>
Cc: <fanhenglong@huawei.com>, "Kaushik Barde" <kbarde@huawei.com>,
        "Kenneth Lee" <liguozhu@huawei.com>,
        "linqaingmin" <linqiangmin@huawei.com>, <wangzhenguo@huawei.com>,
        "Wu Fengguang" <fengguang.wu@intel.com>,
        "Nick Piggin" <npiggin@kernel.dk>, <linux-kernel@vger.kernel.org>
Subject: Re: One (possible) x86 get_user_pages bug
References: <4D416D9A.9010603@huawei.com>
 <1296136618.15234.187.camel@laptop>
In-Reply-To: <1296136618.15234.187.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 27.01.11 at 14:56, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2011-01-27 at 21:05 +0800, Xiaowei Yang wrote:
>> 
>> However, from the comments embedded in gup.c, it seems deliberate to 
>> avoid the lock in the fast path. The question is: if so, how to avoid 
>> the above scenario? 
> 
> Something like the below comes to mind... but I must say I haven't fully
> considered the problem yet..

That doesn't seem to account for the possible case of the page
even managing to get allocated again to something else.

And I think you would need to drop out of gup_pte_range() in
that case.

I would think this needs to be get_page_unless_zero()
followed by re-checking of the page table entry (probably
not even requiring a second gup_get_pte()); I'm not sure
yet what the correct action would be for change in only the
accessed/dirty bits.

Jan

> ---
>  arch/x86/mm/gup.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
> index dbe34b9..6527933 100644
> --- a/arch/x86/mm/gup.c
> +++ b/arch/x86/mm/gup.c
> @@ -89,10 +89,11 @@ static noinline int gup_pte_range(pmd_t pmd, unsigned 
> long addr,
>  		}
>  		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
>  		page = pte_page(pte);
> -		get_page(page);
> -		SetPageReferenced(page);
> -		pages[*nr] = page;
> -		(*nr)++;
> +		if (get_page_unless_zero(page)) {
> +			SetPageReferenced(page);
> +			pages[*nr] = page;
> +			(*nr)++;
> +		}
>  
>  	} while (ptep++, addr += PAGE_SIZE, addr != end);
>  	pte_unmap(ptep - 1);



