Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759183Ab0GVAOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 20:14:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759100Ab0GVAOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 20:14:15 -0400
Message-Id: <201007220014.o6M0E4cP009447@int-mx03.intmail.prod.int.phx2.redhat.com>
From: "Josh Stone" <jistone@redhat.com>
Date: Wed, 21 Jul 2010 17:14:04 -0700
To: systemtap@sourceware.org
Subject: SystemTap release 1.3
Cc: lwn@lwn.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The systemtap team announces release 1.3.

  integrated compile-server client, automatic structure
  pretty-printing, much faster & better stack backtraces (user and
  kernel space), interesting new sample scripts, prototype
  debuginfo-less <sys/sdt.h> userspace markers, kernel versions 2.6.9
  through 2.6.35-rc4

= Where to get it

  http://sourceware.org/systemtap/ - our project page
  http://sourceware.org/systemtap/ftp/releases/systemtap-1.3.tar.gz
  http://koji.fedoraproject.org/koji/packageinfo?packageID=615
  git tag release-1.3 (commit e12e958)

  There have been over 500 commits since the last release.
  There have been 106 bugs/features fixed since the last release.

= How to build it

  See the README and NEWS files at
  http://sourceware.org/git/?p=systemtap.git;a=tree
  Further information at http://sourceware.org/systemtap/wiki/

= Systemtap frontend (stap) changes

- A new integrated compile-server client is now available as part of stap.

  o 'stap --use-server ...' is equivalent to 'stap-client ...'
  o 'stap --list-servers' is equivalent to 'stap-find-servers'
  o 'stap --list-servers=online' is equivalent to 'stap-find-servers --all'
  o stap-client and its related tools will soon be deprecated.
  o the nss-devel and avahi-devel packages are required for building stap with
    the integrated client (checked during configuration).
  o nss and avahi are required to run the integrated client.

- The new "--ldd" option automatically adds any additional shared
  libraries needed by probed or -d-listed userspace binaries to the -d
  list, to enable symbolic backtracing through them.  Similarly, the
  new "--all-modules" option automatically adds any currently loaded
  kernel modules (listed in /proc/modules) to the -d list.

- By default the systemtap-runtime RPM builds now include a shared
  library, staplog.so, that allows crash to extract systemtap data from
  a vmcore image.

- Backward compatibility flags (--compatible=VERSION, and matching
  script preprocessing predicate %( systemtap_v CMP "version" %)
  and a deprecation policy are being introduced, in case future
  tapset/language changes break valid scripts.

- The <sys/sdt.h> user-space markers no longer default to an implicit
  MARKER_NAME_ENABLED() semaphore check for each marker.  To check for
  enabled markers use a .d declaration file, then:
     if (MARKER_NAME_ENABLED()) MARKER_NAME()

- Hyphenated <sys/sdt.h> marker names such as process(...).mark("foo-bar")
  are now accepted in scripts.  They are mapped to the double-underscore
  form ("foo__bar").

- More robust <sys/sdt.h> user-space markers support is included.  For
  some platforms (x86*, ppc*), this can let systemtap probe the markers
  without debuginfo.  This implementation also supports preserving
  the "provider" name associated with a marker:
    probe process("foo").provider("bar").mark("baz") to match
    STAP_PROBE<n>(bar, baz <...>)
  (Compile with -DSTAP_SDT_V1 to revert to the previous implementation.
  Systemtap supports pre-existing or new binaries using them.)

- User space marker arguments no longer use volatile if the version of gcc,
  which must be at least 4.5.0, supports richer DWARF debuginfo.  Use cflags
  -DSTAP_SDT_VOLATILE=volatile or -DSTAP_SDT_VOLATILE= when building
  the sys/sdt.h application to override this one way or another.

- New stap option -G VAR=VALUE allows overriding global variables
  by passing the settings to staprun as module options.

- The uprobes kernel module now has about half the overhead when probing
  NOPs, which is particularly relevant for sdt.h markers.

= Systemtap script language changes

- Iterating with "foreach" can now explicitly save the value for the loop.
     foreach(v = [i,j] in array)
       printf("array[%d,%s] = %d\n", i, j, v /* array[i,j] */)

- A new operator @entry is available for automatically saving an expression
  at entry time for use in a .return probe.
   probe foo.return { println(get_cycles() - @entry(get_cycles())) }

- Probe $target variables and @cast() can now use a suffix to print complex
  data types as strings.  Use a single '$' for a shallow view, or '$$' for a
  deeper view that includes nested types.  For example, with fs_struct:
   $fs$ : "{.users=%i, .lock={...}, .umask=%i,
            .in_exec=%i, .root={...}, .pwd={...}}"
   $fs$$ : "{.users=%i, .lock={.raw_lock={.lock=%u}}, .umask=%i, .in_exec=%i,
             .root={.mnt=%p, .dentry=%p}, .pwd={.mnt=%p, .dentry=%p}}"

