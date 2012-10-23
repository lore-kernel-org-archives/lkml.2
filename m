Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805Ab2JWNhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:37:04 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57412 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301Ab2JWNhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:37:02 -0400
Date: Tue, 23 Oct 2012 14:36:35 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Philip Rakity <prakity@nvidia.com>
Cc: Pavan Kunapuli <pkunapuli@nvidia.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH 2/2] mmc: sdhci: Defer probe if regulator_get fails
Message-ID: <20121023133635.GV21164@n2100.arm.linux.org.uk>
References: <1350976740-19284-1-git-send-email-pkunapuli@nvidia.com> <1350976740-19284-3-git-send-email-pkunapuli@nvidia.com> <4F1DF342-A2C4-434A-B878-A11374089E6E@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F1DF342-A2C4-434A-B878-A11374089E6E@nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 03:21:58PM +0200, Philip Rakity wrote:
> On 23 Oct 2012, at 09:19, Pavan Kunapuli <pkunapuli@nvidia.com> wrote:
> > -	/* If vqmmc regulator and no 1.8V signalling, then there's no UHS */
> > +	/*
> > +	 * If vqmmc regulator and no 1.8V signalling, then there's no UHS.
> > +	 * vqmmc regulator should be present. If it's not present,
> > +	 * assume the regulator driver registration is not yet done and
> > +	 * defer the probe.
> > +	 */
> > 	host->vqmmc = regulator_get(mmc_dev(mmc), "vqmmc");
> > 	if (IS_ERR(host->vqmmc)) {
> > -		pr_info("%s: no vqmmc regulator found\n", mmc_hostname(mmc));
> > +		pr_err("%s: no vqmmc regulator found\n", mmc_hostname(mmc));
> > 		host->vqmmc = NULL;
> > +		return -EPROBE_DEFER;
> 
> Some systems exist where vmmc regulator exists and vqmmc regulator does not.  The vmmc regular is fixed at 3.3v.  
> Deferring the probe will cause issues.

That's one of the issues of deferred probing: you don't know if one of the
_get() functions failed because it just isn't present, or whether it's
failed because it hasn't been registered yet.

The two conditions are indistinguishable from the driver point of view.

The solution to it is to ensure that those drivers where hardware resource
X is optional provide a dummy resource to the driver when the hardware
resource is not available.  That means, as far as the driver is concerned,
that it will always expect to get a full set of resources whether or not
the hardware has them.

If drivers care about such stuff, then we should have xxx_is_dummy()
functions (eg, clk_is_dummy(clk)) which return TRUE when the hardware
resource is not available.  (which we could use NULL to indicate and
would be in keeping with the specified IS_ERR() usage of these APIs.)
