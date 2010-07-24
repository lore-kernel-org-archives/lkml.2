Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab0GXMFK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 08:05:10 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49298 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619Ab0GXMFI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 08:05:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Y3f+aDQ2EI8DjjyZQtkiAMm9xVSmP1UonkpUYOMCul75gzH80/p+RYNnuPa7rxvChP
         l7c+ytiM9EtnIfeCC3Al3gZWuBJ9RpmsRvLJwOzuaANf3m4pbPoY9IEnrwD7LmOc3QI+
         9bj6DdHF+ZPUD87dGqLDdjkbXpKiw0q5+BUzo=
MIME-Version: 1.0
In-Reply-To: <20100724174405.3C99.A69D9226@jp.fujitsu.com>
References: <20100722190100.GA22269@amd>
	<20100724174038.3C96.A69D9226@jp.fujitsu.com>
	<20100724174405.3C99.A69D9226@jp.fujitsu.com>
Date: Sat, 24 Jul 2010 21:05:05 +0900
X-Google-Sender-Auth: OQ-e6yS5dAudwLYzmNZVHpoJOTI
Message-ID: <AANLkTimno0L3_6VmF11XavxLpQ1BibQ=kZUzFyF7axdb@mail.gmail.com>
Subject: Re: [PATCH 1/2] vmscan: shrink_all_slab() use reclaim_state instead 
	the return value of shrink_slab()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Frank Mayhar <fmayhar@google.com>, John Stultz <johnstul@us.ibm.com>
Cc: kosaki.motohiro@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/24 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>:
> Now, shrink_slab() doesn't return number of reclaimed objects. IOW,
> current shrink_all_slab() is broken. Thus instead we use reclaim_state
> to detect no reclaimable slab objects.
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  mm/vmscan.c |   20 +++++++++-----------
>  1 files changed, 9 insertions(+), 11 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index d7256e0..bfa1975 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -300,18 +300,16 @@ static unsigned long shrink_slab(struct zone *zone, unsigned long scanned, unsig
>  void shrink_all_slab(void)
>  {
>        struct zone *zone;
> -       unsigned long nr;
> +       struct reclaim_state reclaim_state;
>
> -again:
> -       nr = 0;
> -       for_each_zone(zone)
> -               nr += shrink_slab(zone, 1, 1, 1, GFP_KERNEL);
> -       /*
> -        * If we reclaimed less than 10 objects, might as well call
> -        * it a day. Nothing special about the number 10.
> -        */
> -       if (nr >= 10)
> -               goto again;
> +       current->reclaim_state = &reclaim_state;
> +       do {
> +               reclaim_state.reclaimed_slab = 0;
> +               for_each_zone(zone)

Oops, this should be for_each_populated_zone().


> +                       shrink_slab(zone, 1, 1, 1, GFP_KERNEL);
> +       } while (reclaim_state.reclaimed_slab);
> +
> +       current->reclaim_state = NULL;
>  }
>
>  static inline int is_page_cache_freeable(struct page *page)
> --
> 1.6.5.2
>
>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
