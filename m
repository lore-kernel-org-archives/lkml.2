Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab1GDOHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 10:07:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:11537 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755317Ab1GDOHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 10:07:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,472,1304319600"; 
   d="scan'208";a="22496264"
Date: Mon, 4 Jul 2011 16:07:31 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mfd: Add initial S5M8751 support
Message-ID: <20110704140731.GC3021@sortiz-mobl>
References: <1308722037-6966-1-git-send-email-sbkim73@samsung.com>
 <1308722037-6966-3-git-send-email-sbkim73@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308722037-6966-3-git-send-email-sbkim73@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 22, 2011 at 02:53:56PM +0900, Sangbeom Kim wrote:
> +#define SLEEPB_ENABLE		1
> +#define SLEEPB_DISABLE		0
> +
> +static DEFINE_MUTEX(io_mutex);
I would prefer to see your IO mutex defined from your s5m8751 structure.


> +int s5m8751_clear_bits(struct s5m8751 *s5m8751, uint8_t reg, uint8_t mask)
> +{
> +	uint8_t reg_val;
> +	int ret = 0;
> +
> +	ret = s5m8751_reg_read(s5m8751, reg, &reg_val);
> +	if (ret)
> +		return ret;
> +
> +	reg_val &= ~mask;
> +	ret = s5m8751_reg_write(s5m8751, reg, reg_val);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(s5m8751_clear_bits);
> +
> +int s5m8751_set_bits(struct s5m8751 *s5m8751, uint8_t reg, uint8_t mask)
> +{
> +	uint8_t reg_val;
> +	int ret = 0;
> +
> +	ret = s5m8751_reg_read(s5m8751, reg, &reg_val);
> +	if (ret)
> +		return ret;
> +
> +	reg_val |= mask;
> +	ret = s5m8751_reg_write(s5m8751, reg, reg_val);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(s5m8751_set_bits);
Your locking for both of those routines is also racy. There's nothing
preventing a writre to happen between your read and your write. They need to
happen atomically, and for that you need to take the lonk in the clear/set
bits routine.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
