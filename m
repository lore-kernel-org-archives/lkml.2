Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964Ab0FQPOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 11:14:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43031 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468Ab0FQPOH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 11:14:07 -0400
Subject: Re: [patch 11/33] fs: dcache scale subdirs
From: Peter Zijlstra <peterz@infradead.org>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       john stultz <johnstul@us.ibm.com>, John Kacur <jkacur@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20090904065535.609317663@nick.local0.net>
References: <20090904065142.114706411@nick.local0.net>
	 <20090904065535.609317663@nick.local0.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 17 Jun 2010 17:13:35 +0200
Message-ID: <1276787615.27822.426.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-04 at 16:51 +1000, npiggin@suse.de wrote:
> @@ -932,6 +984,7 @@ static int select_parent(struct dentry *
>         int found = 0;
>  
>         spin_lock(&dcache_lock);
> +       spin_lock(&this_parent->d_lock);
>  repeat:
>         next = this_parent->d_subdirs.next;
>  resume:
> @@ -939,8 +992,9 @@ resume:
>                 struct list_head *tmp = next;
>                 struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
>                 next = tmp->next;
> +               BUG_ON(this_parent == dentry);
>  
> -               spin_lock(&dentry->d_lock);
> +               spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);

Right, so this isn't going to work well, this dentry recursion is
basically unbounded afaict, so the 2nd subdir will also be locked using
DENRTY_D_LOCKED_NESTED, resulting in the 1st and 2nd subdir both having
the same (sub)class and lockdep doesn't like that much.

Do we really need to keep the whole path locked? One of the comments
seems to suggest we could actually drop some locks and re-acquire.

>                 dentry_lru_del_init(dentry);
>                 /* 
>                  * move only zero ref count dentries to the end 
> @@ -950,33 +1004,45 @@ resume:
>                         dentry_lru_add_tail(dentry);
>                         found++;
>                 }
> -               spin_unlock(&dentry->d_lock);
>  
>                 /*
>                  * We can return to the caller if we have found some (this
>                  * ensures forward progress). We'll be coming back to find
>                  * the rest.
>                  */
> -               if (found && need_resched())
> +               if (found && need_resched()) {
> +                       spin_unlock(&dentry->d_lock);
>                         goto out;
> +               }
>  
>                 /*
>                  * Descend a level if the d_subdirs list is non-empty.
>                  */
>                 if (!list_empty(&dentry->d_subdirs)) {
> +                       spin_unlock(&this_parent->d_lock);
> +                       spin_release(&dentry->d_lock.dep_map, 1, _RET_IP_);
>                         this_parent = dentry;
> +                       spin_acquire(&this_parent->d_lock.dep_map, 0, 1, _RET_IP_);
>                         goto repeat;
>                 }
> +
> +               spin_unlock(&dentry->d_lock);
>         } 
