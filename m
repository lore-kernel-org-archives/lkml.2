Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab2LRJmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 04:42:06 -0500
Received: from www84.your-server.de ([213.133.104.84]:50077 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab2LRJmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 04:42:04 -0500
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, ak@linux.intel.com,
        aarcange@redhat.com, john.stultz@linaro.org, luto@amacapital.net,
        xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: stefani@seibold.net
Subject: [PATCH 0/6] Add 32 bit VDSO time function support
Date: Tue, 18 Dec 2012 10:40:50 +0100
Message-Id: <1355823656-13902-1-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.8.0
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

This patch add the functions vdso_gettimeofday(), vdso_clock_gettime()
and vdso_time() to the 32 bit VDSO.

The reason to do this was to get a fast reliable time stamp. Many developers
uses TSC to get a fast time time stamp, without knowing the pitfalls. VDSO
time functions a fast and reliable way, because the kernel knows the
best time source and the P- and C-state of the CPU.

The helper library to use the VDSO functions can be download at
http://http://seibold.net/vdso.c
The libary is very small, only 228 lines of code. Compile it with
gcc -Wall -O3 -fpic vdso.c -lrt -shared -o libvdso.so
and use it with LD_PRELOAD=<path>/libvdso.so

This kind of helper must be integrated into glibc, for x86 64 bit and
PowerPC it is already there.

Some benchmark linux 32 bit results (all measurements are in nano seconds):

Intel(R) Celeron(TM) CPU 400MHz

Average time kernel call:
 gettimeofday(): 1039
 clock_gettime(): 1578
 time(): 526
Average time VDSO call:
 gettimeofday(): 378
 clock_gettime(): 303
 time(): 60

Celeron(R) Dual-Core CPU T3100 1.90GHz

Average time kernel call:
 gettimeofday(): 209
 clock_gettime(): 406
 time(): 135
Average time VDSO call:
 gettimeofday(): 51
 clock_gettime(): 43
 time(): 10

So you can see a performance increase between 4 and 13, depending on the
CPU and the function.

The patch is against kernel 3.7. Please apply if you like it.

Changelog:
25.11.2012 - first release and proof of concept for linux 3.4
11.12.2012 - Port to linux 3.7 and code cleanup
12.12.2012 - fixes suggested by Andy Lutomirski
           - fixes suggested by John Stultz
           - use call VDSO32_vsyscall instead of int 80
           - code cleanup
17.12.2012 - support for IA32_EMULATION, this includes
             - code cleanup
             - include cleanup to fix compile warnings and errors
	     - move out seqcount from seqlock, enable use in VDSO
	     - map FIXMAP and HPET into the 32 bit address space
18.12.2012 - split into separate patches
