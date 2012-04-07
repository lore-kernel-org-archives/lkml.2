Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab2DGMgS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 08:36:18 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61387 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab2DGMgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 08:36:16 -0400
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Sat, 7 Apr 2012 20:35:34 +0800
Message-ID: <CANFwon15SdDbOLEMXrCe7+OXHkOFfdDQndFoAvzj+xR+da+qFA@mail.gmail.com>
Subject: An example to use KGTP analyze application performance bottleneck
To: linux-kernel@vger.kernel.org, "gdb@sourceware.org" <gdb@sourceware.org>,
        kgtp <kgtp@freelists.org>
Cc: Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        Steven <mqyoung@gmail.com>, colyli@gmail.com,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Geunsik Lim <leemgs1@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://code.google.com/p/kgtp/wiki/hotcode#An_example_to_use_KGTP_analyze_application_performance_bottlenec

Overview
After KGTP (http://code.google.com/p/kgtp/) 20120319, it include a
script hotcode.py that can show the hotest code line in the Linux
kernel or user space program through parse and record the pc address
in the interrupt handler. This document is an example that use it
analyze application performance bottleneck.
This example need KGTP 20120406 or later version.

Introduce of performance issue
KGTP include a script getmod.py. If a GDB that is debugging an Linux
Kernel call this script, it will auto load the debug info of the Linux
kernel modules that this Linux kernel is inserted. Then GDB can debug
these modules better than before. This script not only can use with
the GDB that connects with KGTP, but also can use with the GDB that
connects with other things such as QEMU. (Please goto
http://code.google.com/p/kgtp/wiki/HOWTO#How_to_use_getmod.py get more
info about this script.)
This script have problem is the execuiton speed is not very fast. This
document will introduce use KGTP analyze this issue.

Analysis process and result
#Insert KGTP
sudo insmod gtp.ko
#Open a GDB to be analyzed
sudo gdb ./vmlinux
#Open another terminal and get the pid of this GDB
ps -e | grep gdb
14632 pts/1    00:00:00 gdb
#Call hotcode.py.  Just input the pid, for other query just input enter.
sudo gdb ./vmlinux -x ~/kernel/svn/trunk/add-ons/hotcode.py
Which part of code you want trace? [(b)oth], (u)ser, (k)ernel:
Please input the pid of task that you want to trace - one per line.
If not set any task, will trace all code in the Linux kernel.
task pid (use empty to stop pid input):14632
Please input the debug binary of task if you want to change it
[/usr/local/bin/gdb]:
task pid (use empty to stop pid input):
Which way you want to output hotcode info when ctrl-c? [(h)tml], (t)ty:
Which file you want to save the html output? [./hotcode.html]:
Show line number (0 meas all)? [20]:
Remote debugging using /sys/kernel/debug/gtp
0x0000000000000000 in irq_stack_union ()
Do you load the symbol from LKM? (y)es, [(n)o]:
#In the GDB part connect to KGTP and call getmod.py
target remote /sys/kernel/debug/gtp
source ~/kernel/svn/trunk/getmod.py
#After getmod.py stop, go to hotcode.py and press ctrl-c.
Then you can get hotcode.html in the current directory. I post it to
the http://teawater.users.sourceforge.net/hotcode/normal.html.

Open this file with browser, you can see the table that show the
hotcode info of getmod.py.
The number after "User space hotcode list" (37716) and "Kernel space
hotcode list" (903) is the times of user space code and kernel space
code got interrupt. From this number, we can get that user code spend
more time.
>From "Hot functions list" of "User space hotcode list", we can see
that function "/usr/local/bin/gdb:strcmp_iw" (12776) and function
"/usr/local/bin/gdb:lookup_partial_symbol" (9059) is hotest function.
If need, click the function name can get the detailed info of this
function. Check the source tree can get that both of this functions is
around symbol parser. This is a bottleneck of this script.
Solution and resule
We can get the stack dump because we have get the hot function name:

#0  strcmp_iw (string1=0x7f4685d5611c "pgd_t", string2=0x3fed870
"attrs") at ../../src/gdb/utils.c:2627
#1  0x000000000063ebaa in lookup_partial_symbol (pst=<optimized out>,
name=<optimized out>, global=<optimized out>, domain=VAR_DOMAIN)
    at ../../src/gdb/psymtab.c:749
#2  0x00000000006400af in lookup_symbol_aux_psymtabs
(objfile=<optimized out>, block_index=1, name=0x4041d80 "attrs",
domain=VAR_DOMAIN)
    at ../../src/gdb/psymtab.c:510
#3  0x000000000063af95 in lookup_symbol_aux_quick (objfile=0x2f28d90,
kind=1, name=0x4041d80 "attrs", domain=VAR_DOMAIN)
    at ../../src/gdb/symtab.c:1522
#4  0x000000000063b183 in lookup_static_symbol_aux (name=0x4041d80
"attrs", domain=VAR_DOMAIN) at ../../src/gdb/symtab.c:1336
#5  0x000000000063b53b in lookup_symbol_aux (is_a_field_of_this=0x0,
language=<optimized out>, domain=VAR_DOMAIN, block=0x0,
    name=0x4041d80 "attrs") at ../../src/gdb/symtab.c:1316
#6  lookup_symbol_in_language (name=<optimized out>, block=0x0,
domain=VAR_DOMAIN, lang=<optimized out>, is_a_field_of_this=0x0)
    at ../../src/gdb/symtab.c:1200
#7  0x00000000005e125f in classify_name (block=0x0) at
../../src/gdb/c-exp.y:2438
#8  0x00000000005e3483 in c_lex () at ../../src/gdb/c-exp.y:2563
Function classify_name will classify the type of a name. getmod.py
will not parse the symbol most of time. So function lookup_symbol will
return NULL most of time. So I add a hash table in function
lookup_symbol. If the lookup_symbol will return NULL, add arguments of
it to the hash table. In the begin of function lookup_symbol, if the
arguments is same with a hash table entry, return NULL directly. You
can get this temp patch in
http://teawater.users.sourceforge.net/hotcode/speedup.txt.
Before this change, I tried to call getmod.py in a Linux kernel that
is inserted 67 modules, the time record is:

239.275789976
242.414674997
234.347954035
237.436943054
244.659180164
Aftet the change, I got:

110.593796968
109.023880005
107.977679014
108.905900002
108.117362976
The speed increase is about 54%.
You can get new hotcode.html from
http://teawater.users.sourceforge.net/hotcode/speedup.html. strcmp_iw
and lookup_partial_symbol is not hot like before.

The advantages of hotcode.py
>From prev analysis process, you can see that hotcode.py can get the
hotcode line info of an application (support more than one
application) and don't need rebuild application with some special lib
or something.
And it can show the hotcode info of both user space code and kernel space code.
Like other KGTP function, hotcode.py can dynamic start and stop trace
the application and don't need stop the application. So it is friendly
with online service or something like it.
And when simple GDB with hotcode.py, the time record is:

255.329950094
252.469471931
255.546139002
252.384520054
255.049283028
The speed decrease is about 6%.
