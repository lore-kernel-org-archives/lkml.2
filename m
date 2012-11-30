Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab2K3Gur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 01:50:47 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18392 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171Ab2K3Guq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 01:50:46 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 29 Nov 2012 22:50:18 -0800
Message-ID: <50B85828.4090405@nvidia.com>
Date: Fri, 30 Nov 2012 08:54:32 +0200
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 1/8] video: tegra: Add nvhost driver
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-2-git-send-email-tbergstrom@nvidia.com> <20121128212301.GA25531@avionic-0098.adnet.avionic-design.de> <50B73710.2040102@nvidia.com> <50B7AAA6.70702@wwwdotorg.org>
In-Reply-To: <50B7AAA6.70702@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.11.2012 20:34, Stephen Warren wrote:
> On 11/29/2012 03:21 AM, Terje Bergström wrote:
>> True. I might also as well delete the general interrupt altogether, as
>> we don't use it for any real purpose.
> 
> Do make sure the interrupts still are part of the DT binding though, so
> that the binding fully describes the HW, and the interrupt is available
> to retrieve if we ever do use it in the future.

Sure, I will just not use the generic irq in DT, but it won't require
any changes in DT bindings.

> You can still create tables of clocks inside the driver and loop over
> them. So, loop unrolling isn't related to my comments at least. It's
> just that clk_get() shouldn't take its parameters from platform data.
> 
> But if these are clocks for (arbitrary) child modules (that may or may
> not exist dynamically), why aren't the drivers for the child modules
> managing them?

There are actually two things here that I mixed, and because of that I
probably confused everybody else.

Let's rip out the ACM. ACM is generic to all modules, and in nvhost owns
the clocks. That's why list of clocks and their frequency policies have
been part of the device description in nvhost. ACM is being replaced
with runtime PM in downstream kernel, but it still requires rigorous
testing and analysis of power profile before we can move to it.

Then, the second thing is that nvhost_probe() has had its own loop to go
through the clocks of host1x module. It's copy-paste of what ACM did,
which is just bad design. That's easily replaceable with static code, as
nvhost_probe() is just for host1x. I'll do that, and as I rip out the
generic power management code, I'll also make 2D and host1x drivers
enable the clocks at probe with static code.

So I think we have a solution that resonates with all proposals.

Best regards,
Terje
