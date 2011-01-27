Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab1A0PAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 10:00:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:40645 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab1A0PAe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 10:00:34 -0500
Subject: Re: One (possible) x86 get_user_pages bug
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jan Beulich <JBeulich@novell.com>
Cc: Xiaowei Yang <xiaowei.yang@huawei.com>, Nick Piggin <npiggin@kernel.dk>,
        fanhenglong@huawei.com, Kaushik Barde <kbarde@huawei.com>,
        Kenneth Lee <liguozhu@huawei.com>,
        linqaingmin <linqiangmin@huawei.com>, wangzhenguo@huawei.com,
        Wu Fengguang <fengguang.wu@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <4D419416020000780002ECB7@vpn.id2.novell.com>
References: <4D416D9A.9010603@huawei.com>
	 <4D419416020000780002ECB7@vpn.id2.novell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 Jan 2011 16:01:17 +0100
Message-ID: <1296140477.15234.223.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-27 at 14:49 +0000, Jan Beulich wrote:
> >>> On 27.01.11 at 14:05, Xiaowei Yang <xiaowei.yang@huawei.com> wrote:
> > We created a scenario to reproduce the bug:
> > ----------------------------------------------------------------
> > // proc1/proc1.2 are 2 threads sharing one page table.
> > // proc1 is the parent of proc2.
> > 
> > proc1               proc2          proc1.2
> > ...                 ...            // in gup_pte_range()
> > ...                 ...            pte = gup_get_pte()
> > ...                 ...            page1 = pte_page(pte)  // (1)
> > do_wp_page(page1)   ...            ...
> > ...                 exit_map()     ...
> > ...                 ...            get_page(page1)        // (2)
> > -----------------------------------------------------------------
> > 
> > do_wp_page() and exit_map() cause page1 to be released into free list 
> > before get_page() in proc1.2 is called. The longer the delay between 
> > (1)&(2), the easier the BUG_ON shows.
> 
> The scenario indeed seems to apply independent of virtualization,
> but the window obviously can be unbounded unless running
> native.
> 
> However, going through all the comments in gup.c again I wonder
> whether pv Xen guests don't violate the major assumption: There
> is talk about interrupts being off preventing (or sufficiently
> deferring) remote CPUs doing TLB flushes. In pv Xen guests,
> however, non-local TLB flushes do not happen by sending IPIs -
> the hypercall interface gets used instead. If that's indeed the
> case, I would have expected quite a few bug reports, but I'm
> unaware of any - Nick, am I overlooking something here?

Indeed, the delay of tlb flush ipi's should ensure that the pages aren't
freed and should cover the race with unmap.

If Xen violates this then xen needs to fix this somehow..
