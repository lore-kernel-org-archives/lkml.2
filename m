Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab2DTVaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 17:30:07 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62715 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab2DTVaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 17:30:04 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <mingo@redhat.com>, <masami.hiramatsu.pt@hitachi.com>,
        <rusty@rustcorp.com.au>
Subject: [RFC PATCH 0/8] backtrace/oops with source/line information
Date: Fri, 20 Apr 2012 16:29:46 -0500
Message-ID: <1334957394-12086-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.10
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is some very preliminary work based on some ideas Masami and I
have talked about over the past few years.  Seeing his disassembler in
action made me decide to take a stab at the in kernel lines for
locations chanages.

What does this patch set do at a high level?

It should be fairly obvious if you take a look at a call to panic()
inside a kernel module without the patch and then with the patch.

Call to panic() without the patch set
-------------------------------------
Call Trace:
 [<ffffffff815f1a33>] panic+0xbd/0x1c3
 [<ffffffff815f1c24>] ? printk+0x68/0x6c
 [<ffffffffa0000175>] panic_write+0x25/0x30 [test_panic]
 [<ffffffff811894d6>] proc_file_write+0x76/0xb0
 [<ffffffff81189460>] ? __proc_create+0x130/0x130
 [<ffffffff811840b8>] proc_reg_write+0x88/0xc0
 [<ffffffff81124158>] vfs_write+0xc8/0x180
 [<ffffffff81124311>] sys_write+0x51/0x90
 [<ffffffff815f6f19>] ia32_do_call+0x13/0x13


Call to panic() with the patch set
----------------------------------
Call Trace:
 [<ffffffff815f3003>] panic+0xbd/0x14 panic.c:111
 [<ffffffff815f31f4>] ? printk+0x68/0xd printk.c:765
 [<ffffffffa0000175>] panic_write+0x25/0x30 [test_panic] test_panic.c:189
 [<ffffffff8118aa96>] proc_file_write+0x76/0x21 generic.c:226
 [<ffffffff8118aa20>] ? __proc_create+0x130/0x21 generic.c:211
 [<ffffffff81185678>] proc_reg_write+0x88/0x21 inode.c:218
 [<ffffffff81125718>] vfs_write+0xc8/0x20 read_write.c:435
 [<ffffffff811258d1>] sys_write+0x51/0x19 read_write.c:457
 [<ffffffff815f84d9>] ia32_do_call+0x13/0xc ia32entry.S:427


The key difference here is that you get the source line information in
any kind of oops/panic/backtrace, including inside kernel modules.  Of
course this comes at the expense of some memory you do not get to use
because these tables have to get stored in a place that is accessible
after a crash.  On a system with 4 gigs of ram however, the cost is
nearly insignificant when you have to give up a few megs for the
capability.  The idea is to make it a bit easier to just jump into a
source tree without having to use any tools to decode the dump (which
I know every kernel developer out there already has anwyay :-)

Using this patch is fairly straight forward. From a developer / end
user perspective here are the steps:
  * set CONFIG_KALLSYMS_LINE_LOCATIONS=y
  * Build a kernel that has debug information
  * Copy the unstripped kernel modules to the target system

--

So how does this work?

There are two separate pieces, one for the core kernel and one for the
kernel modules.  In both cases we need debug information generated
into the elf files for the purpose of obtaining the .debug_line
section which has the tables of where all the address / source line
information lives.

For the core kernel, all the line location information is added to the
kallsyms table using a new symbol type '0xff'.  These symbols will not
show up if you "cat /proc/kallsyms", such that no user space
applications break.  The new line location symbols are added to the
kallsyms table using a modified version of readelf which can only read
the .debug_line section of a vmlinux file.  This output is sent into
scripts/kallsyms and where it is encoded into an assembly file and
then compiled and linked into the kernel.  The internal kallsyms
encoding was changed in order to have fast lookups of the symbol type
information, and then a new function call was added to provide line
location lookups inside the kernel.

For a kernel module, the kernel module loader will look for a
.debug_line section after completing the kallsyms processing.  If it
finds one of these locations it will process the relocations and then
dynamically create a set of linked lists of the compilation units that
were used to create the kernel module.  Each compilation unit in the
linked list 2 arrays, one for the for source locations, and another
for address offset, source line number, and source line index into the
source file array.

Finally the symbol lookup used by printk was changed to request the
lines for location data when it exists.

--

One of the interesting things you can do if you are tight on memory
but can afford kallsyms, is to only use lines for locations in a
single kernel module and even leave out lines for locations for the
kernel core.

Example backtrace using the same kernel as above
------------------------------------------------
Call Trace:
 [<ffffffff815f2e23>] panic+0xbd/0x1c3
 [<ffffffff815f3014>] ? printk+0x68/0x6c
 [<ffffffffa0000175>] panic_write+0x25/0x30 [test_panic] test_panic.c:189
 [<ffffffff8118a8b6>] proc_file_write+0x76/0xb0
 [<ffffffff8118a840>] ? __proc_create+0x130/0x130
 [<ffffffff81185498>] proc_reg_write+0x88/0xc0
 [<ffffffff81125538>] vfs_write+0xc8/0x180
 [<ffffffff811256f1>] sys_write+0x51/0x90
 [<ffffffff815f82d9>] ia32_do_call+0x13/0x13

--

More details...

The first two patches in this series really are not all that
interesting.  The first simply adds in readelf.c from binutils 2.14,
the second strips it down such that it actually compiles and runs just
to emit source/line information from a vmlinux file.  The remainder of
the readelf patches fix it to work properly with the objective of
pushing the information into the kallsyms table.  At least this way we
have the complete history of how this was derrived.

If you are wondering why I pulled in an modified readelf?  It is
because most of the pre-built versions of readelf I tried were not
working properly on 32 or 64 bit combinations of machines.

What is left to do here?
  * Decide if this is worthy at all for the mainline
  * Perhaps change the implementation so to use a different table
    for the core kernel or also use .debug_line data
  * Check the memory usage in kallsyms with and without the type array
  * Provide some stats on how much memory this really uses (cost/benefit)
  * Perhaps split the elf functions out of module.c into their own file
  * Add in an optional kbuild option to not strip the .debug_line section
    from kernel module files
  * Fix the bug where the symbol offset isn't right when using lines
    for locations built into the kernel
  * Fix the bounds checking in the print_symbol because there is
    clearly a buffer overrun if you put a _really_ long file name in.


As always comments are welcome. :-)

Cheers,
Jason.

git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git lines_for_locations

--

Jason Wessel (8):
      readelf: check in a direct copy of readelf.c from binutils 2.14
      readelf: remove code unrelated to .debug_line section processing
      readelf: emit simple to parse line .debug_line data
      readelf: Fix dumping a 64 bit elf file on a 32 bit host
      kallsyms: convert the kallsyms storage to store the type separately
      kallsyms: Add kallsyms kallsyms_line_loc_lookup and print function
      modules: decode .debug_line sections if provided by insmod
      kallsyms,modules: add module_address_line_lookup() to kallsyms_line_loc_lookup()

 Makefile                 |    9 +-
 include/linux/kallsyms.h |   12 +
 include/linux/module.h   |   32 ++
 init/Kconfig             |   11 +
 kernel/kallsyms.c        |  140 +++++--
 kernel/module.c          |  549 ++++++++++++++++++++++++++
 scripts/Makefile         |    2 +
 scripts/kallsyms.c       |   49 ++-
 scripts/namespace.pl     |    1 +
 scripts/readelf.c        | 1855 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 10 files changed, 2618 insertions(+), 42 deletions(-)
 create mode 100644 scripts/readelf.c
