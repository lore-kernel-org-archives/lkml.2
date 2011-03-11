Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab1CKLrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 06:47:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33507 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab1CKLrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 06:47:03 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] cpupowerutils - cpufrequtils extended with quite some features
Date: Fri, 11 Mar 2011 12:46:59 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.37.1-1.2-desktop; KDE/4.6.0; x86_64; ; )
Cc: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        discuss@lesswatts.org, power@bughost.org, cpufreq@vger.kernel.org,
        linux@dominikbrodowski.net, Mattia Dongili <malattia@linux.it>,
        Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        herrmann.der.user@googlemail.com, linux-omap@vger.kernel.org,
        dri-devel@lists.freedesktop.org
MIME-Version: 1.0
X-Length: 5164
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103111247.00212.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

cpupowerutils is based on the well known cpufrequtils project.

Where do I find it?
-------------------

A git repository is hosted on gitorious:
git://gitorious.org/cpupowerutils/cpupowerutils.git
Be careful, it's not the default, but the cpupowerutils branch!

You can also directly download a tarball of the cpupowerutils branch:
wget http://gitorious.org/cpupowerutils/cpupowerutils/archive-
tarball/cpupowerutils cpupowerutils.tar.gz

How to make it run
------------------

You need the pcitutils package (or whatever provides libpci) at runtime
and pcitutils-devel package (or whatever provides /usr/include/pci/pci.h)
at compile time.
Also a gcc version that provides cpuid.h is needed, but it's in there for
some time already afaik.

Don't forget to use the right branch if you use the git repo:
git branch --track cpupowerutils origin/cpupowerutils
git checkout cpupowerutils

make
# There is nothing for choosing lib vs lib64, default is
# /usr/lib,therefore you might need:
libdir=/usr/lib64 make install-lib
ldconfig
./cpupower

There is one known compile warning in get_cpu_topology, it's
on the ToDo list.

Why is there need for another tool?
-----------------------------------

CPU power consumption vs performance tuning is not about
CPU frequency switching anymore for quite some time.
Deep sleep states, traditional dynamic frequency scaling and
hidden turbo/boost frequencies are tight close together and
depend on each other. The first two exist on different architectures
like PPC, Itanium and ARM the latter only on X86.
On X86 the APU (CPU+GPU) will only run most efficiently if CPU
and GPU has proper power management in place.

Users and Developers want to have *one* tool to get an overview what their 
system supports and to monitor and debug CPU power management in detail.

The tool should compile and work on as much architectures as
possible.

What is this tool doing?
------------------------

It provides all features cpufrequtils does.
It got enhanced with cpuidle and turbo/boost mode (on X86) statistics.
On AMD the exact amount of supported boost states and their frequencies
are shown. On Intel only turbo/boost support is shown.

It got enhanced with a generic HW monitor tool (cpupower monitor).

The generic HW monitor tool is the most powerful enhancement.
It is a framework to monitor kernel or HW power statistics.
It's easy to extend with additional, architecture or processor model
specific counters.
It's based on turbostat which got merged into the kernel recently:
tools/power/x86/turbostat

In fact turbostat functionality is integrated as three separate monitors
implementing the cpupower monitor API:
  - Nehalem
  - SandyBridge
  - Mperf
While Nehalem and SandyBridge HW sleep counters are Intel specific, the
mperf functionality is now available on other HW than Intel, supporting 
the
needed registers (Functionality includes: average frequency including
turbo/boost frequency, C0 vs Cx idle count).

Additionally there is a monitor to collect kernel idle statistics and 
display them (separate or together) in the same format. This works on all 
architectures using the cpuidle kernel framework including different ARM
architectures and there were patches for powerpc (not in the mainline
kernel yet).
This allows to compare kernel and HW statistics on specific workloads and
figure out how the HW performs compared to OS behavior.

Additionally there is an AMD Liano (fam 12h) and Ontario (fam 14h) family 
specific monitor. This one shows different Package Core (!PC0, PC1, PC7)
sleep state statistics directly read out from HW, similar to Nehalem
and SandyBridge coutners.
The registers are accessed via PCI and therefore can still be read out 
while cores have been offlined.
The Liano/Ontario monitor has one special counter: NBP1 (North Bridge P1).
This one always returns 0 or 1, depending on whether the North Bridge P1
power state got entered at least once during measure time.
Being able to enter NBP1 state also depends on graphics power management.
Therefore this counter can be used to verify whether the graphics' driver
power management is working as expected. (E.g. this counter proves that
radeon KMS graphics drivers are missing functionality and NBP1 will only
be entered when using the fglrx driver).


Some examples
-------------

On a somewhat older Intel machine where turbostat complaints about:
/archteam/trenn/packages/turbostat/turbostat
No invariant TSC

