Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab2BKXHH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 18:07:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45259 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab2BKXHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 18:07:04 -0500
Date: Sat, 11 Feb 2012 15:06:36 -0800
From: "=?UTF-8?B?dGlwLWJvdCBmb3IgRmVybmFuZG8gTHVpcyBWw6F6cXVleiBDYW8=?=" 
	<fernando@oss.ntt.co.jp>
Message-ID: <tip-9919cba7ff71147803c988521cc1ceb80e7f0f6d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rdunlap@xenotime.net, fernando@oss.ntt.co.jp, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rdunlap@xenotime.net, fernando@oss.ntt.co.jp, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <1328827342-6253-1-git-send-email-dzickus@redhat.com>
References: <1328827342-6253-1-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] watchdog: Update documentation
Git-Commit-ID: 9919cba7ff71147803c988521cc1ceb80e7f0f6d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 11 Feb 2012 15:06:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9919cba7ff71147803c988521cc1ceb80e7f0f6d
Gitweb:     http://git.kernel.org/tip/9919cba7ff71147803c988521cc1ceb80e7f0f6d
Author:     Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp>
AuthorDate: Thu, 9 Feb 2012 17:42:20 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 11 Feb 2012 15:11:28 +0100

watchdog: Update documentation

The soft and hard lockup detectors are now built on top of the
hrtimer and perf subsystems. Update the documentation
accordingly.

Signed-off-by: Fernando Luis Vazquez Cao<fernando@oss.ntt.co.jp>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Link: http://lkml.kernel.org/r/1328827342-6253-1-git-send-email-dzickus@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/lockup-watchdogs.txt |   63 +++++++++++++++++++++++++++
 Documentation/nmi_watchdog.txt     |   83 ------------------------------------
 2 files changed, 63 insertions(+), 83 deletions(-)

