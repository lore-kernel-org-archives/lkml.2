Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab0HIS5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 14:57:45 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53030 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab0HIS5o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 14:57:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=O4gVw7XKTRJXw3kevmssmzmJJ4MI5dYvUxH2Bpr9zdACcpQazWQXQQfmphwjdTMQl2
         fY6bd/F8TugX4EickPEQ6m+Mak+i97ju9jIu005UfJ+NHfiumoAXfsin5v7a3Y2yPYHm
         YbY4jHikZGBtcjB1mZSPaP05WVZdzUhOl+BUg=
MIME-Version: 1.0
In-Reply-To: <1281374816-904-5-git-send-email-ngupta@vflare.org>
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>
	<1281374816-904-5-git-send-email-ngupta@vflare.org>
Date: Mon, 9 Aug 2010 21:57:42 +0300
X-Google-Sender-Auth: hTnjZFJkFPXoA56wnHEPuma-DMI
Message-ID: <AANLkTin7_fKxTzE2rngh1Ew5Ss8F_Aw0s9Gz6ySug6SX@mail.gmail.com>
Subject: Re: [PATCH 04/10] Use percpu buffers
From: Pekka Enberg <penberg@kernel.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 9, 2010 at 8:26 PM, Nitin Gupta <ngupta@vflare.org> wrote:
> @@ -303,38 +307,41 @@ static int zram_write(struct zram *zram, struct bio *bio)
>                                zram_test_flag(zram, index, ZRAM_ZERO))
>                        zram_free_page(zram, index);
>
> -               mutex_lock(&zram->lock);
> +               preempt_disable();
> +               zbuffer = __get_cpu_var(compress_buffer);
> +               zworkmem = __get_cpu_var(compress_workmem);
> +               if (unlikely(!zbuffer || !zworkmem)) {
> +                       preempt_enable();
> +                       goto out;
> +               }

The per-CPU buffer thing with this preempt_disable() trickery looks
overkill to me. Most block device drivers seem to use mempool_alloc()
for this sort of thing. Is there some reason you can't use that here?
