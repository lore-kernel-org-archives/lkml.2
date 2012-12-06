Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424696Ab2LFT0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 14:26:41 -0500
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:57333 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423240Ab2LFT0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 14:26:40 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnNKAAfxwFBV5qjOPGdsb2JhbABEhUuFI7M5FwMBAQEBODSCHgEBBAE6HCMFCwgDRhQlChqIHQrCbBSMLoNZYQOWAoV7g1OJboFj
X-IronPort-AV: E=Sophos;i="4.84,231,1355094000"; 
   d="scan'208";a="239084959"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 6 Dec 2012 20:28:45 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Jan Kara <jack@suse.cz>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Oops in 3.7-rc8 isolate_free_pages_block()
Message-ID: <20121206192845.GA599@polaris.bitmath.org>
References: <20121206091744.GA1397@polaris.bitmath.org>
 <20121206144821.GC18547@quack.suse.cz>
 <20121206161934.GA17258@suse.de>
 <CA+55aFw9WQN-MYFKzoGXF9Z70h1XsMu5X4hLy0GPJopBVuE=Yg@mail.gmail.com>
 <20121206175451.GC17258@suse.de>
 <CA+55aFwDZHXf2FkWugCy4DF+mPTjxvjZH87ydhE5cuFFcJ-dJg@mail.gmail.com>
 <20121206183259.GA591@polaris.bitmath.org>
 <CA+55aFzievpA_b5p-bXwW11a89eC-ucpzKUuSqb2PNQOLrqaPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzievpA_b5p-bXwW11a89eC-ucpzKUuSqb2PNQOLrqaPg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually, looking at it some more, I think that two-liner patch had
> *ANOTHER* bug.
> 
> Because the other line seems buggy as well.
> 
> Instead of
> 
>         end_pfn = ALIGN(pfn + pageblock_nr_pages, pageblock_nr_pages);
> 
> I think it should be
> 
>         end_pfn = ALIGN(pfn+1, pageblock_nr_pages);
> 
> instead. ALIGN() already aligns upwards (but the "+1" is needed in
> case pfn is already at a pageblock_nr_pages boundary, at which point
> ALIGN() would have just returned that same boundary.

Ah, and now the two callers treat the pointers the same way.

> Hmm? Mel, please confirm. And Henrik, it might be good to test that
> doubly-fixed patch. Because reading the patch and trying to fix bugs
> in it that way is *not* the same as actually verifying it ;)

Confirmed, working. I also checked 3.6, but could not trigger the
original problem there. The code also looks different, so it makes
sense. To be explicit, this is what I tested on top of v3.7-rc8:

---
 mm/compaction.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 9eef558..ff1c483 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -713,7 +713,15 @@ static void isolate_freepages(struct zone *zone,
 
 		/* Found a block suitable for isolating free pages from */
 		isolated = 0;
-		end_pfn = min(pfn + pageblock_nr_pages, zone_end_pfn);
+
+		/*
+		 * As pfn may not start aligned, pfn+pageblock_nr_page
+		 * may cross a MAX_ORDER_NR_PAGES boundary and miss
+		 * a pfn_valid check. Ensure isolate_freepages_block()
+		 * only scans within a pageblock.
+		 */
+		end_pfn = ALIGN(pfn + 1, pageblock_nr_pages);
+		end_pfn = min(end_pfn, zone_end_pfn);
 		isolated = isolate_freepages_block(cc, pfn, end_pfn,
 						   freelist, false);
 		nr_freepages += isolated;
-- 
1.8.0.1

Hopefully, that's a wrap. :-)

Henrik
