Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab2LMJNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 04:13:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42580 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab2LMJNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 04:13:06 -0500
From: Paolo Pisati <paolo.pisati@canonical.com>
To: linux-omap <linux-omap@vger.kernel.org>
Cc: Paul Walmsley <paul@pwsan.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Robert Nelson <robertcnelson@gmail.com>,
        Felipe Balbi <balbi@ti.com>, stable@vger.kernel.org,
        Paolo Pisati <paolo.pisati@canonical.com>
Subject: [PATCH] [resend] regulator: core: if voltage scaling fails, restore original values
Date: Thu, 13 Dec 2012 10:12:59 +0100
Message-Id: <1355389980-5532-1-git-send-email-paolo.pisati@canonical.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[resent with cc: stable and a bit more context]

I've been experiencing solid hangs on my beaglexm with v3.7 after                                                                                                                         
kexec:                                                                                                                                                                                    
                                                                                                                                                                                          
here is my .config (omap2plus + EHCI/OHCI + CPUFREQ + DEVTMP):                                                                                                                            
                                                                                                                                                                                          
http://people.canonical.com/~ppisati/omap3_cpufreq_kexec/config                                                                                                                           
                                                                                                                                                                                          
here is the diff i added to get some debugging:                                                                                                                                           
                                                                                                                                                                                          
http://people.canonical.com/~ppisati/omap3_cpufreq_kexec/dpll-debug.diff                                                                                                                  
                                                                                                                                                                                          
here is a trace of the kexeced kernel:                                                                                                                                                    
                                                                                                                                                                                          
http://people.canonical.com/~ppisati/omap3_cpufreq_kexec/kexec-boot.txt

And after a second look it's clear what's going on:

[...]
[    5.575744] cpu cpu0: cpufreq-omap: 300 MHz, -1 mV --> 800 MHz, 1325 mV
[    5.582946] voltdm_scale: No voltage scale API registered for vdd_mpu_iva
[    5.590332] cpu cpu0: omap_target: unable to scale voltage up.
[1]
[    5.596649] notification 1 of frequency transition to 300000 kHz
[    5.603179] FREQ: 300000 - CPU: 0
[    5.606597] governor: change or update limits
[    5.611572] __cpufreq_governor for CPU 0, event 3
[    5.616699] setting to 800000 kHz because of event 3
[    5.622039] target for CPU 0: 800000 kHz, relation 1
[    5.627441] request for target 800000 kHz (relation: 1) for cpu 0
[    5.634063] target is 2 (800000 kHz, 2)
[    5.638183] notification 0 of frequency transition to 800000 kHz
[    5.644775] cpu cpu0: cpufreq-omap: 300 MHz, -1 mV --> 800 MHz, 1325 mV
[2]
[hangs here]

first time[1] it tries to ramp up frequency (and thus voltage),
regulator_set_voltage() returns an error and we exit:

omap-cpufreq.c::omap_target():

	...
    dev_dbg(mpu_dev, "cpufreq-omap: %u MHz, %ld mV --> %u MHz, %ld mV\n",
        freqs.old / 1000, volt_old ? volt_old / 1000 : -1,
        freqs.new / 1000, volt ? volt / 1000 : -1);

    /* scaling up?  scale voltage before frequency */
    if (mpu_reg && (freqs.new > freqs.old)) {
        r = regulator_set_voltage(mpu_reg, volt - tol, volt + tol);
        if (r < 0) {
            dev_warn(mpu_dev, "%s: unable to scale voltage up.\n",
                 __func__);
            freqs.new = freqs.old;
            goto done;
        }
    }

	ret = clk_set_rate(mpu_clk, freqs.new * 1000);
	...

but inside regulator_set_voltage(), we save the new regulator voltage before
actually ramping up:

core.c::regulator_set_voltage():
	...
    regulator->min_uV = min_uV;
    regulator->max_uV = max_uV;

    ret = regulator_check_consumers(rdev, &min_uV, &max_uV);
    if (ret < 0)
        goto out2;

    ret = _regulator_do_set_voltage(rdev, min_uV, max_uV);  <-- ERROR!!!
    if (ret < 0)
        goto out2;
	...


and by the time we try to change frequency again[2], regulator_set_voltage()
is a noop because it thinks we are already at the desired voltage:

core.c::regulator_set_voltage():

	...
    /* If we're setting the same range as last time the change
     * should be a noop (some cpufreq implementations use the same
     * voltage for multiple frequencies, for example).
     */
    if (regulator->min_uV == min_uV && regulator->max_uV == max_uV)
        goto out;
	...

and as a consequence, in omap_target(), we call clk_set_rate() with
the wrong voltage.

The attached patch restore the original regulator voltage values in case
of an error.

CCing stable@ since it predates 2.6.38rc1 when the noop optimization was
introduced:

commit 95a3c23ae620c1b4c499746e70f4034bdc067737
Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
Date:   Thu Dec 16 15:49:37 2010 +0000

    regulator: Optimise out noop voltage changes

Paolo Pisati (1):
  regulator: core: if voltage scaling fails, restore original voltage
    values

 drivers/regulator/core.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

-- 
1.7.10.4

