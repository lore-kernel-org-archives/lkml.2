Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab1JZG0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 02:26:45 -0400
Received: from smtp-out.google.com ([216.239.44.51]:14071 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab1JZG0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 02:26:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=J/N2wCS7mnu6Z2h+m8ZZvxiYNJtzgyRAth+g2zpOJpFechwif9fYYJZNhRh3kQ61e
	CI0IQGIalU2mUOu6RihZg==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1110252322220.20273@chino.kir.corp.google.com>
References: <1319524789-22818-1-git-send-email-ccross@android.com>
	<20111025090956.GA10797@suse.de>
	<alpine.DEB.2.00.1110251513520.26017@chino.kir.corp.google.com>
	<CAMbhsRQ3y2SBwEfjiYgfxz2-h0fgn20mLBYgFuBwGqon0f-a8g@mail.gmail.com>
	<alpine.DEB.2.00.1110252244270.18661@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1110252311030.20273@chino.kir.corp.google.com>
	<CAMbhsRS+-jn7d1bTd4F0_RB9860iWjOHLfOkDsqLfWEUbR3TYA@mail.gmail.com>
	<alpine.DEB.2.00.1110252322220.20273@chino.kir.corp.google.com>
Date: Tue, 25 Oct 2011 23:26:40 -0700
X-Google-Sender-Auth: 8CfTilFyFTqUhATcW8zsaHgzBkM
Message-ID: <CAMbhsRQdrWRLkj7U-u2AZxM11mSUNj5_1K27g58cMBo1Js1Yeg@mail.gmail.com>
Subject: Re: [PATCH] mm: avoid livelock on !__GFP_FS allocations
From: Colin Cross <ccross@android.com>
To: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 11:24 PM, David Rientjes <rientjes@google.com> wrote:
> On Tue, 25 Oct 2011, Colin Cross wrote:
>
>> > Or, rather, when pm_restrict_gfp_mask() clears __GFP_IO and __GFP_FS that
>> > it also has the same behavior as __GFP_NORETRY in should_alloc_retry() by
>> > setting a variable in file scope.
>> >
>>
>> Why do you prefer that over adding a gfp_required_mask?
>>
>
> Because it avoids an unnecessary OR in the page and slab allocator
> fastpaths which are red hot :)
>

Makes sense.  What about this?  Official patch to follow.

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fef8dc3..59cd4ff 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1786,6 +1786,13 @@ should_alloc_retry(gfp_t gfp_mask, unsigned int order,
                return 0;

        /*
+        * If PM has disabled I/O, OOM is disabled and reclaim is unlikely
+        * to make any progress.  To prevent a livelock, don't retry.
+        */
+       if (!(gfp_allowed_mask & __GFP_FS))
+               return 0;
+
+       /*
         * In this implementation, order <= PAGE_ALLOC_COSTLY_ORDER
         * means __GFP_NOFAIL, but that may not be true in other
         * implementations.
