Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab0LNXV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 18:21:56 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45443 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab0LNXVy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 18:21:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vhw4EBCvkA20I4dZXQZc9e0BV0RuN06HmJguPBeqcHQAltHBXHVnqValT28r98p5P3
         ULvjJhM22xj9ndvAc/XqmITgcf9jlj1LTJST/tVNILLBI1JDY3JhBxJsjqf/R6qE09nX
         kO1ERELLFu2zZoMiB0BeH5hGC8nK0vCwmORCs=
MIME-Version: 1.0
In-Reply-To: <20101214212909.17022.96801.stgit@mike.mtv.corp.google.com>
References: <20101214212846.17022.64836.stgit@mike.mtv.corp.google.com>
	<20101214212909.17022.96801.stgit@mike.mtv.corp.google.com>
Date: Wed, 15 Dec 2010 00:21:53 +0100
Message-ID: <AANLkTik8wzDPPtMM+YPoOSojiW_Nev-KDkAg8dtDV=g1@mail.gmail.com>
Subject: Re: [PATCH v3 03/22] netconsole: Introduce 'enabled' state-machine
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
To: Mike Waychison <mikew@google.com>
Cc: simon.kagstrom@netinsight.net, davem@davemloft.net, nhorman@tuxdriver.com,
        Matt Mackall <mpm@selenic.com>, adurbin@google.com,
        linux-kernel@vger.kernel.org, chavey@google.com,
        Greg KH <greg@kroah.com>, netdev@vger.kernel.org,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        akpm@linux-foundation.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/14 Mike Waychison <mikew@google.com>:
> Representing the internal state within netconsole isn't really a boolean
> value, but rather a state machine with transitions.
[...]
> diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
> index 6e16888..288a025 100644
> --- a/drivers/net/netconsole.c
> +++ b/drivers/net/netconsole.c
[...]
> @@ -350,9 +362,9 @@ static ssize_t store_enabled(struct netconsole_target *nt,
>                err = netpoll_setup(&nt->np);
>                spin_lock_irqsave(&target_list_lock, flags);
>                if (err)
> -                       nt->enabled = 0;
> +                       nt->np_state = NETPOLL_DISABLED;
>                else
> -                       nt->enabled = 1;
> +                       nt->np_state = NETPOLL_ENABLED;
>                spin_unlock_irqrestore(&target_list_lock, flags);
>                if (err)
>                        return err;
[...]

Since the spinlock protects only nt->np_state setting, you might be
able to remove it altogether and use cmpxchg() where nt->np_state
transitions from enabled or disabled state.

Maybe the locking scheme just needs more thought altogether?

Best Regards,
Micha³ Miros³aw
