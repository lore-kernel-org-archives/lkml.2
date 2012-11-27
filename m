Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab2K0G3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 01:29:34 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13459 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510Ab2K0G3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 01:29:32 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 26 Nov 2012 22:29:24 -0800
Message-ID: <50B45EA8.7000502@nvidia.com>
Date: Tue, 27 Nov 2012 08:33:12 +0200
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 5/8] ARM: tegra: Add auxiliary data for nvhost
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-6-git-send-email-tbergstrom@nvidia.com> <50B3FDCC.7080709@wwwdotorg.org>
In-Reply-To: <50B3FDCC.7080709@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.11.2012 01:39, Stephen Warren wrote:
> Clock names shouldn't be passed in platform data; instead, clk_get()
> should be passed the device object and device-relative (i.e. not global)
> clock name. I expect if the driver is fixed to make this change, the
> changes to tegra*_clocks_data.c won't be needed either.

Isn't this code doing exactly that - getting a device relative clock,
nvhost_module_init() in nvhost.acm.c:

(...)
	/* initialize clocks to known state */
	while (pdata->clocks[i].name && i < NVHOST_MODULE_MAX_CLOCKS) {
		long rate = pdata->clocks[i].default_rate;
		struct clk *c;

		c = devm_clk_get(&dev->dev, pdata->clocks[i].name);
		if (IS_ERR_OR_NULL(c)) {
			dev_err(&dev->dev, "Cannot get clock %s\n",
					pdata->clocks[i].name);
			return -ENODEV;
		}

		rate = clk_round_rate(c, rate);
		clk_prepare_enable(c);
		clk_set_rate(c, rate);
		clk_disable_unprepare(c);
		pdata->clk[i] = c;
		i++;
	}
(...)

Without the clock changes, the clocks in board files are now assigned to
devid "tegra_grhost". I guess the correct way to do this would be to
assign them to "tegra-gr2d" (2d, epp) and "host1x" - except if we also
want to drop "tegra-" from the device name.

Terje
