Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab2H3SY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 14:24:58 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47773 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab2H3SY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 14:24:56 -0400
MIME-Version: 1.0
In-Reply-To: <1346251989-26537-1-git-send-email-ldewangan@nvidia.com>
References: <1346251989-26537-1-git-send-email-ldewangan@nvidia.com>
From: Rabin Vincent <rabin@rab.in>
Date: Thu, 30 Aug 2012 20:24:15 +0200
X-Google-Sender-Auth: -jioMbNPRJWdVbXw6b_T5MYuUpY
Message-ID: <CAH+eYFBe6c0_H6z65AfW-6BCuxrQYFVFSXrZT865JGmcvyMRCg@mail.gmail.com>
Subject: Re: [PATCH V2] regulator: disable supply regulator if it is enabled
 for boot-on
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/29 Laxman Dewangan <ldewangan@nvidia.com>:
> @@ -3614,8 +3615,11 @@ static int __init regulator_init_complete(void)
>
>                 mutex_lock(&rdev->mutex);
>
> -               if (rdev->use_count)
> +               if (rdev->use_count) {
> +                       if (rdev->supply && c->boot_on)
> +                               supply_disable = true;
>                         goto unlock;
> +               }
>
>                 /* If we can't read the status assume it's on. */
>                 if (ops->is_enabled)
> @@ -3634,6 +3638,8 @@ static int __init regulator_init_complete(void)
>                         if (ret != 0) {
>                                 rdev_err(rdev, "couldn't disable: %d\n", ret);
>                         }
> +                       if (rdev->supply)
> +                               supply_disable = true;
>                 } else {
>                         /* The intention is that in future we will
>                          * assume that full constraints are provided

This does not handle the case where a regulator is not set boot_on but
is considered on (for example, because of the lack of an is_enabled
callback), and is later actually enabled by a consumer before
regulator_init_complete().  In this case, the supply's use count will
still be one more than it should be, because the "&& c->boot_on"
condition above will fail.

To fix this, you should probably note which regulators' supplies you
enable in regulator_register() and use that information in the above two
checks here in regulator_init_complete().
