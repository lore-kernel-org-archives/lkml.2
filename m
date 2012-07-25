Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372Ab2GYEvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 00:51:00 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:39725 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab2GYEu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 00:50:59 -0400
MIME-Version: 1.0
In-Reply-To: <1343141382-31087-1-git-send-email-benchan@chromium.org>
References: <1343141382-31087-1-git-send-email-benchan@chromium.org>
Date: Wed, 25 Jul 2012 10:35:58 +0545
Message-ID: <CAHdPZaOTvF=e3j8ypzK8_V5Uh_8Nk1U74uVe4tcXs+cdQvimjg@mail.gmail.com>
Subject: Re: [PATCH v2] staging: gdm72xx: fix reference counting in gdm_wimax_event_init
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Ben Chan <benchan@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 8:34 PM, Ben Chan <benchan@chromium.org> wrote:
> This patch fixes the commit "staging/gdm72xx: cleanup little at
> gdm_wimax_event_rcv" (8df858ea76b76dde9a39d4edd9aaded983582cfe),
> which mishandles the reference counting of wm_event.
>
> Signed-off-by: Ben Chan <benchan@chromium.org>
> ---
> Fixed the commit message as suggested by Dan Carpenter.
>
>  drivers/staging/gdm72xx/gdm_wimax.c |   16 ++++++++++------
>  1 files changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
> index 0716efc..6cb8107 100644
> --- a/drivers/staging/gdm72xx/gdm_wimax.c
> +++ b/drivers/staging/gdm72xx/gdm_wimax.c
> @@ -258,12 +258,16 @@ static int gdm_wimax_event_init(void)
>         if (!wm_event.ref_cnt) {
>                 wm_event.sock = netlink_init(NETLINK_WIMAX,
>                                                 gdm_wimax_event_rcv);
> -               if (wm_event.sock)
> -                       wm_event.ref_cnt++;
> -               INIT_LIST_HEAD(&wm_event.evtq);
> -               INIT_LIST_HEAD(&wm_event.freeq);
> -               INIT_WORK(&wm_event.ws, __gdm_wimax_event_send);
> -               spin_lock_init(&wm_event.evt_lock);
> +               if (wm_event.sock) {
> +                       INIT_LIST_HEAD(&wm_event.evtq);
> +                       INIT_LIST_HEAD(&wm_event.freeq);
> +                       INIT_WORK(&wm_event.ws, __gdm_wimax_event_send);
> +                       spin_lock_init(&wm_event.evt_lock);
> +               }
> +       }
> +
> +       if (wm_event.sock) {
> +               wm_event.ref_cnt++;
>                 return 0;
>         }
>
> --
> 1.7.7.3
>

Hi Ben,

I have some basic understanding about this flow of the function,

Here is my understanding of the thing i have done when i was doing
some cleanups to this driver.

The ref_cnt will be 0 at first time. if so the sock creation happens
only once, and register_wimax_device only calls this function.
so i think doing the ref_cnt++ inside the if (!wm_event.ref_cnt) is valid.

Please suggest me if i am wrong.

Thanks,
