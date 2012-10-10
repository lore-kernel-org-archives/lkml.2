Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab2JJBaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 21:30:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757243Ab2JJBad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 21:30:33 -0400
Message-Id: <201210100130.q9A1UKog003087@int-mx02.intmail.prod.int.phx2.redhat.com>
From: "Josh Stone" <jistone@redhat.com>
Date: Tue, 09 Oct 2012 18:30:20 -0700
To: lwn@lwn.net, linux-kernel@vger.kernel.org, -c@redhat.com,
        systemtap@sourceware.org
Subject: systemtap release 2.0
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The systemtap team announces release 2.0!

  prototype/preview dyninst backend, preprocessor macros, script
  privilege level conditionals, probe alias suffixes, revamped
  backtrace tapsets, tested on kernels 2.6.9 through 3.6.


= Where to get it

  http://sourceware.org/systemtap/ - our project page
  http://sourceware.org/systemtap/ftp/releases/systemtap-2.0.tar.gz
  http://koji.fedoraproject.org/koji/packageinfo?packageID=615
  git tag release-2.0 (commit a63381cc)

  There have been over 350 commits since the last release.
  There have been over 50 bugs fixed / features added since the last release.


= How to build it

  See the README and NEWS files at
  http://sourceware.org/git/?p=systemtap.git;a=tree
  Further information at http://sourceware.org/systemtap/wiki/


= Systemtap frontend (stap) changes

- A new --runtime option has been added to allow the user to choose
  between the existing kernel (--runtime=kernel) and the prototype
  dyninst (--runtime=dyninst) backends. See the sections "Systemtap
  runtime changes" and "Known issues" below for more information on
  the dyninst backend.


= Systemtap script language changes

- The systemtap preprocessor now has a simple macro facility as follows:

    @define add(a,b) %( ((@a)+(@b)) %)
    @define probegin(x) %(
       probe begin {
         @x
       }
    %)

    @probegin( foo = @add(40, 2); print(foo) )

  Macros defined in the user script and regular tapset .stp files are
  local to the file. To get around this, the tapset library can define
  globally visible 'library macros' inside .stpm files. (A .stpm file
  must contain a series of @define directives and nothing else.)

  The status of the feature is experimental; semantics of macroexpansion
  may change (unlikely) or expand in the future.

- Systemtap probe aliases may be used with additional suffixes
  attached. The suffixes are passed on to the underlying probe
  point(s) as shown below:

    probe foo = bar, baz { }
    probe foo.subfoo.option("gronk") { }
    // expands to: bar.subfoo.option("gronk"), baz.subfoo.option("gronk")

  In practical terms, this allows us to specify additional options to
  certain tapset probe aliases, by writing e.g.
    probe syscall.open.return.maxactive(5) { ... }

- Preprocessor conditional to vary code based on script privilege level:
  unprivileged -- %( systemtap_privilege == "stapusr" %? ... %)
  privileged   -- %( systemtap_privilege != "stapusr" %? ... %)
  or, alternately %( systemtap_privilege == "stapsys"
                  || systemtap_privilege == "stapdev" %? ... %)

  The "unprivileged" category corresponds to code that must be able to
  run in stapusr mode, while the "privileged" category corresponds to
  all other code (requiring privilege level stapsys or above).

- To ease migration to the embedded-C locals syntax introduced in 1.8
  (namely, STAP_ARG_* and STAP_RETVALUE), the old syntax can now be
  re-enabled on a per-function basis using the /* unmangled */ pragma:

    function add_foo:long(a:long, b:long) %{ /* unmangled */
      THIS->__retvalue = THIS->a + STAP_ARG_b;
    %}

  Note that both the old and the new syntax may be used in an
  /* unmangled */ function. Functions not marked /* unmangled */
  can only use the new syntax.

- Adjacent string literals are now glued together irrespective of
  intervening whitespace or comments:
    "foo " "bar" --> "foo bar"
    "foo " /* comment */ "bar" --> "foo bar"
  Previously, the first pair of literals would be glued correctly,
  while the second would cause a syntax error.


= Systemtap runtime changes

