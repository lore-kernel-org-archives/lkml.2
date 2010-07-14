Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893Ab0GNUjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:39:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57336 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757419Ab0GNUjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:39:36 -0400
Message-ID: <4C3E1FA0.9000107@kernel.org>
Date: Wed, 14 Jul 2010 13:35:44 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: tip/master broken with x2apic and kexec
References: <4C3BD6AA.3070908@kernel.org> <4C3CE210.2030902@zytor.com> <4C3CF650.30905@kernel.org>
In-Reply-To: <4C3CF650.30905@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4C3E206D.01EF,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 04:27 PM, Yinghai Lu wrote:
> On 07/13/2010 03:00 PM, H. Peter Anvin wrote:
>> On 07/12/2010 07:59 PM, Yinghai Lu wrote:
>>> tip/master: 
>>> system1: BIOS enabled x2apic, first kernel boot well, and when kexec second kernel will cause system instant reboot.
>>>
>>> system2: BIOS not enable x2apic, first kernel boot well and enable x2apic, and kexec second kernel well. but when kexec third kernel will case system instant reboot.
>>>
>>> linus' tree is ok.
>>>
>>> but for system2 if boot with nox2apic ,intr-remaping off, iommu off, the kexec loop test will pass.
>>>
>>> the problem looks start in recent two or three weeks.
>>>
>>> Any idea?
>>>
>>> bisecting will take a while, because the system post take a while everytime.
>>>
>>> Thanks
>>>
>>> Yinghai Lu
>>
>> OK, I found the bug... if you could test out the patch which will be
>> sent out shortly I would very much appreciate it.
> 
> not sure if your patch is the offending one now.
> 
> kL: kernel from linus tree
> kT1: kernel from tip
> kT2: kernel from tip with reverting your patch
> 
> BIOS-->kL ---> kL ---> kL....always working
> BIOS-->kT1 ---> kT1 --->  kT1 : between second one and third one system reset instant...
> BIOS-->kT2 ---> kT2 --->  kT2 : between second one and third one system reset instant...
> 
> BIOS-->kL ---> kL ---> kL ---> then kT1 ---> kT1 .... always working
> BIOS-->kL ---> kL ---> kL ---> then kT2 ---> kT2 .... always working
> 

bisecting said:

> git bisect good
58687acba59266735adb8ccd9b5b9aa2c7cd205b is the first bad commit
commit 58687acba59266735adb8ccd9b5b9aa2c7cd205b
Author: Don Zickus <dzickus@redhat.com>
Date:   Fri May 7 17:11:44 2010 -0400

    lockup_detector: Combine nmi_watchdog and softlockup detector
    
    The new nmi_watchdog (which uses the perf event subsystem) is very
    similar in structure to the softlockup detector.  Using Ingo's
    suggestion, I combined the two functionalities into one file:
    kernel/watchdog.c.
    
    Now both the nmi_watchdog (or hardlockup detector) and softlockup
    detector sit on top of the perf event subsystem, which is run every
    60 seconds or so to see if there are any lockups.
    
    To detect hardlockups, cpus not responding to interrupts, I
    implemented an hrtimer that runs 5 times for every perf event
    overflow event.  If that stops counting on a cpu, then the cpu is
    most likely in trouble.
    
    To detect softlockups, tasks not yielding to the scheduler, I used the
    previous kthread idea that now gets kicked every time the hrtimer fires.
    If the kthread isn't being scheduled neither is anyone else and the
    warning is printed to the console.
    
    I tested this on x86_64 and both the softlockup and hardlockup paths
    work.
    
    V2:
    - cleaned up the Kconfig and softlockup combination
    - surrounded hardlockup cases with #ifdef CONFIG_PERF_EVENTS_NMI
    - seperated out the softlockup case from perf event subsystem
    - re-arranged the enabling/disabling nmi watchdog from proc space
    - added cpumasks for hardlockup failure cases
    - removed fallback to soft events if no PMU exists for hard events
    
    V3:
    - comment cleanups
    - drop support for older softlockup code
    - per_cpu cleanups
    - completely remove software clock base hardlockup detector
    - use per_cpu masking on hard/soft lockup detection
    - #ifdef cleanups
    - rename config option NMI_WATCHDOG to LOCKUP_DETECTOR
    - documentation additions
    
    V4:
    - documentation fixes
    - convert per_cpu to __get_cpu_var
    - powerpc compile fixes
    
    V5:
    - split apart warn flags for hard and soft lockups
    
    TODO:
    - figure out how to make an arch-agnostic clock2cycles call
      (if possible) to feed into perf events as a sample period
    
    [fweisbec: merged conflict patch]
    
    Signed-off-by: Don Zickus <dzickus@redhat.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Cyrill Gorcunov <gorcunov@gmail.com>
    Cc: Eric Paris <eparis@redhat.com>
    Cc: Randy Dunlap <randy.dunlap@oracle.com>
    LKML-Reference: <1273266711-18706-2-git-send-email-dzickus@redhat.com>
    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

