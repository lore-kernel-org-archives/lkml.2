Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab1EAWLH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 18:11:07 -0400
Received: from smtp-out.google.com ([216.239.44.51]:15388 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab1EAWLD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 18:11:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=R4kcMFgFM+oUXBq1jLSZWaDDtiFsb3tjYUE4zUXNOFgd/wrRjsiVpS0uCJLOcUw1OD
         XIEBxyKYzGe/vz9mDb4w==
MIME-Version: 1.0
In-Reply-To: <c7a7b3ceafe4fdc4bc038774374504827c01481f.1304261567.git.minchan.kim@gmail.com>
References: <cover.1304261567.git.minchan.kim@gmail.com>
	<c7a7b3ceafe4fdc4bc038774374504827c01481f.1304261567.git.minchan.kim@gmail.com>
Date: Sun, 1 May 2011 15:10:58 -0700
Message-ID: <BANLkTi=c2tBcXJnFi-i4r1_ADiMFebmxMA@mail.gmail.com>
Subject: Re: [PATCH 1/2] Check PageUnevictable in lru_deactivate_fn
From: Ying Han <yinghan@google.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 1, 2011 at 8:03 AM, Minchan Kim <minchan.kim@gmail.com> wrote:
> The lru_deactivate_fn should not move page which in on unevictable lru
> into inactive list. Otherwise, we can meet BUG when we use isolate_lru_pages
> as __isolate_lru_page could return -EINVAL.
> It's really BUG and let's fix it.
>
> Reported-by: Ying Han <yinghan@google.com>
> Tested-by: Ying Han <yinghan@google.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> ---
>  mm/swap.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/mm/swap.c b/mm/swap.c
> index a83ec5a..2e9656d 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -429,6 +429,9 @@ static void lru_deactivate_fn(struct page *page, void *arg)
>        if (!PageLRU(page))
>                return;
>
> +       if (PageUnevictable(page))
> +               return;
> +
>        /* Some processes are using the page */
>        if (page_mapped(page))
>                return;
> --
> 1.7.1

Thanks Minchan for the fix, and i haven't been able to reproducing the
issue after applying the patch.

--Ying

>
