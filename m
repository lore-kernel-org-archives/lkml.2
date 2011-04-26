Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab1DZJ2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 05:28:05 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48330 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab1DZJ2D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 05:28:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WIoNVZc/k1SXaH0bW4mcCOrZ1ZHOJjPxY98v99M8LTnRmB2LCrBVlBuJLojD+RhwTm
         OHicrbvK7u+AxhQ690PK94tv0INhEM4QJ49Rfr4OP5dK2DlGRb1hPnyc8LAy7FeXe3VP
         FOHTfX+/2giJwdal1/BNV4Nr0I6fKPdIoSdD0=
MIME-Version: 1.0
In-Reply-To: <20110426085953.GA12389@darkstar>
References: <20110426085953.GA12389@darkstar>
Date: Tue, 26 Apr 2011 18:28:01 +0900
Message-ID: <BANLkTikkUq7rg4umYQ5yt9ve+q34Pf+=Ag@mail.gmail.com>
Subject: Re: [PATCH v2] virtio_balloon: disable oom killer when fill balloon
From: Minchan Kim <minchan.kim@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please resend this with [2/2] to linux-mm.

On Tue, Apr 26, 2011 at 5:59 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> When memory pressure is high, virtio ballooning will probably cause oom killing.
> Even if alloc_page with GFP_NORETRY itself does not directly trigger oom it
> will make memory becoming low then memory alloc of other processes will trigger
> oom killing. It is not desired behaviour.

I can't understand why it is undesirable.
Why do we have to handle it specially?


>
> Here disable oom killer in fill_balloon to address this issue.
> Add code comment as KOSAKI Motohiro's suggestion.
>
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> ---
>  drivers/virtio/virtio_balloon.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
>
> --- linux-2.6.orig/drivers/virtio/virtio_balloon.c      2011-04-26 11:39:14.053118406 +0800
> +++ linux-2.6/drivers/virtio/virtio_balloon.c   2011-04-26 16:54:56.419741542 +0800
> @@ -25,6 +25,7 @@
>  #include <linux/freezer.h>
>  #include <linux/delay.h>
>  #include <linux/slab.h>
> +#include <linux/oom.h>
>
>  struct virtio_balloon
>  {
> @@ -102,6 +103,12 @@ static void fill_balloon(struct virtio_b
>        /* We can only do one array worth at a time. */
>        num = min(num, ARRAY_SIZE(vb->pfns));
>
> +       /* Disable oom killer for indirect oom due to our memory consuming
> +        * Currently only hibernation code use oom_killer_disable,

Hmm, Please look at current mmotm. Now oom_killer_disabled is used by
do_try_to_free_pages in mmotm so it could make unnecessary oom kill.

BTW, I can't understand why we need to handle virtio by special.
Could you explain it in detail? :)



-- 
Kind regards,
Minchan Kim
