Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722Ab2FQRgU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 13:36:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757629Ab2FQRgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 13:36:18 -0400
Date: Sun, 17 Jun 2012 13:35:55 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: systemtap@sourceware.org
Cc: linux-kernel@vger.kernel.org, lwn@lwn.net
Subject: systemtap release 1.8
Message-ID: <20120617173555.GA27325@redhat.com>
Reply-To: systemtap@sourceware.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The systemtap team announces release 1.8.

  user-space probing support with unmodified linus kernel 3.5-rc,
  kernel netfilter-hook probing, ipv6 support in tapsets and
  compile-server, concurrent compilations in compile-server, improved
  dwarf4 support (.debug_types), @var() construct for accessing
  variables in global scope, stap resource-limit options, tested on
  kernels 3.5-rc through 2.6.9


= Where to get it

  http://sourceware.org/systemtap/ - our project page
  http://sourceware.org/systemtap/ftp/releases/systemtap-1.8.tar.gz
  http://koji.fedoraproject.org/koji/packageinfo?packageID=615
  git tag release-1.8 (commit 48fa6b5e)

  There have been over 300 commits since the last release.
  There have been over 50 bugs/features fixed since the last release.


= How to build it

  See the README and NEWS files at
  http://sourceware.org/git/?p=systemtap.git;a=tree
  Further information at http://sourceware.org/systemtap/wiki/


= Systemtap frontend (stap) changes

- When invoked by systemtap, the kbuild $PATH environment is sanitized
  (prefixed with /usr/bin:/bin:) in an attempt to exclude compilers
  other than the one the kernel was presumed built with.

- The systemtap compile-server and client now support IPv6 networks.

