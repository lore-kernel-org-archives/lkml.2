Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab2DWLon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 07:44:43 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:42344 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab2DWLom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 07:44:42 -0400
X-AuditID: b753bd60-9fe84ba000000655-84-4f9540a714e8
X-AuditID: b753bd60-9fe84ba000000655-84-4f9540a714e8
Message-ID: <4F9540A0.6090805@hitachi.com>
Date: Mon, 23 Apr 2012 20:44:32 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, rusty@rustcorp.com.au,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 0/8] backtrace/oops with source/line information
References: <1334957394-12086-1-git-send-email-jason.wessel@windriver.com>
In-Reply-To: <1334957394-12086-1-git-send-email-jason.wessel@windriver.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/04/21 6:29), Jason Wessel wrote:
> This is some very preliminary work based on some ideas Masami and I
> have talked about over the past few years.  Seeing his disassembler in
> action made me decide to take a stab at the in kernel lines for
> locations chanages.
>
> What does this patch set do at a high level?
>
> It should be fairly obvious if you take a look at a call to panic()
> inside a kernel module without the patch and then with the patch.
>
> Call to panic() without the patch set
> -------------------------------------
> Call Trace:
>  [<ffffffff815f1a33>] panic+0xbd/0x1c3
>  [<ffffffff815f1c24>] ? printk+0x68/0x6c
>  [<ffffffffa0000175>] panic_write+0x25/0x30 [test_panic]
>  [<ffffffff811894d6>] proc_file_write+0x76/0xb0
>  [<ffffffff81189460>] ? __proc_create+0x130/0x130
>  [<ffffffff811840b8>] proc_reg_write+0x88/0xc0
>  [<ffffffff81124158>] vfs_write+0xc8/0x180
>  [<ffffffff81124311>] sys_write+0x51/0x90
>  [<ffffffff815f6f19>] ia32_do_call+0x13/0x13
>
>
> Call to panic() with the patch set
> ----------------------------------
> Call Trace:
>  [<ffffffff815f3003>] panic+0xbd/0x14 panic.c:111
>  [<ffffffff815f31f4>] ? printk+0x68/0xd printk.c:765
>  [<ffffffffa0000175>] panic_write+0x25/0x30 [test_panic] test_panic.c:189
>  [<ffffffff8118aa96>] proc_file_write+0x76/0x21 generic.c:226
>  [<ffffffff8118aa20>] ? __proc_create+0x130/0x21 generic.c:211
>  [<ffffffff81185678>] proc_reg_write+0x88/0x21 inode.c:218
>  [<ffffffff81125718>] vfs_write+0xc8/0x20 read_write.c:435
>  [<ffffffff811258d1>] sys_write+0x51/0x19 read_write.c:457
>  [<ffffffff815f84d9>] ia32_do_call+0x13/0xc ia32entry.S:427

Cool!! :D

This can be also useful for kprobes, users can put new events on the
specified lines not address! Ofcourse, I'd like to use this interface
for the disassembler patch too. ;)

> The key difference here is that you get the source line information in
> any kind of oops/panic/backtrace, including inside kernel modules.  Of
> course this comes at the expense of some memory you do not get to use
> because these tables have to get stored in a place that is accessible
> after a crash.  On a system with 4 gigs of ram however, the cost is
> nearly insignificant when you have to give up a few megs for the
> capability.  The idea is to make it a bit easier to just jump into a
> source tree without having to use any tools to decode the dump (which
> I know every kernel developer out there already has anwyay :-)

By the way, it seems that source file doesn't include directries,
is that possible to expand it? Since there are many files which have
same name but in different directries, it would be better to
print those path informations too.

>
> Using this patch is fairly straight forward. From a developer / end
> user perspective here are the steps:
>   * set CONFIG_KALLSYMS_LINE_LOCATIONS=y

I've found this config under Kallsyms resources, but I think
it is better to put it under CONFIG_DEBUG_INFO, because you
may need to enable CONFIG_DEBUG_INFO for build kernel with
.debug_* stuffs, and that will increase on-memory kernel
footprint.


