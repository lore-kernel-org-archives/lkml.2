Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934135Ab2HWSZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:25:26 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53408 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225Ab2HWSZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:25:22 -0400
Message-ID: <5036758F.1030507@wwwdotorg.org>
Date: Thu, 23 Aug 2012 12:25:19 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Axel Lin <axel.lin@gmail.com>, Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] max8907: fix use of possibly NULL idata
References: <1345745958-16782-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1345745958-16782-1-git-send-email-swarren@wwwdotorg.org>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 12:19 PM, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> If a regulator is not used by a board, it's quite legitimate not to
> provide platform data or a device tree node to configure it (i.e.
> regulator_init_data). In that case, during MAX8907 regulator's
> probe(), the idata variable will be NULL for that regulator. Prevent
> dereferincing it.
> 
> If the MBATT regulator's init_data is not specified, or no name was
> specified in the constraints, the regulator will be named based on
> the regulator descriptor, so initialize mbatt_rail_name from there.

Laxman,

The TPS6586x driver avoids this NULL-dereference issue by simply not
registering any regulators when idata is NULL. See
drivers/mfd/tps6586x.c:tps6586x_parse_dt():

>         for (i = 0, j = 0; i < num && j < count; i++) {
>                 struct regulator_init_data *reg_idata;
> 
>                 if (!tps6586x_matches[i].init_data)
>                         continue;

If I interpreted Mark Brown correctly, this isn't correct; all the
regulators within the chip should always be registered, just without any
user-supplied constraints. Assuming I didn't misinterpret Mark, can you
please fix the TPS6586x driver to always register the regulators, and
apply the fix below. Could you please check the TPS65911 driver and see
what the status is there too? Thanks very much!
