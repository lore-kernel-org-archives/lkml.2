Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312Ab2CIRNx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 12:13:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557Ab2CIRNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 12:13:52 -0500
Message-ID: <4F5A3A4D.1020008@redhat.com>
Date: Fri, 09 Mar 2012 18:13:49 +0100
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Jan Kratochvil <jan.kratochvil@redhat.com>,
        Roland McGrath <mcgrathr@google.com>
CC: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: Extending coredump note section to contain filenames
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland, Jan,

While working with coredump analysis, it struck me how much
PITA is caused merely by the fact that names of loaded binary
and libraries are not known.

gdb retrieves loaded library names by examining dynamic loader's
data stored in the coredump's data segments. It uses intimate
knowledge how and where dynamic loader keeps the list of loaded
libraries. (Meaning that it will break if non-standard loader
is used).

And, as Jan explained to me, it depends on knowing
where the linked list of libs starts, which requires knowing binary
which was running. IIRC there is no easy and reasonably foolproof
way to determine binary's name. (Looking at argv[0] on stack
is not reasonably foolproof).

Which is *ridiculous*. We *know* the list of mapped files
at the coredump generation time. It can even be accessed as
/proc/PID/maps.

I propose to save this information in coredump.

(For people not very familiar with coredump format:
coredumps have a NOTE segment which contains register values,
PID of the crashed process, and other such info. It looks like this:

Program Headers:
   Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
   NOTE           0x000254 0x00000000 0x00000000 0x00814 0x00000     0
   LOAD           0x001000 0x00172000 0x00000000 0x01000 0x01000 R E 0x1000
...
Notes at offset 0x00000254 with length 0x00000814:
   Owner                 Data size       Description
   CORE                 0x00000090       NT_PRSTATUS (prstatus structure)
   CORE                 0x0000007c       NT_PRPSINFO (prpsinfo structure)
   CORE                 0x000000a0       NT_AUXV (auxiliary vector)
   CORE                 0x0000006c       NT_FPREGSET (floating point registers)
   LINUX                0x00000200       NT_PRXFPREG (user_xfpregs structure)
   LINUX                0x00000340       NT_X86_XSTATE (x86 XSAVE extended state)
   LINUX                0x00000030       Unknown note type: (0x00000200)

and I propose to add a new note to this segment)

Do you think such addition would be useful?


What format this note should have? Hmmm. How about this:

Elf_Word count    // how many files are mapped
array of [count] elements of
     Elf_Addr start
     Elf_Addr end
     Elf_Addr file_ofs
followed by filenames in ASCII: "FILE1" NUL "FILE2" NUL "FILE3" NUL...

The rationale for not saving some other attributes is that the list
of all mapped files can be somewhat big. For example:

$ cat /proc/`pidof firefox`/maps | wc -c
41553

Thus, we probably may want to make it smaller.
We may save a bit by coalescing the adjacent mappings to the same file
which only differ in attributes. Example from my firefox's /proc/pid/maps file:

b6fa0000-b6fb4000 r-xp 00000000 fd:01 671717     /usr/lib/xulrunner-2/libmozjs.so
b6fb4000-b6fb6000 ---p 00014000 fd:01 671717     /usr/lib/xulrunner-2/libmozjs.so

In fact these two mappings map contiguos area of the file to a contiguous area
of memory, so in coredump we can represent it as one item:

start:b6fa0000 end:b6fb6000 ofs:00000000 name:/usr/lib/xulrunner-2/libmozjs.so

The information about memory attributes is present in coredump anyway,
in program header, so it can be restored by coredump analysis tools.


Maybe we also would want to be able to compress filenames by saying
"take N chars from previous name, then append this suffix".
This means that instead of storing
     "/usr/lib/xulrunner-2/libxul.so" NUL
     "/usr/lib/xulrunner-2/libxul.so" NUL
     "/usr/lib/xulrunner-2/libmozjs.so" NUL
we'd store
     "/usr/lib/xulrunner-2/libxul.so" NUL
     <30> NUL
     <24> "mozjs.so" NUL
But is it worth the pain in the coredump parsers?


Another question is detection of deleted files.
If /usr/lib/xulrunner-2/libmozjs.so was updated while program ran
and now file mapped into process address space does not correspond
to the same-named file on disk, can we help users to detect this? How?
By saving maj/min/inode? Hash thereof?
File size?
File's md5sum (probably not, way too expensive. But nicely robust...)?

-- 
vda