- Support for DWARF4 .debug_types sections (for executables and shared
  libraries compiled with recent GCC's -gdwarf-4 / -fdebug-types-section).
  PR12997.  SystemTap now requires elfutils 0.148+, full .debug_types support
  depends on elfutils 0.154+.

- Systemtap modules are somewhat smaller & faster to compile.  Their
  debuginfo is now suppressed by default; use -B CONFIG_DEBUG_INFO=y to
  re-enable.

- Stap now has resource limit options:
    --rlimit-as=NUM
    --rlimit-cpu=NUM
    --rlimit-nproc=NUM
    --rlimit-stack=NUM
    --rlimit-fsize=NUM
  All resource limiting has been moved from the compile server to stap
  itself. When running the server as "stap-server", default resource
  limit values are specified in ~stap-server/.systemtap/rc.


= Systemtap script language changes

- @var now an alternative language syntax for accessing DWARF variables
  in uprobe and kprobe handlers (process, kernel, module). @var("somevar")
  can be used where $somevar can be used. The @var syntax also makes it
  possible to access non-local, global compile unit (CU) variables by
  specifying the CU source file as follows @var("somevar@some/src/file.c").
  This will provide the target variable value of global "somevar" as defined
  in the source file "some/src/file.c". The @var syntax combines with all
  normal features of DWARF target variables like @defined(), @entry(),
  [N] array indexing, field access through ->, taking the address with
  the & prefix and shallow or deep pretty printing with a $ or $$ suffix.

- Printf formats can now use "%#c" to escape non-printing characters.

- Pretty-printed bitfields use integers and chars use escaped formatting
  for printing.

- SystemTap now mangles local variables to avoid collisions with C
  headers included by tapsets. This required a change in how
  embedded-C functions access local parameters and the return value slot.
  If you need to run code which uses the old THIS-> notation, run stap
  with the --compatible=1.7 option.


= Systemtap runtime changes

- There is updated support for user-space probing against kernels >=
  3.5, which have no utrace but do have the newer inode-uprobes work
  by Srikar Dronamraju and colleagues.  For kernels < 3.5, the
  following 3 sets of kernel patches would need to be backported to
  your kernel to use this preliminary user-space probing support:
  - inode-uprobes patches:
  - exec tracepoint kernel patch:
  - task_work_add kernel patches:

- staprun accepts a -T timeout option to allow less frequent wake-ups
  to poll for low-throughput output from scripts.

- Previous fix for bug CVE-2012-0875 (kernel panic when processing malformed
  DWARF unwind data) is merged.

- The systemtap compile-server now supports multiple concurrent connections.
  Specify the desired maximum number of concurrent connections with
  the new stap-server/stap-serverd --max-threads option. Specify a
  value of '0' to tell the server not to spawn any new threads (handle
  all connections serially in the main thread). The default value is
  the number of processor cores on the host.


= Systemtap tapset changes

- The following tapset functions are deprecated in release 1.8 and will be
  removed in release 1.9:
      daddr_to_string()

- All functions were updated for the new STAP_ARG* embedded-C API.

- More tapsets were added to the generated reference documentation /
  man pages.

- New tapsets:
  netfilter.stp          defines utilities for netfilter scripts
  guru-delay.stp         inject mdelay/udelay into kernel operation

- Changed tapsets:
  syscalls.stp etc.      updated for linux 3.5-rc
  dentry.stp             updated for rhel5, back to the future
  context-caller.stp     fixed to operate without uretprobes
  s390/registers.stp     support getting that pesky sixth syscall arg
  inet_*.stp             make more available to unprivileged users
  inet_*.stp             expose ipv6 addresses & functionality


= Systemtap sample scripts

- All functions were updated for the new STAP_ARG* embedded-C API.

- New samples:
  netfilter_drop.stp     netfilter demo: dropping some outgoing packets
  netfilter_summary.stp  show TCP/IP traffic by src/dest address
  psig.stp               list active signal handlers of a process
  auditbt.stp            generate userspace backtraces on kernel audit events
  nfsdtop.stp            print nfs lookup operation summaries
  pf3.stp                time-sampling-based profile of kernel+userspace
  enospc.stp             generate syslog message on filesystem -ENOSPC

- Changed samples:
  varwatch.stp           produces narrower output
  eventcount.stp         given new options to periodically monitor/sort
  mm*.stp                updated for upstream mm kernel tracepoints
  ioblktime.stp          tries harder to catch merged iorequests
  pfiles.stp             avoid non-atomic memory allocation


= Contributors for this release

  Andreas Müller*, Bryn M. Reeves, Chris Meek, Dave Brolley, David
  Smith, Eugene Teo, Felix Lin*, Frank Ch. Eigler, Frederic Turgis,
  Josh Stone, Lukas Czerner*, Mark Wielaard, Negreanu Marius Adrian*,
  Nitin A Kamble*, Serguei Makarov*, Stan Cox, Timo Juhani Lindfors,
  Tom Tromey*, Wade Farnsworth, William Cohen, ch huang*

  Special thanks to new contributors, marked with '*' above.


= Examples of tested kernel versions

  3.5-rc (x86_64)
  3.3.0 (x86_64)
  3.2.0 (x86_64)
  3.1.0 (x86_64)
  2.6.32 (x86_64,i686,ppc64,s390x)
  2.6.18 (x86_64,i686)
  2.6.9 (i686)


= Known issues with this release

- Some kernel crashes continue to be reported when a script probes
  broad kernel function wildcards.  (PR2725)


= Bugs fixed for this release <http://sourceware.org/PR#####>

10299  mangle local variable names
11763  on s390x, nd_syscall probes that use $arg6 fail
12331  offer a --sysroot option to aid cross-compiling
12341  deref()/store_deref() variations between arches
13193  Running bz6503.exp results in unresponsive/crashed machine
13370  ipv6 support
13458  sort generated tapset documentation
13461  bring back systemtap-client subpackage
13474  SDT_V3 arm can't parse operand '4@[fp, #-16]'
13475  SDT_V3 arm can't parse operand '-4@r3'
13516  more robust handling of ^C
13609  Consider handling compiler server requests in parallel
13631  Detection of Reqested Privilege Level in stap-serverd
13640  stap-server: don't start by default
13641  pfiles.stp does something nasty
13644  staprun: support --version
13646  ipv6 tapset support
13661  server softening: allow relaxed rlimits
13667  expose netfilter hook
13670  on 3.3 kernels, 'mnt_parent' has been moved from 'struct vfsmount'
13672  on 3.3 kernels, the ioscheduler.stp tapset can't find elevator names
13681  on rhel4, bulk mode flight recording tests leave a module behind
13694  on rhel6, tcp.sendmsg returns incorrect "sock" local variable
13713  MAXTRACE/MAXBACKTRACE undocumented feature
13714  panic when sampling backtrace() in timer.profile
13734  systemtap.stress/current.stp need to be updated for arm
13745  memory tracepoints examples need updating
13768  systemtap.spec Requires should reflect current packaging
13784  Cannot find a defining variable location in different CU
13815  On RHEL5 (2.6.18-308.el5), the dentry.stp tapset is broken
13819  A Call Trace is generated when stap is run if the kernel option "Debug access to per_cpu maps" is enabled
13833  function().library() is not aware of rpath
13868  Use UTRACE_ATTACH_ATOMIC when calling utrace create under lock.
13876  miscompilation for duplicated tapset function
13992  assertion failure on bad stap -d /paths
13998  pretty-printing bitfields shouldn't use %c
13999  pretty-printing shouldn't use %c
14000  crosscompiled uprobe target filename doesn't have the sysroot path removed.
14005  don't freak on overlong kernel module relocs
14057  ERROR: Your privilege credentials (stapsys) are insufficient to run this module (stapdev required).
14078  librpmio.so exports bundled broken glob(3) clone
14079  caller() pass-4 error if no uretprobes in script
14107  Bad user unwinding from kernel fatal signal handler for some x86_64 kernels
14137  buildok/netfilter02.stp not ok
14146  tapset::* man pages should be generated from actual tapset files
14165  netfilter.stp -- extract IPV6 protocol info
14168  sanitize environment better for invoking kernel-module-builder make
14208  Retire obsolete handwritten manpages
14220  stap failes with "error: ...cpu_possible_map undeclared..."
14221  timer.profile probes cause kernel warning
14224  only the 1st of multiple identical perf probes get hit
14240  on RHEL5 (2.6.18-308.el5), netfilter probe cause compilation to fail
14244  Mode 0700 debugfs leads staprun to orphan modules
