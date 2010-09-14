Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab0INRK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 13:10:58 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39104 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab0INRK4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 13:10:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sU3LIYFXB8ew1cgLmr6NmucVqbuCqG5pug9OhCpIwaNM1/uTKNgEFFt/SFJgf/K5oi
         9xY8thgQ/ypR0pdLBaX8yizDwrhJHEh4USvt4ZZQNiCtWMdE4wLkCvLp3VUTrjQhtHtg
         iB4bIi/9ZEP5f2G+6HeH6+rkRIQol4RvHybCs=
MIME-Version: 1.0
In-Reply-To: <1284483964-2370-2-git-send-email-penberg@kernel.org>
References: <1284483964-2370-1-git-send-email-penberg@kernel.org>
	<1284483964-2370-2-git-send-email-penberg@kernel.org>
Date: Tue, 14 Sep 2010 20:10:55 +0300
X-Google-Sender-Auth: 8pEMPS4iLwlye-D5P_1jJezHSZw
Message-ID: <AANLkTinxNbBQ3phKH8aoOSCO-+3FLn=te4OAqx4J8cU+@mail.gmail.com>
Subject: Re: [PATCH 2/2] SLUB: Mark merged slab caches in /proc/slabinfo
From: Pekka Enberg <penberg@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 8:06 PM, Pekka Enberg <penberg@kernel.org> wrote:
> SLUB uses the name of the first slab cache for all merged slab caches. To make
> the output of /proc/slabinfo more obvious, append the name of each merged slab
> cache to s->name.
>
> An example output looks like this:
>
>  bip-16,ip_dst_cache,kioctx     42     42    [snip]
>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: David Rientjes <rientjes@google.com>
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Pekka Enberg <penberg@kernel.org>

Unfortunately this breaks "slabtop". I guess we could try some other delimiter?

> ---
>  mm/slub.c |   41 ++++++++++++++++++++++++++++++-----------
>  1 files changed, 30 insertions(+), 11 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 0704288..6b08256 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3149,6 +3149,34 @@ void __init kmem_cache_init_late(void)
>  {
>  }
>
> +static int kmem_merge_names(struct kmem_cache *s, const char *name)
> +{
> +       size_t new_size;
> +       char *new_name;
> +
> +       /* Don't append name to merged name more than once */
> +       if (strstr(s->name, name))
> +               return 0;
> +
> +       /* Comma separated and NULL terminated. */
> +       new_size = strlen(s->name) + strlen(name) + 2;
> +
> +       new_name = kmalloc(new_size, GFP_KERNEL);
> +       if (!new_name)
> +               return -ENOMEM;
> +
> +       snprintf(new_name, new_size, "%s,%s", s->name, name);
> +
> +       if (s->flags & SLAB_DYNAMIC_NAME)
> +               kfree(s->name);
> +
> +       s->name = new_name;
> +
> +       s->flags |= SLAB_DYNAMIC_NAME;
> +
> +       return 0;
> +}
> +
>  /*
>  * Find a mergeable slab cache
>  */
> @@ -3221,17 +3249,8 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
>        down_write(&slub_lock);
>        s = find_mergeable(size, align, flags, name, ctor);
>        if (s) {
> -               if (!(s->flags & SLAB_DYNAMIC_NAME)) {
> -                       const char *new_name;
> -
> -                       new_name = kstrdup(s->name, GFP_KERNEL);
> -                       if (!new_name)
> -                               goto err;
> -
> -                       s->name = new_name;
> -
> -                       s->flags |= SLAB_DYNAMIC_NAME;
> -               }
> +               if (kmem_merge_names(s, name))
> +                       goto err;
>
>                s->refcount++;
>                /*
> --
> 1.6.3.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