- Systemtap includes a new prototype backend, which uses Dyninst to instrument
  a user's own processes at runtime. This backend does not use kernel modules,
  and does not require root privileges, but is restricted with respect to the
  kinds of probes and other constructs that a script may use.

  Users from source should configure --with-dyninst and install a
  fresh dyninst snapshot such as that in Fedora rawhide.  It may be
  necessary to disable conflicting selinux checks; systemtap will advise.

  Select this new backend with the stap option --runtime=dyninst and a
  -c target process, along with normal options. (-x target processes
  are not supported in this prototype version.) For example:

    stap --runtime=dyninst -c 'stap -l begin' \
      -e 'probe process.function("main") { println("hi from dyninst!") }'

- To aid diagnoses in the event of a kernel panic, systemtap now uses
  the panic_notifier_list facility to dump a summary of its trace
  buffers to the serial console.

- Significant bug fixes to dwarfless kprobe behaviour. @entry() is now
  supported, and code such as

    stap -e 'probe kprobe.function("foo") !, kprobe.function("sys_read")

  now behaves correctly with non-existent functions. This allows the
  dwarfless syscall tapset nd_syscalls.stp to achieve approximate
  feature parity with the DWARF-enabled syscall tapsets.


= Systemtap tapset changes

- To support the possibility of separate kernel and dyninst backends,
  the tapsets have been reorganized into separate folders according to
  backend. Thus kernel-specific tapsets are located under linux/, the
  dyninst-specific ones under dyninst/

- The backtrace/unwind tapsets have been expanded to allow random
  access to individual elements of the backtrace. (A caching mechanism
  ensures that the backtrace computation run at most once for each
  time a probe fires, regardless of how many times or what order the
  query functions are called in.) New tapset functions are:
    stack/ustack - return n'th element of backtrace
    callers/ucallers - return first n elements of backtrace
    print_syms/print_usyms - print full information on a list of symbols
    sprint_syms/sprint_usyms - as above, but return info as a string

  The following existing functions have been superseded by print_syms()
  et al.; new scripts are recommended to avoid using them:
      print_stack()
      print_ustack()
      sprint_stack()
      sprint_ustack()

- The probefunc() tapset function is now myproc-unprivileged, and can
  now be used in unprivileged scripts for such things as profiling in
  userspace programs. For instance, try running
  systemtap.examples/general/para-callgraph.stp in unprivileged mode
  with a stapusr-permitted probe.

- New tapsets:
  linux/panic.stp  expose the kernel's panic() function to guru mode scripts

- Changed tapsets:
  linux/conversions.stp   added kernel_string[2]_utf[16/32] functions
  linux/uconversions.stp  ditto, but for user memory
  linux/nd_syscalls.stp   fix gaps in dwarfless support for various syscalls
  linux/syscalls.stp      ditto
  linux/syscalls2.stp     ditto
  linux/netfilter.stp     additional support for ARP packets


= Systemtap sample scripts

- All backtrace examples transitioned to use print_syms() et al.
  instead of print_stack() et al.

- New samples:
  alias_suffixes.stp  profiling example of simplifications with alias suffixes

- Changed samples:
  profiling/pf2.stp  make use of wrapping stats arrays
  profiling/pf3.stp  ditto


= Examples of tested kernel versions

  3.6.0 (i686, x86_64)
  3.5.4 (x86_64)
  3.5.3 (avmv7l)
  3.5.2 (armv7l)
  3.5.0 (armv7l)
  3.4.6 (x86_64)
  3.4.4 (x86_64)
  3.3.1 (i686)
  2.6.32 (x86_64)
  2.6.18 (i686)
  2.6.9 (i686)


= Known issues with this release

- Some kernel crashes continue to be reported when a script probes
  broad kernel function wildcards.  (PR2725)

- Some systems mount debugfs with mode 0700, which prevents non-root
  users from connecting to stap modules.  To work around this issue,
  try "chmod 0755 /sys/kernel/debug" as root.  (PR14245)

