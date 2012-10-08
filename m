Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab2JHPRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 11:17:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60402 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529Ab2JHPRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 11:17:02 -0400
Date: Mon, 8 Oct 2012 16:16:56 +0100
From: Mel Gorman <mgorman@suse.de>
To: Mike Yoknis <mike.yoknis@hp.com>
Cc: mingo@redhat.com, akpm@linux-foundation.org, linux-arch@vger.kernel.org,
        mmarek@suse.cz, tglx@linutronix.de, hpa@zytor.com, arnd@arndb.de,
        sam@ravnborg.org, minchan@kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        mhocko@suse.cz, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: memmap_init_zone() performance improvement
Message-ID: <20121008151656.GM29125@suse.de>
References: <1349276174-8398-1-git-send-email-mike.yoknis@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1349276174-8398-1-git-send-email-mike.yoknis@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 08:56:14AM -0600, Mike Yoknis wrote:
> memmap_init_zone() loops through every Page Frame Number (pfn),
> including pfn values that are within the gaps between existing
> memory sections.  The unneeded looping will become a boot
> performance issue when machines configure larger memory ranges
> that will contain larger and more numerous gaps.
> 
> The code will skip across invalid sections to reduce the
> number of loops executed.
> 
> Signed-off-by: Mike Yoknis <mike.yoknis@hp.com>

This only helps SPARSEMEM and changes more headers than should be
necessary. It would have been easier to do something simple like

if (!early_pfn_valid(pfn)) {
	pfn = ALIGN(pfn + MAX_ORDER_NR_PAGES, MAX_ORDER_NR_PAGES) - 1;
	continue;
}

because that would obey the expectation that pages within a
MAX_ORDER_NR_PAGES-aligned range are all valid or all invalid (ARM is the
exception that breaks this rule). It would be less efficient on
SPARSEMEM than what you're trying to merge but I do not see the need for
the additional complexity unless you can show it makes a big difference
to boot times.

-- 
Mel Gorman
SUSE Labs
