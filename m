Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab0I1VTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 17:19:51 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61157 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab0I1VTt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 17:19:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ML/ZxYXI/bE957ueh/Umk5yL/s4mMtj0RgSHN7vln13xb5/spX/b/jqk6Kxxl9c+Pw
         tpGXXSSdDQU+E5jME5P/yBptBKysSVtCraNtBb/2guIw+FI++3nYNhw0hgIodTgFuXLs
         ZLLVYO9JCO7QXIKLOEdKRRdMGzukfEOZ3ZkhQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTikquMSnLFW2dcDEWW=Jtez5zzYSuRPFwbyVnk+y@mail.gmail.com>
References: <AANLkTi=PTp7YW_eYxtF-H2QSxgei3whWH59wU0C9oCkz@mail.gmail.com>
	<1285693648.14518.7.camel@voyager>
	<AANLkTi=NiB4hoA5Y8kbR7R8B+J-jJXAHGSu5JdOLSQsj@mail.gmail.com>
	<1285704762.14518.19.camel@voyager>
	<AANLkTikquMSnLFW2dcDEWW=Jtez5zzYSuRPFwbyVnk+y@mail.gmail.com>
Date: Tue, 28 Sep 2010 23:19:48 +0200
Message-ID: <AANLkTi=s4HJepGa32mKfCYn2sHWems09mH0DRKXqAt9R@mail.gmail.com>
Subject: Re: [uml-devel] [REGRESSION] um: ubd: block layer issue (Was: ext3
 filesystem corruption in user mode linux)
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Janjaap Bos <janjaap@bos.nl>, tj@kernel.org, axboe@kernel.dk,
        mike.miller@hp.com, user-mode-linux-devel@lists.sourceforge.net,
        adrian@mcmen.demon.co.uk, jdike@addtoit.com,
        LKML <linux-kernel@vger.kernel.org>, grant.likely@secretlab.ca,
        Geert.Uytterhoeven@sonycom.com, Chris Frey <cdfrey@foursquare.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 10:37 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
>
> This changeset from 2007 indeed moved the update of req->sector.
>
> However, in the new code, before or after applying your patch, there's no update
> of req->sector anymore. Everything is done in local variables.
>
> Is it possible that we only need the hunk below to fix the corruption?

Yes, it seems so. So far all my test cases work fine.
I'll submit a patch in a few minutes.

> | diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
> | index 5ff5546..655ed9e 100644
> | --- a/arch/um/drivers/ubd_kern.c
> | +++ b/arch/um/drivers/ubd_kern.c
> | @@ -746,8 +746,12 @@ static int ubd_open_dev(struct ubd *ubd_dev)
> |       }
> |       ubd_dev->fd = fd;
> |
> | +     /* A setting higher than 1 sector currently (v2.6.33) generates
> | +     data loss, both for raw and cow ubd. */
> | +     blk_queue_max_sectors(ubd_dev->queue, 1 * sizeof(long));
> | +     blk_queue_max_phys_segments(ubd_dev->queue, 1 * sizeof(long));
> | +
> |       if(ubd_dev->cow.file != NULL){
> | -             blk_queue_max_sectors(ubd_dev->queue, 8 * sizeof(long));
> |
> |               err = -ENOMEM;
> |               ubd_dev->cow.bitmap = vmalloc(ubd_dev->cow.bitmap_len);
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
>

-- 
Cheers,
//richard