diff --git a/Documentation/lockup-watchdogs.txt b/Documentation/lockup-watchdogs.txt
new file mode 100644
index 0000000..d2a3660
--- /dev/null
+++ b/Documentation/lockup-watchdogs.txt
@@ -0,0 +1,63 @@
+===============================================================
+Softlockup detector and hardlockup detector (aka nmi_watchdog)
+===============================================================
+
+The Linux kernel can act as a watchdog to detect both soft and hard
+lockups.
+
+A 'softlockup' is defined as a bug that causes the kernel to loop in
+kernel mode for more than 20 seconds (see "Implementation" below for
+details), without giving other tasks a chance to run. The current
+stack trace is displayed upon detection and, by default, the system
+will stay locked up. Alternatively, the kernel can be configured to
+panic; a sysctl, "kernel.softlockup_panic", a kernel parameter,
+"softlockup_panic" (see "Documentation/kernel-parameters.txt" for
+details), and a compile option, "BOOTPARAM_HARDLOCKUP_PANIC", are
+provided for this.
+
+A 'hardlockup' is defined as a bug that causes the CPU to loop in
+kernel mode for more than 10 seconds (see "Implementation" below for
+details), without letting other interrupts have a chance to run.
+Similarly to the softlockup case, the current stack trace is displayed
+upon detection and the system will stay locked up unless the default
+behavior is changed, which can be done through a compile time knob,
+"BOOTPARAM_HARDLOCKUP_PANIC", and a kernel parameter, "nmi_watchdog"
+(see "Documentation/kernel-parameters.txt" for details).
+
+The panic option can be used in combination with panic_timeout (this
+timeout is set through the confusingly named "kernel.panic" sysctl),
+to cause the system to reboot automatically after a specified amount
+of time.
+
+=== Implementation ===
+
+The soft and hard lockup detectors are built on top of the hrtimer and
+perf subsystems, respectively. A direct consequence of this is that,
+in principle, they should work in any architecture where these
+subsystems are present.
+
+A periodic hrtimer runs to generate interrupts and kick the watchdog
+task. An NMI perf event is generated every "watchdog_thresh"
+(compile-time initialized to 10 and configurable through sysctl of the
+same name) seconds to check for hardlockups. If any CPU in the system
+does not receive any hrtimer interrupt during that time the
+'hardlockup detector' (the handler for the NMI perf event) will
+generate a kernel warning or call panic, depending on the
+configuration.
+
+The watchdog task is a high priority kernel thread that updates a
+timestamp every time it is scheduled. If that timestamp is not updated
+for 2*watchdog_thresh seconds (the softlockup threshold) the
+'softlockup detector' (coded inside the hrtimer callback function)
+will dump useful debug information to the system log, after which it
+will call panic if it was instructed to do so or resume execution of
+other kernel code.
+
+The period of the hrtimer is 2*watchdog_thresh/5, which means it has
+two or three chances to generate an interrupt before the hardlockup
+detector kicks in.
+
+As explained above, a kernel knob is provided that allows
+administrators to configure the period of the hrtimer and the perf
+event. The right value for a particular environment is a trade-off
+between fast response to lockups and detection overhead.
diff --git a/Documentation/nmi_watchdog.txt b/Documentation/nmi_watchdog.txt
deleted file mode 100644
index bf9f80a..0000000
--- a/Documentation/nmi_watchdog.txt
+++ /dev/null
@@ -1,83 +0,0 @@
-
-[NMI watchdog is available for x86 and x86-64 architectures]
-
-Is your system locking up unpredictably? No keyboard activity, just
-a frustrating complete hard lockup? Do you want to help us debugging
-such lockups? If all yes then this document is definitely for you.
-
-On many x86/x86-64 type hardware there is a feature that enables
-us to generate 'watchdog NMI interrupts'.  (NMI: Non Maskable Interrupt
-which get executed even if the system is otherwise locked up hard).
-This can be used to debug hard kernel lockups.  By executing periodic
-NMI interrupts, the kernel can monitor whether any CPU has locked up,
-and print out debugging messages if so.
-
-In order to use the NMI watchdog, you need to have APIC support in your
-kernel. For SMP kernels, APIC support gets compiled in automatically. For
-UP, enable either CONFIG_X86_UP_APIC (Processor type and features -> Local
-APIC support on uniprocessors) or CONFIG_X86_UP_IOAPIC (Processor type and
-features -> IO-APIC support on uniprocessors) in your kernel config.
-CONFIG_X86_UP_APIC is for uniprocessor machines without an IO-APIC.
-CONFIG_X86_UP_IOAPIC is for uniprocessor with an IO-APIC. [Note: certain
-kernel debugging options, such as Kernel Stack Meter or Kernel Tracer,
-may implicitly disable the NMI watchdog.]
-
-For x86-64, the needed APIC is always compiled in.
-
-Using local APIC (nmi_watchdog=2) needs the first performance register, so
-you can't use it for other purposes (such as high precision performance
-profiling.) However, at least oprofile and the perfctr driver disable the
-local APIC NMI watchdog automatically.
-
-To actually enable the NMI watchdog, use the 'nmi_watchdog=N' boot
-parameter.  Eg. the relevant lilo.conf entry:
-
-        append="nmi_watchdog=1"
-
-For SMP machines and UP machines with an IO-APIC use nmi_watchdog=1.
-For UP machines without an IO-APIC use nmi_watchdog=2, this only works
-for some processor types.  If in doubt, boot with nmi_watchdog=1 and
-check the NMI count in /proc/interrupts; if the count is zero then
-reboot with nmi_watchdog=2 and check the NMI count.  If it is still
-zero then log a problem, you probably have a processor that needs to be
-added to the nmi code.
-
-A 'lockup' is the following scenario: if any CPU in the system does not
-execute the period local timer interrupt for more than 5 seconds, then
-the NMI handler generates an oops and kills the process. This
-'controlled crash' (and the resulting kernel messages) can be used to
-debug the lockup. Thus whenever the lockup happens, wait 5 seconds and
-the oops will show up automatically. If the kernel produces no messages
-then the system has crashed so hard (eg. hardware-wise) that either it
-cannot even accept NMI interrupts, or the crash has made the kernel
-unable to print messages.
-
-Be aware that when using local APIC, the frequency of NMI interrupts
-it generates, depends on the system load. The local APIC NMI watchdog,
-lacking a better source, uses the "cycles unhalted" event. As you may
-guess it doesn't tick when the CPU is in the halted state (which happens
-when the system is idle), but if your system locks up on anything but the
-"hlt" processor instruction, the watchdog will trigger very soon as the
-"cycles unhalted" event will happen every clock tick. If it locks up on
-"hlt", then you are out of luck -- the event will not happen at all and the
-watchdog won't trigger. This is a shortcoming of the local APIC watchdog
--- unfortunately there is no "clock ticks" event that would work all the
-time. The I/O APIC watchdog is driven externally and has no such shortcoming.
-But its NMI frequency is much higher, resulting in a more significant hit
-to the overall system performance.
-
-On x86 nmi_watchdog is disabled by default so you have to enable it with
-a boot time parameter.
-
-It's possible to disable the NMI watchdog in run-time by writing "0" to
-/proc/sys/kernel/nmi_watchdog. Writing "1" to the same file will re-enable
-the NMI watchdog. Notice that you still need to use "nmi_watchdog=" parameter
-at boot time.
-
-NOTE: In kernels prior to 2.4.2-ac18 the NMI-oopser is enabled unconditionally
-on x86 SMP boxes.
-
-[ feel free to send bug reports, suggestions and patches to
-  Ingo Molnar <mingo@redhat.com> or the Linux SMP mailing
-  list at <linux-smp@vger.kernel.org> ]
-
