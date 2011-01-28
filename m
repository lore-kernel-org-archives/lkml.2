Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab1A1Mk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 07:40:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:37663 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab1A1Mk5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 07:40:57 -0500
Subject: Re: One (possible) x86 get_user_pages bug
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jan Beulich <JBeulich@novell.com>
Cc: Xiaowei Yang <xiaowei.yang@huawei.com>, fanhenglong@huawei.com,
        Kaushik Barde <kbarde@huawei.com>, Kenneth Lee <liguozhu@huawei.com>,
        linqaingmin <linqiangmin@huawei.com>, wangzhenguo@huawei.com,
        Wu Fengguang <fengguang.wu@intel.com>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org
In-Reply-To: <4D418F8D020000780002EC8F@vpn.id2.novell.com>
References: <4D416D9A.9010603@huawei.com>
	 <1296136618.15234.187.camel@laptop>
	 <4D418F8D020000780002EC8F@vpn.id2.novell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 28 Jan 2011 11:51:31 +0100
Message-ID: <1296211891.15234.269.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-27 at 14:30 +0000, Jan Beulich wrote:
> >>> On 27.01.11 at 14:56, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Thu, 2011-01-27 at 21:05 +0800, Xiaowei Yang wrote:
> >> 
> >> However, from the comments embedded in gup.c, it seems deliberate to 
> >> avoid the lock in the fast path. The question is: if so, how to avoid 
> >> the above scenario? 
> > 
> > Something like the below comes to mind... but I must say I haven't fully
> > considered the problem yet..
> 
> That doesn't seem to account for the possible case of the page
> even managing to get allocated again to something else.
> 
> And I think you would need to drop out of gup_pte_range() in
> that case.
> 
> I would think this needs to be get_page_unless_zero()
> followed by re-checking of the page table entry (probably
> not even requiring a second gup_get_pte()); I'm not sure
> yet what the correct action would be for change in only the
> accessed/dirty bits.

Nah, if its racy against unmap its racy and the caller needs to be able
to deal with whatever page comes it way. You either get the old, the
new, or no page.

The get_page_unless_zero() + RCU-freed page-tables should make Xen work
again, look at the powerpc gup_fast implementation.
