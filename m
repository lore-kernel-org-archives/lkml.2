Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab2BBCmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 21:42:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546Ab2BBCmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 21:42:05 -0500
Date: Wed, 1 Feb 2012 21:41:42 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: systemtap@sourceware.org
Cc: linux-kernel@vger.kernel.org, lwn@lwn.net
Subject: systemtap 1.7 release
Message-ID: <20120202024142.GC20878@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The systemtap team announces release 1.7

  The new group and privilege level "stapsys" has been added,
  debuginfo can now be automatically downloaded, quiet runtime error
  handling was added, parser error handling has been improved, device
  driver initialization functions can now be probed, user and kernel
  dwarf backtraces are now enabled on ppc, s390x and arm, new
  stap-server customizing options have been added.  Associative arrays
  are much faster.  Many diagnostic messages have been improved.
  Preliminary user-space probing with inode-uprobes, without utrace.
  Faster (compiled) *printf formatting.


= Where to get it

  http://sourceware.org/systemtap/ - our project page
  http://sourceware.org/systemtap/ftp/releases/systemtap-1.7.tar.gz
  http://koji.fedoraproject.org/koji/packageinfo?packageID=615
  git tag release-1.7 (commit 83bd2699)

  There have been over 700 commits since the last release.
  There have been over 90 bugs/features fixed since the last release.


= How to build it

  See the README and NEWS files at
  http://sourceware.org/git/?p=systemtap.git;a=tree
  Further information at http://sourceware.org/systemtap/wiki/


= Systemtap frontend (stap) changes

- New Options

 + Systemtap loads extra command line options from $SYSTEMTAP_DIR/rc
   ($HOME/.systemtap/rc by default) before the normal argc/argv.  This
   may be useful to activate site options such as --use-server or
   --download-debuginfo or --modinfo.                                                                             
 + The translator supports a new --suppress-handler-errors option, which
   causes most runtime errors to be turned into quiet skipped probes.  This
   also disables the MAXERRORS and MAXSKIPPED limits.

 + Translator warnings have been standardized and controlled by the -w / -W 
   flags.

 + The translator supports a new --modinfo NAME=VALUE option, which emits
   additional MODULE_INFO(n,v) macros into the generated code.

 + The stap-server service (initscript) now supports three new options:
    --log LOGFILE	allow specifying a log file
    --port PORT-NUMBER	allow specifying a network port number
    --SSL CERT-DATABASE allow specifying an NSS certificate database location
   These options are also supported within individual server configuration
   files. See stap-server and initscript/README.stap-server for details.
   The stap-server is no longer activated by default.

 + The translator supports a new --dump-probe-types option, which dumps a list
   of supported probe types.  If --unprivileged is also specified, the list
   will be limited to probe types which are available to unprivileged users.

 + Systemtap supports a new --download-debuginfo[=OPTION] option, which can be
   used to automatically download required debuginfo.  Possible values for
   OPTION are: 'yes', 'no', 'ask', and a positive number representing the
   timeout desired. The default behavior is to not automatically download the
   debuginfo.

 + Systemtap supports a new option --privilege=[stapusr|stapsys|stapdev].
   Systemtap now supports a new group and privilege level "stapsys", which is
   equivalent to the privilege afforded by membership in the group "stapdev",
   except that guru mode (-g) functionality may not be used.
   --privilege=stapusr is equivalent to specifying the existing --unprivileged
   option. --privilege=stapdev is the default.

 + The systemtap module cache is cleaned less frequently, governed by the
   number of seconds in the $SYSTEMTAP_DIR/cache/cache_clean_interval_s file.

- The stap-server has seen many improvements, and is no longer considered
  experimental.

- The fixed maximum number of VMA pages that will be tracked at runtime has
  been removed. This reduces memory use for those scripts that either do not
  need any or need only limited target process VMA tracking, and also allows
  easier system wide probes that inspect shared library variables and/or user
  backtraces.  stap will now silently ignore -DTASK_FINDER_VMA_ENTRY_ITEMS.

