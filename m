Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab1CHXqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 18:46:11 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51227 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756473Ab1CHXqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 18:46:10 -0500
Date: Tue, 8 Mar 2011 23:46:29 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Samuel Ortiz <sameo@linux.intel.com>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
Subject: Re: [PATCH v4 2/4] MAX8997/8966 PMIC Regulator Driver Initial
 Release
Message-ID: <20110308234629.GD2717@opensource.wolfsonmicro.com>
References: <1299573443-24784-1-git-send-email-myungjoo.ham@samsung.com>
 <1299573443-24784-3-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299573443-24784-3-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 05:37:21PM +0900, MyungJoo Ham wrote:
> This patch supports PMIC/Regulator part of MAX8997/MAX8966 MFD.
> In this initial release, selecting voltages or current-limit
> and switching on/off the regulators are supported.

This looks pretty good, it's probably OK to apply as-is and clean up
some more stuff later on.

> +static int max8997_list_voltage_charger_cv(struct regulator_dev *rdev,
> +		unsigned int selector)
> +{
> +	int rid = max8997_get_rid(rdev);
> +
> +	if (rid == MAX8997_CHARGER_CV) {

A little nicer to do if != then error out (saves indentation for the
entire rest of the function.

> +/*
> + * Assess the damage on the voltage setting of BUCK1,2,5 by the change.
> + *
> + * When GPIO-DVS mode is used for multiple bucks, changing the voltage value
> + * of one of the bucks may affect that of another buck, which is the side
> + * effect of the change (set_voltage). This function examines the GPIO-DVS
> + * configurations and checks whether such side-effect exists.
> + */

I'm not 100% sure I understand exactly what the mechanism for side
effects to occur is here (the code is a little abstruse, I'd expect it
to go through and set a flag if it finds a side effect would occur).
However, one thing that occurs to me is that you're not using the fact
that the regulator API passes in voltage ranges in the checks - you're
checking for any change, but it's possible that a side effect could
occur and still be in the range that was requested which should ideally
be allowed.  For example, if the side effect would be to change from
1.1V to 1.2V but the requested range was 1.1-1.3V then while there is
a side effect all the requirements that drivers provided are still being
met so we don't need to worry.

This sort of side effect is something we shouild probably add to the
core, other hardware has the possibility of having similar gang control
of the regulators although the mechanism here seems unusually complex.
I don't think we need to do that for this driver though.
