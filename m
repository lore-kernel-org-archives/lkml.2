Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab0CTO0p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 10:26:45 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:54075 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab0CTO0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 10:26:42 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Date: Sat, 20 Mar 2010 19:56:38 +0530
Message-Id: <20100320142638.11427.49335.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>
References: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v1 9/10] Uprobes Documentation patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uprobes documentation.

Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 Documentation/uprobes.txt |  244 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 244 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/uprobes.txt


diff --git a/Documentation/uprobes.txt b/Documentation/uprobes.txt
new file mode 100644
index 0000000..08bbf24
--- /dev/null
+++ b/Documentation/uprobes.txt
@@ -0,0 +1,244 @@
+Title	: User-Space Probes (Uprobes)
+Authors	: Jim Keniston <jkenisto@us.ibm.com>
+	: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
+
+CONTENTS
+
+1. Concepts: Uprobes
+2. Architectures Supported
+3. Configuring Uprobes
+4. API Reference
+5. Uprobes Features and Limitations
+6. Probe Overhead
+7. TODO
+8. Uprobes Team
+9. Uprobes Example
+
+1. Concepts: Uprobes
+
+Uprobes enables you to dynamically break into any routine in a
+user application and collect debugging and performance information
+non-disruptively. You can trap at any code address, specifying a
+kernel handler routine to be invoked when the breakpoint is hit.
+
+A uprobe can be inserted on any instruction in the application's
+virtual address space.  The registration function register_uprobe()
+specifies which process is to be probed, where the probe is to be
+inserted, and what handler is to be called when the probe is hit.
+
+Uprobes-based instrumentation can be packaged as a kernel
+module.  In the simplest case, the module's init function installs
+("registers") one or more probes, and the exit function unregisters
+them.
+
+1.1 How Does a Uprobe Work?
+
+When a uprobe is registered, Uprobes makes a copy of the probed
+instruction, stops the probed application, replaces the first byte(s)
+of the probed instruction with a breakpoint instruction (e.g., int3
+on i386 and x86_64), and allows the probed application to continue.
+(When inserting the breakpoint, Uprobes uses background page
+replacement mechanism, so that the breakpoint affects only that
+process, and not any other process running that program.  This is
+true even if the probed instruction is in a shared library.)
+
+When a CPU hits the breakpoint instruction, a trap occurs, the CPU's
+user-mode registers are saved, and uprobes notifier code finds the
+associated uprobe.  It then executes the handler associated with the
+uprobe, passing the handler the addresses of the uprobe struct and the
+saved registers. The handler can run either in interrupt context or in
+task context; this specified by the user at the time of registration.
+When run in task context, the handler may block, but keep in mind that
+the probed thread remains stopped while your handler runs.
+
+Next, Uprobes single-steps its copy of the probed instruction and
+resumes execution of the probed process at the instruction following
+the probepoint.  (It would be simpler to single-step the actual
+instruction in place, but then Uprobes would have to temporarily
+remove the breakpoint instruction.  This would create problems in a
+multithreaded application.  For example, it would open a time window
+when another thread could sail right past the probepoint.)
+
+Instruction copies to be single-stepped are stored in a per-process
+"execution out of line (XOL) area," which is a little VM area
+created by Uprobes in each probed process's address space.
+
+Uprobes handles interesting events in the lifetime of the probed
+process, such as fork, clone, exec, and exit.
+
+1.2 Multithreaded Applications
+
+Uprobes supports the probing of multithreaded applications.  Uprobes
+imposes no limit on the number of threads in a probed application.
+All threads in a process use the same text pages, so every probe
+in a process affects all threads; of course, each thread hits the
+probepoint (and runs the handler) independently.  Multiple threads
+may run the same handler simultaneously.  If you want a particular
+thread or set of threads to run a particular handler, your handler
+should check current or current->pid to determine which thread has
+hit the probepoint.
+
+When a process clones a new thread, that thread automatically shares
+all current and future probes established for that process.
+
+2. Architectures Supported
+
+This user-bkpt based version of Uprobes is implemented on the following
+architectures:
+
+- x86
+
+3. Configuring Uprobes
+
+When configuring the kernel using make menuconfig/xconfig/oldconfig,
+ensure that CONFIG_UPROBES is set to "y". Under "General setup" select
+"User-space breakpoint assistance" then select "User-space probes".
+
+So that you can load and unload Uprobes-based instrumentation modules,
+make sure "Loadable module support" (CONFIG_MODULES) and "Module
+unloading" (CONFIG_MODULE_UNLOAD) are set to "y".
+
+4. API Reference
+
+The Uprobes API includes a "register" function and an "unregister"
+function for uprobes.  Here are terse, mini-man-page specifications for
+these functions and the associated probe handlers that you'll write.
+See the latter half of this document for examples.
+
+4.1 register_uprobe
+
+#include <linux/uprobes.h>
+int register_uprobe(struct uprobe *u);
+
+Sets a breakpoint at virtual address u->vaddr in the process whose
+pid is u->pid.  When the breakpoint is hit, Uprobes calls u->handler.
+If u->handler_in_interrupt is set, the handler runs in interrupt
+context. Otherwise it runs in task context.
+
+register_uprobe() returns 0 on success, or a negative errno
+otherwise.
+
+User's handler (u->handler):
+#include <linux/uprobes.h>
+#include <linux/ptrace.h>
+void handler(struct uprobe *u, struct pt_regs *regs);
+
+Called with u pointing to the uprobe associated with the breakpoint,
+and regs pointing to the struct containing the registers saved when
+the breakpoint was hit.
+
+4.2 unregister_uprobe
+
+#include <linux/uprobes.h>
+void unregister_uprobe(struct uprobe *u);
+
+Removes the specified probe.  The unregister function can be called
+at any time after the probe has been registered, and can be called
+from a uprobe handler.
+
+5. Uprobes Features and Limitations
+
+The user is expected to assign values to the following members
+of struct uprobe: pid, vaddr, handler, and handler_in_interrupt.
+Uprobes may produce unexpected results if you:
+- change the contents of a uprobe object while it is registered; or
+- attempt to register a uprobe that is already registered.
+
+In this implementation, Uprobes allows only one uprobe at a particular
+address.
+
+Any number of kernel modules may probe a particular process
+simultaneously, and a particular module may probe any number of
+processes simultaneously.
+
+Probes are shared by all threads in a process (including newly
+created threads).
+
+If a probed process exits or execs, Uprobes automatically
+unregisters all uprobes associated with that process.  Subsequent
+attempts to unregister these probes will be treated as no-ops.
+
+On the other hand, if a probed memory area is removed from the
+process's virtual memory map (e.g., via dlclose(3) or munmap(2)),
+it's currently up to you to unregister the probes first.
+
+There is no way to specify that probes should be inherited across fork;
+Uprobes removes all probepoints in the newly created child process.
+
+To avoid interfering with interactive debuggers, Uprobes will refuse
+to insert a probepoint where a breakpoint instruction already exists,
+Some architectures may refuse to insert probes on other types of
+instructions.
+
+If you install a probe in an inline-able function, Uprobes makes
+no attempt to chase down all inline instances of the function and
+install probes there.  gcc may inline a function without being asked,
+so keep this in mind if you're not seeing the probe hits you expect.
+
+A probe handler can modify the environment of the probed function
+-- e.g., by modifying data structures, or by modifying the
+contents of the pt_regs struct (which are restored to the registers
+upon return from the breakpoint).  So Uprobes can be used, for example,
+to install a bug fix or to inject faults for testing.  Uprobes, of
+course, has no way to distinguish the deliberately injected faults
+from the accidental ones.  Don't drink and probe.
+
+When Uprobes establishes a probepoint on a previous unprobed page
+of text, Linux creates a new copy of the page via its copy-on-write
+mechanism.  When probepoints are removed, Uprobes makes no attempt
+to consolidate identical copies of the same page.  This could affect
+memory availability if you probe many, many pages in many, many
+long-running processes.
+
+6. Probe Overhead
+
+Probe overhead is measured on a benchmark that hits the same probepoint
+repeatedly, firing a simple handler each time. Probe overhead
+changes with different cpus/archs/ probe handlers and the number of
+iterations.
+
+Here are sample overhead figures (in usec) for x86 architecture.
+
+i686: Intel(R) Xeon(TM) CPU 2.40GHz
+Without probe module.
+100000 interations in 0.000650 sec i.e 0.006500 usec per iteration
+
+With probes and handler run in interrupt context.
+100000 interations in 0.340774 sec i.e 3.407740 usec per iteration
+probe overhead is  3.401240 usec per probe hit.
+
+With probes and handler run in task context.
+100000 interations in 0.365589 sec i.e 3.655890 usec per iteration
+probe overhead is 3.649390 usec per probe hit.
+
+x86_64: Intel(R) Xeon(R) CPU           X7350  @ 2.93GHz
+Without probe module.
+100000 interations in 0.000468 sec i.e  0.004680 usec per iteration
+
+With probes and handler run in interrupt context.
+100000 interations in 0.120369 sec i.e 1.203690 usec per iteration
+Probe overhead is 1.199010 usec per probe hit.
+
+With probes and handler run in task context.
+100000 interations in 0.130685 sec i.e 1.306850 usec per iteration
+Probe overhead is 1.302170 usec per probe hit.
+
+7. TODO
+
+a. Support for other architectures.
+b. Support for multiple probes at the same address.
+c. Support for boosted probes.
+d. Support return probes.
+
+8. Uprobes Team
+
+The following people have made major contributions to Uprobes:
+Jim Keniston - jkenisto@us.ibm.com
+Srikar Dronamraju - srikar@linux.vnet.ibm.com
+Ananth Mavinakayanahalli - ananth@in.ibm.com
+Prasanna Panchamukhi - prasanna@in.ibm.com
+Dave Wilder - dwilder@us.ibm.com
+
+9. Uprobes Example
+
+samples/uprobes/uprobe_example.c
