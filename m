Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab1DGL5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 07:57:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42267 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab1DGL5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 07:57:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=m0xjMidYZRzTaWyk4JF9V+BNEk36MXnOCyexREnXE8UW9nlbgdbCPq2v/EyW9T/ugB
         XD+ypsrtKCwRxvptDRdJkm9PEJZg8skMNWZfUV5NLciKg6aCAVAaN7FLf0L+4ZXGr3M5
         Jtb61+vd6g0kAxADXLc+bjW+s1nrkvpdWoSSE=
Subject: Re: Regression from 2.6.36
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, azurIt <azurit@pobox.sk>,
        linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <BANLkTinnTnjZvQ9S1AmudZcZBokMy8-93w@mail.gmail.com>
References: <20110315132527.130FB80018F1@mail1005.cent>
	 <20110317001519.GB18911@kroah.com> <20110407120112.E08DCA03@pobox.sk>
	 <4D9D8FAA.9080405@suse.cz>
	 <BANLkTinnTnjZvQ9S1AmudZcZBokMy8-93w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Apr 2011 13:57:08 +0200
Message-ID: <1302177428.3357.25.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 07 avril 2011 à 19:21 +0800, Américo Wang a écrit :
> On Thu, Apr 7, 2011 at 6:19 PM, Jiri Slaby <jslaby@suse.cz> wrote:
> > Cced few people.
> >
> > Also the series which introduced this were discussed at:
> > http://lkml.org/lkml/2010/5/3/53


> >
> 
> I guess this is due to that lots of fdt are allocated by kmalloc(),
> not vmalloc(), and we kfree() them in rcu callback.
> 
> How about deferring all of the removal to workqueue? This may
> hurt performance I think.
> 
> Anyway, like the patch below... makes sense?
> 
> Not-yet-signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> ---
> diff --git a/fs/file.c b/fs/file.c
> index 0be3447..34dc355 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -96,20 +96,14 @@ void free_fdtable_rcu(struct rcu_head *rcu)
>                                 container_of(fdt, struct files_struct, fdtab));
>                 return;
>         }
> -       if (!is_vmalloc_addr(fdt->fd) && !is_vmalloc_addr(fdt->open_fds)) {
> -               kfree(fdt->fd);
> -               kfree(fdt->open_fds);
> -               kfree(fdt);
> -       } else {
> -               fddef = &get_cpu_var(fdtable_defer_list);
> -               spin_lock(&fddef->lock);
> -               fdt->next = fddef->next;
> -               fddef->next = fdt;
> -               /* vmallocs are handled from the workqueue context */
> -               schedule_work(&fddef->wq);
> -               spin_unlock(&fddef->lock);
> -               put_cpu_var(fdtable_defer_list);
> -       }
> +
> +       fddef = &get_cpu_var(fdtable_defer_list);
> +       spin_lock(&fddef->lock);
> +       fdt->next = fddef->next;
> +       fddef->next = fdt;
> +       schedule_work(&fddef->wq);
> +       spin_unlock(&fddef->lock);
> +       put_cpu_var(fdtable_defer_list);
>  }


Nope, this makes no sense at all.

Its probably the other way. We want to free those blocks ASAP

A fix would be to make alloc_fdmem() use vmalloc() if size is more than
4 pages, or whatever limit is reached.

We had a similar memory problem in fib_trie in the past  : We force a
synchronize_rcu() every XXX Mbytes allocated to make sure we dont have
too much ram waiting to be freed in rcu queues.







