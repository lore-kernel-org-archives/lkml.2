Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab1KUUDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 15:03:13 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:59337 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab1KUUDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 15:03:07 -0500
Message-ID: <1321905728.6445.2.camel@work-vm>
Subject: Re: CPU hyperthreading turned on after soft power-cycle
From: John Stultz <john.stultz@linaro.org>
To: Jiri Polach <jiri.polach@seznam.cz>
Cc: Jiri Polach <clarinet@atlas.cz>, 647095@bugs.debian.org,
        Jonathan Nieder <jrnieder@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Date: Mon, 21 Nov 2011 12:02:08 -0800
In-Reply-To: <4ECA51B9.3010707@seznam.cz>
References: <20111030110543.5872.61279.reportbug@supermicro.uochb.cas.cz>
	 <1319988329.6759.88.camel@deadeye> <4EAE9D3A.7000108@atlas.cz>
	 <4EB92181.5030500@seznam.cz> <20111110015212.GB2399@elie.gateway.2wire.net>
	 <4EBD2825.6050806@atlas.cz> <4EC43DF7.4010902@atlas.cz>
	 <1321561946.25715.16.camel@work-vm> <4EC59BCE.6050902@atlas.cz>
	 <1321574019.25715.52.camel@work-vm> <4ECA51B9.3010707@seznam.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11112120-5518-0000-0000-00000087A5F1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 14:27 +0100, Jiri Polach wrote:
> >>>> Finally! After another 50+ compilations a have it! It took some time as
> >>>> first I had to find a reason why some revisions did not boot (almost 2/3
> >>>> were unbootable and the first bad commit was among them). Having this
> >>>> solved I have been able to bisect without "skipping". The result is
> >>>> surprising (at least for me) - believe it or not, the first bad commit
> >>>> is 6610e089 "RTC: Rework RTC code to use timerqueue for events" from
> >>>> John Stultz (I am sending him a copy of this message).
> >>>>
> >>>> I would never expect this would be a problem, but my understanding of
> >>>> this commit is very limited, so I am certainly missing the point.
> >>>> However, I have tried to compile 2.6.38 (which was "bad") with "Real
> >>>> Time Clock" configuration option turned off and it behaves "normally"
> >>>> then (= is "good").
> >>>
> >>> Huh. That's *very* odd.  Is your system doing anything in-particular
> >>> with the RTC?  I don't have a clue right off, so probably the next step
> >>
> >> Yes, it is very odd. The system does not do anything special with RTC.
> >> It is a diskless computational workstation.
> >>
> >>> is doing a bit of instrumentation to try to figure out where exactly we
> >>> trigger the behavior. Could you checkout commit 6610e089 and apply the
> >>> patch below to see if we can't narrow it down?
> >>
> >> With the patch applied the system does not show the strange behavior (=
> >> is "good").
> >>
> >>> Could you also send your .config to me?
> >>
> >> Sure. It is attached. I have found that if I turn CONFIG_RTC_DRV_CMOS
> >> off, the system behaves normally (= is "good") too.
> >
> > Yea. My rough guess is that the BIOS is somehow sensitive to how the
> > CMOS RTC is touched.
> >
> > Does disabling CONFIG_HPET_EMULATE_RTC change the behavior?
> 
> But how do I do it? :-)
> 
> I have not found a way to disable it in "menuconfig". If I comment it 
> out manually in .config, it is automatically set back to "y" as soon as 
> compilation starts ...

Good point. I forgot on x86_64 you can't disable HPET_TIMER.

Could you then use the following patch (and run make oldconfig before
building).

thanks
-john


diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cb9a104..77b5273 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -640,7 +640,7 @@ config HPET_TIMER
 	  Choose N to continue using the legacy 8254 timer.
 
 config HPET_EMULATE_RTC
-	def_bool y
+	def_bool n
 	depends on HPET_TIMER && (RTC=y || RTC=m || RTC_DRV_CMOS=m || RTC_DRV_CMOS=y)
 
 config APB_TIMER



