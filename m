Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab1BIG67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 01:58:59 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52643 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab1BIG66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 01:58:58 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 9 Feb 2011 15:52:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: Re: [mmotm] BUG: Bad page state in process khugepaged ?
Message-Id: <20110209155246.69a7f3a1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110209155001.0e369475.nishimura@mxp.nes.nec.co.jp>
References: <20110209151036.f24a36a6.kamezawa.hiroyu@jp.fujitsu.com>
	<20110209155001.0e369475.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Feb 2011 15:50:01 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> > 
> > In hex, pc->flags was 7A00000000004 and this means PCG_USED bit is set.
> > This implies page_remove_rmap() may not be called but ->mapping is NULL. Hmm?
> > (7A is encoding of section number.)
> > 
> Sigh.. it seems another freed-but-not-uncharged problem..
> 

Ah, ok, this is maybe caused by this. I'm sorry that I missed this.
==
static inline int free_pages_check(struct page *page)
{
        if (unlikely(page_mapcount(page) |
                (page->mapping != NULL)  |
                (atomic_read(&page->_count) != 0) |
                (page->flags & PAGE_FLAGS_CHECK_AT_FREE) |
                (mem_cgroup_bad_page_check(page)))) {    <==========(*)
                bad_page(page);
                return 1;
==

Then, ok, this is a memcgroup and hugepage issue.

I'll look into.

Thanks,
-Kame

