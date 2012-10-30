Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965511Ab2J3Syz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:54:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47585 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965134Ab2J3Syx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:54:53 -0400
Date: Tue, 30 Oct 2012 11:54:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, klamm@yandex-team.ru,
        mgorman@suse.de, hannes@cmpxchg.org
Subject: Re: [PATCH RFC] mm,vmscan: only evict file pages when we have
 plenty
Message-Id: <20121030115451.f4c097f0.akpm@linux-foundation.org>
In-Reply-To: <20121030144204.0aa14d92@dull>
References: <20121030144204.0aa14d92@dull>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2012 14:42:04 -0400
Rik van Riel <riel@redhat.com> wrote:

> If we have more inactive file pages than active file pages, we
> skip scanning the active file pages alltogether, with the idea
> that we do not want to evict the working set when there is
> plenty of streaming IO in the cache.

Yes, I've never liked that.  The "(active > inactive)" thing is a magic
number.  And suddenly causing a complete cessation of vm scanning at a
particular magic threshold seems rather crude, compared to some complex
graduated thing which will also always do the wrong thing, only more
obscurely ;)

Ho hum, in the absence of observed problems, I guess we don't muck with
it.

> However, the code forgot to also skip scanning anonymous pages
> in that situation.  That lead to the curious situation of keeping
> the active file pages protected from being paged out when there
> are lots of inactive file pages, while still scanning and evicting
> anonymous pages.
> 
> This patch fixes that situation, by only evicting file pages
> when we have plenty of them and most are inactive.
> 

Any observed runtime effects from this?  If so, were they good?

> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1686,6 +1686,15 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
>  			fraction[1] = 0;
>  			denominator = 1;
>  			goto out;
> +		} else if (!inactive_file_is_low_global(zone)) {
> +			/*
> +			 * There is enough inactive page cache, do not
> +			 * reclaim anything from the working set right now.
> +			 */
> +			fraction[0] = 0;
> +			fraction[1] = 1;
> +			denominator = 1;
> +			goto out;
>  		}
>  	}

Let's make the commenting look logical:

--- a/mm/vmscan.c~mmvmscan-only-evict-file-pages-when-we-have-plenty-fix
+++ a/mm/vmscan.c
@@ -1679,9 +1679,11 @@ static void get_scan_count(struct lruvec
 
 	if (global_reclaim(sc)) {
 		free  = zone_page_state(zone, NR_FREE_PAGES);
-		/* If we have very few page cache pages,
-		   force-scan anon pages. */
 		if (unlikely(file + free <= high_wmark_pages(zone))) {
+			/*
+			 * If we have very few page cache pages, force-scan
+			 * anon pages.
+			 */
 			fraction[0] = 1;
 			fraction[1] = 0;
 			denominator = 1;
_

