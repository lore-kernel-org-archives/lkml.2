Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab0INSDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 14:03:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751740Ab0INSDJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 14:03:09 -0400
MIME-Version: 1.0
In-Reply-To: <1284483964-2370-1-git-send-email-penberg@kernel.org>
References: <1284483964-2370-1-git-send-email-penberg@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 14 Sep 2010 11:02:39 -0700
Message-ID: <AANLkTi=G6ge_FYWVDFw3HSjtF4EdDVyDg3TWxxJgYCYc@mail.gmail.com>
Subject: Re: [PATCH 1/2] SLUB: Fix merged slab cache names
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 10:06 AM, Pekka Enberg <penberg@kernel.org> wrote:
>
> @@ -3218,6 +3221,18 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
>        down_write(&slub_lock);
>        s = find_mergeable(size, align, flags, name, ctor);
>        if (s) {
> +               if (!(s->flags & SLAB_DYNAMIC_NAME)) {
> +                       const char *new_name;
> +
> +                       new_name = kstrdup(s->name, GFP_KERNEL);
> +                       if (!new_name)
> +                               goto err;
> +
> +                       s->name = new_name;

Once you do this, please actually update the name to list the first
few different names.

Since the SLAB_DYNAMIC_NAME test mean that this will only happen once,
I would suggest something like just doing

   size = strlen(s->name) + strlen(name) + sizeof(", ...");
   new_name = kmalloc(size, GFP_KERNEL);
   if (!new_name)
      return -ENOMEM;
   snprintf(new_name, "%s, %s...", s->name, name);

so that you get the two first names listed. Sure, it will be
wrong/incomplete if there's lots of merging, but it will be visually
very obvious in /proc/slabinfo and in the debug messages.

                  Linus
