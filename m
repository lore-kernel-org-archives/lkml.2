Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab2BHOhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 09:37:50 -0500
Received: from smtp-cpk.frontbridge.com ([204.231.192.41]:33197 "EHLO
	WA2EHSNDR002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752953Ab2BHOht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 09:37:49 -0500
X-FB-OUTBOUND-SPAM: yes
X-SpamScore: 2
X-BigFish: VS2(zzef9Mb922lzz1202h1082kzz8275dhz2dh87h2a8h668h839h944h41h42h)
X-Forefront-Antispam-Report: CIP:94.101.220.16;KIP:(null);UIP:(null);IPV:NLI;H:nzt0014e.dknz.nzcorp.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 8 Feb 2012 15:37:41 +0100
From: Anders Ossowicki <aowi@novozymes.com>
To: <linux-kernel@vger.kernel.org>
CC: <jk@novozymes.com>
Subject: Memory issues with Opteron 6220
Message-ID: <20120208143741.GB28486@otto.nzcorp.net>
Reply-To: <aowi@novozymes.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, jk@novozymes.com
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SMTP-Mail-From: aowi@otto.nzcorp.net
X-OriginatorOrg: novozymes.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

We're seeing unexpected slowdowns and other memory issues with a new system.
Enough to render it unusable. For example:

Error: open3: fork failed: Cannot allocate memory

at times where there's no real memory pressure:
                   total       used       free     shared    buffers     cached
      Mem:     132270720  131942388     328332          0     299768  103334420
      -/+ buffers/cache:   28308200  103962520
      Swap:      7811068      13760    7797308

The simplest test we've been able to trigger the slowdowns with, is executing
'dpkg -l perl'. On our other systems, this takes a fraction of a second, at
least with a hot cache. Here it takes somewhere between two and four seconds
even when there's no load on the machine. Several other things, including our own
software is similarly slowed down by an order of magnitude or more.


The system is a Dell Poweredge R715, with two eight-core Opteron 6220
processors and 128G of memory. We have several similar systems, such as the one
this should replace: R715, 2x8 core Opteron 6140, 128G memory, and they do not
exhibit any similar symptoms.

We have tried with 2.6.37, 2.6.38, 3.2.5 and 3.3-rc1 with no luck. The
microcode updates from AMD have not helped either.


stracing dpkg -l perl yields
$ time strace -cf dpkg -l perl >/dev/null
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 95.91    0.017821        1782        10           munmap
  3.40    0.000632           1      1181           read
  0.35    0.000065           1        77        37 open
[..]
  0.00    0.000000           0         2           arch_prctl
------ ----------- ----------- --------- --------- ----------------
100.00    0.018580                  2197        49 total

real    0m4.005s
user    0m3.250s
sys     0m0.720s

It might just be a red herring though, since it doesn't account for the real
time anyway. On a functioning system the output looks like:
$ time strace -cf dpkg -l perl >/dev/null
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
100.00    0.000123           1       117           read
  0.00    0.000000           0       160           write
[..]
  0.00    0.000000           0         2           arch_prctl
------ ----------- ----------- --------- --------- ----------------
100.00    0.000123                   588        47 total

real    0m0.276s
user    0m0.160s
sys     0m0.090s


The two most obvious differences between a system that works and one that does
not, is the newer CPU and newer memory. The older machines have Samsung
M393B1K70CHD-YH9 chips (8G DDR3 1333MHz ECC REG) and new one has Samsung
M393B2G70BH0-CK0 chips (16G DDR3 1600MHz ECC REG)

/proc/cpuinfo:
processor   : 15
vendor_id   : AuthenticAMD
cpu family  : 21
model       : 1
model name  : AMD Opteron(TM) Processor 6220
stepping    : 2
microcode   : 0x6000613
cpu MHz     : 3000.048
cache size  : 2048 KB
physical id : 1
siblings    : 8
core id     : 3
cpu cores   : 4
apicid      : 39
initial apicid  : 39
fpu     : yes
fpu_exception   : yes
cpuid level : 13
wp      : yes
flags       : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm
constant_tsc rep_good nopl nonstop_tsc extd_apicid amd_dcm aperfmperf pni
pclmulqdq monitor ssse3 cx16 sse4_1 sse4_2 popcnt aes xsave avx lahf_lm
cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs
xop skinit wdt lwp fma4 nodeid_msr topoext perfctr_core arat cpb npt lbrv
svm_lock nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter
pfthreshold
bogomips    : 6000.40
TLB size    : 1536 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 48 bits physical, 48 bits virtual
power management: ts ttp tm 100mhzsteps hwpstate [9]

DMI info:
Memory Device
    Array Handle: 0x1000
    Error Information Handle: Not Provided
    Total Width: 72 bits
    Data Width: 64 bits
    Size: 16384 MB
    Form Factor: DIMM
    Set: 6
    Locator: DIMM_B4 
    Bank Locator: Not Specified
    Type: <OUT OF SPEC>
    Type Detail: Synchronous
    Speed: 1600 MHz (0.6 ns)
    Manufacturer: 80CE80B380CE
    Part Number: M393B2G70BH0-CK0

If it all seems a bit vague, it's because we're at wits end with how to debug
this issue. Consistent slowdowns and occasional failure to allocate memory for
no apparent reason is what we're seeing. Any help or suggestions is very
welcome.

dmesg is available at http://dev.exherbo.org/~arkanoid/atlas-dmesg-3.2.5.txt
-- 
Anders Ossowicki