- The dyninst backend is still very much a prototype, with a number
  of issues, limitations, and general teething woes. For instance:
  + target process selection only supported via -c, not via -x
  + lack of support for multiarch/cross-instrumentation
  + tapset functions are very incomplete relative to what is supported
    when the kernel backend is active
  + exception handling becomes completely broken in programs
    instrumented by the current version of dyninst

  See dyninst/README and the systemtap/dyninst Bugzilla component
  (http://tinyurl.com/stapdyn-PR-list) if you want all the gory
  details about the state of the feature.


= Contributors for this release

  Alexander Lochmann*, Bryn M. Reeves, Chris Meek, Dave Brolley,
  David Smith, Dennis Gilmore*, Frank Ch. Eigler, Jiri Slaby*,
  Josh Stone, Mark Wielaard, Peter Robinson, Robin Lee*, Serguei
  Makarov, Stan Cox, Torsten Polle*, William Cohen

  Special thanks to new contributors, marked with '*' above.
  Special thanks to Serguei Makarov for drafting these notes.


= Bugs fixed for this release <http://sourceware.org/PR#####>

 6580  revamp backtrace-related tapset functions
11207  Support preprocessor macros
11424  dwarfless kprobe.* probes don't validate at translate time
11659  hook into kernel panic_notifier_list
12210  Allow extra suffixes on alias expansion
13451  tapset/nd_syscalls.stp:# FIXME: doesn't handle dup3
13452  tapset/nd_syscalls.stp:# FIXME: doesn't handle sys_eventfd2()
13453  tapset/nd_syscalls.stp:# FIXME: doesn't handle sys_inotify_init1()
13454  nd_syscall tapset needs to handle sys_pipe2 and pipe0/pipe1
13455  tapset/nd_syscalls2.stp:# FIXME: should prefer sys_signalfd4
13456  tapset/nd_syscalls.stp:# FIXME: doesn't handle sys_epoll_create1()
13486  pass-4 error (frame_base undeclared), inlined function argument
13489  support upstream inode-based uprobes
13693  make probefunc unprivileged
13814  retire PR13193 override
13934  hand-written assembly SDT probes fail to parse
14016  coverity warnings
14026  inode-uprobes should compute proper SET_REG_IP before probe invocation
14179  Reorganize the runtime to accommodate different backends
14180  Reorganize the tapsets to accommodate different backends
14230  on ia64, the conversions.exp tracepoint test hangs
14296  The blk.stp example fails occasionally
14313  rewrite alias example in langref.tex
14346  with inode-uprobes, the dtrace_vfork_exec test fails
14353  more than 1 syscall.dup2 probe alias in syscalls.stp
14360  parser: document string literal concatenation, drop /* */ treatment
14364  pagefault_disable use for other arches
14369  Markers with $vars are reported "not found" when missing debuginfo
14378  dwarfless kprobe return probes don't support @entry()
14394  on f17 x86_64, the 32-bit signal syscall/nd_syscall test fails
14396  Missing DW_ATE_UTF support (char16_t, char32_t)
14407  better buildid checking needed
14409  Delay inode-uprobes registration until after buildid checks
14425  no more stapfuncs man pages
14427  task_work changes need updated runtime support
14429  systemtap.spec too chatty with groupadd failures
14432  tempdir isn't always removed
14434  dwflpp sometimes caches incomplete class_type
14449  systemtap-server subpackage %post depends on systemtap-runtime
14452  make sys/sdt.h stop using 1ULL literal
14453  tolerate rhel6.3 kernel rpc* tracepoint headers that lack various decls
14460  nc (netcat) in rawhide (nmap-ncat) no workie properly with files
14463  scheduling while atomic" bug on rawhide
14467  on rawhide, getting "poison overwritten" kernel bug
14488  stapdyn runtime needs deref et al.
14489  Revamp probe metadata between modules and stapdyn
14524  pragma for pre-1.8 embedded-c mangling scheme
14535  stap-env should be in -server not -runtime
14546  DWARF unwinder can corrupt probe memory
14549  probefunc and print_ustack changes cause lots of exelib.exp failures
14560  cmd_parse.exp sometimes hangs or fails on EOF
14611  suppress bug#9740 workaround for unaffected kernels
14630  intermittent crash in lookup_bad_addr
14632  Some typos in documents
14642  pfiles.stp doesn't compile anymore because of missing FD_ISSET
14655  kallsyms_lookup_name is not exported by kernel versions prior to 2.6.33
14682  null deref during pmap_agg_overflow.exp test
