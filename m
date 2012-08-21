Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab2HUGej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 02:34:39 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64079 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab2HUGef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 02:34:35 -0400
MIME-Version: 1.0
In-Reply-To: <1344451493-30836-1-git-send-email-linz@li-pro.net>
References: <1344451493-30836-1-git-send-email-linz@li-pro.net>
Date: Tue, 21 Aug 2012 16:34:34 +1000
Message-ID: <CAEgOgz5J8vw1QPL_5--c1ykac_C13hdxfJk_ksKA4X9SKJx6aw@mail.gmail.com>
Subject: Re: [PATCH] microblaze: uartlite: avoid NULL pointer exception
From: Peter Crosthwaite <peter.crosthwaite@petalogix.com>
To: Stephan Linz <linz@li-pro.net>
Cc: monstr@monstr.eu, microblaze-uclinux@itee.uq.edu.au,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 4:44 AM, Stephan Linz <linz@li-pro.net> wrote:
> 'prop' is an pointer and can only be unset (NULL) after
> prop = of_get_property() when it goes wrong.
>
> Kernel oops in ulite_probe():
>
> [    1.016645] uartlite 8fff0000.debug: failed to get alias id, errno -19
> [    1.024246] Oops: kernel access of bad area, sig: 11
> [    1.029733]  Registers dump: mode=27827D60
> [    1.034362]  r1=C79113E0, r2=00000000, r3=00000000, r4=00000000
> [    1.040918]  r5=C02E1E49, r6=C02D5918, r7=00000070, r8=000014C9
> [    1.047475]  r9=000014C8, r10=000014C9, r11=00000006, r12=FFFFFFFC
> [    1.054318]  r13=00000000, r14=C79114A0, r15=C0293BDC, r16=00000000
> [    1.061261]  r17=C0293BE4, r18=FFFFFFFE, r19=C788BDC8, r20=00000000
> [    1.068207]  r21=00000000, r22=FFFFFFED, r23=C788BDC0, r24=C033E840
> [    1.075145]  r25=C033EEA4, r26=00000000, r27=00000000, r28=00000000
> [    1.082086]  r29=00000000, r30=00000000, r31=C7824AC0, rPC=C0293BE4
> [    1.089024]  msr=000046A2, ear=00000000, esr=00000872, fsr=C7827E08
> [    1.096281] Kernel panic - not syncing: Attempted to kill init!
>
> Now it is:
>
> [    1.014924] uartlite 8fff0000.debug: failed to get alias id, errno -19
> [    1.022543] uartlite 8fff0000.debug: failed to get port-number
>
> Signed-off-by: Stephan Linz <linz@li-pro.net>
Reviewed-by: Peter Crosthwaite <peter.crosthwaite@petalogix.com>
Tested-by: Peter Crosthwaite <peter.crosthwaite@petalogix.com>

> ---
>  drivers/tty/serial/uartlite.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/tty/serial/uartlite.c b/drivers/tty/serial/uartlite.c
> index a276282..3cba732 100644
> --- a/drivers/tty/serial/uartlite.c
> +++ b/drivers/tty/serial/uartlite.c
> @@ -589,9 +589,8 @@ static int __devinit ulite_probe(struct platform_device *pdev)
>                 dev_warn(&pdev->dev, "failed to get alias id, errno %d\n", id);
>                 /* Fall back to old port-number property */
>                 prop = of_get_property(pdev->dev.of_node, "port-number", NULL);
> -               if (prop < 0) {
> -                       dev_warn(&pdev->dev,
> -                               "failed to get port-number, errno %d\n", prop);
> +               if (!prop) {
> +                       dev_warn(&pdev->dev, "failed to get port-number\n");
>                         id = -1;
>                 } else
>                         id = be32_to_cpup(prop);
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
