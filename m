Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab1I1HW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 03:22:29 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34480 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1I1HW2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 03:22:28 -0400
MIME-Version: 1.0
In-Reply-To: <1317183650.2067.10.camel@shrek.rexursive.com>
References: <1317183650.2067.10.camel@shrek.rexursive.com>
Date: Wed, 28 Sep 2011 10:22:27 +0300
X-Google-Sender-Auth: Ag4koTPz8DZdjoXWnxjx_ZmTAiI
Message-ID: <CAOJsxLGam5htmwtTZOuPka02+CZ1Fkv1b+SuYMJ8x9VRntFzRQ@mail.gmail.com>
Subject: Re: [PATCH v5]: Improve performance of LZO hibernation
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Bojan Smojver <bojan@rexursive.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 7:20 AM, Bojan Smojver <bojan@rexursive.com> wrote:
> +static int lzo_compress_threadfn(void *data)
> +{
> +       struct cmp_data *d = data;
> +
> +       while(1) {
> +               wait_event(d->go, atomic_read(&d->ready) ||
> +                                 kthread_should_stop());
> +               if (kthread_should_stop())
> +                       break;

So... what happens to the hibernation process when 'kthread_should_stop()'
returns true?

> +               atomic_set(&d->ready, 0);
> +
> +               d->ret = lzo1x_1_compress(d->unc, d->unc_len,
> +                                         d->cmp + LZO_HEADER, &d->cmp_len,
> +                                         d->wrk);
> +               atomic_set(&d->stop, 1);
> +               wake_up(&d->done);
> +       }
> +
> +       return 0;
> +}
>
>  /**
>  * save_image_lzo - Save the suspend image data compressed with LZO.
> @@ -434,45 +494,74 @@ static int save_image_lzo(struct swap_map_handle *handle,
>        int ret = 0;
>        int nr_pages;
>        int err2;
> +       int cpu;
>        struct bio *bio;
>        struct timeval start;
>        struct timeval stop;
> -       size_t off, unc_len, cmp_len;
> -       unsigned char *unc, *cmp, *wrk, *page;
> +       size_t off, thr, cthr, nthr;
> +       unsigned char *page = NULL;
> +       struct cmp_data *data = NULL;
> +
> +       /*
> +        * We'll limit the number of threads for compression to limit memory
> +        * footprint.
> +        */
> +       nthr = num_online_cpus() - 1;
> +       nthr = nthr > LZO_THREADS ? LZO_THREADS : (nthr < 1 ? 1 : nthr);

That's probably one of the most unreadable uses of the ternary
operator I've ever seen!

What's going on here anyway? Why "num_online_cpus() - 1"? What's wrong with

  nr_threads = num_online_cpus();
  if (nr_threads > LZO_THREADS)
    nr_threads = LZO_THREADS;

[ And yes, please use less cryptic variable names. ]

Overall, I really like your patch!
