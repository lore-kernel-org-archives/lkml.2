Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab0GMRwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 13:52:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45255 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849Ab0GMRwJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 13:52:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ewswiUjKlCIicEqBEAnima2T3SnmLiOyKs0lQgNWLaPX8PK1kBE8DyHeI8LHa4SrxP
         f+AWeTKoFXz3zcKnCB1QABSalVaxkLfB9FLEmg3K4ZU/9glf8fmxvVzcj/pryeaRLeKN
         SfU6aaCtYapgk4TAVH8wG15x9SLOHfA8sdpU4=
MIME-Version: 1.0
In-Reply-To: <1278756333-6850-1-git-send-email-lliubbo@gmail.com>
References: <1278756333-6850-1-git-send-email-lliubbo@gmail.com>
Date: Tue, 13 Jul 2010 20:52:04 +0300
X-Google-Sender-Auth: wfInXTqIWvLO_gfkAR8hMM4SS-I
Message-ID: <AANLkTikMcPcldBh_uVKxrH7rEIUju3Y_3X2jLi9jw2Vs@mail.gmail.com>
Subject: Re: [PATCH] slob_free:free objects to their own list
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Bob Liu <lliubbo@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, mpm@selenic.com,
        hannes@cmpxchg.org, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bob,

[ Please CC me on SLOB patches. You can use the 'scripts/get_maintainer.pl'
  script to figure out automatically who to CC on your patches. ]

On Sat, Jul 10, 2010 at 1:05 PM, Bob Liu <lliubbo@gmail.com> wrote:
> slob has alloced smaller objects from their own list in reduce
> overall external fragmentation and increase repeatability,
> free to their own list also.
>
> Signed-off-by: Bob Liu <lliubbo@gmail.com>

The patch looks sane to me. Matt, does it look OK to you as well?

It would be nice to have some fragmentation numbers for this. One
really simple test case is to grep for MemTotal and MemFree in
/proc/meminfo. I'd expect to see some small improvement with your
patch applied. Quantifying long term fragmentation would be even
better but I don't have a good test case for that so I'm CC'ing Mel.

> ---
>  mm/slob.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
>
> diff --git a/mm/slob.c b/mm/slob.c
> index 3f19a34..d582171 100644
> --- a/mm/slob.c
> +++ b/mm/slob.c
> @@ -396,6 +396,7 @@ static void slob_free(void *block, int size)
>        slob_t *prev, *next, *b = (slob_t *)block;
>        slobidx_t units;
>        unsigned long flags;
> +       struct list_head *slob_list;
>
>        if (unlikely(ZERO_OR_NULL_PTR(block)))
>                return;
> @@ -424,7 +425,13 @@ static void slob_free(void *block, int size)
>                set_slob(b, units,
>                        (void *)((unsigned long)(b +
>                                        SLOB_UNITS(PAGE_SIZE)) & PAGE_MASK));
> -               set_slob_page_free(sp, &free_slob_small);
> +               if (size < SLOB_BREAK1)
> +                       slob_list = &free_slob_small;
> +               else if (size < SLOB_BREAK2)
> +                       slob_list = &free_slob_medium;
> +               else
> +                       slob_list = &free_slob_large;
> +               set_slob_page_free(sp, slob_list);
>                goto out;
>        }
>
> --
> 1.5.6.3
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
