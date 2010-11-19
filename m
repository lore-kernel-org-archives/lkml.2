Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab0KSTlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 14:41:37 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61677 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab0KSTlf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 14:41:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=MkZWHUkIMcyoNGz4x3Z9t7qn8lyf9dPuzX0vXicadetCpUqzTmYHOrQBYpMGh3NPmf
         b0ZcwI1cA/aXHiXeoHkyDVI+B4QFY9mQJx+N/227gFlES9tAoUVkLNaEmjcIYx7cG8K3
         RVkPI8nMiUzTZzWfQ3AxZjzb7d4TVnS8Ey+54=
MIME-Version: 1.0
In-Reply-To: <20101116142029.528762151@kernel.dk>
References: <20101116140900.039761100@kernel.dk>
	<20101116142029.528762151@kernel.dk>
Date: Fri, 19 Nov 2010 11:41:25 -0800
X-Google-Sender-Auth: p9o5LNEe8xyVBoe6CpWWOAD2gzM
Message-ID: <AANLkTimhArQ_NStZqxKcq-bzMWG3NpWK-N9+njdqfR0c@mail.gmail.com>
Subject: Re: [patch 14/28] fs: dcache scale subdirs
From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 6:09 AM, Nick Piggin <npiggin@kernel.dk> wrote:

> Index: linux-2.6/fs/dcache.c
> ===================================================================
> --- linux-2.6.orig/fs/dcache.c  2010-11-17 00:52:37.000000000 +1100
> +++ linux-2.6/fs/dcache.c       2010-11-17 01:05:44.000000000 +1100

> @@ -217,24 +219,22 @@ static void dentry_lru_move_tail(struct
>  *
>  * If this is the root of the dentry tree, return NULL.
>  *
> - * dcache_lock and d_lock must be held by caller, are dropped by d_kill.
> + * dcache_lock and d_lock and d_parent->d_lock must be held by caller, and
> + * are dropped by d_kill.
>  */
> -static struct dentry *d_kill(struct dentry *dentry)
> +static struct dentry *d_kill(struct dentry *dentry, struct dentry *parent)
>        __releases(dentry->d_lock)
> +       __releases(parent->d_lock)
>        __releases(dcache_lock)
>  {
> -       struct dentry *parent;
> -
>        list_del(&dentry->d_u.d_child);
> +       if (parent)
> +               spin_unlock(&parent->d_lock);
>        dentry_iput(dentry);
>        /*
>         * dentry_iput drops the locks, at which point nobody (except
>         * transient RCU lookups) can reach this dentry.
>         */
> -       if (IS_ROOT(dentry))
> -               parent = NULL;
> -       else
> -               parent = dentry->d_parent;
>        d_free(dentry);
>        return parent;
>  }
> @@ -270,6 +270,7 @@ static struct dentry *d_kill(struct dent
>
>  void dput(struct dentry *dentry)
>  {
> +       struct dentry *parent;
>        if (!dentry)
>                return;
>
> @@ -277,6 +278,10 @@ void dput(struct dentry *dentry)
>        if (dentry->d_count == 1)
>                might_sleep();
>        spin_lock(&dentry->d_lock);
> +       if (IS_ROOT(dentry))
> +               parent = NULL;
> +       else
> +               parent = dentry->d_parent;
>        if (dentry->d_count == 1) {
>                if (!spin_trylock(&dcache_lock)) {
>                        /*

Removed one and added three of the IS_ROOT() checks I think...Maybe
add a macro for setting the local parent pointer?  Ah never mind.  In
patch 28 they collapse back into a single instance.

In this patch the nested locking starts to feel a little more natural
to me.  The last number of patches in the series end up re-simplifying
a lot of intermediate complexity.
