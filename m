Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab1F0GLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 02:11:22 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42802 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756408Ab1F0GK6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 02:10:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kcpYZPFJHhMWq6lGxFOOmsszki0YTxmOgeBMFIdysYFj6QF+a04UMYKpb/5hnrX/ID
         oVgGt6WysPcElb3FD/rIbIz1AYsTb3PkkZzRylC1fUPcfeX3UI6IreNjTk7KuWySB0Wl
         u2iqDd7vxALm3LR4MLvWUEZUdBmzwRyaCcbO0=
MIME-Version: 1.0
In-Reply-To: <1308926697-22475-2-git-send-email-mgorman@suse.de>
References: <1308926697-22475-1-git-send-email-mgorman@suse.de>
	<1308926697-22475-2-git-send-email-mgorman@suse.de>
Date: Mon, 27 Jun 2011 15:10:57 +0900
Message-ID: <BANLkTikNcWhcxPkPnC4amnrC-bNEUNqGQw@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm: vmscan: Correct check for kswapd sleeping in sleeping_prematurely
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?Q?P=C3=A1draig_Brady?= <P@draigbrady.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Colin King <colin.king@canonical.com>,
        Andrew Lutomirski <luto@mit.edu>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 11:44 PM, Mel Gorman <mgorman@suse.de> wrote:
> During allocator-intensive workloads, kswapd will be woken frequently
> causing free memory to oscillate between the high and min watermark.
> This is expected behaviour.
>
> A problem occurs if the highest zone is small.  balance_pgdat()
> only considers unreclaimable zones when priority is DEF_PRIORITY
> but sleeping_prematurely considers all zones. It's possible for this
> sequence to occur
>
>  1. kswapd wakes up and enters balance_pgdat()
>  2. At DEF_PRIORITY, marks highest zone unreclaimable
>  3. At DEF_PRIORITY-1, ignores highest zone setting end_zone
>  4. At DEF_PRIORITY-1, calls shrink_slab freeing memory from
>        highest zone, clearing all_unreclaimable. Highest zone
>        is still unbalanced
>  5. kswapd returns and calls sleeping_prematurely
>  6. sleeping_prematurely looks at *all* zones, not just the ones
>     being considered by balance_pgdat. The highest small zone
>     has all_unreclaimable cleared but but the zone is not
>     balanced. all_zones_ok is false so kswapd stays awake
>
> This patch corrects the behaviour of sleeping_prematurely to check
> the zones balance_pgdat() checked.
>
> Reported-and-tested-by: Pádraig Brady <P@draigBrady.com>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
