Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab0JFEJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 00:09:23 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33343 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab0JFEJW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 00:09:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=LnvDUzuM7uTfrbPQ7BTnIbdkyKgpdn4MXKEzh6fhv7blfFnmgzIa23udjNd8DjGiEt
         BDB/it+hQzEc0aAlr9n1+09qWEVgM5+adRFR75G+5tHmaVQxYNkhe0VqJPbcfwLPYaed
         gqwdl1nw1WDzDSep9+kEaCf/bjhdiElHN4adM=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] regulator: Add option for machine drivers to enable the dummy regulator
Date: Wed, 6 Oct 2010 06:09:17 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-trunk-amd64; KDE/4.4.5; x86_64; ; )
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Igor Grinberg <grinberg@compulab.co.il>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Walleij <linus.ml.walleij@gmail.com>
References: <1286331512-4608-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1286331512-4608-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010060609.17412.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne St 6. října 2010 04:18:32 Mark Brown napsal(a):
> Allow machine drivers to explicitly enable the use of the dummy regulator,
> enabling simpler support for systems with only a few specific supplies
> visible to software.
> 
> It is strongly recommended that this is not used on systems with
> substantial software control over their PMICs, for maximum functionality
> constrints should be as fully specified as possible.

This still solves nothing ... This leaves boards broken and the granularity is 
too big. Consider there are boards that use regulator for MMC, but not for 
ADS7846 for example.

Cheers
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/Makefile        |    3 +--
>  drivers/regulator/core.c          |   22 ++++++++++++++++++++++
>  include/linux/regulator/machine.h |    5 +++++
>  3 files changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
> index 8285fd8..f58bfdb 100644
> --- a/drivers/regulator/Makefile
> +++ b/drivers/regulator/Makefile
> @@ -3,14 +3,13 @@
>  #
> 
> 
> -obj-$(CONFIG_REGULATOR) += core.o
> +obj-$(CONFIG_REGULATOR) += core.o dummy.o
>  obj-$(CONFIG_REGULATOR_FIXED_VOLTAGE) += fixed.o
>  obj-$(CONFIG_REGULATOR_VIRTUAL_CONSUMER) += virtual.o
>  obj-$(CONFIG_REGULATOR_USERSPACE_CONSUMER) += userspace-consumer.o
> 
>  obj-$(CONFIG_REGULATOR_AD5398) += ad5398.o
>  obj-$(CONFIG_REGULATOR_BQ24022) += bq24022.o
> -obj-$(CONFIG_REGULATOR_DUMMY) += dummy.o
>  obj-$(CONFIG_REGULATOR_LP3971) += lp3971.o
>  obj-$(CONFIG_REGULATOR_MAX1586) += max1586.o
>  obj-$(CONFIG_REGULATOR_TWL4030) += twl-regulator.o
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index 422a709..bf82d01 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -33,6 +33,7 @@ static DEFINE_MUTEX(regulator_list_mutex);
>  static LIST_HEAD(regulator_list);
>  static LIST_HEAD(regulator_map_list);
>  static int has_full_constraints;
> +static bool board_wants_dummy_regulator;
> 
>  /*
>   * struct regulator_map
> @@ -1108,6 +1109,11 @@ static struct regulator *_regulator_get(struct
> device *dev, const char *id, }
>  	}
> 
> +	if (board_wants_dummy_regulator) {
> +		rdev = dummy_regulator_rdev;
> +		goto found;
> +	}
> +
>  #ifdef CONFIG_REGULATOR_DUMMY
>  	if (!devname)
>  		devname = "deviceless";
> @@ -2461,6 +2467,22 @@ void regulator_has_full_constraints(void)
>  EXPORT_SYMBOL_GPL(regulator_has_full_constraints);
> 
>  /**
> + * regulator_use_dummy_regulator - Provide a dummy regulator when none is
> found + *
> + * Calling this function will cause the regulator API to provide a
> + * dummy regulator to consumers if no physical regulator is found,
> + * allowing most consumers to proceed as though a regulator were
> + * configured.  This allows systems such as those with software
> + * controllable regulators for the CPU core only to be brought up more
> + * readily.
> + */
> +void regulator_use_dummy_regulator(void)
> +{
> +	board_wants_dummy_regulator = true;
> +}
> +EXPORT_SYMBOL_GPL(regulator_use_dummy_regulator);
> +
> +/**
>   * rdev_get_drvdata - get rdev regulator driver data
>   * @rdev: regulator
>   *
> diff --git a/include/linux/regulator/machine.h
> b/include/linux/regulator/machine.h index e298028..761c745 100644
> --- a/include/linux/regulator/machine.h
> +++ b/include/linux/regulator/machine.h
> @@ -189,10 +189,15 @@ int regulator_suspend_prepare(suspend_state_t state);
> 
>  #ifdef CONFIG_REGULATOR
>  void regulator_has_full_constraints(void);
> +void regulator_use_dummy_regulator(void);
>  #else
>  static inline void regulator_has_full_constraints(void)
>  {
>  }
> +
> +static inline void regulator_use_dummy_regulator(void)
> +{
> +}
>  #endif
> 
>  #endif
