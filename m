Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945Ab2EGXs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 19:48:29 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:47127 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757484Ab2EGXs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 19:48:28 -0400
From: Kevin Hilman <khilman@ti.com>
To: "AnilKumar\, Chimata" <anilkumar@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "J\, KEERTHY" <j-keerthy@ti.com>,
        "linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "rjw\@sisk.pl" <rjw@sisk.pl>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm\@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "Pihet-XID\, Jean" <j-pihet@ti.com>
Subject: Re: [PATCH V3 00/10] PM: Create the AVS(Adaptive Voltage Scaling)
Organization: Texas Instruments, Inc.
References: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
	<20120426191159.GA9415@sirena.org.uk>
	<CAJ6a13a6WN9h1QZynpEOf-R6RXwWBZ2eOPkTeNc15JX_YfAz_w@mail.gmail.com>
	<20120427175657.GP18260@opensource.wolfsonmicro.com>
	<87397o3n4y.fsf@ti.com>
	<331ABD5ECB02734CA317220B2BBEABC13E9B1A67@DBDE01.ent.ti.com>
Date: Mon, 07 May 2012 16:48:41 -0700
In-Reply-To: <331ABD5ECB02734CA317220B2BBEABC13E9B1A67@DBDE01.ent.ti.com>
	(Chimata AnilKumar's message of "Fri, 4 May 2012 08:21:28 +0000")
Message-ID: <87mx5jy2li.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"AnilKumar, Chimata" <anilkumar@ti.com> writes:

> On Sat, Apr 28, 2012 at 02:31:17, Hilman, Kevin wrote:
>> Hi Mark,
>> 
>> Mark Brown <broonie@opensource.wolfsonmicro.com> writes:
>> 
>> > On Fri, Apr 27, 2012 at 11:09:10AM +0530, J, KEERTHY wrote:
>> >
>> >> Devfreq and cpufreq are related to dynamic frequency/voltage switching between
>> >> pre defined Operating Performance Points or the OPPs. Every OPP being
>> >> a voltage/frequency pair. Smartreflex is a different
>> >> power management technique.
>> >
>> > But presumably these things should integrate somehow - for example,
>> > should devfreq and cpufreq be providing inputs into what AVS is doing,
>> > and if so how?
>> 
>> The way it is currently designed, cpufreq/devfreq/regulator layers don't
>> need to know about AVS.
>> 
>> The higher-level layers only know about the "nominal" voltage.  AVS
>> hardware does automatic, adaptive, micro-adjustments around that nominal
>> voltage, and these micro-adjustments are managed by the AVS hardware
>> sending commands to the PMIC.  (specifically, on OMAP, the AVS sensors
>> provide inputs to the voltage processor (VP) which provide inputs to the
>> voltage controller (VC) which sends commands to the PMIC[1].)
>> 
>> The driver proposed here is primarily for initializing the various
>> parameters/sensitivity/etc. of the AVS hardware, but the actual voltage
>> adjustments are done in hardware by VC/VP.
>> 
>> The only thing the higher-level layers might potentially need to do to
>> enable/disable AVS around transitions (e.g. when changing OPP, AVS is
>> disabled before changing OPP and only re-enabled when the new nominal
>> voltage has been acheived.)
>> 
>> On OMAP, we handle this inside the OMAP-specific voltage layer which is
>> called by the regulator framework, so even the regulators do not need
>> any knowledge of AVS.
>
> Kevin,
>
> I want to point out some cases of SR implementation where this may not
> be true.
>
> Devices like DM8168, DM8148 and AM335X use Class 2B implementation of SR.
>
> Under this, SR module issues an interrupt to ARM when there is a need to
> change the voltage based on temperature changes, ageing etc.
>
> Once the interrupt arrives, kernel needs to adjust voltage using regulator API.
> The voltage change is a micro adjustment as in other SR classes.

That can easily be handled writing a plugin specific to class 2B.  This
driver was designed so plugins for other classes can be supported.  

Sure, we might need some enhancements for other classes (we already know
that we will for class 1 support.)  However, the purpose of this series
is to do the cleanups necessary for the driver to move to drivers/*.

Support for additional classes can be added after the driver is moved
if/when folks are motivated to post that support upstream.

> The SR class 2B implementation on these devices does not exist in mainline.
> I can point to some public repositories if you are interested in taking a look at
> the current code.

No thanks.  We can discuss it when you post support for it to mainline.

Kevin

> Implementation of this SR method is must on at least the DM8168 device and
> I know some customers who are using it on their production systems.
>
> Regards
> AnilKumar
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