- Scripts that use kernel.trace("...") probes compile much faster.

- Parse errors no longer generate a cascade of false errors.  Instead, a
  parse error skips the rest of the current probe or function, and resumes
  at the next one.  This should generate fewer and better messages.

- On 2.6.29+ kernels, systemtap can now probe kernel modules that
  arrive and/or depart during session run-time.  This allows
  probing of device driver initialization functions, which had formerly been
  blacklisted.

- The environment variable MAXBACKTRACE, which did work in earlier releases,
  has now been documented in the stap 1 manual page.

- Kernel backtraces can now be generated for non-pt_regs probe context
  if the kernel support dump_trace(). This enables backtraces from
  certain timer probes and tracepoints.

- There is some limited preliminary support for user-space probing
  against kernels such as linux-next, which have no utrace but do have
  the newer inode-uprobes work by Srikar Dronamraju and colleagues.

- Architecture Specific Changes

 + ubacktrace() should now also work for some x86 kernel probes which can
   use the dwarf unwinder to recover the user registers to provide
   more accurate user backtraces.

 + The s390x systemtap runtime now properly splits kernel and user
   addresses, which are in separate address spaces on that architecture,
   which enables user space introspection.

 + ppc, s390x, and arm now support user backtraces through the DWARF unwinder.

 + ppc now handles function descriptors as symbol names correctly.

 + arm now has a uprobes port which enables user probes. This still
   requires some kernel patches (user_regsets and tracehook support for
   arm).


= Systemtap script language changes

- process("PATH").[library("PATH")].function("NAME").exported probes are now
  supported to filter function() to only exported instances.

- process("PATH").library("PATH").plt("NAME") probes are now supported.
  Wildcards are supported in the plt-name part, to refer to any function in the
  program linkage table which matches the glob pattern and the rest of the
  probe point.

- Global array wrapping is now supported for both associative and
  statistics typed arrays using the '%' character to signify a wrapped
  array. For example, 'global foo%[100]' would allow the array 'foo'
  to be wrapped if more than 100 elements are inserted.

- The following probe types are deprecated in release 1.7 and will be removed in release 1.8:
      kernel.function(number).inline
      module(string).function(number).inline
      process.function(number).inline
      process.library(string).function(number).inline
      process(string).function(number).inline
      process(string).library(string).function(number).inline

- SDT can now define up to 12 arguments in a probe point.

- Formatted printing is faster by compiling the formatting directives
  to C code rather than interpreting at run time.

- The translator has better support for probing C++ applications by
  better undertanding of compilation units, nested types, templates,
  as used in probe point and @cast constructs.


= Systemtap tapset changes

- Many prior tapset functions have had documentation added for the generated
  man pages and tapset reference guide.

- The tapset functions remote_id() and remote_uri() identify the member of a
  swarm of "stap --remote FOO --remote BAR baz.stp" concurrent executions.

- The task_backtrace() tapset function was deprecated in 1.7 and has been
  removed in 1.7.

- The tapset function probe_type() has been added, to return a short string
  describing the low level probe handler type for the current probe point.

- Both unwind and symbol data is now only collected and emitted for
  scripts actually using backtracing or function/data symbols.
  Tapset functions are marked with /* pragma:symbols */ or
  /* pragma:unwind */ to indicate they need the specific data.

- The functions cpu_clock_ns(cpu), local_clock_ns(), and their coarser variants
  have been added.  These are monotonic wallclock time sources, rather than the
  absolute time-since-epoch sort.  On kernels too old for these functions, it
  falls back to stap's gettimeofday.
  
- The tapset speculative.stp has been added.  Strings can be speculatively
  written to an output buffer and then later committed or discarded.

- The tapset stopwatch.stp has been added.  It allows named virtual stopwatches
  to be stopped/started/read, as a substitute for manual timestamp subtraction.

- The tapset function pstrace() has been added.  It allows printing of
  a process ancestry list.