You still get mperf statistics (here core 1 is 100% utilized):
/archteam/trenn/git/latest_cpupowerutils/cpufrequtils/cpupower monitor 
    |Mperf               || Idle_Stats                
CPU | C0   | Cx   | Freq || POLL | C1   | C2   | C3   
   0|  3.71| 96.29|  2833||  0.00|  0.00|  0.02| 96.32
   1| 100.0| -0.00|  2833||  0.00|  0.00|  0.00|  0.00
   2|  9.06| 90.94|  1983||  0.00|  7.69|  6.98| 76.45
   3|  7.43| 92.57|  2039||  0.00|  2.60| 12.62| 77.52

Hm, mperf (C0 vs Cx) implementation also depends on a correct working
TSC, but shows sane values on this machine. But it can be implemented
in another way using gettimeofday and not tsc as well.

For above machine, listing available monitors/counters via:
"cpupower monitor -l" shows:

Monitor "Mperf" (3 states) - Might overflow after 922000000 s
C0      [T] -> Processor Core not idle
Cx      [T] -> Processor Core in an idle state
Freq    [T] -> Average Frequency (including boost) in MHz
Monitor "Idle_Stats" (3 states) - Might overflow after 4294967295 s
POLL    [T] -> CPUIDLE CORE POLL IDLE
C1      [T] -> ACPI FFH INTEL MWAIT 0x0
C2      [T] -> ACPI FFH INTEL MWAIT 0x10
C3      [T] -> ACPI FFH INTEL MWAIT 0x30

On a Tylersburg/Nehalem you get an additional one:
Monitor "Nehalem" (4 states) - Might overflow after 922000000 s
C3      [C] -> Processor Core C3
C6      [C] -> Processor Core C6
PC3     [P] -> Processor Package C3
PC6     [P] -> Processor Package C6

On a SandyBridge you have yet another monitor:
Monitor "SandyBridge" (3 states) - Might overflow after 922000000 s
C7      [C] -> Processor Core C7
PC2     [P] -> Processor Package C2
PC7     [P] -> Processor Package C7

If output is too much or you only want to compare specific stats,
use:
./cpupower monitor -m "SandyBridge,Mperf"
and only SandyBridge and Mperf counters are shown in the order you
pass them.

On an AMD (at least latest fam10h with mperf/boost support) one
would of course not get the Nehalem or SandyBridge, but
still the Mperf counters. 

Additionlly on Ontario (fam 14h) or Liano (fam 12h) you get some
AMD specific sleep state residency HW counters:

Monitor "Ontario" (4 states) - Might overflow after 343 s
!PC0    [P] -> Package in sleep state (PC1 or deeper)
PC1     [P] -> Processor Package C1
PC6     [P] -> Processor Package C6
NBP1    [P] -> North Bridge P1 boolean counter (returns 0 or 1)


Kernel Idle_Stats counter is the only one also working without root
privileges and is architecture independent (should provide info on quite
some ARM models and possibly soon on powerpc as well if cpuidle support
is implemented in the kernel there):

./cpupower monitor
Available monitor Mperf needs root access
    |Idle_Stats                 
CPU | POLL | C1   | C2   | C3   
   0|  0.00|  0.00|  3.20| 89.86
   1|  0.00|  0.00|  2.27| 82.62
   2|  0.00|  0.00| 23.44| 68.78
   3|  0.00| 15.38|  9.34| 65.31

If you want to monitor specific workload the turbostat feature to
measure specific commands is available as well:

./cpupower monitor cp xorg-x11-driver-video-7.6-163.1.x86_64.rpm /tmp/
cp took 0.23406 seconds and exited with status 0
    |Ontario                    || Mperf              || Idle_Stats         
CPU | !PC0 | PC1  | PC6  | NBP1 || C0   | Cx   | Freq || POLL | C1   | C2   
   0| 72.38|  1.47| 19.39|     0|| 21.16| 78.84|   800||  0.00| 90.59|  
0.00
   1| 72.38|  1.47| 19.39|     0||  2.91| 97.09|  1184||  0.00| 97.42|  
0.00

This output reveals quite some kernel bugs:
- C2 is not entered -> dma_latency set too high by ath9k -> fixed already
                    -> But microcode still insures deep sleep states are
                       entered. Using C2 should be more efficient, though.
                       That can get proofed with some more measures...

- NorthBridge P1 not entered -> Kernel radeon driver missing some PM.
                             -> fglrx would show 1 here.
- Frequency of the wrong core is switched up?
       -> Just realized that, might be related to:
          http://comments.gmane.org/gmane.linux.kernel.cpufreq/6977
          Hm, it's not always reproducable, anyway the tool works...


What next?
----------

Happy testing..., if you have a recent machine, you'll like it!

After some testing phase it would be great to get this tool
merged into the kernel git repo under:
tools/power/cpupower
and replace the Intel HW only supporting tools in tools/power/x86.

Thanks,

   Thomas
