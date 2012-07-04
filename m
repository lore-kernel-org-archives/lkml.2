Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab2GDNFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 09:05:14 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62700 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab2GDNFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 09:05:10 -0400
MIME-Version: 1.0
In-Reply-To: <1340389359-2407-2-git-send-email-js1304@gmail.com>
References: <1340389359-2407-1-git-send-email-js1304@gmail.com>
	<1340389359-2407-2-git-send-email-js1304@gmail.com>
Date: Wed, 4 Jul 2012 16:05:09 +0300
X-Google-Sender-Auth: JYZLChb43pnmrSabtQuFBNmjnts
Message-ID: <CAOJsxLEy++a5R6-7bFaHNG4XqmvJoUTEMMJhpVD5nnxLkAafsw@mail.gmail.com>
Subject: Re: [PATCH 2/3] slub: reduce failure of this_cpu_cmpxchg in
 put_cpu_partial() after unfreezing
From: Pekka Enberg <penberg@kernel.org>
To: Joonsoo Kim <js1304@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 9:22 PM, Joonsoo Kim <js1304@gmail.com> wrote:
> In current implementation, after unfreezing, we doesn't touch oldpage,
> so it remain 'NOT NULL'. When we call this_cpu_cmpxchg()
> with this old oldpage, this_cpu_cmpxchg() is mostly be failed.
>
> We can change value of oldpage to NULL after unfreezing,
> because unfreeze_partial() ensure that all the cpu partial slabs is removed
> from cpu partial list. In this time, we could expect that
> this_cpu_cmpxchg is mostly succeed.
>
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 92f1c0e..531d8ed 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1968,6 +1968,7 @@ int put_cpu_partial(struct kmem_cache *s, struct page *page, int drain)
>                                 local_irq_save(flags);
>                                 unfreeze_partials(s);
>                                 local_irq_restore(flags);
> +                               oldpage = NULL;
>                                 pobjects = 0;
>                                 pages = 0;
>                                 stat(s, CPU_PARTIAL_DRAIN);

Makes sense. Christoph, David?
