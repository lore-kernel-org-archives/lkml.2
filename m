Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab1GYCRW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 22:17:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab1GYCRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 22:17:20 -0400
Date: Sun, 24 Jul 2011 22:17:01 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: cpufreq 3.1 pull.
Message-ID: <20110725021701.GA8347@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from ..
master.kernel.org:/pub/scm/linux/kernel/git/davej/cpufreq.git/ next

 arch/arm/Kconfig                                   |    4 -
 arch/arm/mach-exynos4/Makefile                     |    1 -
 arch/arm/mach-s3c64xx/Makefile                     |    4 -
 arch/arm/mach-s5pv210/Makefile                     |    1 -
 drivers/cpufreq/Kconfig                            |    5 +
 drivers/cpufreq/Kconfig.arm                        |   32 +++
 drivers/cpufreq/Makefile                           |    8 +-
 drivers/cpufreq/acpi-cpufreq.c                     |    2 +-
 .../cpufreq/exynos4210-cpufreq.c                   |    9 +-
 .../cpufreq.c => drivers/cpufreq/s3c64xx-cpufreq.c |   11 +-
 .../cpufreq.c => drivers/cpufreq/s5pv210-cpufreq.c |  210 +++++++++++++++++---
 11 files changed, 241 insertions(+), 46 deletions(-)
 create mode 100644 drivers/cpufreq/Kconfig.arm
 rename arch/arm/mach-exynos4/cpufreq.c => drivers/cpufreq/exynos4210-cpufreq.c (98%)
 rename arch/arm/mach-s3c64xx/cpufreq.c => drivers/cpufreq/s3c64xx-cpufreq.c (98%)
 rename arch/arm/mach-s5pv210/cpufreq.c => drivers/cpufreq/s5pv210-cpufreq.c (73%)

commit 133de1211982bd2ba9ab401f7a73d25d052ccd61
Author: Axel Lin <axel.lin@gmail.com>
Date:   Fri Jul 8 14:24:36 2011 +0800

    [CPUFREQ] s5pv210: make needlessly global symbols static
    
    The following symbols are needlessly defined global:
      s5pv210_verify_speed
      s5pv210_getspeed
    
    Make them static.
    
    Signed-off-by: Axel Lin <axel.lin@gmail.com>
    Acked-by: Kukjin Kim <kgene.kim@samsung.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 2f0d6f20ec4cc157ba092e008ed20a99590142c4
Author: Axel Lin <axel.lin@gmail.com>
Date:   Fri Jul 8 14:20:44 2011 +0800

    [CPUFREQ] exynos4210: make needlessly global symbols static
    
    The following symbols are needlessly defined global:
      exynos4_verify_speed
      exynos4_getspeed
      exynos4_set_clkdiv
    
    Make them static.
    
    Signed-off-by: Axel Lin <axel.lin@gmail.com>
    Acked-by: Kukjin Kim <kgene.kim@samsung.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit ef993ef8dcd4f3e4d058400c5bd2f7c547344e74
Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
Date:   Tue Jun 28 20:26:49 2011 -0700

    [CPUFREQ] S3C6410: Add some lower frequencies for 800MHz base clock operation
    
    By extension from the 667MHz based clocks currently supported add 100MHz
    and 200MHz operating points. Due to a lack of documentation these have not
    been confirmed as supported but by extension from the existing frequencies
    they should be OK, and I've given them quite a bit of runtime testing.
    
    The major risk is synchronization with the non-ARM clocks but as we
    can't currently scale the ARM PLL the risk should be relatively low.
    
    Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
    Acked-by: Kukjin Kim <kgene.kim@samsung.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit fe7f1bcbff917f22e121d4b2c045fb1de80cc450
Author: Huisung Kang <hs1218.kang@samsung.com>
Date:   Fri Jun 24 16:04:18 2011 +0900

    [CPUFREQ] S5PV210: Add reboot notifier to prevent system hang
    
    When system reboot, the CPUFREQ level should be 800MHz to prevent
    system lockup.
    
    Signed-off-by: Huisung Kang <hs1218.kang@samsung.com>
    Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
    Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 74df8e69e901e624fe0b439f914aa7be66201154
Author: Todd Poynor <toddpoynor@google.com>
Date:   Fri Jun 24 16:04:17 2011 +0900

    [CPUFREQ] S5PV210: Adjust udelay prior to voltage scaling down
    
    Voltage scaling accesses the MAX8998 regulators over bit-banged I2C
    with lots of udelays.  In the case of decreasing CPU speed, the
    number of loops per us for udelay needs to be adjusted prior to
    decreasing voltage to avoid delaying for up to 10X too long.
    
    Signed-off-by: Todd Poynor <toddpoynor@google.com>
    Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
    Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 5b02b7794b555e299c5e9298c6b223b538888ec8
Author: Arve Hjønnevåg <arve@android.com>
Date:   Fri Jun 24 16:04:16 2011 +0900

    [CPUFREQ] S5PV210: Lock a mutex while changing the cpu frequency
    
    Without this lock the call to change the frequency for suspend could
    switch to a new frequency while another thread was still changing the
    cpu voltage.
    
    Signed-off-by: Arve Hjønnevåg <arve@android.com>
    Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
    Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 405e6d6df739a27a267b381213aa9e86c4929543
Author: Huisung Kang <hs1218.kang@samsung.com>
Date:   Fri Jun 24 16:04:15 2011 +0900

    [CPUFREQ] S5PV210: Add pm_notifier to prevent system unstable
    
    Minimum 800MHz is needed to enter/exit suspend mode due to voltage mismatch.
    
    Signed-off-by: Huisung Kang <hs1218.kang@samsung.com>
    Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
    Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit e8b4c1986efbb5b1e1bab9f359c340816e4d9869
