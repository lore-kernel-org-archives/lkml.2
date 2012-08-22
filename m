Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab2HVDho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 23:37:44 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60878 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab2HVDhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 23:37:41 -0400
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF0AEB@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F41EF0AEB@DQHE02.ent.ti.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Wed, 22 Aug 2012 11:37:19 +0800
X-Google-Sender-Auth: SDaIGUUfnRrRIec840AO5IWJF3c
Message-ID: <CAK5ve-LoER0X36JMBjY4Dqgts5FapAs=2w01J05YgJ8tmYHMkg@mail.gmail.com>
Subject: Re: [PATCH 2/4] leds-lp5523: set the brightness to 0 forcely on
 removing the driver
To: "Kim, Milo" <Milo.Kim@ti.com>, Tejun Heo <tj@kernel.org>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 5:03 PM, Kim, Milo <Milo.Kim@ti.com> wrote:
> Turning off the brightness of each channel is required
> when removing the driver.
>
> So use flush_work_sync() rather than cancel_work_sync() to wait for
> unhandled brightness works.

Hmmm, I think we still should use cancel_work() here based on your
idea. Please find the patch from Tejun and add him to this loop
[PATCH 4/6] workqueue: deprecate flush[_delayed]_work_sync()
---
Before this patchset,

 flush_work()

        flush the last queued instance of the work item.  If it got
        queued on multple CPUs, it only considers the last queued
        instance.  The work item could still be executing on other
        CPUs and the flush might become noop if there are competing
        queueing operation on another CPU.

 flush_work_sync()

        flush_work() + wait for executing instances on all CPUs.  The
        flush_work() part may still become noop if there's competing
        queueing operation.

 cancel_work()

        Dequeue the work item if it's pending.  Doesn't care about
        whether it's executing or not.

 cancel_work_sync()

        cancel_work() + flush_work_sync().


After this patchset,

 flush_work()

        flush the work item.  Any queueing happened previously is
        guaranteed to have finished execution on return.  If no
        further queueing happened after flush started, the work item
        is guaranteed to be idle on return.

 cancel_work()

        Same as before.

 cancel_work_sync()

        cancel_work() followed by flush_work().  The same semantics as
        del_timer_sync().
---

cancel_work_sync() won't execute the work item at all just cancel
them, but flush will execute them and return.

-Bryan

>
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/leds/leds-lp5523.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
> index 9fd9a92..f090819 100644
> --- a/drivers/leds/leds-lp5523.c
> +++ b/drivers/leds/leds-lp5523.c
> @@ -974,7 +974,7 @@ static int __devinit lp5523_probe(struct i2c_client *client,
>  fail2:
>         for (i = 0; i < chip->num_leds; i++) {
>                 led_classdev_unregister(&chip->leds[i].cdev);
> -               cancel_work_sync(&chip->leds[i].brightness_work);
> +               flush_work_sync(&chip->leds[i].brightness_work);
>         }
>  fail1:
>         if (pdata->enable)
> @@ -993,7 +993,7 @@ static int lp5523_remove(struct i2c_client *client)
>
>         for (i = 0; i < chip->num_leds; i++) {
>                 led_classdev_unregister(&chip->leds[i].cdev);
> -               cancel_work_sync(&chip->leds[i].brightness_work);
> +               flush_work_sync(&chip->leds[i].brightness_work);
>         }
>
>         if (chip->pdata->enable)
> --
> 1.7.2.5
>
>
> Best Regards,
> Milo
>
>



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
