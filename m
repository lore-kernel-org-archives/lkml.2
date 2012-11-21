Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab2KULGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 06:06:11 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:36058 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab2KULGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 06:06:08 -0500
Message-ID: <50ACB59B.4090404@iki.fi>
Date: Wed, 21 Nov 2012 13:06:03 +0200
From: Tomi Valkeinen <tomba@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Alex Courbot <acourbot@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>, Rob Herring <rob.herring@calxeda.com>,
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
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com> <1353149747-31871-2-git-send-email-acourbot@nvidia.com> <20121120215429.B621F3E1821@localhost> <13540495.epaCf4JVn9@percival>
In-Reply-To: <13540495.epaCf4JVn9@percival>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-21 06:23, Alex Courbot wrote:
> Hi Grant,
> 
> On Wednesday 21 November 2012 05:54:29 Grant Likely wrote:
>>> With the advent of the device tree and of ARM kernels that are not
>>> board-tied, we cannot rely on these board-specific hooks anymore but
>>
>> This isn't strictly true. It is still perfectly fine to have board
>> specific code when necessary. However, there is strong encouragement to
>> enable that code in device drivers as much as possible and new board
>> files need to have very strong justification.
> 
> But doesn't introducing board-specific code into the kernel just defeats the 
> purpose of the DT? If we extend this logic, we are heading straight back to 
> board-definition files. To a lesser extent than before I agree, but the problem 
> is fundamentally the same.

I don't think so. I'll reiterate my opinion on this subject, as a
summary and for those who haven't read the discussions of the earlier
versions of the series. And perhaps I'll even manage to say something
new =).


First about the board specific code. I think we may need some board
specific code, even if this series was merged. Let's call them board
drivers. These board drivers would only exist for boards with some weird
setups that cannot be expressed or managed with DT and normal drivers.

I think these cases would be quite rare, as I can't even come up with a
very good example. I guess most likely these cases would involve some
small trivial chips for muxing or such, for which it doesn't really make
sense to have a real driver.

Say, perhaps a board with two LCDs connected to one video output, and
only one LCD can be enabled at a time, and you need to set some mux chip
to route the signals to the correct LCD. In this case I'd see we should
have hotplug support in the display framework, and the board driver
would act on user input (sysfs file, perhaps), plugging in/out the LCD
device depending on the user input.


As for expressing device internal details in the DT data, as done in
this series, I don't like it very much. I think the DT data or the board
file should just describe which device is the one in question, and how
it's connected to other components on the board. The driver for the
device should handle everything else.

As Alex pointed out, there may be lots of devices that work the same way
when enabled, but require slightly different power-on/off sequences. We
could have these sequences in the driver itself, either as plain code,
or in a table of some sort, possibly using the power sequence framework
presented in this series. The correct code or sequence would be ran
depending on the particular model of the device.

I think this approach is correct in the sense that this is what drivers
are supposed to do: handle all the device internal matters. But this
raises the problem of bloating the kernel with possibly lots of
different power sequences, of which only a few would be used by a board,
and all the rest would just be waste of memory.

Regarding this problem I have the following questions, to which I don't
have clear answers:

- How much of this device specific data is too much? If a driver
supports 10 different models, and the sequences for each model take 100
bytes, this 1000 bytes doesn't sound too much. But where's the limit?
And even if one driver only has 1kB of this data, what if we have lots
of similar drivers?

- How many bytes does a power sequence presented in this series take, if
the sequence contains, say, 5 steps, with gpio, delay, pwm, delay and
regulator?

- How likely is it that we'll get lots of different models? A hundred
different models for a backlight PWM with different power-on/off
sequences already sounds a really big number. If we're only going to
have each driver supporting, say, no more than 10 models, perhaps the
problem is not even an issue in practice.

- Are there ways to limit this bloat in the driver? One obvious way
would be to discard the unused sequences after driver probe, but that
only works for platform devices. Although, I guess these sequences would
mostly be used by platform drivers? If so, then the problem could be
solved by discarding the data after probe. Another would be to load the
sequences from a file as firmware, but that feels quite an awful
solution. Anybody have other ideas?

One clear positive side with in-driver approach is that it's totally
inside the kernel, and can be easily reworked in the future, or even
changed to a DT-based approach as presented in this series if that seems
like a better solution. The DT based approach, on the other hand, will
be more or less written to stone after it's merged.


So, I like the framework of expressing the sequences presented in this
series (except there's a problem with error cases, as I pointed out in
another post), as it can be used inside the drivers. But I'm not so
enthusiastic about presenting the sequences in DT.

My suggestion would be to go forward with an in-driver solution, and
look at the DT based solution later if we are seeing an increasing bloat
in the drivers.

 Tomi

