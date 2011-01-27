Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab1A0QHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 11:07:36 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:41355 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab1A0QHf convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Thu, 27 Jan 2011 11:07:35 -0500
Message-Id: <4D41A651020000780002ED36@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 27 Jan 2011 16:07:29 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Xiaowei Yang" <xiaowei.yang@huawei.com>,
        "Nick Piggin" <npiggin@kernel.dk>
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, <fanhenglong@huawei.com>,
        "Kaushik Barde" <kbarde@huawei.com>,
        "Kenneth Lee" <liguozhu@huawei.com>,
        "linqaingmin" <linqiangmin@huawei.com>, <wangzhenguo@huawei.com>,
        "Wu Fengguang" <fengguang.wu@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: One (possible) x86 get_user_pages bug
References: <4D416D9A.9010603@huawei.com>
In-Reply-To: <4D416D9A.9010603@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 27.01.11 at 14:05, Xiaowei Yang <xiaowei.yang@huawei.com> wrote:
> We created a scenario to reproduce the bug:
> ----------------------------------------------------------------
> // proc1/proc1.2 are 2 threads sharing one page table.
> // proc1 is the parent of proc2.
> 
> proc1               proc2          proc1.2
> ...                 ...            // in gup_pte_range()
> ...                 ...            pte = gup_get_pte()
> ...                 ...            page1 = pte_page(pte)  // (1)
> do_wp_page(page1)   ...            ...
> ...                 exit_map()     ...
> ...                 ...            get_page(page1)        // (2)
> -----------------------------------------------------------------
> 
> do_wp_page() and exit_map() cause page1 to be released into free list 
> before get_page() in proc1.2 is called. The longer the delay between 
> (1)&(2), the easier the BUG_ON shows.

Other than responded initially, I don't this can happen outside
of Xen: do_wp_page() won't reach page_cache_release() when
gup_pte_range() is running for the same mm on another CPU,
since it can't get past ptep_clear_flush() (waiting for the CPU
in get_user_pages_fast() to re-enable interrupts).

> An experimental patch is made to prevent the PTE being modified in the 
> middle of gup_pte_range(). The BUG_ON disappears afterward.
> 
> However, from the comments embedded in gup.c, it seems deliberate to 
> avoid the lock in the fast path. The question is: if so, how to avoid 
> the above scenario?

Nick, based on your doing of the initial implementation, would
you be able to estimate whether disabling get_user_pages_fast()
altogether for Xen would be performing measurably worse than
adding the locks (but continuing to avoid acquiring mm->mmap_sem)
as suggested by Xiaowei? That's of course only if the latter is correct
at all, of which I haven't fully convinced myself yet.

Jan

