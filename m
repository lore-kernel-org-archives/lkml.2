Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab0LQBqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 20:46:22 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57294 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab0LQBqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 20:46:21 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6199"; a="67166539"
Message-ID: <3bf69fb1c4f33c8a1f405b4f05ba1a59.squirrel@www.codeaurora.org>
Date: Thu, 16 Dec 2010 17:46:07 -0800 (PST)
Subject: Re: [PATCH 2/2] regulator: Optimise out noop voltage changes
From: "Saravana Kannan" <skannan@codeaurora.org>
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>
Cc: "Saravana Kannan" <skannan@codeaurora.org>,
        "Liam Girdwood" <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Reported-by: Saravana Kannan <skannan@codeaurora.org>
Thanks

>  int regulator_set_voltage(struct regulator *regulator, int min_uV, int
> max_uV)
>  {
>  	struct regulator_dev *rdev = regulator->rdev;
> -	int ret;
> +	int ret = 0;
>
>  	mutex_lock(&rdev->mutex);
>
> +	/* If we're setting the same range as last time the change
> +	 * should be a noop (some cpufreq implementations use the same +	 *
voltage for multiple frequencies, for example).
> +	 */
> +	if (regulator->min_uV == min_uV && regulator->max_uV == max_uV)
+		goto out;
> +

I have only web email access now. Sorry for the vague references to code
that follow.

When you reported a merge/rebase issue the other day, I didn't respond
with a similar patch for the following reasons:
1. With support for multiple consumers, we can further optimize and call
the producer's set voltage only if the final voltage range changes. So if
consumer A asks for (2.0 - 5.0) and consumer B keeps changing between (1.0
- 5.0) and (1.5 - 5.0), then we can completely no-op all of consumer B's
calls.

2. When I was trying to do the above this Sunday, I also noticed what
looks like a bug or at least an unpleasant behavior. A consumer's min_uV
and max_uV were being updated (for-next around Dec 12th) before calling
the producer's set voltage. So, in the above example, if consumer C comes
in and asks for (10 - 15), it will prevent the producer voltage from ever
changing again. All of consumer A and B's future requests will result in a
failure since min_uV > max_uV when you do the consumer aggregation.

Hope my vague references to code is good enough to point you the code I'm
talking about. May be you already fixed it too!

Thanks,
Saravana
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.




