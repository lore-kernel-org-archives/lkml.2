Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab0IYU6N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 16:58:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40547 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab0IYU6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 16:58:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PLXIdhMAdolE3DQpw5fywxnbXoFhU0GHnYABgOVps89XAot8fGoWcI+0uo3WuHS56+
         A7XUzIg+qD7LgBBdqU0ZU9Ub8UR3VPOfvWTCugqtmiUm/9+KCWuArQIeLrgZmUq8yFzH
         WnD+NBxcYfubCzd+U72DuqJmH8hI+a4F7TBAI=
MIME-Version: 1.0
In-Reply-To: <201009252239.21376.linux@rainbow-software.org>
References: <201009252239.21376.linux@rainbow-software.org>
Date: Sat, 25 Sep 2010 16:58:10 -0400
X-Google-Sender-Auth: 0B8ZghUJKi9EzRxUv03scOlNrNg
Message-ID: <AANLkTikasuZbf6ymCWBjAW3oq7+BBox1N06jPZqTBQr4@mail.gmail.com>
Subject: Re: [PATCH] de2104x: fix TP link detection
From: Jeff Garzik <jgarzik@pobox.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: netdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o8PKwMde010757

On Sat, Sep 25, 2010 at 4:39 PM, Ondrej Zary <linux@rainbow-software.org> wrote:
> @@ -1160,14 +1164,29 @@ no_link_yet:
>  static void de_media_interrupt (struct de_private *de, u32 status)
>  {
>        if (status & LinkPass) {
> +               /* Ignore if current media is AUI or BNC and we can't use TP */
> +               if ((de->media_type == DE_MEDIA_AUI ||
> +                    de->media_type == DE_MEDIA_BNC) &&
> +                   (de->media_lock ||
> +                    !de_ok_to_advertise(de, DE_MEDIA_TP_AUTO)))
> +                       return;
> +               /* If current media is not TP, change it to TP */
> +               if ((de->media_type == DE_MEDIA_AUI ||
> +                    de->media_type == DE_MEDIA_BNC)) {
> +                       de->media_type = DE_MEDIA_TP_AUTO;
> +                       de_stop_rxtx(de);
> +                       de_set_media(de);
> +                       de_start_rxtx(de);
> +               }
>                de_link_up(de);
>                mod_timer(&de->media_timer, jiffies + DE_TIMER_LINK);
>                return;
>        }
>
>        BUG_ON(!(status & LinkFail));
> -
> -       if (netif_carrier_ok(de->dev)) {
> +       /* Mark the link as down only if current media is TP */
> +       if (netif_carrier_ok(de->dev) && de->media_type != DE_MEDIA_AUI &&
> +           de->media_type != DE_MEDIA_BNC) {
>                de_link_down(de);
>                mod_timer(&de->media_timer, jiffies + DE_TIMER_NO_LINK);
>        }

Acked-by: Jeff Garzik <jgarzik@redhat.com>
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
