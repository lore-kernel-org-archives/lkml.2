Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab2HPIZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 04:25:17 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33156 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab2HPIZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 04:25:14 -0400
Date: Thu, 16 Aug 2012 11:25:07 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: dedekind1@gmail.com
Cc: Richard Genoud <richard.genoud@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] UBI: use the whole MTD device size to get
 bad_peb_limit
Message-ID: <20120816112507.01b7c0f0@pixies.home.jungo.com>
In-Reply-To: <1345043331.3393.151.camel@sauron.fi.intel.com>
References: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
	<1341937423-16516-4-git-send-email-richard.genoud@gmail.com>
	<1345043331.3393.151.camel@sauron.fi.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem, Richard,

On Wed, 15 Aug 2012 18:08:51 +0300 Artem Bityutskiy <dedekind1@gmail.com> wrote:
> 1. Invalid blocks are block that contain one or more bad bits beyond
> ECC.

I would remove this one sentence from the log, it is misleading; invalid
blocks are not necessarily related to ECC.

>  		if (CONFIG_MTD_UBI_BEB_LIMIT > 0) {
> -			int percent = CONFIG_MTD_UBI_BEB_LIMIT;
> -			int limit = mult_frac(ubi->peb_count, percent, 100);
> +			int per1024 = CONFIG_MTD_UBI_BEB_LIMIT;
> +			int limit, device_pebs;
> +			uint64_t device_size;
> +
> +			/*
> +			 * Here we are using size of the entire flash chip and
> +			 * not just the MTD partition size because the maximum
> +			 * number of bad eraseblocks is a percentage of the
> +			 * whole device and bad eraseblocks are not fairly
> +			 * distributed over the flash chip. So the worst case
> +			 * is that all the bad eraseblocks of the chip are in
> +			 * the MTD partition we are attaching (ubi->mtd).
> +			 */
> +			device_size = mtd_get_device_size(ubi->mtd);
> +			device_pebs = mtd_div_by_eb(device_size, ubi->mtd);
> +			limit = mult_frac(device_pebs, per1024, 1024);
>  
>  			/* Round it up */
> -			if (mult_frac(limit, 100, percent) < ubi->peb_count)
> +			if (mult_frac(limit, 1024, per1024) < ubi->peb_count)

Oops... should be: 

+			if (mult_frac(limit, 1024, per1024) < device_pebs)

Regards,
Shmulik
