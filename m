Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab0HYNrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 09:47:36 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:38587 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab0HYNrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 09:47:32 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Wed, 25 Aug 2010 19:12:44 +0530
Message-Id: <20100825134244.5447.1872.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
Subject: [PATCHv11 2.6.36-rc2-tip 7/15]  7: uprobes: Uprobes Documentation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Uprobes Documentation.

Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

Changelog from V5: Removed references to Modules, Samples, and
   probe Overhead.

Changelog from v3: Updated measurements.

Changelog from v2: Updated measurements.

Changelog from v1: Addressed comments from Randy Dunlap.
		 : Updated measurements.

 Documentation/uprobes.txt |  188 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 188 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/uprobes.txt

diff --git a/Documentation/uprobes.txt b/Documentation/uprobes.txt
new file mode 100644
index 0000000..5b620d8
--- /dev/null
+++ b/Documentation/uprobes.txt
@@ -0,0 +1,188 @@
+Title	: User-Space Probes (Uprobes)
+Authors	: Jim Keniston <jkenisto@us.ibm.com>
+	: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
+
+CONTENTS
+
+1. Concepts: Uprobes
+2. Architectures Supported
+3. API Reference
+4. Uprobes Features and Limitations
+5. TODO
+6. Uprobes Team
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
+task context; this is specified by the user at the time of registration.
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
+This user_bkpt based version of Uprobes is implemented on the following
+architectures:
+
+- x86
+
+3. API Reference
+
+The Uprobes API includes a "register" function and an "unregister"
+function for uprobes.  Here are terse, mini-man-page specifications for
+these functions and the associated probe handlers that you'll write.
+See the latter half of this document for examples.
+
+3.1 register_uprobe
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
+3.2 unregister_uprobe
+
+#include <linux/uprobes.h>
+void unregister_uprobe(struct uprobe *u);
+
+Removes the specified probe.  The unregister function can be called
+at any time after the probe has been registered, and can be called
+from a uprobe handler.
+
+4. Uprobes Features and Limitations
+
+The user is expected to assign values to the following members
+of struct uprobe: pid, vaddr, handler.
+Uprobes may produce unexpected results if you:
+- change the contents of a uprobe object while it is registered; or
+- attempt to register a uprobe that is already registered.
+
+In this implementation, Uprobes allows only one uprobe at a particular
+address.
+
+Uprobe clients may be used to probe a particular process
+simultaneously, or probe any number of processes simultaneously.
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
+to insert a probepoint where a breakpoint instruction already exists.
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
+When Uprobes establishes a probepoint on a previous unprobed page of
+text, Linux creates a new copy of the page via background page
+replacement  mechanism.  When probepoints are removed, Uprobes makes
+no attempt to consolidate identical copies of the same page.  This
+could affect memory availability if you probe many, many pages in
+many, many long-running processes.
+
+5. TODO
+
+a. Support for other architectures.
+b. Support for multiple probes at the same address.
+c. Support for boosted probes.
+d. Support return probes.
+
+6. Uprobes Team
+
+The following people have made major contributions to Uprobes:
+Jim Keniston - jkenisto@us.ibm.com
+Srikar Dronamraju - srikar@linux.vnet.ibm.com
+Ananth Mavinakayanahalli - ananth@in.ibm.com
+Prasanna Panchamukhi - prasanna@in.ibm.com
+Dave Wilder - dwilder@us.ibm.com
