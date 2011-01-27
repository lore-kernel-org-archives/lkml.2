Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436Ab1A0Otu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 09:49:50 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:53686 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab1A0Ott convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Thu, 27 Jan 2011 09:49:49 -0500
Message-Id: <4D419416020000780002ECB7@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 27 Jan 2011 14:49:42 +0000
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

The scenario indeed seems to apply independent of virtualization,
but the window obviously can be unbounded unless running
native.

However, going through all the comments in gup.c again I wonder
whether pv Xen guests don't violate the major assumption: There
is talk about interrupts being off preventing (or sufficiently
deferring) remote CPUs doing TLB flushes. In pv Xen guests,
however, non-local TLB flushes do not happen by sending IPIs -
the hypercall interface gets used instead. If that's indeed the
case, I would have expected quite a few bug reports, but I'm
unaware of any - Nick, am I overlooking something here?

Jan

