Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab0LUSTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 13:19:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50720 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752479Ab0LUSTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 13:19:51 -0500
Date: Tue, 21 Dec 2010 18:19:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: dd diasemi <dd.diasemi@gmail.com>
Cc: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 5/11] REGULATOR: Regulator module of DA9052 device
 driver
Message-ID: <20101221181949.GA3105@rakim.wolfsonmicro.main>
References: <AANLkTimCp+q54oO0iKbrgR8q=3an9h0qQ7iLYJtiqcw9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimCp+q54oO0iKbrgR8q=3an9h0qQ7iLYJtiqcw9@mail.gmail.com>
X-Cookie: All true wisdom is found on T-shirts.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 07:10:12PM +0100, dd diasemi wrote:

> Linux Kernel Version: 2.6.34

Always submit drivers against current development kernels, see the git
trees referenced in MAINTAINERS - linux-next is usually a good
approximation.  Drivers generated against older kernels will frequently
not even build against current kernels.  I'm fairly sure this has been
mentioned to you on previous submissions.

I've *briefly* glanced through the code below but not thoroughly
reviewed due to the old kernel version.

> +struct regulator {
> +	struct device *dev;
> +	struct list_head list;
> +	int uA_load;
> +	int min_uV;
> +	int max_uV;
> +	int enabled;
> +	char *supply_name;
> +	struct device_attribute dev_attr;
> +	struct regulator_dev *rdev;
> +};

Why are you replicating this in your driver?  You should never even look
at the interenals of this structure...

> +	da9052_lock(priv->da9052);
> +	ret = priv->da9052->read(priv->da9052, &ssc_msg);
> +	if (ret) {
> +		da9052_unlock(priv->da9052);
> +		return -EIO;
> +	}
> +
> +	ssc_msg.data = (ssc_msg.data | da9052_regulators[id].en_bit_mask);
> +
> +	ret = priv->da9052->write(priv->da9052, &ssc_msg);
> +	if (ret) {
> +		da9052_unlock(priv->da9052);
> +		return -EIO;
> +	}
> +	da9052_unlock(priv->da9052);

This register manpulation looks like it really should be factored out
into the MFD driver - there's quite a few copies of essentially the same
code in the regulator driver alone.

> +			(DA9052_BUCK_PERI_STEP_ABOVE_3000);
> +	} else{

checkpatch.pl will spot style issues like this for you.

> +	priv->da9052 = da9052;
> +	for (i = 0; i < 14; i++) {

14 is a magic number...  should be something more meaningful.

> +/* PM Device name and static Major number macros */
> +#define DRIVER_NAME				"da9052-regulator"

This shouldn't be in a header where other code might see it.

> +/* PM Device Error Codes */
> +

Remove this empty section.