- The tapset functions cpu_clock_ns(cpu), local_clock_ns(), and coarser
  variants were added, as monotonic wallclock time sources.

= Systemtap sample scripts

  + eventcount.stp uses wrapped maps to avoid runtime errors due to too many
    processes being encountered.

  + New sample watchdog.stp: implement a resettable system watchdog timer
    that prints a backtrace if it expires.

  + New sample func_time_stats.stp: print histogram of execution duration of
    some named function.

  + New sample stopwatches.stp: demonstrates timekeeping using distinct 
    stopawtches.

  + New sample nfsd_unlink.stp: lists which clients are removing files across
    NFS.

  + New sample pstrace_exec.stp: print process ancestry for selected execs.

  + New sample syscalltimes: a shell+systemtap script to summarize/filter
    system call times.

  + New sample periodic.stp: use the timer_expire_entry tracepoint to summarize
    software timer activity in the kernel.

  + New sample kvm_service_time.stp: report on vm-exit operations.

  + New sample qemu_count.stp: report on userspace qemu sys/sdt.h activity.

  + New sample qemu_io.stp: report on i/o port access by virtual machine.


= Contributors for this release

  Chris Meek, Dave Brolley, David Smith, *Diego Elio Pettenò, Frank
  Ch. Eigler, *Frederic Turgis, *Fredrik Östman, *Han Pingtian,
  Jim Keniston, Josh Stone, Lukas Berk, Mark Wielaard, *Otavio Pontes,
  *Peter Robinson, Srikar Dronamraju, Stan Cox, Timo Juhani Lindfors,
  *Wade Farnsworth, William Cohen

  Special thanks to Stan Cox for drafting these notes.
  Special thanks to new contributors, marked with '*' above.


= Examples of tested kernel versions

  3.3.0-rc1 (x86_64)
  3.2.0-0 (i686,x86_64)
  3.1.4-1 (i686,x86_64)
  3.0.0-1 (x86_64)
  2.6.41.4-1 (i686)
  2.6.40.4-6 (armv7l)
  2.6.38.6 (i686)
  2.6.35.14 (x86_64)
  2.6.32-220 (x86_64,i686,ppc64,s390x)
  2.6.18-274 (x86_64)
  2.6.9-101 (i686)


= Known issues with this release

- Some kernel crashes continue to be reported when a script probes
  broad kernel function wildcards.  (PR2725)

- Some kernel crashes have been reported when intensely probing many
  short-lived user-space programs with uprobes. (PR13634, in progress.)


= Bugs fixed for this release <http://sourceware.org/PR#####>