- Embedded-C may be used within expressions as values, when in guru mode:
     num = %{ LINUX_VERSION_CODE %}               // int64_t
     name = %{ /* string */ THIS_MODULE->name %}  // const char*
     printf ("%s %x\n", name, num)
  The usual /* pure */, /* unprivileged */, and /* guru */ markers may be used 
  as with embedded-C functions.

- Probe wildcards can now use '**' to cross the '.' separator.
     $ stap -l 'sys**open'
     syscall.mq_open
     syscall.open

- A new procfs parameter .umask(UMASK) which provides modification of
  file permissions using the proper umask value.  Default file
  permissions for a read probe are 0400, 0200 for a write probe, and
  0600 for a file with a read and write probe.

= Systemtap tapset changes

- It is now possible in some situations to use print_ubacktrace() to
  get a user space stack trace from a kernel probe point. e.g. for
  user backtraces when there is a pagefault:
  $ stap -d /bin/sort --ldd -e 'probe vm.pagefault {
      if (pid() == target()) {
         printf("pagefault @0x%x\n", address); print_ubacktrace();
      } }' -c /bin/sort
  [...]
  pagefault @0x7fea0595fa70
   0x000000384f07f958 : __GI_strcmp+0x12b8/0x1440 [libc-2.12.so]
   0x000000384f02824e : __gconv_lookup_cache+0xee/0x5a0 [libc-2.12.so]
   0x000000384f021092 : __gconv_find_transform+0x92/0x2cf [libc-2.12.so]
   0x000000384f094896 : __wcsmbs_load_conv+0x106/0x2b0 [libc-2.12.so]
   0x000000384f08bd90 : mbrtowc+0x1b0/0x1c0 [libc-2.12.so]
   0x0000000000404199 : ismbblank+0x39/0x90 [sort]
   0x0000000000404a4f : inittables_mb+0xef/0x290 [sort]
   0x0000000000406934 : main+0x174/0x2510 [sort]
   0x000000384f01ec5d : __libc_start_main+0xfd/0x1d0 [libc-2.12.so]
   0x0000000000402509 : _start+0x29/0x2c [sort]
  [...]

- New tapset functions to get a string representation of a stack trace:
  sprint_[u]backtrace() and sprint_[u]stack().

- New tapset function to get the module (shared library) name for a
  user space address umodname:string(long). The module name will now
  also be in the output of usymdata() and in backtrace addresses even
  when they were not given with -d at the command line.

- Kernel backtraces are now much faster (replaced a linear search
  with a binary search).

- A new family of set_kernel_* functions make it easier for gurus to write
  new values at arbitrary memory addresses.

- The tapset alias 'syscall.compat_pselect7a' was misnamed.  It should
  have been 'syscall.compat_pselect7' (without the trailing 'a').
  Starting in release 1.4, the old name will be deprecated.

= New script examples

- profiling/errno.stp      Show which processes and system calls
                           return errors most frequently
