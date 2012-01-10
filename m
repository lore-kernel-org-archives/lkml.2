Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311Ab2AJQj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 11:39:28 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19070 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab2AJQj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 11:39:26 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 10 Jan 2012 08:39:14 -0800
Date: Tue, 10 Jan 2012 18:39:05 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        "Russell King" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH v2 0/3] Tegra30 clockframework
Message-ID: <20120110163905.GL32619@tbergstrom-lnx.Nvidia.com>
References: <1326123315-32670-1-git-send-email-pdeschrijver@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF177EE3A286@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF177EE3A286@HQMAIL01.nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 10:30:05PM +0100, Stephen Warren wrote:
> Peter De Schrijver wrote at Monday, January 09, 2012 8:35 AM:
> > This patchset introduces the tegra30 clockframework. Clocks which require
> > voltage scaling are not included in this version. The implementation doesn't
> > use the generic clock code yet. It's the intention to move to it, once the
> > semantics are fully clarified.
> > 
> > ---
> > 
> > Changes in v2:
> >  * Fix parent clocks for TWD. This makes the SMP configuration booting again.
> 
> Peter,
> 
> This version seems to still boot as well as without these patches.
> 
> I hacked some AUXDATA into board-dt-tegra30.c in an attempt to get SDHCI
> working, but found that:
> 
> a) sdhci_add_host() fails due to:
> 
> mmc0: Hardware doesn't specify timeout clock frequency.
> 
> I haven't investigated why this happens.
> 

I had a look at it, but I haven't found the rootcause.

> b) More directly related to these patches, when sdhci_add_host() fails,
> sdhci_tegra_probe() calls clk_disable() and clk_put() on its clock. One
> of these hangs somehow. I assume that's a bug in this clock patch?
> 

Sortof. The rootcause for this one is that pll_p gets disabled when
sdhci_tegra_probe() calls  clk_disable(). pll_p also provides the input clock
for UARTD however, so the next printk() call will hang the system. The reason
for this is that no kernel driver has actually enabled the UARTD clock at that
point, and thus pll_p hasn't been turned on from a clock framework point of
view.
Workaround is to enable UARTD in board-dt-tegra30 like we do for tegra20. I
guess we need a better solution to cope with a different UART being the
console UART. (See next mail)

Cheers,

Peter.
