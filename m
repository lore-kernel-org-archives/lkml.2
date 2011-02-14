Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab1BNPQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 10:16:04 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43865 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab1BNPQC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 10:16:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v0srkvlzJ8N+7g2lxyVa/n+OrpwDj86hbeOkDjmnF+yaRSngX1zdYZIW4nIKcZh2t9
         w1SOy4PewZdvfD7bWgPOYRXz+/IKsF/6GROxUxSonBUGv5iUA6ZchvQvewv1sZgtyp4F
         y45BEAjG8mw8BSiQ/X8AwPtvzoI2MH9CFxl6g=
MIME-Version: 1.0
In-Reply-To: <1297694579-23611-1-git-send-email-segoon@openwall.com>
References: <1297694579-23611-1-git-send-email-segoon@openwall.com>
Date: Mon, 14 Feb 2011 17:16:00 +0200
Message-ID: <AANLkTimidxVJxw-XKTWwCZh8k_vKHDeqxAwVbY6+aJ6x@mail.gmail.com>
Subject: Re: [PATCH v2] core: dev: don't call BUG() on bad input
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tom Herbert <therbert@google.com>, Changli Gao <xiaosuo@gmail.com>,
        Jesse Gross <jesse@nicira.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 4:42 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> alloc_netdev() may be called with too long name (more that IFNAMSIZ bytes).
> Currently this leads to BUG().  Other insane inputs (bad txqs, rxqs) and
> even OOM don't lead to BUG().  Made alloc_netdev() return NULL, like on
> other errors.

> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -5761,7 +5761,10 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
>        size_t alloc_size;
>        struct net_device *p;
>
> -       BUG_ON(strlen(name) >= sizeof(dev->name));
> +       if (strnlen(name, sizeof(dev->name)) >= sizeof(dev->name)) {
> +               pr_err("alloc_netdev: Too long device name\n");
> +               return NULL;
> +       }

Netdevice name isn't some random junk you get from userspace, so BUG is fine.
