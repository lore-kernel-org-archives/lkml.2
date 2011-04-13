Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858Ab1DMQ0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:26:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53913 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932601Ab1DMQ0P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:26:15 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Ben Gardiner <bengardiner@nanometrics.ca>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Ben Dooks <ben-linux@fluff.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bastian Ruppert <Bastian.Ruppert@sewerin.de>,
        "Griffis, Brad" <bgriffis@ti.com>,
        Jon Povey <jon.povey@racelogic.co.uk>,
        Philby John <pjohn@in.mvista.com>
Date: Wed, 13 Apr 2011 21:55:23 +0530
Subject: RE: [PATCH 0/6] i2c-davinci gpio pulsed SCL recovery with ICPFUNC
Thread-Topic: [PATCH 0/6] i2c-davinci gpio pulsed SCL recovery with ICPFUNC
Thread-Index: Acvz2cHowwCPWz90RZmr7wg5y3yAPAGGAqSQ
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024C8B3CD6@dbde02.ent.ti.com>
References: <cover.1302031487.git.bengardiner@nanometrics.ca>
In-Reply-To: <cover.1302031487.git.bengardiner@nanometrics.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Wed, Apr 06, 2011 at 03:08:03, Ben Gardiner wrote:
> This series for the i2c-davinci driver implements both a register dump and
> a pulsed-SCL recovery of the bus on those controllers that have ICPFUNC
> registers which is, so far, the da850 and da830 based platforms.
> 
> I2C "controller timed out" messages were being observed by both myself on the
> da850evm and Bastian Ruppert on some custom da850 hardware [1]. Originally I 
> thought it was the existing pulse-SCL routine but was quickly proven wrong; my
> apologies to John Povey and Philby John for jumping to conclusions.
> 
> A discussion was spawned on the e2e forums [2] where Brad Griffis was
> instrumental in the development of the recovery routine proposed by this patch
> series. It was pointed out by him that the da850's i2c controller has the
> ability to control the SDA and SCL pins as GPIOS through its ICPFUNC registers.
> The recovery routine implemented by the patch series toggles the SCL pin and 
> reads the SDA state using the ICPFUNC registers.

[...]

> 
> When creating this series I noticed that there are obvious similarities between
> the existing recovery routine implemented by Philby John and John Povey and the
> recovery routine proposed in this series. Testing was performed using the
> ICPFUNC regsiters to toggle SCL as prescribed by the existing routine and it
> was found that the recovery did not work. The method described initially by Brad
> Griffis had the initial state of SCL high and delays of 5us with a maximum 
of
> 8 pulses with a check of SDA each time as compared to the existing routine with
> undetermined SCL initial state, 20us delays and a maximum of 8 pulses. I tested

I wonder how these values (5us or 20us) are derived. The document[1]
referred to in the existing code says that "the master should send
9 clock pulses". I think 5us suggested by Brad assumes a 100KHz
bus. If that is so, this number should be derived out of the bus_freq
platform data.

[1] http://www.nxp.com/documents/user_manual/UM10204.pdf

> and found that if I changed the initial state of SCL or the number of pulses
> (Bastian had success with 16) that the recovery did not occur as expected;

Was this testing done with the original PinMuxed GPIO based approach or with
the new internal GPIO based approach?

> furthermore Brad pointed out that it was important to check the state of SDA
> after each pulse to see if the slave had released the line. Indeed, adding the
> check of SDA resulted in a quicker recovery. On my da850evm, at least, the
> recovery took only one SCL pulse every time.

Yes, the document referred to above suggests this too.

I guess the existing recovery mechanism and the new ICPFUNC
based approach shouldn't be functionally different - correct?

In that case, it would really be worthwhile to fix the existing
recovery method as well.

> 
> It would be nice to consolidate the two recovery routines and -- since they
> are gpio-based -- put the shared recovery routine in i2c-algo-bit so it can
> also be used by bitbanging i2c masters. I did not undertake the former because
> I don't have access to the hardware on which the existing recovery routine was
> tested.

I think if you see issues with existing code, you should just
go ahead and fix. AFAICT, the existing approach should have
worked for you. You can test on your hardware and those with
other hardware can test your patches as well and send their
acks.

Thanks,
Sekhar

> I did not undertake the latter since 1) it seems premature until the
> recovery routines are consolidated (or not) and 2) it would require more
> changes of a broad scope which I feared might mire the review process of this
> series which is, at its core, a functioning workaround of an observed problem
> with da850evm hardware (plus some regsiter dumps). It is my hope that both the
> consolidation of the recovery routines and the extraction to common bitbanging
> code can be done in a later series.
> 
> [1] http://permalink.gmane.org/gmane.linux.davinci/22291
> [2] http://e2e.ti.com/support/dsp/omap_applications_processors/f/42/p/99895/350610.aspx
> 
> Ben Gardiner (6):
>   i2c-davinci: register dump before attempted bus recovery
>   i2c-davinci: convert davinci_i2c_platform_data to kerneldoc
>   i2c-davinci: introduce a dev-> function pointer for scl pulsing
>   i2c-davinci: use the DA8xx's ICPFUNC to toggle I2C as gpio
>   i2c-davinci: if device has pfunc register, dump that group also
>   da8xx: enable the use of the ICPFUNC in i2c-davinci
> 
>  arch/arm/mach-davinci/devices-da8xx.c    |    6 +
>  arch/arm/mach-davinci/include/mach/i2c.h |   21 +++-
>  drivers/i2c/busses/i2c-davinci.c         |  155 ++++++++++++++++++++++++++++--
>  3 files changed, 170 insertions(+), 12 deletions(-)
> 
> 