3217   compiled binary tracing
4794   backtrace of yyy_func3 and print_stack of yyy_func3 fails on ppc64.
5450   backtrace does not work for systemtap on s390x
5908   conversion test fails on arm
6503   permit probes on module .init and __exit functions
6961   backtrace from non-pt_regs probe context
10787  Probe exported functions only
10994  utrace-free task_finder
11209  Provide an alternative time tapset
11441  stap-server Roadmap to Legitimacy
11671  Allocate __stp_tf_vma_entry dynamically
11769  process.mark probes losing arguments
11775  ensure all tapsets are referenced in tapsets.tmpl
11859  print_ubacktrace() from kernel return probe prints kretprobe addresses
12135  field search is wrong when inheritance masks names
12136  @cast can't find namespaced types
12215  probe process functions defined in shared libraries
12221  Include build-ids in the script hash
12413  kprocess.* support PIDs but not TIDs
12741  rip-relative instruction is not detected as such
12773  invoke abrt-action-debuginfo-install --id=XXXXX if missing debuginfo
12888  stap-serverd should be weaned from -k
12895  stapconf should be using -nostdinc
12916  Aliased process probes aren't allowed for unprivileged
12947  Use of hardware watchpoint causing oops
13006  numa_faults.stp crashes 2.6.9 kernels
13026  staprun security bugs: CVE-2011-2502 CVE-2011-2503
13032  ring_buffer.c broken because ring_buffer_peek changed signature
13055  Replace kern_path_parent in runtime/procfs.c
13057  Provide a Command Line Option to Dump Supported Probe Points
13072  sdt.h STAP_PROBE doesn't build against gcc 3.4.6 on i386
13076  tweak module cache aging defaults & logic
13083  debug 3.1 kernel doesn't like mmput() in stap_utrace_attach
13100  Building tracepoint cache all at once fails when kernel debuginfo installed
13101  Networking tapsets should have structured comments
13102  nfs tapsets should have structured comments
13103  substr man page flubs 3rd arg
13107  simplify compile-server testsuite
13108  kprobing some paravirt stuff seems unsafe
13112  kprobing some port i/o stuff seems unsafe
13128  intermediate privilege between stapdev and stapusr
13132  buildok/pr10678.stp fails if system doesn't have ne2k-pci module
13133  sdt_misc.exp's wildcard criterion should be changed
13136  a guru-mode printk function
13142  Stopping script execution on Android (ARM) does not unload kernel module
13146  memory allocation can sleep
13155  conflicting tracepoint headers block stap -l / stap -p4
13156  improve hash_XXX.log
13158  rename_module.exp leaving module behind
13164  Deprecate process.function(number).inline
13200  apparent user-space memory corruption, unprivileged_myproc.exp
13210  vdso runtime tracking is broken
13216  AM_GNU_GETTEXT_VERSION needs a version
13241  too much dump-unwindsyms processing for modules even if !need_symbols
13261  syntax for global arrays activating map->wrap mode
13266  Implement DW_CFA_restore in the dwarf unwinder
13272  printf "quoting" broken
13274  standardize warning processing
13283  script -> C translator incorrect comparison (using ==) of kernel_string() operands
13284  failure to resolve kernel global e.g. jiffies
13289  %m/%M printf formatting operators access memory incorrectly
13306  option to skip probes with alias prologue problems
13312  on 2.6.18 s390x kernels, PTRACE_GET_LAST_BREAK isn't defined
13313  Can't parse SDT_V3 operand '(%rcx,%rax,8)'
13317  improve parse error recovery heuristics
13318  make it possible to set a default -DMAXMEMORY for unprivileged builds
13319  startup printk message omits stap -sNNN buffer sizes
13323  staprun should check return code from send_request when sending messages via the transport layer
13338  possible infinite recursion for process wildcard
13353  --remote arch/release maybe not respected for build-id calculations
13354  remote metadata / management
13373  FAILs for function.label(string) and new plt probe constructs in unprivileged myproc/probes tests
13386  BUG: using smp_processor_id() in preemptible code
13394  gcc 4.6 doesn't inline ibar for unprivileged testcase
13398  Allow Compile-Server Specs to Resolve to localhost and localhost.localdomain
13404  DTRACE_PROBE for more that 10 arguments needed
13428  nfsd.stp failure on f16 because of renamed kernel function
13440  cast.exp fails on s390x umod cast in (kernel) begin probe
13445  control.c:137: error: the frame size of 264 bytes is larger than 256 bytes
13458  sort generated tapset documentation
13460  expose all stap-serverd options to stap-server
13461  bring back systemtap-client subpackage
13462  symdata() returns ARM mapping symbols
13479  ARM tapset/scheduler.stp refers to kernel.function("__switch_to")
13496  stap could show some progress of the communication with the server
13499  prepare to deprecate grapher
13513  undo PR11759 for newer PREEMPT_RT kernels
13520  .systemtap/rc file
13536  staprun -u race condition
13539  occasional oops, kernel SEGV, RHEL5, :uprobes:uprobe_free_process+0xba/0x131
13546  improve map hashing
13626  gcc 4.7 doesn't compile sdt.h with -std=c++0x
13628  stap-prep script doesn't work in pt_BR environments
13631  Detection of Reqested Privilege Level in stap-serverd
13640  stap-server: don't start by default 


