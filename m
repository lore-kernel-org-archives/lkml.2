Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab0IOO7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 10:59:48 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37995 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab0IOO7q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 10:59:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=dJybPymbpQ6cPUYIbAsWpsBaDuViOdHHmqrYQjHTYqER1QvdVkhtWlo7srJVTUZt0C
         y4R5YGKxRc2hVb2uFy8Xtozy2zaVP9Br7nv1Jt1Q5QYDSO9Goly3qwGOiF/6KysGIpWQ
         R7EkNPsyLExmlYFyt362wdbR6jknAPpeD+Y0c=
MIME-Version: 1.0
In-Reply-To: <1284561161-22278-1-git-send-email-lczerner@redhat.com>
References: <1284561161-22278-1-git-send-email-lczerner@redhat.com>
From: Mike Snitzer <snitzer@redhat.com>
Date: Wed, 15 Sep 2010 10:59:25 -0400
X-Google-Sender-Auth: s0SmwZv-5xqDCm4u340Towy0Y3A
Message-ID: <AANLkTinmJyJOqgSe6G0RiNUgT59wtxeT6y+0b3GivQem@mail.gmail.com>
Subject: Re: [PATCH] block: Make blkdev_issue_discard() interruptible
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, sandeen@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 10:32 AM, Lukas Czerner <lczerner@redhat.com> wrote:
> Since the discard may take quite long time, especially with really big
> extents (like the whole device for example), it would be nice to give to
> users the opportunity to abort it. This is especially useful for mkfs,
> when user can not know in advance how long it will take.
>
> In conjunction with mke2fs patch "Inform user about ongoing discard"
> it gives the user all the comfort of being informed about discard and
> being able to abort the operation.
>
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  block/blk-lib.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index d0216b9..4f54a1a 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -102,6 +102,11 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>                else if (!bio_flagged(bio, BIO_UPTODATE))
>                        ret = -EIO;
>                bio_put(bio);
> +
> +               if (signal_pending(current)) {
> +                       ret = -ERESTARTSYS;
> +                       break;
> +               }
>        }
>        return ret;
>  out_free_page:

Neil Brown recently suggested the use of fatal_signal_pending() rather
than signal_epnding() in another thread:
http://lkml.org/lkml/2010/9/12/232

I think Neil's suggestion applies here too?

Mike
