Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab0ESBnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:43:00 -0400
Received: from mail.windriver.com ([147.11.1.11]:41221 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921Ab0ESBkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:40:21 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [GIT PULL] kdb / early debug (1 of 2) for 2.6.35
Date: Tue, 18 May 2010 20:39:10 -0500
Message-Id: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
X-OriginalArrivalTime: 19 May 2010 01:39:40.0656 (UTC) FILETIME=[262F2F00:01CAF6F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus please pull the kdb-merge tree which merges the kdb front end
into the kernel debug core for 7 architectures.

git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git kdb-merge

--- Notes for Linus ---

Because I touched numerous files outside the kernel debugger I tried
to get sign off from other maintainers.  I received acks and review
comments for everything but the changes to arch/x86/kernel/traps.c
changes in which case I received no response at all.  The code is
#ifdef'ed such that if you do not use a kernel debugger, there is no
impact.

I split the kdb and early debug functionality into 2 trees.  If you
are ok with both trees, you can just pull:

git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus

--- End Notes for Linus ---

This patch set is the same as the pull request for the 2.6.34 kernel
with minor context updates.

Originally this was 3 separate patch sets.

At the present time the atomic kernel mode setting patch set is in
review by the drm maintainers and may or make not make the merge
window.

The history of the combined 3 sets of patches follows.

The kdb / kgdb functionality is considered stable.  The patch set has
been in linux-next for several months, following the completion of the
prototype phase which consisted of porting the original SGI maintained
kdb v4.4 into the kernel debug core and polling I/O hooks.  There are
several people in the community actively making use of the patches.

You can preview the documentation at:

http://kernel.org/pub/linux/kernel/people/jwessel/kdb/

Differences in the final patch set vs v3:

  * All controversial patches were dropped
     o The kms series was dropped entirely
     o Modifications to panic.c were dropped
  * All the lockless changes to si_meminfo and swap info were dropped
  * The ppc debug handler was made permanent instead of an #ifdef
  * Acks added for blackfin, mips, printk.c, and dbgp modifications

Differences in the V3 patch set:

* The ARM hooks were dropped and implemented another way by RMK
* X86 hw breakpoint regression patches were merged in 2.6.33-rc7
* All the NR_CPUS arrays were factored out of the kdb shell
* The kdb init was divided into an early and late section
  to allow extended commands definitions to use kernel memory
  allocator
* The KMS debugger API function names were updated for consistency
* Several minor bugs fixed in the kdb shell with the pager
* The early debug series was added to kgdb-next
  * Allows early hardware breakpoints and trap on X86
  * Allows kgdb and kdb over the EHCI USB Debug Port
  * Allows kdb debugging in conjunction with earlyprintk=vga

Differences in the V2 patch set:

* All the code is now in linux-next via kgdb-next
  * 6 different build breakages were repaired around different .config
    options not compiling
  * kms / kdb / kgdb was built tested as kernel modules
* The kdb core was split into 2 patches, 1 for the core, and one for all
  the files touched outside the kdb core
* kdb_seq_printf added to eliminate the duplicate meminfo commands in procfs
* kdb breakpoint code refactored to remove unused globals and struct members
* Fixed the possibility to loop infinitely in the kdb md command
* Cleaned up the kdb kernel/modules.c patch
* Removed the unused kdb report helper function in kernel/sched.c
* HW instruction and data access breakpoints implementation completed
* The kdb keyboard code no longer modifies include/linux/keyboard.h
* The kernel_probe_read and kernel_probe_write were cleaned up for blackfin
* The blackfin arch specific kgdb implementation was cleaned up and merged
* The debug core now turns off tracing while the kernel debugger is active
* New in the series is a command for kdb called ftdump, which allows
  dumping the ftrace buffer
* kdb will automatically set the correct number of rows on the display
  via the information from the vt_console when using kms
* There is preliminary documentation for kdb and kms
* The drm hacks patch is still a hack, but cleaned up and using macros

The acks were added for the blackfin, sparc and sh arch specific code by the
respective maintainers.


Differences in the V1 patch set vs the RFC:

Back in May 2009 an initial kdb prototype was posted to lkml as an RFC
to see if there was sufficient interest to merge kdb and kgdb together.

There was enough interest to continue on with the project, and it is
now in a state where further work can occur to review, and hopefully
merge the code into a future kernel.

If this is the first time you have heard about kgdb or kdb, you might
consider taking a look at the presentation slides from LPC 2009.

http://kgdb.wiki.kernel.org/index.php/Main_Page#Linux_Plumbers_Conference_presentation_2009

The code included in this series does not include any of the USB code
referenced in the presentation.

Several changes have occurred since the original prototype was posted.
All of the architectures using the kgdb core today have had the
functions implemented to make use of the kdb shell.  This list
includes x86, arm, ppc, mips, sh, sparc, and blackfin.  The proposed
atomic kernel modesetting project now has an initial implementation
for the intel i915 driver, and it should be possible to add atomic
mode setting hooks for any other video driver which makes use of
builtin kernel mode setting.  All the dead code and functions that
were not previously implemented in the RFC have been removed or
implemented.

The directory of the kernel debugger changed as well.  All the kernel
debugger pieces, the debug core, gdbstub and kdb now live under
kernel/debug.

While the patch set may be slightly large, it is broken down into
logical, incremental functionality.  Only the first 12 patches are
needed to see kdb in action on a serial port which has a kgdboc driver
for example.

It is important to understand that this work was directly derived from
the original kdb, and the intent is to deprecate the out of tree kdb
and move all its functionality to this code base.  This version of kdb
is completely wired into the debug core and the kgdboc polled I/O
model using the same API used by the gdbstub (which people call kgdb).

The kdb front end in this patch series works a little differently than
if you were to take the original kdb patch set from:

ftp://oss.sgi.com/projects/kdb/download/v4.4/

In the kernel .config you should enable the following options:

CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
CONFIG_KGDB_LOW_LEVEL_TRAP=y
CONFIG_KGDB_KDB=y
CONFIG_KDB_KEYBOARD=y

To use kdb with a serial port you would use the kgdb/kgdboc way of
doing things.  You would used a kernel command line with:

   console=ttyS0,115200 kgdboc=ttyS0 kgdbwait

That will get you access to kdb just after the console has been
registered.  If you want to use the keyboard, you could use the
following (NOTE it is kbd and not kdb, kbd is short for keyboard):

   console=tty0 kgdboc=kbd kgdbwait

You can also use the keyboard and or serial console:

   console=ttyS0,115200 console=tty0 kgdboc=kbd,ttyS0


In terms of breaking into the debugger after the system is up, you
must use the sysrq-g sequence.  That means you could run:
   echo g > /proc/sysrq-trigger

Or you can use the SysRq key on your key board.  On a typical laptop
you might have to do the following:

press and hold ALT    -- You will be holding this the whole time
press and hold FN
press and release the key with the SysRq label
release FN
press and release g
release ALT

Once you are in kdb you can run help to see a limited list of
commands.

You can also still connect gdb or re-enter kdb without leaving the
exception state, if you are using a serial port.  To get out of kgdb
mode you can type "$3#33", or to get into kgdb mode from kdb, you can
type "kgdb".

>From gdb you can issue commands to the kdb front end, via gdb's
monitor command.  For instance you could issue "monitor lsmod".
Allowing the gdb monitor extension was certainly another motivation
behind the prototype.

Included among the kdb patches are some kgdb specific fixes for the
next kernel merge window, and if kdb were to not make the cut, these
patches will be split out of the series.  Anything too ugly for a
possible merge is also a candidate to get removed from the series.

Thanks,
Jason.

---

The following changes since commit e40152ee1e1c7a63f4777791863215e3faa37a86:
  Linus Torvalds (1):
        Linus 2.6.34

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git kdb-merge

Jason Wessel (25):
      Move kernel/kgdb.c to kernel/debug/debug_core.c
      Separate the gdbstub from the debug core
      MAINTAINERS: update kgdb, and debug_core info
      kgdb,sparc: Add in kgdb_arch_set_pc for sparc
      kgdb,sh: update superh kgdb exception handling
      kgdb,blackfin: Add in kgdb_arch_set_pc for blackfin
      kdb: core for kgdb back end (1 of 2)
      kdb: core for kgdb back end (2 of 2)
      kgdb: core changes to support kdb
      kgdb,8250,pl011: Return immediately from console poll
      sh,sh-sci: Use NO_POLL_CHAR in the SCIF polled console code
      sparc,sunzilog: Add console polling support for sunzilog serial driver
      kgdb: gdb "monitor" -> kdb passthrough
      kgdboc,keyboard: Keyboard driver for kdb with kgdb
      kgdb,docs: Update the kgdb docs to include kdb
      kgdb: remove post_primary_code references
      x86,kgdb: Add low level debug hook
      powerpc,kgdb: Introduce low level trap catching
      mips,kgdb: kdb low level trap catch and stack trace
      kgdb: Add the ability to schedule a breakpoint via a tasklet
      kgdboc,kdb: Allow kdb to work on a non open console port
      printk,kdb: capture printk() when in kdb shell
      debug_core,kdb: Allow the debug core to process a recursive debug entry
      MAINTAINERS: update kgdb, kdb, and debug_core info
      kdb,debug_core: Allow the debug core to receive a panic notification

 Documentation/DocBook/kgdb.tmpl       |  692 ++++++--
 Documentation/kernel-parameters.txt   |   14 +-
 MAINTAINERS                           |    6 +-
 arch/arm/include/asm/kmap_types.h     |    1 +
 arch/arm/kernel/kgdb.c                |    5 +
 arch/blackfin/kernel/kgdb.c           |    5 +
 arch/mips/include/asm/kgdb.h          |    2 +
 arch/mips/kernel/kgdb.c               |   27 +-
 arch/mips/kernel/traps.c              |   13 +
 arch/powerpc/include/asm/kmap_types.h |    1 +
 arch/powerpc/kernel/kgdb.c            |   11 +-
 arch/powerpc/kernel/traps.c           |    7 +-
 arch/sh/kernel/kgdb.c                 |   14 +-
 arch/sparc/kernel/kgdb_32.c           |    6 +
 arch/sparc/kernel/kgdb_64.c           |    6 +
 arch/x86/include/asm/kgdb.h           |    3 +
 arch/x86/kernel/kgdb.c                |   56 +-
 arch/x86/kernel/traps.c               |    6 +
 drivers/serial/8250.c                 |    4 +-
 drivers/serial/amba-pl011.c           |    6 +-
 drivers/serial/kgdboc.c               |   75 +-
 drivers/serial/sh-sci.c               |    6 +-
 drivers/serial/sunzilog.c             |   50 +
 include/asm-generic/kmap_types.h      |    3 +-
 include/linux/kdb.h                   |  117 ++
 include/linux/kgdb.h                  |   41 +-
 include/linux/serial_core.h           |    1 +
 init/main.c                           |    2 +
 kernel/Makefile                       |    2 +-
 kernel/debug/Makefile                 |    6 +
 kernel/debug/debug_core.c             |  967 +++++++++++
 kernel/debug/debug_core.h             |   81 +
 kernel/debug/gdbstub.c                | 1017 ++++++++++++
 kernel/debug/kdb/.gitignore           |    1 +
 kernel/debug/kdb/Makefile             |   25 +
 kernel/debug/kdb/kdb_bp.c             |  564 +++++++
 kernel/debug/kdb/kdb_bt.c             |  210 +++
 kernel/debug/kdb/kdb_cmds             |   35 +
 kernel/debug/kdb/kdb_debugger.c       |  169 ++
 kernel/debug/kdb/kdb_io.c             |  826 ++++++++++
 kernel/debug/kdb/kdb_keyboard.c       |  212 +++
 kernel/debug/kdb/kdb_main.c           | 2852 +++++++++++++++++++++++++++++++++
 kernel/debug/kdb/kdb_private.h        |  300 ++++
 kernel/debug/kdb/kdb_support.c        |  927 +++++++++++
 kernel/kallsyms.c                     |   21 +
 kernel/kgdb.c                         | 1764 --------------------
 kernel/module.c                       |    4 +
 kernel/printk.c                       |   25 +
 kernel/sched.c                        |    7 +-
 kernel/signal.c                       |   40 +
 lib/Kconfig.kgdb                      |   24 +-
 51 files changed, 9243 insertions(+), 2016 deletions(-)
 create mode 100644 include/linux/kdb.h
 create mode 100644 kernel/debug/Makefile
 create mode 100644 kernel/debug/debug_core.c
 create mode 100644 kernel/debug/debug_core.h
 create mode 100644 kernel/debug/gdbstub.c
 create mode 100644 kernel/debug/kdb/.gitignore
 create mode 100644 kernel/debug/kdb/Makefile
 create mode 100644 kernel/debug/kdb/kdb_bp.c
 create mode 100644 kernel/debug/kdb/kdb_bt.c
 create mode 100644 kernel/debug/kdb/kdb_cmds
 create mode 100644 kernel/debug/kdb/kdb_debugger.c
 create mode 100644 kernel/debug/kdb/kdb_io.c
 create mode 100644 kernel/debug/kdb/kdb_keyboard.c
 create mode 100644 kernel/debug/kdb/kdb_main.c
 create mode 100644 kernel/debug/kdb/kdb_private.h
 create mode 100644 kernel/debug/kdb/kdb_support.c
 delete mode 100644 kernel/kgdb.c
