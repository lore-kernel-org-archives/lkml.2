Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760210Ab0LNXP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 18:15:26 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53533 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759240Ab0LNXPY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 18:15:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Oyqly72E5uEki6f73ng96otsoF1rYRlkXvas1MFMTLE0a76o8R2VcKaSqhxwEdANkJ
         Yi8KhkxVkDoD+kyQK9DOU8laZSMrjp4xjR+90ntXGOqaG7/pycs6YtD2L+uzIDS/Br6m
         MSA0i8TE889LjACh/wBz99LCbKA0ac1YpQ2B0=
MIME-Version: 1.0
In-Reply-To: <20101214212904.17022.16604.stgit@mike.mtv.corp.google.com>
References: <20101214212846.17022.64836.stgit@mike.mtv.corp.google.com>
	<20101214212904.17022.16604.stgit@mike.mtv.corp.google.com>
Date: Wed, 15 Dec 2010 00:15:23 +0100
Message-ID: <AANLkTi=reqRMrv4k5EZKdj7pmsomApw9=Kwh9nxfKCuJ@mail.gmail.com>
Subject: Re: [PATCH v3 02/22] netconsole: Introduce locking over the netpoll fields
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
> The netconsole driver currently doesn't do any locking over its
> configuration fields.  This can cause problems if we were to ever have
> concurrent writing to fields while somebody is enabling the service.
>
> For simplicity, this patch extends targets_list_lock to cover all
> configuration fields within the targets.  Macros are also added here to
> wrap accessors so that we check whether the target has been enabled with
> locking handled.
>
> Signed-off-by: Mike Waychison <mikew@google.com>
> Acked-by: Matt Mackall <mpm@selenic.com>
> ---
>  drivers/net/netconsole.c |  114 ++++++++++++++++++++++++++--------------------
>  1 files changed, 64 insertions(+), 50 deletions(-)
>
> diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
> index c87a49e..6e16888 100644
> --- a/drivers/net/netconsole.c
> +++ b/drivers/net/netconsole.c
> @@ -327,6 +327,7 @@ static ssize_t store_enabled(struct netconsole_target *nt,
>                             const char *buf,
>                             size_t count)
>  {
> +       unsigned long flags;
>        int err;
>        long enabled;
>
> @@ -335,6 +336,10 @@ static ssize_t store_enabled(struct netconsole_target *nt,
>                return enabled;
>
>        if (enabled) {  /* 1 */
> +               spin_lock_irqsave(&target_list_lock, flags);
> +               if (nt->enabled)
> +                       goto busy;
> +               spin_unlock_irqrestore(&target_list_lock, flags);
>

This looks wrong. Unless there is another lock or mutex covering this
function, at this point (after spin_unlock_irqrestore()) another
thread might set nt->enabled = 1.

Best Regards,
Micha³ Miros³aw
