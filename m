Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab2LBCeM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 21:34:12 -0500
Received: from us-mx3.synaptics.com ([12.239.217.85]:24029 "EHLO
	us-mx3.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab2LBCeK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 21:34:10 -0500
From: Christopher Heiny <Cheiny@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        Linux Input <linux-input@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: RE: [PATCH 2/4] Input: RMI4 - move sensor driver and F01 handler
 into the core
Thread-Topic: [PATCH 2/4] Input: RMI4 - move sensor driver and F01 handler
 into the core
Thread-Index: AQHNzIBPu2VspvNYJEywNifpuvIQJZgAQj0AgAFWwwCAAzhALA==
Date: Sun, 2 Dec 2012 02:36:31 +0000
Message-ID: <BFABBC009FBA1C43B207B15FD485ABD922D67BCF@USW-MAIL1.synaptics-inc.local>
References: <1354008098-26346-1-git-send-email-dmitry.torokhov@gmail.com>
 <1354008098-26346-2-git-send-email-dmitry.torokhov@gmail.com>
 <50B6EA88.2010506@synaptics.com>,<20121129172120.GA3656@core.coreip.homeip.net>
In-Reply-To: <20121129172120.GA3656@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.10.35]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for top posting this - I forgot to email while still at work.

I've been poking at this, and think (a) it's possible that I'm being too paranoid, and (b) it looks like it'll work with some of the future stuff.  So I'll back off my objections for the moment, and give these changes a try, possibly with some slight modifications.

Thanks!
Chris
________________________________________
From: linux-input-owner@vger.kernel.org [linux-input-owner@vger.kernel.org] on behalf of Dmitry Torokhov [dmitry.torokhov@gmail.com]
Sent: Thursday, November 29, 2012 9:21 AM
To: Christopher Heiny
Cc: Linus Walleij; Linux Input; Linux Kernel; Allie Xiong; Vivian Ly; Daniel Rosenberg; Alexandra Chin; Joerie de Gram; Wolfram Sang; Mathieu Poirier
Subject: Re: [PATCH 2/4] Input: RMI4 - move sensor driver and F01 handler into the core

Hi Chris,
On Wed, Nov 28, 2012 at 08:54:32PM -0800, Christopher Heiny wrote:
> On 11/27/2012 01:21 AM, Dmitry Torokhov wrote:
> >There is no point in having the sensor driver and F01 handler separate
> >from the RMI core since it is not useful without them and having them
> >all together simplifies initialization among other things.
>
> Hi Dmitry,
>
> I've been looking at this patch as well as your patch 3/4 changes,
> and I'm not sure it's for the better.
>
> One thing that confuses me is that these appear to go against the
> advice we've been getting over the past months to rely more on
> standard kernel bus and driver implementations, instead of the
> "roll-your-own" implementation we had been using before.
>
> More importantly, the patches inextricably link the sensor driver
> implementation and the F01 driver implementation to the bus
> implementation, and means that any given system can have only one
> way of managing F01.  As you observed, a sensor is pretty much
> useless without an F01 handler, but I am reasonably sure that there
> will be future systems that have more than one RMI4 sensor in them,
> and there is a strong possibility that these sensors may have
> different requirements for handling F01.  In the near future, then,
> these changes will have to be refactored back to something more like
> the structure of our 2012/11/16 patch set.
>
> Additionally, having F01 as a special case means that when we start
> implementing things such as support for request_firmware(), there
> will have to be a bunch of special case code to deal with F01, since
> it's no longer "just another function driver".  That seems to go in
> exactly the opposite direction of the simplification that you're
> trying to achieve.

But F01 continues to being "just another function driver" even with my
changes. It is still registered as rmi_fucntion_handler and uses
standard matching mechanisms to bind to rmi_functions registered by the
sensor driver. What I changed is the fact that rmi_f01 is no longer a
separate module which could be loaded after loading rmi_bus and it can't
be unloaded without unloading rmi_bus. This simplifies things and makes
it easier to have rmi core compiled as a module.

Also I do not quite follow your idea that devices might have different
requirements for handling F01. If that is true then be _can't_ implement
"F01" as "another function driver"... But that is orthogonal for the 3/4
change we are discussing here.

Thanks.

--
Dmitry
--
To unsubscribe from this list: send the line "unsubscribe linux-input" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
