Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab1DGLVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 07:21:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44782 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab1DGLVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 07:21:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=rKvGEBfMws1InEiTe4X9Px3WvANHP/b5yzonw6aQVUZc4WHC8uFg2XMNkCB8BWx1dQ
         bCW6+db/M8sJDDCY6u+YNHVenRdaXkktYeemZKGmz78nipOk7rINBjZcj6Fv22SF/zJ4
         +A/elRNeKIzhQv3JLgUfF+zzP+souJs5jnDic=
MIME-Version: 1.0
In-Reply-To: <4D9D8FAA.9080405@suse.cz>
References: <20110315132527.130FB80018F1@mail1005.cent>
	<20110317001519.GB18911@kroah.com>
	<20110407120112.E08DCA03@pobox.sk>
	<4D9D8FAA.9080405@suse.cz>
Date: Thu, 7 Apr 2011 19:21:00 +0800
Message-ID: <BANLkTinnTnjZvQ9S1AmudZcZBokMy8-93w@mail.gmail.com>
Subject: Re: Regression from 2.6.36
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: azurIt <azurit@pobox.sk>, linux-kernel@vger.kernel.org,
        Changli Gao <xiaosuo@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-fsdevel@vger.kernel.org,
        Jiri Slaby <jirislaby@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 7, 2011 at 6:19 PM, Jiri Slaby <jslaby@suse.cz> wrote:
> Cced few people.
>
> Also the series which introduced this were discussed at:
> http://lkml.org/lkml/2010/5/3/53
>

I guess this is due to that lots of fdt are allocated by kmalloc(),
not vmalloc(), and we kfree() them in rcu callback.

How about deferring all of the removal to workqueue? This may
hurt performance I think.

Anyway, like the patch below... makes sense?

Not-yet-signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/fs/file.c b/fs/file.c
index 0be3447..34dc355 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -96,20 +96,14 @@ void free_fdtable_rcu(struct rcu_head *rcu)
                                container_of(fdt, struct files_struct, fdtab));
                return;
        }
-       if (!is_vmalloc_addr(fdt->fd) && !is_vmalloc_addr(fdt->open_fds)) {
-               kfree(fdt->fd);
-               kfree(fdt->open_fds);
-               kfree(fdt);
-       } else {
-               fddef = &get_cpu_var(fdtable_defer_list);
-               spin_lock(&fddef->lock);
-               fdt->next = fddef->next;
-               fddef->next = fdt;
-               /* vmallocs are handled from the workqueue context */
-               schedule_work(&fddef->wq);
-               spin_unlock(&fddef->lock);
-               put_cpu_var(fdtable_defer_list);
-       }
+
+       fddef = &get_cpu_var(fdtable_defer_list);
+       spin_lock(&fddef->lock);
+       fdt->next = fddef->next;
+       fddef->next = fdt;
+       schedule_work(&fddef->wq);
+       spin_unlock(&fddef->lock);
+       put_cpu_var(fdtable_defer_list);
 }
