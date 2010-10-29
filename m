Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab0J2Gfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 02:35:47 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55457 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab0J2Gfj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 02:35:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=WlaCwR8iPezGwc3YpcW5O4z4O7Lszqxy4hEN3KIhhtxzdZ26wuHaEMl/7t7UxdnCxA
         wGdzffG6nHXfKlObKd5Mq9l/7leEKR/HxS1FS9nSxVK4eg/xIGMfPLEKPU88m1RozPbF
         NX+37wf3q9RFE9QqYLJGxgYMNCNW5g8F+5wl8=
MIME-Version: 1.0
In-Reply-To: <20101028140621.GE6062@bicker>
References: <20101028140621.GE6062@bicker>
Date: Fri, 29 Oct 2010 14:35:37 +0800
X-Google-Sender-Auth: pgsLXjRudiGs3_7PIQs64G7Y2dk
Message-ID: <AANLkTi=3wFj3CGDbdXmVFAS6EcXjyQhpAw4t9VnKf0iu@mail.gmail.com>
Subject: Re: [patch] rapidio: use resource_size()
From: Li Yang <leoli@freescale.com>
To: Dan Carpenter <error27@gmail.com>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Li Yang <leoli@freescale.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 10:06 PM, Dan Carpenter <error27@gmail.com> wrote:
> The size calculation is done incorrectly here because it should include
> both the start and end (end - start + 1).  It's easiest to just use
> resource_size() which does the right thing.
>
> I was worried there was something non-standard going on because the
> printk() subtracts "end - 1", but the rest of the file uses the normal
> resource size calculations.  This function is only called from

Looks like a non-standard hack to make the res.end equal to actual end
+ 1.  I have updated the fsl_rio.c to use standard resource semantic,
so the hack was long broken.

> fsl_rio_setup() in arch/powerpc/sysdev/fsl_rio.c and the calculation
> there is also:
>        port->iores.start = law_start;
>        port->iores.end = law_start + law_size - 1;
> So I think this is the correct fix.
>
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Li Yang <leoli@freescale.com>

> ---
> Compile tested only.
>
> diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
> index 68cf0c9..7b5080c 100644
> --- a/drivers/rapidio/rio.c
> +++ b/drivers/rapidio/rio.c
> @@ -1159,11 +1159,11 @@ int __devinit rio_init_mports(void)
>
>        list_for_each_entry(port, &rio_mports, node) {
>                if (!request_mem_region(port->iores.start,
> -                                       port->iores.end - port->iores.start,
> +                                       resource_size(&port->iores),
>                                        port->name)) {
>                        printk(KERN_ERR
>                               "RIO: Error requesting master port region 0x%016llx-0x%016llx\n",
> -                              (u64)port->iores.start, (u64)port->iores.end - 1);
> +                              (u64)port->iores.start, (u64)port->iores.end);
>                        rc = -ENOMEM;
>                        goto out;
>                }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
- Leo
