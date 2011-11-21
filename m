Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754Ab1KUKqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 05:46:16 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36376 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab1KUKqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 05:46:14 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 21 Nov 2011 19:44:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        mhocko@suse.cz, Andrea Arcangeli <aarcange@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH] fix mem_cgroup_split_huge_fixup to work efficiently.
Message-Id: <20111121194452.01c8e93d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111121104250.GI1770@cmpxchg.org>
References: <20111117103308.063f78df.kamezawa.hiroyu@jp.fujitsu.com>
	<20111121104250.GI1770@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Nov 2011 11:42:50 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> On Thu, Nov 17, 2011 at 10:33:08AM +0900, KAMEZAWA Hiroyuki wrote:
> > 
> > I'll send this again when mm is shipped.
> > I sometimes see mem_cgroup_split_huge_fixup() in perf report and noticed
> > it's very slow. This fixes it. Any comments are welcome.
> > 
> > ==
> > Subject: [PATCH] fix mem_cgroup_split_huge_fixup to work efficiently.
> > 
> > at split_huge_page(), mem_cgroup_split_huge_fixup() is called to
> > handle page_cgroup modifcations. It takes move_lock_page_cgroup()
> > and modify page_cgroup and LRU accounting jobs and called
> > HPAGE_PMD_SIZE - 1 times.
> > 
> > But thinking again,
> >   - compound_lock() is held at move_accout...then, it's not necessary
> >     to take move_lock_page_cgroup().
> >   - LRU is locked and all tail pages will go into the same LRU as
> >     head is now on.
> >   - page_cgroup is contiguous in huge page range.
> > 
> > This patch fixes mem_cgroup_split_huge_fixup() as to be called once per
> > hugepage and reduce costs for spliting.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> I agree with the changes, but since you are resending it anyway: I
> think removing the move_lock and switching the hook to take care of
> all tail pages in one go are two logical steps.  Would you mind
> breaking it up into separate patches?
> 
> In any case,
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Ok, I'll break this into 2 patches at resending.

Thanks,
-Kame


