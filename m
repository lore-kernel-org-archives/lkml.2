Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab2LTAIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 19:08:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab2LTAIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 19:08:07 -0500
Date: Wed, 19 Dec 2012 16:08:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Satoru Moriya <satoru.moriya@hds.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 5/7] mm: vmscan: clean up get_scan_count()
Message-Id: <20121219160805.658f724f.akpm@linux-foundation.org>
In-Reply-To: <1355767957-4913-6-git-send-email-hannes@cmpxchg.org>
References: <1355767957-4913-1-git-send-email-hannes@cmpxchg.org>
	<1355767957-4913-6-git-send-email-hannes@cmpxchg.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2012 13:12:35 -0500
Johannes Weiner <hannes@cmpxchg.org> wrote:

> Reclaim pressure balance between anon and file pages is calculated
> through a tuple of numerators and a shared denominator.
> 
> Exceptional cases that want to force-scan anon or file pages configure
> the numerators and denominator such that one list is preferred, which
> is not necessarily the most obvious way:
> 
>     fraction[0] = 1;
>     fraction[1] = 0;
>     denominator = 1;
>     goto out;
> 
> Make this easier by making the force-scan cases explicit and use the
> fractionals only in case they are calculated from reclaim history.
> 
> And bring the variable declarations/definitions in order.
> 
> ...
>
> +	u64 fraction[2], uninitialized_var(denominator);

Using uninitialized_var() puts Linus into rant mode.  Unkindly, IMO:
uninitialized_var() is documentarily useful and reduces bloat.  There is
a move afoot to replace it with

	int foo = 0;	/* gcc */

To avoid getting ranted at we can do

--- a/mm/vmscan.c~mm-vmscan-clean-up-get_scan_count-fix
+++ a/mm/vmscan.c
@@ -1658,7 +1658,8 @@ static void get_scan_count(struct lruvec
 			   unsigned long *nr)
 {
 	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
-	u64 fraction[2], uninitialized_var(denominator);
+	u64 fraction[2];
+	u64 denominator = 0;
 	struct zone *zone = lruvec_zone(lruvec);
 	unsigned long anon_prio, file_prio;
 	enum scan_balance scan_balance;
_

Which bloats the text by six bytes, but will force a nice div-by-zero
if we ever hit that can't-happen path.
