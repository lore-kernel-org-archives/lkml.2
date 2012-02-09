Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab2BIMoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 07:44:08 -0500
Received: from smtp-cpk.frontbridge.com ([204.231.192.41]:39903 "EHLO
	WA2EHSNDR003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754239Ab2BIMoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 07:44:05 -0500
X-FB-OUTBOUND-SPAM: yes
X-SpamScore: -6
X-BigFish: VS-6(zz1432N98dKzz1202h1082kzz8275dhz2dh87h2a8h668h839h944h41h42h)
X-Forefront-Antispam-Report: CIP:94.101.220.16;KIP:(null);UIP:(null);IPV:NLI;H:nzt0015e.dknz.nzcorp.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 9 Feb 2012 13:43:55 +0100
From: Anders Ossowicki <aowi@novozymes.com>
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
CC: <jk@novozymes.com>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Memory issues with Opteron 6220
Message-ID: <20120209124355.GA20902@otto.nzcorp.net>
Reply-To: <aowi@novozymes.com>
Mail-Followup-To: Andreas Herrmann <herrmann.der.user@googlemail.com>,
	jk@novozymes.com, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
	Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>
References: <20120208143741.GB28486@otto.nzcorp.net>
 <20120208205628.GA18909@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120208205628.GA18909@alberich.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SMTP-Mail-From: aowi@otto.nzcorp.net
X-OriginatorOrg: novozymes.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 09:56:28PM +0100, Andreas Herrmann wrote:
> I assume you have the latest BIOS on your system?
Yep, 2.3.0 is the newest available on Dell's website for this machine.
 
> After glancing through attached dmesg I wonder whether you have "Cool
> and quiet" disabled in BIOS, see
> 
> [    8.936505] [Firmware Bug]: powernow-k8: No compatible ACPI _PSS objects found.
> [    8.936514] [Firmware Bug]: powernow-k8: Try again with latest BIOS.
> 
> Is this on purpose?
I went digging through the power management options of the bios and found that
CPU performance was set to System DBPM[1] by default. After switching it to OS
DBPM, powernow-k8 seemed a lot happier:

[    5.272938] powernow-k8: Found 4 AMD Opteron(TM) Processor 6220
(16 cpu cores) (version 2.20.00)
[    5.273111] powernow-k8: Core Performance Boosting: on.
[    5.273256] powernow-k8:    0 : pstate 0 (3000 MHz)
[..]
[    5.274601] powernow-k8:    4 : pstate 4 (1400 MHz)

full dmesg at http://dev.exherbo.org/~arkanoid/atlas-dmesg-3.2.5-20120209.txt

>From cursory investigation, it appears we've gotten the expected performance
back, when all CPUs are running at max frequency. So far so good.

I am curious though... a few observations:
1) With System DBPM, /proc/cpuinfo said 3GHz, the performance of the machine
   was crappy.
2) With OS DBPM, /proc/cpuinfo said 1.4GHz, the performance of the machine was
   equally crappy, as expected.
3) With OS DBPM, and the performance cpufreq governor, /proc/cpuinfo said 3GHz,
   the performance of the machine was good. Again as expected.

The conclusion I draw from this is that something (the BIOS?) is lying to the
OS. Bad Dell!

The manual is sparse on explanations of this System DBPM. It basically says that
it is a Dell proprietary implementation in BIOS, that provides improved
performance/watt over the OS implementation of AMD PowerNow!.

I apologise if that made you spit out a mouthful of coffee but that really is
what it says. It doesn't seem to be doing its job very well.

This leaves the issue of randomly failing memory allocations. I can't see why
that would be related to the power management woes, but I am by no means an
expert.  I'll see if we can still trigger the problem, but if someone can see a
causal link, please enlighten me.

 
> To rule out memory from being the culprit ...
> Have you tested the newer CPU system with the old memory?
Nope.

> Have you observed any MCEs (e.g. DRAM ECC errors) on the failing system)?
> EDAC should report them in dmesg if this is the case.
Nothing in dmesg or the iDRAC's service event log (where ECC errors usually get
logged as well).


[1] Demand-based power management, apparently.

-- 
Anders Ossowicki

