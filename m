Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab1ATBBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 20:01:12 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37632 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab1ATBBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 20:01:10 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 20 Jan 2011 09:55:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/4] memcg: fix USED bit handling at uncharge in THP
Message-Id: <20110120095503.74dea304.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110119121043.GB2232@cmpxchg.org>
References: <20110118113528.fd24928f.kamezawa.hiroyu@jp.fujitsu.com>
	<20110118114049.5ffdf5da.kamezawa.hiroyu@jp.fujitsu.com>
	<20110119121043.GB2232@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Jan 2011 13:10:43 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> Hello KAMEZAWA-san,
> 
> On Tue, Jan 18, 2011 at 11:40:49AM +0900, KAMEZAWA Hiroyuki wrote:
> > +void mem_cgroup_split_huge_fixup(struct page *head, struct page *tail)
> > +{
> > +	struct page_cgroup *head_pc = lookup_page_cgroup(head);
> > +	struct page_cgroup *tail_pc = lookup_page_cgroup(tail);
> > +	unsigned long flags;
> > +
> > +	/*
> > +	 * We have no races witch charge/uncharge but will have races with
> > +	 * page state accounting.
> > +	 */
> > +	move_lock_page_cgroup(head_pc, &flags);
> > +
> > +	tail_pc->mem_cgroup = head_pc->mem_cgroup;
> > +	smp_wmb(); /* see __commit_charge() */
> 
> I thought the barriers were needed because charging does not hold the
> lru lock.  But here we do, and all the 'lockless' read-sides do so as
> well.  Am I missing something or can this barrier be removed?
> 

Hmm. I think this can be removed. But it's just because there is only one
referer of lockless access to pc->mem_cgroup. I think it's ok to remove
this but it should be done by independent patch with enough patch
clarification. IOW, I'll do later in another patch.

Thanks,
-Kame