Author: Jonghwan Choi <jhbird.choi@samsung.com>
Date:   Fri Jun 24 16:04:14 2011 +0900

    [CPUFREQ] S5PV210: Add arm/int voltage control support
    
    Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
    Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 90d5d0a119bcf189e8b33f776b4f8371b789b311
Author: Huisung Kang <hs1218.kang@samsung.com>
Date:   Fri Jun 24 16:04:13 2011 +0900

    [CPUFREQ] S5PV210: Add additional symantics for "relation" in cpufreq with pm
    
    Relation has an additional symantics other than standard.
    s5pv310_target funtion have below additional relation.
    - DISABLE_FURTHER_CPUFREQ : disable further access to target
    - ENABLE_FURTHER_CPUFRER : enable access to target
    
    Signed-off-by: Huisung Kang <hs1218.kang@samsung.com>
    Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
    Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit fb3b1fefaaccdbdc716db0963ba41fb6b4221e60
Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
Date:   Wed Jun 22 15:08:56 2011 +0100

    [CPUFREQ] S3C64xx: Notify transition complete as soon as frequency changed
    
    The CPUFREQ_POSTCHANGE notification is used to update things that depend on
    the system clock rates. Since this may include the interfaces used to talk
    to the regulators do the notification before we try to update regulators
    to reflect lowered system clock rate.
    
    The voltage scaling is just a power optimisation and may not happen at all
    so there's no concern about it not having completed.
    
    Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
    Acked-by: Kukjin Kim <kgene.kim@samsung.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit c6e2d68558b612fdfdb0d7ddcb51ad4578b81eba
Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
Date:   Wed Jun 8 14:49:15 2011 +0100

    [CPUFREQ] S3C6410: Support 800MHz operation in cpufreq
    
    At least some newer S3C6410 silicon supports operation up to 800MHz rather
    than just 667MHz. Unfortunately I don't have access to any of documentation
    of this other than some running systems, add a new cpufreq table entry for
    this based on the behaviour of those systems.
    
    Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
    Acked-by: Kukjin Kim <kgene.kim@samsung.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 4911ca1031c2ade225fdf22cc872bc121c2c2ec5
Author: Julia Lawall <julia@diku.dk>
Date:   Mon Jun 6 18:59:02 2011 -0700

    [CPUFREQ] s5pv210-cpufreq.c: Add missing clk_put
    
    The successive calls to clk_get each call clk_put in the case of failure,
    but this is not done for subsequent error handling code.  The calls to
    clk_get are moved to the end of the function, and appropriate gotos are
    added.
    
    A simplified version of the semantic match that finds this problem is as
    follows: (http://coccinelle.lip6.fr/)
    
    // <smpl>
    @r exists@
    expression e1,e2;
    statement S;
    @@
    
    e1 = clk_get@p1(...);
    ... when != e1 = e2
        when != clk_put(e1)
        when any
    if (...) { ... when != clk_put(e1)
                   when != if (...) { ... clk_put(e1) ... }
    * return@p3 ...;
     } else S
    // </smpl>
    
    Signed-off-by: Julia Lawall <julia@diku.dk>
    Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 15964d388528c1dbb672027c8003fe7e81630a35
Author: Kukjin Kim <kgene.kim@samsung.com>
Date:   Mon Jun 6 18:43:01 2011 -0700

    [CPUFREQ] Move compile for S3C64XX cpufreq to /drivers/cpufreq
    
    Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
    Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 069283c3ec87e0abaa14f6bef96342b609f0fb92
Author: Dave Jones <davej@kernel.org>
Date:   Mon Jun 6 21:10:04 2011 -0400

    [CPUFREQ] Remove some vi noise that escaped into the Makefile.

commit f7d770790f29781116d0de1339214934b8020c1e
Author: Kukjin Kim <kgene.kim@samsung.com>
Date:   Wed Jun 1 14:18:22 2011 -0700

    [CPUFREQ] Move ARM Samsung cpufreq drivers to drivers/cpufreq/
    
    According to discussion of the ARM arch subsystem migration,
    ARM cpufreq drivers move to drivers/cpufreq. So this patch
    adds Kconfig.arm for ARM like x86 and adds Samsung S5PV210
    and EXYNOS4210 cpufreq driver compile in there.
    As a note, otherw will be moved.
    
    Cc: Dave Jones <davej@redhat.com>
    Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit be2de99beaca6506a1f97a636750c108a41b5c00
Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
Date:   Tue May 10 15:42:08 2011 +0200

    [CPUFREQ/S3C64xx] Move S3C64xx CPUfreq driver into drivers/cpufreq
    
    This is a straight code motion patch, there are no changes to the driver
    itself. The Kconfig is left untouched as the ARM CPUfreq Kconfig is all
    in one big block in arm/Kconfig and should be moved en masse rather than
    being done piecemeal.
    
    Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 92e03c41a415e8e9e8009a1f5bbb9036f3bfb2f4
Author: Matthew Garrett <mjg@redhat.com>
Date:   Wed Jul 13 17:58:32 2011 -0400

    [CPUFREQ] Handle CPUs with different capabilities in acpi-cpufreq
    
    acpi-cpufreq checks each CPU for aperf/mperf support, but only sets a
    global flag. This will cause errors if some CPUs in the system don't
    support the feature. Check boot_cpu_has() instead in order to make sure
    that all CPUs support it.
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Dave Jones <davej@redhat.com>
