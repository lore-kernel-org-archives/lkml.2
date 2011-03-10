Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab1CJJDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 04:03:20 -0500
Received: from router-fw.net-space.pl ([89.174.63.77]:42441 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab1CJJDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 04:03:17 -0500
Date: Thu, 10 Mar 2011 10:02:07 +0100
From: Daniel Kiper <dkiper@net-space.pl>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Daniel Kiper <dkiper@net-space.pl>, ian.campbell@citrix.com,
        akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, wdauchy@gmail.com,
        rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH R4 7/7] xen/balloon: Memory hotplug support for Xen balloon driver
Message-ID: <20110310090207.GB13978@router-fw-old.local.net-space.pl>
References: <20110308215049.GH27331@router-fw-old.local.net-space.pl> <1299628939.9014.3499.camel@nimitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299628939.9014.3499.camel@nimitz>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 04:02:19PM -0800, Dave Hansen wrote:
> On Tue, 2011-03-08 at 22:50 +0100, Daniel Kiper wrote:
> > +static int xen_online_page_notifier(struct notifier_block *nb, unsigned long val, void *v)
> > +{
> > +	struct page *page = v;
> > +	unsigned long pfn = page_to_pfn(page);
> > +
> > +	if (pfn >= num_physpages)
> > +		num_physpages = pfn + 1;
> > +
> > +	inc_totalhigh_pages();
> > +
> > +#ifdef CONFIG_FLATMEM
> > +	max_mapnr = max(pfn, max_mapnr);
> > +#endif
>
> I really don't like that this is a direct copy of online_page() up to
> this point.  They're already subtly different.  I'm also curious if this
> breaks on 32-bit kernels because of the unconditional
> inc_totalhigh_pages().
>
> If it's done this way, I'd almost guarantee that the first time someone
> fixes a bug or adds a generic feature in online_page() that Xen gets
> missed.

OK, I rewrite this part of code.

> > +	mutex_lock(&balloon_mutex);
> > +
> > +	__balloon_append(page);
> > +
> > +	if (balloon_stats.hotplug_pages)
> > +		--balloon_stats.hotplug_pages;
> > +	else
> > +		--balloon_stats.balloon_hotplug;
> > +
> > +	mutex_unlock(&balloon_mutex);
> > +
> > +	return NOTIFY_STOP;
> > +}
>
> I'm not a _huge_ fan of these notifier chains, but I guess it works.

Could you tell me why ??? I think that in that case new
(faster, simpler, etc.) mechanism is an overkill. I prefer
to use something which is writen, tested and ready for usage.

> However, if you're going to use these notifier chains, then we probably
> should use them to full effect.  Have a notifier list like this:
>
> 	1. generic online_page()
> 	2. xen_online_page_notifier() (returns NOTIFY_STOP)
> 	3. free_online_page()
>
> Where finish_online_page() does something like this:
>
> finish_online_page(...)
> {
>         ClearPageReserved(page);
>         init_page_count(page);
>         __free_page(page);
> }

OK.

Daniel
