Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab1FFPe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:34:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37296 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab1FFPeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:34:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=svw2pPXDLwlbK+EY95z7SauGh/zQTyEXck0rBvBu2lJ+TxFGQQu7ARECYLdjHp5y0Q
         MKPLCsNG51snSRx6tququAzLpjiiUfHjT5myCOnHPAHs3eRCcLIB4dZYjQu9gSLLC+nq
         wCSliZCdOWHPmoejmQAykUSJm9FEY/Dh8zEw8=
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Mon, 6 Jun 2011 23:33:32 +0800
Message-ID: <BANLkTi=cqG7DFDAvnUVmZq8KyBq6fAcjeg@mail.gmail.com>
Subject: KGTP example 1: count the function vfs_read running clock and called
 times of each program with GDB+Python
To: linux-kernel@vger.kernel.org, gdb@sourceware.org
Cc: Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        Steven <mqyoung@gmail.com>, colyli@gmail.com,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Content-Type: multipart/mixed; boundary=0015174753e8cf54d904a50cd594
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015174753e8cf54d904a50cd594
Content-Type: text/plain; charset=ISO-8859-1

Hi,

In the release note of KGTP
201100601(https://lkml.org/lkml/2011/6/1/543), I introduce the
gtpframe_pipe.  It supply to get the tracepoint frame entry when kgtp
is running.
I will show a example to count the function vfs_read running clock and
called times of each program with GDB+Python.

Before using the examples, you need to make some preparations.
1. Make sure your kernel is built by GCC 4.5 or later version.
Because Kernel is built by -O2, new version GCC generate more debug
info.
2. Make sure your kernel support Kprobe because KGTP need it.
3. Use the GDB 7.3 or later version.  Because old version GDB have a
lot of bugs of tracepoint and miss some feature that we need in the
example.  If you use UBUNTU, You can got later version GDB package in
https://lkml.org/lkml/2011/6/4/65
4. Make sure your GDB support Python.  To make sure that, you can use
following command in GDB:
(gdb) python print("python is OK.\n")
If GDB output "python is OK.", GDB support Python is OK.
If not, you need rebuild your GDB with config "--with-python".

See https://code.google.com/p/kgtp/wiki/HOWTO#Get_KGTP_through_http to
get howto get, build and insmod KGTP.

After insmod KGTP module you can set the tracepoint.  The attachment
"r.source" is the GDB source file for set the tracepoint in the
address that we need.
You can let your GDB set the tracepoint with command:
sudo gdb ./vmlinux -x ./r.source
Or GDB command:
source r.source
To load it.
After set the tracepoint, you can use GDB command "tstart" and "tstop"
to start and stop the trace.

Then we can begin to parse the KGTP tracepoint frame entry with
GDB+Python.  The attachemt "r.py" is the Python script that will do
it.  You can use the command:
sudo gdb ./vmlinux -x r.py
Or GDB command:
source r.py
When the parse begin, you can use ctrl-c to get the info like:
vfs_read:  1146144473124 ns 54981 times

Top 3 of clock is:
{<unavailable> <repeats 16 times>} 859234925034
"chrome\000\000\000\000\000\000\000\000\000" 286747105396
"Xorg", '\000' <repeats 11 times> 87940392

Top 3 of times is:
"chrome\000\000\000\000\000\000\000\000\000" 35956
"Xorg", '\000' <repeats 11 times> 7915
"pulseaudio\000\000\000\000\000" 2406

Top 3 of clock per times is:
{<unavailable> <repeats 16 times>} 15343480804
"chrome\000\000\000\000\000\000\000\000\000" 7974944
"hald", '\000' <repeats 11 times> 462464

Top 3 of real clock is:
{<unavailable> <repeats 16 times>} 859234925034
"chrome\000\000\000\000\000\000\000\000\000" 286747105396
"Xorg", '\000' <repeats 11 times> 87940392

Top 3 of real clock per times is:
"kscope\000\000\000\000\000\000\000\000\000" 9085
"GoogleTalkPlugi" 2290
"udisks-helper-a" 2158

The clock is the vfs_read exec ns.
The real clock is the vfs_read exec ns that only when the process that
call vfs_read is running.



I will introduce the r.source and r.py in following part:
Following part I will explain r.source:
     1	list vfs_read
     2	target remote /sys/kernel/debug/gtp
This line connect the interface of KGTP.
     3	trace read_write.c:310
     4	  commands
     5	    collect ((struct task_struct *)$current_task)->pid
     6	    collect $no_self_trace
     7	  end
These lines set tracepoint in the begin of function vfs_read.
Line 5 mean collect current pid of process.
Line 6 mean this tracepoint set in a code that have process context.
Don't need trace the current KGTP user space code such as GDB connect
to the KGTP interface.  It introduce in
https://code.google.com/p/kgtp/wiki/HOWTO#Special_trace_state_variable_$no_self_trace
     8	trace read_write.c:331
     9	  commands
    10	    collect ((struct task_struct *)$current_task)->pid
    11	    collect ((struct task_struct *)$current_task)->comm
    12	    collect $no_self_trace
    13	  end
These lines set tracepoint in the end of function vfs_read.  All the
return of vfs_read will trace by this tracepoint.
This tracepoint collect other value that need in Python script.
    14	list schedule
    15	trace 4247
    16	  commands
    17	    collect prev->pid
    18	    collect next->pid
    19	  end
This tracepoint trace in the "schedule" function, we will use it to
get which process is running on the CPU.
    20	set circular-trace-buffer on
This command set the frame circular.  When the frame is full, it will
auto overwrite the old entry.


Following part I will explain r.py:
     1	#!/usr/bin/python
     2	
     3	import signal;
     4	import gdb;
gdb is a special lib when use python inside GDB, you can get more
about it in http://sourceware.org/gdb/current/onlinedocs/gdb/Python.html
     5	
     6	real_read_clock = 0;
     7	read_clock = 0;
     8	read_num = 0;
     9	read_comm = {};
These vals is for record the info from Kernel.
    10	
    11	def tfind_entry(num):
    12		if num < 0:
    13			tid = gdb.execute("tfind", False, True);
    14		else:
    15			tid = gdb.execute("tfind "+str(num), False, True);
    16		if tid.find(", tracepoint ") < 0:
    17			return -1;
    18		tid = tid[tid.find(", tracepoint ") + len(", tracepoint "):];
    19		return int(tid);
This function can get the "num" entry and return the tracepoint
number.  If num < 0, will get the next entry.
The tracepoint return value can use to make sure which address we arrive.
If you write a python parse code, you can use this function.
    20	
    21	def print_top(comm, index, num):
    22		for e in comm:
    23			print e[0], e[1][index];
    24			num -= 1;
    25			if num <= 0:
    26				break;
    27	
    28	def sigint_handler(num, e):
    29		print "vfs_read: ", read_clock, "ns", read_num, "times";
    30		print "";
    31		print "Top 3 of clock is:";
    32		print_top (sorted(read_comm.items(), key=lambda d:d[1][0],
reverse=True), 0, 3);
    33		print "";
    34		print "Top 3 of times is:";
    35		print_top (sorted(read_comm.items(), key=lambda d:d[1][1],
reverse=True), 1, 3);
    36		print "";
    37		print "Top 3 of clock per times is:";
    38		print_top (sorted(read_comm.items(), key=lambda d:d[1][2],
reverse=True), 2, 3);
    39		print "";
    40		print "Top 3 of real clock is:";
    41		print_top (sorted(read_comm.items(), key=lambda d:d[1][3],
reverse=True), 3, 3);
    42		print "";
    43		print "Top 3 of real clock per times is:";
    44		print_top (sorted(read_comm.items(), key=lambda d:d[1][4],
reverse=True), 4, 3);
    45	
    46		try:
    47			s = raw_input('Continue? (yes)')
    48		except:
    49			s = 'y'
    50		finally:
    51			if s[0:1] != 'n' and s[0:1] != 'N':
    52				return;
    53		exit(1);
This function is the handler of ctrl-c.  It output the parse info with
function print_top.
    54	
    55	gdb.execute("set pagination off", True, True);
This is the first line of parser.
The line close pagination then it will not affect the parse.  If you
write yourself parser, suggest add this line too.
    56	
    57	#set tracepoint id
    58	vfs_read_begin = 1;
    59	vfs_read_end = 2;
    60	schedule = 3;
    61	
    62	signal.signal(signal.SIGINT, sigint_handler);
    63	signal.siginterrupt(signal.SIGINT, False);
Setup the ctrl-c handler and set system call restart when it return.
    64	
    65	#connect to the gdbframe_pipe
    66	gdb.execute("list vfs_read");
    67	gdb.execute("target tfile /sys/kernel/debug/gtpframe_pipe");
Connect to KGTP interface.
    68	
    69	r_list = {};
    70	
    71	while 1:
    72		try:
    73			tid = tfind_entry(-1);
    74			if tid < 0:
    75				raise gdb.error ("Something wrong, drop one entry.");
Get entry from gtpframe_pipe is special.  Please see
https://code.google.com/p/kgtp/wiki/HOWTO#Get_the_frame_info_with_GDB
to get info.
    76	
    77			if tid == vfs_read_begin:
    78				entry = {};
    79				entry["begin_clock"] = long(gdb.parse_and_eval("$clock"));
    80				entry["prev_clock"] = entry["begin_clock"];
    81				entry["real_clock"] = 0;
    82				pid = long(gdb.parse_and_eval("((struct task_struct
*)$current_task)->pid"));
    83				r_list[pid] = entry;
This the parser of begin of vfs_read.  It will record the entry of a
pid to the r_list.
In GDB python you can access special trace state variables with
function "gdb.parse_and_eval".  This function will return a special
type that inside GDB.  So need convert it to other type before use it.
    84			elif tid == schedule:
    85				pid = long(gdb.parse_and_eval("prev->pid"));
    86				if pid in r_list:
    87					clock = long(gdb.parse_and_eval("$clock"));
    88					r_list[pid]["real_clock"] += clock - r_list[pid]["prev_clock"];
    89					r_list[pid]["prev_clock"] = clock;
    90				else:
    91					pid = long(gdb.parse_and_eval("next->pid"));
    92					if pid in r_list:
    93						r_list[pid]["prev_clock"] = long(gdb.parse_and_eval("$clock"));
This is the parser of schedule.
When the prev pid or next pid is inside r_list, it will set the
real_clock inside r_list.
    94			elif tid == vfs_read_end:
    95				pid = long(gdb.parse_and_eval("((struct task_struct
*)$current_task)->pid"));
    96				if pid not in r_list:
    97					raise gdb.error ("cannot find vfs_read_begin for vfs_read_end");
    98	
    99				clock = long(gdb.parse_and_eval("$clock"));
   100				r_list[pid]["real_clock"] += clock - r_list[pid]["prev_clock"];
   101				clock = clock - r_list[pid]["begin_clock"];
   102	
   103				read_clock += clock;
   104				real_read_clock += r_list[pid]["real_clock"];
   105				read_num += 1;
   106	
   107				comm = str(gdb.parse_and_eval("((struct task_struct
*)$current_task)->comm"));
   108				if comm in read_comm:
   109					read_comm[comm][0] += clock;
   110					read_comm[comm][1] += 1;
   111					read_comm[comm][2] = read_comm[comm][0] / read_comm[comm][1];
   112					read_comm[comm][3] += r_list[pid]["real_clock"];
   113					read_comm[comm][4] = r_list[pid]["real_clock"] / read_comm[comm][1];
   114				else:
   115					read_comm[comm] = [clock, 1, clock,
r_list[pid]["real_clock"], r_list[pid]["real_clock"]];
   116				del(r_list[pid]);
This is handler of vfs_read end.  When get the pid inside r_list,
record it and remove it.
   117			else:
   118				raise gdb.error ("Trace id error.");
   119		except gdb.error, x:
   120			print("Drop one entry because", x);
   121		except gdb.MemoryError, x:
   122			print("Drop one entry because", x);
This is the except handler, we didn't handle all the except because we
want handle ctrl-c.
   123	
   124		gdb.execute("tfind", False, True);
Tell KGTP pipe interface that we need the next entry.

This code have a bug.  Because we set circular-trace-buffer on, some
entry will be overwrite.  If a vfs_read_end is overwrite but
vfs_read_begin is record in r_list, it will never be removed.  r_list
will increase too big.

Thanks,
Hui

--0015174753e8cf54d904a50cd594
Content-Type: application/octet-stream; name="r.source"
Content-Disposition: attachment; filename="r.source"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_golj0i1e0

bGlzdCB2ZnNfcmVhZAp0YXJnZXQgcmVtb3RlIC9zeXMva2VybmVsL2RlYnVnL2d0cAp0cmFjZSBy
ZWFkX3dyaXRlLmM6MzEwCiAgY29tbWFuZHMKICAgIGNvbGxlY3QgKChzdHJ1Y3QgdGFza19zdHJ1
Y3QgKikkY3VycmVudF90YXNrKS0+cGlkCiAgICBjb2xsZWN0ICRub19zZWxmX3RyYWNlCiAgZW5k
CnRyYWNlIHJlYWRfd3JpdGUuYzozMzEKICBjb21tYW5kcwogICAgY29sbGVjdCAoKHN0cnVjdCB0
YXNrX3N0cnVjdCAqKSRjdXJyZW50X3Rhc2spLT5waWQKICAgIGNvbGxlY3QgKChzdHJ1Y3QgdGFz
a19zdHJ1Y3QgKikkY3VycmVudF90YXNrKS0+Y29tbQogICAgY29sbGVjdCAkbm9fc2VsZl90cmFj
ZQogIGVuZApzZXQgY2lyY3VsYXItdHJhY2UtYnVmZmVyIG9uCmxpc3Qgc2NoZWR1bGUKdHJhY2Ug
NDI0NwogIGNvbW1hbmRzCiAgICBjb2xsZWN0IHByZXYtPnBpZAogICAgY29sbGVjdCBuZXh0LT5w
aWQKICBlbmQKc2V0IGNpcmN1bGFyLXRyYWNlLWJ1ZmZlciBvbgo=
--0015174753e8cf54d904a50cd594
Content-Type: text/x-python; charset=US-ASCII; name="r.py"
Content-Disposition: attachment; filename="r.py"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_golj0ipd1

IyEvdXNyL2Jpbi9weXRob24KCmltcG9ydCBzaWduYWw7CmltcG9ydCBnZGI7CgpyZWFsX3JlYWRf
Y2xvY2sgPSAwOwpyZWFkX2Nsb2NrID0gMDsKcmVhZF9udW0gPSAwOwpyZWFkX2NvbW0gPSB7fTsK
CmRlZiB0ZmluZF9lbnRyeShudW0pOgoJaWYgbnVtIDwgMDoKCQl0aWQgPSBnZGIuZXhlY3V0ZSgi
dGZpbmQiLCBGYWxzZSwgVHJ1ZSk7CgllbHNlOgoJCXRpZCA9IGdkYi5leGVjdXRlKCJ0ZmluZCAi
K3N0cihudW0pLCBGYWxzZSwgVHJ1ZSk7CglpZiB0aWQuZmluZCgiLCB0cmFjZXBvaW50ICIpIDwg
MDoKCQlyZXR1cm4gLTE7Cgl0aWQgPSB0aWRbdGlkLmZpbmQoIiwgdHJhY2Vwb2ludCAiKSArIGxl
bigiLCB0cmFjZXBvaW50ICIpOl07CglyZXR1cm4gaW50KHRpZCk7CgpkZWYgcHJpbnRfdG9wKGNv
bW0sIGluZGV4LCBudW0pOgoJZm9yIGUgaW4gY29tbToKCQlwcmludCBlWzBdLCBlWzFdW2luZGV4
XTsKCQludW0gLT0gMTsKCQlpZiBudW0gPD0gMDoKCQkJYnJlYWs7CgpkZWYgc2lnaW50X2hhbmRs
ZXIobnVtLCBlKToKCXByaW50ICJ2ZnNfcmVhZDogIiwgcmVhZF9jbG9jaywgIm5zIiwgcmVhZF9u
dW0sICJ0aW1lcyI7CglwcmludCAiIjsKCXByaW50ICJUb3AgMyBvZiBjbG9jayBpczoiOwoJcHJp
bnRfdG9wIChzb3J0ZWQocmVhZF9jb21tLml0ZW1zKCksIGtleT1sYW1iZGEgZDpkWzFdWzBdLCBy
ZXZlcnNlPVRydWUpLCAwLCAzKTsKCXByaW50ICIiOwoJcHJpbnQgIlRvcCAzIG9mIHRpbWVzIGlz
OiI7CglwcmludF90b3AgKHNvcnRlZChyZWFkX2NvbW0uaXRlbXMoKSwga2V5PWxhbWJkYSBkOmRb
MV1bMV0sIHJldmVyc2U9VHJ1ZSksIDEsIDMpOwoJcHJpbnQgIiI7CglwcmludCAiVG9wIDMgb2Yg
Y2xvY2sgcGVyIHRpbWVzIGlzOiI7CglwcmludF90b3AgKHNvcnRlZChyZWFkX2NvbW0uaXRlbXMo
KSwga2V5PWxhbWJkYSBkOmRbMV1bMl0sIHJldmVyc2U9VHJ1ZSksIDIsIDMpOwoJcHJpbnQgIiI7
CglwcmludCAiVG9wIDMgb2YgcmVhbCBjbG9jayBpczoiOwoJcHJpbnRfdG9wIChzb3J0ZWQocmVh
ZF9jb21tLml0ZW1zKCksIGtleT1sYW1iZGEgZDpkWzFdWzNdLCByZXZlcnNlPVRydWUpLCAzLCAz
KTsKCXByaW50ICIiOwoJcHJpbnQgIlRvcCAzIG9mIHJlYWwgY2xvY2sgcGVyIHRpbWVzIGlzOiI7
CglwcmludF90b3AgKHNvcnRlZChyZWFkX2NvbW0uaXRlbXMoKSwga2V5PWxhbWJkYSBkOmRbMV1b
NF0sIHJldmVyc2U9VHJ1ZSksIDQsIDMpOwoKCXRyeToKCQlzID0gcmF3X2lucHV0KCdDb250aW51
ZT8gKHllcyknKQoJZXhjZXB0OgoJCXMgPSAneScKCWZpbmFsbHk6CgkJaWYgc1swOjFdICE9ICdu
JyBhbmQgc1swOjFdICE9ICdOJzoKCQkJcmV0dXJuOwoJZXhpdCgxKTsKCmdkYi5leGVjdXRlKCJz
ZXQgcGFnaW5hdGlvbiBvZmYiLCBUcnVlLCBUcnVlKTsKCiNzZXQgdHJhY2Vwb2ludCBpZAp2ZnNf
cmVhZF9iZWdpbiA9IDE7CnZmc19yZWFkX2VuZCA9IDI7CnNjaGVkdWxlID0gMzsKCnNpZ25hbC5z
aWduYWwoc2lnbmFsLlNJR0lOVCwgc2lnaW50X2hhbmRsZXIpOwpzaWduYWwuc2lnaW50ZXJydXB0
KHNpZ25hbC5TSUdJTlQsIEZhbHNlKTsKCiNjb25uZWN0IHRvIHRoZSBnZGJmcmFtZV9waXBlCmdk
Yi5leGVjdXRlKCJsaXN0IHZmc19yZWFkIik7CmdkYi5leGVjdXRlKCJ0YXJnZXQgdGZpbGUgL3N5
cy9rZXJuZWwvZGVidWcvZ3RwZnJhbWVfcGlwZSIpOwoKcl9saXN0ID0ge307Cgp3aGlsZSAxOgoJ
dHJ5OgoJCXRpZCA9IHRmaW5kX2VudHJ5KC0xKTsKCQlpZiB0aWQgPCAwOgoJCQlyYWlzZSBnZGIu
ZXJyb3IgKCJTb21ldGhpbmcgd3JvbmcsIGRyb3Agb25lIGVudHJ5LiIpOwoKCQlpZiB0aWQgPT0g
dmZzX3JlYWRfYmVnaW46CgkJCWVudHJ5ID0ge307CgkJCWVudHJ5WyJiZWdpbl9jbG9jayJdID0g
bG9uZyhnZGIucGFyc2VfYW5kX2V2YWwoIiRjbG9jayIpKTsKCQkJZW50cnlbInByZXZfY2xvY2si
XSA9IGVudHJ5WyJiZWdpbl9jbG9jayJdOwoJCQllbnRyeVsicmVhbF9jbG9jayJdID0gMDsKCQkJ
cGlkID0gbG9uZyhnZGIucGFyc2VfYW5kX2V2YWwoIigoc3RydWN0IHRhc2tfc3RydWN0ICopJGN1
cnJlbnRfdGFzayktPnBpZCIpKTsKCQkJcl9saXN0W3BpZF0gPSBlbnRyeTsKCQllbGlmIHRpZCA9
PSBzY2hlZHVsZToKCQkJcGlkID0gbG9uZyhnZGIucGFyc2VfYW5kX2V2YWwoInByZXYtPnBpZCIp
KTsKCQkJaWYgcGlkIGluIHJfbGlzdDoKCQkJCWNsb2NrID0gbG9uZyhnZGIucGFyc2VfYW5kX2V2
YWwoIiRjbG9jayIpKTsKCQkJCXJfbGlzdFtwaWRdWyJyZWFsX2Nsb2NrIl0gKz0gY2xvY2sgLSBy
X2xpc3RbcGlkXVsicHJldl9jbG9jayJdOwoJCQkJcl9saXN0W3BpZF1bInByZXZfY2xvY2siXSA9
IGNsb2NrOwoJCQllbHNlOgoJCQkJcGlkID0gbG9uZyhnZGIucGFyc2VfYW5kX2V2YWwoIm5leHQt
PnBpZCIpKTsKCQkJCWlmIHBpZCBpbiByX2xpc3Q6CgkJCQkJcl9saXN0W3BpZF1bInByZXZfY2xv
Y2siXSA9IGxvbmcoZ2RiLnBhcnNlX2FuZF9ldmFsKCIkY2xvY2siKSk7CgkJZWxpZiB0aWQgPT0g
dmZzX3JlYWRfZW5kOgoJCQlwaWQgPSBsb25nKGdkYi5wYXJzZV9hbmRfZXZhbCgiKChzdHJ1Y3Qg
dGFza19zdHJ1Y3QgKikkY3VycmVudF90YXNrKS0+cGlkIikpOwoJCQlpZiBwaWQgbm90IGluIHJf
bGlzdDoKCQkJCXJhaXNlIGdkYi5lcnJvciAoImNhbm5vdCBmaW5kIHZmc19yZWFkX2JlZ2luIGZv
ciB2ZnNfcmVhZF9lbmQiKTsKCgkJCWNsb2NrID0gbG9uZyhnZGIucGFyc2VfYW5kX2V2YWwoIiRj
bG9jayIpKTsKCQkJcl9saXN0W3BpZF1bInJlYWxfY2xvY2siXSArPSBjbG9jayAtIHJfbGlzdFtw
aWRdWyJwcmV2X2Nsb2NrIl07CgkJCWNsb2NrID0gY2xvY2sgLSByX2xpc3RbcGlkXVsiYmVnaW5f
Y2xvY2siXTsKCgkJCXJlYWRfY2xvY2sgKz0gY2xvY2s7CgkJCXJlYWxfcmVhZF9jbG9jayArPSBy
X2xpc3RbcGlkXVsicmVhbF9jbG9jayJdOwoJCQlyZWFkX251bSArPSAxOwoKCQkJY29tbSA9IHN0
cihnZGIucGFyc2VfYW5kX2V2YWwoIigoc3RydWN0IHRhc2tfc3RydWN0ICopJGN1cnJlbnRfdGFz
ayktPmNvbW0iKSk7CgkJCWlmIGNvbW0gaW4gcmVhZF9jb21tOgoJCQkJcmVhZF9jb21tW2NvbW1d
WzBdICs9IGNsb2NrOwoJCQkJcmVhZF9jb21tW2NvbW1dWzFdICs9IDE7CgkJCQlyZWFkX2NvbW1b
Y29tbV1bMl0gPSByZWFkX2NvbW1bY29tbV1bMF0gLyByZWFkX2NvbW1bY29tbV1bMV07CgkJCQly
ZWFkX2NvbW1bY29tbV1bM10gKz0gcl9saXN0W3BpZF1bInJlYWxfY2xvY2siXTsKCQkJCXJlYWRf
Y29tbVtjb21tXVs0XSA9IHJfbGlzdFtwaWRdWyJyZWFsX2Nsb2NrIl0gLyByZWFkX2NvbW1bY29t
bV1bMV07CgkJCWVsc2U6CgkJCQlyZWFkX2NvbW1bY29tbV0gPSBbY2xvY2ssIDEsIGNsb2NrLCBy
X2xpc3RbcGlkXVsicmVhbF9jbG9jayJdLCByX2xpc3RbcGlkXVsicmVhbF9jbG9jayJdXTsKCQkJ
ZGVsKHJfbGlzdFtwaWRdKTsKCQllbHNlOgoJCQlyYWlzZSBnZGIuZXJyb3IgKCJUcmFjZSBpZCBl
cnJvci4iKTsKCWV4Y2VwdCBnZGIuZXJyb3IsIHg6CgkJcHJpbnQoIkRyb3Agb25lIGVudHJ5IGJl
Y2F1c2UiLCB4KTsKCWV4Y2VwdCBnZGIuTWVtb3J5RXJyb3IsIHg6CgkJcHJpbnQoIkRyb3Agb25l
IGVudHJ5IGJlY2F1c2UiLCB4KTsgCgoJZ2RiLmV4ZWN1dGUoInRmaW5kIiwgRmFsc2UsIFRydWUp
Owo=
--0015174753e8cf54d904a50cd594--
