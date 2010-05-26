Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab0EZQCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 12:02:55 -0400
Received: from sprinkles.athenacr.com ([64.95.46.210]:39477 "EHLO
	sprinkles.inp.in.athenacr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752691Ab0EZQCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 12:02:53 -0400
Message-ID: <4BFD4629.6040602@athenacr.com>
Date: Wed, 26 May 2010 12:02:49 -0400
From: Brian Bloniarz <bmb@athenacr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
References: <4BF58B59.7080901@athenacr.com>	 <AANLkTinJ36UBMsVvTEoPnmAVS6np9Ja6heEtKA93r7tp@mail.gmail.com>	 <ce764b91-11b0-44a5-9cf9-96977652bbd5@default>	 <1274727116.2954.5.camel@localhost.localdomain>	 <4BFADF9D.9050209@zytor.com 1274733566.2954.73.camel@localhost.localdomain>	 <3ec7f284-1507-47fb-b5a2-eea29f68c627@default> <4BFAFE17.8060105@zytor.com>	 <4BFB2902.50308@athenacr.com>  <4BFC687A.9040304@athenacr.com>	 <1274834888.4678.66.camel@localhost.localdomain>	 <4BFC8C77.7020802@athenacr.com> <1274886299.1759.8.camel@work-vm>
In-Reply-To: <1274886299.1759.8.camel@work-vm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2010 11:04 AM, john stultz wrote:
> Right but having applications add "Linux on x86 where the TSC is being
> used" logic is pretty poor solution. Its an issue that should be
> addressed from the kernel side.

Yeah, sure.

> And really, if apps really wanted this info, they can fish it out
> of /proc/cpuinfo.
Really? I was under the impression that tsc_khz can differ
from cpu_mhz (invariant tsc?), and cpu_mhz can differ from what
shows up in /proc/cpuinfo cpuMHz due to cpufreq scaling. I was
also under the impression that knowing or controlling tsc_khz
is what NTP needs to ensure stability (assuming the TSC is
otherwise stable, i.e. no halts-in-idle, NMI etc etc weirdness).

Dan Magenheimer wrote:
> /sys/devices/system/clocksource/clocksource0/current_khz
>
> is that an acceptable arch-independent patch? (And which do
> you prefer?)

Thomas Gleixner:
> I'd rather see a generic solution which provides the information of
> the current (and possibly those of the available) clock source(s). 

Another possibility:

$ cd /sys/devices/system/clocksource/clocksource0/

$ ls -lR
available_clocksource
current_clocksource
current_clocksource_ln -> tsc
tsc/
tsc/calibration
tsc/calibrated_master -> ../hpet
tsc/khz
hpet/
hpet/calibration
hpet/khz

$ cat tsc/calibration
slave
# there has been a one-time calibration against a reference at boot time,
# the source clock is in calibrated_master and and the khz is calculated
# from that

$ cat hpet/calibration
constant
# takes its value from constant value from boot loader, configuration
# or some CPU/chipset register

Would this be workable? I need to look deeper at how the other clocksources
work, for example the virtualized ones. I'm also wondering if NICs with their
own clocks & IEEE-1588 support are going to become part of the clocksource
infrastructure (see e.g. http://patchwork.ozlabs.org/patch/52626/)

Thanks everyone for the guidance.