- io/deviceseeks.stp       Histograms of seek behavior for each device
- process/noptrace.stp     Disable ptrace(2) from hierarchies of processes
- general/sizeof.stp       Print the size of a C type
- profiling/linetimes.stp  Show time spent on each line if a function
- process/cycle_thief.stp  Track IRQs and other processes stealing
                           cycles from a task
- general/para-callgraph-verbose.stp  Verbose callgraph tracing

= Contributors for this release

  Adrien Kunysz*, Charley Wang, Dave Brolley, David Smith,
  Don Domingo, Frank Ch. Eigler, Josh Stone, Lars R. Damerow*,
  Lukas Berk*, Mark Wielaard, Przemysław Pawełczyk, Rayson Ho*,
  Roland McGrath, Srikar Dronamraju, Stan Cox, Tom Callaway*,
  Tony Jones*, Wenji Huang, William Cohen

  Special thanks to new contributors, marked with '*' above.

  Thanks also to David Smith for compiling these notes.

= Examples of tested kernel versions

  2.6.9 (el4/i686)
  2.6.18 (el5/ia64/i686/x86_64)
  2.6.32 (el6/i686/x86_64)
  2.6.32 (f12/i686/x86_64)
  2.6.33 (f13/i686/x86_64)
  2.6.35-rc4 (rawhide/x86_64)

= Known issues with this release

- When using the systemtap client and server udp port 5353 must be
  open in your firewall in order for the clent to find servers using
  avahi-browse.

- The stap-server may not be sufficiently robust to operate on an open
  untrusted network.

- Some kernel crashes continue to be reported when a script probes
  broad kernel function wildcards.

