Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab2ATQ5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 11:57:10 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16119 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab2ATQ5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 11:57:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 20 Jan 2012 08:57:06 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Tony Lindgren <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        Barry Song <21cnbao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>
Date: Fri, 20 Jan 2012 08:57:05 -0800
Subject: RE: [PATCH 2/4] pinctrl: Fix pinmux_hog_maps when ctrl_dev_name is
 not set
Thread-Topic: [PATCH 2/4] pinctrl: Fix pinmux_hog_maps when ctrl_dev_name is
 not set
Thread-Index: AczXjwLVIWBa3rfdTp6aqdvk7YPCBQABTbvg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB383@HQMAIL01.nvidia.com>
References: <20120120161610.21955.25082.stgit@kaulin.local>
 <20120120161727.21955.7437.stgit@kaulin.local>
In-Reply-To: <20120120161727.21955.7437.stgit@kaulin.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0KGvJmM006804

Tony Lindgren wrote at Friday, January 20, 2012 9:17 AM:
> The ctrl_dev_name is optional for struct pinmux_map assuming
> that ctrl_dev is set. Without this patch we can get:
> 
> Unable to handle kernel NULL pointer dereference at virtual address 00000000

> diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c


> @@ -992,9 +992,12 @@ int pinmux_hog_maps(struct pinctrl_dev *pctldev)
> 
>  	for (i = 0; i < pinmux_maps_num; i++) {
>  		struct pinmux_map const *map = &pinmux_maps[i];
> +		int match_found = 0;
> 
> -		if (((map->ctrl_dev == dev) ||
> -		     !strcmp(map->ctrl_dev_name, devname)) &&
> +		if (map->ctrl_dev_name && !strcmp(map->ctrl_dev_name, devname))
> +				match_found = 1;
> +
> +		if (((map->ctrl_dev == dev) || match_found) &&
>  		    map->hog_on_boot) {
>  			/* OK time to hog! */
>  			ret = pinmux_hog_map(pctldev, map);

Wouldn't it be better if match_found was true for all matching cases,
in other words for the new code to be:

		int match_found = 0;

		if (map->ctrl_dev_name && !strcmp(map->ctrl_dev_name, devname))
				match_found = 1;
		if (map->ctrl_dev == dev)
				match_found = 1;
		if (match_found && map->hog_on_boot) {

-- 
nvpublic

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
