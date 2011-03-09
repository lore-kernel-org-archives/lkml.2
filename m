Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab1CIAC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 19:02:28 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:42874 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314Ab1CIAC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 19:02:27 -0500
Subject: Re: [PATCH R4 7/7] xen/balloon: Memory hotplug support for Xen
 balloon driver
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, wdauchy@gmail.com,
        rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20110308215049.GH27331@router-fw-old.local.net-space.pl>
References: <20110308215049.GH27331@router-fw-old.local.net-space.pl>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 08 Mar 2011 16:02:19 -0800
Message-ID: <1299628939.9014.3499.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-08 at 22:50 +0100, Daniel Kiper wrote:
> +static enum bp_state reserve_additional_memory(long credit)
> +{
> +	int rc;
> +	unsigned long balloon_hotplug = credit;
> +
> +	balloon_hotplug <<= PAGE_SHIFT;
> +
> +	rc = add_virtual_memory((u64 *)&balloon_hotplug);

This would work if all 'unsigned long's were 64-bits.  It'll break on
32-bit kernels in a very bad way by overwriting 4 bytes of stack.

> +	if (rc) {
> +		pr_info("xen_balloon: %s: add_virtual_memory() failed: %i\n", __func__, rc);
> +		return BP_EAGAIN;
> +	}
> +
> +	balloon_hotplug >>= PAGE_SHIFT;
> +
> +	balloon_hotplug -= credit;
> +
> +	balloon_stats.hotplug_pages += credit;
> +	balloon_stats.balloon_hotplug = balloon_hotplug;
> +
> +	return BP_DONE;
> +}
> +
> +static int xen_online_page_notifier(struct notifier_block *nb, unsigned long val, void *v)
> +{
> +	struct page *page = v;
> +	unsigned long pfn = page_to_pfn(page);
> +
> +	if (pfn >= num_physpages)
> +		num_physpages = pfn + 1;
> +
> +	inc_totalhigh_pages();
> +
> +#ifdef CONFIG_FLATMEM
> +	max_mapnr = max(pfn, max_mapnr);
> +#endif

I really don't like that this is a direct copy of online_page() up to
this point.  They're already subtly different.  I'm also curious if this
breaks on 32-bit kernels because of the unconditional
inc_totalhigh_pages().

If it's done this way, I'd almost guarantee that the first time someone
fixes a bug or adds a generic feature in online_page() that Xen gets
missed.  

> +	mutex_lock(&balloon_mutex);
> +
> +	__balloon_append(page);
> +
> +	if (balloon_stats.hotplug_pages)
> +		--balloon_stats.hotplug_pages;
> +	else
> +		--balloon_stats.balloon_hotplug;
> +
> +	mutex_unlock(&balloon_mutex);
> +
> +	return NOTIFY_STOP;
> +}

I'm not a _huge_ fan of these notifier chains, but I guess it works.
However, if you're going to use these notifier chains, then we probably
should use them to full effect.  Have a notifier list like this:

	1. generic online_page()
	2. xen_online_page_notifier() (returns NOTIFY_STOP)
	3. free_online_page()

Where finish_online_page() does something like this:

finish_online_page(...)
{
        ClearPageReserved(page);
        init_page_count(page);
        __free_page(page);
}

These patches are definitely getting there.  Just another round or two,
and they should be ready to go.

-- Dave

