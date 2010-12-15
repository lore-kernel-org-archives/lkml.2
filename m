Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab0LOASU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 19:18:20 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42861 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab0LOASS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 19:18:18 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 15 Dec 2010 09:12:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 36 of 66] memcg compound
Message-Id: <20101215091209.8c757ad1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101214173817.GH5638@random.random>
References: <patchbomb.1288798055@v2.random>
	<495ffee2d60adab4d18b.1288798091@v2.random>
	<20101118152628.GY8135@csn.ul.ie>
	<20101119101041.ffe00712.kamezawa.hiroyu@jp.fujitsu.com>
	<20101214173817.GH5638@random.random>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Dec 2010 18:38:17 +0100
Andrea Arcangeli <aarcange@redhat.com> wrote:
 
> > > > @@ -2491,14 +2503,14 @@ __do_uncharge(struct mem_cgroup *mem, co
> > > >  	if (batch->memcg != mem)
> > > >  		goto direct_uncharge;
> > > >  	/* remember freed charge and uncharge it later */
> > > > -	batch->bytes += PAGE_SIZE;
> > > > +	batch->bytes += page_size;
> > 
> > Hmm, isn't it simpler to avoid batched-uncharge when page_size > PAGE_SIZE ?
> 
> As you wish, so I'm changing it like this.
> 
> archs where the pmd is implemented purely in software might actually
> be able to use page sizes smaller than 2M that may make sense to
> batch, but for now if you think this is simpler I'll go for it. We
> need simple.
> 

Thank you. Hmm,..seems not very simple :( I'm sorry.
Please do as you want.

-Kame

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2503,6 +2503,9 @@ __do_uncharge(struct mem_cgroup *mem, co
>  	if (!batch->do_batch || test_thread_flag(TIF_MEMDIE))
>  		goto direct_uncharge;
>  
> +	if (page_size != PAGE_SIZE)
> +		goto direct_uncharge;
> +
>  	/*
>  	 * In typical case, batch->memcg == mem. This means we can
>  	 * merge a series of uncharges to an uncharge of res_counter.
> @@ -2511,9 +2514,9 @@ __do_uncharge(struct mem_cgroup *mem, co
>  	if (batch->memcg != mem)
>  		goto direct_uncharge;
>  	/* remember freed charge and uncharge it later */
> -	batch->bytes += page_size;
> +	batch->bytes += PAGE_SIZE;
>  	if (uncharge_memsw)
> -		batch->memsw_bytes += page_size;
> +		batch->memsw_bytes += PAGE_SIZE;
>  	return;
>  direct_uncharge:
>  	res_counter_uncharge(&mem->res, page_size);
> 
> 

