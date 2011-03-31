Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab1CaEXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 00:23:49 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.181]:6656
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752532Ab1CaEXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 00:23:47 -0400
X-SpamScore: -16
X-BigFish: VS-16(zzdf9M1432N98dNzz1202hzz1497iz2dh2a8h637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 31 Mar 2011 12:25:08 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>,
        <linaro-dev@lists.linaro.org>, <patches@linaro.org>
Subject: Re: [PATCH 0/5] consolidate sdhci pltfm & OF drivers and get them
 self registered
Message-ID: <20110331042507.GA21846@S2100-06.ap.freescale.net>
References: <1301042931-4869-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1301042931-4869-1-git-send-email-shawn.guo@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 04:48:46PM +0800, Shawn Guo wrote:
> Here are what the patch set does.
> 
> * Remove .probe and .remove hooks from sdhci-pltfm.c and make it be
>   a pure common helper function providers.
> * Add .probe and .remove hooks for sdhci pltfm drivers sdhci-cns3xxx,
>   sdhci-dove, sdhci-tegra, and sdhci-esdhc-imx to make them self
>   registered with calling helper functions created above.
> * Migrate the use of sdhci_of_host and sdhci_of_data to
>   sdhci_pltfm_host and sdhci_pltfm_data, so that OF version host and
>   data structure works can be saved, and pltfm version works for both
>   cases.
> * Add OF common helper stuff into sdhci-pltfm.c, and make OF version
>   sdhci drivers sdhci-of-esdhc and sdhci-of-hlwd become self
>   registered as well, so that sdhci-of-core.c and sdhci-of.h can be
>   removed.
> * Consolidate the OF and pltfm esdhc drivers into one with sharing
>   the same pair of .probe and .remove hooks.  As a result,
>   sdhci-esdhc-imx.c and sdhci-of-esdhc.c go away, while
>   sdhci-esdhc.c comes in and works for both MPCxxx and i.MX.
> * Eliminate include/linux/mmc/sdhci-pltfm.h with moving stuff into
>   drivers/mmc/host/sdhci-pltfm.h.
> 
> And the benefits we gain from the changes are:
> 
> * Get the sdhci device driver follow the Linux trend that driver
>   makes the registration by its own.
> * sdhci-pltfm.c becomes simple and clean as it only has common helper
>   stuff there now.
> * All sdhci device specific things are going back its own driver.
> * The dt and non-dt drivers are consolidated to use the same pair of
>   .probe and .remove hooks.
> * SDHCI driver for Freescale eSDHC controller found on both MPCxxx
>   and i.MX platforms is consolidated to use the same one .probe
>   function.
> 
> The patch set works against the tree below, and was only tested on
> i.mx51 babbage board, all other targets were build tested.
> 
>   git://git.secretlab.ca/git/linux-2.6.git devicetree/test
> 
> Comments are welcomed and appreciated.
> 
> Regards,
> Shawn
> 
> PS: The first patch is a squashing of the patch set below, which was
> posted for review a few days back.
> 
>   [PATCH 0/5] make sdhci device drivers self registered
> 
> Some patches in this series are relatively large, involving more
> changes than expected, I chose to not split considering they are
> logically integral, and doing so can reduce the patch quantity much,
> and make bisect much easier.  But sorry for that it makes reviewers'
> life harder.
> 
> Shawn Guo (5):
>       mmc: sdhci: make sdhci-pltfm device drivers self registered
>       mmc: sdhci: eliminate sdhci_of_host and sdhci_of_data
>       mmc: sdhci: make sdhci-of device drivers self registered
>       mmc: sdhci: consolidate sdhci-of-esdhc and sdhci-esdhc-imx
>       mmc: sdhci: merge two sdhci-pltfm.h into one
> 
>  drivers/mmc/host/Kconfig           |   71 ++++---
>  drivers/mmc/host/Makefile          |   17 +-
>  drivers/mmc/host/sdhci-cns3xxx.c   |   68 ++++++-
>  drivers/mmc/host/sdhci-dove.c      |   69 ++++++-
>  drivers/mmc/host/sdhci-esdhc-imx.c |  149 -------------
>  drivers/mmc/host/sdhci-esdhc.c     |  412 ++++++++++++++++++++++++++++++++++++
>  drivers/mmc/host/sdhci-of-core.c   |  247 ---------------------
>  drivers/mmc/host/sdhci-of-esdhc.c  |   89 --------
>  drivers/mmc/host/sdhci-of-hlwd.c   |   89 +++++++-
>  drivers/mmc/host/sdhci-of.h        |   42 ----
>  drivers/mmc/host/sdhci-pltfm.c     |  251 +++++++++-------------
>  drivers/mmc/host/sdhci-pltfm.h     |   36 +++-
>  drivers/mmc/host/sdhci-tegra.c     |  187 ++++++++++-------
>  include/linux/mmc/sdhci-pltfm.h    |   35 ---
>  14 files changed, 912 insertions(+), 850 deletions(-)
> --

Any comments?  Is this the right direction to move?

-- 
Regards,
Shawn

