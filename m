Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab2IEH55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 03:57:57 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52436 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab2IEH5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 03:57:55 -0400
MIME-Version: 1.0
In-Reply-To: <5046FC22.3050509@gmail.com>
References: <1346681648-21427-1-git-send-email-clouds.yan@gmail.com>
	<1346681648-21427-2-git-send-email-clouds.yan@gmail.com>
	<50456F2E.6060408@gmail.com>
	<CAH+=+MG=9189mS7+Cb85-PV51EX1Df-zGmZ3u4YtSsEfmphYUQ@mail.gmail.com>
	<5046FC22.3050509@gmail.com>
Date: Wed, 5 Sep 2012 15:57:54 +0800
Message-ID: <CAH+=+MGaevMRUoF9CKi+YoS4ais3UFJNbQkqRfFBtgjhyWPaeQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] proc: return -ENOMEM when inode allocation failed
From: yan yan <clouds.yan@gmail.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/5 Cong Wang <xiyou.wangcong@gmail.com>:
>>> Why the !memcmp() case is related with ENOMEM ??
>>
>>
>> We are presetting 'error' here. The following proc_get_inode() will try
>> to get an inode, either from inode cache or allocate a new one (and fill
>> it).
>>
>> If we get a NULL inode, that means allocation failed. That's how
>> ENOMEM involved.
>
>
> Then the following patch is probably better than yours:
>
>
> diff --git a/fs/proc/generic.c b/fs/proc/generic.c
> index b3647fe..6b22913 100644
> --- a/fs/proc/generic.c
> +++ b/fs/proc/generic.c
> @@ -427,12 +427,16 @@ struct dentry *proc_lookup_de(struct proc_dir_entry
> *de, struct inode *dir,
>
>                 if (!memcmp(dentry->d_name.name, de->name, de->namelen)) {
>                         pde_get(de);
>                         spin_unlock(&proc_subdir_lock);
> -                       error = -EINVAL;
>                         inode = proc_get_inode(dir->i_sb, de);
> +                       if (!inode) {
> +                               error = -ENOMEM;
> +                               goto out_put;
> +                       }
>                         goto out_unlock;
>                 }
>         }
>         spin_unlock(&proc_subdir_lock);
> +
>  out_unlock:
>
>         if (inode) {
> @@ -440,6 +444,8 @@ out_unlock:
>                 d_add(dentry, inode);
>                 return NULL;
>         }
> +out_put:
> +
>         if (de)
>                 pde_put(de);
>         return ERR_PTR(error);
>
>

Change so many lines to save a assignment to 'error' ...

That's a stye issue. I prefer a simple change, though your
change seems OK to me.

Thanks
