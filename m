Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934059Ab0J1Rij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 13:38:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41802 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934042Ab0J1Rie convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 13:38:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NpLDjrGxutNkinCCGGxRCKj+uaPLhhrZPwKrDJAlRZEUVv632EsdHn8GZDjmDlVLCe
         nxRWjFHj/RQN4NWTJEyy/755tneQS+jGmwIiSFok0RXD9cBdMdxRXCTTf52CF8MH965G
         L564U956xSDvli5vCPygldg9Zp/ph2rjPgvbg=
MIME-Version: 1.0
In-Reply-To: <1285271646-2768-2-git-send-email-vgoyal@redhat.com>
References: <1285271646-2768-1-git-send-email-vgoyal@redhat.com>
	<1285271646-2768-2-git-send-email-vgoyal@redhat.com>
Date: Thu, 28 Oct 2010 19:38:33 +0200
X-Google-Sender-Auth: LsQB7t_1n4HLCidsWK7KlzVjiyc
Message-ID: <AANLkTi=KDqSu8PrR2JbNzwv_Z93G6X5MRqbEiSF9hVgH@mail.gmail.com>
Subject: Re: [PATCH 1/2] amiga floppy: Stop sharing request queue across
 multiple gendisks
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, hch@lst.de,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 21:54, Vivek Goyal <vgoyal@redhat.com> wrote:
> o Use one request queue per gendisk instead of sharing request queue
>
> o Don't have hardware. No compile testing or run time testing done. Completely
>  untested.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  drivers/block/amiflop.c |   59 ++++++++++++++++++++++++++++++++++++++--------
>  1 files changed, 48 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
> index 76f114f..ead8b77 100644
> --- a/drivers/block/amiflop.c
> +++ b/drivers/block/amiflop.c
> @@ -114,8 +114,6 @@ static unsigned long int fd_def_df0 = FD_DD_3;     /* default for df0 if it does
>  module_param(fd_def_df0, ulong, 0);
>  MODULE_LICENSE("GPL");
>
> -static struct request_queue *floppy_queue;
> -
>  /*
>  *  Macros
>  */
> @@ -164,6 +162,7 @@ static volatile int selected = -1;  /* currently selected drive */
>  static int writepending;
>  static int writefromint;
>  static char *raw_buf;
> +static int fdc_queue;
>
>  static DEFINE_SPINLOCK(amiflop_lock);
>
> @@ -1334,6 +1333,42 @@ static int get_track(int drive, int track)
>        return -1;
>  }
>
> +/*
> + * Round-robin between our available drives, doing one request from each
> + */
> +static struct request *set_next_request(void)
> +{
> +       struct request_queue *q;
> +       int cnt = FD_MAX_UNITS;
> +       struct request *rq;
> +
> +       /* Find next queue we can dispatch from */
> +       fdc_queue = fdc_queue + 1;
> +       if (fdc_queue == FD_MAX_UNITS)
> +               fdc_queue = 0;
> +
> +       for(cnt = FD_MAX_UNITS; cnt > 0, cnt--) {
> +
> +               if (unit[fdc_queue].type->code == FD_NODRIVE) {
> +                       if (++fdc_queue == FD_MAX_UNITS)
> +                               fdc_queue = 0;
> +                       cotinue;
> +               }
> +
> +               q = unit[fdc_queue].gendisk->queue;
> +               if (q) {
> +                       rq = blk_fetch_request(q);
> +                       if (rq)
> +                               break;
> +               }
> +
> +               if (++fdc_queue == FD_MAX_UNITS)
> +                       fdc_queue = 0;
> +       }
> +
> +       return rq;
> +}

drivers/block/amiflop.c:1344: warning: ‘rq’ may be used uninitialized
in this function
drivers/block/ataflop.c:1402: warning: ‘rq’ may be used uninitialized
in this function

Should `rq' just be initialized to NULL? I looked at
floppy.c:set_next_request(), but it's
completely different.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
