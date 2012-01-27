Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab2A0Jo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 04:44:28 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36650 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab2A0Jo0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 04:44:26 -0500
MIME-Version: 1.0
In-Reply-To: <1327568457-27734-13-git-send-email-m.szyprowski@samsung.com>
References: <1327568457-27734-1-git-send-email-m.szyprowski@samsung.com> <1327568457-27734-13-git-send-email-m.szyprowski@samsung.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 27 Jan 2012 11:44:05 +0200
X-Google-Sender-Auth: lR2jnmuz_5iJU7-1qBZgu4g7YN8
Message-ID: <CADMYwHw1B4RNV_9BqAg_M70da=g69Z3kyo5Cr6izCMwJ9LAtvA@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH 12/15] drivers: add Contiguous Memory Allocator
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Jonathan Corbet <corbet@lwn.net>, Mel Gorman <mel@csn.ul.ie>,
        Michal Nazarewicz <mina86@mina86.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Jesse Barker <jesse.barker@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

With v19, I can't seem to allocate big regions anymore (e.g. 101MiB).
In particular, this seems to fail:

On Thu, Jan 26, 2012 at 11:00 AM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> +static int cma_activate_area(unsigned long base_pfn, unsigned long count)
> +{
> +       unsigned long pfn = base_pfn;
> +       unsigned i = count >> pageblock_order;
> +       struct zone *zone;
> +
> +       WARN_ON_ONCE(!pfn_valid(pfn));
> +       zone = page_zone(pfn_to_page(pfn));
> +
> +       do {
> +               unsigned j;
> +               base_pfn = pfn;
> +               for (j = pageblock_nr_pages; j; --j, pfn++) {
> +                       WARN_ON_ONCE(!pfn_valid(pfn));
> +                       if (page_zone(pfn_to_page(pfn)) != zone)
> +                               return -EINVAL;

The above WARN_ON_ONCE is triggered, and then the conditional is
asserted (page_zone() retuns a "Movable" zone, whereas zone is
"Normal") and the function fails.

This happens to me on OMAP4 with your 3.3-rc1-cma-v19 branch (and a
bunch of remoteproc/rpmsg patches).

Do big allocations work for you ?

Thanks,
Ohad.
