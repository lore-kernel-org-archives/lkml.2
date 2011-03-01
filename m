Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab1CAK2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 05:28:18 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:63104 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146Ab1CAK2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 05:28:16 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 3/8] Add a mfd IPUv3 driver
Date: Tue, 1 Mar 2011 11:27:49 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, Paul Mundt <lethal@linux-sh.org>,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Alan Cox <alan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <1298887229-7987-1-git-send-email-s.hauer@pengutronix.de> <201102281811.45277.arnd@arndb.de> <20110301091544.GK29521@pengutronix.de>
In-Reply-To: <20110301091544.GK29521@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103011127.51605.arnd@arndb.de>
X-Provags-ID: V02:K0:mlX4EFF13jI+Qk1g5l0q5+9zSPi7fL5pTmgzV5Fwuug
 b+UYFiP6y5bZWFBh4zpmuJ9u1tOvPvEfnZyIO02WIojObsLKg4
 wZDug74EjCePMB3uZ6xZrZK3ad+4tHBHjFTpJfNcVDRKHXgEeC
 gwhse8tMLQbbibve5O5zV0uP5PpWLTru2FnKhG0PelxQv7x2BF
 FWuNX4bBF6TbvitY5x5VQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 March 2011, Sascha Hauer wrote:

> When turning this into a kms driver moving the source code will be the
> smallest problem I guess.
> I have no preference where to put this code. First it was in
> drivers/mfd/ and it felt wrong because there seems to be too much code
> in it a mfd maintainer shouldn't be bothered with. drivers/video/ seems
> to be wrong because this code will probably support cameras which belong
> to drivers/media/video/. So if there's consensus on drivers/gpu/ I will
> happily put it there.
> What directory do you suggest? drivers/gpu/ or some subdirectory
> (drm/vga)?

I'd suggest a subdirectory of drivers/gpu/, e.g.
drivers/gpu/embedded/imx-ipu/. Alan is currently adding a driver
for the Intel GMA500, and there are others (TI, ST-Ericsson, ...)
that fit in a similar category of complex graphics subsystems
without an actual GPU core. I think they should all go to the same
place.

> > The interrupt logic needs some comments. What are you trying to achieve here?
> 
> The IPU has 463 status bits which can trigger an interrupt. Most
> of them are associated to channels, some are general interrupts. My
> problem is that I don't know how the interrupts will be used by drivers
> later. Most drivers will probably use only one interrupt but others
> will be interested in a larger group of interrupts. So I decided to
> use a bitmap allowing each driver to register for groups of event
> it is interested in.

Ok, I see. So you essentially have a huge nested interrupt controller
and try to be clever about the possible use cases, which may be the
right choice, but apparently you don't know that yet because not
all the drivers have been written at this point.

Taking one step back from this, have you considered making this
a regular interrupt controller? That would make the client drivers
more standard -- you could define the interrupt numbers as resources
of a platform device or in the device tree, for instance.
The cost might be more complex code, e.g. when a device requires
many interrupts, but I think it will be at least as efficient
at run-time, and less surprising for readers and authors of
client drivers.

	Arnd
