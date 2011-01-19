Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab1ASMKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 07:10:50 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:57049 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab1ASMKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 07:10:49 -0500
Date: Wed, 19 Jan 2011 13:10:43 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/4] memcg: fix USED bit handling at uncharge in THP
Message-ID: <20110119121043.GB2232@cmpxchg.org>
References: <20110118113528.fd24928f.kamezawa.hiroyu@jp.fujitsu.com>
 <20110118114049.5ffdf5da.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110118114049.5ffdf5da.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello KAMEZAWA-san,

On Tue, Jan 18, 2011 at 11:40:49AM +0900, KAMEZAWA Hiroyuki wrote:
> +void mem_cgroup_split_huge_fixup(struct page *head, struct page *tail)
> +{
> +	struct page_cgroup *head_pc = lookup_page_cgroup(head);
> +	struct page_cgroup *tail_pc = lookup_page_cgroup(tail);
> +	unsigned long flags;
> +
> +	/*
> +	 * We have no races witch charge/uncharge but will have races with
> +	 * page state accounting.
> +	 */
> +	move_lock_page_cgroup(head_pc, &flags);
> +
> +	tail_pc->mem_cgroup = head_pc->mem_cgroup;
> +	smp_wmb(); /* see __commit_charge() */

I thought the barriers were needed because charging does not hold the
lru lock.  But here we do, and all the 'lockless' read-sides do so as
well.  Am I missing something or can this barrier be removed?

	Hannes
