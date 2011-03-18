Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020Ab1CRW13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 18:27:29 -0400
Received: from smtp-out.google.com ([74.125.121.67]:51180 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932914Ab1CRW1Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 18:27:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=DyEzNR51cTZIx3MPP1G2ZZ/KTsHwZdfzWFKgFnxsE6h7t4WmorbIS8tjuU+0mlI7RK
         Yp/wTDJ7wQ32StmeQLAw==
MIME-Version: 1.0
In-Reply-To: <20110318083723.GE8571@htj.dyndns.org>
References: <20110318083723.GE8571@htj.dyndns.org>
From: Justin TerAvest <teravest@google.com>
Date: Fri, 18 Mar 2011 15:26:59 -0700
Message-ID: <AANLkTi=uX1PbKEs1=4mfAXKEpxwy1knWrLZsY9dUNpoh@mail.gmail.com>
Subject: Re: [PATCH] block: NULL dereference on error path in __blkdev_get()
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 1:37 AM, Tejun Heo <tj@kernel.org> wrote:
> From: Dan Carpenter <error27@gmail.com>
>
> "disk" is always NULL when we goto out.  There was a check for this
> before, but it was removed in 69e02c59a7d9 "block: Don't check events
> while open is in progress".
>
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> Acked-by: Tejun Heo <tj@kernel.org>

I was running into this problem too; this patch fixes the problem.

Tested-by: Justin TerAvest <teravest@google.com>

>
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index fbe05cb..7d02afb 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1181,9 +1181,9 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
>  out_unlock_bdev:
>        mutex_unlock(&bdev->bd_mutex);
>        disk_unblock_events(disk);
> - out:
>        module_put(disk->fops->owner);
>        put_disk(disk);
> + out:
>        bdput(bdev);
>
>        return ret;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
