Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab1IHXCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:02:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43277 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752996Ab1IHXCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:02:09 -0400
Date: Thu, 8 Sep 2011 09:27:15 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org, Michael.Hennerich@analog.com,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 1/2] regmap: Support half writes and padding between
 register and value.
Message-ID: <20110908162715.GB3098@opensource.wolfsonmicro.com>
References: <1315490964-25718-1-git-send-email-jic23@cam.ac.uk>
 <1315490964-25718-2-git-send-email-jic23@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315490964-25718-2-git-send-email-jic23@cam.ac.uk>
X-Cookie: Avoid reality at all costs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 03:09:23PM +0100, Jonathan Cameron wrote:

> Note half writes currently assume address numbers are even only.
> That's a pain for caching so other suggestions welcome.  I could set
> it as a 7 bit address and increase the padding to 9 bits.  That makes
> the write bit a little strange though as it will be going into the
> padding.

This needs more documentation somewhere explaining what a half write is
and/or a better name for half write but doesn't look too invasive so I
think this approach can work.  If we come up with something better later
then we can always change things, there shouldn't be too many users to
update if that happens.

> -	map->format.reg_bytes = config->reg_bits / 8;
> +	map->format.buf_size = (config->reg_bits +
> +				config->reg_pad_bits +
> +				config->val_bits) / 8;
> +	map->format.reg_bytes = (config->reg_bits + config->reg_pad_bits)/ 8;

Please do a patch adding padding separately - that does seem like a
useful thing to have in general, with the option of having it both
before and after the register.

> -	if (val == map->work_buf + map->format.reg_bytes)
> -		ret = map->bus->write(map->dev, map->work_buf,
> -				      map->format.reg_bytes + val_len);
> -	else if (map->bus->gather_write)
> +	if (val == map->work_buf + map->format.reg_bytes) {
> +		if (map->format.half_write) {
> +			ret = map->bus->write(map->dev, map->work_buf,
> +					      (map->format.reg_bytes +
> +					       val_len) >> 1);
> +			if (ret >= 0)
> +				ret = map->bus->write(map->dev,
> +						      map->work_buf +
> +						      ((map->format.reg_bytes +
> +							val_len) >> 1),
> +						      (map->format.reg_bytes +
> +						       val_len) >> 1);
> +		} else {
> +			ret = map->bus->write(map->dev, map->work_buf,
> +					      map->format.reg_bytes + val_len);
> +		}

This code is getting very complicated...  I think it'd be clearer to
have a special case at the head of the function that does the half write
stuff.  It also feels like the half bit needs parameterisation, but I
can't immediately think of how to do that sensibly.
