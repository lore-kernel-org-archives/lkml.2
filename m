Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab1DEViQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 17:38:16 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:44837 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750940Ab1DEViO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 17:38:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=NJWWy2e8T6OQDfMg/OkZziFmyo6VywunDzm+WNoZMsoFIwRM4pW2PA95WMLtcrLLxs
         m5EzcF9Adv92ANAfaiYutixCGLE+OHIumJcurp1IRtKMCRi7Z3L/E3+gRR2HW00nXuC2
         XsdihlpKzXqJVGPn+HKnQX6IiJTc0rHiCWJkY=
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: davinci-linux-open-source@linux.davincidsp.com, linux-i2c@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>, Ben Dooks <ben-linux@fluff.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Bastian Ruppert <Bastian.Ruppert@sewerin.de>,
        Brad Griffis <bgriffis@ti.com>, Jon Povey <jon.povey@racelogic.co.uk>,
        Philby John <pjohn@in.mvista.com>
Subject: [PATCH 0/6] i2c-davinci gpio pulsed SCL recovery with ICPFUNC
Date: Tue,  5 Apr 2011 17:38:03 -0400
Message-Id: <cover.1302031487.git.bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series for the i2c-davinci driver implements both a register dump and
a pulsed-SCL recovery of the bus on those controllers that have ICPFUNC
registers which is, so far, the da850 and da830 based platforms.

I2C "controller timed out" messages were being observed by both myself on the
da850evm and Bastian Ruppert on some custom da850 hardware [1]. Originally I 
thought it was the existing pulse-SCL routine but was quickly proven wrong; my
apologies to John Povey and Philby John for jumping to conclusions.

A discussion was spawned on the e2e forums [2] where Brad Griffis was
instrumental in the development of the recovery routine proposed by this patch
series. It was pointed out by him that the da850's i2c controller has the
ability to control the SDA and SCL pins as GPIOS through its ICPFUNC registers.
The recovery routine implemented by the patch series toggles the SCL pin and 
reads the SDA state using the ICPFUNC registers.

The changes in this series are staged in increments of features and each patch
depends on the changes introduced by the patch before it with the exception of 
patch 2/6 which is largely independent of 1/6.

The real meat of the series in in patch 4/6. First we introduce a register
dump routine in 1/6 since this information was requested immeadiately by Brad
Griffis when the conversation began; then the i2c-davinci platform data 
structure's comments are converted to kerneldoc in 2/6. Then in 3/6 a level of
indirection is introduced so that the implementation of the recovery procedure
can be switched at runtime; this level of indirection is used in the subsequent
patch, 4/6, to execute a pulsed-SCL recovery routine using the ICPFUNC
registers if they are present. Where the presence of the registers is indicated
by the platform in a has_pfunc flag in platform data. Finally since all da8xx
platforms' i2c controllers have the ICPFUNC registers, the da8xx utility
function to register i2c controllers is modified to set the flag so that the
new recovery routine is used in all da8xx platforms.

I developed this patch against v2.6.38 but I have also tested it against 
v2.6.39-rc1: it applies cleanly and the recovery routine is executed as it was
in v2.6.38.

When creating this series I noticed that there are obvious similarities between
the existing recovery routine implemented by Philby John and John Povey and the
recovery routine proposed in this series. Testing was performed using the
ICPFUNC regsiters to toggle SCL as prescribed by the existing routine and it
was found that the recovery did not work. The method described initially by Brad
Griffis had the initial state of SCL high and delays of 5us with a maximum of
8 pulses with a check of SDA each time as compared to the existing routine with
undetermined SCL initial state, 20us delays and a maximum of 8 pulses. I tested
and found that if I changed the initial state of SCL or the number of pulses
(Bastian had success with 16) that the recovery did not occur as expected;
furthermore Brad pointed out that it was important to check the state of SDA
after each pulse to see if the slave had released the line. Indeed, adding the
check of SDA resulted in a quicker recovery. On my da850evm, at least, the
recovery took only one SCL pulse every time.

It would be nice to consolidate the two recovery routines and -- since they
are gpio-based -- put the shared recovery routine in i2c-algo-bit so it can
also be used by bitbanging i2c masters. I did not undertake the former because
I don't have access to the hardware on which the existing recovery routine was
tested. I did not undertake the latter since 1) it seems premature until the
recovery routines are consolidated (or not) and 2) it would require more
changes of a broad scope which I feared might mire the review process of this
series which is, at its core, a functioning workaround of an observed problem
with da850evm hardware (plus some regsiter dumps). It is my hope that both the
consolidation of the recovery routines and the extraction to common bitbanging
code can be done in a later series.

[1] http://permalink.gmane.org/gmane.linux.davinci/22291
[2] http://e2e.ti.com/support/dsp/omap_applications_processors/f/42/p/99895/350610.aspx

Ben Gardiner (6):
  i2c-davinci: register dump before attempted bus recovery
  i2c-davinci: convert davinci_i2c_platform_data to kerneldoc
  i2c-davinci: introduce a dev-> function pointer for scl pulsing
  i2c-davinci: use the DA8xx's ICPFUNC to toggle I2C as gpio
  i2c-davinci: if device has pfunc register, dump that group also
  da8xx: enable the use of the ICPFUNC in i2c-davinci

 arch/arm/mach-davinci/devices-da8xx.c    |    6 +
 arch/arm/mach-davinci/include/mach/i2c.h |   21 +++-
 drivers/i2c/busses/i2c-davinci.c         |  155 ++++++++++++++++++++++++++++--
 3 files changed, 170 insertions(+), 12 deletions(-)

