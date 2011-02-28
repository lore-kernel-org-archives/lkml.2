Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab1B1Jyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 04:54:39 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37933 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab1B1Jyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 04:54:38 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 28 Feb 2011 18:48:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] page_cgroup: Reduce allocation overhead for
 page_cgroup array for CONFIG_SPARSEMEM v4
Message-Id: <20110228184821.f10dba19.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110228095316.GC4648@tiehlicka.suse.cz>
References: <20110223151047.GA7275@tiehlicka.suse.cz>
	<1298485162.7236.4.camel@nimitz>
	<20110224134045.GA22122@tiehlicka.suse.cz>
	<20110225122522.8c4f1057.kamezawa.hiroyu@jp.fujitsu.com>
	<20110225095357.GA23241@tiehlicka.suse.cz>
	<20110228095347.7510b1d4.kamezawa.hiroyu@jp.fujitsu.com>
	<20110228091256.GA4648@tiehlicka.suse.cz>
	<20110228182322.a34cc1fd.kamezawa.hiroyu@jp.fujitsu.com>
	<20110228095316.GC4648@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Feb 2011 10:53:16 +0100
Michal Hocko <mhocko@suse.cz> wrote:

> On Mon 28-02-11 18:23:22, KAMEZAWA Hiroyuki wrote:
> [...]
> > > From 84a9555741b59cb2a0a67b023e4bd0f92c670ca1 Mon Sep 17 00:00:00 2001
> > > From: Michal Hocko <mhocko@suse.cz>
> > > Date: Thu, 24 Feb 2011 11:25:44 +0100
> > > Subject: [PATCH] page_cgroup: Reduce allocation overhead for page_cgroup array for CONFIG_SPARSEMEM
> > > 
> > > Currently we are allocating a single page_cgroup array per memory
> > > section (stored in mem_section->base) when CONFIG_SPARSEMEM is selected.
> > > This is correct but memory inefficient solution because the allocated
> > > memory (unless we fall back to vmalloc) is not kmalloc friendly:
> > >         - 32b - 16384 entries (20B per entry) fit into 327680B so the
> > >           524288B slab cache is used
> > >         - 32b with PAE - 131072 entries with 2621440B fit into 4194304B
> > >         - 64b - 32768 entries (40B per entry) fit into 2097152 cache
> > > 
> > > This is ~37% wasted space per memory section and it sumps up for the
> > > whole memory. On a x86_64 machine it is something like 6MB per 1GB of
> > > RAM.
> > > 
> > > We can reduce the internal fragmentation by using alloc_pages_exact
> > > which allocates PAGE_SIZE aligned blocks so we will get down to <4kB
> > > wasted memory per section which is much better.
> > > 
> > > We still need a fallback to vmalloc because we have no guarantees that
> > > we will have a continuous memory of that size (order-10) later on during
> > > the hotplug events.
> > > 
> > > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> > > CC: Dave Hansen <dave@linux.vnet.ibm.com>
> > > CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Thanks. I will repost it with Andrew in the CC.
> 
> > 
> > But...nitpick, it may be from my fault..
> [...]
> > > +static void free_page_cgroup(void *addr)
> > > +{
> > > +	if (is_vmalloc_addr(addr)) {
> > > +		vfree(addr);
> > > +	} else {
> > > +		struct page *page = virt_to_page(addr);
> > > +		if (!PageReserved(page)) { /* Is bootmem ? */
> > 
> > I think we never see PageReserved if we just use alloc_pages_exact()/vmalloc().
> 
> I have checked that and we really do not (unless I am missing some
> subtle side effects). Anyway, I think we still should at least BUG_ON on
> that.
> 
> > Maybe my old patch was not enough and this kind of junks are remaining in
> > the original code.
> 
> Should I incorporate it into the patch. I think that a separate one
> would be better for readability.
> 
> ---
> From e7a897a42b526620eb4afada2d036e1c9ff9e62a Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Mon, 28 Feb 2011 10:43:12 +0100
> Subject: [PATCH] page_cgroup array is never stored on reserved pages
> 
> KAMEZAWA Hiroyuki noted that free_pages_cgroup doesn't have to check for
> PageReserved because we never store the array on reserved pages
> (neither alloc_pages_exact nor vmalloc use those pages).
> 
> So we can replace the check by a BUG_ON.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thank you.
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

