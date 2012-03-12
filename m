Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab2CLSKF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 14:10:05 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42526 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998Ab2CLSKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 14:10:02 -0400
Message-ID: <4F5E3BE7.4080207@wwwdotorg.org>
Date: Mon, 12 Mar 2012 12:09:43 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Dmitry Artamonow <mad_soft@inbox.ru>, Olof Johansson <olof@lixom.net>
CC: linux-tegra@vger.kernel.org, Andi <andi.shyti@gmail.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, Colin Cross <ccross@android.com>,
        Mike Rapoport <mike@compulab.co.il>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/2] arm/tegra: add timeout to PCIe PLL lock detection
 loop
References: <20120306201538.GA14350@rainbow> <1331287760-10546-1-git-send-email-mad_soft@inbox.ru>
In-Reply-To: <1331287760-10546-1-git-send-email-mad_soft@inbox.ru>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2012 03:09 AM, Dmitry Artamonow wrote:
> Tegra PCIe driver waits for PLL to lock using busy loop.
> If PLL fails to lock for some reason, this leads to silent lockup
> while booting (PCIe code is not modular).
> 
> Fix by adding timeout, so if PLL doesn't lock in a couple
> of seconds, just PCIe driver fails and machine continues to boot.
> 
> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>

> diff --git a/arch/arm/mach-tegra/pcie.c b/arch/arm/mach-tegra/pcie.c

>  	/* Wait for the PLL to lock */
> +	timeout = 2000;
>  	do {
>  		val = pads_readl(PADS_PLL_CTL);
> +		usleep_range(1000, 1000);
> +		if (--timeout == 0) {
> +			pr_err("Tegra PCIe error: timeout waiting for PLL\n");
> +			return -EBUSY;
> +		}
>  	} while (!(val & PADS_PLL_CTL_LOCKDET));

Thierry pointed out that one of NVIDIA's downstream kernels uses a
timeout of 300 here, rather than 2000 above. Do you see a specific need
for this timeout for be 2000 rather than 300? It might be nice to be
consistent.

Olof, I notice you've already applied V1 of this, which has the return
statement issue. Can you replace it with this, or should Dmitry send an
incremental patch?
