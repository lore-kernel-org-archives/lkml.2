Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab0LTMjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 07:39:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39566 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756919Ab0LTMjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 07:39:05 -0500
Date: Mon, 20 Dec 2010 12:39:03 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Update consumer state only after set
 voltage succeeds.
Message-ID: <20101220123903.GE26706@rakim.wolfsonmicro.main>
References: <1292625868-26862-1-git-send-email-skannan@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292625868-26862-1-git-send-email-skannan@codeaurora.org>
X-Cookie: Reapply as necessary.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 02:44:28PM -0800, Saravana Kannan wrote:

>  static int regulator_check_consumers(struct regulator_dev *rdev,
> +				     struct regulator *ignore,
>  				     int *min_uV, int *max_uV)

This feels really invasive, and prone to robustness issues as we're just
randomly not checking one of the consumers on a single call, meaning we
skip some checking some of the time.  It's not going to make the code
more maintainable.

> -	regulator->min_uV = min_uV;
> -	regulator->max_uV = max_uV;
> -
> -	ret = regulator_check_consumers(rdev, &min_uV, &max_uV);
> +	ret = regulator_check_consumers(rdev, regulator, &min_uV, &max_uV);
>  	if (ret < 0)
>  		goto out;
>  
>  	ret = _regulator_do_set_voltage(rdev, min_uV, max_uV);
> +	if (!ret) {
> +		regulator->min_uV = min_uV;
> +		regulator->max_uV = max_uV;
> +	}

If you're going to do something probably unwinding the assignment on
error would cover it.
