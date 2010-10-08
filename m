Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702Ab0JHPrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 11:47:48 -0400
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:33585 "EHLO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab0JHPrr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 11:47:47 -0400
MIME-Version: 1.0
In-Reply-To: <1262629066-18398-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20100104181634.GA18258@rakim.wolfsonmicro.main>
	<1262629066-18398-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Fri, 8 Oct 2010 08:27:10 -0500
Message-ID: <AANLkTimWPZJzp61uCNMcu1o8Nra4_FQyUhjrtox2sxB2@mail.gmail.com>
Subject: Re: [PATCH 1/3] regulator: Add notifier event on regulator disable
From: Jeffrey Carlyle <jeff.carlyle@motorola.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Lun Chang <w13550@motorola.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 4, 2010 at 12:17 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> The intended use case is for drivers which disable regulators to save
> power but need to do some work to restore the hardware state when
> restarting.  If the supplies are not actually disabled due to board
> limits or sharing with other active devices this notifier allows the
> driver to avoid unneeded reinitialisation, particularly when used with
> runtime PM.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/core.c           |    7 +++++--
>  include/linux/regulator/consumer.h |    4 +++-
>  2 files changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index 686ef27..cce76a8 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -1341,6 +1341,9 @@ static int _regulator_disable(struct regulator_dev *rdev)
>                                       __func__, rdev_get_name(rdev));
>                                return ret;
>                        }
> +
> +                       _notifier_call_chain(rdev, REGULATOR_EVENT_DISABLE,
> +                                            NULL);
>                }
>
>                /* decrease our supplies ref count and disable if required */
> @@ -1399,8 +1402,8 @@ static int _regulator_force_disable(struct regulator_dev *rdev)
>                        return ret;
>                }
>                /* notify other consumers that power has been forced off */
> -               _notifier_call_chain(rdev, REGULATOR_EVENT_FORCE_DISABLE,
> -                       NULL);
> +               _notifier_call_chain(rdev, REGULATOR_EVENT_FORCE_DISABLE |
> +                       REGULATOR_EVENT_DISABLE, NULL);
>        }
>
>        /* decrease our supplies ref count and disable if required */
> diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
> index 030d922..28c9fd0 100644
> --- a/include/linux/regulator/consumer.h
> +++ b/include/linux/regulator/consumer.h
> @@ -89,8 +89,9 @@
>  * REGULATION_OUT Regulator output is out of regulation.
>  * FAIL           Regulator output has failed.
>  * OVER_TEMP      Regulator over temp.
> - * FORCE_DISABLE  Regulator shut down by software.
> + * FORCE_DISABLE  Regulator forcibly shut down by software.
>  * VOLTAGE_CHANGE Regulator voltage changed.
> + * DISABLE        Regulator was disabled.
>  *
>  * NOTE: These events can be OR'ed together when passed into handler.
>  */
> @@ -102,6 +103,7 @@
>  #define REGULATOR_EVENT_OVER_TEMP              0x10
>  #define REGULATOR_EVENT_FORCE_DISABLE          0x20
>  #define REGULATOR_EVENT_VOLTAGE_CHANGE         0x40
> +#define REGULATOR_EVENT_DISABLE                0x80
>
>  struct regulator;
>
> --
> 1.6.5.7

Mark et al, sorry to drag up something from nine months ago, but I'm
having a problem with this patch. I have a regulator A that sets
regulator B as its supply. When I call set_supply to add B as the
supply for A, regulator A gets added to the supply_list for regulator
B.

When I call regulator_disable(A), I end up with a call chain like this:

regulator_disable(A)
- mutex_lock(A)
- _regulator_disable(A)
-- _regulator_disable(B)
--- _notifier_call_chain(B)
---- mutex_lock(A)

Which results in dead lock since we trying to acquire the mutex lock
for regulator A which we already hold.

When I call regulator_disable(A), regulator_disable grabs the
mutex_lock for A. Then while inside _regulator_disable,
regulator_disable(B) is called since B is the supply for A. With this
patch, _regulator_disable(B) ends up calling _notifier_call_chain(B).
A is in the supply_list for B, so inside the notifier loop we try to
grab the mutext_lock for A again.

Am I doing something wrong in how I am setting up B as the supply for
A or is this bug in the regulator core code?

Thanks,
 - Jeff
