Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab1BJEEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 23:04:53 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52883 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847Ab1BJEEw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 23:04:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EjAxoIlOM+q86d5keNdWE+g2okJTXdz0s9mzEXRjKlM2NqAwWUH7vy0GrGDGWzd7Xc
         wJ9fgijlIdcErXvdFJxC/iRHA8PYtetkJEb3wDhuJWyxBd9f7RmRtJE7RwTk3v6hVGVR
         3nMNYBultgUFIUslfyfGiTLejbZ+Alkj7OGbc=
MIME-Version: 1.0
In-Reply-To: <20110209154606.GJ27110@cmpxchg.org>
References: <20110209154606.GJ27110@cmpxchg.org>
Date: Thu, 10 Feb 2011 13:04:51 +0900
Message-ID: <AANLkTikY8Z5K=ydaN7+1QXi-ofLYgV0Vhw0u-4B=Q9Hg@mail.gmail.com>
Subject: Re: [patch] vmscan: fix zone shrinking exit when scan work is done
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        Kent Overstreet <kent.overstreet@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 12:46 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> Hi,
>
> I think this should fix the problem of processes getting stuck in
> reclaim that has been reported several times.  Kent actually
> single-stepped through this code and noted that it was never exiting
> shrink_zone(), which really narrowed it down a lot, considering the
> tons of nested loops from the allocator down to the list shrinking.
>
>        Hannes
>
> ---
> From: Johannes Weiner <hannes@cmpxchg.org>
> Subject: vmscan: fix zone shrinking exit when scan work is done
>
> '3e7d344 mm: vmscan: reclaim order-0 and use compaction instead of
> lumpy reclaim' introduced an indefinite loop in shrink_zone().
>
> It meant to break out of this loop when no pages had been reclaimed
> and not a single page was even scanned.  The way it would detect the
> latter is by taking a snapshot of sc->nr_scanned at the beginning of
> the function and comparing it against the new sc->nr_scanned after the
> scan loop.  But it would re-iterate without updating that snapshot,
> looping forever if sc->nr_scanned changed at least once since
> shrink_zone() was invoked.
>
> This is not the sole condition that would exit that loop, but it
> requires other processes to change the zone state, as the reclaimer
> that is stuck obviously can not anymore.
>
> This is only happening for higher-order allocations, where reclaim is
> run back to back with compaction.
>
> Reported-by: Michal Hocko <mhocko@suse.cz>
> Reported-by: Kent Overstreet <kent.overstreet@gmail.com>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
