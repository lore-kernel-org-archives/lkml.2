Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab2KIRQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 12:16:11 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:46645 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab2KIRQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 12:16:06 -0500
Message-ID: <509D3A53.6080007@wwwdotorg.org>
Date: Fri, 09 Nov 2012 10:16:03 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        Jonas Aaberg <jonas.aberg@stericsson.com>
Subject: Re: [PATCH v2] pinctrl/nomadik: make independent of prcmu driver
References: <1352456915-28738-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1352456915-28738-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2012 03:28 AM, Linus Walleij wrote:
> From: Jonas Aaberg <jonas.aberg@stericsson.com>
> 
> Currently there are some unnecessary criss-cross
> dependencies between the PRCMU driver in MFD and a lot of
> other drivers, mainly because other drivers need to poke
> around in the PRCM register range.
> 
> In cases like this there are actually just a few select
> registers that the pinctrl driver need to read/modify/write,
> and it turns out that no other driver is actually using
> these registers, so there are no concurrency issues
> whatsoever.
> 
> So: don't let the location of the register range complicate
> things, just poke into these registers directly and skip
> a layer of indirection.
> 
> Take this opportunity to add kerneldoc to the pinctrl
> state container.

> diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c

> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (res) {
> +		npct->prcm_base = devm_ioremap(&pdev->dev, res->start,
> +					       resource_size(res));
> +		if (!npct->prcm_base) {
> +			dev_err(&pdev->dev,
> +				"failed to ioremap PRCM registers\n");
> +			return -ENOMEM;
> +		}
> +	} else {
> +		dev_info(&pdev->dev,
> +			 "No PRCM base, assume no ALT-Cx control is available\n");
> +	}

Where is "assume no ALT-Cx control is available" implemented; I don't
see anything that uses npct->prcm_base to conditionally enable/block any
features. Is it just assumed that the DT won't contain any entries that
trigger writes to the PRCM registers? That seems fragile; it could cause
a "user"-triggered kernel crash.

Aside from that, this seems fine. Much smaller than V1:-)
