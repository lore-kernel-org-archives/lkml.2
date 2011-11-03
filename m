Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934187Ab1KCQzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 12:55:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934073Ab1KCQze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 12:55:34 -0400
Date: Thu, 3 Nov 2011 12:21:51 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: cpufreq pull for 3.1
Message-ID: <20111103162151.GA31657@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Temporarily at github until I get my kernel.org acct back.
(blocked waiting on signed key uploads).

git@github.com:kernelslacker/cpufreq.git/ next

 drivers/cpufreq/db8500-cpufreq.c     |   36 +++++----
 drivers/cpufreq/e_powersaver.c       |  135 +++++++++++++++++++++++++++++++---
 drivers/cpufreq/exynos4210-cpufreq.c |  129 +++++++++++++++++++++++++++++++-
 3 files changed, 268 insertions(+), 32 deletions(-)

commit 6283e328fb8148a8a5753e95c04c16aaef2287c0
Author: Linus Walleij <linus.walleij@linaro.org>
Date:   Fri Sep 2 08:52:10 2011 +0200

    [CPUFREQ] db8500: support all frequencies
    
    This adds support for the 200 MHz frequency mode of the
    DB8500 SoC, and prints the available frequencies at init
    time.
    
    Cc: Vincent Guittot <vincent.guittot@linaro.org>
    Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit ded84337ac820700f1b9dda724201e64b2ad3536
Author: Axel Lin <axel.lin@gmail.com>
Date:   Tue Sep 27 15:11:42 2011 +0800

    [CPUFREQ] db8500: remove unneeded for loop iteration over freq_table
    
    Don't know why to do the loop iteration here. It looks unneeded.
    
    Signed-off-by: Axel Lin <axel.lin@gmail.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 0073f538c1c35f996982b583f5de7a6a43408b9b
Author: MyungJoo Ham <myungjoo.ham@samsung.com>
Date:   Thu Aug 18 19:45:16 2011 +0900

    [CPUFREQ] ARM Exynos4210 PM/Suspend compatibility with different bootloaders
    
    We have various bootloaders for Exynos4210 machines. Some of they
    set the ARM core frequency at boot time even when the boot is a resume
    from suspend-to-RAM. Such changes may create inconsistency in the
    data of CPUFREQ driver and have incurred hang issues with suspend-to-RAM.
    
    This patch enables to save and restore CPU frequencies with pm-notifier and
    sets the frequency at the initial (boot-time) value so that there wouldn't
    be any inconsistency between bootloader and kernel. This patch does not
    use CPUFREQ's suspend/resume callbacks because they are syscore-ops, which
    do not allow to use mutex that is being used by regulators that are used by
    the target function.
    
    This also prevents any CPUFREQ transitions during suspend-resume context,
    which could be dangerous at noirq-context along with regulator framework.
    
    Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
    Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 8efd072b32d67436413e98e25e9a316216e88900
Author: Vincent Guittot <vincent.guittot@linaro.org>
Date:   Thu Aug 25 08:31:20 2011 +0200

    [CPUFREQ] ARM: ux500: send cpufreq notification for all cpus
    
    The same clock is used for all cpus so we must notify the frequency change
    for each one in order to update the configuration of all twd clockevents.
    
    change since V1:
    * use policy->cpus instead of cpu_online_mask
    
    Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 826e570bb24de7671be66de7a6f036c304caad1e
Author: Rafał Bilski <rafalbilski@interia.pl>
Date:   Sat Jul 23 23:35:28 2011 +0100

    [CPUFREQ] e_powersaver: Allow user to lower maximum voltage
    
    Add new module option "set_max_voltage".
    One of the lessons learned from Adaptive Powersaver is that voltage values
    returned by processor are for worst case scenario. But required voltage
    is changing with CPU temperature. And even processors produced in the same
    batch can have different minimum voltage necessary for stable work at
    specified frequency.
    On Elonex Webbook, once system starts, temperature never drops below
    48 deg. C. Loading module after systems start allows user to lower CPU
    voltage and still have stable system.
    Sadly C7 doesn't allow code to set frequency or voltage from outside limits.
    If you ask it to set voltage lower then minimum it will ignore you. Thats
    why it isn't possible to change minimum voltage for minimum frequency too.
    Changing maximum voltage on Elonex Webbook leads to very good results. Looks
    like VIA C7 1.6GHz 1084mV can safetly run at 892mV. This means 83% of
    orginal value. If same percentage applies to power generated it means 12.5W
    in the place of 15W. Not much, but it is better then nothing.
    Only C7-M makes it possible.
    If voltage is too low by 16mV or more you will experience kernel panic.
    If voltage is too low by 32mV or more you will experience system freeze.
    
    Signed-off-by: Rafał Bilski <rafalbilski@interia.pl>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 27e954c241673d2437448bd8bf0eaa7cd81a4b15
Author: Rafał Bilski <rafalbilski@interia.pl>
Date:   Thu Jul 21 22:11:29 2011 +0100

    [CPUFREQ] e_powersaver: Check BIOS limit for CPU frequency
    
    Call ACPI function to get BIOS limit for CPU frequency.
    Fail if processor would like to run at higher frequency.
    Allow user to ignore BIOS limit.
    
    eps: Detected VIA Model D C7-M
    eps: Current voltage = 1084mV
    eps: Current multiplier = 16
    eps: Highest voltage = 1084mV
    eps: Highest multiplier = 16
    eps: Lowest voltage = 844mV
    eps: Lowest multiplier = 4
    eps: ACPI limit 1.60GHz
    
    Signed-off-by: Rafał Bilski <rafalbilski@interia.pl>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit ed361bf08033f165e0a004f254919e13f07df0ae
Author: Rafał Bilski <rafalbilski@interia.pl>
Date:   Wed Jul 20 21:20:56 2011 +0100

    [CPUFREQ] e_powersaver: Additional checks
    
    Some systems are using 1,2Ghz@844mV processors running at 600MHz@796mV.
    Try to detect such systems and don't touch anything on it. If CPU doesn't have
    P-States in BIOS it should run at maximum frequency.
    Allow user to bypass checks by means of two new options.
    Don't set frequency to maximum on module unloading to avoid bada boom.
    It is also possible that some processors may have incorrect values in min/max
    registers caused by error in manufacturing process. Probably it would be BIOS
    job to set them to right frequency and P-States tables would have correct
    values inside.
    Two additional sanity checks for voltage.
    
    Signed-off-by: Rafał Bilski <rafalbilski@interia.pl>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 5beae3b9b6f5479998310a849f73aa32a637dd3b
Author: Donggeun Kim <dg77.kim@samsung.com>
Date:   Tue Jul 19 14:41:57 2011 +0900

    [CPUFREQ] exynos4210: Show list of available frequencies
    
    This patch enables 'scaling_available_frequencies' attribute
    showing list of available frequencies.
    
    Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
    Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
    Signed-off-by: KyungMin Park <kyungmin.park@samsung.com>
    Signed-off-by: Dave Jones <davej@redhat.com>
