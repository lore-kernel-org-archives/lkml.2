Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab1LVQ6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 11:58:40 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36381 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab1LVQ6h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 11:58:37 -0500
MIME-Version: 1.0
In-Reply-To: <4EF2F9EB.7000006@jp.fujitsu.com>
References: <4EF2F9EB.7000006@jp.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Thu, 22 Dec 2011 11:58:13 -0500
Message-ID: <CAHGf_=ov5B6LTB+fXHAsVkw-qW7QrnJ1y-nEzWOxPK_KKm7hGQ@mail.gmail.com>
Subject: Re: [PATCH] mm: mmap system call does not return EOVERFLOW
To: Naotaka Hamaguchi <n.hamaguchi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> To fix this bug, it is necessary to compare "off" plus "len"
> with "off" by units of "off_t". The patch is here:
>
> Signed-off-by: Naotaka Hamaguchi <n.hamaguchi@jp.fujitsu.com>
> ---
>  mm/mmap.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index eae90af..e74e736 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -948,6 +948,7 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
>        vm_flags_t vm_flags;
>        int error;
>        unsigned long reqprot = prot;
> +       off_t off = pgoff << PAGE_SHIFT;
>
>        /*
>         * Does the application expect PROT_READ to imply PROT_EXEC?
> @@ -971,7 +972,7 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
>                return -ENOMEM;
>
>        /* offset overflow? */
> -       if ((pgoff + (len >> PAGE_SHIFT)) < pgoff)
> +       if ((off + len) < off)
>                return -EOVERFLOW;

Hmm...
pgoff doesn't make actual overflow. do_mmap_pgoff() can calculate big
value. We have
no reason to make artificial limit. Why don't you meke a overflow
check in sys_mmap()?
