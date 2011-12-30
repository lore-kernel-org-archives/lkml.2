Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab1L3WNe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 17:13:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49611 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab1L3WNc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 17:13:32 -0500
MIME-Version: 1.0
In-Reply-To: <20111230215024.GA5513@electric-eye.fr.zoreil.com>
References: <20111229183902.GC21946@electric-eye.fr.zoreil.com>
	<20111229.170514.1766899380937848638.davem@davemloft.net>
	<CACPM=kV8NwYLAdODQHxYmJ21X0RmZ8KJT9szKdY2xa-DsesvQg@mail.gmail.com>
	<CACPM=kVfsXgFhKheevTS1pm7kCoezKO3M+102O=PRbXzxebxxg@mail.gmail.com>
	<20111229235312.GA27092@electric-eye.fr.zoreil.com>
	<CACPM=kXTqY1kVWrEMB-Z0Lqy6t+rXvMzixcSUy7fAz6g_ajV9g@mail.gmail.com>
	<20111230125655.GA32031@electric-eye.fr.zoreil.com>
	<CACPM=kVBxcL1_Z9zVvnEEdEgAc0rbAAbzkcocz4OYWQ2xn6VmQ@mail.gmail.com>
	<20111230180347.GA3647@electric-eye.fr.zoreil.com>
	<CACPM=kXWXUE+JcVhkz-6tGZ2YyteN9sGA80+Pnw6+LaJ-eNWBA@mail.gmail.com>
	<20111230215024.GA5513@electric-eye.fr.zoreil.com>
Date: Fri, 30 Dec 2011 23:13:29 +0100
X-Google-Sender-Auth: ipe6xN-BR-ms-tcRCqhWfEukuMs
Message-ID: <CACPM=kUxSRhDc2EqgceBRTFgBei7dh3_n7bPyoH=8aNC_uq4FA@mail.gmail.com>
Subject: Re: [PATCH 1/1] via-rhine: Fix hanging with high CPU load on low-end broads.
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: David Miller <davem@davemloft.net>, shemminger@vyatta.com,
        bhutchings@solarflare.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rl@hellgate.ch
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/30 Francois Romieu <romieu@fr.zoreil.com>:
> Bjarke Istrup Pedersen <gurligebis@gentoo.org> :
> [...]
>> Just applied it to HEAD of net-next, and got the following compiler warning:
>> drivers/net/ethernet/via/via-rhine.c:2182:13: warning:
>> 'rhine_task_enable' defined but not used
>
> You are running with CONFIG_PM disabled and a down / up loop will not
> work. The patch below should hide the latter, at least as long as the
> relevant workqueue does not stall for too long... Extra cancel_work in
> task_enable could work too but it will look strange.
>
>> Just so you know that too :)

Does not build with patch:

drivers/net/ethernet/via/via-rhine.c: In function 'rhine_open':
drivers/net/ethernet/via/via-rhine.c:1539:2: error: implicit
declaration of function 'rhine_task_enable'
drivers/net/ethernet/via/via-rhine.c: At top level:
drivers/net/ethernet/via/via-rhine.c:2183:13: warning: conflicting
types for 'rhine_task_enable'
drivers/net/ethernet/via/via-rhine.c:2183:13: error: static
declaration of 'rhine_task_enable' follows non-static declaration
drivers/net/ethernet/via/via-rhine.c:1539:2: note: previous implicit
declaration of 'rhine_task_enable' was here
drivers/net/ethernet/via/via-rhine.c:2183:13: warning:
'rhine_task_enable' defined but not used

Wouldn't it be an idea to move the declarations to a via-rhine.h file,
and include it, to work around it, and seperate it like it should be?

/Bjarke

> Thanks for testing.
>
> diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
> index c57e1da..89ced1b 100644
> --- a/drivers/net/ethernet/via/via-rhine.c
> +++ b/drivers/net/ethernet/via/via-rhine.c
> @@ -1536,6 +1536,7 @@ static int rhine_open(struct net_device *dev)
>        alloc_rbufs(dev);
>        alloc_tbufs(dev);
>        rhine_chip_reset(dev);
> +       rhine_task_enable(rp);
>        init_registers(dev);
>        if (debug > 2)
>                netdev_dbg(dev, "%s() Done - status %04x MII status: %04x\n",
> --
> Ueimor
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
