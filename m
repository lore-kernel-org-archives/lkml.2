Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab2KSLwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 06:52:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:51119 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab2KSLwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 06:52:11 -0500
Date: Mon, 19 Nov 2012 12:52:09 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: DVS regulator drivers
Message-ID: <Pine.LNX.4.64.1211191213380.11024@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:wlV5qCSyAo0af6HD+ItWqgrpTOMERXTAV97Xw0cy0Qn
 DEhcL7/JEZ77UPBNPnzXPrA44x1yDpNpg09O3GEceHK5yXx+uC
 hXFo5rkcJ4rywPYwoWMxrq7Hm7pSTierOqZ1lidCkMFM1yrQqV
 cqgsNP0oNiWX0l3xeh2Lc3HO7dh7L9Ho109xk66t5VnDaHe92L
 yr3YPJDWjOR8q7w3DJLZHixjRhFd8EsC5weZEH8z5/z3E+Cg71
 Xhkzz7+D4vrOlXQy67TKKBvAc4xZRupxNhmlgWUjz0r0lH4z9A
 F/ZKXxy6NnGg50fkBY2zVoSnNYsqGc5qrPr7wcIqwW2AQVkukG
 t3nh56elko9ofvPzOoo4Ie0OyVSGxUUkl7iOxIwXX/Rh/GzucY
 NA87BMtnfXIAg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I mentioned in an earlier mail today [1] I have a difficulty seeing how 
the current regulator API can efficiently be used for DVS-type regulators. 
Trying to look at existing mainline drivers it seems to me they try to 
guess, what the user really wants, do that differently and don't manage to 
do that in a bug-free way. Specifically, I looked at 2 drivers:

wm831x-dcdc.c handles 2 voltages: "DVS" and "ON." If the new voltage in 
.set_voltage_sel() is equal to one of them, it is just used. If it is a 
new voltage, there's a comment in the driver in 
wm831x_buckv_set_voltage_sel():

	/* Always set the ON status to the minimum voltage */

but I actually don't see, where the minimum is selected. It seems instead 
in this case the "ON" value is just set:

	ret = wm831x_set_bits(wm831x, on_reg, WM831X_DC1_ON_VSEL_MASK, vsel);
	if (ret < 0)
		return ret;
	dcdc->on_vsel = vsel;

Then it goes on to actually switch the output voltage to this new "ON" 
value and then:

	/*
	 * If this VSEL is higher than the last one we've seen then
	 * remember it as the DVS VSEL.  This is optimised for CPUfreq
	 * usage where we want to get to the highest voltage very
	 * quickly.
	 */
	if (vsel > dcdc->dvs_vsel) {
		ret = wm831x_set_bits(wm831x, dvs_reg,
				      WM831X_DC1_DVS_VSEL_MASK,
				      dcdc->dvs_vsel);

Above the _old_ DVS value is set again?

		if (ret == 0)
			dcdc->dvs_vsel = vsel;

Now .dvs_vsel is set - after the voltage has been set to the old value. 
And now both - ON and DVS values are equal to the same value - vsel?... 
Confused.

lp872x.c seems to be selecting between ON and DVS (or V1 and V2 in lp872x' 
terminology) in lp872x_set_dvs(), which is called every time a voltage is 
set. But this function always gets the same arguments - supplied from the 
platform data and therefore only one voltage is ever used... The two 
"dynamic" DVS selection fields in struct lp872x: .dvs_pin and .dvs_gpio 
seem just to always stay constant, the latter is also just initialised 
once and is never used again.

Again, I don't have those devices, so I cannot test and would be a bit 
hesitant to provide patches, but that's my impression from just looking at 
them.

Thanks
Guennadi

[1] https://lkml.org/lkml/2012/11/19/169
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
