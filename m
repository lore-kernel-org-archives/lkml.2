Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab1HEDx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 23:53:58 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15760 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023Ab1HEDxz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 23:53:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 04 Aug 2011 20:53:36 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Liam Girdwood <lrg@ti.com>,
        Chris Ball <cjb@laptop.org>, "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Thu, 4 Aug 2011 20:53:34 -0700
Subject: RE: [PATCH 1/3] irq: If an IRQ is a GPIO, request and configure it
Thread-Topic: [PATCH 1/3] irq: If an IRQ is a GPIO, request and configure it
Thread-Index: AcxTAucXCMZENJsdR8uYxtS3EQIaOgAH4T9Q
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF049F171EC1@HQMAIL01.nvidia.com>
References: <1312498820-2275-1-git-send-email-swarren@nvidia.com>
 <1312498820-2275-2-git-send-email-swarren@nvidia.com>
 <20110805000148.GB13321@opensource.wolfsonmicro.com>
In-Reply-To: <20110805000148.GB13321@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote at Thursday, August 04, 2011 6:02 PM:
> On Thu, Aug 04, 2011 at 05:00:18PM -0600, Stephen Warren wrote:
> 
> > +	} else {
> > +		gpio = irq_to_gpio(irq);
> > +		if (gpio_is_valid(gpio)) {
> > +			ret = gpio_request(gpio, new->name);
> > +			if (ret < 0)
> > +				goto out_mask;
> > +			ret = gpio_direction_input(gpio);
> > +			if (ret < 0)
> > +				goto out_mask;
> > +		}
> 
> If you treat failures as an error what happens when a driver is using a
> GPIO as both an interrupt and a GPIO?  For example a driver which
> monitors the level on a GPIO and uses edge triggered IRQs to be notified
> of state changes.

Well, things break. This is essentially the problem I was describing in
the PATCH 0 email, just with a slightly different motivation.

I suppose that an alternative here would be to simply ignore any errors
from gpio_request. This might have the benefit of removing the need for
the other two patches I posted in the series. However, it seems a little
dirty; one benefit of the IRQ code calling gpio_request and honoring
errors would be to detect when some completely unrelated code had a bug
and had called gpio_request on the GPIO before. Such detection would be
non-existent if we don't error out on gpio_request. Perhaps some mechanism
is needed to indicate that the driver has explicitly already called
gpio_request for a legitimate shared purpose, and only then ignore
errors?

--
nvpublic

