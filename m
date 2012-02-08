Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab2BHORR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 09:17:17 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52376 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab2BHORQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 09:17:16 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Andrew Morton" <akpm@linux-foundation.org>,
        "Mel Gorman" <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: compaction: Check for overlapping nodes during isolation for
 migration
References: <20120206090841.GF5938@suse.de>
Date: Wed, 08 Feb 2012 15:17:13 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v9c5yzm03l0zgt@mpn-glaptop>
In-Reply-To: <20120206090841.GF5938@suse.de>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Feb 2012 10:08:41 +0100, Mel Gorman <mgorman@suse.de> wrote:
> When isolating pages for migration, migration starts at the start of a
> zone while the free scanner starts at the end of the zone. Migration
> avoids entering a new zone by never going beyond the free scanned.
> Unfortunately, in very rare cases nodes can overlap. When this happens,
> migration isolates pages without the LRU lock held, corrupting lists
> which will trigger errors in reclaim or during page free such as in the
> following oops
[...]
> The fix is straight-forward. isolate_migratepages() has to make a
> similar check to isolate_freepage to ensure that it never isolates
> pages from a zone it does not hold the LRU lock for.
>
> This was discovered in a 3.0-based kernel but it affects 3.1.x, 3.2.x
> and current mainline.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> Cc: <stable@vger.kernel.org>
> ---
>  mm/compaction.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
>
> diff --git a/mm/compaction.c b/mm/compaction.c
> index bd6e739..6042644 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -330,8 +330,17 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
>  			continue;
>  		nr_scanned++;
>-		/* Get the page and skip if free */
> +		/*
> +		 * Get the page and ensure the page is within the same zone.
> +		 * See the comment in isolate_freepages about overlapping
> +		 * nodes. It is deliberate that the new zone lock is not taken
> +		 * as memory compaction should not move pages between nodes.
> +		 */
>  		page = pfn_to_page(low_pfn);
> +		if (page_zone(page) != zone)
> +			continue;
> +
> +		/* Skip if free */
>  		if (PageBuddy(page))
>  			continue;
>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
