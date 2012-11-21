Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab2KUIcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 03:32:20 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13578 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab2KUIcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 03:32:18 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 21 Nov 2012 00:32:14 -0800
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
Date: Wed, 21 Nov 2012 17:32:12 +0900
Message-ID: <1699753.ZQsWMHINxd@percival>
Organization: NVIDIA
User-Agent: KMail/4.9.3 (Linux/3.6.6-1-ARCH; KDE/4.9.3; x86_64; ; )
In-Reply-To: <50AC8D3B.6040300@ti.com>
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com> <4316169.5QXVzv7peZ@percival> <50AC8D3B.6040300@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 November 2012 16:13:47 Tomi Valkeinen wrote:
> * PGP Signed by an unknown key
> 
> On 2012-11-21 03:56, Alex Courbot wrote:
> > Hi Tomi,
> > 
> > On Tuesday 20 November 2012 22:48:18 Tomi Valkeinen wrote:
> >> I guess there's a reason, but the above looks a bit inconsistent. For
> >> gpio you define the gpio resource inside the step. For power and pwm the
> >> resource is defined before the steps. Why wouldn't "pwm = <&pwm 2
> >> 5000000>;" work in step2?
> > 
> > That's mostly a framework issue. Most frameworks do not export a function
> > that allow to dereference a phandle - they expect resources to be
> > declared right under the device node and accessed by name through
> > foo_get(device, name). So using phandles in power sequences would require
> > to export these additional
> Right, I expected something like that.
> 
> > functions and also opens the door to some inconsistencies - for instance,
> > your PWM phandle could be referenced a second time in the sequence with a
> > different period - how do you know that these are actually referring the
> > same PWM device?
> 
> This I didn't understand. Doesn't "<&pwm 2 xyz>" point to a single
> device, no matter where and how many times it's used?
> 
> >>> +When a power sequence is run, its steps is executed one after the other
> >>> until +one step fails or the end of the sequence is reached.
> >> 
> >> The document doesn't give any hint of what the driver should do if
> >> running the power sequence fails. Run the "opposite" power sequence?
> >> Will that work for all resources? I'm mainly thinking of a case where
> >> each enable of the resource should be matched by a disable, i.e. you
> >> can't call disable if no enable was called.
> > 
> > We discussed that issue already (around v5 I think) and the conclusion was
> > that it should be up to the driver. When we simply enable/disable
> > resources it is easy to revert, but in the future non-boolean properties
> > will likely be introduced, and these cannot easily be reverted. Moreover
> > some drivers might have more complex recovery needs. This deserves more
> > discussion I think, as I'd like to have some "generic" recovery mechanism
> > that covers most of the cases.
> 
> Ok. I'll need to dig up the conversation

IIRC it was somewhere around here:

https://lkml.org/lkml/2012/9/7/662

See the parent messages too.

> Did you consider any examples
> of how some driver could handle the error cases?

For all the (limited) use cases I considered, playing the power-off sequence 
when power-on fails just works. If power-off also fails you are potentially in 
more trouble though. Maybe we could have another "run" function that does not 
stop on errors for handling such cases where you want to "stop everything you 
can".

> What I'm worried about is that, as far as I understand, the power
> sequence is kinda like black box to the driver. The driver just does
> "power-up", without knowing what really goes on in there.

The driver could always inspect the sequence, but you are right in that this 
is not how it is intended to be done.

> And if it doesn't know what goes on in there, nor what's in "power-down"
> sequence, how can it do anything when an error happens? The only option
> I see is that the driver doesn't do anything, which will leave some
> resources enabled, or it can run the power-down sequence, which may or
> may not work.

Failures might be better handled if sequences have some "recovery policy" 
about what to do when they fail, as mentioned in the link above. As you 
pointed out, the driver might not always know enough about the resources 
involved to do the right thing.

Alex.

