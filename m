Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab2G3TMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 15:12:47 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:42029 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754553Ab2G3TMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 15:12:44 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: XsMFGqUVM1k3EJkkAFAfaormIfM6SHPGEOnjGPTziw0wWTe
 Npy4Inwoe7amEra2h13SDFnsueiDhH6WlskNq52MYnML7GlAyoq2eonqyKsU
 C2FpGJ2vn4ZzDHJVYfXzvoIz0r0Je5eRGs9FlnHLoN2rgNuzDrllU.Qvm6sJ
 yXZMt0UV4VFEakDydBKtq8Vu1B.HnZhgKoCPAHOoWTa9W5D4dmJ7dCN5oLhQ
 QmLrcONS8AXrgChYllpY4_hVoLD2_BC.zaMfqNk7.gdb1B9tPD3mAv7jqdLT
 tu_ntv5dv_ypBUGIj8eK9u_RrEMaJXqv5_OPUktyFCCdSUadxAdy6fCZsmHd
 WS97z182j7tPKYHkj6pSN2EMx2bHo26.OU2_yFWecsDM5hYo4FJl0gGeEcn_
 JmKiOJaz_wne3qPp8pGI_FqQLm1VEsDoL5zvbrQndBgHr01Q.WPk-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 30 Jul 2012 14:12:39 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: JoonSoo Kim <js1304@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] slub: remove one code path and reduce lock contention
 in __slab_free()
In-Reply-To: <CAAmzW4N5HxN+Ha_kwwKSf9na-g6bnro1UumQ+ZiQEmgS4kacrA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1207301411140.27584@router.home>
References: <1343420271-3825-1-git-send-email-js1304@gmail.com> <alpine.DEB.2.00.1207271538250.25434@router.home> <CAAmzW4N5HxN+Ha_kwwKSf9na-g6bnro1UumQ+ZiQEmgS4kacrA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jul 2012, JoonSoo Kim wrote:

> 2012/7/28 Christoph Lameter <cl@linux.com>:
> > On Sat, 28 Jul 2012, Joonsoo Kim wrote:
> >
> >> Subject and commit log are changed from v1.
> >
> > That looks a bit better. But the changelog could use more cleanup and
> > clearer expression.
> >
> >> @@ -2490,25 +2492,17 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
> >>                  return;
> >>          }
> >>
> >> +     if (unlikely(!new.inuse && n->nr_partial > s->min_partial))
> >> +             goto slab_empty;
> >> +
> >
> > So we can never encounter a empty slab that was frozen before? Really?
>
> In my suggestion,  'was_frozen = 1' is "always" handled without taking a lock.

Yepo that is true with this patch.

> Then, never hit following code.
> +     if (unlikely(!new.inuse && n->nr_partial > s->min_partial))
> +             goto slab_empty;
> +


Correct.

> Instead, hit following code.
>         if (likely(!n)) {
>
>                 /*
>                  * If we just froze the page then put it onto the
>                  * per cpu partial list.
>                  */
>                 if (new.frozen && !was_frozen) {
>                         put_cpu_partial(s, page, 1);
>                         stat(s, CPU_PARTIAL_FREE);
>                 }
>                 /*
>                  * The list lock was not taken therefore no list
>                  * activity can be necessary.
>                  */
>                 if (was_frozen)
>                         stat(s, FREE_FROZEN);
>                 return;
>         }
>
> So, even if we encounter a empty slab that was frozen before, we just
> do "stat(s, FREE_FROZEN)".
> Please let me know my answer is sufficient.

Yes.

Acked-by: Christoph Lameter <cl@linux.com>

