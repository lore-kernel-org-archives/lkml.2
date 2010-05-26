Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934825Ab0EZX2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 19:28:35 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47697 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab0EZX2e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 19:28:34 -0400
MIME-Version: 1.0
Message-ID: <a20d4b76-5ba0-44cf-a26b-f58129377354@default>
Date: Wed, 26 May 2010 16:26:31 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Venkatesh Pallipadi <venki@google.com>, Len Brown <lenb@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: RE: tsc reliability for Intel Core 2 Duo "Conroe"
References: <d1278473-1065-4607-98e0-67f2b985ec15@default
 AANLkTim1_8Rf0fPfycE92z5CAXpLXYga93A5qTxgXjqz@mail.gmail.com>
In-Reply-To: <AANLkTim1_8Rf0fPfycE92z5CAXpLXYga93A5qTxgXjqz@mail.gmail.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090206.4BFDAE55.00C5:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Venkatesh Pallipadi [mailto:venki@google.com]
> 
> On Wed, May 26, 2010 at 10:41 AM, Dan Magenheimer
> <dan.magenheimer@oracle.com> wrote:
> > Looking through code following up on the separate TSC-related
> > thread, I noticed that my Intel Core 2 Duo "Conroe" box
> > is determined to have an unstable TSC, so falls back
> > to clocksource==hpet.
> >
> > While a Conroe has X86_FEATURE_CONSTANT_TSC and not
> > X86_FEATURE_NONSTOP_TSC, a Conroe is only able to enter
> > C0 and C1 (unlike its sister Intel Core 2 Duo processor
> > "Merom" which can enter C0-C3).
> >
> > I was under the impression (possibly from an earlier kernel
> > version?) that tsc_constant PLUS inability to enter deep-C
> > states would result in an acceptably stable TSC to use
> > as a clocksource (assuming it passes a TSC warp test).
> >
> > So is this a bug?  Or is my impression incorrect?
> >
> > See tsc_check_state() in drivers/acpi/processor_idle.c.
> > I can submit a patch, but wanted to check first.
> 
> Adding Len.
> 
> tsc_check_state(0 should only mark TSC unstable when state > C1 and
> !NONSTOP_TSC. Are you seeing TSC marked even with only C1?
> 
> Or may be you are hitting the bug in acpi_pad.c that marks TSC
> unstable more aggressively. I recently sent out a patch for that here
> -
> https://patchwork.kernel.org/patch/100633/


Hi Venki and Len --

(all code references to 2.6.34)

I noticed the acpi_pad code also but that's not where I'm
getting the mark_tsc_unstable call from.

After digging deeper, it appears that this processor is entering
C2 (as can be seen /sys/devices/system/cpu/cpu*/cpuidle/ output below)
despite the documentation I have, as well as this posting from Len:
http://forum.soft32.com/linux/ACPI-states-Conroe-ftopict339089.html 
I wonder if C1E state is somehow incorrectly getting recorded as
C2 state?  Or maybe TSC doesn't stop in C2 (TSC is most certainly
not stopping), in which case the test in tsc_check_state() should
be againt ACPI_STATE_C2?

In any case, this appears to now be an ACPI C-state question
so thanks, Venki, for cc'ing Len... and tglx is off the hook :-)

Len, note that this box is an Intel SDP so if it is an odd
duck, please just let me know... though I think I may have
some Xen code to fix depending on the answer to the above.

Thanks,
Dan

/sys/devices/system/cpu/cpu0/cpuidle/state0/desc: CPUIDLE CORE POLL IDLE
/sys/devices/system/cpu/cpu0/cpuidle/state0/latency: 0
/sys/devices/system/cpu/cpu0/cpuidle/state0/name: C0
/sys/devices/system/cpu/cpu0/cpuidle/state0/power: 4294967295
/sys/devices/system/cpu/cpu0/cpuidle/state0/time: 0
/sys/devices/system/cpu/cpu0/cpuidle/state0/usage: 0
/sys/devices/system/cpu/cpu0/cpuidle/state1/desc: ACPI FFH INTEL MWAIT 0x0
/sys/devices/system/cpu/cpu0/cpuidle/state1/latency: 1
/sys/devices/system/cpu/cpu0/cpuidle/state1/name: C1
/sys/devices/system/cpu/cpu0/cpuidle/state1/power: 1000
/sys/devices/system/cpu/cpu0/cpuidle/state1/time: 1946
/sys/devices/system/cpu/cpu0/cpuidle/state1/usage: 7
/sys/devices/system/cpu/cpu0/cpuidle/state2/desc: ACPI IOPORT 0x814
/sys/devices/system/cpu/cpu0/cpuidle/state2/latency: 1
/sys/devices/system/cpu/cpu0/cpuidle/state2/name: C2
/sys/devices/system/cpu/cpu0/cpuidle/state2/power: 500
/sys/devices/system/cpu/cpu0/cpuidle/state2/time: 12636559121
/sys/devices/system/cpu/cpu0/cpuidle/state2/usage: 19779974
/sys/devices/system/cpu/cpu1/cpuidle/state0/desc: CPUIDLE CORE POLL IDLE
/sys/devices/system/cpu/cpu1/cpuidle/state0/latency: 0
/sys/devices/system/cpu/cpu1/cpuidle/state0/name: C0
/sys/devices/system/cpu/cpu1/cpuidle/state0/power: 4294967295
/sys/devices/system/cpu/cpu1/cpuidle/state0/time: 0
/sys/devices/system/cpu/cpu1/cpuidle/state0/usage: 0
/sys/devices/system/cpu/cpu1/cpuidle/state1/desc: ACPI FFH INTEL MWAIT 0x0
/sys/devices/system/cpu/cpu1/cpuidle/state1/latency: 1
/sys/devices/system/cpu/cpu1/cpuidle/state1/name: C1
/sys/devices/system/cpu/cpu1/cpuidle/state1/power: 1000
/sys/devices/system/cpu/cpu1/cpuidle/state1/time: 656
/sys/devices/system/cpu/cpu1/cpuidle/state1/usage: 4
/sys/devices/system/cpu/cpu1/cpuidle/state2/desc: ACPI IOPORT 0x814
/sys/devices/system/cpu/cpu1/cpuidle/state2/latency: 1
/sys/devices/system/cpu/cpu1/cpuidle/state2/name: C2
/sys/devices/system/cpu/cpu1/cpuidle/state2/power: 500
/sys/devices/system/cpu/cpu1/cpuidle/state2/time: 12652644397
/sys/devices/system/cpu/cpu1/cpuidle/state2/usage: 19717956
