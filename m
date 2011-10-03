Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab1JCLAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 07:00:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60280 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab1JCLAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 07:00:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dmitry Artamonow <mad_soft@inbox.ru>
Subject: Re: [PATCH 2/6] ASoC: codecs: AK4641 depends on GPIOLIB
Date: Mon, 03 Oct 2011 12:59:58 +0200
Message-ID: <1655842.jHSiigr4V5@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <20111002212711.GC4506@opensource.wolfsonmicro.com>
References: <1317587284-2776-1-git-send-email-arnd@arndb.de> <2726393.3Oc3SrGyN4@wuerfel> <20111002212711.GC4506@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:zvzWTmoz7XMeR1ZkbKjHu9NcWWPdN8sow0q6L3VxpgI
 bj/hfuuXpspCrnQz6IDdHeTA+vKv0yugdBZgDfsvzjbhPOl+Ug
 D84K2dZ7EJ24TE09gyznlCS+weGM2x7puEzHrOv6fk1YRTe20k
 9O3EBiDD/0eyMoT+MY1PV64Q+9eD5Pf01u2M7ur2udHYhIh6X6
 0ZcvzIVfZPtczo7BrdiaZvtXglfIpMZrqqCG7Kz9COQDdTyCAY
 9cuexIpGrnmbZ0s9IdQ0EbufeZWhim+mApuN5NVpDwYYIfa1J8
 3JKu6bML/UWgvRdU1h99lY1N0+d4FNN8Wu2JQ1rmsUuuLZHWBL
 tuDG6YnrryKfvxYtoq3w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 October 2011 22:27:11 Mark Brown wrote:
> > Is there any other symbol that I can test then?
> 
> You shouldn't be testing anything - the client side GPIO API (which is
> what this driver is using) is supposed to stub itself out when not in
> use so drivers should just be able to use it without worrying about
> dependencies.  You didn't report the problem but I'd expect that
> whatever you saw will be an issue in whatever platform you were trying
> to build for (I'm guessing it hasn't provided gpio_request_one()),
> though it could be a problem in the gpiolib stubs if that's being used.

I don't remember where I first saw it. If the problem comes back,
I'll do a full bug report. I've verified now that it works on
various platforms with and without GPIOLIB.

I didn't know how the GPIO bits fit together, so I ended up doing
something that made the problem go away, whatever it was. This
is of course a problem with the randconfig fixing: One really needs
to understand every possible corner of the kernel to get it right,
and if you don't you end up with a patch that avoids the symptom
without fixing the underlying bug and then you make it harder to
find.

I really appreciate you doing the thorough review of the patches
to make sure we find the actual bugs, which is one of the main
things I want to achieve here anyway.

> > I noticed that a lot of places use 'depends on GPIOLIB' or
> > '#ifdef CONFIG_GPIOLIB', are those usually wrong, too?
> 
> Checks for gpiolib in drivers providing GPIOs are sensible, if a
> platform hasn't used gpiolib then it's generally not even got an
> interface for drivers to provide GPIOs.
> 
> On the user side these are usually due to people making the sort of
> changes you're making here due to a random build coverage issue - it
> seems unfortunately common for people to just shove a dependency in
> Kconfig when they run into a build coverage issue without looking at
> what's going on.  For a lot of the stuff you see on PCs it's going to
> make sense but for some of the "service" APIs like GPIOs that are more
> commonly used only in embedded contexts the use of the API is usually
> completely optional (eg, in this case the driver is controlling power
> and reset lines which could easily just be strapped in the hardware with
> no soft control and are supplied as optional platform data) so for many
> systems the driver is going to work completely happily without doing
> anything with GPIOs.
> 
> Adding dependencies to all the users needlessly restricts which systems
> can use the drivers.  Adding ifdefs to the drivers is repetitive and
> isn't great for legiblity, having the header stub itself out is simpler
> and easier to use on the driver side.

Ok, makes sense. Thanks for the background information!

	Arnd
