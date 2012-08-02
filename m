Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab2HBH6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 03:58:34 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13555 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab2HBH6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 03:58:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 02 Aug 2012 00:58:21 -0700
Message-ID: <501A338D.7080105@nvidia.com>
Date: Thu, 2 Aug 2012 17:00:13 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [RFC][PATCH v3 1/3] runtime interpreted power sequences
References: <1343390750-3642-1-git-send-email-acourbot@nvidia.com> <1343390750-3642-2-git-send-email-acourbot@nvidia.com> <50170EA0.1010408@wwwdotorg.org>
In-Reply-To: <50170EA0.1010408@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 07:45 AM, Stephen Warren wrote:
> Oh I see. That's a little confusing. Why not just reference the relevant
> resources directly in each step; something more like:
>
> 		gpio@1 {
> 			action = "enable-gpio";
> 			gpio = <&gpio 1 0>;
> 		};
>
> I guess that might make parsing/building a little harder, since you'd
> have to detect when you'd already done gpio_request() on a given GPIO
> and not repeat it or something like that, but to me this makes the DT a
> lot easier to comprehend.

I tried to move towards having the phandles directly in the sequences 
themselves - that reminded me why I did not do that in the first place. 
Let's say we have a sequence like this (reg property omitted on purpose):

	power-on-sequence {
		step@0 {
			regulator = <&backlight_reg>;
			enable;
		};
		step@1 {
			delay = <10000>;
		};
		step@2 {
			pwm = <&pwm 2 5000000>;
			enable;
		};
		step@3 {
			gpio = <&gpio 28 0>;
			enable;
		};
	};

The problem is, how do we turn these phandles into the resource of 
interest. The type of the resource can be infered by the name of the 
property. The hard part is resolving the resource from the phandle - it 
seems like the API just does not allow to do this. GPIO has 
of_get_named_gpio, but AFAIK there are no equivalent for regulator 
consumer and PWM: the only way to use the DT with them is through 
get_regulator and get_pwm which work at the device level.

Or is there a way that I overlooked?

Thanks,
Alex.

