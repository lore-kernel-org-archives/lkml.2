Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab2LNSmQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 13:42:16 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:36889 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756889Ab2LNSmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 13:42:11 -0500
Subject: [RFC][PATCH 3/7] order memory debugging Kconfig options
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 14 Dec 2012 13:42:03 -0500
References: <20121214184200.8EC5168B@kernel.stglabs.ibm.com>
In-Reply-To: <20121214184200.8EC5168B@kernel.stglabs.ibm.com>
Message-Id: <20121214184203.37E6C724@kernel.stglabs.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121418-7182-0000-0000-000003CD049F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are a *LOT* of memory debugging options.  They are just scattered
all over the "Kernel Hacking" menu.  Sure, "memory debugging" is a very
vague term and it's going to be hard to make absolute rules about what
goes in here, but this has to be better than what we had before.

This does, however, leave out the architecture-specific memory
debugging options (like x86's DEBUG_SET_MODULE_RONX).  There would need
to be some substantial changes to move those in here.  Kconfig can not
easily mix arch-specific and generic options together: it really
requires a file per-architecture, and I think having an
arch/foo/Kconfig.debug-memory might be taking things a bit too far

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/x86/Kconfig.debug |    2 
 linux-2.6.git-dave/lib/Kconfig.debug      |  702 +++++++++++++++---------------
 2 files changed, 357 insertions(+), 347 deletions(-)

diff -puN arch/x86/Kconfig.debug~order-memory-debugging-options arch/x86/Kconfig.debug
--- linux-2.6.git/arch/x86/Kconfig.debug~order-memory-debugging-options	2012-12-10 11:27:44.047952567 -0500
+++ linux-2.6.git-dave/arch/x86/Kconfig.debug	2012-12-10 11:27:44.063952709 -0500
@@ -61,7 +61,7 @@ config EARLY_PRINTK_DBGP
 
 config X86_PTDUMP
 	bool "Export kernel pagetable layout to userspace via debugfs"
-	depends on DEBUG_KERNEL
+	depends on DEBUG_MEMORY
 	select DEBUG_FS
 	---help---
 	  Say Y here if you want to show the kernel pagetable layout in a
diff -puN lib/Kconfig.debug~order-memory-debugging-options lib/Kconfig.debug
--- linux-2.6.git/lib/Kconfig.debug~order-memory-debugging-options	2012-12-10 11:27:44.059952672 -0500
+++ linux-2.6.git-dave/lib/Kconfig.debug	2012-12-10 11:28:38.668440377 -0500
@@ -173,6 +173,285 @@ config DEBUG_KERNEL
 	  Say Y here if you are developing drivers or trying to debug and
 	  identify kernel problems.
 
+menuconfig DEBUG_MEMORY
+	bool "Memory Debugging"
+	def_bool y
+	depends on DEBUG_KERNEL
+	help
+	  Say Y here if you are trying to debug memory issues like memory
+	  corruption or memory leaks.
+
+if DEBUG_MEMORY
+
+source mm/Kconfig.debug
+
+config DEBUG_OBJECTS
+	bool "Debug object operations"
+	help
+	  If you say Y here, additional code will be inserted into the
+	  kernel to track the life time of various objects and validate
+	  the operations on those objects.
+
+config DEBUG_OBJECTS_SELFTEST
+	bool "Debug objects selftest"
+	depends on DEBUG_OBJECTS
+	help
+	  This enables the selftest of the object debug code.
+
+config DEBUG_OBJECTS_FREE
+	bool "Debug objects in freed memory"
+	depends on DEBUG_OBJECTS
+	help
+	  This enables checks whether a k/v free operation frees an area
+	  which contains an object which has not been deactivated
+	  properly. This can make kmalloc/kfree-intensive workloads
+	  much slower.
+
+config DEBUG_OBJECTS_TIMERS
+	bool "Debug timer objects"
+	depends on DEBUG_OBJECTS
+	help
+	  If you say Y here, additional code will be inserted into the
+	  timer routines to track the life time of timer objects and
+	  validate the timer operations.
+
+config DEBUG_OBJECTS_WORK
+	bool "Debug work objects"
+	depends on DEBUG_OBJECTS
+	help
+	  If you say Y here, additional code will be inserted into the
+	  work queue routines to track the life time of work objects and
+	  validate the work operations.
+
+config DEBUG_OBJECTS_RCU_HEAD
+	bool "Debug RCU callbacks objects"
+	depends on DEBUG_OBJECTS
+	help
+	  Enable this to turn on debugging of RCU list heads (call_rcu() usage).
+
+config DEBUG_OBJECTS_PERCPU_COUNTER
+	bool "Debug percpu counter objects"
+	depends on DEBUG_OBJECTS
+	help
+	  If you say Y here, additional code will be inserted into the
+	  percpu counter routines to track the life time of percpu counter
+	  objects and validate the percpu counter operations.
+
+config DEBUG_OBJECTS_ENABLE_DEFAULT
+	int "debug_objects bootup default value (0-1)"
+        range 0 1
+        default "1"
+        depends on DEBUG_OBJECTS
+        help
+          Debug objects boot parameter default value
+
+config DEBUG_SLAB
+	bool "Debug slab memory allocations"
+	depends on DEBUG_KERNEL && SLAB && !KMEMCHECK
+	help
+	  Say Y here to have the kernel do limited verification on memory
+	  allocation as well as poisoning memory on free to catch use of freed
+	  memory. This can make kmalloc/kfree-intensive workloads much slower.
+
+config DEBUG_SLAB_LEAK
+	bool "Memory leak debugging"
+	depends on DEBUG_SLAB
+
+config SLUB_DEBUG_ON
+	bool "SLUB debugging on by default"
+	depends on SLUB && SLUB_DEBUG && !KMEMCHECK
+	default n
+	help
+	  Boot with debugging on by default. SLUB boots by default with
+	  the runtime debug capabilities switched off. Enabling this is
+	  equivalent to specifying the "slub_debug" parameter on boot.
+	  There is no support for more fine grained debug control like
+	  possible with slub_debug=xxx. SLUB debugging may be switched
+	  off in a kernel built with CONFIG_SLUB_DEBUG_ON by specifying
+	  "slub_debug=-".
+
+config SLUB_STATS
+	default n
+	bool "Enable SLUB performance statistics"
+	depends on SLUB && SYSFS
+	help
+	  SLUB statistics are useful to debug SLUBs allocation behavior in
+	  order find ways to optimize the allocator. This should never be
+	  enabled for production use since keeping statistics slows down
+	  the allocator by a few percentage points. The slabinfo command
+	  supports the determination of the most active slabs to figure
+	  out which slabs are relevant to a particular load.
+	  Try running: slabinfo -DA
+
+config HAVE_DEBUG_KMEMLEAK
+	bool
+
+config DEBUG_KMEMLEAK
+	bool "Kernel memory leak detector"
+	depends on DEBUG_KERNEL && EXPERIMENTAL && HAVE_DEBUG_KMEMLEAK
+	select DEBUG_FS
+	select STACKTRACE if STACKTRACE_SUPPORT
+	select KALLSYMS
+	select CRC32
+	help
+	  Say Y here if you want to enable the memory leak
+	  detector. The memory allocation/freeing is traced in a way
+	  similar to the Boehm's conservative garbage collector, the
+	  difference being that the orphan objects are not freed but
+	  only shown in /sys/kernel/debug/kmemleak. Enabling this
+	  feature will introduce an overhead to memory
+	  allocations. See Documentation/kmemleak.txt for more
+	  details.
+
+	  Enabling DEBUG_SLAB or SLUB_DEBUG may increase the chances
+	  of finding leaks due to the slab objects poisoning.
+
+	  In order to access the kmemleak file, debugfs needs to be
+	  mounted (usually at /sys/kernel/debug).
+
+config DEBUG_KMEMLEAK_EARLY_LOG_SIZE
+	int "Maximum kmemleak early log entries"
+	depends on DEBUG_KMEMLEAK
+	range 200 40000
+	default 400
+	help
+	  Kmemleak must track all the memory allocations to avoid
+	  reporting false positives. Since memory may be allocated or
+	  freed before kmemleak is initialised, an early log buffer is
+	  used to store these actions. If kmemleak reports "early log
+	  buffer exceeded", please increase this value.
+
+config DEBUG_KMEMLEAK_TEST
+	tristate "Simple test for the kernel memory leak detector"
+	depends on DEBUG_KMEMLEAK && m
+	help
+	  This option enables a module that explicitly leaks memory.
+
+	  If unsure, say N.
+
+config DEBUG_KMEMLEAK_DEFAULT_OFF
+	bool "Default kmemleak to off"
+	depends on DEBUG_KMEMLEAK
+	help
+	  Say Y here to disable kmemleak by default. It can then be enabled
+	  on the command line via kmemleak=on.
+
+config DEBUG_STACK_USAGE
+	bool "Stack utilization instrumentation"
+	depends on DEBUG_KERNEL && !IA64 && !PARISC
+	help
+	  Enables the display of the minimum amount of free stack which each
+	  task has ever had available in the sysrq-T and sysrq-P debug output.
+
+	  This option will slow down process creation somewhat.
+
+config DEBUG_VM
+	bool "Debug VM"
+	depends on DEBUG_KERNEL
+	help
+	  Enable this to turn on extended checks in the virtual-memory system
+          that may impact performance.
+
+	  If unsure, say N.
+
+config DEBUG_VM_RB
+	bool "Debug VM red-black trees"
+	depends on DEBUG_VM
+	help
+	  Enable this to turn on more extended checks in the virtual-memory
+	  system that may impact performance.
+
+	  If unsure, say N.
+
+config DEBUG_VIRTUAL
+	bool "Debug VM translations"
+	depends on DEBUG_KERNEL && X86
+	help
+	  Enable some costly sanity checks in virtual to page code. This can
+	  catch mistakes with virt_to_page() and friends.
+
+	  If unsure, say N.
+
+config DEBUG_NOMMU_REGIONS
+	bool "Debug the global anon/private NOMMU mapping region tree"
+	depends on DEBUG_KERNEL && !MMU
+	help
+	  This option causes the global tree of anonymous and private mapping
+	  regions to be regularly checked for invalid topology.
+
+config DEBUG_MEMORY_INIT
+	bool "Debug memory initialisation" if EXPERT
+	default !EXPERT
+	help
+	  Enable this for additional checks during memory initialisation.
+	  The sanity checks verify aspects of the VM such as the memory model
+	  and other information provided by the architecture. Verbose
+	  information will be printed at KERN_DEBUG loglevel depending
+	  on the mminit_loglevel= command-line option.
+
+	  If unsure, say Y
+
+config MEMORY_NOTIFIER_ERROR_INJECT
+	tristate "Memory hotplug notifier error injection module"
+	depends on MEMORY_HOTPLUG_SPARSE && NOTIFIER_ERROR_INJECTION
+	help
+	  This option provides the ability to inject artifical errors to
+	  memory hotplug notifier chain callbacks.  It is controlled through
+	  debugfs interface under /sys/kernel/debug/notifier-error-inject/memory
+
+	  If the notifier call chain should be failed with some events
+	  notified, write the error code to "actions/<notifier event>/error".
+
+	  Example: Inject memory hotplug offline error (-12 == -ENOMEM)
+
+	  # cd /sys/kernel/debug/notifier-error-inject/memory
+	  # echo -12 > actions/MEM_GOING_OFFLINE/error
+	  # echo offline > /sys/devices/system/memory/memoryXXX/state
+	  bash: echo: write error: Cannot allocate memory
+
+	  To compile this code as a module, choose M here: the module will
+	  be called pSeries-reconfig-notifier-error-inject.
+
+	  If unsure, say N.
+
+config DEBUG_PER_CPU_MAPS
+	bool "Debug access to per_cpu maps"
+	depends on DEBUG_KERNEL
+	depends on SMP
+	help
+	  Say Y to verify that the per_cpu map being accessed has
+	  been set up. This adds a fair amount of code to kernel memory
+	  and decreases performance.
+
+	  Say N if unsure.
+
+config DEBUG_HIGHMEM
+	bool "Highmem debugging"
+	depends on DEBUG_KERNEL && HIGHMEM
+	help
+	  This options enables addition error checking for high memory systems.
+	  Disable for production systems.
+
+config DEBUG_STACKOVERFLOW
+	bool "Check for stack overflows"
+	depends on ARCH_ENABLE_DEBUG_STACKOVERFLOW
+	---help---
+	 Say Y here if you want to check for overflows of kernel, IRQ
+	 and exception stacks (if your archicture uses them). This
+	 option will show detailed messages if free stack space drops
+	 below a certain limit.
+
+	 These kinds of bugs usually occur when call-chains in the
+	 kernel get too deep, especially when interrupts are
+	 involved.
+
+	 Use this in cases where you see apparently random memory
+	 corruption, especially if it appears in 'struct thread_info'
+
+source "lib/Kconfig.kmemcheck"
+
+endif # DEBUG_MEMORY
+
 config DEBUG_SHIRQ
 	bool "Debug shared IRQ handlers"
 	depends on DEBUG_KERNEL && GENERIC_HARDIRQS
@@ -267,252 +546,100 @@ config PANIC_ON_OOPS
 
 	  Say N if unsure.
 
-config PANIC_ON_OOPS_VALUE
-	int
-	range 0 1
-	default 0 if !PANIC_ON_OOPS
-	default 1 if PANIC_ON_OOPS
-
-config DETECT_HUNG_TASK
-	bool "Detect Hung Tasks"
-	depends on DEBUG_KERNEL
-	default LOCKUP_DETECTOR
-	help
-	  Say Y here to enable the kernel to detect "hung tasks",
-	  which are bugs that cause the task to be stuck in
-	  uninterruptible "D" state indefinitiley.
-
-	  When a hung task is detected, the kernel will print the
-	  current stack trace (which you should report), but the
-	  task will stay in uninterruptible state. If lockdep is
-	  enabled then all held locks will also be reported. This
-	  feature has negligible overhead.
-
-config DEFAULT_HUNG_TASK_TIMEOUT
-	int "Default timeout for hung task detection (in seconds)"
-	depends on DETECT_HUNG_TASK
-	default 120
-	help
-	  This option controls the default timeout (in seconds) used
-	  to determine when a task has become non-responsive and should
-	  be considered hung.
-
-	  It can be adjusted at runtime via the kernel.hung_task_timeout_secs
-	  sysctl or by writing a value to
-	  /proc/sys/kernel/hung_task_timeout_secs.
-
-	  A timeout of 0 disables the check.  The default is two minutes.
-	  Keeping the default should be fine in most cases.
-
-config BOOTPARAM_HUNG_TASK_PANIC
-	bool "Panic (Reboot) On Hung Tasks"
-	depends on DETECT_HUNG_TASK
-	help
-	  Say Y here to enable the kernel to panic on "hung tasks",
-	  which are bugs that cause the kernel to leave a task stuck
-	  in uninterruptible "D" state.
-
-	  The panic can be used in combination with panic_timeout,
-	  to cause the system to reboot automatically after a
-	  hung task has been detected. This feature is useful for
-	  high-availability systems that have uptime guarantees and
-	  where a hung tasks must be resolved ASAP.
-
-	  Say N if unsure.
-
-config BOOTPARAM_HUNG_TASK_PANIC_VALUE
-	int
-	depends on DETECT_HUNG_TASK
-	range 0 1
-	default 0 if !BOOTPARAM_HUNG_TASK_PANIC
-	default 1 if BOOTPARAM_HUNG_TASK_PANIC
-
-config SCHED_DEBUG
-	bool "Collect scheduler debugging info"
-	depends on DEBUG_KERNEL && PROC_FS
-	default y
-	help
-	  If you say Y here, the /proc/sched_debug file will be provided
-	  that can help debug the scheduler. The runtime overhead of this
-	  option is minimal.
-
-config SCHEDSTATS
-	bool "Collect scheduler statistics"
-	depends on DEBUG_KERNEL && PROC_FS
-	help
-	  If you say Y here, additional code will be inserted into the
-	  scheduler and related routines to collect statistics about
-	  scheduler behavior and provide them in /proc/schedstat.  These
-	  stats may be useful for both tuning and debugging the scheduler
-	  If you aren't debugging the scheduler or trying to tune a specific
-	  application, you can say N to avoid the very slight overhead
-	  this adds.
-
-config TIMER_STATS
-	bool "Collect kernel timers statistics"
-	depends on DEBUG_KERNEL && PROC_FS
-	help
-	  If you say Y here, additional code will be inserted into the
-	  timer routines to collect statistics about kernel timers being
-	  reprogrammed. The statistics can be read from /proc/timer_stats.
-	  The statistics collection is started by writing 1 to /proc/timer_stats,
-	  writing 0 stops it. This feature is useful to collect information
-	  about timer usage patterns in kernel and userspace. This feature
-	  is lightweight if enabled in the kernel config but not activated
-	  (it defaults to deactivated on bootup and will only be activated
-	  if some application like powertop activates it explicitly).
-
-config DEBUG_OBJECTS
-	bool "Debug object operations"
-	depends on DEBUG_KERNEL
-	help
-	  If you say Y here, additional code will be inserted into the
-	  kernel to track the life time of various objects and validate
-	  the operations on those objects.
-
-config DEBUG_OBJECTS_SELFTEST
-	bool "Debug objects selftest"
-	depends on DEBUG_OBJECTS
-	help
-	  This enables the selftest of the object debug code.
-
-config DEBUG_OBJECTS_FREE
-	bool "Debug objects in freed memory"
-	depends on DEBUG_OBJECTS
-	help
-	  This enables checks whether a k/v free operation frees an area
-	  which contains an object which has not been deactivated
-	  properly. This can make kmalloc/kfree-intensive workloads
-	  much slower.
-
-config DEBUG_OBJECTS_TIMERS
-	bool "Debug timer objects"
-	depends on DEBUG_OBJECTS
-	help
-	  If you say Y here, additional code will be inserted into the
-	  timer routines to track the life time of timer objects and
-	  validate the timer operations.
-
-config DEBUG_OBJECTS_WORK
-	bool "Debug work objects"
-	depends on DEBUG_OBJECTS
-	help
-	  If you say Y here, additional code will be inserted into the
-	  work queue routines to track the life time of work objects and
-	  validate the work operations.
-
-config DEBUG_OBJECTS_RCU_HEAD
-	bool "Debug RCU callbacks objects"
-	depends on DEBUG_OBJECTS
-	help
-	  Enable this to turn on debugging of RCU list heads (call_rcu() usage).
-
-config DEBUG_OBJECTS_PERCPU_COUNTER
-	bool "Debug percpu counter objects"
-	depends on DEBUG_OBJECTS
-	help
-	  If you say Y here, additional code will be inserted into the
-	  percpu counter routines to track the life time of percpu counter
-	  objects and validate the percpu counter operations.
-
-config DEBUG_OBJECTS_ENABLE_DEFAULT
-	int "debug_objects bootup default value (0-1)"
-        range 0 1
-        default "1"
-        depends on DEBUG_OBJECTS
-        help
-          Debug objects boot parameter default value
+config PANIC_ON_OOPS_VALUE
+	int
+	range 0 1
+	default 0 if !PANIC_ON_OOPS
+	default 1 if PANIC_ON_OOPS
 
-config DEBUG_SLAB
-	bool "Debug slab memory allocations"
-	depends on DEBUG_KERNEL && SLAB && !KMEMCHECK
+config DETECT_HUNG_TASK
+	bool "Detect Hung Tasks"
+	depends on DEBUG_KERNEL
+	default LOCKUP_DETECTOR
 	help
-	  Say Y here to have the kernel do limited verification on memory
-	  allocation as well as poisoning memory on free to catch use of freed
-	  memory. This can make kmalloc/kfree-intensive workloads much slower.
+	  Say Y here to enable the kernel to detect "hung tasks",
+	  which are bugs that cause the task to be stuck in
+	  uninterruptible "D" state indefinitiley.
 
-config DEBUG_SLAB_LEAK
-	bool "Memory leak debugging"
-	depends on DEBUG_SLAB
+	  When a hung task is detected, the kernel will print the
+	  current stack trace (which you should report), but the
+	  task will stay in uninterruptible state. If lockdep is
+	  enabled then all held locks will also be reported. This
+	  feature has negligible overhead.
 
-config SLUB_DEBUG_ON
-	bool "SLUB debugging on by default"
-	depends on SLUB && SLUB_DEBUG && !KMEMCHECK
-	default n
+config DEFAULT_HUNG_TASK_TIMEOUT
+	int "Default timeout for hung task detection (in seconds)"
+	depends on DETECT_HUNG_TASK
+	default 120
 	help
-	  Boot with debugging on by default. SLUB boots by default with
-	  the runtime debug capabilities switched off. Enabling this is
-	  equivalent to specifying the "slub_debug" parameter on boot.
-	  There is no support for more fine grained debug control like
-	  possible with slub_debug=xxx. SLUB debugging may be switched
-	  off in a kernel built with CONFIG_SLUB_DEBUG_ON by specifying
-	  "slub_debug=-".
+	  This option controls the default timeout (in seconds) used
+	  to determine when a task has become non-responsive and should
+	  be considered hung.
 
-config SLUB_STATS
-	default n
-	bool "Enable SLUB performance statistics"
-	depends on SLUB && SYSFS
-	help
-	  SLUB statistics are useful to debug SLUBs allocation behavior in
-	  order find ways to optimize the allocator. This should never be
-	  enabled for production use since keeping statistics slows down
-	  the allocator by a few percentage points. The slabinfo command
-	  supports the determination of the most active slabs to figure
-	  out which slabs are relevant to a particular load.
-	  Try running: slabinfo -DA
+	  It can be adjusted at runtime via the kernel.hung_task_timeout_secs
+	  sysctl or by writing a value to
+	  /proc/sys/kernel/hung_task_timeout_secs.
 
-config HAVE_DEBUG_KMEMLEAK
-	bool
+	  A timeout of 0 disables the check.  The default is two minutes.
+	  Keeping the default should be fine in most cases.
 
-config DEBUG_KMEMLEAK
-	bool "Kernel memory leak detector"
-	depends on DEBUG_KERNEL && EXPERIMENTAL && HAVE_DEBUG_KMEMLEAK
-	select DEBUG_FS
-	select STACKTRACE if STACKTRACE_SUPPORT
-	select KALLSYMS
-	select CRC32
+config BOOTPARAM_HUNG_TASK_PANIC
+	bool "Panic (Reboot) On Hung Tasks"
+	depends on DETECT_HUNG_TASK
 	help
-	  Say Y here if you want to enable the memory leak
-	  detector. The memory allocation/freeing is traced in a way
-	  similar to the Boehm's conservative garbage collector, the
-	  difference being that the orphan objects are not freed but
-	  only shown in /sys/kernel/debug/kmemleak. Enabling this
-	  feature will introduce an overhead to memory
-	  allocations. See Documentation/kmemleak.txt for more
-	  details.
+	  Say Y here to enable the kernel to panic on "hung tasks",
+	  which are bugs that cause the kernel to leave a task stuck
+	  in uninterruptible "D" state.
 
-	  Enabling DEBUG_SLAB or SLUB_DEBUG may increase the chances
-	  of finding leaks due to the slab objects poisoning.
+	  The panic can be used in combination with panic_timeout,
+	  to cause the system to reboot automatically after a
+	  hung task has been detected. This feature is useful for
+	  high-availability systems that have uptime guarantees and
+	  where a hung tasks must be resolved ASAP.
 
-	  In order to access the kmemleak file, debugfs needs to be
-	  mounted (usually at /sys/kernel/debug).
+	  Say N if unsure.
 
-config DEBUG_KMEMLEAK_EARLY_LOG_SIZE
-	int "Maximum kmemleak early log entries"
-	depends on DEBUG_KMEMLEAK
-	range 200 40000
-	default 400
-	help
-	  Kmemleak must track all the memory allocations to avoid
-	  reporting false positives. Since memory may be allocated or
-	  freed before kmemleak is initialised, an early log buffer is
-	  used to store these actions. If kmemleak reports "early log
-	  buffer exceeded", please increase this value.
+config BOOTPARAM_HUNG_TASK_PANIC_VALUE
+	int
+	depends on DETECT_HUNG_TASK
+	range 0 1
+	default 0 if !BOOTPARAM_HUNG_TASK_PANIC
+	default 1 if BOOTPARAM_HUNG_TASK_PANIC
 
-config DEBUG_KMEMLEAK_TEST
-	tristate "Simple test for the kernel memory leak detector"
-	depends on DEBUG_KMEMLEAK && m
+config SCHED_DEBUG
+	bool "Collect scheduler debugging info"
+	depends on DEBUG_KERNEL && PROC_FS
+	default y
 	help
-	  This option enables a module that explicitly leaks memory.
+	  If you say Y here, the /proc/sched_debug file will be provided
+	  that can help debug the scheduler. The runtime overhead of this
+	  option is minimal.
 
-	  If unsure, say N.
+config SCHEDSTATS
+	bool "Collect scheduler statistics"
+	depends on DEBUG_KERNEL && PROC_FS
+	help
+	  If you say Y here, additional code will be inserted into the
+	  scheduler and related routines to collect statistics about
+	  scheduler behavior and provide them in /proc/schedstat.  These
+	  stats may be useful for both tuning and debugging the scheduler
+	  If you aren't debugging the scheduler or trying to tune a specific
+	  application, you can say N to avoid the very slight overhead
+	  this adds.
 
-config DEBUG_KMEMLEAK_DEFAULT_OFF
-	bool "Default kmemleak to off"
-	depends on DEBUG_KMEMLEAK
+config TIMER_STATS
+	bool "Collect kernel timers statistics"
+	depends on DEBUG_KERNEL && PROC_FS
 	help
-	  Say Y here to disable kmemleak by default. It can then be enabled
-	  on the command line via kmemleak=on.
+	  If you say Y here, additional code will be inserted into the
+	  timer routines to collect statistics about kernel timers being
+	  reprogrammed. The statistics can be read from /proc/timer_stats.
+	  The statistics collection is started by writing 1 to /proc/timer_stats,
+	  writing 0 stops it. This feature is useful to collect information
+	  about timer usage patterns in kernel and userspace. This feature
+	  is lightweight if enabled in the kernel config but not activated
+	  (it defaults to deactivated on bootup and will only be activated
+	  if some application like powertop activates it explicitly).
 
 config DEBUG_PREEMPT
 	bool "Debug preemptible kernel"
@@ -739,15 +866,6 @@ config STACKTRACE
 	bool
 	depends on STACKTRACE_SUPPORT
 
-config DEBUG_STACK_USAGE
-	bool "Stack utilization instrumentation"
-	depends on DEBUG_KERNEL && !IA64 && !PARISC
-	help
-	  Enables the display of the minimum amount of free stack which each
-	  task has ever had available in the sysrq-T and sysrq-P debug output.
-
-	  This option will slow down process creation somewhat.
-
 config DEBUG_KOBJECT
 	bool "kobject debugging"
 	depends on DEBUG_KERNEL
@@ -755,13 +873,6 @@ config DEBUG_KOBJECT
 	  If you say Y here, some extra kobject debugging messages will be sent
 	  to the syslog. 
 
-config DEBUG_HIGHMEM
-	bool "Highmem debugging"
-	depends on DEBUG_KERNEL && HIGHMEM
-	help
-	  This options enables addition error checking for high memory systems.
-	  Disable for production systems.
-
 config HAVE_DEBUG_BUGVERBOSE
 	bool
 
@@ -800,40 +911,6 @@ config DEBUG_INFO_REDUCED
 	  DEBUG_INFO build and compile times are reduced too.
 	  Only works with newer gcc versions.
 
-config DEBUG_VM
-	bool "Debug VM"
-	depends on DEBUG_KERNEL
-	help
-	  Enable this to turn on extended checks in the virtual-memory system
-          that may impact performance.
-
-	  If unsure, say N.
-
-config DEBUG_VM_RB
-	bool "Debug VM red-black trees"
-	depends on DEBUG_VM
-	help
-	  Enable this to turn on more extended checks in the virtual-memory
-	  system that may impact performance.
-
-	  If unsure, say N.
-
-config DEBUG_VIRTUAL
-	bool "Debug VM translations"
-	depends on DEBUG_KERNEL && X86
-	help
-	  Enable some costly sanity checks in virtual to page code. This can
-	  catch mistakes with virt_to_page() and friends.
-
-	  If unsure, say N.
-
-config DEBUG_NOMMU_REGIONS
-	bool "Debug the global anon/private NOMMU mapping region tree"
-	depends on DEBUG_KERNEL && !MMU
-	help
-	  This option causes the global tree of anonymous and private mapping
-	  regions to be regularly checked for invalid topology.
-
 config DEBUG_WRITECOUNT
 	bool "Debug filesystem writers count"
 	depends on DEBUG_KERNEL
@@ -844,18 +921,6 @@ config DEBUG_WRITECOUNT
 
 	  If unsure, say N.
 
-config DEBUG_MEMORY_INIT
-	bool "Debug memory initialisation" if EXPERT
-	default !EXPERT
-	help
-	  Enable this for additional checks during memory initialisation.
-	  The sanity checks verify aspects of the VM such as the memory model
-	  and other information provided by the architecture. Verbose
-	  information will be printed at KERN_DEBUG loglevel depending
-	  on the mminit_loglevel= command-line option.
-
-	  If unsure, say Y
-
 config DEBUG_LIST
 	bool "Debug linked list manipulation"
 	depends on DEBUG_KERNEL
@@ -1095,17 +1160,6 @@ config DEBUG_FORCE_WEAK_PER_CPU
 	  To ensure that generic code follows the above rules, this
 	  option forces all percpu variables to be defined as weak.
 
-config DEBUG_PER_CPU_MAPS
-	bool "Debug access to per_cpu maps"
-	depends on DEBUG_KERNEL
-	depends on SMP
-	help
-	  Say Y to verify that the per_cpu map being accessed has
-	  been set up. This adds a fair amount of code to kernel memory
-	  and decreases performance.
-
-	  Say N if unsure.
-
 config LKDTM
 	tristate "Linux Kernel Dump Test Tool Module"
 	depends on DEBUG_FS
@@ -1180,29 +1234,6 @@ config PM_NOTIFIER_ERROR_INJECT
 
 	  If unsure, say N.
 
-config MEMORY_NOTIFIER_ERROR_INJECT
-	tristate "Memory hotplug notifier error injection module"
-	depends on MEMORY_HOTPLUG_SPARSE && NOTIFIER_ERROR_INJECTION
-	help
-	  This option provides the ability to inject artifical errors to
-	  memory hotplug notifier chain callbacks.  It is controlled through
-	  debugfs interface under /sys/kernel/debug/notifier-error-inject/memory
-
-	  If the notifier call chain should be failed with some events
-	  notified, write the error code to "actions/<notifier event>/error".
-
-	  Example: Inject memory hotplug offline error (-12 == -ENOMEM)
-
-	  # cd /sys/kernel/debug/notifier-error-inject/memory
-	  # echo -12 > actions/MEM_GOING_OFFLINE/error
-	  # echo offline > /sys/devices/system/memory/memoryXXX/state
-	  bash: echo: write error: Cannot allocate memory
-
-	  To compile this code as a module, choose M here: the module will
-	  be called pSeries-reconfig-notifier-error-inject.
-
-	  If unsure, say N.
-
 config PSERIES_RECONFIG_NOTIFIER_ERROR_INJECT
 	tristate "pSeries reconfig notifier error injection module"
 	depends on PPC_PSERIES && NOTIFIER_ERROR_INJECTION
@@ -1299,7 +1330,6 @@ config LATENCYTOP
 	  Enable this option if you want to use the LatencyTOP tool
 	  to find out which userspace is blocking on what kernel operations.
 
-source mm/Kconfig.debug
 source kernel/trace/Kconfig
 
 config RBTREE_TEST
@@ -1467,29 +1497,9 @@ config ASYNC_RAID6_TEST
 config HAVE_DEBUG_STACKOVERFLOW
 	bool
 
-config DEBUG_STACKOVERFLOW
-	bool "Check for stack overflows"
-	depends on DEBUG_KERNEL && HAVE_DEBUG_STACKOVERFLOW
-	---help---
-	  Say Y here if you want to check for overflows of kernel, IRQ
-	  and exception stacks (if your archicture uses them). This
-	  option will show detailed messages if free stack space drops
-	  below a certain limit.
-
-	  These kinds of bugs usually occur when call-chains in the
-	  kernel get too deep, especially when interrupts are
-	  involved.
-
-	  Use this in cases where you see apparently random memory
-	  corruption, especially if it appears in 'struct thread_info'
-
-	  If in doubt, say "N".
-
 source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"
 
-source "lib/Kconfig.kmemcheck"
-
 config TEST_KSTRTOX
 	tristate "Test kstrto*() family of functions at runtime"
_

