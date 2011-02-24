Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab1BXPJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 10:09:41 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60111 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab1BXPJi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 10:09:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=NiRmG1WlBcYsQw7+502SkMVJJhWUMp6KRM0OvNkL9pOOtQUs49k3sflzx4FSfd/7NG
         rzkhNY5Hk3tz+53lAFvNaqBb+EBpDAoYyB2o1BAqf0XbJWaXah27+HZHlxxH19H9sXLx
         lLcskncFKFV5602cqd6Wwoc064h/SxTd621Gk=
MIME-Version: 1.0
In-Reply-To: <E1PscUb-0004a3-Qi@pomaz-ex.szeredi.hu>
References: <E1PscUb-0004a3-Qi@pomaz-ex.szeredi.hu>
From: Mike Snitzer <snitzer@redhat.com>
Date: Thu, 24 Feb 2011 10:06:57 -0500
X-Google-Sender-Auth: hKk4-pwEz898CyPdWPYUjFzd8CM
Message-ID: <AANLkTikhhuUZSryKsrb0LGuyux=zvGf+ncsNZXdj5Xeh@mail.gmail.com>
Subject: Re: [PATCH] block: fix refcounting in BLKBSZSET
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        kovariadam@gmail.com, florian@mickler.org, rjw@sisk.pl, tj@kernel.org,
        linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>,
        psusi@cfl.rr.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 9:48 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> [and lkml cc-d too]
>
> This fixes bug 29202 in the 2.6.38 regression list.

It looks like this may fix bug 29792 too.

Mike

> Please apply.
>
> Thanks,
> Miklos
>
> ----
> Subject: block: fix refcounting in BLKBSZSET
>
> From: Miklos Szeredi <mszeredi@suse.cz>
>
> Adam Kovari and others reported that disconnecting an USB drive with
> an ntfs-3g filesystem would cause "kernel BUG at fs/inode.c:1421!" to
> be triggered.
>
> The BUG could be traced back to ioctl(BLKBSZSET), which would
> erroneously decrement the refcount on the bdev.  This is because
> blkdev_get() expects the refcount to be already incremented and either
> returns success or decrements the refcount and returns an error.
>
> The bug was introduced by e525fd89 (block: make blkdev_get/put()
> handle exclusive access), which didn't take into account this behavior
> of blkdev_get().
>
> Reported-by: Adam Kovari <kovariadam@gmail.com>
> CC: Tejun Heo <tj@kernel.org>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  block/ioctl.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> Index: linux.git/block/ioctl.c
> ===================================================================
> --- linux.git.orig/block/ioctl.c        2011-01-18 09:02:44.000000000 +0100
> +++ linux.git/block/ioctl.c     2011-02-24 14:23:56.000000000 +0100
> @@ -294,9 +294,11 @@ int blkdev_ioctl(struct block_device *bd
>                        return -EINVAL;
>                if (get_user(n, (int __user *) arg))
>                        return -EFAULT;
> -               if (!(mode & FMODE_EXCL) &&
> -                   blkdev_get(bdev, mode | FMODE_EXCL, &bdev) < 0)
> -                       return -EBUSY;
> +               if (!(mode & FMODE_EXCL)) {
> +                       bdgrab(bdev);
> +                       if (blkdev_get(bdev, mode | FMODE_EXCL, &bdev) < 0)
> +                               return -EBUSY;
> +               }
>                ret = set_blocksize(bdev, n);
>                if (!(mode & FMODE_EXCL))
>                        blkdev_put(bdev, mode | FMODE_EXCL);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