:040000 040000 c99baa531fdcc45b1cc4d2d3257c9a848067961b 637cfd2034d694e3fdcb0eb0b52b705d71b5078a M    Documentation
:040000 040000 0844d6f54293ec10af53a1d5ff64053dc9585a02 acb13a89b3f58130ef9677160e73b7121095da84 M    arch
:040000 040000 9b7508dba6d0a76cbec9d6c7ed82820e8c4f2a97 8016330e23998f9dfdce2512556e8a795d66aa55 M    include
:040000 040000 e6ec48f3f0314aff9a6a46706772ccd26d901830 ad70b3b8d21c8114096c8a5675393f1ab11457f5 M    init
:040000 040000 a4456db9fbda918e06e68e573f18b51f388182db ace18da3199572a1fbc2c0800a2d65f22050ff8c M    kernel
:040000 040000 120bb994855546e2e0003e54e3a382663994c00d 0e7721b41acd86ecae6ddf3c2aa6b836543aacb3 M    lib


> git bisect log
git bisect start
# bad: [6058b92b74c529f7234b92492bf634f52707a8c0] Merge branch 'x86/setup'
git bisect bad 6058b92b74c529f7234b92492bf634f52707a8c0
# good: [1c5474a65bf15a4cb162dfff86d6d0b5a08a740c] Linux 2.6.35-rc5
git bisect good 1c5474a65bf15a4cb162dfff86d6d0b5a08a740c
# good: [f12813390bebee04bbd0a070592ce57648805493] Merge branch 'tracing/urgent'
git bisect good f12813390bebee04bbd0a070592ce57648805493
# bad: [e8eb3808c6bd8d78895f6b61d4a36d8346818aad] Merge branch 'x86/urgent'
git bisect bad e8eb3808c6bd8d78895f6b61d4a36d8346818aad
# good: [bb8beea5d4df37ccfb0359329dc0053a82f38501] Merge branch 'linus'
git bisect good bb8beea5d4df37ccfb0359329dc0053a82f38501
# bad: [24e5c8ccb4d187c7a05cb77c3ac004581ad16f26] Merge branch 'linus'
git bisect bad 24e5c8ccb4d187c7a05cb77c3ac004581ad16f26
# bad: [fbde9fccc1a9da261f9f786338af10edbbfb7eb8] Merge branch 'irq/core'
git bisect bad fbde9fccc1a9da261f9f786338af10edbbfb7eb8
# good: [a9a58f907d8650db1c650688cddbecfe481f91d7] Merge branch 'perf/core'
git bisect good a9a58f907d8650db1c650688cddbecfe481f91d7
# bad: [89d7ce2a2178e7f562f608b466a18c8c2ece87af] lockup_detector: Make BOOTPARAM_SOFTLOCKUP_PANIC depend on LOCKUP_DETECTOR
git bisect bad 89d7ce2a2178e7f562f608b466a18c8c2ece87af
# bad: [2508ce1845a3b256798532b2c6b7997c2dc6533b] lockup_detector: Remove old softlockup code
git bisect bad 2508ce1845a3b256798532b2c6b7997c2dc6533b
# bad: [58687acba59266735adb8ccd9b5b9aa2c7cd205b] lockup_detector: Combine nmi_watchdog and softlockup detector
git bisect bad 58687acba59266735adb8ccd9b5b9aa2c7cd205b
# good: [a9aa1d02de36b450990b0e25a88fc2ff1c3e6b94] Merge commit 'v2.6.34-rc7' into perf/nmi
git bisect good a9aa1d02de36b450990b0e25a88fc2ff1c3e6b94





