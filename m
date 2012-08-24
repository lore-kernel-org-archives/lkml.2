Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759604Ab2HXPUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 11:20:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64551 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab2HXPUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 11:20:44 -0400
Date: Sat, 25 Aug 2012 00:20:35 +0900
From: Minchan Kim <minchan@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: [RFC] mm: support MIGRATE_DISCARD
Message-ID: <20120824152035.GA2127@barrios>
References: <1345782330-23234-1-git-send-email-minchan@kernel.org>
 <503797F0.1050805@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503797F0.1050805@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik,

On Fri, Aug 24, 2012 at 11:04:16AM -0400, Rik van Riel wrote:
> On 08/24/2012 12:25 AM, Minchan Kim wrote:
> >This patch introudes MIGRATE_DISCARD mode in migration.
> >It drops *unmapped clean cache pages* instead of migration so that
> 
> Am I confused, or does the code not match the changelog?
> 
> It looks like it is still trying to discard mapped page cache pages:

Embarrassing typo :( "clean cache page" is right.
That includes both mapped/unmapped clean cache pages.

> 
> >+	file = page_is_file_cache(page);
> >+	ttu_flags = TTU_IGNORE_ACCESS;
> >+retry:
> >+	if (!(mode & MIGRATE_DISCARD) || !file || PageDirty(page))
> >+		ttu_flags |= (TTU_MIGRATION | TTU_IGNORE_MLOCK);
> >+	else
> >+		discard_mode = true;
> >+
> >  	/* Establish migration ptes or remove ptes */
> >-	try_to_unmap(page, TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS);
> >+	rc = try_to_unmap(page, ttu_flags);
> >
> >  skip_unmap:
> >-	if (!page_mapped(page))
> >-		rc = move_to_new_page(newpage, page, remap_swapcache, mode);
> >+	if (rc == SWAP_SUCCESS) {
> >+		if (!discard_mode)
> >+			rc = move_to_new_page(newpage, page,
> >+					remap_swapcache, mode);
> >+		else {
> >+
> >+			rc = discard_page(page);
> >+			goto uncharge;
> >+		}
> 
> 
> 
> -- 
> All rights reversed
