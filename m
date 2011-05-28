Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab1E1DxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 23:53:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35212 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362Ab1E1DxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 23:53:15 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=zZD41cM2pQYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=aj8sFHz-Cv_FPs0x1RkA:9 a=44NLxs_vqMu2v950gjAA:7 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [GIT PULL] x86: Put back -pg to tsc.o and add no GCOV to
 vread_tsc_64.o
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@MIT.EDU>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 27 May 2011 23:53:13 -0400
Message-ID: <1306554793.11899.9.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

While running ktest randconfig tests on latest Linus's tree, I hit a
case where the function graph tracer caused a nasty crash, or even a
reboot. Using the ktest git bisect utility, I quickly found that the
crash was due to the commit:

  44259b1a x86-64: Move vread_tsc into a new file with sensible options

I found that it removed the -pg from tsc.o causing accesses to tsc to be
traced. The function graph tracer uses the tsc outside its recursive
protection and this caused the crash.

But this was not the only bug. As I had 3 different configs that crashed
in my randconfig tests, I tested all three. The first two ran fine with
the update of the tsc.o with the -pg option, but the third config failed
with the init process taking a segfault in the vread_tsc function.

That same patch added the vread_tsc_64.o but did not disable GCOV from
it. Thomas noticed that GCOV was set in that config and after disabling
GCOV, the strange accesses to kernel space in that function went away.

This patch adds back the -pg and protects vread_tsc_64.o from GCOV.

Note, this is based on latest Linus and not tip's perf/urgent branch
because the bug does not exist in the tip branch.


Please pull the latest tip/perf/urgent-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent-2


Steven Rostedt (1):
      x86: Put back -pg to tsc.o and add no GCOV to vread_tsc_64.o

----
 arch/x86/kernel/Makefile |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)
---------------------------
commit 89e1be50c68eb5e58b873dce87bbac627ee18d1f
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Fri May 27 23:11:24 2011 -0400

    x86: Put back -pg to tsc.o and add no GCOV to vread_tsc_64.o
    
    The commit 44259b1abfaa8bb819d25d41d71e8e33e25dd36a
        Author: Andy Lutomirski <luto@MIT.EDU>
        x86-64: Move vread_tsc into a new file with sensible options
    
    Removed the -pg from tsc.o which caused the function graph tracer
    to go into an infinite function call recursion as it uses the tsc
    internally outside its recursion protection, thus tracing the tsc
    breaks the function graph tracer.
    
    This commit also added the file vread_tsc_64.c that gets used
    by vdso but failed to prevent GCOV from monkeying with it,
    causing userspace to try to access kernel data when GCOV was
    enabled.
    
    Thanks to Thomas Gleixner for pointing out GCOV as the likely
    culprit that added strange kernel accesses into the vread_tsc()
    call.
    
    Cc: Author: Andy Lutomirski <luto@MIT.EDU>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index f5abe3a..90b06d4 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -8,6 +8,7 @@ CPPFLAGS_vmlinux.lds += -U$(UTS_MACHINE)
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not profile debug and lowlevel utilities
+CFLAGS_REMOVE_tsc.o = -pg
 CFLAGS_REMOVE_rtc.o = -pg
 CFLAGS_REMOVE_paravirt-spinlocks.o = -pg
 CFLAGS_REMOVE_pvclock.o = -pg
@@ -28,6 +29,7 @@ CFLAGS_paravirt.o	:= $(nostackp)
 GCOV_PROFILE_vsyscall_64.o	:= n
 GCOV_PROFILE_hpet.o		:= n
 GCOV_PROFILE_tsc.o		:= n
+GCOV_PROFILE_vread_tsc_64.o	:= n
 GCOV_PROFILE_paravirt.o		:= n
 
 # vread_tsc_64 is hot and should be fully optimized:


