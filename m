Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab2K0Kwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 05:52:35 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13130 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab2K0Kwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 05:52:33 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 27 Nov 2012 02:52:33 -0800
Date: Tue, 27 Nov 2012 12:52:30 +0200
From: Sivaram Nair <sivaramn@nvidia.com>
To: Terje Bergstrom <tbergstrom@nvidia.com>
CC: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 1/8] video: tegra: Add nvhost driver
Message-ID: <20121127105230.GD10090@sivaramn-lnx>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
 <1353935954-13763-2-git-send-email-tbergstrom@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <1353935954-13763-2-git-send-email-tbergstrom@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 02:19:07PM +0100, Terje Bergstrom wrote:
> +
> +struct nvhost_chip_support *nvhost_chip_ops;

should be static?

> +static int __devinit nvhost_alloc_resources(struct nvhost_master *host)
> +{
> +       int err;
> +
> +       err = nvhost_init_chip_support(host);
> +       if (err)
> +               return err;
> +
> +       return 0;

nit: why not just return err - the 'if(err)' is unnecessary)?

> +
> +       nvhost = host;

I think this should be delayed until the init is complete as this
variable is not cleared if there is a failure during init. Also I feel
that the name nvhost is a bit short for an exported variable.

> +static void to_state_running_locked(struct platform_device *dev)
> +{
> +       struct nvhost_device_data *pdata = platform_get_drvdata(dev);
> +       int prev_state = pdata->powerstate;
> +
> +       if (pdata->powerstate == NVHOST_POWER_STATE_POWERGATED)
> +               to_state_clockgated_locked(dev);
> +
> +       if (pdata->powerstate == NVHOST_POWER_STATE_CLOCKGATED) {
> +               int i;
> +
> +               if (dev->dev.parent)
> +                       nvhost_module_busy(to_platform_device(dev->dev.parent));
> +
> +               for (i = 0; i < pdata->num_clks; i++) {
> +                       int err = clk_prepare_enable(pdata->clk[i]);
> +                       if (err) {
> +                               dev_err(&dev->dev, "Cannot turn on clock %s",
> +                                       pdata->clocks[i].name);
> +                               return;

In case of an error, returning here leaves some clocks turned on. 

Sivaram
