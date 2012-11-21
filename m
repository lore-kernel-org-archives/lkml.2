Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab2KUB4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 20:56:46 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17870 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab2KUB4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 20:56:44 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 20 Nov 2012 17:56:38 -0800
From: Alex Courbot <acourbot@nvidia.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCHv9 1/3] Runtime Interpreted Power Sequences
Date: Wed, 21 Nov 2012 10:56:36 +0900
Message-ID: <4316169.5QXVzv7peZ@percival>
Organization: NVIDIA
User-Agent: KMail/4.9.3 (Linux/3.6.6-1-ARCH; KDE/4.9.3; x86_64; ; )
In-Reply-To: <50AB9832.90709@ti.com>
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com> <1353149747-31871-2-git-send-email-acourbot@nvidia.com> <50AB9832.90709@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

On Tuesday 20 November 2012 22:48:18 Tomi Valkeinen wrote:
> I guess there's a reason, but the above looks a bit inconsistent. For
> gpio you define the gpio resource inside the step. For power and pwm the
> resource is defined before the steps. Why wouldn't "pwm = <&pwm 2
> 5000000>;" work in step2?

That's mostly a framework issue. Most frameworks do not export a function that 
allow to dereference a phandle - they expect resources to be declared right 
under the device node and accessed by name through foo_get(device, name). So 
using phandles in power sequences would require to export these additional 
functions and also opens the door to some inconsistencies - for instance, your 
PWM phandle could be referenced a second time in the sequence with a different 
period - how do you know that these are actually referring the same PWM 
device?

> > +When a power sequence is run, its steps is executed one after the other
> > until +one step fails or the end of the sequence is reached.
> 
> The document doesn't give any hint of what the driver should do if
> running the power sequence fails. Run the "opposite" power sequence?
> Will that work for all resources? I'm mainly thinking of a case where
> each enable of the resource should be matched by a disable, i.e. you
> can't call disable if no enable was called.

We discussed that issue already (around v5 I think) and the conclusion was 
that it should be up to the driver. When we simply enable/disable resources it 
is easy to revert, but in the future non-boolean properties will likely be 
introduced, and these cannot easily be reverted. Moreover some drivers might 
have more complex recovery needs. This deserves more discussion I think, as 
I'd like to have some "generic" recovery mechanism that covers most of the 
cases.

Alex.

