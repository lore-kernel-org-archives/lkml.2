Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab2LLMLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 07:11:11 -0500
Received: from service87.mimecast.com ([91.220.42.44]:56060 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab2LLMLK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 07:11:10 -0500
Message-ID: <1355314238.19818.38.camel@hornet>
Subject: Re: [PATCH] regulator: vexpress: Add missing n_voltages setting
From: Pawel Moll <pawel.moll@arm.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 12 Dec 2012 12:10:38 +0000
In-Reply-To: <CAFRkauBScqEMh3y1FcBuYO0dSM1yQV6OOG4Z5HQ8Ueq_Mmm9UA@mail.gmail.com>
References: <1355213050.7387.1.camel@phoenix>
	 <1355233859.19818.11.camel@hornet>
	 <CAFRkauBScqEMh3y1FcBuYO0dSM1yQV6OOG4Z5HQ8Ueq_Mmm9UA@mail.gmail.com>
X-Mailer: Evolution 3.6.0-0ubuntu3
Mime-Version: 1.0
X-OriginalArrivalTime: 12 Dec 2012 12:10:39.0234 (UTC) FILETIME=[B3213E20:01CDD861]
X-MC-Unique: 112121212104200501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-11 at 23:39 +0000, Axel Lin wrote:
> I was thinking below patch to fix the issue:
>  diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index cd1b201..891bc96 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -1885,9 +1885,14 @@ int regulator_can_change_voltage(struct
> regulator *regulator)
>         struct regulator_dev    *rdev = regulator->rdev;
>  
>         if (rdev->constraints &&
> -           rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE &&
> -           rdev->desc->n_voltages > 1)
> -               return 1;
> +           rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE) {
> +               if (rdev->desc->n_voltages > 1)
> +                       return 1;
> +               if (rdev->desc->continuous_voltage_range &&
> +                   rdev->constraints->min_uV && rdev->constraints->max_uV)
> +                       return 1;
> +
> +       }
>  
>         return 0;
>  }

I wouldn't say so, although of course it's not my call. To my ming the
(valid_ops_mask & REGULATOR_CHANGE_VOLTAGE) should really be the only
condition here. I'd even risk saying that checking n_voltages > 1 or
continuous_voltage_range is a bit over the top. So maybe the correct
thing to do would be:

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index cd1b201..38fe3a2 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1885,8 +1885,7 @@ int regulator_can_change_voltage(struct regulator *regulator)
 	struct regulator_dev	*rdev = regulator->rdev;
 
 	if (rdev->constraints &&
-	    rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE &&
-	    rdev->desc->n_voltages > 1)
+	    rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE)
 		return 1;
 
 	return 0;

And before you ask - I initialize regulator data from the device tree,
so I get all constraints and valid_ops_mask set by
of_get_regulator_init_data() and of_get_regulation_constraints().

> But then I think if the core relies on n_voltages settings, why not
> set n_voltages in the driver
> even if a driver has continuous_voltage_range set.

I'm not sure that you can say that "the core relies on n_voltages". This
is probably a question for Mark, but to my mind it's one of the possible
cases.
> 
> Maybe I'm still not full understand about continuous_voltage_range,
> A driver with continuous_voltage_range looks special to me:
> 1. regulator_count_voltages() always return 0
> 2. regulator_list_voltage() returns -EINVAL. ( Does it make sense to
> not implement list_voltage ? )

Because it doesn't have "discreet" operating points. The count/list
voltage interface is supposed to represent a regulator that can be set
to (for example) 1V, 2V, 3V, 4V or 5V. "My" regulator (example again)
can be set to any value between 1V and 5V, for example 2.3456. Why would
you like to enumerate all thousands of possible values between 1 and 5?

> 3. vexpress_regulator_set_voltage() looks does not have voltage range
> checking:
>     Given init_data->constraints.min_uV= 50000
> init_data->constraints.max_uV=60000
>     What happen if vexpress_regulator_set_voltage is called with
> min_uV=80000, max_uV=100000?

The core takes care of that - have a look at regulator_set_voltage()
(hint: regulator_check_voltage ;-). The driver can assume that it will
get values within the constraints.

> 4. It's unclear to me if only one of
> init_data->constraints->min_uV/init_data->constraints->max_uV is set.

Again, from my point of view it's the core's problem. I don't think it's
a legal case though.

Paweł



