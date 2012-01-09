Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933343Ab2AIWh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:37:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42259 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755880Ab2AIWh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:37:27 -0500
Date: Mon, 9 Jan 2012 22:37:25 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: linux-kernel@vger.kernel.org, Dajun <dajun.chen@diasemi.com>,
        arnd@arndb.de, sameo@linux.intel.com,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [PATCH 02/06] MFD: DA9052/53 MFD core module v9 Added ADC
	support
Message-ID: <20120109223725.GG30766@opensource.wolfsonmicro.com>
References: <1326098770.3542.31.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326098770.3542.31.camel@dhruva>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 02:16:10PM +0530, Ashish Jangam wrote:
> Re-submitting the patch.

This is patch 2/6 - where are patches 1 and 3-6?

> +	/* Channel gets activated on enabling the Conversion bit */
> +	mux_sel = chan_mux[channel] | DA9052_ADC_MAN_MAN_CONV;
> +
> +	if (da9052->auxadc_active) {
> +		ret = -EBUSY;
> +		goto err;
> +	}
> +
> +	/* Enqueue the request */
> +	list_add(&req->list, &da9052->auxadc_pending);

Maintaining a list of outstanding requests seems a bit odd if it's only
possible to have a single active request at any one time.

> +
> +	ret = da9052_reg_write(da9052, DA9052_ADC_MAN_REG, mux_sel);
> +	if (ret < 0)
> +		goto err;
> +
> +	da9052->auxadc_active = channel;
> +
> +	mutex_unlock(&da9052->auxadc_lock);
> +
> +	/* Wait for an interrupt */
> +	wait_for_completion_timeout(&req->done, msecs_to_jiffies(500));
> +
> +	mutex_lock(&da9052->auxadc_lock);

With only one request being possible at once just not dropping the mutex
seems like the easiest approach - it'll mean that userspace doesn't need
to worry about -EBUSY and you could save all the allocation, deallocation
and list management.  As things stand I expect userspace will run into
errors sometimes.
