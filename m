Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380Ab1HMPqu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 11:46:50 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51161 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab1HMPqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 11:46:48 -0400
Date: Sat, 13 Aug 2011 10:46:38 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Dave Jones <davej@redhat.com>
Cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mattia Dongili <malattia@debian.org>
Subject: [BUG?] Moving drivers to drivers/cpufreq/ causes all to be loaded
Message-ID: <20110813154638.GA1494@elie.gateway.2wire.net>
References: <20110414094447.GA1611@n2100.arm.linux.org.uk>
 <alpine.LFD.2.00.1104211629300.24613@xanadu.home>
 <201104261605.26791.arnd@arndb.de>
 <201104261904.45923.rjw@sisk.pl>
 <20110426181508.GB1908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426181508.GB1908@redhat.com>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(-cc: linux-arm-kernel, +cc: linux-kernel, Mattia)
Hi,

Dave Jones wrote:

> in cpufreq.next I moved the x86 drivers over.  Someone look it over ?

Some people[1] have been seeing regressions after this change (when
moving from 2.6.39 to 3.0, presumably from commit bb0a56ecc4ba,
"[CPUFREQ] Move x86 drivers to drivers/cpufreq/").  The first symptom
was messages at boot:

| Loading cpufreq kernel modules...FATAL: Error inserting powernow_k7 (/lib/modules/3.0.0-1-486/kernel/drivers/cpufreq/powernow-k7.ko): No such device
| FATAL: Error inserting speedstep_ich (/lib/modules/3.0.0-1-486/kernel/drivers/cpufreq/speedstep-ich.ko): No such device
| FATAL: Error inserting acpi_cpufreq (/lib/modules/3.0.0-1-486/kernel/drivers/cpufreq/acpi-cpufreq.ko): Device or resource busy
[etc]

The second symptom was the wrong cpufreq driver being loaded
(p4-clockmod instead of acpi-cpufreq).  The cause seems to be some
code in init scripts that originated in powernowd 0.97-2ubuntu1 (2007)
or some time before that:

|         #get list of available modules (governors and helpers)
|         LOC="/lib/modules/$(uname -r)/kernel/drivers/cpufreq"
|         if [ -d $LOC ]; then
|           MODAVAIL=$( ( find $LOC -type f -name "*.o" -printf "basename %f .o\n"; \
|               find $LOC -type f -name "*.ko" -printf "basename %f .ko\n" ) | /bin/sh)
|         else
|           MODAVAIL=""
|         fi
| 
|         #echo "Loading cpufreq modules:"
|         for mod in $MODAVAIL; do
|         #        echo "     $mod"
|                 echo $LIST| grep -q -w "$mod" || modprobe $mod >/dev/null || /bin/true
|         done

This takes all kernel modules in drivers/cpufreq, blindly assumes
they must be governors or helpers, and loads them.  Nowadays it is
in the loadcpufreq script in cpufrequtils; so in cpufrequtils 007-2
(03 Aug 2011), the pattern changed to drivers/cpufreq/cpufreq_*.ko
which just matches the governors and helpers and everybody's happy.

Except:

 (1) This is still incredibly fragile.  What *should* cpufrequtils
     be doing to get the drivers it needs?

 (2) Using the 3.0 or later kernel with old userspace gives bad
     results (e.g., 30% increase in power consumption for one
     reporter).  That's a regression.  Bad kernel, no biscuit.

Ideas?

[1] http://bugs.debian.org/635348