= Bugs fixed for this release

   1155  inline function parameters
   2168  incomplete translation of histogram bucket foreach
   2228  benchmark suite
   3672  Support formatted dump of struct $pointers
   3833  nfs_proc.stp and LKET/nfs_proc.stp tapset files broken
   4396  script to dump hung task's kernel stack
   4529  tapset coverage option
   4978  need better printf() documentation
   5151  rpc-all-probes.stp fails on 2.6.23-rc9 kernel
   5621  RFE: support for a general buffer kread()
   5949  instruction/block tracing for userspace
   6582  register() needs pt_regs check
   6731  improve -l (listing mode) to list probe/alias variables
   6739  global alias cache too slow
   6819  stapprobes(5) - syntactically (in)valid probepoints
   6826  shorthand or variable for probed executable's path
   6898  marker $$args / $$parms
   6902  optimize use of elfutils offline module search
   7030  signal tapset may be referring to inline functions.
   7070  registration error (rc -22), module probes, missing reloc info
   9958  Provide a way for C tapset functions to assert guru mode
   9998  Update tapset/i686/registers.stp per pt_regs change
  10023  Examples showing kernelpoint use
  10025  wildcards lose when embedded in conditional %(%) expressions
  10054  improve $expr->foo->bar->zoo error messages
  10065  Create modules for Hardware Breakpoint
  10080  track vdso for process symbols/backtrace
  10115  Regression with inet_sock @cast from 0.9 to 0.9.7 on 2.6.9 kernel
  10228  Add more vma-tracking for user space symbol/backtraces
  10245  Allow "-" in static marker names
  10327  follow symbol aliases for debuginfo search
  10393  sdt.exp utrace tests fail on 2.6.31 rawhide kernel
  10599  Always print module/map names for kernel/executable addresses
  10665  backtrace() is too slow
  10830  new pp() variant for source-level probe point name
  10913  bad/misleading translator error message
  10943  Support generic @entry saving in .return probes
  10978  Getting the size of a data type
  11095  Support "provider" for mark() probes
  11222  ABRT interface
  11266  var_expanding_visitor barfs on non-assignment lvalues
  11274  stap-client doesn't understand "--"
  11340  directly-accessed tracepoint args are surviving target_symbols
  11343  backward compatibility flags/conditionals
  11373  let stap-client use cache
  11399  Allow ** in matching probe points
  11425  probefunc() broken when used with kprobe.function
  11427  systemtap 1.2 does not compile on sparc/sparc64
  11443  Add a "list unprivileged" option to stap
  11446  Server installed by systemtap-server rpm should be locally trusted
  11455  use XDG_DATA_DIRS for tapset path searching
  11457  unresolved *mib_filter_key functions
  11473  Support optional "VALUE =" in foreach loops
  11474  iotop example is very slow in pass-2
  11480  bad kfail for rpc-all-probes.stp test
  11498  don't have a cow with oversize debug_frame
  11508  automate -d option for shared library searching
  11514  nd_syscall.exp takes 10 times longer than syscall.exp testcase
  11553  need better message for return probe on inline function
  11556  @cast() with array indexing on pointers
  11566  embedded-C expressions
  11573  uprobe_get_pc, sayonara
  11575  TRYLOCKDELAY too short
  11590  optimized pre/postfix operators throw away initial assignment
  11592  sdt.h should have a 'disable-semaphores' override option
  11598  @defined() should allow the address-of operator "&"
  11599  Support data pointer in tracepoint callbacks
  11609  -d ALL_LOADED_MODULES option
  11617  Gluing string literals doesn't work with token substitution
  11641  FAIL: fib (19 1) backtrace from uretprobe fails
  11649  workarounds for incomplete kernel include/linux/events/*.h decls
  11661  recvmmsg missing from syscall tapset
  11663  switch to embedded-c-expressions for kernel-marker tapset functions
  11664  try-catch squashes normal exits from next/return
  11665  umodname tapset function
  11672  utrace_report_syscall_exit crash
  11678  stap -d /bin/prog --ldd doesn't pick up ld.so
  11680  Systemtap build broken on PPC64
  11684  eliminate duplication between language reference guide and tapset docs
  11690  Semaphores are broken under STAP_SDT_V2
  11698  stap fails to figure out powerpc function aliases
  11706  unautoconfiscation of most stap*.in man pages
  11707  on ppc, all nd_syscall probes fail
  11708  SDT on i686 is register-poor
  11710  on s390x, all nd_syscall probes fail
  11713  listing of available $variables should include $
  11719  on ppc, the cmd_parse.exp and preprocessor.exp test fail
  11721  the usymbols.exp testcase shouldn't touch '__user' memory directly
  11722  on ppc, usymbols.exp should be probing syscall.rt_sigaction32
  11723  transok/buildko.stp fails incorrectly
  11725  on RHEL5 ppc, systemtap.printf/bin6.exp fails
  11726  on ppc, systemtap.printf/memory1.exp fails with compile errors
  11727  the systemtap.server/server.exp testcase reports invalid failures
  11729  option for procfs files to specify permissions
  11752  on ppc, the signal.handle_signal tapset alias needs to be updated
  11761  stap -L 'kernel.mark("*")' only lists $arg1..$argN variables
  11762  the systemtap.base/flightrec*.exp tests randomly fail
  11771  on ppc, the syscall.pipe tapset alias fails when accessing pipe0/pipe1
  11775  ensure all tapsets are referenced in tapsets.tmpl
  11778  sprint_ustack & sprint_stack 
  11785  some $foo$ pretty-printing bugs
  11808  loc2c unfinished chain from a struct $return
  11809  loc2c vs empty piece
  11815  SDT_V2 sdt.h broken for modern gcc on x86-64, cxxclass.exp
  11821  SDT_V2 dwarfless ambiguities with powerpc // -mno-regnames
  11825  The piece we want is part of a computed value!

= Test results on various systems

- After running "sudo make installcheck" from the test suite, on a
  suitably equipped machine (kernel debugging data and other stuff
  installed), you should see 1400-1600 passes and a small handful of
  failures.  On a machine without kernel utrace support, you should
  see 800-1000 passes.

*** Hark! A gopher's spiffy crankshaft! ***
