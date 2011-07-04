Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab1GDKmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 06:42:21 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62281 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757262Ab1GDKmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 06:42:20 -0400
Message-ID: <4E11994B.7070103@gmail.com>
Date: Mon, 04 Jul 2011 20:43:23 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Bill Gatliff <bgat@billgatliff.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        viresh kumar <viresh.kumar@st.com>, Shawn Guo <shawn.guo@linaro.org>,
        Ryan Mallon <ryan@bluewatersys.com>
Subject: Re: [PATCH 1/3] PWM: add pwm framework support
References: <1309430517-23821-2-git-send-email-s.hauer@pengutronix.de> <BANLkTikQGFA7XcuAtEEi7_4m-j6-00sZ6Q@mail.gmail.com> <201106301441.24493.arnd@arndb.de> <BANLkTin_htv2z3D9Bbf6N8Y7UKFRvPtvOg@mail.gmail.com> <20110630170229.GP6069@pengutronix.de> <4E0D0595.5070205@gmail.com> <20110701073755.GR6069@pengutronix.de> <4E0D8540.2020200@gmail.com> <20110701085414.GV6069@pengutronix.de> <4E0E6916.50406@gmail.com> <20110704075556.GD6069@pengutronix.de>
In-Reply-To: <20110704075556.GD6069@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/11 17:55, Sascha Hauer wrote:
> I am tired of discussing this. It seems we can't agree and unless
> someone else jumps in here we will probably have to wait for another
> year until something moves in the PWM area.

If we are going to introduce a new framework for pwms then we should
create one which meets the needs of at least all of the in kernel
drivers. This patch series provides no solution for either the atmel or
ep93xx drivers, so it is not a complete solution. At some point the
api/framework _must_ be changed. If we can introduce transition layers
then we should do that now so they we can provide a common framework
along with some forward thinking about how the other drivers are going
to be migrated to the new framework. This patch series doesn't even
migrate _any_ of the existing drivers.

It doesn't have to be an all or nothing approach. Possibly Bill's series
is perhaps too involved by changing the api, introducing sysfs support
and reworking the pwm users. But your series is at the opposite end of
the spectrum. It does too little. It will take a few release cycles to
get all of the existing drivers migrated and since we can't change the
api until that happens the atmel and ep93xx drivers will take longer
still. At the very least your series should migrate some of the drivers.

The timeline argument is a bit poor. Yes, there has been discussion for
a lengthy time about how the pwm api should be developed, but I think
that is because it is non-trivial to come up with a framework which is
good enough to support all of the pwm hardware (some of which is already
in the mainline). Getting something merged now just because it can be
done quickly is not a good idea if it all has to get reworked in the
future so that it can support all the hardware.

The pwm framework needs to incorporate at least the following:
 - sysfs access (ep93xx driver)
 - Multiple channels per device (atmel driver)

The mxs driver you introduce looks like it could be implemented as a
single device (continuous mmio space) with multiple channels rather than
the pwm core/driver approach you have. I also can't see anything in this
patch set which hooks up the mxs pwms to an actual board (i.e. nothing
calls mxs_add_mxs_pwm)?

The other nice things to have for the pwm framework are:
 - More fine grained control of pwms: pwm_period_ns, period_duty_ns, etc
 - Polarity control
 - Synchronisation support for multi-channel devices
 - Interrupt handler support
 - Sleeping vs non-sleeping configuration api

The fine-grained control api could be added now. pwm_config could be
left as is for the time being (the new api could be a wrapper around it
to start with). Polarity control and interrupt handling apis could also
be defined without affecting the drivers which don't need to implement
them. Multiple channels and the sleeping/non-sleeping api are the more
difficult ones, but at least having some sort of indication about how
these plan to be solved would be useful.

~Ryan

