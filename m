Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab0CWACt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 20:02:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784Ab0CWACr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 20:02:47 -0400
To: systemtap@sourceware.org
Cc: linux-kernel@vger.kernel.org, lwn@lwn.net
Subject: systemtap 1.2 release notes
References: <4BA435EE.6080108@redhat.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Mon, 22 Mar 2010 20:02:37 -0400
In-Reply-To: <4BA435EE.6080108@redhat.com> (Josh Stone's message of "Fri, 19 Mar 2010 19:41:50 -0700")
Message-ID: <y0m7hp3x5uq.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The systemtap team announces release 1.2.

  prototype perf event and hw-breakpoint probing, security fixes,
  error tolerance script language extensions, optimizations, tapsets,
  interesting new sample scripts, kernel versions 2.6.9 through 2.6.34-rc

= Where to get it

  http://sourceware.org/systemtap/ - our project page
  http://sourceware.org/systemtap/ftp/releases/systemtap-1.2.tar.gz
  http://koji.fedoraproject.org/koji/packageinfo?packageID=615
  git tag release-1.2 (commit e36ba31aa5)

= How to build it

  See the README and NEWS files at
  http://sourceware.org/git/?p=systemtap.git;a=tree
  Further information at http://sourceware.org/systemtap/wiki/

= Systemtap frontend (stap) changes

- Tapset-related man pages have been renamed.  'man -k 3stap' should
  show the installed list, which due to prefixing should no longer
  collide over ordinary system functions.

- User space marker arguments no longer use volatile if the version of
  gcc, which must be at least 4.5.0, supports richer DWARF debuginfo.
  Use cflags -DSTAP_SDT_VOLATILE=volatile or -DSTAP_SDT_VOLATILE= when
  building the sys/sdt.h application to override this either way.

- A new command line flag '-W' forces systemtap to abort translation of
  a script if any warnings are produced.  It is similar to gcc's
  -Werror.  (If '-w' is also supplied to suppress warnings, it wins.)

- In order to limit potential impact from future security problems, the
  stap-server process does not permit its being launched as root.

= Systemtap script language changes

- Type-casting can now use multiple headers to resolve codependencies.
     @cast(task, "task_struct",
           "kernel<linux/sched.h><linux/fs_struct.h>")->fs->umask

- A new construct for error handling is available.  It is similar to c++
  exception catching, using try and catch as new keywords.  Within a
  handler or function, the following is valid and may be nested:
     try { /* arbitrary statements */ }
     catch (er) { /* e.g. println("caught error ", er) */ }

- A new predicate @defined is available for testing whether a particular
  $variable/expression is resolvable at translate time:
     probe foo { if (@defined($bar)) log ("$bar is available here") }
- Adjacent string literals are glued together, making this construct
  valid:
     probe process("/usr" @1 "/bin").function("*") { ... }

= Systemtap tapset changes

- Prototype support for "perf events", where the kernel supports the
  2.6.33 in-kernel API.  Probe points may refer to low-level 
  perf_event_attr type/config numbers, or to a number of aliases
  defined in the new perf.stp tapset:
     probe perf.sw.cpu_clock, perf.type(0).config(4) { }

- On recent kernels, for some architectures/configurations, hardware
  breakpoint probes are supported.  The probe point syntax is:
     probe kernel.data(ADDRESS).write
     probe kernel.data(ADDRESS).length(LEN).write
     probe kernel.data("SYMBOL_NAME").write

- Miscellaneous other additions:
  - atomic tapset for kernel atomic variables
  - nfsderror() function to translate NFS error numbers
  - more task_time and proc_mem variants
  - functions for accessing process command-lines

= New script examples

- general/varwatch.stp   Watch a variable changing value in a thread
- io/iodevstats.stp      List executables R/W the most data by device
- io/nfs_func_users.stp  Tally the NFS functions used by each process
- process/pfiles.stp     Print process file descriptors
- profiling/fntimes.stp  Show functions taking longer than usual

= Contributors for this release

  Charley Wang, Dave Brolley, David J. Wilder, David Smith, Eugene Teo,
  Eugeniy Meshcheryakov, Frank Ch. Eigler, Josh Stone, Mark Wielaard,
  Nobuhiro Tachino, Petr Muller, Prerna Saxena, Przemyslaw Pawelczyk,
  Roland McGrath, Stan Cox, Steve Dickson, Tim Moore, Wenji Huang,
  William Cohen

  Thanks to Josh Stone for compiling these notes.

= Examples of tested kernel versions

  2.6.9 (el4/i686)
  2.6.18 (el5/ia64/i686/x86_64)
  2.6.30.5 (f11/i686/x86_64)
  2.6.31 (f12/i686/x86_64)
  2.6.32.3 (rawhide/x86_64)
  2.6.34-rc1 (rawhide/x86_64)

= Known issues with this release

- When using the systemtap client and server udp port 5353 must be
  open in your firewall in order for the clent to find servers using
  avahi-browse.

- The stap-server may not be sufficiently robust to operate on an open
  untrusted network.

- Some kernel crashes continue to be reported when a script probes
  broad kernel function wildcards.

= Bugs fixed for this release

    909  perf counter events, perfmon? kernel API
   3859  SystemTap Control Library
   6954  ++ operations not triggering automatic global printing
   9737  test.tcl aborts testrun when using certain expect versions.
   9738  Running a stap script throws up compilation error
   9931  diagnostic aids for module cache collisions
  10257  sprint(@hist_*) doesn't parse
  10331  ssl certificate use error
  10435  Hardware breakpoint support
  10451  don't start client/server tests if avahi-daemon is not running
  10493  runtime/time.c: need autoconf for cpu_khz
  10641  -m NAME should be disabled in --unprivileged mode
  10690  need way to produce bigger procfs output
  10719  Implement constant-folding optimizations
  10747  preprocessor permits invalid construct
  10831  Preserve the derivation chain for sdt and label probes
  10835  stap-stop-server doesn't work for failed starts
  10848  enforcement of memory limits 
  10901  use AC_SYS_LARGEFILE or such for stat*64 use
  10905  stap-server initscript improvements
  11004  error catching syntax
  11005  @defined() predicate for compile-time $var error catching
  11059  No dtrace script documentation
  11075  RFE: -Werror
  11078  avoid procfs race condition
  11105  fix vulnerability of stap-server to spacious incoming arguments
  11114  librpm autoconf search too complex
  11124  user space markers inefficient due to volatile args
  11173  markers get a bad address in prelinked libraries
  11195  argument expansion needs better recursion protection
  11196  Retrieving variables from marker locations broken on x86_64
  11201  Distributed scripts should not be removed on clean
  11205  use assigned stap-server uid/gid 155/155 in systemtap.spec
  11208  auto-concatenate string literals
  11210  3stap man pages colliding with 3
  11220  arrays can't store MAXSTRINGLEN strings
  11223  procfs write probe problem
  11224  setting module arguments needs to be tested/documented
  11229  Error message for CONFIG_UTRACE could mention kernel headers
  11234  __get_argv can overflow its return buffer
  11246  Add better control over caching
  11256  harden --unprivileged mode
  11269  syscall.mmap decoding $fd incorrectly with MAP_ANONYMOUS
  11270  The 'nd_syscall' tapset needs a testcase
  11275  Don't print the full usage after command line error
  11277  _stp_text_str uses bad octal escapes
  11281  Negative -D value triggers ERROR: Safety pattern mismatch
  11282  FAIL: RUNTIME1 was cached
  11286  Client-only Arguments Passed to the Server
  11296  sdt.h test cases don't work from systemtap-testsuite rpm
  11309  ditch runtime/uprobes chmod in systemtap.spec
  11326  Can't optimize away bad $vars in return probes
  11336  procfs runtime code holding mutex too long
  11342  last_stmt is sometimes not available for errors
  11346  @defined() with '--skip-badvars' doesn't work correctly
  11352  sdt.exp kprobe tests FAIL with SEGV
  11360  Bad interaction between -L and @defined
  11363  no logrotate support for stap server log
  11364  cxxclass.exp fails with latest std.h and g++ (Red Hat 4.4.3-4)
  11366  @defined() and unoptimized stap -u don't work nicely together
  11370  multi-header @cast
  11372  proc_mem.stp needs better testing
  11402  pipe2 syscall not supported 
  11405  tolerate/ignore tapsets with syntax errors
  11406  Add dup2, epoll_create1, eventfd2, inotify_init1 and signalfd4 to syscall tapset
  CVE-2009-4273  stap-server command injection
  CVE-2010-0411  __get_argv() tapset fn buffer overflow
  CVE-2010-0412  stap-server command injection part 2

= Test results on various systems

- After running "sudo make installcheck" from the test suite, on a
  suitably equipped machine (kernel debugging data and other stuff
  installed), you should see 1000-1100 passes and a small handful of
  failures.  Those enjoying utrace in their kernels should see several
  hundred more passes.