>   * Build a kernel that has debug information
>   * Copy the unstripped kernel modules to the target system
>
> --
>
> So how does this work?
>
> There are two separate pieces, one for the core kernel and one for the
> kernel modules.  In both cases we need debug information generated
> into the elf files for the purpose of obtaining the .debug_line
> section which has the tables of where all the address / source line
> information lives.
>
> For the core kernel, all the line location information is added to the
> kallsyms table using a new symbol type '0xff'.  These symbols will not
> show up if you "cat /proc/kallsyms", such that no user space
> applications break.  The new line location symbols are added to the
> kallsyms table using a modified version of readelf which can only read
> the .debug_line section of a vmlinux file.  This output is sent into
> scripts/kallsyms and where it is encoded into an assembly file and
> then compiled and linked into the kernel.  The internal kallsyms
> encoding was changed in order to have fast lookups of the symbol type
> information, and then a new function call was added to provide line
> location lookups inside the kernel.
>
> For a kernel module, the kernel module loader will look for a
> .debug_line section after completing the kallsyms processing.  If it
> finds one of these locations it will process the relocations and then
> dynamically create a set of linked lists of the compilation units that
> were used to create the kernel module.  Each compilation unit in the
> linked list 2 arrays, one for the for source locations, and another
> for address offset, source line number, and source line index into the
> source file array.
>
> Finally the symbol lookup used by printk was changed to request the
> lines for location data when it exists.

Ah, that's really what I want! :)
I think ftrace also can use this for pretty printing ip address.


> --
>
> One of the interesting things you can do if you are tight on memory
> but can afford kallsyms, is to only use lines for locations in a
> single kernel module and even leave out lines for locations for the
> kernel core.
>
> Example backtrace using the same kernel as above
> ------------------------------------------------
> Call Trace:
>  [<ffffffff815f2e23>] panic+0xbd/0x1c3
>  [<ffffffff815f3014>] ? printk+0x68/0x6c
>  [<ffffffffa0000175>] panic_write+0x25/0x30 [test_panic] test_panic.c:189
>  [<ffffffff8118a8b6>] proc_file_write+0x76/0xb0
>  [<ffffffff8118a840>] ? __proc_create+0x130/0x130
>  [<ffffffff81185498>] proc_reg_write+0x88/0xc0
>  [<ffffffff81125538>] vfs_write+0xc8/0x180
>  [<ffffffff811256f1>] sys_write+0x51/0x90
>  [<ffffffff815f82d9>] ia32_do_call+0x13/0x13
>
> --
>
> More details...
>
> The first two patches in this series really are not all that
> interesting.  The first simply adds in readelf.c from binutils 2.14,
> the second strips it down such that it actually compiles and runs just
> to emit source/line information from a vmlinux file.  The remainder of
> the readelf patches fix it to work properly with the objective of
> pushing the information into the kallsyms table.  At least this way we
> have the complete history of how this was derrived.
>
> If you are wondering why I pulled in an modified readelf?  It is
> because most of the pre-built versions of readelf I tried were not
> working properly on 32 or 64 bit combinations of machines.

Maybe you can report it to the readelf upstream.

> What is left to do here?
>   * Decide if this is worthy at all for the mainline
>   * Perhaps change the implementation so to use a different table
>     for the core kernel or also use .debug_line data
>   * Check the memory usage in kallsyms with and without the type array
>   * Provide some stats on how much memory this really uses (cost/benefit)
>   * Perhaps split the elf functions out of module.c into their own file
>   * Add in an optional kbuild option to not strip the .debug_line section
>     from kernel module files
>   * Fix the bug where the symbol offset isn't right when using lines
>     for locations built into the kernel
>   * Fix the bounds checking in the print_symbol because there is
>     clearly a buffer overrun if you put a _really_ long file name in.
>
>
> As always comments are welcome. :-)
>
> Cheers,
> Jason.
>
> git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git
lines_for_locations

BTW, correct git url is here, isn't it? :)
git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/kgdb.git

Thanks!

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
