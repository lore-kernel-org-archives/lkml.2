Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab2FXXy4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 19:54:56 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57355 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab2FXXyz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 19:54:55 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:3801:a800:1ff:fe00:df]
In-Reply-To: <1340409205-23606-1-git-send-email-bfreed@chromium.org>
References: <1340409205-23606-1-git-send-email-bfreed@chromium.org>
Date: Sun, 24 Jun 2012 16:54:55 -0700
Message-ID: <CAOesGMgq5HRz+pDFQtED5GPN0RUrON=_k_y4YHHzKrMkHnVk4A@mail.gmail.com>
Subject: Re: [PATCH] spi: Unlock a spinlock before calling into the controller driver.
From: Olof Johansson <olof@lixom.net>
To: Bryan Freed <bfreed@chromium.org>
Cc: spi-devel-general@lists.sourceforge.net, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, LinusW <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(Adding Linus Walleij and Mark Brown since they were the ones doing
the queue changes).

On Fri, Jun 22, 2012 at 4:53 PM, Bryan Freed <bfreed@chromium.org> wrote:
> spi_pump_messages() calls into a controller driver with
> unprepare_transfer_hardware() which is documented as "This may sleep".
> As in the prepare_transfer_hardware() call below, we should release the
> queue_lock spinlock before making the call.
> Rework the logic a bit to hold queue_lock to protect the 'busy' flag,
> then release it to call unprepare_transfer_hardware().
>
> Signed-off-by: Bryan Freed <bfreed@chromium.org>
>
> ---
>  drivers/spi/spi.c |   15 +++++++--------
>  1 files changed, 7 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index fc0da39..f7f9df9 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -532,17 +532,16 @@ static void spi_pump_messages(struct kthread_work *work)
>        /* Lock queue and check for queue work */
>        spin_lock_irqsave(&master->queue_lock, flags);
>        if (list_empty(&master->queue) || !master->running) {
> -               if (master->busy && master->unprepare_transfer_hardware) {
> -                       ret = master->unprepare_transfer_hardware(master);
> -                       if (ret) {
> -                               spin_unlock_irqrestore(&master->queue_lock, flags);
> -                               dev_err(&master->dev,
> -                                       "failed to unprepare transfer hardware\n");
> -                               return;
> -                       }
> +               if (!master->busy) {
> +                       spin_unlock_irqrestore(&master->queue_lock, flags);
> +                       return;
>                }
>                master->busy = false;
>                spin_unlock_irqrestore(&master->queue_lock, flags);
> +               if (master->unprepare_transfer_hardware &&
> +                   master->unprepare_transfer_hardware(master))
> +                       dev_err(&master->dev,
> +                               "failed to unprepare transfer hardware\n");


I'm not sure this is safe to do. The lock is dropped for the prepare
side, but in that case we can be sure that the above code can't come
in and unprepare at the same time since there is per definition a
request on the queue at that time.

On the other hand, between the lock drop and the call to unprepare
above, another code path can come in and queue up a request and either
not do prepare properly, or there will be a prepare that races with
the unprepare.

It might make more sense to use a workqueue here and schedule a
unprepare call that way instead (and cancelling appropriately before
the prepare call if needed). I'm open for other suggestions as well.


-Olof
