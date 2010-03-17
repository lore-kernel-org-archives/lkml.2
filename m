Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab0CQEXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 00:23:10 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47643 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab0CQEXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 00:23:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 17 Mar 2010 13:19:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 02/11] mm,migration: Do not try to migrate unmapped 
 anonymous pages
Message-Id: <20100317131912.0712e6b0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <28c262361003162115k79e3d40fka6e1def6472823ef@mail.gmail.com>
References: <1268412087-13536-1-git-send-email-mel@csn.ul.ie>
	<28c262361003141728g4aa40901hb040144c5a4aeeed@mail.gmail.com>
	<20100315143420.6ec3bdf9.kamezawa.hiroyu@jp.fujitsu.com>
	<20100315112829.GI18274@csn.ul.ie>
	<1268657329.1889.4.camel@barrios-desktop>
	<20100315142124.GL18274@csn.ul.ie>
	<20100316084934.3798576c.kamezawa.hiroyu@jp.fujitsu.com>
	<20100317111234.d224f3fd.kamezawa.hiroyu@jp.fujitsu.com>
	<28c262361003162000w34cc13ecnbd32840a0df80f95@mail.gmail.com>
	<20100317121551.b619f55b.kamezawa.hiroyu@jp.fujitsu.com>
	<28c262361003162115k79e3d40fka6e1def6472823ef@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Mar 2010 13:15:14 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Wed, Mar 17, 2010 at 12:15 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Wed, 17 Mar 2010 12:00:15 +0900
> > Minchan Kim <minchan.kim@gmail.com> wrote:
> >
> >> On Wed, Mar 17, 2010 at 11:12 AM, KAMEZAWA Hiroyuki
> >> > BTW, I doubt freeing anon_vma can happen even when we check mapcount.
> >> >
> >> > "unmap" is 2-stage operation.
> >> >        1. unmap_vmas() => modify ptes, free pages, etc.
> >> >        2. free_pgtables() => free pgtables, unlink vma and free it.
> >> >
> >> > Then, if migration is enough slow.
> >> >
> >> >        Migration():                            Exit():
> >> >        check mapcount
> >> >        rcu_read_lock
> >> >        pte_lock
> >> >        replace pte with migration pte
> >> >        pte_unlock
> >> >                                                pte_lock
> >> >        copy page etc...                        zap pte (clear pte)
> >> >                                                pte_unlock
> >> >                                                free_pgtables
> >> >                                                ->free vma
> >> >                                                ->free anon_vma
> >> >        pte_lock
> >> >        remap pte with new pfn(fail)
> >> >        pte_unlock
> >> >
> >> >        lock anon_vma->lock             # modification after free.
> >> >        check list is empty
> >>
> >> check list is empty?
> >> Do you mean anon_vma->head?
> >>
> > yes.
> >
> >> If it is, is it possible that that list isn't empty since anon_vma is
> >> used by others due to
> >> SLAB_DESTROY_BY_RCU?
> >>
> > There are 4 cases.
> >        A) anon_vma->list is not empty because anon_vma is not freed.
> >        B) anon_vma->list is empty because it's freed.
> >        C) anon_vma->list is empty but it's reused.
> >        D) anon_vma->list is not empty but it's reused.
> 
> E) anon_vma is used for other object.
> 
> That's because we don't hold rcu_read_lock.
> I think Mel met this E) situation.
> 
Hmm. 

> AFAIU, even slab page of SLAB_BY_RCU can be freed after grace period.
> Do I miss something?
> 
I miss something. Sorry for noise.

Maybe we need check page_mapped() before calling try_to_unmap() as
vmscan does. Thank you for your help.

Thanks,
-Kame

