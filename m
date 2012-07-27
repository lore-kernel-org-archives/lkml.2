Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab2G0Uqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 16:46:32 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:28252 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752308Ab2G0Uqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 16:46:30 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: TqKV36IVM1mwkjdRWDib8sSCIRzQF7QDtY8P7ryAggRNxnH
 ObeJeCLfTUJXdC64UEN9UMcXJttFDI.bs8MJLBZz3QIKL.c3SH.OmbyzlGMM
 uQd7dK402scNl4hTYbsXh8X756WkWey2zly2.MAHHi3ngMaIYnJMpOspunlH
 WLm2WB9Xe05bWZWQlySt2.S5gidn4LzKUGcCGu40VCcBddVbQam8ftQyT94X
 5QseAMcRIV9H6QQOSSUnfim1EiMvdxd2i_n9UkeDrMfTwe77e.B7kbWAaAMt
 x.vHwTYer5Mm8eKJSSbJoadgBn.3DVYfac9D8uwObd_UsA7o58bWi53HK9Cs
 E4pDQt6ZsEvQ6T9yxFaaVV7mMafdpI2IuHFe1oC63XFOfgURPc9IkvBsBD8T
 FJjGcaUhw4ZMAR.Ogj8PyyIgzlbtkHc7NZNuyRZ.7DyU5mXJe2Tw-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 27 Jul 2012 15:46:24 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Joonsoo Kim <js1304@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] slub: remove one code path and reduce lock contention
 in __slab_free()
In-Reply-To: <1343420271-3825-1-git-send-email-js1304@gmail.com>
Message-ID: <alpine.DEB.2.00.1207271538250.25434@router.home>
References: <1343420271-3825-1-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jul 2012, Joonsoo Kim wrote:

> Subject and commit log are changed from v1.

That looks a bit better. But the changelog could use more cleanup and
clearer expression.

> @@ -2490,25 +2492,17 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
>                  return;
>          }
>
> +	if (unlikely(!new.inuse && n->nr_partial > s->min_partial))
> +		goto slab_empty;
> +

So we can never encounter a empty slab that was frozen before? Really?

Remote frees can decrement inuse again. All objects of a slab frozen on
one cpu could be allocated while the slab is still frozen. The
unfreezing requires slab_alloc to encounter a NULL pointer after all.

A remote processor could obtain a pointer to all these objects and free
them. The code here would cause an unfreeze action. Another alloc on the
first processor would cause a *second* unfreeze action on a page that was
freed.
