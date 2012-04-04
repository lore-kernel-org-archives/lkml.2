Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab2DDSdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 14:33:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932267Ab2DDSdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 14:33:50 -0400
Message-ID: <4F7C9402.3090602@redhat.com>
Date: Wed, 04 Apr 2012 14:33:38 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Salman Qazi <sqazi@google.com>, stable@kernel.org
Subject: Re: [PATCH] clocksource, prevent overflow in clocksource_cyc2ns
References: <1333552260-1170-1-git-send-email-prarit@redhat.com> <4F7C8C3E.1020203@us.ibm.com>
In-Reply-To: <4F7C8C3E.1020203@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> One idea might be to replace the cyc2ns w/ mult_frac in only the watchdog code. 
> I need to think on that some more (and maybe have you provide some debug output)
> to really understand how that's solving the issue for you, but it would be able
> to be done w/o affecting the other assumptions of the timekeeping core.
> 

Hey John,

After reading the initial part of your reply I was thinking about calling
mult_frac() directly from the watchdog code as well.

Here's some debug output I cobbled together to get an idea of how quickly the
overflow was happening.

[    5.435323] clocksource_watchdog: {0} cs tsc csfirst 227349443638728 mask
0xFFFFFFFFFFFFFFFF mult 797281036 shift 31
[    5.444930] clocksource_watchdog: {0} wd hpet wdfirst 78332535 mask
0xFFFFFFFF mult 292935555 shift 22

These, of course, are just the basic data from the clocksources tsc and hpet.

This next output shows the overflow of the clocksource_cys2ns() function.

The output is

clocksource_watchdog: {cpu_number} cs cs->read() clocksource_cyc2ns(csnow -
csfirst) clocksource_cyc2ns_calling_mult_frac()

and

clocksource_watchdog: {cpu_number} wd wd->read() clocksource_cyc2ns(wdnow - wdfirst)

[   19.429080] clocksource_watchdog: {28} cs 37709489529 5410200359 14000134951
[   19.436964] clocksource_watchdog: {28} wd 200456437 14000133902
[   19.928803] clocksource_watchdog: {29} cs 39056111109 5910151011 14500085603
[   19.936678] clocksource_watchdog: {29} wd 207614817 14500084315
[   20.428600] clocksource_watchdog: {30} cs 40402933983 6410176395 15000110987
[   20.436477] clocksource_watchdog: {30} wd 214774270 15000109668
[   20.928376] clocksource_watchdog: {31} cs 41749696692 6910179442 15500114034
[   20.936260] clocksource_watchdog: {31} wd 221933402 15500112602
[   21.428091] clocksource_watchdog: {0} cs 43096297329 7410122318 16000056910
[   21.435878] clocksource_watchdog: {0} wd 229091680 16000055891
[   21.927855] clocksource_watchdog: {1} cs 44443031499 7910114770 16500049362
[   21.935642] clocksource_watchdog: {1} wd 236250654 16500047790
[   22.427640] clocksource_watchdog: {2} cs 45789820092 8410127427 17000062019
[   22.435426] clocksource_watchdog: {2} wd 243409925 17000060432
[   22.927479] clocksource_watchdog: {3} cs 47136754215 320259522 17500128706

^^^^ Right here.  The output of clocksource_cyc2ns() overflows, so in theory
anything with a delay of ~18 seconds or greater would cause an overflow in the
watchdog calculation.

[   22.935168] clocksource_watchdog: {3} wd 250569969 17500127061
[   23.427221] clocksource_watchdog: {4} cs 48483425124 820228487 18000097671
[   23.434916] clocksource_watchdog: {4} wd 257728618 18000096262
[   23.926970] clocksource_watchdog: {5} cs 49830120549 1320206554 18500075738
[   23.934762] clocksource_watchdog: {5} wd 264887389 18500073983
[   24.426772] clocksource_watchdog: {6} cs 51176954790 1820236158 19000105342
[   24.434564] clocksource_watchdog: {6} wd 272046903 19000103596
[   24.926565] clocksource_watchdog: {7} cs 52523765154 2320256898 19500126082
[   24.934343] clocksource_watchdog: {7} wd 279206289 19500124270

[Aside: Eventually, the hpet overflows too!]

So on to the reproducer ... in which I did

echo 1 > /proc/sys/kernel/sysrq
for i in `seq 10000`; do sleep 1000 &  done
echo t > /proc/sysrq-trigger


Apr  2 20:05:17 intel-canoepass-02 kernel: [  104.429864]  [<ffffffff814fb7db>]
do_nanosleep+0x8b/0xc0
Apr  2 20:05:17 intel-canoepass-02 kernel: [  104.429866]  [<ffffffff81097324>]
hrtimer_nanosleep+0xc4/0x180

<snip lots of backtraces for 14000 tasks>

[  621.639952] Clocksource tsc unstable (delta = -4589931578 ns)

And then obviously the system switches to hpet.  If, however, I switch to using
the mult_func() the problem goes away so I'm sure my theory is right.

Let me know if you'd like to see any other debug from this.  I can certainly
dump anything you want.

P.

