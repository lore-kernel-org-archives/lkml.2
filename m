Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab1K2XeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 18:34:21 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:60740 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425Ab1K2XeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 18:34:19 -0500
Message-ID: <1322609653.21423.46.camel@work-vm>
Subject: Re: CPU hyperthreading turned on after soft power-cycle
From: John Stultz <john.stultz@linaro.org>
To: Clarinet <clarinet@atlas.cz>
Cc: 647095@bugs.debian.org, Jonathan Nieder <jrnieder@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Date: Tue, 29 Nov 2011 15:34:13 -0800
In-Reply-To: <4ED4CF7C.8020808@atlas.cz>
References: <20111030110543.5872.61279.reportbug@supermicro.uochb.cas.cz>
	 <1319988329.6759.88.camel@deadeye> <4EAE9D3A.7000108@atlas.cz>
	 <4EB92181.5030500@seznam.cz> <20111110015212.GB2399@elie.gateway.2wire.net>
	 <4EBD2825.6050806@atlas.cz> <4EC43DF7.4010902@atlas.cz>
	 <1321561946.25715.16.camel@work-vm> <4EC59BCE.6050902@atlas.cz>
	 <1321574019.25715.52.camel@work-vm> <4ECA51B9.3010707@seznam.cz>
	 <1321905728.6445.2.camel@work-vm> <4ECAC340.8090908@atlas.cz>
	 <1322533915.24090.69.camel@work-vm> <4ED4CF7C.8020808@atlas.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11112923-3270-0000-0000-000002399E70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-29 at 13:26 +0100, Clarinet wrote:
> > Using an older "known-good" kernel, could you build and run the test
> > case at the end of Documentation/rtc.txt a few times and see if it
> > triggers the same problem?
> >
> > I'm suspicious that the setting the alarm is whats tripping the BIOS
> > into enabling the HT bit. Because with older kernels, we used PIE mode
> > irqs which hwclock usually uses at boot, but with newer kernels, we
> > emulate PIE via AIE alarm mode. So if the BIOS was broken before, you
> > wouldn't have noticed unless you tried to use AIE irqs.
> >
> > If this doesn't work, I'll get some patches to both 2.6.27 and 2.6.28
> > kernels to debug the exact flow of how we're touching the hardware and
> > then we can further narrow it down.
> 
> I ran the tests the following way:
> 
> - boot 2.6.37.6 - check /proc/cpuinfo - 12 processors
> - halt
> - boot 2.6.37.6 - check /proc/cpuinfo - 12 processors
> - run rtctest
> - reboot
> - boot 2.6.37.6 - check /proc/cpuinfo - 12 processors
> - halt
> - boot 2.6.37.6 - check /proc/cpuinfo - 12 processors
> - run rtctest
> - halt
> - boot 2.6.37.6 - check /proc/cpuinfo - 24 processors
> 
> So the conclusion is that only if rtctest is run and the machine is 
> halted, it triggers the HT problem. Reboot seems to "neutralize" 
> whatever rtctest did.

Ok, this also confirms that the board had issues *before* any changes
were made to the RTC core. I'd push the board vendor to update the BIOS
to avoid this issue.

Even so, I'm curious as to what exactly trips it up. Maybe we can
provide a module option for the rtc-cmos driver to disable the alarm
functionality, so you can at least avoid the issue until the board
vendor fixes the problem (if ever).

Assuming its the alarm being set, could you try the following on a
current kernel and let me know if it still shows the problem? hwclock
might throw some odd messages with this test patch, but those can be
ignored.

thanks
-john

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 05beb6c..d9814aa 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -305,8 +305,8 @@ static void cmos_irq_enable(struct cmos_rtc *cmos, unsigned char mask)
 	cmos_checkintr(cmos, rtc_control);
 
 	rtc_control |= mask;
-	CMOS_WRITE(rtc_control, RTC_CONTROL);
-	hpet_set_rtc_irq_bit(mask);
+//	CMOS_WRITE(rtc_control, RTC_CONTROL);
+//	hpet_set_rtc_irq_bit(mask);
 
 	cmos_checkintr(cmos, rtc_control);
 }




