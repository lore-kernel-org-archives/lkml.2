Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585Ab2IEVhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 17:37:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54170 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759538Ab2IEVhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 17:37:02 -0400
Date: Wed, 5 Sep 2012 14:37:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: yan <clouds.yan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3 v2] proc: use kzalloc instead of kmalloc and memset
Message-Id: <20120905143700.7bfc3b1e.akpm@linux-foundation.org>
In-Reply-To: <1346847437-3308-4-git-send-email-clouds.yan@gmail.com>
References: <1346847437-3308-1-git-send-email-clouds.yan@gmail.com>
	<1346847437-3308-4-git-send-email-clouds.yan@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 Sep 2012 20:17:17 +0800
yan <clouds.yan@gmail.com> wrote:

> Part of the memory will be written twice after this change, but that 
> should be negligible.
> 
> ...
>
> --- a/fs/proc/generic.c
> +++ b/fs/proc/generic.c
> @@ -616,10 +616,9 @@ static struct proc_dir_entry *__proc_create(struct proc_dir_entry **parent,
>  
>  	len = strlen(fn);
>  
> -	ent = kmalloc(sizeof(struct proc_dir_entry) + len + 1, GFP_KERNEL);
> +	ent = kzalloc(sizeof(struct proc_dir_entry) + len + 1, GFP_KERNEL);
>  	if (!ent) goto out;
>  
> -	memset(ent, 0, sizeof(struct proc_dir_entry));
>  	memcpy(ent->name, fn, len + 1);
>  	ent->namelen = len;
>  	ent->mode = mode;

I'm not sure that I really like the idea of adding this additional
overhead.  But sure, it won't matter to anyone at all.

While we're digging around in __proc_create(), how about we fix a few
other things?


From: Andrew Morton <akpm@linux-foundation.org>
Subject: proc-use-kzalloc-instead-of-kmalloc-and-memset-fix

fix __proc_create() coding-style issues, remove unneeded zero-initialisations

Cc: yan <clouds.yan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/proc/generic.c~proc-use-kzalloc-instead-of-kmalloc-and-memset-fix fs/proc/generic.c
--- a/fs/proc/generic.c~proc-use-kzalloc-instead-of-kmalloc-and-memset-fix
+++ a/fs/proc/generic.c
@@ -605,7 +605,8 @@ static struct proc_dir_entry *__proc_cre
 	unsigned int len;
 
 	/* make sure name is valid */
-	if (!name || !strlen(name)) goto out;
+	if (!name || !strlen(name))
+		goto out;
 
 	if (xlate_proc_name(name, parent, &fn) != 0)
 		goto out;
@@ -617,18 +618,17 @@ static struct proc_dir_entry *__proc_cre
 	len = strlen(fn);
 
 	ent = kzalloc(sizeof(struct proc_dir_entry) + len + 1, GFP_KERNEL);
-	if (!ent) goto out;
+	if (!ent)
+		goto out;
 
 	memcpy(ent->name, fn, len + 1);
 	ent->namelen = len;
 	ent->mode = mode;
 	ent->nlink = nlink;
 	atomic_set(&ent->count, 1);
-	ent->pde_users = 0;
 	spin_lock_init(&ent->pde_unload_lock);
-	ent->pde_unload_completion = NULL;
 	INIT_LIST_HEAD(&ent->pde_openers);
- out:
+out:
 	return ent;
 }
 
_

