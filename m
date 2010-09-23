Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509Ab0IWVDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 17:03:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47676 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab0IWVDO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 17:03:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=XDyZGNq5MOcpqzi82gsyX02Ag8gZxwP9IXfacY/7EbHaqKpFzymzbkkb9Xe/p1UnBr
         cKKa02Lq2+0EMlMu7NwKLF6Xd2HJRpB3Io3ZijBzXZjprXXe3kzZuhVpk7TkP9QIgITV
         51fyiUp8kHBEypjBGeqLlfTsg/EmSOVFH861M=
MIME-Version: 1.0
In-Reply-To: <201009232259.20261.linux@rainbow-software.org>
References: <201009232259.20261.linux@rainbow-software.org>
Date: Thu, 23 Sep 2010 17:03:13 -0400
X-Google-Sender-Auth: Ch0WBr7_KJZXavHjVBAeaf23Fj0
Message-ID: <AANLkTikwXyr4pH5rqkoXpiYvkvpLc7s8tq-EwmM1+r7m@mail.gmail.com>
Subject: Re: [PATCH] de2104x: disable autonegotiation on broken hardware
From: Jeff Garzik <jgarzik@pobox.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: netdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 4:59 PM, Ondrej Zary <linux@rainbow-software.org> wrote:
> At least on older 21041-AA chips (mine is rev. 11), TP duplex autonegotiation
> causes the card not to work at all (link is up but no packets are transmitted).
>
> de4x5 disables autonegotiation completely. But it seems to work on newer
> (21041-PA rev. 21) so disable it only on rev<20 chips.
>
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
>
> --- linux-2.6.36-rc3-orig/drivers/net/tulip/de2104x.c   2010-08-29 17:36:04.000000000 +0200
> +++ linux-2.6.36-rc3/drivers/net/tulip/de2104x.c        2010-09-24 00:27:41.000000000 +0200
> @@ -364,6 +364,8 @@ static u16 t21040_csr15[] = { 0, 0, 0x00
>  /* 21041 transceiver register settings: TP AUTO, BNC, AUI, TP, TP FD*/
>  static u16 t21041_csr13[] = { 0xEF01, 0xEF09, 0xEF09, 0xEF01, 0xEF09, };
>  static u16 t21041_csr14[] = { 0xFFFF, 0xF7FD, 0xF7FD, 0x6F3F, 0x6F3D, };
> +/* If on-chip autonegotiation is broken, use half-duplex (FF3F) instead */
> +static u16 t21041_csr14_brk[] = { 0xFF3F, 0xF7FD, 0xF7FD, 0x6F3F, 0x6F3D, };
>  static u16 t21041_csr15[] = { 0x0008, 0x0006, 0x000E, 0x0008, 0x0008, };
>
>
> @@ -1911,8 +1913,14 @@ fill_defaults:
>        for (i = 0; i < DE_MAX_MEDIA; i++) {
>                if (de->media[i].csr13 == 0xffff)
>                        de->media[i].csr13 = t21041_csr13[i];
> -               if (de->media[i].csr14 == 0xffff)
> -                       de->media[i].csr14 = t21041_csr14[i];
> +               if (de->media[i].csr14 == 0xffff) {
> +                       /* autonegotiation is broken at least on some chip
> +                          revisions - rev. 0x21 works, 0x11 does not */
> +                       if (de->pdev->revision < 0x20)
> +                               de->media[i].csr14 = t21041_csr14_brk[i];
> +                       else
> +                               de->media[i].csr14 = t21041_csr14[i];
> +               }

Interesting...  I never knew about that quirk.

Acked-by: Jeff Garzik <jgarzik@redhat.com>
