Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab1D0PAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:00:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61384 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab1D0PAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 11:00:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrea Righi <andrea@betterlinux.com>
Subject: Re: [PATCH] fadvise: introduce POSIX_FADV_DONTNEED_FS
Date: Wed, 27 Apr 2011 17:00:12 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Mike Frysinger <vapier@gentoo.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1303914545-15642-1-git-send-email-andrea@betterlinux.com>
In-Reply-To: <1303914545-15642-1-git-send-email-andrea@betterlinux.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201104271700.13013.arnd@arndb.de>
X-Provags-ID: V02:K0:28N9cDVU7fbqx9edhUDPZVnYjycu9RbZqVW0f4Wc8y8
 3bOJqHeiQCNO8HUtvbaFBNukbzHlCw0kRwrF04M59Ae3rAixXv
 Vbw7Wzltu6utSJiuY5Hy5nE1Ik28umoK1al1bDHWA2DjbYTRzF
 UINwsLirQ7kyuth5YgZd4Vgd8mhSLwaweaz3zKTa9jmMvW5oTg
 1I504UvFI2KcrLULrwWPQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 April 2011 16:29:05 Andrea Righi wrote:
> diff --git a/include/linux/fadvise.h b/include/linux/fadvise.h
> index e8e7471..dc9ce98 100644
> --- a/include/linux/fadvise.h
> +++ b/include/linux/fadvise.h
> @@ -13,9 +13,11 @@
>  #if defined(__s390x__)
>  #define POSIX_FADV_DONTNEED    6 /* Don't need these pages.  */
>  #define POSIX_FADV_NOREUSE     7 /* Data will be accessed once.  */
> +#define POSIX_FADV_DONTNEED_FS 8 /* Don't need these filesystem pages.  */
>  #else
>  #define POSIX_FADV_DONTNEED    4 /* Don't need these pages.  */
>  #define POSIX_FADV_NOREUSE     5 /* Data will be accessed once.  */
> +#define POSIX_FADV_DONTNEED_FS 6 /* Don't need these filesystem pages.  */
>  #endif
>  
>  #endif /* FADVISE_H_INCLUDED */

Please don't make the s390 mess worse than it already is here.
I think the best solution would be to assign new values starting
from 8 so they can be common for all architectures.

> @@ -127,6 +128,12 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
>                         invalidate_mapping_pages(mapping, start_index,
>                                                 end_index);
>                 break;
> +       case POSIX_FADV_DONTNEED_FS:
> +               if (!current_euid())
> +                       drop_pagecache_sb(file->f_dentry->d_sb, NULL);
> +               else
> +                       ret = -EPERM;
> +               break;

I somewhat disagree with keying the capability off the UID value, even
if that is what the sysctl uses. CAP_SYS_ADMIN is not that nice either, but
I think it's better than the UID here.

Aside from these, I like the patch.

	Arnd
