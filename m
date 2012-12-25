Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab2LYPiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 10:38:17 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:51510 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab2LYPiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 10:38:15 -0500
MIME-Version: 1.0
In-Reply-To: <1356449082-3016-1-git-send-email-js1304@gmail.com>
References: <CAAvDA15U=KCOujRYA5k3YkvC9Z=E6fcG5hopPUJNgULYj_MAJw@mail.gmail.com>
	<1356449082-3016-1-git-send-email-js1304@gmail.com>
Date: Wed, 26 Dec 2012 00:30:15 +0900
Message-ID: <CAAmzW4Nz6if==JjxLQGYwwQwKPDXfUbeioyPHWZQQFNu=xXUeQ@mail.gmail.com>
Subject: Re: [PATCH] slub: assign refcount for kmalloc_caches
From: JoonSoo Kim <js1304@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Paul Hargrove <phhargrove@lbl.gov>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Joonsoo Kim <js1304@gmail.com>,
        Christoph Lameter <cl@linux.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/26 Joonsoo Kim <js1304@gmail.com>:
> commit cce89f4f6911286500cf7be0363f46c9b0a12ce0('Move kmem_cache
> refcounting to common code') moves some refcount manipulation code to
> common code. Unfortunately, it also removed refcount assignment for
> kmalloc_caches. So, kmalloc_caches's refcount is initially 0.
> This makes errornous situation.
>
> Paul Hargrove report that when he create a 8-byte kmem_cache and
> destory it, he encounter below message.
> 'Objects remaining in kmalloc-8 on kmem_cache_close()'
>
> 8-byte kmem_cache merge with 8-byte kmalloc cache and refcount is
> increased by one. So, resulting refcount is 1. When destory it, it hit
> refcount = 0, then kmem_cache_close() is executed and error message is
> printed.
>
> This patch assign initial refcount 1 to kmalloc_caches, so fix this
> errornous situtation.
>
> Cc: <stable@vger.kernel.org> # v3.7
> Cc: Christoph Lameter <cl@linux.com>
> Reported-by: Paul Hargrove <phhargrove@lbl.gov>
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
>
> diff --git a/mm/slub.c b/mm/slub.c
> index a0d6984..321afab 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3279,6 +3279,7 @@ static struct kmem_cache *__init create_kmalloc_cache(const char *name,
>         if (kmem_cache_open(s, flags))
>                 goto panic;
>
> +       s->refcount = 1;
>         list_add(&s->list, &slab_caches);
>         return s;
>
> --
> 1.7.9.5
>

I missed some explanation.
In v3.8-rc1, this problem is already solved.
See create_kmalloc_cache() in mm/slab_common.c.
So this patch is just for v3.7 stable.
