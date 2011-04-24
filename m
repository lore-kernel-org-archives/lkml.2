Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab1DXO2j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 10:28:39 -0400
Received: from mail-fx0-f66.google.com ([209.85.161.66]:45473 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079Ab1DXO2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 10:28:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=gKCyVlmof9X8RCPFK2XqQisIrbAzZbNpYJLQvTho2xGJNvJ55uh8QJKLJ3IUVEOKgF
         WQeHi50EX/8xDQNCM7hj1pgBoelrrq3lU0OgSi/jk82rwaQ4uW5pban6nodoNg9/U8e9
         xo35UXxFBj8dpLu7/SFhyePGhEOzTTbblFN1E=
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Sun, 24 Apr 2011 22:28:13 +0800
Message-ID: <BANLkTinOwu+MazHDhJLtsSZVkJHLBtWSzw@mail.gmail.com>
Subject: KGTP (Linux Kernel debugger and tracer) 20110424 release
To: linux-kernel@vger.kernel.org
Cc: Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        Steven <mqyoung@gmail.com>, colyli@gmail.com,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KGTP is a realtime and lightweight Linux Kernel GDB debugger and
tracer that use Kprobe.

It make Linux Kernel supply a GDB remote debug interface. Then GDB in
current machine or remote machine(see "Make GDB connect to gtp") can
debug Linux through GDB tracepoint without stop the Linux Kernel. And
even if the board doesn't have GDB on it and doesn't have
interface for remote debug. It can debug the Linux Kernel use offline
debug (See "Offline debug").

It support X86-32, X86-64, MIPS and ARM.
http://www.tudou.com/programs/view/_p6VTgxmCRA/ This is a video(in
Chinese) to show how to use it.

Now, KGTP 20110424 release.
You can get the package for it from
http://kgtp.googlecode.com/files/kgtp_20110424.tar.bz2
or
svn co https://kgtp.googlecode.com/svn/tags/20110424

The main change of this verion is add a special trace state variables
$dump_stack, "collect" it will let Linux Kernel output stack dump
directly.
Following example let Linux Kernel show the stack dump of vfs_readdir:
trace vfs_readdir
  commands
    collect $dump_stack
  end
Then your kernel will printk like:

[22779.208064] gtp 1:Pid: 441, comm: python Not tainted 2.6.39-rc3+ #46
[22779.208068] Call Trace:
[22779.208072]  [<fe653cca>] gtp_get_var+0x4a/0xa0 [gtp]
[22779.208076]  [<fe653d79>] gtp_collect_var+0x59/0xa0 [gtp]
[22779.208080]  [<fe655974>] gtp_action_x+0x1bb4/0x1dc0 [gtp]
[22779.208084]  [<c05b6408>] ? _raw_spin_unlock+0x18/0x40
[22779.208088]  [<c023f152>] ? __find_get_block_slow+0xd2/0x160
[22779.208091]  [<c01a8c56>] ? delayacct_end+0x96/0xb0
[22779.208100]  [<c023f404>] ? __find_get_block+0x84/0x1d0
[22779.208103]  [<c05b6408>] ? _raw_spin_unlock+0x18/0x40
[22779.208106]  [<c02e0838>] ? find_revoke_record+0xa8/0xc0
[22779.208109]  [<c02e0c45>] ? jbd2_journal_cancel_revoke+0xd5/0xe0
[22779.208112]  [<c02db51f>] ? __jbd2_journal_temp_unlink_buffer+0x2f/0x110
[22779.208115]  [<fe655c4c>] gtp_kp_pre_handler+0xcc/0x1c0 [gtp]
[22779.208118]  [<c05b8a88>] kprobe_exceptions_notify+0x3d8/0x440
[22779.208121]  [<c05b7d54>] ? hw_breakpoint_exceptions_notify+0x14/0x180
[22779.208124]  [<c05b95eb>] ? sub_preempt_count+0x7b/0xb0
[22779.208126]  [<c0227ac5>] ? vfs_readdir+0x15/0xb0
[22779.208128]  [<c0227ac4>] ? vfs_readdir+0x14/0xb0
[22779.208131]  [<c05b9743>] notifier_call_chain+0x43/0x60
[22779.208134]  [<c05b9798>] __atomic_notifier_call_chain+0x38/0x50
[22779.208137]  [<c05b97cf>] atomic_notifier_call_chain+0x1f/0x30
[22779.208140]  [<c05b980d>] notify_die+0x2d/0x30
[22779.208142]  [<c05b71c5>] do_int3+0x35/0xa0

Add a special trace state variables $clock.  Access it in tracepoint
condition and action will get the return of local_clock() that return
the timestamp in nanoseconds.

And according to Steven Rostedt's mail, move the interface from proc
to debug fs.  So, access kgtp need change to /sys/kernel/debug/gtp.

The other change is:
Make frame align better.
Change sp_checked to type 0xff, Change stack of x from local to static.
Fix the bug of $printk_tmp.
Make getgtprsp.pl support special trace state variables.

You can read the doc gtp.txt to get how to use kgtp.

And according to the comments of Christoph.  I make a patch for Linux
Kernel and make it looks OK with checkpatch.pl.

Signed-off-by: Hui Zhu <teawater@gmail.com>

---
 Documentation/trace/gtp.txt |  873 +++++++
 arch/arm/include/asm/gtp.h  |   13
 arch/mips/include/asm/gtp.h |   18
 arch/x86/include/asm/gtp.h  |   18
 lib/Kconfig.debug           |    9
 lib/Makefile                |    2
 lib/gtp.c                   | 5104 ++++++++++++++++++++++++++++++++++++++++++++
 scripts/getgtprsp.pl        |  102
 8 files changed, 6139 insertions(+)

--- /dev/null
+++ b/Documentation/trace/gtp.txt
@@ -0,0 +1,873 @@
+		Linux Kernel GDB tracepoint module (KGTP)
+		=========================================
+		By Hui Zhu <teawater@gmail.com>
+		https://code.google.com/p/kgtp/wiki/HOWTO
+		2011-04-24
+
+Table of contents
+-----------------
+
+What is KGTP
+Report issue about KGTP
+Get info about GDB tracepoint
+Get KGTP through http
+Get KGTP through svn
+Config KGTP
+Compile KGTP
+Install KGTP
+Uninstall KGTP
+Howto use
+	Exec it
+	Make GDB connect to gtp
+	Add module symbols to GDB
+	Get GDB tracepoint commands
+	Get registers info from Kernel
+	Get the value of variable from Kernel
+	How to use use tracepoint condition
+	How to use trace state variables
+		Simple trace state variables
+		Special trace state variables $current_task,
+		    $current_thread_info, $cpu_id, $dump_stack, $printk_level,
+		    $printk_format, $printk_tmp and $clock
+	Show all the traced data of current frame
+	Get backtrace info from Kernel
+	Howto let tracepoint output value directly
+		Output stack dump directly
+		Switch collect to output the value directly
+		Use printf command in actions
+	Get status of KGTP from Kernel
+	Set the trace buffer into a circular buffer
+	Do not stop tracepoint when the GDB disconnect
+	Howto show the variable that value of it is optimized
+		Linux kernel "Compile with almost no optimization" patch
+		Update your GCC
+	Offline debug
+
+
+
+
+What is KGTP
+------------
+
+KGTP is a realtime and lightweight Linux Kernel GDB debugger and tracer that
+use Kprobe.
+
+It make Linux Kernel supply a GDB remote debug interface. Then GDB in current
+machine or remote machine(see "Make GDB connect to gtp") can debug Linux
+through GDB tracepoint without stop the Linux Kernel.
+And even if the board doesn't have GDB on it and doesn't have interface for
+remote debug. It can debug the Linux Kernel use offline debug (See "Offline
+debug").
+It support X86-32, X86-64, MIPS and ARM.
+http://www.tudou.com/programs/view/_p6VTgxmCRA/ This is a video(in Chinese)
+to show how to use it.
+
+
+
+
+Report issue about KGTP
+-----------------------
+You can post it in https://code.google.com/p/kgtp/issues/list or write Email
+to teawater@gmail.com.
+
+
+
+
+Get info about GDB tracepoint
+-----------------------------
+Please goto http://sourceware.org/gdb/current/onlinedocs/gdb/Tracepoints.html
+
+
+
+
+Get KGTP through http
+---------------------
+Please goto http://code.google.com/p/kgtp/downloads/list OR UPDATE to down
+the package.
+
+
+
+
+Get KGTP through svn
+--------------------
+Some people have trouble with access to KGTP website. You can access kgtp
+through svn:
+
+------------------------------------------------------------
+svn checkout http://kgtp.googlecode.com/svn/ kgtp-read-only
+------------------------------------------------------------
+
+kgtp-read-only/tags/ There is the each release of KGTP.
+kgtp-read-only/trunk/ There is the main trunk of KGTP.
+
+
+
+
+Config KGTP
+-----------
+
+Before compile KGTP, you can choice which Kernel you want build with and
+which compiler you want through change the Makefile. For example:
+
+-------------------------------------------
+KERNELDIR := /lib/modules/`uname -r`/build
+CROSS_COMPILE :=
+-------------------------------------------
+
+KERNELDIR is set the directory which Kernel you want build for. Now it set to
+the current kernel that you use.
+CROSS_COMPILE is set the compiler that you want to build the KGTP. Empty mean
+use current compiler.
+ARCH is the architecture.
+
+------------------------------------------
+KERNELDIR := /home/teawater/kernel/bamd64
+CROSS_COMPILE :=x86_64-glibc_std-
+ARCH := x86_64
+------------------------------------------
+
+KERNELDIR is set to /home/teawater/kernel/bamd64. Compiler will
+use x86_64-glibc_std-gcc.
+
+
+
+
+Compile KGTP
+------------
+
+For normal use:
+
+---------
+cd kgtp/
+make
+---------
+
+If you want KGTP out the debug message,please use following (It is available
+after 20100825):
+
+---------
+cd kgtp/
+make D=1
+---------
+
+
+
+
+Install KGTP
+------------
+
+------------------
+cd kgtp/
+sudo make install
+------------------
+
+
+
+
+Uninstall KGTP
+--------------
+
+--------------------
+cd kgtp/
+sudo make uninstall
+--------------------
+
+
+
+
+Howto use
+---------
+
+Exec it
+-------
+
+If you had installed the KGTP in your system, you can:
+
+------------------
+sudo modprobe gtp
+------------------
+
+Or you can use the kgtp module in the directory.
+
+-------------------
+cd kgtp/
+sudo insmod gtp.ko
+-------------------
+
+
+
+Make GDB connect to gtp
+-----------------------
+
+In current machine:
+
+---------------------------------
+sudo gdb ./vmlinux
+(gdb) target remote /sys/kernel/debug/gtp
+Remote debugging using /sys/kernel/debug/gtp
+0x0000000000000000 in ?? ()
+---------------------------------
+
+In remote machine:
+
+---------------------------------------------
+#Open the KGTP interface in current machine.
+sudo su
+nc -l 1234 </sys/kernel/debug/gtp >/sys/kernel/debug/gtp
+(nc -l -p 1234 </sys/kernel/debug/gtp >/sys/kernel/debug/gtp for old version
+netcat.)
+#Let gdb connect to the port 1234
+gdb ./vmlinux
+(gdb) target remote xxx.xxx.xxx.xxx:1234
+---------------------------------------------
+
+
+
+Add module symbols to GDB
+-------------------------
+
+Sometime, you need add the Linux Kernel module(lkm) symbols to GDB to debug it.
+Following a example howto add ext3.ko's symbols to GDB:
+
+--------------------------------------------------------------------------------
+cat /proc/modules  | grep ext
+ext3 116512 3 - Live 0xf9083000
+#Get the address 0xf9083000.
+modinfo ext3
+filename:       /lib/modules/2.6.36-rc2+/kernel/fs/ext3/ext3.ko
+#Get the directory name of ext3.
+(gdb) add-symbol-file /lib/modules/2.6.36-rc2+/kernel/fs/ext3/ext3.ko
0xf9083000
+#Then, GDB get the symbols of ext3.
+--------------------------------------------------------------------------------
+
+You will see that it just add the text section info to GDB, sometime you need
+add another section info of other section, for example:
+
+--------------------------------------------------------------------------------
+cat /sys/module/ext3/sections/.bss
+0xf908170c
+#Get the bss address 0xf908170c.
+(gdb) add-symbol-file /lib/modules/2.6.36-rc2+/kernel/fs/ext3/ext3.ko
0xf9083000 -s .bss 0xf908170c
+#Then, GDB get the symbols of ext3.
+--------------------------------------------------------------------------------
+
+
+
+Get GDB tracepoint commands
+---------------------------
+
+Please goto http://sourceware.org/gdb/current/onlinedocs/gdb/Tracepoints.html
+
+
+Get registers info from Kernel
+------------------------------
+
+Following part is an example that record the value of all registers when Linux
+Kernel call function "vfs_readdir".
+
+--------------------------------------------------------------------------------
+(gdb) trace vfs_readdir
+Tracepoint 1 at 0xc01a1ac0: file
+/home/teawater/kernel/linux-2.6/fs/readdir.c, line 23.
+(gdb) actions
+Enter actions for tracepoint 1, one per line.
+End with a line saying just "end".
+>collect $reg
+>end
+(gdb) tstart
+(gdb) shell ls
+(gdb) tstop
+(gdb) tfind
+Found trace frame 0, tracepoint 1
+#0  0xc01a1ac1 in vfs_readdir (file=0xc5528d00, filler=0xc01a1900 <filldir64>,
+   buf=0xc0d09f90) at /home/teawater/kernel/linux-2.6/fs/readdir.c:23
+23      /home/teawater/kernel/linux-2.6/fs/readdir.c: No such file or
directory.
+       in /home/teawater/kernel/linux-2.6/fs/readdir.c
+(gdb) info reg
+eax            0xc5528d00       -984445696
+ecx            0xc0d09f90       -1060069488
+edx            0xc01a1900       -1072031488
+ebx            0xfffffff7       -9
+esp            0xc0d09f8c       0xc0d09f8c
+ebp            0x0      0x0
+esi            0x8061480        134616192
+edi            0xc5528d00       -984445696
+eip            0xc01a1ac1       0xc01a1ac1 <vfs_readdir+1>
+eflags         0x286    [ PF SF IF ]
+cs             0x60     96
+ss             0x8061480        134616192
+ds             0x7b     123
+es             0x7b     123
+fs             0x0      0
+gs             0x0      0
+(gdb) tfind
+Found trace frame 1, tracepoint 1
+0xc01a1ac1      23      in /home/teawater/kernel/linux-2.6/fs/readdir.c
+(gdb) info reg
+eax            0xc5528d00       -984445696
+ecx            0xc0d09f90       -1060069488
+edx            0xc01a1900       -1072031488
+ebx            0xfffffff7       -9
+esp            0xc0d09f8c       0xc0d09f8c
+ebp            0x0      0x0
+esi            0x8061480        134616192
+edi            0xc5528d00       -984445696
+eip            0xc01a1ac1       0xc01a1ac1 <vfs_readdir+1>
+eflags         0x286    [ PF SF IF ]
+cs             0x60     96
+ss             0x8061480        134616192
+ds             0x7b     123
+es             0x7b     123
+fs             0x0      0
+gs             0x0      0
+--------------------------------------------------------------------------------
+
+
+
+Get the value of variable from Kernel
+-------------------------------------
+
+Following part is an example that record the value of "jiffies_64" when Linux
+Kernel call function "vfs_readdir".
+
+--------------------------------------------------------------------------------
+(gdb) trace vfs_readdir
+Tracepoint 1 at 0xc01ed740: file
/home/teawater/kernel/linux-2.6/fs/readdir.c, line 24.
+(gdb) actions
+Enter actions for tracepoint 1, one per line.
+End with a line saying just "end".
+>collect jiffies_64
+>collect file->f_path.dentry->d_iname
+>end
+(gdb) tstart
+(gdb) shell ls
+arch    drivers   include  kernel    mm               Module.symvers
security  System.map  virt
+block   firmware  init     lib       modules.builtin  net
sound     t           vmlinux
+crypto  fs        ipc      Makefile  modules.order    scripts
source    usr         vmlinux.o
+(gdb) tstop
+(gdb) tfind
+Found trace frame 0, tracepoint 1
+#0  0xc01ed741 in vfs_readdir (file=0xf4063000, filler=0xc01ed580
<filldir64>, buf=0xd6dfdf90)
+    at /home/teawater/kernel/linux-2.6/fs/readdir.c:24
+24      {
+(gdb) p jiffies_64
+$1 = 4297248706
+(gdb) p file->f_path.dentry->d_iname
+$1 = "b26", '\000' <repeats 28 times>
+--------------------------------------------------------------------------------
+
+
+
+How to use use tracepoint condition
+-----------------------------------
+
+http://sourceware.org/gdb/current/onlinedocs/gdb/Tracepoint-Conditions.html
+Like the breakpoint, we can set condition to tracepoint. But it speed is more
+fast than breakpoint's condition because KGTP do all the condition check.
+For example:
+
+------------------------------
+(gdb) trace handle_irq
+(gdb) condition 1 (irq == 47)
+------------------------------
+
+This action of tracepoint 1 will work only when irq number is 47.
+
+
+
+How to use trace state variables
+--------------------------------
+
+http://sourceware.org/gdb/current/onlinedocs/gdb/Trace-State-Variables.html
+Tracepoint have special variables. You can trace it or use it in tracepoint
+condition.
+Note that only GDB 7.2.1 and later version support use trace state variables
+directly, the old version GDB just can show the value of trace state variables
+through command "info tvariables".
+
+
+Simple trace state variables
+----------------------------
+
+Define a trace state variable $c.
+
+-------------------
+(gdb) tvariable $c
+-------------------
+
+Trace state variable $c created, with initial value 0.
+Use it in the action. Follow action will use $c to count how much irq happen
+in Kernel.
+
+-----------------------------------------------------------------------
+(gdb) trace handle_irq
+(gdb) actions
+Enter actions for tracepoint 3, one per line.
+End with a line saying just "end".
+>collect $c     #Save current value of $c to the trace frame buffer.
+>teval $c=$c+1  #Increase the $c.
+>end
+-----------------------------------------------------------------------
+
+You can get the current value of $c when the trace is running or stop.
+
+----------------------------------
+(gdb) tstart
+(gdb) info tvariables
+$c              0           31554
+(gdb) p $c
+$5 = 33652
+(gdb) tstop
+(gdb) p $c
+$9 = 105559
+----------------------------------
+
+When use the tfind parse the trace frame buffer, if the value of trace state
+variable is collect. You can use it.
+
+------------------------------
+(gdb) tstop
+(gdb) tfind
+(gdb) info tvariables
+$c              0           0
+(gdb) p $c
+$6 = 0
+(gdb) tfind 100
+(gdb) p $c
+$7 = 100
+------------------------------
+
+
+Special trace state variables $current_task, $current_thread_info, $cpu_id,
+$dump_stack, $printk_level, $printk_format, $printk_tmp and $clock
+--------------------------------------------------------------------------
+
+KGTP have special trace state variables $current_task, $current_thread_info,
+$cpu_id and $clock can very easy to access to some special value. You can see
+them when GDB connect to the KGTP. You can use them in tracepoint condition
+or actions.
+Access $current_task in tracepoint condition and action will get the return
+of get_current().
+Access $current_thread_info in tracepoint condition and action will get the
+return of current_thread_info().
+Access $cpu_id in tracepoint condition and action will get the return of
+smp_processor_id().
+Access $clock in tracepoint condition and action will get the return of
+local_clock() that return the timestamp in nanoseconds.
+
+And KGTP have other special trace state variables $dump_stack, $printk_level,
+$printk_format and $printk_tmp, all of them are for output value directly that
+will introduce in "Howto let tracepoint output value directly".
+
+Following example will count process 16663 call how many sys_read in $c
+and collect the struct thread_info of current task:
+
+--------------------------------------------------------------------------------
+(gdb) trace vfs_read if ((*(struct task_struct *)$current_task)->pid == 16663)
+(gdb) tvariable $c
+(gdb) actions
+Enter actions for tracepoint 4, one per line.
+End with a line saying just "end".
+>teval $c=$c+1
+>collect (*(struct thread_info *)$current_thread_info)
+>end
+(gdb) tstart
+(gdb) info tvariables
+Name            Initial     Current
+$c              0           184
+$current_task   0           <unknown>
+$current_thread_info 0           <unknown>
+$cpu_id         0           <unknown>
+(gdb) tstop
+(gdb) tfind
+(gdb) p *(struct thread_info *)$current_thread_info
+$10 = {task = 0xf0ac6580, exec_domain = 0xc07b1400, flags = 0, status
= 0, cpu = 1, preempt_count = 2, addr_limit = {
+    seg = 4294967295}, restart_block = {fn = 0xc0159fb0
<do_no_restart_syscall>, {{arg0 = 138300720, arg1 = 11,
+        arg2 = 1, arg3 = 78}, futex = {uaddr = 0x83e4d30, val = 11,
flags = 1, bitset = 78, time = 977063750,
+        uaddr2 = 0x0}, nanosleep = {index = 138300720, rmtp = 0xb,
expires = 335007449089}, poll = {
+        ufds = 0x83e4d30, nfds = 11, has_timeout = 1, tv_sec = 78,
tv_nsec = 977063750}}},
+  sysenter_return = 0xb77ce424, previous_esp = 0, supervisor_stack =
0xef340044 "", uaccess_err = 0}
+--------------------------------------------------------------------------------
+
+nother example can show how much sys_read() execute in each cpu.
+
+--------------------------------------
+tvariable $c0
+tvariable $c1
+trace sys_read
+  condition $bpnum ($cpu_id == 0)
+  commands
+    teval $c0=$c0+1
+  end
+trace sys_read
+  condition $bpnum ($cpu_id == 1)
+  commands
+    teval $c1=$c1+1
+  end
+info tvariables
+Name            Initial     Current
+$current_task   0           <unknown>
+$cpu_id         0           <unknown>
+$c0             0           3255
+$c1             0           1904
+--------------------------------------
+
+sys_read() execute 3255 times in cpu0 and 1904 times in cpu1.
+
+
+
+Show all the traced data of current frame
+-----------------------------------------
+
+--------------------------------------------------------------------------------
+(gdb) tdump
+Data collected at tracepoint 1, trace frame 0:
+$cr = void
+file->f_path.dentry->d_iname =
"gtp\000.google.chrome.g05ZYO\000\235", <incomplete sequence \364>
+jiffies_64 = 4319751455
+--------------------------------------------------------------------------------
+
+
+
+Get backtrace info from Kernel
+------------------------------
+
+We can get the backtrace through collect the stack.
+In x86_32, following action command will collect 512 bytes of stack.
+
+-----------------------------------
+collect *(unsigned char *)$esp@512
+-----------------------------------
+
+In x86_64, following command will collect 512 bytes of stack.
+
+-----------------------------------
+collect *(unsigned char *)$rsp@512
+-----------------------------------
+
+In MIPS or ARM, following command will collect 512 bytes of stack.
+----------------------------------
+collect *(unsigned char *)$sp@512
+-----------------------------------
+
+Following part is an example about howto backtrace in x86_64:
+
+--------------------------------------------------------------------------------
+(gdb) trace vfs_readdir
+Tracepoint 1 at 0xffffffff8113f7fc: file
/home/teawater/kernel/linux-2.6/fs/readdir.c, line 24.
+(gdb) actions
+Enter actions for tracepoint 1, one per line.
+End with a line saying just "end".
+>collect *(unsigned char *)$rsp@512
+>end
+(gdb) tstart
+(gdb) shell ls
+2      block    firmware  i        ipc     Makefile
modules.order   scripts   source      t~    vmlinux
+a.out  crypto   fs        include  kernel  mm
Module.symvers  security  System.map  usr   vmlinux.o
+arch   drivers  gdb.txt   init     lib     modules.builtin  net
      sound     t           virt
+(gdb) tstop
+(gdb) tfind
+Found trace frame 0, tracepoint 1
+#0  0xffffffff8113f7fd in vfs_readdir (file=0xffff880075f00780,
filler=0xffffffff8113f630 <filldir>, buf=0xffff880005785f38)
+    at ./linux-2.6/fs/readdir.c:24
+24      {
+(gdb) bt
+#0  0xffffffff8113f7fd in vfs_readdir (file=0xffff880075f00780,
filler=0xffffffff8113f630 <filldir>, buf=0xffff880005785f38)
+    at ./linux-2.6/fs/readdir.c:24
+#1  0xffffffff8113fa14 in sys_getdents (fd=<value optimized out>,
dirent=0x801108, count=32768)
+    at ./linux-2.6/fs/readdir.c:214
+#2  0xffffffff8100af42 in ?? () at ./linux-2.6/arch/x86/kernel/entry_64.S:487
+--------------------------------------------------------------------------------
+
+
+
+Howto let tracepoint output value directly
+------------------------------------------
+
+In the previous parts, you can get that to get the value from Linux Kernel you
+need use tracepoint action "collect" save value to the tracepoint frame and
+use GDB command "tfind" parse the the value out from the frame.
+But we want get the value directly sometime, so KGTP support two ways to output
+value directly.
+
+
+Output stack dump directly
+--------------------------
+KGTP have special trace state variables $dump_stack, "collect" it will let
+Linux Kernel output stack dump directly.
+
+Following example let Linux Kernel show the stack dump of vfs_readdir:
+
+--------------------------------------------------------------------------------
+trace vfs_readdir
+  commands
+    collect $dump_stack
+  end
+--------------------------------------------------------------------------------
+
+Then your kernel will printk like:
+
+--------------------------------------------------------------------------------
+[22779.208064] gtp 1:Pid: 441, comm: python Not tainted 2.6.39-rc3+ #46
+[22779.208068] Call Trace:
+[22779.208072]  [<fe653cca>] gtp_get_var+0x4a/0xa0 [gtp]
+[22779.208076]  [<fe653d79>] gtp_collect_var+0x59/0xa0 [gtp]
+[22779.208080]  [<fe655974>] gtp_action_x+0x1bb4/0x1dc0 [gtp]
+[22779.208084]  [<c05b6408>] ? _raw_spin_unlock+0x18/0x40
+[22779.208088]  [<c023f152>] ? __find_get_block_slow+0xd2/0x160
+[22779.208091]  [<c01a8c56>] ? delayacct_end+0x96/0xb0
+[22779.208100]  [<c023f404>] ? __find_get_block+0x84/0x1d0
+[22779.208103]  [<c05b6408>] ? _raw_spin_unlock+0x18/0x40
+[22779.208106]  [<c02e0838>] ? find_revoke_record+0xa8/0xc0
+[22779.208109]  [<c02e0c45>] ? jbd2_journal_cancel_revoke+0xd5/0xe0
+[22779.208112]  [<c02db51f>] ? __jbd2_journal_temp_unlink_buffer+0x2f/0x110
+[22779.208115]  [<fe655c4c>] gtp_kp_pre_handler+0xcc/0x1c0 [gtp]
+[22779.208118]  [<c05b8a88>] kprobe_exceptions_notify+0x3d8/0x440
+[22779.208121]  [<c05b7d54>] ? hw_breakpoint_exceptions_notify+0x14/0x180
+[22779.208124]  [<c05b95eb>] ? sub_preempt_count+0x7b/0xb0
+[22779.208126]  [<c0227ac5>] ? vfs_readdir+0x15/0xb0
+[22779.208128]  [<c0227ac4>] ? vfs_readdir+0x14/0xb0
+[22779.208131]  [<c05b9743>] notifier_call_chain+0x43/0x60
+[22779.208134]  [<c05b9798>] __atomic_notifier_call_chain+0x38/0x50
+[22779.208137]  [<c05b97cf>] atomic_notifier_call_chain+0x1f/0x30
+[22779.208140]  [<c05b980d>] notify_die+0x2d/0x30
+[22779.208142]  [<c05b71c5>] do_int3+0x35/0xa0
+--------------------------------------------------------------------------------
+
+
+Switch collect to output the value directly
+-------------------------------------------
+
+KGTP have special trace state variables $printk_level, $printk_format
+and $printk_tmp to support this function.
+
+$printk_level, if its value is 8 (this is the default value), "collect" will
+save value to the tracepoint frame.
+If its value is 0-7, "collect" will output the value through "printk" directly,
+and value will be the level of printk.  The level is:
+0	KERN_EMERG	system is unusable
+1	KERN_ALERT	action must be taken immediately
+2	KERN_CRIT	critical conditions
+3	KERN_ERR	error conditions
+4	KERN_WARNING	warning conditions
+5	KERN_NOTICE	normal but significant condition
+6	KERN_INFO	informational
+7	KERN_DEBUG	debug-level messages
+
+$printk_format, collect printk will output value in the format that set by it.
+The format is:
+0	This is the default value.
+	If the size of collect value is 1, 2, 4 or 8, it will be outputted as
+	a unsigned decimal.
+	If not, it will be outputted as a hexadecimal string.
+1	Output value in signed decimal.
+2	Output value in unsigned decimal.
+3	Output value in unsigned hexadecimal.
+4	Output value as a string.
+5	Output value as a hexadecimal string.
+
+$printk_tmp, to output the value of global variable need set to it first.
+
+Following example show the a count number, pid, jiffies_64 and the file name
+that call vfs_readdir:
+
+--------------------------------------------------------------------------------
+tvariable $c
+trace vfs_readdir
+  commands
+    teval $printk_level=0
+    collect $c=$c+1
+    collect (*(struct task_struct *)$current_task)->pid
+    collect $printk_tmp=jiffies_64
+    teval $printk_format=4
+    collect file->f_path.dentry->d_iname
+  end
+--------------------------------------------------------------------------------
+
+Then your kernel will printk like:
+
+--------------------------------------------------------------------------------
+gtp 1:$c=$c+1=41
+gtp 1:(*(struct task_struct *)$current_task)->pid=12085
+gtp 1:$printk_tmp=jiffies_64=4322021438
+gtp 1:file->f_path.dentry->d_iname=b26
+gtp 1:$c=$c+1=42
+gtp 1:(*(struct task_struct *)$current_task)->pid=12085
+gtp 1:$printk_tmp=jiffies_64=4322021438
+gtp 1:file->f_path.dentry->d_iname=b26
+--------------------------------------------------------------------------------
+
+"gtp 1" mean that it output by tracepoint 1.
+
+
+Use printf command in actions
+-----------------------------
+
+This way have a trouble is GDB is still not accept the patch that make
+tracepoint support printf, So if you want use it, you need patch the patch in
+http://sourceware.org/ml/gdb-patches/2011-03/msg00022.html and build your
+GDB with yourself.
+
+Following example show the a count number, pid and the file name that call
+vfs_readdir:
+
+--------------------------------------------------------------------------------
+tvariable $c
+trace vfs_readdir
+  commands
+    printf "<0>%d pid=%d name:%s\n", $c=$c+1, (*(struct task_struct
*)$current_task)->pid, file->f_path.dentry->d_iname
+  end
+--------------------------------------------------------------------------------
+
+Then your kernel will printk like:
+
+--------------------------------------------------------------------------------
+1 pid=10888 name:bin
+2 pid=10888 name:bin
+3 pid=10893 name:teawater
+4 pid=10893 name:teawater
+--------------------------------------------------------------------------------
+
+Like what we use printk in Linux Kernel, please add kernel loglevel
in the begin
+and add "\n" in the end.
+The kernel loglevel is:
+KERN_EMERG	"<0>"	system is unusable
+KERN_ALERT	"<1>"	action must be taken immediately
+KERN_CRIT	"<2>"	critical conditions
+KERN_ERR	"<3>"	error conditions
+KERN_WARNING	"<4>"	warning conditions
+KERN_NOTICE	"<5>"	normal but significant condition
+KERN_INFO	"<6>"	informational
+KERN_DEBUG	"<7>"	debug-level messages
+
+
+
+Get status of KGTP from Kernel
+------------------------------
+Please use GDB command "tstatus"
+
+
+
+Set the trace buffer into a circular buffer
+-------------------------------------------
+http://sourceware.org/gdb/current/onlinedocs/gdb/Starting-and-Stopping-Trace-Experiments.html
+The frame buffer is not a circular buffer by default. When the buffer is full,
+the tracepoint will stop.
+
+-----------------------------
+set circular-trace-buffer on
+-----------------------------
+
+Set frame buffer to a circular buffer. When the buffer is full, it will auto
+discard traceframes (oldest first) and keep trace.
+
+
+
+Do not stop tracepoint when the GDB disconnect
+----------------------------------------------
+
+http://sourceware.org/gdb/current/onlinedocs/gdb/Starting-and-Stopping-Trace-Experiments.html
+The KGTP will stop and delete the trace frame when GDB disconnect with it by
+default.
+
+----------------------------
+set disconnected-tracing on
+----------------------------
+will open the KGTP disconnect-trace. After that, when GDB disconnect with KGTP,
+KGTP will not stop trace. And after GDB reconnect to KGTP, it can keep control
+the KGTP like nothing happen.
+
+
+
+Howto show the variable that value of it is optimized
+-----------------------------------------------------
+
+Sometimes, GDB will output some value like:
+
+-------------------------------------------
+inode has been optimized out of existence.
+res has been optimized out of existence.
+-------------------------------------------
+
+That is because value of inode and res is optimized. Linux Kernel is built
+with -O2 so you will get this trouble sometimes.
+There are 2 ways to handle it:
+
+Linux kernel "Compile with almost no optimization" patch
+--------------------------------------------------------
+If you do not care about the speed when you debug the Kernel, you can use the
+patch for Linux Kernel in
+http://code.google.com/p/kgtp/downloads/detail?name=co.patch It add a option
+in "Kernel hacking" called "Compile with almost no optimization". It will make
+kernel be built without -O2. It support x86_32, x86_64 and arm.
+
+Update your GCC
+---------------
+The VTA branch(http://gcc.gnu.org/wiki/Var_Tracking_Assignments) was merged
+for GCC 4.5 Which helps a lot with generating dwarf for previously
+"optimized out" values.
+
+
+
+Offline debug
+-------------
+
+In the PC that can run the GDB:
+Change the "target remote XXXX" to
+
+------------------------------------------
+(gdb) target remote | perl ./getgtprsp.pl
+------------------------------------------.
+
+After that, set tracepoint and start it as usual:
+
+--------------------------------------------------------------------------------
+(gdb) trace vfs_readdir
+Tracepoint 1 at 0xffffffff8114f3c0: file
/home/teawater/kernel/linux-2.6/fs/readdir.c, line 24.
+(gdb) actions
+Enter actions for tracepoint 1, one per line.
+End with a line saying just "end".
+#If your GDB support tracepoint "printf" (see "Howto use tracepoint
printf"), use it to show the value directly is better.
+>collect $reg
+>end
+(gdb) tstart
+(gdb) stop
+(gdb) quit
+--------------------------------------------------------------------------------
+
+Then you can find files gtpstart and gtpstop. Copy it to the machine that you
+want debug.
+
+
+In the debuged machine after insmod the gtp.ko:
+Start the tracepoint:
+
+------------------------------------
+cat gtpstart > /sys/kernel/debug/gtp
+------------------------------------
+
+Stop the tracepoint:
+
+-----------------------------------
+cat gtpstop > /sys/kernel/debug/gtp
+-----------------------------------
+
+You can let Linux Kernel show the value directly, please see "Howto let
+tracepoint output value directly".
+
+If you want save the value to the trace frame and parse later, you can use file
+"/sys/kernel/debug/gtpframe" that have the trace frame. Copy it to the PC that
+has GDB.
+
+In the PC that can run the GDB:
+
+--------------------------------------------------------------------------------
+(gdb) target tfile ./gtpframe
+Tracepoint 1 at 0xffffffff8114f3dc: file
/home/teawater/kernel/linux-2.6/fs/readdir.c, line 24.
+Created tracepoint 1 for target's tracepoint 1 at 0xffffffff8114f3c0.
+(gdb) tfind
+Found trace frame 0, tracepoint 1
+#0  vfs_readdir (file=0xffff880036e8f300, filler=0xffffffff8114f240
<filldir>, buf=0xffff880001e5bf38)
+    at /home/teawater/kernel/linux-2.6/fs/readdir.c:24
+24      {
+--------------------------------------------------------------------------------
--- /dev/null
+++ b/arch/arm/include/asm/gtp.h
@@ -0,0 +1,13 @@
+#ifndef _ASM_ARM_GTP_H_
+#define _ASM_ARM_GTP_H_
+
+#define ULONGEST		uint64_t
+#define LONGEST			int64_t
+#define CORE_ADDR		unsigned long
+
+#define GTP_REGS_PC(regs)	((regs)->uregs[15])
+
+#define GTP_REG_ASCII_SIZE	336
+#define GTP_REG_BIN_SIZE	168
+
+#endif
--- /dev/null
+++ b/arch/mips/include/asm/gtp.h
@@ -0,0 +1,18 @@
+#ifndef _ASM_MIPS_GTP_H_
+#define _ASM_MIPS_GTP_H_
+
+#define ULONGEST		uint64_t
+#define LONGEST			int64_t
+#define CORE_ADDR		unsigned long
+
+#define GTP_REGS_PC(regs)	((regs)->cp0_epc)
+
+#ifdef CONFIG_32BIT
+#define GTP_REG_ASCII_SIZE	304
+#define GTP_REG_BIN_SIZE	152
+#else
+#define GTP_REG_ASCII_SIZE	608
+#define GTP_REG_BIN_SIZE	304
+#endif
+
+#endif
--- /dev/null
+++ b/arch/x86/include/asm/gtp.h
@@ -0,0 +1,18 @@
+#ifndef _ASM_X86_GTP_H_
+#define _ASM_X86_GTP_H_
+
+#define ULONGEST		uint64_t
+#define LONGEST			int64_t
+#define CORE_ADDR		unsigned long
+
+#define GTP_REGS_PC(regs)	((regs)->ip)
+
+#ifdef CONFIG_X86_32
+#define GTP_REG_ASCII_SIZE	128
+#define GTP_REG_BIN_SIZE	64
+#else
+#define GTP_REG_ASCII_SIZE	296
+#define GTP_REG_BIN_SIZE	148
+#endif
+
+#endif
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1253,6 +1253,15 @@ config ASYNC_RAID6_TEST

 	  If unsure, say N.

+config GTP
+	tristate "GDB tracepoint support"
+	depends on X86 || ARM || MIPS
+	depends on KPROBES
+	depends on DEBUG_FS
+	---help---
+	  Supply GDB tracepoint interface in /sys/kernel/debug/gtp.
+          See https://code.google.com/p/kgtp/wiki/HOWTO
+
 source "samples/Kconfig"

 source "lib/Kconfig.kgdb"
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -115,6 +115,8 @@ obj-$(CONFIG_AVERAGE) += average.o

 obj-$(CONFIG_CPU_RMAP) += cpu_rmap.o

+obj-$(CONFIG_GTP) += gtp.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h

--- /dev/null
+++ b/lib/gtp.c
@@ -0,0 +1,5104 @@
+/*
+ * Kernel GDB tracepoint module.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright(C) Hui Zhu (teawater@gmail.com), 2010, 2011
+ */
+
+#include <linux/version.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <linux/vmalloc.h>
+#include <linux/poll.h>
+#include <linux/kprobes.h>
+#include <linux/debugfs.h>
+#include <asm/gtp.h>
+
+#define KERN_NULL
+
+#ifdef GTPDEBUG
+#define GTP_DEBUG		KERN_WARNING
+#endif
+
+#define GTP_RW_MAX		16384
+
+#define FRAME_ALIGN_SIZE	sizeof(unsigned int)
+#define FRAME_ALIGN(x)		((x + FRAME_ALIGN_SIZE - 1) \
+				 & (~(FRAME_ALIGN_SIZE - 1)))
+
+#define FID_TYPE		unsigned int
+#define FID_SIZE		sizeof(FID_TYPE)
+#define FID(x)			(*((FID_TYPE *)x))
+#define FID_HEAD		0
+#define FID_REG			1
+#define FID_MEM			2
+#define FID_VAR			3
+#define FID_END			4
+
+/* GTP_FRAME_SIZE must align with FRAME_ALIGN_SIZE.  */
+#define GTP_FRAME_SIZE		5242880
+#define GTP_FRAME_HEAD_SIZE	(FID_SIZE + sizeof(char *) + sizeof(ULONGEST))
+#define GTP_FRAME_REG_SIZE	(FID_SIZE + sizeof(char *) \
+				 + sizeof(struct pt_regs))
+#define GTP_FRAME_MEM_SIZE	(FID_SIZE + sizeof(char *) \
+				 + sizeof(struct gtp_frame_mem))
+#define GTP_FRAME_VAR_SIZE	(FID_SIZE + sizeof(char *) \
+				 + sizeof(struct gtp_frame_var))
+
+#define TOHEX(h)		((h) > 9 ? (h) + 'a' - 10 : (h) + '0')
+
+struct action_agent_exp {
+	unsigned int	size;
+	uint8_t		*buf;
+	int		need_var_lock;
+};
+
+struct action_m {
+	int		regnum;
+	CORE_ADDR	offset;
+	size_t		size;
+};
+
+struct action {
+	struct action	*next;
+	unsigned char	type;
+	char		*src;
+	union {
+		ULONGEST		reg_mask;
+		struct action_agent_exp	exp;
+		struct action_m		m;
+	} u;
+};
+
+struct gtpsrc {
+	struct gtpsrc	*next;
+	char		*src;
+};
+
+enum gtp_stop_type {
+	gtp_stop_normal = 0,
+	gtp_stop_frame_full,
+	gtp_stop_efault,
+	gtp_stop_access_wrong_reg,
+	gtp_stop_agent_expr_code_error,
+	gtp_stop_agent_expr_stack_overflow,
+};
+
+struct gtp_entry {
+	struct gtp_entry	*next;
+	int			disable;
+	ULONGEST		num;
+	ULONGEST		addr;
+	ULONGEST		step;
+	ULONGEST		pass;
+	int			nopass;
+	atomic_t		current_pass;
+	int			kpreg;
+	struct kprobe		kp;
+	struct work_struct	work;
+	enum gtp_stop_type	reason;
+	struct action		*cond;
+	struct action		*action_list;
+	struct gtpsrc		*src;
+	int			have_printk;
+	struct gtpsrc		*printk_str;
+};
+
+struct gtp_var {
+	struct gtp_var	*next;
+	unsigned int	num;
+	uint64_t	val;
+	char		*src;
+};
+
+struct gtp_frame_mem {
+	CORE_ADDR	addr;
+	size_t		size;
+};
+
+struct gtp_frame_var {
+	unsigned int	num;
+	uint64_t	val;
+};
+
+struct gtpro_entry {
+	struct gtpro_entry	*next;
+	CORE_ADDR		start;
+	CORE_ADDR		end;
+};
+
+static struct gtp_entry		*gtp_list;
+static struct gtp_entry		*current_gtp;
+static struct action		*current_gtp_action;
+static struct gtpsrc		*current_gtp_src;
+
+static struct workqueue_struct	*gtp_wq;
+
+static char			gtp_read_ack;
+static char			*gtp_rw_buf;
+static char			*gtp_rw_bufp;
+static size_t			gtp_rw_size;
+
+static int			gtp_start;
+
+static int			gtp_disconnected_tracing;
+static int			gtp_circular;
+
+static DEFINE_SPINLOCK(gtp_var_lock);
+static struct gtp_var		*gtp_var_list;
+static unsigned int		gtp_var_head;
+static unsigned int		gtp_var_tail;
+static struct gtp_var		**gtp_var_array;
+static struct gtp_var		*current_gtp_var;
+#define GTP_VAR_CURRENT_TASK_ID		1
+static struct gtp_var		gtp_var_current_task = {
+	.next	= NULL,
+	.num	= GTP_VAR_CURRENT_TASK_ID,
+	.src	= "0:1:63757272656e745f7461736b",
+};
+#define GTP_VAR_CURRENT_THREAD_INFO_ID	2
+static struct gtp_var		gtp_var_current_thread_info = {
+	.next	= &gtp_var_current_task,
+	.num	= GTP_VAR_CURRENT_THREAD_INFO_ID,
+	.src	= "0:1:63757272656e745f7468726561645f696e666f",
+};
+#define GTP_VAR_CLOCK_ID		3
+static struct gtp_var		gtp_var_clock = {
+	.next	= &gtp_var_current_thread_info,
+	.num	= GTP_VAR_CLOCK_ID,
+	.src	= "0:1:636c6f636b",
+};
+#define GTP_VAR_CPU_ID			4
+static struct gtp_var		gtp_var_cpu_id = {
+	.next	= &gtp_var_clock,
+	.num	= GTP_VAR_CPU_ID,
+	.src	= "0:1:6370755f6964",
+};
+#define GTP_VAR_PRINTK_TMP_ID		5
+static struct gtp_var		gtp_var_printk_tmp = {
+	.next	= &gtp_var_cpu_id,
+	.num	= GTP_VAR_PRINTK_TMP_ID,
+	.src	= "0:1:7072696e746b5f746d70",
+};
+#define GTP_VAR_PRINTK_LEVEL_ID		6
+static struct gtp_var		gtp_var_printk_level = {
+	.next	= &gtp_var_printk_tmp,
+	.num	= GTP_VAR_PRINTK_LEVEL_ID,
+	.src	= "8:1:7072696e746b5f6c6576656c",
+};
+#define GTP_VAR_PRINTK_FORMAT_ID	7
+static struct gtp_var		gtp_var_printk_format = {
+	.next	= &gtp_var_printk_level,
+	.num	= GTP_VAR_PRINTK_FORMAT_ID,
+	.src	= "0:1:7072696e746b5f666f726d6174",
+};
+#define GTP_VAR_DUMP_STACK_ID		8
+static struct gtp_var		gtp_var_dump_stack = {
+	.next	= &gtp_var_printk_format,
+	.num	= GTP_VAR_DUMP_STACK_ID,
+	.src	= "0:1:64756d705f737461636b",
+};
+#define GTP_VAR_LIST_FIRST		(&gtp_var_dump_stack)
+#define GTP_VAR_SPECIAL_MIN		GTP_VAR_CURRENT_TASK_ID
+#define GTP_VAR_SPECIAL_MAX		GTP_VAR_DUMP_STACK_ID
+#define GTP_VAR_IS_SPECIAL(x)		((x) >= GTP_VAR_SPECIAL_MIN \
+					 && (x) <= GTP_VAR_SPECIAL_MAX)
+#define GTP_VAR_NOT_GETV(x)		((x) == GTP_VAR_PRINTK_LEVEL_ID \
+					 || (x) == GTP_VAR_PRINTK_FORMAT_ID)
+#define GTP_VAR_NOT_SETV(x)		(((x) >= GTP_VAR_CURRENT_TASK_ID \
+					  && (x) <= GTP_VAR_CPU_ID) \
+					 || (x) == GTP_VAR_DUMP_STACK_ID)
+#define GTP_VAR_NOT_TRACEV(x)		((x) >= GTP_VAR_PRINTK_LEVEL_ID \
+					 && (x) <= GTP_VAR_PRINTK_FORMAT_ID)
+
+static DEFINE_SPINLOCK(gtp_frame_lock);
+static char			*gtp_frame;
+static char			*gtp_frame_r_start;
+static char			*gtp_frame_w_start;
+static char			*gtp_frame_end;
+static int			gtp_frame_is_circular;
+static char			*gtp_frame_current;
+static int			gtp_frame_current_num;
+static atomic_t			gtp_frame_create;
+static char			*gtp_frame_file;
+static size_t			gtp_frame_file_size;
+
+static struct gtpro_entry	*gtpro_list;
+
+#define GTP_PRINTF_MAX		256
+static DEFINE_PER_CPU(char[GTP_PRINTF_MAX], gtp_printf);
+
+#ifdef CONFIG_X86
+static ULONGEST
+gtp_action_reg_read(struct pt_regs *regs, struct gtp_entry *tpe, int num)
+{
+	ULONGEST	ret;
+
+	switch (num) {
+#ifdef CONFIG_X86_32
+	case 0:
+		ret = regs->ax;
+		break;
+	case 1:
+		ret = regs->cx;
+		break;
+	case 2:
+		ret = regs->dx;
+		break;
+	case 3:
+		ret = regs->bx;
+		break;
+	case 4:
+		ret = (ULONGEST)(CORE_ADDR)&regs->sp;
+		break;
+	case 5:
+		ret = regs->bp;
+		break;
+	case 6:
+		ret = regs->si;
+		break;
+	case 7:
+		ret = regs->di;
+		break;
+	case 8:
+		ret = regs->ip - 1;
+		break;
+	case 9:
+		ret = regs->flags;
+		break;
+	case 10:
+		ret = regs->cs;
+		break;
+	case 11:
+		ret = regs->ss;
+		break;
+	case 12:
+		ret = regs->ds;
+		break;
+	case 13:
+		ret = regs->es;
+		break;
+	case 14:
+		ret = regs->fs;
+		break;
+	case 15:
+		ret = regs->gs;
+		break;
+#else
+	case 0:
+		ret = regs->ax;
+		break;
+	case 1:
+		ret = regs->bx;
+		break;
+	case 2:
+		ret = regs->cx;
+		break;
+	case 3:
+		ret = regs->dx;
+		break;
+	case 4:
+		ret = regs->si;
+		break;
+	case 5:
+		ret = regs->di;
+		break;
+	case 6:
+		ret = regs->bp;
+		break;
+	case 7:
+		ret = regs->sp;
+		break;
+	case 8:
+		ret = regs->r8;
+		break;
+	case 9:
+		ret = regs->r9;
+		break;
+	case 10:
+		ret = regs->r10;
+		break;
+	case 11:
+		ret = regs->r11;
+		break;
+	case 12:
+		ret = regs->r12;
+		break;
+	case 13:
+		ret = regs->r13;
+		break;
+	case 14:
+		ret = regs->r14;
+		break;
+	case 15:
+		ret = regs->r15;
+		break;
+	case 16:
+		ret = regs->ip - 1;
+		break;
+	case 17:
+		ret = regs->flags;
+		break;
+	case 18:
+		ret = regs->cs;
+		break;
+	case 19:
+		ret = regs->ss;
+		break;
+#endif
+	default:
+		ret = 0;
+		tpe->reason = gtp_stop_access_wrong_reg;
+		break;
+	}
+
+	return ret;
+}
+
+static void
+gtp_regs2ascii(struct pt_regs *regs, char *buf)
+{
+#ifdef CONFIG_X86_32
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_regs2ascii: ax = 0x%x\n",
+		(unsigned int) regs->ax);
+	printk(GTP_DEBUG "gtp_regs2ascii: cx = 0x%x\n",
+		(unsigned int) regs->cx);
+	printk(GTP_DEBUG "gtp_regs2ascii: dx = 0x%x\n",
+		(unsigned int) regs->dx);
+	printk(GTP_DEBUG "gtp_regs2ascii: bx = 0x%x\n",
+		(unsigned int) regs->bx);
+	printk(GTP_DEBUG "gtp_regs2ascii: sp = 0x%x\n",
+		(unsigned int) regs->sp);
+	printk(GTP_DEBUG "gtp_regs2ascii: bp = 0x%x\n",
+		(unsigned int) regs->bp);
+	printk(GTP_DEBUG "gtp_regs2ascii: si = 0x%x\n",
+		(unsigned int) regs->si);
+	printk(GTP_DEBUG "gtp_regs2ascii: di = 0x%x\n",
+		(unsigned int) regs->di);
+	printk(GTP_DEBUG "gtp_regs2ascii: ip = 0x%x\n",
+		(unsigned int) regs->ip);
+	printk(GTP_DEBUG "gtp_regs2ascii: flags = 0x%x\n",
+		(unsigned int) regs->flags);
+	printk(GTP_DEBUG "gtp_regs2ascii: cs = 0x%x\n",
+		(unsigned int) regs->cs);
+	printk(GTP_DEBUG "gtp_regs2ascii: ss = 0x%x\n",
+		(unsigned int) regs->ss);
+	printk(GTP_DEBUG "gtp_regs2ascii: ds = 0x%x\n",
+		(unsigned int) regs->ds);
+	printk(GTP_DEBUG "gtp_regs2ascii: es = 0x%x\n",
+		(unsigned int) regs->es);
+	printk(GTP_DEBUG "gtp_regs2ascii: fs = 0x%x\n",
+		(unsigned int) regs->fs);
+	printk(GTP_DEBUG "gtp_regs2ascii: gs = 0x%x\n",
+		(unsigned int) regs->gs);
+#endif
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->ax));
+	buf += 8;
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->cx));
+	buf += 8;
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->dx));
+	buf += 8;
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->bx));
+	buf += 8;
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->sp));
+	buf += 8;
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->bp));
+	buf += 8;
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->si));
+	buf += 8;
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->di));
+	buf += 8;
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->ip));
+	buf += 8;
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->flags));
+	buf += 8;
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->cs));
+	buf += 8;
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->ss));
+	buf += 8;
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->ds));
+	buf += 8;
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->es));
+	buf += 8;
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->fs));
+	buf += 8;
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->gs));
+	buf += 8;
+#else
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_regs2ascii: ax = 0x%lx\n", regs->ax);
+	printk(GTP_DEBUG "gtp_regs2ascii: bx = 0x%lx\n", regs->bx);
+	printk(GTP_DEBUG "gtp_regs2ascii: cx = 0x%lx\n", regs->cx);
+	printk(GTP_DEBUG "gtp_regs2ascii: dx = 0x%lx\n", regs->dx);
+	printk(GTP_DEBUG "gtp_regs2ascii: si = 0x%lx\n", regs->si);
+	printk(GTP_DEBUG "gtp_regs2ascii: di = 0x%lx\n", regs->di);
+	printk(GTP_DEBUG "gtp_regs2ascii: bp = 0x%lx\n", regs->bp);
+	printk(GTP_DEBUG "gtp_regs2ascii: sp = 0x%lx\n", regs->sp);
+	printk(GTP_DEBUG "gtp_regs2ascii: r8 = 0x%lx\n", regs->r8);
+	printk(GTP_DEBUG "gtp_regs2ascii: r9 = 0x%lx\n", regs->r9);
+	printk(GTP_DEBUG "gtp_regs2ascii: r10 = 0x%lx\n", regs->r10);
+	printk(GTP_DEBUG "gtp_regs2ascii: r11 = 0x%lx\n", regs->r11);
+	printk(GTP_DEBUG "gtp_regs2ascii: r12 = 0x%lx\n", regs->r12);
+	printk(GTP_DEBUG "gtp_regs2ascii: r13 = 0x%lx\n", regs->r13);
+	printk(GTP_DEBUG "gtp_regs2ascii: r14 = 0x%lx\n", regs->r14);
+	printk(GTP_DEBUG "gtp_regs2ascii: r15 = 0x%lx\n", regs->r15);
+	printk(GTP_DEBUG "gtp_regs2ascii: ip = 0x%lx\n", regs->ip);
+	printk(GTP_DEBUG "gtp_regs2ascii: flags = 0x%lx\n", regs->flags);
+	printk(GTP_DEBUG "gtp_regs2ascii: cs = 0x%lx\n", regs->cs);
+	printk(GTP_DEBUG "gtp_regs2ascii: ss = 0x%lx\n", regs->ss);
+#endif
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->ax));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->bx));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->cx));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->dx));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->si));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->di));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->bp));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->sp));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->r8));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->r9));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->r10));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->r11));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->r12));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->r13));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->r14));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->r15));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->ip));
+	buf += 16;
+	sprintf(buf, "%08x",
+		(unsigned int) swab32((unsigned int)regs->flags));
+	buf += 8;
+	sprintf(buf, "%08x",
+		(unsigned int) swab32((unsigned int)regs->cs));
+	buf += 8;
+	sprintf(buf, "%08x",
+		(unsigned int) swab32((unsigned int)regs->ss));
+	buf += 8;
+#endif
+}
+
+static void
+gtp_regs2bin(struct pt_regs *regs, char *buf)
+{
+#ifdef CONFIG_X86_32
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_regs2ascii: ax = 0x%x\n",
+		(unsigned int) regs->ax);
+	printk(GTP_DEBUG "gtp_regs2ascii: cx = 0x%x\n",
+		(unsigned int) regs->cx);
+	printk(GTP_DEBUG "gtp_regs2ascii: dx = 0x%x\n",
+		(unsigned int) regs->dx);
+	printk(GTP_DEBUG "gtp_regs2ascii: bx = 0x%x\n",
+		(unsigned int) regs->bx);
+	printk(GTP_DEBUG "gtp_regs2ascii: sp = 0x%x\n",
+		(unsigned int) regs->sp);
+	printk(GTP_DEBUG "gtp_regs2ascii: bp = 0x%x\n",
+		(unsigned int) regs->bp);
+	printk(GTP_DEBUG "gtp_regs2ascii: si = 0x%x\n",
+		(unsigned int) regs->si);
+	printk(GTP_DEBUG "gtp_regs2ascii: di = 0x%x\n",
+		(unsigned int) regs->di);
+	printk(GTP_DEBUG "gtp_regs2ascii: ip = 0x%x\n",
+		(unsigned int) regs->ip);
+	printk(GTP_DEBUG "gtp_regs2ascii: flags = 0x%x\n",
+		(unsigned int) regs->flags);
+	printk(GTP_DEBUG "gtp_regs2ascii: cs = 0x%x\n",
+		(unsigned int) regs->cs);
+	printk(GTP_DEBUG "gtp_regs2ascii: ss = 0x%x\n",
+		(unsigned int) regs->ss);
+	printk(GTP_DEBUG "gtp_regs2ascii: ds = 0x%x\n",
+		(unsigned int) regs->ds);
+	printk(GTP_DEBUG "gtp_regs2ascii: es = 0x%x\n",
+		(unsigned int) regs->es);
+	printk(GTP_DEBUG "gtp_regs2ascii: fs = 0x%x\n",
+		(unsigned int) regs->fs);
+	printk(GTP_DEBUG "gtp_regs2ascii: gs = 0x%x\n",
+		(unsigned int) regs->gs);
+#endif
+	memcpy(buf, &regs->ax, 4);
+	buf += 4;
+	memcpy(buf, &regs->cx, 4);
+	buf += 4;
+	memcpy(buf, &regs->dx, 4);
+	buf += 4;
+	memcpy(buf, &regs->bx, 4);
+	buf += 4;
+	memcpy(buf, &regs->sp, 4);
+	buf += 4;
+	memcpy(buf, &regs->bp, 4);
+	buf += 4;
+	memcpy(buf, &regs->si, 4);
+	buf += 4;
+	memcpy(buf, &regs->di, 4);
+	buf += 4;
+	memcpy(buf, &regs->ip, 4);
+	buf += 4;
+	memcpy(buf, &regs->flags, 4);
+	buf += 4;
+	memcpy(buf, &regs->cs, 4);
+	buf += 4;
+	memcpy(buf, &regs->ss, 4);
+	buf += 4;
+	memcpy(buf, &regs->ds, 4);
+	buf += 4;
+	memcpy(buf, &regs->es, 4);
+	buf += 4;
+	memcpy(buf, &regs->fs, 4);
+	buf += 4;
+	memcpy(buf, &regs->gs, 4);
+	buf += 4;
+#else
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_regs2ascii: ax = 0x%lx\n", regs->ax);
+	printk(GTP_DEBUG "gtp_regs2ascii: bx = 0x%lx\n", regs->bx);
+	printk(GTP_DEBUG "gtp_regs2ascii: cx = 0x%lx\n", regs->cx);
+	printk(GTP_DEBUG "gtp_regs2ascii: dx = 0x%lx\n", regs->dx);
+	printk(GTP_DEBUG "gtp_regs2ascii: si = 0x%lx\n", regs->si);
+	printk(GTP_DEBUG "gtp_regs2ascii: di = 0x%lx\n", regs->di);
+	printk(GTP_DEBUG "gtp_regs2ascii: bp = 0x%lx\n", regs->bp);
+	printk(GTP_DEBUG "gtp_regs2ascii: sp = 0x%lx\n", regs->sp);
+	printk(GTP_DEBUG "gtp_regs2ascii: r8 = 0x%lx\n", regs->r8);
+	printk(GTP_DEBUG "gtp_regs2ascii: r9 = 0x%lx\n", regs->r9);
+	printk(GTP_DEBUG "gtp_regs2ascii: r10 = 0x%lx\n", regs->r10);
+	printk(GTP_DEBUG "gtp_regs2ascii: r11 = 0x%lx\n", regs->r11);
+	printk(GTP_DEBUG "gtp_regs2ascii: r12 = 0x%lx\n", regs->r12);
+	printk(GTP_DEBUG "gtp_regs2ascii: r13 = 0x%lx\n", regs->r13);
+	printk(GTP_DEBUG "gtp_regs2ascii: r14 = 0x%lx\n", regs->r14);
+	printk(GTP_DEBUG "gtp_regs2ascii: r15 = 0x%lx\n", regs->r15);
+	printk(GTP_DEBUG "gtp_regs2ascii: ip = 0x%lx\n", regs->ip);
+	printk(GTP_DEBUG "gtp_regs2ascii: flags = 0x%lx\n", regs->flags);
+	printk(GTP_DEBUG "gtp_regs2ascii: cs = 0x%lx\n", regs->cs);
+	printk(GTP_DEBUG "gtp_regs2ascii: ss = 0x%lx\n", regs->ss);
+#endif
+	memcpy(buf, &regs->ax, 8);
+	buf += 8;
+	memcpy(buf, &regs->bx, 8);
+	buf += 8;
+	memcpy(buf, &regs->cx, 8);
+	buf += 8;
+	memcpy(buf, &regs->dx, 8);
+	buf += 8;
+	memcpy(buf, &regs->si, 8);
+	buf += 8;
+	memcpy(buf, &regs->di, 8);
+	buf += 8;
+	memcpy(buf, &regs->bp, 8);
+	buf += 8;
+	memcpy(buf, &regs->sp, 8);
+	buf += 8;
+	memcpy(buf, &regs->r8, 8);
+	buf += 8;
+	memcpy(buf, &regs->r9, 8);
+	buf += 8;
+	memcpy(buf, &regs->r10, 8);
+	buf += 8;
+	memcpy(buf, &regs->r11, 8);
+	buf += 8;
+	memcpy(buf, &regs->r12, 8);
+	buf += 8;
+	memcpy(buf, &regs->r13, 8);
+	buf += 8;
+	memcpy(buf, &regs->r14, 8);
+	buf += 8;
+	memcpy(buf, &regs->r15, 8);
+	buf += 8;
+	memcpy(buf, &regs->ip, 8);
+	buf += 8;
+	memcpy(buf, &regs->flags, 4);
+	buf += 4;
+	memcpy(buf, &regs->cs, 4);
+	buf += 4;
+	memcpy(buf, &regs->ss, 4);
+	buf += 4;
+#endif
+}
+#endif
+
+#ifdef CONFIG_MIPS
+static ULONGEST
+gtp_action_reg_read(struct pt_regs *regs, struct gtp_entry *tpe, int num)
+{
+	ULONGEST	ret;
+
+	if (num > 90) {
+		/* GDB convert the reg number to a GDB
+		   [1 * gdbarch_num_regs .. 2 * gdbarch_num_regs) REGNUM
+		   in function mips_dwarf_dwarf2_ecoff_reg_to_regnum.  */
+		num -= 90;
+	}
+
+	if (num >= 0 && num <= 31) {
+		ret = regs->regs[num];
+	} else {
+		switch (num) {
+		case 32:
+			ret = regs->cp0_status;
+			break;
+		case 33:
+			ret = regs->lo;
+			break;
+		case 34:
+			ret = regs->hi;
+			break;
+		case 35:
+			ret = regs->cp0_badvaddr;
+			break;
+		case 36:
+			ret = regs->cp0_cause;
+			break;
+		case 37:
+			ret = regs->cp0_epc;
+			break;
+		default:
+			ret = 0;
+			tpe->reason = gtp_stop_access_wrong_reg;
+			break;
+		}
+	}
+
+	return ret;
+};
+
+static void
+gtp_regs2ascii(struct pt_regs *regs, char *buf)
+{
+#ifdef GTP_DEBUG
+	{
+		int	i;
+
+		for (i = 0; i < 32; i++)
+			printk(GTP_DEBUG "gtp_gdbrsp_g: r%d = 0x%lx\n", i,
+			       regs->regs[i]);
+	}
+	printk(GTP_DEBUG "gtp_gdbrsp_g: status = 0x%lx\n",
+	       regs->cp0_status);
+	printk(GTP_DEBUG "gtp_gdbrsp_g: lo = 0x%lx\n", regs->lo);
+	printk(GTP_DEBUG "gtp_gdbrsp_g: hi = 0x%lx\n", regs->hi);
+	printk(GTP_DEBUG "gtp_gdbrsp_g: badvaddr = 0x%lx\n",
+	       regs->cp0_badvaddr);
+	printk(GTP_DEBUG "gtp_gdbrsp_g: cause = 0x%lx\n", regs->cp0_cause);
+	printk(GTP_DEBUG "gtp_gdbrsp_g: pc = 0x%lx\n", regs->cp0_epc);
+#endif
+
+#ifdef CONFIG_32BIT
+#define OUTFORMAT	"%08lx"
+#define REGSIZE		8
+#ifdef __LITTLE_ENDIAN
+#define SWAB(a)		swab32(a)
+#else
+#define SWAB(a)		(a)
+#endif
+#else
+#define OUTFORMAT	"%016lx"
+#define REGSIZE		16
+#ifdef __LITTLE_ENDIAN
+#define SWAB(a)		swab64(a)
+#else
+#define SWAB(a)		(a)
+#endif
+#endif
+	{
+		int	i;
+
+		for (i = 0; i < 32; i++) {
+			sprintf(buf, OUTFORMAT,
+				 (unsigned long) SWAB(regs->regs[i]));
+			buf += REGSIZE;
+		}
+	}
+
+	sprintf(buf, OUTFORMAT,
+		 (unsigned long) SWAB(regs->cp0_status));
+	buf += REGSIZE;
+	sprintf(buf, OUTFORMAT,
+		 (unsigned long) SWAB(regs->lo));
+	buf += REGSIZE;
+	sprintf(buf, OUTFORMAT,
+		 (unsigned long) SWAB(regs->hi));
+	buf += REGSIZE;
+	sprintf(buf, OUTFORMAT,
+		 (unsigned long) SWAB(regs->cp0_badvaddr));
+	buf += REGSIZE;
+	sprintf(buf, OUTFORMAT,
+		 (unsigned long) SWAB(regs->cp0_cause));
+	buf += REGSIZE;
+	sprintf(buf, OUTFORMAT,
+		 (unsigned long) SWAB(regs->cp0_epc));
+	buf += REGSIZE;
+#undef OUTFORMAT
+#undef REGSIZE
+#undef SWAB
+}
+
+static void
+gtp_regs2bin(struct pt_regs *regs, char *buf)
+{
+#ifdef GTP_DEBUG
+	{
+		int	i;
+
+		for (i = 0; i < 32; i++)
+			printk(GTP_DEBUG "gtp_gdbrsp_g: r%d = 0x%lx\n", i,
+			       regs->regs[i]);
+	}
+	printk(GTP_DEBUG "gtp_gdbrsp_g: status = 0x%lx\n",
+	       regs->cp0_status);
+	printk(GTP_DEBUG "gtp_gdbrsp_g: lo = 0x%lx\n", regs->lo);
+	printk(GTP_DEBUG "gtp_gdbrsp_g: hi = 0x%lx\n", regs->hi);
+	printk(GTP_DEBUG "gtp_gdbrsp_g: badvaddr = 0x%lx\n",
+	       regs->cp0_badvaddr);
+	printk(GTP_DEBUG "gtp_gdbrsp_g: cause = 0x%lx\n", regs->cp0_cause);
+	printk(GTP_DEBUG "gtp_gdbrsp_g: pc = 0x%lx\n", regs->cp0_epc);
+#endif
+
+#ifdef CONFIG_32BIT
+#define REGSIZE		4
+#else
+#define REGSIZE		8
+#endif
+	{
+		int	i;
+
+		for (i = 0; i < 32; i++) {
+			memcpy(buf, &regs->regs[i], REGSIZE);
+			buf += REGSIZE;
+		}
+	}
+	memcpy(buf, &regs->cp0_status, REGSIZE);
+	buf += REGSIZE;
+	memcpy(buf, &regs->lo, REGSIZE);
+	buf += REGSIZE;
+	memcpy(buf, &regs->hi, REGSIZE);
+	buf += REGSIZE;
+	memcpy(buf, &regs->cp0_badvaddr, REGSIZE);
+	buf += REGSIZE;
+	memcpy(buf, &regs->cp0_cause, REGSIZE);
+	buf += REGSIZE;
+	memcpy(buf, &regs->cp0_epc, REGSIZE);
+	buf += REGSIZE;
+#undef REGSIZE
+}
+#endif
+
+#ifdef CONFIG_ARM
+static ULONGEST
+gtp_action_reg_read(struct pt_regs *regs, struct gtp_entry *tpe, int num)
+{
+	if (num >= 0 && num < 16)
+		return regs->uregs[num];
+	else if (num == 25)
+		return regs->uregs[16];
+
+	tpe->reason = gtp_stop_access_wrong_reg;
+	return 0;
+}
+
+static void
+gtp_regs2ascii(struct pt_regs *regs, char *buf)
+{
+#ifdef __LITTLE_ENDIAN
+#define SWAB(a)		swab32(a)
+#else
+#define SWAB(a)		(a)
+#endif
+	int	i;
+
+	for (i = 0; i < 16; i++) {
+#ifdef GTP_DEBUG
+		printk(GTP_DEBUG "gtp_gdbrsp_g: r%d = 0x%lx\n",
+		       i, regs->uregs[i]);
+#endif
+		sprintf(buf, "%08lx", (unsigned long) SWAB(regs->uregs[i]));
+		buf += 8;
+	}
+
+	/* f0-f7 fps */
+	memset(buf, '0', 200);
+	buf += 200;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_gdbrsp_g: cpsr = 0x%lx\n", regs->uregs[16]);
+#endif
+	sprintf(buf, "%08lx",
+		 (unsigned long) SWAB(regs->uregs[16]));
+	buf += 8;
+#undef SWAB
+}
+
+static void
+gtp_regs2bin(struct pt_regs *regs, char *buf)
+{
+	int	i;
+
+	for (i = 0; i < 16; i++) {
+#ifdef GTP_DEBUG
+		printk(GTP_DEBUG "gtp_gdbrsp_g: r%d = 0x%lx\n",
+		       i, regs->uregs[i]);
+#endif
+		memcpy(buf, &regs->uregs[i], 4);
+		buf += 4;
+	}
+
+	/* f0-f7 fps */
+	memset(buf, '\0', 100);
+	buf += 100;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_gdbrsp_g: cpsr = 0x%lx\n", regs->uregs[16]);
+#endif
+	memcpy(buf, &regs->uregs[16], 4);
+	buf += 4;
+}
+#endif
+
+static char *
+gtp_frame_next(char *frame)
+{
+	switch (FID(frame)) {
+	case FID_HEAD:
+		frame += FRAME_ALIGN(GTP_FRAME_HEAD_SIZE);
+		break;
+	case FID_REG:
+		frame += FRAME_ALIGN(GTP_FRAME_REG_SIZE);
+		break;
+	case FID_MEM: {
+			struct gtp_frame_mem	*gfm;
+
+			gfm = (struct gtp_frame_mem *) (frame + FID_SIZE
+							+ sizeof(char *));
+			frame += FRAME_ALIGN(GTP_FRAME_MEM_SIZE + gfm->size);
+		}
+		break;
+	case FID_VAR:
+		frame += FRAME_ALIGN(GTP_FRAME_VAR_SIZE);
+		break;
+	case FID_END:
+		frame = gtp_frame;
+		break;
+	default:
+		return NULL;
+		break;
+	}
+
+	return frame;
+}
+
+#ifdef FRAME_ALLOC_RECORD
+ULONGEST	frame_alloc_size;
+ULONGEST	frame_alloc_size_hole;
+#endif
+
+static char *
+gtp_frame_alloc(size_t size)
+{
+	char	*ret = NULL;
+
+#ifdef FRAME_ALLOC_RECORD
+	frame_alloc_size += size;
+	frame_alloc_size_hole += (FRAME_ALIGN(size) - size);
+#endif
+
+	size = FRAME_ALIGN(size);
+
+	if (size > GTP_FRAME_SIZE)
+		return NULL;
+
+	spin_lock(&gtp_frame_lock);
+
+	if (gtp_frame_w_start + size > gtp_frame_end) {
+		if (gtp_circular) {
+			gtp_frame_is_circular = 1;
+#ifdef FRAME_ALLOC_RECORD
+			if (gtp_frame_w_start != gtp_frame_end
+			    && gtp_frame_end - gtp_frame_w_start < FID_SIZE) {
+				printk(KERN_WARNING "Frame align wrong."
+						    "start = %p end = %p\n",
+				       gtp_frame_w_start, gtp_frame_end);
+				goto out;
+			}
+#endif
+			if (gtp_frame_w_start != gtp_frame_end)
+				FID(gtp_frame_w_start) = FID_END;
+			gtp_frame_w_start = gtp_frame;
+			gtp_frame_r_start = gtp_frame;
+		} else
+			goto out;
+	}
+
+	if (gtp_frame_is_circular) {
+		while (gtp_frame_w_start <= gtp_frame_r_start
+		       && gtp_frame_w_start + size > gtp_frame_r_start) {
+			char *tmp = gtp_frame_next(gtp_frame_r_start);
+			if (tmp == NULL)
+				goto out;
+			gtp_frame_r_start = tmp;
+		}
+	}
+
+	ret = gtp_frame_w_start;
+	gtp_frame_w_start += size;
+
+out:
+	spin_unlock(&gtp_frame_lock);
+	return ret;
+}
+
+static char * *
+gtp_action_head(struct gtp_entry *tpe)
+{
+	char		*tmp;
+	char		**nextp;
+	ULONGEST	*trace_nump;
+
+	/* Get the head.  */
+	tmp = gtp_frame_alloc(GTP_FRAME_HEAD_SIZE);
+	if (!tmp) {
+		tpe->reason = gtp_stop_frame_full;
+		return NULL;
+	}
+
+	FID(tmp) = FID_HEAD;
+	tmp += FID_SIZE;
+
+	nextp = (char **)tmp;
+	*nextp = NULL;
+	tmp += sizeof(char *);
+
+	trace_nump = (ULONGEST *)tmp;
+	*trace_nump = tpe->num;
+
+	return nextp;
+}
+
+struct gtp_trace_s {
+	struct gtp_entry	*tpe;
+	struct pt_regs		*regs;
+	char			**next;
+	int			*run;
+	ULONGEST		printk_tmp;
+	unsigned int		printk_level;
+	unsigned int		printk_format;
+	struct gtpsrc		*printk_str;
+};
+
+#define GTP_PRINTK_FORMAT_A	0
+#define GTP_PRINTK_FORMAT_D	1
+#define GTP_PRINTK_FORMAT_U	2
+#define GTP_PRINTK_FORMAT_X	3
+#define GTP_PRINTK_FORMAT_S	4
+#define GTP_PRINTK_FORMAT_B	5
+
+static int
+gtp_action_printk(struct gtp_trace_s *gts, ULONGEST addr, size_t size)
+{
+	unsigned int	printk_format = gts->printk_format;
+	char		*pbuf = per_cpu(gtp_printf, smp_processor_id());
+
+	if (gts->printk_str == NULL) {
+		gts->tpe->reason = gtp_stop_agent_expr_code_error;
+		printk(KERN_WARNING "gtp_action_printk: id:%d "
+				    "printk doesn't have var name.  Please "
+				    "check actions of it.\n",
+			(int)gts->tpe->num);
+		return -1;
+	}
+
+	if (size) {
+		if (size > GTP_PRINTF_MAX - 1)
+			size = GTP_PRINTF_MAX - 1;
+		if (gts->printk_format != GTP_PRINTK_FORMAT_S
+		    && gts->printk_format != GTP_PRINTK_FORMAT_B
+		    && size > 8)
+			size = 8;
+		if (probe_kernel_read(pbuf, (void *)(CORE_ADDR)addr, size)) {
+			gts->tpe->reason = gtp_stop_efault;
+			printk(KERN_WARNING "gtp_action_printk: id:%d "
+					    "read %p %u get error.\n",
+			       (int)gts->tpe->num, (void *)(CORE_ADDR)addr,
+			       (unsigned int)size);
+			return -1;
+		}
+	} else {
+		size = sizeof(ULONGEST);
+		memcpy(pbuf, &addr, sizeof(ULONGEST));
+	}
+
+	if (printk_format == GTP_PRINTK_FORMAT_A) {
+		if (size == 1 || size == 2 || size == 4 || size == 8)
+			printk_format = GTP_PRINTK_FORMAT_U;
+		else
+			printk_format = GTP_PRINTK_FORMAT_B;
+	}
+
+	switch (printk_format) {
+	case GTP_PRINTK_FORMAT_D:
+		switch (size) {
+		case 1:
+			printk(KERN_NULL "<%d>%s%d\n", gts->printk_level,
+			       gts->printk_str->src, pbuf[0]);
+			break;
+		case 2:
+			printk(KERN_NULL "<%d>%s%d\n", gts->printk_level,
+			       gts->printk_str->src, (int)(*(short *)pbuf));
+			break;
+		case 4:
+			printk(KERN_NULL "<%d>%s%d\n", gts->printk_level,
+			       gts->printk_str->src, *(int *)pbuf);
+			break;
+		case 8:
+			printk(KERN_NULL "<%d>%s%lld\n", gts->printk_level,
+			       gts->printk_str->src, *(long long *)pbuf);
+			break;
+		default:
+			printk(KERN_WARNING "gtp_action_printk: id:%d "
+					    "size %d cannot printk.\n",
+			       (int)gts->tpe->num, (unsigned int)size);
+			gts->tpe->reason = gtp_stop_agent_expr_code_error;
+			return -1;
+			break;
+		}
+		break;
+	case GTP_PRINTK_FORMAT_U:
+		switch (size) {
+		case 1:
+			printk(KERN_NULL "<%d>%s%u\n", gts->printk_level,
+			       gts->printk_str->src, pbuf[0]);
+			break;
+		case 2:
+			printk(KERN_NULL "<%d>%s%u\n", gts->printk_level,
+			       gts->printk_str->src, (int)(*(short *)pbuf));
+			break;
+		case 4:
+			printk(KERN_NULL "<%d>%s%u\n", gts->printk_level,
+			       gts->printk_str->src, *(int *)pbuf);
+			break;
+		case 8:
+			printk(KERN_NULL "<%d>%s%llu\n", gts->printk_level,
+			       gts->printk_str->src, *(long long *)pbuf);
+			break;
+		default:
+			printk(KERN_WARNING "gtp_action_printk: id:%d "
+					    "size %d cannot printk.\n",
+			       (int)gts->tpe->num, (unsigned int)size);
+			gts->tpe->reason = gtp_stop_agent_expr_code_error;
+			return -1;
+			break;
+		}
+		break;
+	case GTP_PRINTK_FORMAT_X:
+		switch (size) {
+		case 1:
+			printk(KERN_NULL "<%d>%s0x%x\n", gts->printk_level,
+			       gts->printk_str->src, pbuf[0]);
+			break;
+		case 2:
+			printk(KERN_NULL "<%d>%s0x%x\n", gts->printk_level,
+			       gts->printk_str->src, (int)(*(short *)pbuf));
+			break;
+		case 4:
+			printk(KERN_NULL "<%d>%s0x%x\n", gts->printk_level,
+			       gts->printk_str->src, *(int *)pbuf);
+			break;
+		case 8:
+			printk(KERN_NULL "<%d>%s0x%llx\n", gts->printk_level,
+			       gts->printk_str->src, *(long long *)pbuf);
+			break;
+		default:
+			printk(KERN_WARNING "gtp_action_printk: id:%d "
+					    "size %d cannot printk.\n",
+			       (int)gts->tpe->num, (unsigned int)size);
+			gts->tpe->reason = gtp_stop_agent_expr_code_error;
+			return -1;
+			break;
+		}
+		break;
+	case GTP_PRINTK_FORMAT_S:
+		pbuf[GTP_PRINTF_MAX - 1] = '\0';
+		printk("<%d>%s%s\n", gts->printk_level, gts->printk_str->src,
+		       pbuf);
+		break;
+	case GTP_PRINTK_FORMAT_B: {
+			size_t	i;
+
+			printk(KERN_NULL "<%d>%s", gts->printk_level,
+			       gts->printk_str->src);
+			for (i = 0; i < size; i++)
+				printk("%02x", (unsigned int)pbuf[i]);
+			printk("\n");
+		}
+		break;
+	default:
+		printk(KERN_WARNING "gtp_action_printk: id:%d "
+				    "printk format %u is not support.\n",
+		       (int)gts->tpe->num, gts->printk_format);
+		gts->tpe->reason = gtp_stop_agent_expr_code_error;
+		return -1;
+		break;
+	}
+
+	gts->printk_str = gts->printk_str->next;
+
+	return 0;
+}
+
+static int
+gtp_action_memory_read(struct gtp_trace_s *gts, int reg, CORE_ADDR addr,
+		       size_t size)
+{
+	char			*tmp;
+	struct gtp_frame_mem	*fm;
+
+	if (reg >= 0)
+		addr += (CORE_ADDR) gtp_action_reg_read(gts->regs,
+							gts->tpe, reg);
+	if (gts->tpe->reason != gtp_stop_normal)
+		return -1;
+
+	if (gts->next == NULL) {
+		gts->next = gtp_action_head(gts->tpe);
+		if (!gts->next)
+			return -1;
+	}
+
+	tmp = gtp_frame_alloc(GTP_FRAME_MEM_SIZE + size);
+	if (!tmp) {
+		gts->tpe->reason = gtp_stop_frame_full;
+		return -1;
+	}
+	*gts->next = tmp;
+
+	FID(tmp) = FID_MEM;
+	tmp += FID_SIZE;
+
+	gts->next = (char **)tmp;
+	*gts->next = NULL;
+	tmp += sizeof(char *);
+
+	fm = (struct gtp_frame_mem *)tmp;
+	fm->addr = addr;
+	fm->size = size;
+	tmp += sizeof(struct gtp_frame_mem);
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_action_memory_read: id:%d %p %u\n",
+	       (int)gts->tpe->num, (void *)addr, (unsigned int)size);
+#endif
+
+	if (probe_kernel_read(tmp, (void *)addr, size)) {
+		gts->tpe->reason = gtp_stop_efault;
+		memset(tmp, 0, size);
+		printk(KERN_WARNING "gtp_action_memory_read: id:%d read %p %u "
+				    "get error.\n", (int)gts->tpe->num,
+		       (void *)addr, (unsigned int)size);
+		return -1;
+	}
+
+	return 0;
+}
+
+static int
+gtp_action_r(struct gtp_trace_s *gts, struct action *ae)
+{
+	struct pt_regs		*regs;
+	char			*tmp;
+
+	if (gts->next == NULL) {
+		gts->next = gtp_action_head(gts->tpe);
+		if (!gts->next)
+			return -1;
+	}
+
+	tmp = gtp_frame_alloc(GTP_FRAME_REG_SIZE);
+	if (!tmp) {
+		gts->tpe->reason = gtp_stop_frame_full;
+		return -1;
+	}
+	*gts->next = tmp;
+
+	FID(tmp) = FID_REG;
+	tmp += FID_SIZE;
+
+	gts->next = (char **)tmp;
+	*gts->next = NULL;
+	tmp += sizeof(char *);
+
+	regs = (struct pt_regs *)tmp;
+
+	memcpy(regs, gts->regs, sizeof(struct pt_regs));
+#ifdef CONFIG_X86_32
+	regs->sp = (unsigned long)&regs->sp;
+#endif	/* CONFIG_X86_32 */
+#ifdef CONFIG_X86
+	regs->ip -= 1;
+#endif	/* CONFIG_X86 */
+
+	return 0;
+}
+
+static struct gtp_var *
+gtp_gtp_var_array_find(unsigned int num)
+{
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_gtp_var_array_find: num:%u %u %u\n",
+	       gtp_var_head, gtp_var_tail, num);
+#endif
+
+	if (num < gtp_var_head || num > gtp_var_tail)
+		return NULL;
+
+	return gtp_var_array[num - gtp_var_head];
+}
+
+uint64_t
+gtp_get_var(struct gtp_trace_s *gts, struct gtp_var *tve)
+{
+	switch (tve->num) {
+	case GTP_VAR_CURRENT_TASK_ID:
+		return (uint64_t)(CORE_ADDR)get_current();
+		break;
+	case GTP_VAR_CURRENT_THREAD_INFO_ID:
+		return (uint64_t)(CORE_ADDR)current_thread_info();
+		break;
+	case GTP_VAR_CLOCK_ID:
+		return (uint64_t)(CORE_ADDR)local_clock();
+		break;
+	case GTP_VAR_CPU_ID:
+		return (uint64_t)(CORE_ADDR)smp_processor_id();
+		break;
+	case GTP_VAR_PRINTK_TMP_ID:
+		return gts->printk_tmp;
+		break;
+	case GTP_VAR_DUMP_STACK_ID:
+		printk(KERN_NULL "gtp %d:", (int)gts->tpe->num);
+		dump_stack();
+		return 0;
+		break;
+	}
+
+	return tve->val;
+}
+
+static int
+gtp_collect_var(struct gtp_trace_s *gts, struct gtp_var *tve)
+{
+	struct gtp_frame_var	*fvar;
+	char			*tmp;
+
+	if (gts->next == NULL) {
+		gts->next = gtp_action_head(gts->tpe);
+		if (!gts->next)
+			return -1;
+	}
+
+	tmp = gtp_frame_alloc(GTP_FRAME_VAR_SIZE);
+	if (!tmp) {
+		gts->tpe->reason = gtp_stop_frame_full;
+		return -1;
+	}
+	*gts->next = tmp;
+
+	FID(tmp) = FID_VAR;
+	tmp += FID_SIZE;
+
+	gts->next = (char **)tmp;
+	*gts->next = NULL;
+	tmp += sizeof(char *);
+
+	fvar = (struct gtp_frame_var *) tmp;
+	fvar->num = tve->num;
+	fvar->val = gtp_get_var(gts, tve);
+
+	return 0;
+}
+
+#define gtp_action_x_getv						\
+	do {								\
+		struct gtp_var	*tve;					\
+									\
+		tve = gtp_gtp_var_array_find(arg);			\
+		if (!tve)						\
+			goto code_error_out;				\
+									\
+		stack[sp++] = top;					\
+									\
+		top = gtp_get_var(gts, tve);				\
+	} while (0)
+
+#define gtp_action_x_setv						\
+	do {								\
+		switch (arg) {						\
+		case GTP_VAR_PRINTK_TMP_ID:				\
+			gts->printk_tmp = top;				\
+			break;						\
+		case GTP_VAR_PRINTK_LEVEL_ID:				\
+			gts->printk_level = (unsigned int)top;		\
+			break;						\
+		case GTP_VAR_PRINTK_FORMAT_ID:				\
+			gts->printk_format = (unsigned int)top;		\
+			break;						\
+		default: {						\
+				struct gtp_var	*tve;			\
+									\
+				tve = gtp_gtp_var_array_find(arg);	\
+				if (!tve)				\
+					goto code_error_out;		\
+				/* Not check the other special		\
+				   trace state variables.		\
+				   Checked in gtp_check_x.  */		\
+				tve->val = (uint64_t)top;		\
+			}						\
+			break;						\
+		}							\
+	} while (0)
+
+#define gtp_action_x_tracev						\
+	do {								\
+		if (gts->tpe->have_printk)				\
+			pc += 2;					\
+		else {							\
+			struct gtp_var	*tve;				\
+									\
+			tve = gtp_gtp_var_array_find(arg);		\
+			if (!tve)					\
+				goto code_error_out;			\
+									\
+			if (gtp_collect_var(gts, tve)) {		\
+				/* gtp_collect_var will set error	\
+				   status with itself if it got		\
+				   error. */				\
+				goto out;				\
+			}						\
+		}							\
+	} while (0)
+
+#define gtp_action_x_tracev_printk					\
+	do {								\
+		struct gtp_var	*tve;					\
+									\
+		tve = gtp_gtp_var_array_find(arg);			\
+		if (!tve)						\
+			goto code_error_out;				\
+									\
+		if (gtp_action_printk(gts, gtp_get_var(gts, tve), 0)) {	\
+			/* gtp_collect_var will set error status with	\
+			   itself if it got error. */			\
+			goto out;					\
+		}							\
+	} while (0)
+
+#define gtp_action_x_printf						\
+	do {								\
+		if (strstr((char *)(ebuf + pc), "%s")) {		\
+			int	i;					\
+			char	buf[50];				\
+									\
+			for (i = 0; i < 50; i++) {			\
+				if (probe_kernel_read(buf + i,		\
+						      argv + i, 1))	\
+					goto code_error_out;		\
+				if (!buf[i])				\
+					break;				\
+			}						\
+			snprintf(pbuf, psize, (char *)(ebuf + pc),	\
+				 buf);					\
+		} else {						\
+			snprintf(pbuf, psize, (char *)(ebuf + pc),	\
+				 argv);					\
+		}							\
+	} while (0)
+
+#define STACK_MAX	32
+static DEFINE_PER_CPU(ULONGEST[STACK_MAX], action_x_stack);
+
+static int
+gtp_action_x(struct gtp_trace_s *gts, struct action *ae)
+{
+	int		ret = 0;
+	unsigned int	pc = 0, sp = 0;
+	ULONGEST	top = 0;
+	int		arg;
+	union {
+		union {
+			uint8_t	bytes[1];
+			uint8_t	val;
+		} u8;
+		union {
+			uint8_t	bytes[2];
+			uint16_t val;
+		} u16;
+		union {
+			uint8_t bytes[4];
+			uint32_t val;
+		} u32;
+		union {
+			uint8_t bytes[8];
+			ULONGEST val;
+		} u64;
+	} cnv;
+	uint8_t		*ebuf = ae->u.exp.buf;
+	int		psize = GTP_PRINTF_MAX;
+	char		*pbuf = per_cpu(gtp_printf, smp_processor_id());
+	ULONGEST	*stack = per_cpu(action_x_stack, smp_processor_id());
+
+	if (ae->u.exp.need_var_lock)
+		spin_lock(&gtp_var_lock);
+
+	if (ae->type == 'X') {
+		while (pc < ae->u.exp.size) {
+#ifdef GTP_DEBUG
+			printk(GTP_DEBUG "gtp_parse_x: cmd %x\n", ebuf[pc]);
+#endif
+
+			switch (ebuf[pc++]) {
+			/* add */
+			case 0x02:
+				top += stack[--sp];
+				break;
+			/* sub */
+			case 0x03:
+				top = stack[--sp] - top;
+				break;
+			/* mul */
+			case 0x04:
+				top *= stack[--sp];
+				break;
+#ifndef CONFIG_MIPS
+			/* div_signed */
+			case 0x05:
+				if (top) {
+					LONGEST l = (LONGEST) stack[--sp];
+					do_div(l, (LONGEST) top);
+					top = l;
+				} else
+					goto code_error_out;
+				break;
+			/* div_unsigned */
+			case 0x06:
+				if (top) {
+					ULONGEST ul = stack[--sp];
+					do_div(ul, top);
+					top = ul;
+				} else
+					goto code_error_out;
+				break;
+			/* rem_signed */
+			case 0x07:
+				if (top) {
+					LONGEST l1 = (LONGEST) stack[--sp];
+					LONGEST l2 = (LONGEST) top;
+					top = do_div(l1, l2);
+				} else
+					goto code_error_out;
+				break;
+			/* rem_unsigned */
+			case 0x08:
+				if (top) {
+					ULONGEST ul1 = stack[--sp];
+					ULONGEST ul2 = top;
+					top = do_div(ul1, ul2);
+				} else
+					goto code_error_out;
+				break;
+#endif
+			/* lsh */
+			case 0x09:
+				top = stack[--sp] << top;
+				break;
+			/* rsh_signed */
+			case 0x0a:
+				top = ((LONGEST) stack[--sp]) >> top;
+				break;
+			/* rsh_unsigned */
+			case 0x0b:
+				top = stack[--sp] >> top;
+				break;
+			/* trace */
+			case 0x0c:
+				--sp;
+				if (!gts->tpe->have_printk) {
+					if (gtp_action_memory_read
+						(gts, -1,
+						 (CORE_ADDR) stack[sp],
+						 (size_t) top))
+						goto out;
+				}
+				top = stack[--sp];
+				break;
+			/* trace_printk */
+			case 0xfd:
+				if (gtp_action_printk(gts,
+						      (ULONGEST)stack[--sp],
+						      (size_t) top))
+					goto out;
+				top = stack[--sp];
+				break;
+			/* trace_quick */
+			case 0x0d:
+				if (!gts->tpe->have_printk) {
+					if (gtp_action_memory_read
+						(gts, -1, (CORE_ADDR) top,
+						 (size_t) ebuf[pc]))
+						goto out;
+				}
+				pc++;
+				break;
+			/* trace_quick_printk */
+			case 0xfe:
+				if (gtp_action_printk(gts, (ULONGEST) top,
+						      (size_t) ebuf[pc++]))
+					goto out;
+				break;
+			/* log_not */
+			case 0x0e:
+				top = !top;
+				break;
+			/* bit_and */
+			case 0x0f:
+				top &= stack[--sp];
+				break;
+			/* bit_or */
+			case 0x10:
+				top |= stack[--sp];
+				break;
+			/* bit_xor */
+			case 0x11:
+				top ^= stack[--sp];
+				break;
+			/* bit_not */
+			case 0x12:
+				top = ~top;
+				break;
+			/* equal */
+			case 0x13:
+				top = (stack[--sp] == top);
+				break;
+			/* less_signed */
+			case 0x14:
+				top = (((LONGEST) stack[--sp])
+					< ((LONGEST) top));
+				break;
+			/* less_unsigned */
+			case 0x15:
+				top = (stack[--sp] < top);
+				break;
+			/* ext */
+			case 0x16:
+				arg = ebuf[pc++];
+				if (arg < (sizeof(LONGEST)*8)) {
+					LONGEST mask = 1 << (arg - 1);
+					top &= ((LONGEST) 1 << arg) - 1;
+					top = (top ^ mask) - mask;
+				}
+				break;
+			/* ref8 */
+			case 0x17:
+				if (probe_kernel_read
+					(cnv.u8.bytes,
+					(void *)(CORE_ADDR)top, 1))
+					goto code_error_out;
+				top = (ULONGEST) cnv.u8.val;
+				break;
+			/* ref16 */
+			case 0x18:
+				if (probe_kernel_read
+					(cnv.u16.bytes,
+					(void *)(CORE_ADDR)top, 2))
+					goto code_error_out;
+				top = (ULONGEST) cnv.u16.val;
+				break;
+			/* ref32 */
+			case 0x19:
+				if (probe_kernel_read
+					(cnv.u32.bytes,
+					(void *)(CORE_ADDR)top, 4))
+					goto code_error_out;
+				top = (ULONGEST) cnv.u32.val;
+				break;
+			/* ref64 */
+			case 0x1a:
+				if (probe_kernel_read
+					(cnv.u64.bytes,
+					(void *)(CORE_ADDR)top, 8))
+					goto code_error_out;
+				top = (ULONGEST) cnv.u64.val;
+				break;
+			/* if_goto */
+			case 0x20:
+				/* The not check sp code don't
+				   support if_goto.  */
+				goto code_error_out;
+				break;
+			/* goto */
+			case 0x21:
+				pc = (ebuf[pc] << 8) + (ebuf[pc + 1]);
+				break;
+			/* const8 */
+			case 0x22:
+				stack[sp++] = top;
+				top = ebuf[pc++];
+				break;
+			/* const16 */
+			case 0x23:
+				stack[sp++] = top;
+				top = ebuf[pc++];
+				top = (top << 8) + ebuf[pc++];
+				break;
+			/* const32 */
+			case 0x24:
+				stack[sp++] = top;
+				top = ebuf[pc++];
+				top = (top << 8) + ebuf[pc++];
+				top = (top << 8) + ebuf[pc++];
+				top = (top << 8) + ebuf[pc++];
+				break;
+			/* const64 */
+			case 0x25:
+				stack[sp++] = top;
+				top = ebuf[pc++];
+				top = (top << 8) + ebuf[pc++];
+				top = (top << 8) + ebuf[pc++];
+				top = (top << 8) + ebuf[pc++];
+				top = (top << 8) + ebuf[pc++];
+				top = (top << 8) + ebuf[pc++];
+				top = (top << 8) + ebuf[pc++];
+				top = (top << 8) + ebuf[pc++];
+				break;
+			/* reg */
+			case 0x26:
+				stack[sp++] = top;
+				arg = ebuf[pc++];
+				arg = (arg << 8) + ebuf[pc++];
+				top = gtp_action_reg_read(gts->regs, gts->tpe,
+							  arg);
+				if (gts->tpe->reason != gtp_stop_normal)
+					goto error_out;
+				break;
+			/* end */
+			case 0x27:
+				if (gts->run)
+					*(gts->run) = (int)top;
+				goto out;
+				break;
+			/* dup */
+			case 0x28:
+				stack[sp++] = top;
+				break;
+			/* pop */
+			case 0x29:
+				top = stack[--sp];
+				break;
+			/* zero_ext */
+			case 0x2a:
+				arg = ebuf[pc++];
+				if (arg < (sizeof(LONGEST)*8))
+					top &= ((LONGEST) 1 << arg) - 1;
+				break;
+			/* swap */
+			case 0x2b:
+				stack[sp] = top;
+				top = stack[sp - 1];
+				stack[sp - 1] = stack[sp];
+				break;
+			/* getv */
+			case 0x2c:
+				arg = ebuf[pc++];
+				arg = (arg << 8) + ebuf[pc++];
+				gtp_action_x_getv;
+				break;
+			/* setv */
+			case 0x2d:
+				arg = ebuf[pc++];
+				arg = (arg << 8) + ebuf[pc++];
+				gtp_action_x_setv;
+				break;
+			/* tracev */
+			case 0x2e:
+				arg = ebuf[pc++];
+				arg = (arg << 8) + ebuf[pc++];
+				gtp_action_x_tracev;
+				break;
+			/* tracev_printk */
+			case 0xff:
+				arg = ebuf[pc++];
+				arg = (arg << 8) + ebuf[pc++];
+				gtp_action_x_tracev_printk;
+				break;
+			/* printf */
+			case 0x31: {
+					arg = ebuf[pc++];
+
+					if (arg) {
+						void	*argv = (void *)
+								(unsigned long)
+								top;
+
+						/* pop */
+						top = stack[--sp];
+
+						gtp_action_x_printf;
+					} else
+						snprintf(pbuf, psize,
+							 (char *)(ebuf + pc));
+					psize -= strlen(pbuf);
+					pbuf += strlen(pbuf);
+
+					pc += strlen((char *)ebuf + pc) + 1;
+				}
+				break;
+			}
+		}
+	} else {
+		/* The x execution code don't support printk so it doesn't have
+		   printk ae support.  */
+		while (pc < ae->u.exp.size) {
+#ifdef GTP_DEBUG
+			printk(GTP_DEBUG "gtp_parse_x: cmd %x\n", ebuf[pc]);
+#endif
+
+			switch (ebuf[pc++]) {
+			/* add */
+			case 0x02:
+				if (sp)
+					top += stack[--sp];
+				else
+					goto code_error_out;
+				break;
+			/* sub */
+			case 0x03:
+				if (sp)
+					top = stack[--sp] - top;
+				else
+					goto code_error_out;
+				break;
+			/* mul */
+			case 0x04:
+				if (sp)
+					top *= stack[--sp];
+				else
+					goto code_error_out;
+				break;
+#ifndef CONFIG_MIPS
+			/* div_signed */
+			case 0x05:
+				if (top && sp) {
+					LONGEST l = (LONGEST) stack[--sp];
+					do_div(l, (LONGEST) top);
+					top = l;
+				} else
+					goto code_error_out;
+				break;
+			/* div_unsigned */
+			case 0x06:
+				if (top && sp) {
+					ULONGEST ul = stack[--sp];
+					do_div(ul, top);
+					top = ul;
+				} else
+					goto code_error_out;
+				break;
+			/* rem_signed */
+			case 0x07:
+				if (top && sp) {
+					LONGEST l1 = (LONGEST) stack[--sp];
+					LONGEST l2 = (LONGEST) top;
+					top = do_div(l1, l2);
+				} else
+					goto code_error_out;
+				break;
+			/* rem_unsigned */
+			case 0x08:
+				if (top && sp) {
+					ULONGEST ul1 = stack[--sp];
+					ULONGEST ul2 = top;
+					top = do_div(ul1, ul2);
+				} else
+					goto code_error_out;
+				break;
+#endif
+			/* lsh */
+			case 0x09:
+				if (sp)
+					top = stack[--sp] << top;
+				else
+					goto code_error_out;
+				break;
+			/* rsh_signed */
+			case 0x0a:
+				if (sp)
+					top = ((LONGEST) stack[--sp]) >> top;
+				else
+					goto code_error_out;
+				break;
+			/* rsh_unsigned */
+			case 0x0b:
+				if (sp)
+					top = stack[--sp] >> top;
+				else
+					goto code_error_out;
+				break;
+			/* trace */
+			case 0x0c:
+				if (sp > 1) {
+					if (gtp_action_memory_read
+					     (gts, -1, (CORE_ADDR) stack[--sp],
+					      (size_t) top)) {
+						/* gtp_action_memory_read will
+						   set error status with itself
+						   if it got error. */
+						goto out;
+					}
+					top = stack[--sp];
+				} else
+					goto code_error_out;
+				break;
+			/* trace_quick */
+			case 0x0d:
+				if (gtp_action_memory_read
+				(gts, -1, (CORE_ADDR) top,
+				(size_t) ebuf[pc++])) {
+					/* gtp_action_memory_read will set
+					   error status with itself if it got
+					   error. */
+					goto out;
+				}
+				break;
+			/* log_not */
+			case 0x0e:
+				top = !top;
+				break;
+			/* bit_and */
+			case 0x0f:
+				if (sp)
+					top &= stack[--sp];
+				else
+					goto code_error_out;
+				break;
+			/* bit_or */
+			case 0x10:
+				if (sp)
+					top |= stack[--sp];
+				else
+					goto code_error_out;
+				break;
+			/* bit_xor */
+			case 0x11:
+				if (sp)
+					top ^= stack[--sp];
+				else
+					goto code_error_out;
+				break;
+			/* bit_not */
+			case 0x12:
+				top = ~top;
+				break;
+			/* equal */
+			case 0x13:
+				if (sp)
+					top = (stack[--sp] == top);
+				else
+					goto code_error_out;
+				break;
+			/* less_signed */
+			case 0x14:
+				if (sp)
+					top = (((LONGEST) stack[--sp])
+						< ((LONGEST) top));
+				else
+					goto code_error_out;
+				break;
+			/* less_unsigned */
+			case 0x15:
+				if (sp)
+					top = (stack[--sp] < top);
+				else
+					goto code_error_out;
+				break;
+			/* ext */
+			case 0x16:
+				arg = ebuf[pc++];
+				if (arg < (sizeof(LONGEST)*8)) {
+					LONGEST mask = 1 << (arg - 1);
+					top &= ((LONGEST) 1 << arg) - 1;
+					top = (top ^ mask) - mask;
+				}
+				break;
+			/* ref8 */
+			case 0x17:
+				if (probe_kernel_read
+					(cnv.u8.bytes,
+					(void *)(CORE_ADDR)top, 1))
+					goto code_error_out;
+				top = (ULONGEST) cnv.u8.val;
+				break;
+			/* ref16 */
+			case 0x18:
+				if (probe_kernel_read
+					(cnv.u16.bytes,
+					(void *)(CORE_ADDR)top, 2))
+					goto code_error_out;
+				top = (ULONGEST) cnv.u16.val;
+				break;
+			/* ref32 */
+			case 0x19:
+				if (probe_kernel_read
+					(cnv.u32.bytes,
+					(void *)(CORE_ADDR)top, 4))
+					goto code_error_out;
+				top = (ULONGEST) cnv.u32.val;
+				break;
+			/* ref64 */
+			case 0x1a:
+				if (probe_kernel_read
+					(cnv.u64.bytes,
+					(void *)(CORE_ADDR)top, 8))
+					goto code_error_out;
+				top = (ULONGEST) cnv.u64.val;
+				break;
+			/* if_goto */
+			case 0x20:
+				if (top)
+					pc = (ebuf[pc] << 8)
+						+ (ebuf[pc + 1]);
+				else
+					pc += 2;
+				/* pop */
+				if (sp)
+					top = stack[--sp];
+				else
+					goto code_error_out;
+				break;
+			/* goto */
+			case 0x21:
+				pc = (ebuf[pc] << 8) + (ebuf[pc + 1]);
+				break;
+			/* const8 */
+			case 0x22:
+				stack[sp++] = top;
+				top = ebuf[pc++];
+				break;
+			/* const16 */
+			case 0x23:
+				stack[sp++] = top;
+				top = ebuf[pc++];
+				top = (top << 8) + ebuf[pc++];
+				break;
+			/* const32 */
+			case 0x24:
+				stack[sp++] = top;
+				top = ebuf[pc++];
+				top = (top << 8) + ebuf[pc++];
+				top = (top << 8) + ebuf[pc++];
+				top = (top << 8) + ebuf[pc++];
+				break;
+			/* const64 */
+			case 0x25:
+				stack[sp++] = top;
+				top = ebuf[pc++];
+				top = (top << 8) + ebuf[pc++];
+				top = (top << 8) + ebuf[pc++];
+				top = (top << 8) + ebuf[pc++];
+				top = (top << 8) + ebuf[pc++];
+				top = (top << 8) + ebuf[pc++];
+				top = (top << 8) + ebuf[pc++];
+				top = (top << 8) + ebuf[pc++];
+				break;
+			/* reg */
+			case 0x26:
+				stack[sp++] = top;
+				arg = ebuf[pc++];
+				arg = (arg << 8) + ebuf[pc++];
+				top = gtp_action_reg_read(gts->regs, gts->tpe,
+							  arg);
+				if (gts->tpe->reason != gtp_stop_normal)
+					goto error_out;
+				break;
+			/* end */
+			case 0x27:
+				if (gts->run)
+					*(gts->run) = (int)top;
+				goto out;
+				break;
+			/* dup */
+			case 0x28:
+				stack[sp++] = top;
+				break;
+			/* pop */
+			case 0x29:
+				if (sp)
+					top = stack[--sp];
+				else
+					goto code_error_out;
+				break;
+			/* zero_ext */
+			case 0x2a:
+				arg = ebuf[pc++];
+				if (arg < (sizeof(LONGEST)*8))
+					top &= ((LONGEST) 1 << arg) - 1;
+				break;
+			/* swap */
+			case 0x2b:
+				if (sp) {
+					stack[sp] = top;
+					top = stack[sp - 1];
+					stack[sp - 1] = stack[sp];
+				} else
+					goto code_error_out;
+				break;
+			/* getv */
+			case 0x2c:
+				arg = ebuf[pc++];
+				arg = (arg << 8) + ebuf[pc++];
+				if (GTP_VAR_NOT_GETV(arg))
+					goto code_error_out;
+				gtp_action_x_getv;
+				break;
+			/* setv */
+			case 0x2d:
+				arg = ebuf[pc++];
+				arg = (arg << 8) + ebuf[pc++];
+				if (GTP_VAR_NOT_SETV(arg))
+					goto code_error_out;
+				gtp_action_x_setv;
+				break;
+			/* tracev */
+			case 0x2e:
+				arg = ebuf[pc++];
+				arg = (arg << 8) + ebuf[pc++];
+				if (GTP_VAR_NOT_TRACEV(arg))
+					goto code_error_out;
+				gtp_action_x_tracev;
+				break;
+			/* printf */
+			case 0x31: {
+					arg = ebuf[pc++];
+
+					if (arg) {
+						void	*argv = (void *)
+								(unsigned long)
+								top;
+
+						/* pop */
+						if (sp)
+							top = stack[--sp];
+						else
+							goto code_error_out;
+
+						gtp_action_x_printf;
+					} else
+						snprintf(pbuf, psize,
+							(char *)(ebuf + pc));
+					psize -= strlen(pbuf);
+					pbuf += strlen(pbuf);
+
+					pc += strlen((char *)ebuf + pc) + 1;
+				}
+				break;
+			}
+
+			if (sp > STACK_MAX - 5) {
+				printk(KERN_WARNING "gtp_action_x: stack "
+						    "overflow.\n");
+				gts->tpe->reason
+					= gtp_stop_agent_expr_stack_overflow;
+				goto error_out;
+			}
+		}
+	}
+code_error_out:
+	gts->tpe->reason = gtp_stop_agent_expr_code_error;
+error_out:
+	ret = -1;
+	printk(KERN_WARNING "gtp_action_x: tracepoint %d "
+			    "action X get error in pc %u.\n",
+		(int)gts->tpe->num, pc);
+out:
+	if (psize != GTP_PRINTF_MAX) {
+		unsigned long	flags;
+
+		local_irq_save(flags);
+		printk("%s", pbuf - (GTP_PRINTF_MAX - psize));
+		local_irq_restore(flags);
+	}
+	if (ae->u.exp.need_var_lock)
+		spin_unlock(&gtp_var_lock);
+	return ret;
+}
+
+static int
+gtp_kp_pre_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct gtp_trace_s	gts;
+	struct action		*ae;
+
+	gts.tpe = container_of(p, struct gtp_entry, kp);
+	gts.regs = regs;
+	gts.next = NULL;
+	gts.printk_tmp = 0;
+	gts.printk_level = 8;
+	gts.printk_format = 0;
+	gts.printk_str = gts.tpe->printk_str;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_kp_pre_handler: tracepoint %d\n",
+	       (int)gts.tpe->num);
+#endif
+
+	if (gts.tpe->kpreg == 0)
+		return 0;
+
+	/* Condition.  */
+	if (gts.tpe->cond) {
+		int	run;
+
+		gts.run = &run;
+		if (gtp_action_x(&gts, gts.tpe->cond))
+			goto tpe_stop;
+		if (!run)
+			return 0;
+	}
+
+	gts.run = NULL;
+
+	/* Pass.  */
+	if (!gts.tpe->nopass) {
+		if (atomic_dec_return(&gts.tpe->current_pass) < 0)
+			goto tpe_stop;
+	}
+
+	atomic_inc(&gtp_frame_create);
+
+	/* Handle actions.  */
+	for (ae = gts.tpe->action_list; ae; ae = ae->next) {
+		switch (ae->type) {
+		case 'R':
+			if (gtp_action_r(&gts, ae))
+				goto tpe_stop;
+			break;
+		case 'X':
+		case 0xff:
+			if (gtp_action_x(&gts, ae))
+				goto tpe_stop;
+			break;
+		case 'M':
+			if (gtp_action_memory_read(&gts, ae->u.m.regnum,
+						   ae->u.m.offset,
+						   ae->u.m.size))
+				goto tpe_stop;
+			break;
+		}
+	}
+
+	return 0;
+
+tpe_stop:
+	gts.tpe->kpreg = 0;
+	queue_work(gtp_wq, &gts.tpe->work);
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_kp_pre_handler: tracepoint %d stop.\n",
+		(int)gts.tpe->num);
+#endif
+	return 0;
+}
+
+static struct action *
+gtp_action_alloc(char *pkg)
+{
+	struct action	*ret;
+
+	ret = kmalloc(sizeof(struct action), GFP_KERNEL);
+	if (!ret)
+		goto out;
+
+	memset(ret, '\0', sizeof(struct action));
+	ret->type = pkg[0];
+	ret->src = pkg;
+
+out:
+	return ret;
+}
+
+static void
+gtp_action_release(struct action *ae)
+{
+	struct action	*ae2;
+
+	while (ae) {
+		ae2 = ae;
+		ae = ae->next;
+		/* Release ae2.  */
+		switch (ae2->type) {
+		case 'X':
+			kfree(ae2->u.exp.buf);
+			break;
+		}
+		kfree(ae2->src);
+		kfree(ae2);
+	}
+}
+
+static void
+gtp_src_release(struct gtpsrc *src)
+{
+	struct gtpsrc	*src2;
+
+	while (src) {
+		src2 = src;
+		src = src->next;
+		kfree(src2->src);
+		kfree(src2);
+	}
+}
+
+static void
+gtp_stop(struct work_struct *work)
+{
+	struct gtp_entry	*tpe = container_of(work,
+						    struct gtp_entry, work);
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_stop: tracepoint %d\n", (int)tpe->num);
+#endif
+
+	unregister_kprobe(&tpe->kp);
+}
+
+static struct gtp_entry *
+gtp_list_add(ULONGEST num, ULONGEST addr)
+{
+	struct gtp_entry	*ret = kmalloc(sizeof(struct gtp_entry),
+					       GFP_KERNEL);
+
+	if (!ret)
+		goto out;
+	memset(ret, '\0', sizeof(struct gtp_entry));
+	ret->num = num;
+	ret->addr = addr;
+	ret->kp.addr = (kprobe_opcode_t *) (CORE_ADDR)addr;
+	ret->kp.pre_handler = gtp_kp_pre_handler;
+	INIT_WORK(&ret->work, gtp_stop);
+	ret->have_printk = 0;
+
+	/* Add to gtp_list.  */
+	ret->next = gtp_list;
+	gtp_list = ret;
+
+out:
+	return ret;
+}
+
+static struct gtp_entry *
+gtp_list_find(ULONGEST num)
+{
+	struct gtp_entry	*tpe;
+
+	for (tpe = gtp_list; tpe; tpe = tpe->next) {
+		if (tpe->num == num)
+			return tpe;
+	}
+
+	return NULL;
+}
+
+static void
+gtp_list_release(void)
+{
+	struct gtp_entry	*tpe;
+
+	while (gtp_list) {
+		tpe = gtp_list;
+		gtp_list = gtp_list->next;
+		gtp_action_release(tpe->cond);
+		gtp_action_release(tpe->action_list);
+		gtp_src_release(tpe->src);
+		kfree(tpe);
+	}
+
+	current_gtp = NULL;
+	current_gtp_action = NULL;
+	current_gtp_src = NULL;
+}
+
+static void
+gtp_frame_reset(void)
+{
+	gtp_frame_r_start = gtp_frame;
+	gtp_frame_w_start = gtp_frame;
+	gtp_frame_end = gtp_frame + GTP_FRAME_SIZE;
+	gtp_frame_is_circular = 0;
+	gtp_frame_current = NULL;
+	gtp_frame_current_num = 0;
+	atomic_set(&gtp_frame_create, 0);
+	if (gtp_frame_file) {
+		vfree(gtp_frame_file);
+		gtp_frame_file = NULL;
+		gtp_frame_file_size = 0;
+	}
+}
+
+static int
+hex2int(char hex, int *i)
+{
+	if ((hex >= '0') && (hex <= '9')) {
+		*i = hex - '0';
+		return 1;
+	}
+	if ((hex >= 'a') && (hex <= 'f')) {
+		*i = hex - 'a' + 10;
+		return 1;
+	}
+	if ((hex >= 'A') && (hex <= 'F')) {
+		*i = hex - 'A' + 10;
+		return 1;
+	}
+
+	return 0;
+}
+
+static char *
+hex2ulongest(char *pkg, ULONGEST *u64)
+{
+	int	i;
+
+	*u64 = 0;
+	while (hex2int(pkg[0], &i)) {
+		pkg++;
+		*u64 = (*u64) << 4;
+		*u64 |= i & 0xf;
+	}
+
+	return pkg;
+}
+
+static char *
+string2hex(char *pkg, char *out)
+{
+	char	*ret = out;
+
+	while (pkg[0]) {
+		sprintf(out, "%x", pkg[0]);
+		pkg++;
+		out += 2;
+	}
+
+	return ret;
+}
+
+static char *
+hex2string(char *pkg, char *out)
+{
+	char	*ret = out;
+	int	i, j;
+
+	while (hex2int(pkg[0], &i) && hex2int(pkg[1], &j)) {
+		out[0] = i * 16 + j;
+		pkg += 2;
+		out += 1;
+	}
+	out[0] = '\0';
+
+	return ret;
+}
+
+static char *
+gtp_strdup(char *begin, char *end)
+{
+	int	len;
+	char	*ret;
+
+	if (end)
+		len = end - begin;
+	else
+		len = strlen(begin);
+
+	ret = kmalloc(len + 1, GFP_KERNEL);
+	if (ret == NULL)
+		return NULL;
+
+	strncpy(ret, begin, len);
+	ret[len] = '\0';
+
+	return ret;
+}
+
+static void
+gtpro_list_clear(void)
+{
+	struct gtpro_entry	*e;
+
+	while (gtpro_list) {
+		e = gtpro_list;
+		gtpro_list = gtpro_list->next;
+		kfree(e);
+	}
+}
+
+static struct gtpro_entry *
+gtpro_list_add(CORE_ADDR start, CORE_ADDR end)
+{
+	struct gtpro_entry	*e;
+
+	e = kmalloc(sizeof(struct gtpro_entry), GFP_KERNEL);
+	if (e == NULL)
+		goto out;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtpro_list_add: %p %p\n", (void *)start, (void *)end);
+#endif
+
+	e->start = start;
+	e->end = end;
+
+	e->next = gtpro_list;
+	gtpro_list = e;
+
+out:
+	return e;
+}
+
+static struct gtp_var *
+gtp_var_add(unsigned int num, uint64_t val, char *src)
+{
+	struct gtp_var *var = kmalloc(sizeof(struct gtp_var), GFP_KERNEL);
+	if (!var)
+		goto out;
+
+	var->num = num;
+	var->val = val;
+
+	var->src = gtp_strdup(src, NULL);
+	if (var->src == NULL) {
+		kfree(var);
+		var = NULL;
+		goto out;
+	}
+
+	var->next = gtp_var_list;
+	gtp_var_list = var;
+	gtp_var_head = min(var->num, gtp_var_head);
+	gtp_var_tail = max(var->num, gtp_var_tail);
+
+out:
+	return var;
+}
+
+static struct gtp_var *
+gtp_var_find(unsigned int num)
+{
+	struct gtp_var	*ret = NULL;
+
+	if (num >= gtp_var_head && num <= gtp_var_tail) {
+		for (ret = gtp_var_list; ret; ret = ret->next) {
+			if (ret->num == num)
+				break;
+		}
+	}
+
+	return ret;
+}
+
+static void
+gtp_var_release(void)
+{
+	struct gtp_var	*tve;
+
+	gtp_var_head = GTP_VAR_SPECIAL_MIN;
+	gtp_var_tail = GTP_VAR_SPECIAL_MAX;
+	current_gtp_var = NULL;
+
+	while (gtp_var_list != GTP_VAR_LIST_FIRST) {
+		tve = gtp_var_list;
+		gtp_var_list = gtp_var_list->next;
+		kfree(tve->src);
+		kfree(tve);
+	}
+}
+
+static int
+gtp_gdbrsp_qtstop(void)
+{
+	struct gtp_entry	*tpe;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_gdbrsp_qtstop\n");
+#endif
+
+#ifdef FRAME_ALLOC_RECORD
+	printk(KERN_WARNING "frame_alloc_size = %llu, "
+			    "frame_alloc_size_hole = %llu\n",
+	       frame_alloc_size, frame_alloc_size_hole);
+	frame_alloc_size = 0;
+	frame_alloc_size_hole = 0;
+#endif
+
+	if (!gtp_start)
+		return -EBUSY;
+
+	flush_workqueue(gtp_wq);
+
+	for (tpe = gtp_list; tpe; tpe = tpe->next) {
+		if (tpe->kpreg) {
+			unregister_kprobe(&tpe->kp);
+			tpe->kpreg = 0;
+		}
+	}
+
+	kfree(gtp_var_array);
+	gtp_var_array = NULL;
+
+	gtp_start = 0;
+
+	return 0;
+}
+
+static int
+gtp_gdbrsp_qtinit(void)
+{
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_gdbrsp_qtinit\n");
+#endif
+
+	if (gtp_start)
+		gtp_gdbrsp_qtstop();
+
+	gtp_list_release();
+
+	if (gtp_frame)
+		gtp_frame_reset();
+
+	gtpro_list_clear();
+
+	gtp_var_release();
+
+	return 0;
+}
+
+static int
+gtp_gdbrsp_qtstart(void)
+{
+	struct gtp_entry	*tpe;
+	struct gtp_var		*tve;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_gdbrsp_qtstart\n");
+#endif
+
+	if (gtp_start)
+		return -EBUSY;
+
+	/* Check the tracepoint that have printk.  */
+	for (tpe = gtp_list; tpe; tpe = tpe->next) {
+		if (tpe->have_printk) {
+			struct action	*ae, *prev_ae = NULL;
+			struct gtpsrc	*src, *srctail = NULL;
+
+restart:
+			for (ae = tpe->action_list; ae;
+			     prev_ae = ae, ae = ae->next) {
+				switch (ae->type) {
+				case 'R':
+					/* Remove it. */
+					if (prev_ae)
+						prev_ae->next = ae->next;
+					else
+						tpe->action_list = ae->next;
+					kfree(ae->src);
+					kfree(ae);
+					if (prev_ae)
+						ae = prev_ae;
+					else
+						goto restart;
+					break;
+				case 'M':
+					printk(KERN_WARNING "qtstart: action "
+					       "of tp %d is not right.  "
+					       "Please put global variable to "
+					       "trace state variable "
+					       "$printk_tmp before print it.\n",
+					       (int)tpe->num);
+					return -EINVAL;
+					break;
+				}
+			}
+
+			for (src = tpe->src; src; src = src->next) {
+				int		i;
+				char		str[strlen(src->src) >> 1];
+				char		*var = NULL;
+				ULONGEST	num;
+				char		tmp[20];
+				struct gtpsrc	*ksrc;
+
+#ifdef GTP_DEBUG
+				printk(GTP_DEBUG "gtp_gdbrsp_qtstart: action "
+						 "%s\n", src->src);
+#endif
+				/* Get the action in str.  */
+				if (strncmp("cmd:0:", src->src,
+					    strlen("cmd:0:")))
+					continue;
+				var = hex2ulongest(src->src + 6, &num);
+				if (var[0] == '\0')
+					return -EINVAL;
+				var++;
+				hex2string(var, str);
+				if (strlen(str) != num)
+					return -EINVAL;
+#ifdef GTP_DEBUG
+				printk(GTP_DEBUG "gtp_gdbrsp_qtstart: action "
+						 "command %s\n", str);
+#endif
+
+				if (strncmp("collect ", str,
+					    strlen("collect ")))
+					continue;
+				for (i = strlen("collect "); ; i++) {
+					if (str[i] != ' ') {
+						var = str + i;
+						break;
+					}
+					if (str[i] == '\0')
+						break;
+				}
+				if (!var) {
+					printk(KERN_WARNING "qtstart: cannot "
+							    "get the var name "
+							    "from tp %d "
+							    "command %s.\n",
+					       (int)tpe->num, str);
+					return -EINVAL;
+				}
+				if (strcmp(var, "$args") == 0
+				    || strcmp(var, "$local") == 0) {
+					printk(KERN_WARNING "qtstart: cannot "
+							    "print $args and "
+							    "$local.\n");
+					return -EINVAL;
+				}
+				if (strcmp(var, "$reg") == 0)
+					continue;
+
+				ksrc = kmalloc(sizeof(struct gtpsrc),
+					       GFP_KERNEL);
+				if (ksrc == NULL)
+					return -ENOMEM;
+				ksrc->next = NULL;
+
+				snprintf(tmp, 20, "gtp %d:", (int)tpe->num);
+				ksrc->src = kmalloc(strlen(tmp)
+						   + strlen(var) + 2,
+						   GFP_KERNEL);
+				if (ksrc->src == NULL) {
+					kfree(ksrc);
+					return -ENOMEM;
+				}
+				sprintf(ksrc->src, "%s%s=", tmp, var);
+
+#ifdef GTP_DEBUG
+				printk(GTP_DEBUG "gtp_gdbrsp_qtstart: new "
+						 "printk var %s\n", ksrc->src);
+#endif
+
+				if (tpe->printk_str)
+					srctail->next = ksrc;
+				else
+					tpe->printk_str = ksrc;
+				srctail = ksrc;
+			}
+		}
+	}
+
+	if (!gtp_frame) {
+		gtp_frame = vmalloc(GTP_FRAME_SIZE);
+		if (!gtp_frame)
+			return -ENOMEM;
+
+		gtp_frame_reset();
+	}
+
+	gtp_start = 1;
+
+	gtp_var_array = kmalloc(sizeof(struct gtp_var *)
+				*(gtp_var_tail - gtp_var_head + 1),
+				GFP_KERNEL);
+	if (!gtp_var_array) {
+		gtp_gdbrsp_qtstop();
+		return -ENOMEM;
+	}
+	memset(gtp_var_array, '\0', sizeof(struct gtp_var *)
+				    *(gtp_var_tail - gtp_var_head + 1));
+	for (tve = gtp_var_list; tve; tve = tve->next)
+		gtp_var_array[tve->num - gtp_var_head] = tve;
+
+	for (tpe = gtp_list; tpe; tpe = tpe->next) {
+		if (!tpe->disable) {
+			int	ret;
+
+			if (!tpe->nopass)
+				atomic_set(&tpe->current_pass, tpe->pass);
+			ret = register_kprobe(&tpe->kp);
+			if (ret < 0) {
+				gtp_gdbrsp_qtstop();
+				return ret;
+			}
+			tpe->kpreg = 1;
+		}
+		tpe->reason = gtp_stop_normal;
+	}
+
+	return 0;
+}
+
+struct gtp_x_goto {
+	struct gtp_x_goto	*next;
+	unsigned int		addr;
+	int			non_goto_done;
+};
+
+static struct gtp_x_goto *
+gtp_x_goto_find(struct gtp_x_goto *list, unsigned int pc)
+{
+	struct gtp_x_goto	*ret = NULL;
+
+	for (ret = list; ret; ret = ret->next) {
+		if (ret->addr == pc)
+			break;
+	}
+
+	return ret;
+}
+
+static struct gtp_x_goto *
+gtp_x_goto_add(struct gtp_x_goto **list, unsigned int pc, int non_goto_done)
+{
+	struct gtp_x_goto	*ret;
+
+	ret = kmalloc(sizeof(struct gtp_x_goto), GFP_KERNEL);
+	if (!ret)
+		goto out;
+
+	ret->addr = pc;
+	ret->non_goto_done = non_goto_done;
+
+	if (*list) {
+		ret->next = *list;
+		*list = ret;
+	} else {
+		ret->next = NULL;
+		*list = ret;
+	}
+
+out:
+	return ret;
+}
+
+struct gtp_x_var {
+	struct gtp_x_var	*next;
+	unsigned int		num;
+	unsigned int		flags;
+};
+
+static int
+gtp_x_var_add(struct gtp_x_var **list, unsigned int num, unsigned int flag)
+{
+	struct gtp_x_var	*curv;
+
+	for (curv = *list; curv; curv = curv->next) {
+		if (curv->num == num)
+			break;
+	}
+
+	if (!curv) {
+		curv = kmalloc(sizeof(struct gtp_x_var), GFP_KERNEL);
+		if (!curv)
+			return -ENOMEM;
+		curv->num = num;
+		curv->flags = 0;
+		if (*list) {
+			curv->next = *list;
+			*list = curv;
+		} else {
+			curv->next = NULL;
+			*list = curv;
+		}
+	}
+
+	curv->flags |= flag;
+
+	return 0;
+}
+
+static int
+gtp_check_x(struct gtp_entry *tpe, struct action *ae)
+{
+	int			ret = -EINVAL;
+	unsigned int		pc = 0, sp = 0;
+	struct gtp_x_goto	*glist = NULL, *gtmp;
+	struct gtp_x_var	*vlist = NULL, *vtmp;
+	uint8_t			*ebuf = ae->u.exp.buf;
+	int			last_trace_pc = -1;
+	unsigned int		stack_size = 0;
+
+reswitch:
+	while (pc < ae->u.exp.size) {
+#ifdef GTP_DEBUG
+		printk(GTP_DEBUG "gtp_check_x: cmd %x\n", ebuf[pc]);
+#endif
+		switch (ebuf[pc++]) {
+		/* add */
+		case 0x02:
+		/* sub */
+		case 0x03:
+		/* mul */
+		case 0x04:
+		/* lsh */
+		case 0x09:
+		/* rsh_signed */
+		case 0x0a:
+		/* rsh_unsigned */
+		case 0x0b:
+		/* bit_and */
+		case 0x0f:
+		/* bit_or */
+		case 0x10:
+		/* bit_xor */
+		case 0x11:
+		/* equal */
+		case 0x13:
+		/* less_signed */
+		case 0x14:
+		/* less_unsigned */
+		case 0x15:
+		/* pop */
+		case 0x29:
+		/* swap */
+		case 0x2b:
+			if (ae->type == 'X') {
+				if (sp < 1) {
+					printk(KERN_WARNING "gtp_check_x: "
+							    "stack overflow "
+							    "in %d.\n",
+					pc - 1);
+					goto release_out;
+				} else
+					sp--;
+			}
+			break;
+
+		/* trace */
+		case 0x0c:
+			if (tpe->have_printk)
+				last_trace_pc = pc - 1;
+
+			if (ae->type == 'X') {
+				if (sp < 2) {
+					printk(KERN_WARNING "gtp_check_x: "
+							    "stack overflow "
+							    "in %d.\n",
+					pc - 1);
+					goto release_out;
+				} else
+					sp -= 2;
+			}
+			break;
+
+		/* log_not */
+		case 0x0e:
+		/* bit_not */
+		case 0x12:
+		/* ref8 */
+		case 0x17:
+		/* ref16 */
+		case 0x18:
+		/* ref32 */
+		case 0x19:
+		/* ref64 */
+		case 0x1a:
+			break;
+
+		/* dup */
+		case 0x28:
+			if (ae->type == 'X') {
+				sp++;
+				if (stack_size < sp)
+					stack_size = sp;
+			}
+			break;
+
+		/* const8 */
+		case 0x22:
+			if (ae->type == 'X') {
+				sp++;
+				if (stack_size < sp)
+					stack_size = sp;
+			}
+		/* ext */
+		case 0x16:
+		/* zero_ext */
+		case 0x2a:
+			if (pc >= ae->u.exp.size)
+				goto release_out;
+			pc++;
+			break;
+
+		/* trace_quick */
+		case 0x0d:
+			if (tpe->have_printk)
+				last_trace_pc = pc - 1;
+
+			if (pc >= ae->u.exp.size)
+				goto release_out;
+			pc++;
+			break;
+
+		/* const16 */
+		case 0x23:
+		/* reg */
+		case 0x26:
+			if (pc + 1 >= ae->u.exp.size)
+				goto release_out;
+			pc += 2;
+			if (ae->type == 'X') {
+				sp++;
+				if (stack_size < sp)
+					stack_size = sp;
+			}
+			break;
+
+		/* const32 */
+		case 0x24:
+			if (pc + 3 >= ae->u.exp.size)
+				goto release_out;
+			pc += 4;
+			if (ae->type == 'X') {
+				sp++;
+				if (stack_size < sp)
+					stack_size = sp;
+			}
+			break;
+
+		/* const64 */
+		case 0x25:
+			if (pc + 7 >= ae->u.exp.size)
+				goto release_out;
+			pc += 8;
+			if (ae->type == 'X') {
+				sp++;
+				if (stack_size < sp)
+					stack_size = sp;
+			}
+			break;
+
+		/* if_goto */
+		case 0x20:
+			if (tpe->have_printk)
+				goto release_out;
+
+			if (pc + 1 >= ae->u.exp.size)
+				goto release_out;
+			gtmp = gtp_x_goto_find(glist, pc);
+			if (gtmp) {
+				if (gtmp->non_goto_done)
+					goto out;
+				else {
+					gtmp->non_goto_done = 1;
+					pc += 2;
+				}
+			} else {
+				if (!gtp_x_goto_add(&glist, pc, 0)) {
+					ret = -ENOMEM;
+					goto release_out;
+				}
+				pc = (ebuf[pc] << 8)
+					+ (ebuf[pc + 1]);
+			}
+			/* Mark this action X need sp check when it exec. */
+			ae->type = 0xff;
+			break;
+
+		/* goto */
+		case 0x21:
+			if (pc + 1 >= ae->u.exp.size)
+				goto release_out;
+			gtmp = gtp_x_goto_find(glist, pc);
+			if (gtmp)
+				goto out;
+			else {
+				if (!gtp_x_goto_add(&glist, pc, 1)) {
+					ret = -ENOMEM;
+					goto release_out;
+				}
+				pc = (ebuf[pc] << 8) + (ebuf[pc + 1]);
+			}
+			break;
+
+		/* end */
+		case 0x27:
+			goto out;
+			break;
+
+		/* getv */
+		case 0x2c: {
+				int	arg;
+
+				if (pc + 1 >= ae->u.exp.size)
+					goto release_out;
+				arg = ebuf[pc++];
+				arg = (arg << 8) + ebuf[pc++];
+
+				if (GTP_VAR_NOT_GETV(arg)) {
+					printk(KERN_WARNING
+					       "gtp_check_x: The tv %d cannot "
+					       "get.\n", arg);
+					goto release_out;
+				}
+
+				if (!GTP_VAR_IS_SPECIAL(arg)) {
+					if (gtp_x_var_add(&vlist, arg, 1)) {
+						ret = -ENOMEM;
+						goto release_out;
+					}
+				}
+			}
+			if (ae->type == 'X') {
+				sp++;
+				if (stack_size < sp)
+					stack_size = sp;
+			}
+			break;
+
+		/* setv */
+		case 0x2d: {
+				int	arg;
+
+				if (pc + 1 >= ae->u.exp.size)
+					goto release_out;
+				arg = ebuf[pc++];
+				arg = (arg << 8) + ebuf[pc++];
+
+				if (GTP_VAR_NOT_SETV(arg)) {
+					printk(KERN_WARNING
+					       "gtp_check_x: The tv %d cannot "
+					       "set.\n", arg);
+					goto release_out;
+				}
+
+				if (arg == GTP_VAR_PRINTK_LEVEL_ID)
+					tpe->have_printk = 1;
+
+				if (!GTP_VAR_IS_SPECIAL(arg)) {
+					if (gtp_x_var_add(&vlist, arg, 2)) {
+						ret = -ENOMEM;
+						goto release_out;
+					}
+				}
+			}
+			break;
+
+		/* tracev */
+		case 0x2e: {
+				int	arg;
+
+				if (tpe->have_printk)
+					last_trace_pc = pc - 1;
+
+				if (pc + 1 >= ae->u.exp.size)
+					goto release_out;
+				arg = ebuf[pc++];
+				arg = (arg << 8) + ebuf[pc++];
+
+				if (GTP_VAR_NOT_TRACEV(arg)) {
+					printk(KERN_WARNING
+					       "gtp_check_x: The tv %d cannot "
+					       "trace.\n", arg);
+					goto release_out;
+				}
+
+				if (!GTP_VAR_IS_SPECIAL(arg)) {
+					if (gtp_x_var_add(&vlist, arg, 4)) {
+						ret = -ENOMEM;
+						goto release_out;
+					}
+				}
+			}
+			break;
+
+		/* printf */
+		case 0x31: {
+				int arg = ebuf[pc++];
+				if (arg && ae->type == 'X') {
+					if (sp < 1) {
+						printk(KERN_WARNING
+						       "gtp_check_x: stack "
+						       "overflow in %d.\n",
+						       pc - 2);
+						goto release_out;
+					} else
+						sp--;
+				}
+				pc += strlen((char *)ebuf + pc) + 1;
+			}
+			break;
+
+		/* div_signed */
+		case 0x05:
+		/* div_unsigned */
+		case 0x06:
+		/* rem_signed */
+		case 0x07:
+		/* rem_unsigned */
+		case 0x08:
+#ifdef CONFIG_MIPS
+			/* XXX, mips don't have 64 bit div.  */
+			goto release_out;
+#endif
+			if (ae->type == 'X') {
+				if (sp < 1) {
+					printk(KERN_WARNING "gtp_check_x: "
+							    "stack overflow "
+							    "in %d.\n",
+					       pc - 1);
+					goto release_out;
+				} else
+					sp--;
+			}
+			break;
+
+		/* float */
+		case 0x01:
+		/* ref_float */
+		case 0x1b:
+		/* ref_double */
+		case 0x1c:
+		/* ref_long_double */
+		case 0x1d:
+		/* l_to_d */
+		case 0x1e:
+		/* d_to_l */
+		case 0x1f:
+		/* trace16 */
+		case 0x30:
+		default:
+			goto release_out;
+			break;
+		}
+	}
+	goto release_out;
+
+out:
+	for (gtmp = glist; gtmp; gtmp = gtmp->next) {
+		if (!gtmp->non_goto_done)
+			break;
+	}
+	if (gtmp) {
+		pc = gtmp->addr + 2;
+		gtmp->non_goto_done = 1;
+		goto reswitch;
+	}
+	if (stack_size >= STACK_MAX) {
+		printk(KERN_WARNING "gtp_check_x: stack overflow.");
+		goto release_out;
+	}
+	ret = 0;
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_check_x: Code is OK. sp_checked is %d. "
+			 "stack_size is %d.\n",
+	       (ae->type == 'X'), stack_size);
+#endif
+
+release_out:
+	while (glist) {
+		gtmp = glist;
+		glist = glist->next;
+		kfree(gtmp);
+	}
+	while (vlist) {
+		vtmp = vlist;
+		vlist = vlist->next;
+		if ((vtmp->flags & 2)
+		    && ((vtmp->flags & 1) || (vtmp->flags & 4)))
+			ae->u.exp.need_var_lock = 1;
+		kfree(vtmp);
+	}
+
+	if (tpe->have_printk && last_trace_pc > -1) {
+		/* Set the last trace code to printk code.  */
+		switch (ebuf[last_trace_pc]) {
+		/* trace */
+		case 0x0c:
+			ebuf[last_trace_pc] = 0xfd;
+			break;
+		/* trace_quick */
+		case 0x0d:
+			ebuf[last_trace_pc] = 0xfe;
+			break;
+		/* tracev */
+		case 0x2e:
+			ebuf[last_trace_pc] = 0xff;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static int
+gtp_parse_x(struct gtp_entry *tpe, struct action *ae, char **pkgp)
+{
+	ULONGEST	size;
+	int		ret = 0, i, h, l;
+	char		*pkg = *pkgp;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_parse_x: %s\n", pkg);
+#endif
+
+	if (pkg[0] == '\0') {
+		ret = -EINVAL;
+		goto out;
+	}
+	pkg = hex2ulongest(pkg, &size);
+	if (pkg[0] != ',') {
+		ret = -EINVAL;
+		goto out;
+	}
+	ae->u.exp.size = (unsigned int)size;
+	pkg++;
+
+	ae->u.exp.buf = kmalloc(ae->u.exp.size, GFP_KERNEL);
+	if (!ae->u.exp.buf)
+		return -ENOMEM;
+
+	for (i = 0; i < ae->u.exp.size
+		    && hex2int(pkg[0], &h) && hex2int(pkg[1], &l);
+	     i++) {
+#ifdef GTP_DEBUG
+		printk(GTP_DEBUG "gtp_parse_x: %s %d %d\n", pkg, h, l);
+#endif
+		ae->u.exp.buf[i] = (h << 4) | l;
+		pkg += 2;
+#ifdef GTP_DEBUG
+		printk(GTP_DEBUG "gtp_parse_x: %x\n", ae->u.exp.buf[i]);
+#endif
+	}
+	if (i != ae->u.exp.size) {
+		kfree(ae->u.exp.buf);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ae->u.exp.need_var_lock = 0;
+
+	ret = gtp_check_x(tpe, ae);
+	if (ret < 0)
+		kfree(ae->u.exp.buf);
+
+out:
+	*pkgp = pkg;
+	return ret;
+}
+
+static int
+gtp_gdbrsp_qtdp(char *pkg)
+{
+	int			addnew = 1;
+	ULONGEST		num, addr;
+	struct gtp_entry	*tpe;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_gdbrsp_qtdp: %s\n", pkg);
+#endif
+
+	if (gtp_start)
+		return -EBUSY;
+
+	if (pkg[0] == '-') {
+		pkg++;
+		addnew = 0;
+	}
+
+	/* Get num and addr.  */
+	if (pkg[0] == '\0')
+		return -EINVAL;
+	pkg = hex2ulongest(pkg, &num);
+	if (pkg[0] == '\0')
+		return -EINVAL;
+	pkg++;
+	pkg = hex2ulongest(pkg, &addr);
+	if (pkg[0] == '\0')
+		return -EINVAL;
+	pkg++;
+
+	tpe = gtp_list_find(num);
+	if (addnew) {
+		if (tpe)
+			return -EINVAL;
+
+		tpe = gtp_list_add(num, addr);
+		if (tpe == NULL)
+			return -ENOMEM;
+
+		if (pkg[0] == '\0')
+			return -EINVAL;
+		if (pkg[0] == 'D')
+			tpe->disable = 1;
+		pkg++;
+
+		/* Get step and pass.  */
+		if (pkg[0] == '\0')
+			return -EINVAL;
+		pkg++;
+		pkg = hex2ulongest(pkg, &tpe->step);
+		if (pkg[0] == '\0')
+			return -EINVAL;
+		pkg++;
+		pkg = hex2ulongest(pkg, &tpe->pass);
+		if (tpe->pass == 0)
+			tpe->nopass = 1;
+	}
+
+	if (tpe) {
+		/* Add action to tpe.  */
+		int	step_action = 0;
+
+		if (pkg[0] == 'S') {
+			pkg++;
+			step_action = 1;
+			/* XXX: Still not support step.  */
+			return 1;
+		}
+		while (pkg[0]) {
+			struct action	*ae = NULL, *atail = NULL;
+
+#ifdef GTP_DEBUG
+			printk(GTP_DEBUG "gtp_gdbrsp_qtdp: %s\n", pkg);
+#endif
+			switch (pkg[0]) {
+			case ':':
+				pkg++;
+				break;
+			case 'M': {
+					int		is_neg = 0;
+					ULONGEST	ulongtmp;
+
+					ae = gtp_action_alloc(pkg);
+					if (!ae)
+						return -ENOMEM;
+					pkg++;
+					if (pkg[0] == '-') {
+						is_neg = 1;
+						pkg++;
+					}
+					pkg = hex2ulongest(pkg, &ulongtmp);
+					ae->u.m.regnum = (int)ulongtmp;
+					if (is_neg)
+						ae->u.m.regnum
+						  = -ae->u.m.regnum;
+					if (pkg[0] == '\0') {
+						kfree(ae);
+						return -EINVAL;
+					}
+					pkg++;
+					pkg = hex2ulongest(pkg, &ulongtmp);
+					ae->u.m.offset = (CORE_ADDR)ulongtmp;
+					if (pkg[0] == '\0') {
+						kfree(ae);
+						return -EINVAL;
+					}
+					pkg++;
+					pkg = hex2ulongest(pkg, &ulongtmp);
+					ae->u.m.size = (size_t)ulongtmp;
+				}
+				break;
+			case 'R':
+				/* XXX: reg_mask is ignore.  */
+				ae = gtp_action_alloc(pkg);
+				if (!ae)
+					return -ENOMEM;
+				pkg++;
+				pkg = hex2ulongest(pkg,
+						   &ae->u.reg_mask);
+				break;
+			case 'X': {
+					int	ret;
+
+					ae = gtp_action_alloc(pkg);
+					if (!ae)
+						return -ENOMEM;
+					pkg++;
+					ret = gtp_parse_x(tpe, ae, &pkg);
+					if (ret < 0) {
+						kfree(ae);
+						return ret;
+					}
+#ifdef GTP_DEBUG
+					if (ae && ae->u.exp.need_var_lock)
+						printk(GTP_DEBUG
+						       "gtp_gdbrsp_qtdp: "
+						       "ae need var lock.\n");
+#endif
+				}
+				break;
+			case '-':
+				pkg++;
+				break;
+			default:
+				/* XXX: Not support.  */
+				return 1;
+			}
+
+			if (ae) {
+				/* Save the src.  */
+				ae->src = gtp_strdup(ae->src, pkg);
+				if (ae->src == NULL) {
+					kfree(ae);
+					return -ENOMEM;
+				}
+				/* Add ae to tpe.  */
+				if (ae->type == 'X' && addnew && !tpe->cond) {
+					tpe->cond = ae;
+					tpe->cond->next = NULL;
+				} else if (!tpe->action_list) {
+					tpe->action_list = ae;
+					atail = ae;
+				} else {
+					if (atail == NULL)
+						for (atail = tpe->action_list;
+						     atail->next;
+						     atail = atail->next)
+							;
+					atail->next = ae;
+					atail = ae;
+				}
+			}
+		}
+	} else
+		return -EINVAL;
+
+	return 0;
+}
+
+static int
+gtp_gdbrsp_qtdpsrc(char *pkg)
+{
+	ULONGEST		num, addr;
+	struct gtpsrc		*src, *srctail;
+	struct gtp_entry	*tpe;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_gdbrsp_qtdpsrc: %s\n", pkg);
+#endif
+
+	if (gtp_start)
+		return -EBUSY;
+
+	/* Get num and addr.  */
+	if (pkg[0] == '\0')
+		return -EINVAL;
+	pkg = hex2ulongest(pkg, &num);
+	if (pkg[0] == '\0')
+		return -EINVAL;
+	pkg++;
+	pkg = hex2ulongest(pkg, &addr);
+	if (pkg[0] == '\0')
+		return -EINVAL;
+	pkg++;
+	tpe = gtp_list_find(num);
+	if (tpe == NULL)
+		return -EINVAL;
+
+	src = kmalloc(sizeof(struct gtpsrc), GFP_KERNEL);
+	if (src == NULL)
+		return -ENOMEM;
+	src->next = NULL;
+	src->src = gtp_strdup(pkg, NULL);
+	if (src->src == NULL) {
+		kfree(src);
+		return -ENOMEM;
+	}
+
+	if (tpe->src) {
+		for (srctail = tpe->src; srctail->next;
+		     srctail = srctail->next)
+			;
+		srctail->next = src;
+	} else
+		tpe->src = src;
+
+	return 0;
+}
+
+static int
+gtp_gdbrsp_qtdisconnected(char *pkg)
+{
+	ULONGEST setting;
+
+	if (pkg[0] == '\0')
+		return -EINVAL;
+
+	hex2ulongest(pkg, &setting);
+	gtp_disconnected_tracing = (int)setting;
+
+	return 0;
+}
+
+static int
+gtp_gdbrsp_qtbuffer(char *pkg)
+{
+	if (strncmp("circular:", pkg, 9) == 0) {
+		ULONGEST setting;
+
+		pkg += 9;
+		if (pkg[0] == '\0')
+			return -EINVAL;
+		hex2ulongest(pkg, &setting);
+		gtp_circular = (int)setting;
+
+		return 0;
+	}
+
+	return 1;
+}
+
+static int
+gtp_frame_head_find_addr(char *cur, int inside, unsigned long lo,
+			 unsigned long hi)
+{
+	char	*tmp;
+	int	tfnum = gtp_frame_current_num;
+
+	if (cur)
+		tmp = cur;
+	else
+		tmp = gtp_frame_r_start;
+
+	do {
+		if (FID(tmp) == FID_HEAD) {
+			if (tfnum != gtp_frame_current_num) {
+				char		*next;
+				struct pt_regs	*regs = NULL;
+
+				for (next = *(char **)(tmp + FID_SIZE); next;
+				     next = *(char **)(next + FID_SIZE)) {
+					if (FID(next) == FID_REG) {
+						regs = (struct pt_regs *)
+						       (next + FID_SIZE
+							+ sizeof(char *));
+						break;
+					}
+				}
+				if (regs
+				    && ((inside
+					 && GTP_REGS_PC(regs) >= lo
+					 && GTP_REGS_PC(regs) <= hi)
+					|| (!inside
+					    && (GTP_REGS_PC(regs) < lo
+						|| GTP_REGS_PC(regs) > hi)))) {
+					gtp_frame_current_num = tfnum;
+					gtp_frame_current = tmp;
+					return 0;
+				}
+			}
+			tfnum++;
+		}
+
+		tmp = gtp_frame_next(tmp);
+		if (!tmp)
+			break;
+
+		if (tmp == gtp_frame_end)
+			tmp = gtp_frame;
+	} while (tmp != gtp_frame_w_start);
+
+	return -1;
+}
+
+static int
+gtp_frame_head_find_trace(char *cur, ULONGEST trace)
+{
+	char	*tmp;
+	int	tfnum = gtp_frame_current_num;
+
+	if (cur)
+		tmp = cur;
+	else
+		tmp = gtp_frame_r_start;
+
+	do {
+		if (FID(tmp) == FID_HEAD) {
+			if (tfnum != gtp_frame_current_num) {
+				if (trace == *(ULONGEST *) (tmp + FID_SIZE
+							    + sizeof(char *))) {
+					gtp_frame_current_num = tfnum;
+					gtp_frame_current = tmp;
+					return 0;
+				}
+			}
+			tfnum++;
+		}
+
+		tmp = gtp_frame_next(tmp);
+		if (!tmp)
+			break;
+
+		if (tmp == gtp_frame_end)
+			tmp = gtp_frame;
+	} while (tmp != gtp_frame_w_start);
+
+	return -1;
+}
+
+static int
+gtp_frame_head_find_num(int num)
+{
+	char	*tmp = gtp_frame_r_start;
+	int	tfnum = 0;
+
+	do {
+		if (FID(tmp) == FID_HEAD) {
+			if (tfnum == num) {
+				gtp_frame_current_num = num;
+				gtp_frame_current = tmp;
+				return 0;
+			}
+			tfnum++;
+		}
+
+		tmp = gtp_frame_next(tmp);
+		if (!tmp)
+			break;
+
+		if (tmp == gtp_frame_end)
+			tmp = gtp_frame;
+	} while (tmp != gtp_frame_w_start);
+
+	return -1;
+}
+
+static int
+gtp_gdbrsp_qtframe(char *pkg)
+{
+	int	ret = -1;
+
+	if (gtp_start)
+		return -EBUSY;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_gdbrsp_qtframe: %s\n", pkg);
+#endif
+
+	if (atomic_read(&gtp_frame_create) == 0)
+		goto out;
+
+	if (strncmp(pkg, "pc:", 3) == 0) {
+		ULONGEST	addr;
+
+		pkg += 3;
+
+		if (pkg[0] == '\0')
+			return -EINVAL;
+		hex2ulongest(pkg, &addr);
+
+		ret = gtp_frame_head_find_addr(gtp_frame_current, 1,
+					       (unsigned long)addr,
+					       (unsigned long)addr);
+	} else if (strncmp(pkg, "tdp:", 4) == 0) {
+		ULONGEST	trace;
+
+		pkg += 4;
+
+		if (pkg[0] == '\0')
+			return -EINVAL;
+		hex2ulongest(pkg, &trace);
+
+		ret = gtp_frame_head_find_trace(gtp_frame_current, trace);
+	} else if (strncmp(pkg, "range:", 6) == 0) {
+		ULONGEST	start, end;
+
+		pkg += 6;
+
+		if (pkg[0] == '\0')
+			return -EINVAL;
+		pkg = hex2ulongest(pkg, &start);
+		if (pkg[0] == '\0')
+			return -EINVAL;
+		pkg++;
+		hex2ulongest(pkg, &end);
+
+		ret = gtp_frame_head_find_addr(gtp_frame_current, 1,
+					       (unsigned long)start,
+					       (unsigned long)end);
+	} else if (strncmp(pkg, "outside:", 8) == 0) {
+		ULONGEST	start, end;
+
+		pkg += 8;
+
+		if (pkg[0] == '\0')
+			return -EINVAL;
+		pkg = hex2ulongest(pkg, &start);
+		if (pkg[0] == '\0')
+			return -EINVAL;
+		pkg++;
+		hex2ulongest(pkg, &end);
+
+		ret = gtp_frame_head_find_addr(gtp_frame_current, 0,
+					       (unsigned long)start,
+					       (unsigned long)end);
+	} else {
+		ULONGEST	num;
+
+		if (pkg[0] == '\0')
+			return -EINVAL;
+		hex2ulongest(pkg, &num);
+
+		if (((int) num) < 0) {
+			/* Return to current.  */
+			gtp_frame_current = NULL;
+			gtp_frame_current_num = 0;
+
+			return 0;
+		}
+		ret = gtp_frame_head_find_num((int) num);
+	}
+
+out:
+	if (ret) {
+		strcpy(gtp_rw_bufp, "F-1");
+		gtp_rw_bufp += 3;
+		gtp_rw_size += 3;
+	} else {
+		sprintf(gtp_rw_bufp, "F%xT%x",
+			gtp_frame_current_num,
+			(unsigned int)
+			*(ULONGEST *)(gtp_frame_current + FID_SIZE
+				      + sizeof(char *)));
+		gtp_rw_size += strlen(gtp_rw_bufp);
+		gtp_rw_bufp += strlen(gtp_rw_bufp);
+	}
+	return 1;
+}
+
+static int
+gtp_gdbrsp_qtro(char *pkg)
+{
+	ULONGEST	start, end;
+
+	gtpro_list_clear();
+
+	while (pkg[0]) {
+		pkg = hex2ulongest(pkg, &start);
+		if (pkg[0] != ',')
+			return -EINVAL;
+		pkg++;
+		pkg = hex2ulongest(pkg, &end);
+		if (pkg[0])
+			pkg++;
+
+		if (gtpro_list_add((CORE_ADDR)start, (CORE_ADDR)end) == NULL)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int
+gtp_gdbrsp_qtdv(char *pkg)
+{
+	ULONGEST	num, val;
+	struct gtp_var	*var;
+	char		*src;
+
+	pkg = hex2ulongest(pkg, &num);
+	if (GTP_VAR_IS_SPECIAL(num))
+		return 0;
+	if (pkg[0] != ':')
+		return -EINVAL;
+	pkg++;
+	src = pkg;
+	pkg = hex2ulongest(pkg, &val);
+	if (pkg[0] != ':')
+		return -EINVAL;
+	pkg++;
+
+	var = gtp_var_find(num);
+	if (var)
+		return -EINVAL;
+
+	if (!gtp_var_add((unsigned int)num, (uint64_t)val, src))
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int
+gtp_gdbrsp_QT(char *pkg)
+{
+	int	ret = 1;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_gdbrsp_QT: %s\n", pkg);
+#endif
+
+	if (strcmp("init", pkg) == 0)
+		ret = gtp_gdbrsp_qtinit();
+	else if (strcmp("Stop", pkg) == 0)
+		ret = gtp_gdbrsp_qtstop();
+	else if (strcmp("Start", pkg) == 0)
+		ret = gtp_gdbrsp_qtstart();
+	else if (strncmp("DP:", pkg, 3) == 0)
+		ret = gtp_gdbrsp_qtdp(pkg + 3);
+	else if (strncmp("DPsrc:", pkg, 6) == 0)
+		ret = gtp_gdbrsp_qtdpsrc(pkg + 6);
+	else if (strncmp("Disconnected:", pkg, 13) == 0)
+		ret = gtp_gdbrsp_qtdisconnected(pkg + 13);
+	else if (strncmp("Buffer:", pkg, 7) == 0)
+		ret = gtp_gdbrsp_qtbuffer(pkg + 7);
+	else if (strncmp("Frame:", pkg, 6) == 0)
+		ret = gtp_gdbrsp_qtframe(pkg + 6);
+	else if (strncmp("ro:", pkg, 3) == 0)
+		ret = gtp_gdbrsp_qtro(pkg + 3);
+	else if (strncmp("DV:", pkg, 3) == 0)
+		ret = gtp_gdbrsp_qtdv(pkg + 3);
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_gdbrsp_QT: return %d\n", ret);
+#endif
+
+	return ret;
+}
+
+static int
+gtp_get_status(struct gtp_entry *tpe, char *buf)
+{
+	int			size = 0;
+	int			tfnum = 0;
+	CORE_ADDR		tmpaddr;
+
+	if (!gtp_frame) {
+		sprintf(buf, "tnotrun:0;");
+		buf += 10;
+		size += 10;
+	} else if (!tpe || (tpe && tpe->reason == gtp_stop_normal)) {
+		sprintf(buf, "tstop:0;");
+		buf += 8;
+		size += 8;
+	} else {
+		char	outtmp[100];
+
+		switch (tpe->reason) {
+		case gtp_stop_frame_full:
+			sprintf(buf, "tfull:%lx;",
+				(unsigned long)tpe->num);
+			break;
+		case gtp_stop_efault:
+			sprintf(buf, "terror:%s:%lx;",
+				string2hex("read memory false", outtmp),
+				(unsigned long)tpe->num);
+			break;
+		case gtp_stop_access_wrong_reg:
+			sprintf(buf, "terror:%s:%lx;",
+				string2hex("access wrong register", outtmp),
+				(unsigned long)tpe->num);
+			break;
+		case gtp_stop_agent_expr_code_error:
+			sprintf(buf, "terror:%s:%lx;",
+				string2hex("agent expression code error",
+					   outtmp),
+				(unsigned long)tpe->num);
+			break;
+		case gtp_stop_agent_expr_stack_overflow:
+			sprintf(buf, "terror:%s:%lx;",
+				string2hex("agent expression stack overflow",
+					   outtmp),
+				(unsigned long)tpe->num);
+			break;
+		default:
+			buf[0] = '\0';
+			break;
+		}
+
+		size += strlen(buf);
+		buf += strlen(buf);
+	}
+
+	if (atomic_read(&gtp_frame_create)) {
+		char	*tmp = gtp_frame_r_start;
+
+		do {
+			if (FID(tmp) == FID_HEAD)
+				tfnum++;
+
+			tmp = gtp_frame_next(tmp);
+			if (!tmp)
+				break;
+
+			if (tmp == gtp_frame_end)
+				tmp = gtp_frame;
+		} while (tmp != gtp_frame_w_start);
+	}
+	sprintf(buf, "tframes:%x;", tfnum);
+	size += strlen(buf);
+	buf += strlen(buf);
+
+	sprintf(buf, "tcreated:%x;", atomic_read(&gtp_frame_create));
+	size += strlen(buf);
+	buf += strlen(buf);
+
+	sprintf(buf, "tsize:%x;", GTP_FRAME_SIZE);
+	size += strlen(buf);
+	buf += strlen(buf);
+
+	spin_lock(&gtp_frame_lock);
+	if (gtp_frame_is_circular)
+		tmpaddr = 0;
+	else
+		tmpaddr = GTP_FRAME_SIZE - (gtp_frame_w_start - gtp_frame);
+	spin_unlock(&gtp_frame_lock);
+	sprintf(buf, "tfree:%lx;", (unsigned long)tmpaddr);
+	size += strlen(buf);
+	buf += strlen(buf);
+
+	sprintf(buf, "circular:%x;", gtp_circular);
+	size += strlen(buf);
+	buf += strlen(buf);
+
+	sprintf(buf, "disconn:%x", gtp_disconnected_tracing);
+	size += strlen(buf);
+	buf += strlen(buf);
+
+	return size;
+}
+
+static int
+gtp_gdbrsp_qtstatus(void)
+{
+	struct gtp_entry	*tpe;
+	int			tmp;
+
+	for (tpe = gtp_list; tpe; tpe = tpe->next) {
+		if (tpe->reason != gtp_stop_normal)
+			break;
+	}
+
+	if (gtp_start && tpe)	/* Tpe is stop, stop all tpes.  */
+		gtp_gdbrsp_qtstop();
+
+	sprintf(gtp_rw_bufp, "T%x;", gtp_start ? 1 : 0);
+	gtp_rw_bufp += 3;
+	gtp_rw_size += 3;
+
+	tmp = gtp_get_status(tpe, gtp_rw_bufp);
+	gtp_rw_bufp += tmp;
+	gtp_rw_size += tmp;
+
+	return 1;
+}
+
+static void
+gtp_report_tracepoint(struct gtp_entry *gtp, char *buf)
+{
+	sprintf(buf, "T%lx:%lx:%c:%lx:%lx",
+		(unsigned long)gtp->num,
+		(unsigned long)gtp->addr,
+		(gtp->disable ? 'D' : 'E'),
+		(unsigned long)gtp->step,
+		(unsigned long)gtp->pass);
+}
+
+static void
+gtp_report_action(struct gtp_entry *gtp, struct action *action, char *buf)
+{
+	sprintf(buf, "A%lx:%lx:%s",
+		(unsigned long)gtp->num,
+		(unsigned long)gtp->addr,
+		action->src);
+}
+
+static void
+gtp_report_src(struct gtp_entry *gtp, struct gtpsrc *src, char *buf)
+{
+	sprintf(buf, "Z%lx:%lx:%s",
+		(unsigned long)gtp->num,
+		(unsigned long)gtp->addr,
+		src->src);
+}
+
+static void
+gtp_current_set_check(void)
+{
+	if (current_gtp_src == NULL)
+		current_gtp = current_gtp->next;
+}
+
+static void
+gtp_current_action_check(void)
+{
+	if (current_gtp_action == NULL) {
+		current_gtp_src = current_gtp->src;
+		gtp_current_set_check();
+	}
+}
+
+static int
+gtp_gdbrsp_qtfp(void)
+{
+	if (gtp_list) {
+		current_gtp = gtp_list;
+		gtp_report_tracepoint(current_gtp, gtp_rw_bufp);
+		gtp_rw_size += strlen(gtp_rw_bufp);
+		gtp_rw_bufp += strlen(gtp_rw_bufp);
+		current_gtp_action = current_gtp->action_list;
+		gtp_current_action_check();
+	} else {
+		gtp_rw_bufp[0] = 'l';
+		gtp_rw_size += 1;
+		gtp_rw_bufp += 1;
+	}
+
+	return 1;
+}
+
+static int
+gtp_gdbrsp_qtsp(void)
+{
+	if (current_gtp_action) {
+		gtp_report_action(current_gtp, current_gtp_action,
+				  gtp_rw_bufp);
+		gtp_rw_size += strlen(gtp_rw_bufp);
+		gtp_rw_bufp += strlen(gtp_rw_bufp);
+		current_gtp_action = current_gtp_action->next;
+		gtp_current_action_check();
+		goto out;
+	}
+
+	if (current_gtp_src) {
+		gtp_report_src(current_gtp, current_gtp_src, gtp_rw_bufp);
+		gtp_rw_size += strlen(gtp_rw_bufp);
+		gtp_rw_bufp += strlen(gtp_rw_bufp);
+		current_gtp_src = current_gtp_src->next;
+		gtp_current_set_check();
+		goto out;
+	}
+
+	if (current_gtp) {
+		gtp_report_tracepoint(current_gtp, gtp_rw_bufp);
+		gtp_rw_size += strlen(gtp_rw_bufp);
+		gtp_rw_bufp += strlen(gtp_rw_bufp);
+		current_gtp_action = current_gtp->action_list;
+		gtp_current_action_check();
+	} else {
+		gtp_rw_bufp[0] = 'l';
+		gtp_rw_size += 1;
+		gtp_rw_bufp += 1;
+	}
+out:
+	return 1;
+}
+
+static void
+gtp_report_var(void)
+{
+	sprintf(gtp_rw_bufp, "%x:%s", current_gtp_var->num,
+		current_gtp_var->src);
+	gtp_rw_size += strlen(gtp_rw_bufp);
+	gtp_rw_bufp += strlen(gtp_rw_bufp);
+}
+
+static int
+gtp_gdbrsp_qtfsv(int f)
+{
+	if (f)
+		current_gtp_var = gtp_var_list;
+
+	if (current_gtp_var) {
+		gtp_report_var();
+		current_gtp_var = current_gtp_var->next;
+	} else {
+		gtp_rw_bufp[0] = 'l';
+		gtp_rw_size += 1;
+		gtp_rw_bufp += 1;
+	}
+
+	return 1;
+}
+
+static int
+gtp_gdbrsp_qtv(char *pkg)
+{
+	ULONGEST		num;
+	struct gtp_var		*var = NULL;
+	struct gtp_frame_var	*vr = NULL;
+	uint64_t		val;
+
+	pkg = hex2ulongest(pkg, &num);
+
+	if (gtp_start || !gtp_frame_current) {
+		if (!GTP_VAR_IS_SPECIAL(num)) {
+			var = gtp_var_find(num);
+			if (var)
+				val = var->val;
+		}
+	} else {
+		char	*next;
+
+		for (next = *(char **)(gtp_frame_current + FID_SIZE); next;
+		     next = *(char **)(next + FID_SIZE)) {
+			if (FID(next) == FID_VAR) {
+				vr = (struct gtp_frame_var *)
+				     (next + FID_SIZE + sizeof(char *));
+				if (vr->num == (unsigned int)num)
+					goto while_stop;
+			}
+		}
+		vr = NULL;
+while_stop:
+		if (vr)
+			val = vr->val;
+	}
+
+	if (var || vr) {
+		sprintf(gtp_rw_bufp, "V%08x%08x",
+			(unsigned int) (val >> 32),
+			(unsigned int) (val & 0xffffffff));
+		gtp_rw_size += strlen(gtp_rw_bufp);
+		gtp_rw_bufp += strlen(gtp_rw_bufp);
+	} else {
+		gtp_rw_bufp[0] = 'U';
+		gtp_rw_size += 1;
+		gtp_rw_bufp += 1;
+	}
+
+	return 1;
+}
+
+static int
+gtp_gdbrsp_qT(char *pkg)
+{
+	int	ret = 1;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_gdbrsp_qT: %s\n", pkg);
+#endif
+
+	if (strcmp("Status", pkg) == 0)
+		ret = gtp_gdbrsp_qtstatus();
+	else if (strcmp("fP", pkg) == 0)
+		ret = gtp_gdbrsp_qtfp();
+	else if (strcmp("sP", pkg) == 0)
+		ret = gtp_gdbrsp_qtsp();
+	else if (strcmp("fV", pkg) == 0)
+		ret = gtp_gdbrsp_qtfsv(1);
+	else if (strcmp("sV", pkg) == 0)
+		ret = gtp_gdbrsp_qtfsv(0);
+	else if (strncmp("V:", pkg, 2) == 0)
+		ret = gtp_gdbrsp_qtv(pkg + 2);
+
+	return ret;
+}
+
+static uint8_t	gtp_m_buffer[0xffff];
+
+static int
+gtp_gdbrsp_m(char *pkg)
+{
+	int		i;
+	ULONGEST	addr, len;
+
+	/* Get add and len.  */
+	if (pkg[0] == '\0')
+		return -EINVAL;
+	pkg = hex2ulongest(pkg, &addr);
+	if (pkg[0] != ',')
+		return -EINVAL;
+	pkg++;
+	pkg = hex2ulongest(pkg, &len);
+	if (len == 0)
+		return -EINVAL;
+	len &= 0xffff;
+	len = (ULONGEST) min((int)((GTP_RW_MAX - 4 - gtp_rw_size) / 2),
+			     (int)len);
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_gdbrsp_m: addr = 0x%lx len = %d\n",
+		(unsigned long) addr, (int) len);
+#endif
+
+	if (gtp_start || !gtp_frame_current) {
+		if (probe_kernel_read(gtp_m_buffer, (void *)(CORE_ADDR)addr,
+					(size_t)len))
+			return -EFAULT;
+	} else {
+		char	*next;
+		int	ret;
+
+		/* The following part is for gtpro support.
+		   It is not available because it make disassemble cannot
+		   work when select a trace frame. */
+#if 0
+		struct gtpro_entry	*gtroe;
+
+		memset(gtp_m_buffer, 0, len);
+
+		/* Read the gtpro.  */
+		for (gtroe = gtpro_list; gtroe; gtroe = gtroe->next) {
+			CORE_ADDR	cur_start, cur_end;
+
+			cur_start = max(gtroe->start, (CORE_ADDR)addr);
+			cur_end = min(gtroe->end, ((CORE_ADDR)(addr + len)));
+			if (cur_start < cur_end) {
+#ifdef GTP_DEBUG
+				printk(GTP_DEBUG "gtp_gdbrsp_m: ro read "
+						 "start = 0x%lx end = 0x%lx\n",
+				       (unsigned long) cur_start,
+				       (unsigned long) cur_end);
+#endif
+				if (probe_kernel_read(gtp_m_buffer,
+						       (void *)cur_start,
+						       (size_t)(cur_end
+								- cur_start)))
+					return -EFAULT;
+			}
+		}
+#endif
+		ret = probe_kernel_read(gtp_m_buffer, (void *)(CORE_ADDR)addr,
+					(size_t)len);
+
+		for (next = *(char **)(gtp_frame_current + FID_SIZE); next;
+		     next = *(char **)(next + FID_SIZE)) {
+			if (FID(next) == FID_MEM) {
+				struct gtp_frame_mem	*mr;
+				ULONGEST		cur_start, cur_end;
+				uint8_t			*buf;
+
+				mr = (struct gtp_frame_mem *)
+				     (next + FID_SIZE + sizeof(char *));
+				buf = next + GTP_FRAME_MEM_SIZE;
+#ifdef GTP_DEBUG
+				printk(GTP_DEBUG "gtp_gdbrsp_m: section "
+						 "addr = 0x%lx size = %lu\n",
+				       (unsigned long) mr->addr,
+				       (unsigned long) mr->size);
+#endif
+				cur_start = max(((ULONGEST)mr->addr), addr);
+				cur_end = min(((ULONGEST)mr->addr
+						+ mr->size),
+					       (addr + len));
+#ifdef GTP_DEBUG
+				printk(GTP_DEBUG "gtp_gdbrsp_m: read "
+						 "start = 0x%lx end = 0x%lx\n",
+				       (unsigned long) cur_start,
+				       (unsigned long) cur_end);
+#endif
+				if (cur_start < cur_end) {
+					memcpy(gtp_m_buffer,
+						buf + cur_start - mr->addr,
+						cur_end - cur_start);
+					ret = 0;
+				}
+			}
+		}
+
+		if (ret)
+			return -EFAULT;
+	}
+
+	for (i = 0; i < (int)len; i++) {
+#ifdef GTP_DEBUG
+		printk(GTP_DEBUG "gtp_gdbrsp_m: %d %02x\n", i, gtp_m_buffer[i]);
+#endif
+		sprintf(gtp_rw_bufp, "%02x", gtp_m_buffer[i]);
+		gtp_rw_bufp += 2;
+		gtp_rw_size += 2;
+	}
+
+	return 1;
+}
+
+static int
+gtp_gdbrsp_g(void)
+{
+	char		*next;
+	struct pt_regs	*regs;
+
+	if (GTP_RW_MAX - 4 - gtp_rw_size < GTP_REG_ASCII_SIZE)
+		return -E2BIG;
+
+	if (gtp_start || !gtp_frame_current) {
+		memset(gtp_rw_bufp, '0', GTP_REG_ASCII_SIZE);
+		goto out;
+	}
+
+	/* Get the regs.  */
+	regs = NULL;
+	for (next = *(char **)(gtp_frame_current + FID_SIZE); next;
+	     next = *(char **)(next + FID_SIZE)) {
+		if (FID(next) == FID_REG) {
+			regs = (struct pt_regs *)
+			       (next + FID_SIZE + sizeof(char *));
+			break;
+		}
+	}
+	if (regs)
+		gtp_regs2ascii(regs, gtp_rw_bufp);
+	else {
+		struct pt_regs		pregs;
+		struct gtp_entry	*tpe;
+
+		memset(&pregs, '\0', sizeof(struct pt_regs));
+		tpe = gtp_list_find(*(ULONGEST *)(gtp_frame_current
+						  + FID_SIZE + sizeof(char *)));
+		if (tpe)
+			GTP_REGS_PC(&pregs) = (unsigned long)tpe->addr;
+		gtp_regs2ascii(&pregs, gtp_rw_bufp);
+	}
+out:
+	gtp_rw_bufp += GTP_REG_ASCII_SIZE;
+	gtp_rw_size += GTP_REG_ASCII_SIZE;
+
+	return 1;
+}
+
+static DEFINE_SEMAPHORE(gtp_rw_lock);
+static DECLARE_WAIT_QUEUE_HEAD(gtp_rw_wq);
+static unsigned int	gtp_rw_count;
+
+static int
+gtp_open(struct inode *inode, struct file *file)
+{
+	int	ret = 0;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_open\n");
+#endif
+
+	down(&gtp_rw_lock);
+	if (gtp_rw_count == 0) {
+		gtp_read_ack = 0;
+		gtp_rw_buf = vmalloc(GTP_RW_MAX);
+		if (!gtp_rw_buf) {
+			ret = -ENOMEM;
+			goto out;
+		}
+	}
+	gtp_rw_count++;
+
+out:
+	up(&gtp_rw_lock);
+	return ret;
+}
+
+static int
+gtp_release(struct inode *inode, struct file *file)
+{
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_release\n");
+#endif
+
+	down(&gtp_rw_lock);
+	gtp_rw_count--;
+	if (gtp_rw_count == 0) {
+		vfree(gtp_rw_buf);
+
+		if (!gtp_disconnected_tracing) {
+			gtp_gdbrsp_qtstop();
+			gtp_gdbrsp_qtinit();
+			if (gtp_frame) {
+				vfree(gtp_frame);
+				gtp_frame = NULL;
+			}
+		}
+	}
+	up(&gtp_rw_lock);
+
+	return 0;
+}
+
+static long
+gtp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_ioctl: %x\n", cmd);
+#endif
+
+	return 0;
+}
+
+static ssize_t
+gtp_write(struct file *file, const char __user *buf, size_t size,
+	  loff_t *ppos)
+{
+	char		*rsppkg = NULL;
+	int		i, ret;
+	unsigned char	csum = 0;
+
+	if (down_interruptible(&gtp_rw_lock))
+		return -EINTR;
+
+	if (size == 0) {
+#ifdef GTP_DEBUG
+		printk(GTP_DEBUG "gtp_write: try write 0 size.\n");
+#endif
+		goto error_out;
+	}
+
+	size = min(size, (size_t) GTP_RW_MAX);
+	if (copy_from_user(gtp_rw_buf, buf, size)) {
+		size = -EFAULT;
+		goto error_out;
+	}
+
+	if (gtp_rw_buf[0] == '+' || gtp_rw_buf[0] == '-'
+	    || gtp_rw_buf[0] == '\3') {
+		if (gtp_rw_buf[0] == '+')
+			gtp_rw_size = 0;
+		size = 1;
+		goto out;
+	}
+
+	if (size < 4) {
+		gtp_read_ack = '-';
+		goto out;
+	}
+	/* Check format and crc and get the rsppkg.  */
+	for (i = 0; i < size - 2; i++) {
+		if (rsppkg == NULL) {
+			if (gtp_rw_buf[i] == '$')
+				rsppkg = gtp_rw_buf + i + 1;
+		} else {
+			if (gtp_rw_buf[i] == '#')
+				break;
+			else
+				csum += gtp_rw_buf[i];
+		}
+	}
+	if (rsppkg && gtp_rw_buf[i] == '#') {
+		/* Format is OK.  Check crc.  */
+		unsigned char	c1, c2;
+
+		gtp_rw_buf[i] = '\0';
+
+		c1 = gtp_rw_buf[i+1];
+		c2 = gtp_rw_buf[i+2];
+		if (csum == (c1 << 4) + c2) {
+#ifdef GTP_DEBUG
+			printk(GTP_DEBUG "gtp_write: crc error\n");
+#endif
+			gtp_read_ack = '-';
+			goto out;
+		}
+	} else {
+#ifdef GTP_DEBUG
+		printk(GTP_DEBUG "gtp_write: format error\n");
+#endif
+		gtp_read_ack = '-';
+		goto out;
+	}
+	gtp_read_ack = '+';
+	size = i + 3;
+
+	wake_up_interruptible_nr(&gtp_rw_wq, 1);
+
+	up(&gtp_rw_lock);
+	if (down_interruptible(&gtp_rw_lock))
+		return -EINTR;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_write: %s\n", rsppkg);
+#endif
+
+	/* Handle rsppkg and put return to gtp_rw_buf.  */
+	gtp_rw_buf[0] = '$';
+	gtp_rw_bufp = gtp_rw_buf + 1;
+	gtp_rw_size = 0;
+	ret = 1;
+	switch (rsppkg[0]) {
+	case '?':
+		strcpy(gtp_rw_bufp, "S05");
+		gtp_rw_bufp += 3;
+		gtp_rw_size += 3;
+		break;
+	case 'g':
+		ret = gtp_gdbrsp_g();
+		break;
+	case 'm':
+		ret = gtp_gdbrsp_m(rsppkg + 1);
+		break;
+	case 'Q':
+		if (rsppkg[1] == 'T')
+			ret = gtp_gdbrsp_QT(rsppkg + 2);
+		break;
+	case 'q':
+		if (rsppkg[1] == 'T')
+			ret = gtp_gdbrsp_qT(rsppkg + 2);
+		else if (strncmp("qSupported", rsppkg, 10) == 0) {
+			strcpy(gtp_rw_bufp,
+			       "ConditionalTracepoints+;"
+			       "TracepointSource+;DisconnectedTracing+");
+			gtp_rw_size += strlen(gtp_rw_bufp);
+			gtp_rw_bufp += strlen(gtp_rw_bufp);
+			ret = 1;
+		}
+		break;
+	case 's':
+	case 'S':
+	case 'c':
+	case 'C':
+		ret = -1;
+		break;
+	}
+	if (ret == 0) {
+		strcpy(gtp_rw_bufp, "OK");
+		gtp_rw_bufp += 2;
+		gtp_rw_size += 2;
+	} else if (ret < 0) {
+		sprintf(gtp_rw_bufp, "E%02x", -ret);
+		gtp_rw_bufp += 3;
+		gtp_rw_size += 3;
+	}
+
+	gtp_rw_bufp[0] = '#';
+	csum = 0;
+	for (i = 1; i < gtp_rw_size + 1; i++)
+		csum += gtp_rw_buf[i];
+	gtp_rw_bufp[1] = TOHEX(csum >> 4);
+	gtp_rw_bufp[2] = TOHEX(csum & 0x0f);
+	gtp_rw_bufp = gtp_rw_buf;
+	gtp_rw_size += 4;
+
+out:
+	wake_up_interruptible_nr(&gtp_rw_wq, 1);
+error_out:
+	up(&gtp_rw_lock);
+	return size;
+}
+
+static ssize_t
+gtp_read(struct file *file, char __user *buf, size_t size,
+	 loff_t *ppos)
+{
+	int	err;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_read\n");
+#endif
+
+	if (size == 0)
+		goto out;
+
+	if (down_interruptible(&gtp_rw_lock))
+		return -EINTR;
+
+	if (gtp_read_ack) {
+		err = put_user(gtp_read_ack, buf);
+		if (err) {
+			size = -err;
+			goto out;
+		}
+		gtp_read_ack = 0;
+		size = 1;
+		goto out;
+	}
+
+	size = min(gtp_rw_size, size);
+	if (size == 0)
+		goto out;
+	if (copy_to_user(buf, gtp_rw_bufp, size)) {
+		size = -EFAULT;
+		goto out;
+	}
+	gtp_rw_bufp += size;
+	gtp_rw_size -= size;
+
+out:
+	up(&gtp_rw_lock);
+	return size;
+}
+
+static unsigned int
+gtp_poll(struct file *file, poll_table *wait)
+{
+	unsigned int	mask = POLLOUT | POLLWRNORM;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_poll\n");
+#endif
+
+	down(&gtp_rw_lock);
+	poll_wait(file, &gtp_rw_wq, wait);
+	if (gtp_read_ack || gtp_rw_size)
+		mask |= POLLIN | POLLRDNORM;
+	up(&gtp_rw_lock);
+
+	return mask;
+}
+
+static char *
+gtp_frame_file_realloc(size_t *real_size, size_t size, int is_end)
+{
+	if (*real_size < gtp_frame_file_size + size) {
+		char	*tmp;
+
+		*real_size = gtp_frame_file_size + size;
+		if (!is_end)
+			*real_size += 100;
+
+		tmp = vmalloc(*real_size);
+		if (!tmp) {
+			vfree(gtp_frame_file);
+			return NULL;
+		}
+
+		memcpy(tmp, gtp_frame_file, gtp_frame_file_size);
+		vfree(gtp_frame_file);
+		gtp_frame_file = tmp;
+	}
+
+	return gtp_frame_file + gtp_frame_file_size;
+}
+
+static int
+gtp_frame2file_m(size_t *real_sizep, uint32_t *data_size, char *frame)
+{
+	struct gtp_frame_mem	*mr;
+	uint8_t			*buf;
+	ULONGEST		addr;
+	size_t			remaining;
+
+	mr = (struct gtp_frame_mem *) (frame + FID_SIZE + sizeof(char *));
+	buf = frame + GTP_FRAME_MEM_SIZE;
+	addr = mr->addr;
+	remaining = mr->size;
+
+	while (remaining > 0) {
+		uint16_t	blocklen;
+		char		*wbuf;
+		size_t		sp;
+
+		blocklen = remaining > 65535 ? 65535 : remaining;
+
+		sp = 1 + sizeof(addr) + sizeof(blocklen) + blocklen;
+		wbuf = gtp_frame_file_realloc(real_sizep, sp, 0);
+		if (!wbuf)
+			return -1;
+
+		wbuf[0] = 'M';
+		wbuf += 1;
+
+		memcpy(wbuf, &addr, sizeof(addr));
+		wbuf += sizeof(addr);
+
+		memcpy(wbuf, &blocklen, sizeof(blocklen));
+		wbuf += sizeof(blocklen);
+
+		memcpy(wbuf, buf, blocklen);
+
+		addr += blocklen;
+		remaining -= blocklen;
+		buf += blocklen;
+
+		gtp_frame_file_size += sp;
+		*data_size += sp;
+	}
+
+	return 0;
+}
+
+static int
+gtp_frame2file_v(size_t *real_sizep, uint32_t *data_size, char *frame)
+{
+	struct gtp_frame_var	*vr;
+	size_t			sp = 1 + sizeof(unsigned int)
+				     + sizeof(uint64_t);
+	char			*wbuf;
+
+	wbuf = gtp_frame_file_realloc(real_sizep, sp, 0);
+	if (!wbuf)
+		return -1;
+
+	vr = (struct gtp_frame_var *) (frame + FID_SIZE + sizeof(char *));
+
+	wbuf[0] = 'V';
+	wbuf += 1;
+
+	memcpy(wbuf, &vr->num, sizeof(unsigned int));
+	wbuf += sizeof(unsigned int);
+
+	memcpy(wbuf, &vr->val, sizeof(uint64_t));
+	wbuf += sizeof(uint64_t);
+
+	gtp_frame_file_size += sp;
+	*data_size += sp;
+
+	return 0;
+}
+
+static int
+gtp_frame2file(size_t *real_sizep, char *frame)
+{
+	int16_t		*tmp16p;
+	char		*next;
+	char		*wbuf;
+	uint32_t	data_size;
+
+	/* Head.  */
+	tmp16p = (int16_t *)gtp_frame_file_realloc(real_sizep, 2, 0);
+	if (!tmp16p)
+		return -1;
+	*tmp16p = (int16_t)*(ULONGEST *)(frame + FID_SIZE + sizeof(char *));
+	gtp_frame_file_size += 2;
+	/* This part is for the data_size.  */
+	wbuf = gtp_frame_file_realloc(real_sizep, 4, 0);
+	if (!wbuf)
+		return -1;
+	gtp_frame_file_size += 4;
+
+	/* Body.  */
+	data_size = 0;
+	for (next = *(char **)(frame + FID_SIZE); next;
+	     next = *(char **)(next + FID_SIZE)) {
+		switch (FID(next)) {
+		case FID_REG:
+			wbuf = gtp_frame_file_realloc(real_sizep,
+						      GTP_REG_BIN_SIZE + 1,
+						      0);
+			if (!wbuf)
+				return -1;
+			wbuf[0] = 'R';
+			gtp_regs2bin((struct pt_regs *)(next + FID_SIZE
+							+ sizeof(char *)),
+				     wbuf + 1);
+			gtp_frame_file_size += GTP_REG_BIN_SIZE + 1;
+			data_size += GTP_REG_BIN_SIZE + 1;
+			break;
+
+		case FID_MEM:
+			if (gtp_frame2file_m(real_sizep, &data_size, next))
+				return -1;
+			break;
+
+		case FID_VAR:
+			if (gtp_frame2file_v(real_sizep, &data_size, next))
+				return -1;
+			break;
+		}
+	}
+
+	/* Set the data_size.  */
+	memcpy(gtp_frame_file + gtp_frame_file_size - data_size - 4,
+	       &data_size, 4);
+
+	return 0;
+}
+
+static ssize_t
+gtpframe_read(struct file *file, char __user *buf, size_t size,
+	      loff_t *ppos)
+{
+	ssize_t	ret = -ENOMEM;
+
+	down(&gtp_rw_lock);
+
+	if (gtp_start) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	/* Set gtp_frame_file if need.  */
+	if (!gtp_frame_file) {
+		size_t			real_size;
+		char			*wbuf;
+		struct gtp_entry	*tpe;
+		struct gtp_var		*tvar;
+		int			tmpsize;
+		char			tmpbuf[200];
+		char			*frame;
+
+		if (gtp_frame_is_circular)
+			real_size = GTP_FRAME_SIZE;
+		else
+			real_size = gtp_frame_w_start - gtp_frame;
+		real_size += 200;
+
+		gtp_frame_file = vmalloc(real_size);
+		if (!gtp_frame_file)
+			goto out;
+		gtp_frame_file_size = 0;
+
+		/* Head. */
+		wbuf = gtp_frame_file;
+		strcpy(wbuf, "\x7fTRACE0\n");
+		gtp_frame_file_size += 8;
+
+		/* BUG: will be a new value.  */
+		snprintf(tmpbuf, 200, "R %x\n", GTP_REG_BIN_SIZE);
+		wbuf = gtp_frame_file_realloc(&real_size, strlen(tmpbuf), 0);
+		if (!wbuf)
+			goto out;
+		strcpy(wbuf, tmpbuf);
+		gtp_frame_file_size += strlen(tmpbuf);
+
+		strcpy(tmpbuf, "status 0;");
+		wbuf = gtp_frame_file_realloc(&real_size, strlen(tmpbuf), 0);
+		if (!wbuf)
+			goto out;
+		strcpy(wbuf, tmpbuf);
+		gtp_frame_file_size += strlen(tmpbuf);
+
+		for (tpe = gtp_list; tpe; tpe = tpe->next) {
+			if (tpe->reason != gtp_stop_normal)
+				break;
+		}
+		tmpsize = gtp_get_status(tpe, tmpbuf);
+		wbuf = gtp_frame_file_realloc(&real_size, tmpsize, 0);
+		if (!wbuf)
+			goto out;
+		memcpy(wbuf, tmpbuf, tmpsize);
+		gtp_frame_file_size += tmpsize;
+
+		wbuf = gtp_frame_file_realloc(&real_size, 1, 0);
+		if (!wbuf)
+			goto out;
+		wbuf[0] = '\n';
+		gtp_frame_file_size += 1;
+
+		/* Tval. */
+		for (tvar = gtp_var_list; tvar; tvar = tvar->next) {
+			snprintf(tmpbuf, 200, "tsv %x:%s\n", tvar->num,
+				 tvar->src);
+			wbuf = gtp_frame_file_realloc(&real_size,
+						      strlen(tmpbuf), 0);
+			if (!wbuf)
+				goto out;
+			strcpy(wbuf, tmpbuf);
+			gtp_frame_file_size += strlen(tmpbuf);
+		}
+
+		/* Tracepoint.  */
+		for (tpe = gtp_list; tpe; tpe = tpe->next) {
+			struct action	*ae;
+			struct gtpsrc	*src;
+
+			/* Tpe.  */
+			gtp_report_tracepoint(tpe, tmpbuf);
+			wbuf = gtp_frame_file_realloc(&real_size,
+						      strlen(tmpbuf) + 5, 0);
+			if (!wbuf)
+				goto out;
+			sprintf(wbuf, "tp %s\n", tmpbuf);
+			gtp_frame_file_size += strlen(tmpbuf) + 4;
+			/* Action.  */
+			for (ae = tpe->action_list; ae; ae = ae->next) {
+				gtp_report_action(tpe, ae, tmpbuf);
+				wbuf = gtp_frame_file_realloc
+					   (&real_size, strlen(tmpbuf) + 5, 0);
+				if (!wbuf)
+					goto out;
+				sprintf(wbuf, "tp %s\n", tmpbuf);
+				gtp_frame_file_size += strlen(tmpbuf) + 4;
+			}
+			/* Src.  */
+			for (src = tpe->src; src; src = src->next) {
+				gtp_report_src(tpe, src, tmpbuf);
+				wbuf = gtp_frame_file_realloc
+					   (&real_size, strlen(tmpbuf) + 5, 0);
+				if (!wbuf)
+					goto out;
+				sprintf(wbuf, "tp %s\n", tmpbuf);
+				gtp_frame_file_size += strlen(tmpbuf) + 4;
+			}
+		}
+
+		wbuf = gtp_frame_file_realloc(&real_size, 1, 0);
+		if (!wbuf)
+			goto out;
+		wbuf[0] = '\n';
+		gtp_frame_file_size += 1;
+
+		/* Frame.  */
+		if (atomic_read(&gtp_frame_create) == 0)
+			goto end;
+		frame = gtp_frame_r_start;
+		do {
+			if (FID(frame) == FID_HEAD) {
+				if (gtp_frame2file(&real_size, frame))
+					goto out;
+			}
+
+			frame = gtp_frame_next(frame);
+			if (!frame)
+				break;
+
+			if (frame == gtp_frame_end)
+				frame = gtp_frame;
+		} while (frame != gtp_frame_w_start);
+
+end:
+		/* End.  */
+		wbuf = gtp_frame_file_realloc(&real_size, tmpsize, 2);
+		if (!wbuf)
+			goto out;
+		wbuf[0] = '\0';
+		wbuf[1] = '\0';
+		gtp_frame_file_size += 2;
+	}
+
+	/* Set buf.  */
+	ret = size;
+	if (*ppos + ret > gtp_frame_file_size) {
+		ret = gtp_frame_file_size - *ppos;
+		if (ret <= 0) {
+			ret = 0;
+			goto out;
+		}
+	}
+	if (copy_to_user(buf, gtp_frame_file + *ppos, ret)) {
+		size = -EFAULT;
+		goto out;
+	}
+	*ppos += ret;
+
+out:
+	up(&gtp_rw_lock);
+	return ret;
+}
+
+static const struct file_operations gtp_operations = {
+	.owner		= THIS_MODULE,
+	.open		= gtp_open,
+	.release	= gtp_release,
+	.unlocked_ioctl	= gtp_ioctl,
+	.compat_ioctl	= gtp_ioctl,
+	.read		= gtp_read,
+	.write		= gtp_write,
+	.poll		= gtp_poll,
+};
+
+static const struct file_operations gtpframe_operations = {
+	.owner		= THIS_MODULE,
+	.open		= gtp_open,
+	.release	= gtp_release,
+	.read		= gtpframe_read,
+	.llseek		= default_llseek,
+};
+
+struct dentry	*gtp_dir;
+struct dentry	*gtpframe_dir;
+
+static int __init gtp_init(void)
+{
+	int		ret = -ENOMEM;
+
+	gtp_list = NULL;
+	gtp_read_ack = 0;
+	gtp_rw_bufp = NULL;
+	gtp_rw_size = 0;
+	gtp_start = 0;
+	gtp_disconnected_tracing = 0;
+	gtp_circular = 0;
+	gtp_var_list = GTP_VAR_LIST_FIRST;
+	gtp_var_head = GTP_VAR_SPECIAL_MIN;
+	gtp_var_tail = GTP_VAR_SPECIAL_MAX;
+	gtp_var_array = NULL;
+	current_gtp_var = NULL;
+	gtp_frame = NULL;
+	gtp_frame_r_start = NULL;
+	gtp_frame_w_start = NULL;
+	gtp_frame_end = NULL;
+	gtp_frame_is_circular = 0;
+	gtp_frame_current = NULL;
+	gtp_frame_current_num = 0;
+	atomic_set(&gtp_frame_create, 0);
+	gtp_rw_count = 0;
+	current_gtp = NULL;
+	current_gtp_action = NULL;
+	current_gtp_src = NULL;
+	gtpro_list = NULL;
+	gtp_frame_file = NULL;
+	gtp_frame_file_size = 0;
+	gtp_dir = NULL;
+	gtpframe_dir = NULL;
+
+	gtp_wq = create_singlethread_workqueue("gtpd");
+	if (gtp_wq == NULL)
+		goto out;
+
+	gtp_dir = debugfs_create_file("gtp", S_IFIFO | S_IRUSR | S_IWUSR, NULL,
+				      NULL, &gtp_operations);
+	if (gtp_dir == NULL || gtp_dir == ERR_PTR(-ENODEV)) {
+		gtp_dir = NULL;
+		goto out;
+	}
+	gtpframe_dir = debugfs_create_file("gtpframe", S_IFIFO | S_IRUSR, NULL,
+					   NULL, &gtpframe_operations);
+	if (gtpframe_dir == NULL || gtpframe_dir == ERR_PTR(-ENODEV)) {
+		gtpframe_dir = NULL;
+		goto out;
+	}
+
+	ret = 0;
+out:
+	if (ret < 0) {
+		if (gtp_wq)
+			destroy_workqueue(gtp_wq);
+
+		if (gtp_dir != NULL)
+			debugfs_remove_recursive(gtp_dir);
+		if (gtpframe_dir != NULL)
+			debugfs_remove_recursive(gtpframe_dir);
+	}
+
+	return 0;
+}
+
+static void __exit gtp_exit(void)
+{
+	if (gtp_dir != NULL)
+		debugfs_remove_recursive(gtp_dir);
+	if (gtpframe_dir != NULL)
+		debugfs_remove_recursive(gtpframe_dir);
+
+	gtp_gdbrsp_qtstop();
+	gtp_gdbrsp_qtinit();
+	if (gtp_frame) {
+		vfree(gtp_frame);
+		gtp_frame = NULL;
+	}
+
+	destroy_workqueue(gtp_wq);
+}
+
+module_init(gtp_init)
+module_exit(gtp_exit)
+
+MODULE_AUTHOR("Hui Zhu <teawater@gmail.com>");
+MODULE_LICENSE("GPL");
--- /dev/null
+++ b/scripts/getgtprsp.pl
@@ -0,0 +1,102 @@
+#!/usr/bin/perl
+
+# This script to get the GDB tracepoint RSP package and save it
+# to ./gtpstart and ./gtpstop file.
+# GPL
+# Copyright(C) Hui Zhu (teawater@gmail.com), 2010
+
+binmode STDIN, ":raw";
+$| = 1;
+
+$status = 0;
+$circular = 0;
+$var_count = 0;
+
+while (1) {
+	sysread STDIN, $c, 1 or next;
+	if ($c eq '') {
+		next;
+	} elsif ($c eq '+' || $c eq '-') {
+		$c = '';
+	}
+
+	sysread STDIN, $line, 1024 or next;
+	print '+';
+	$line = $c.$line;
+
+	open(LOG, ">>./log");
+	print LOG $line."\n";
+	close (LOG);
+
+	if ($status == 0) {
+		if ($line eq '$?#3f') {
+			print '$S05#b8';
+		} elsif ($line eq '$g#67') {
+			print '$00000000#80';
+		} elsif ($line =~ /^\$m/ || $line =~ /^\$p/) {
+			print '$00000000#80';
+		} elsif ($line eq '$qTStatus#49') {
+			print '$T0;tnotrun:0;tframes:0;tcreated:0;tsize:';
+			print '500000;tfree:500000;circular:0;disconn:0#d1';
+		} elsif ($line eq '$QTBuffer:circular:1#f9') {
+			print '$OK#9a';
+			$circular = 1;
+		} elsif ($line eq '$QTBuffer:circular:0#f8') {
+			print '$OK#9a';
+			$circular = 0;
+		} elsif ($line eq '$QTStop#4b') {
+			print '$OK#9a';
+		} elsif ($line =~ /^\$qSupported/) {
+			print '$ConditionalTracepoints+;TracepointSource+#1b';
+		} elsif ($line eq '$QTinit#59') {
+			$status = 1;
+			open(STARTFILE, ">./gtpstart");
+			print STARTFILE '$QTDisconnected:1#e3'."\n";
+			if ($circular) {
+				print STARTFILE '$QTBuffer:circular:1#f9'."\n";
+			} else {
+				print STARTFILE '$QTBuffer:circular:0#f8'."\n";
+			}
+		} elsif ($line eq '$qTfV#81') {
+			print '$8:0:1:64756d705f737461636b#f6';
+		} elsif ($line eq '$qTsV#8e') {
+			if ($var_count == 0) {
+				print '$7:0:1:7072696e746b5f666f726d6174#9b';
+			} elsif ($var_count == 1) {
+				print '$6:8:1:7072696e746b5f6c6576656c#3a';
+			} elsif ($var_count == 2) {
+				print '$5:0:1:7072696e746b5f746d70#28';
+			} elsif ($var_count == 3) {
+				print '$4:0:1:6370755f6964#f3';
+			} elsif ($var_count == 4) {
+				print '$3:0:1:636c6f636b#e1';
+			} elsif ($var_count == 5) {
+				print '$2:0:1:63757272656e745f7468726561';
+				print '645f696e666f#1f';
+			} elsif ($var_count == 6) {
+				print '$1:0:1:63757272656e745f7461736b#c7';
+			} else {
+				print '$l#6c';
+			}
+			$var_count++;
+		} else {
+			print '$#00';
+		}
+	}
+
+	if ($status == 1) {
+		print '$OK#9a';
+
+		print STARTFILE $line."\n";
+
+		if ($line eq '$QTStart#b3') {
+			$status = 0;
+
+			close(STARTFILE);
+
+			open(STOPFILE, ">./gtpstop");
+			print STOPFILE '$QTStop#4b'."\n";
+			close(STOPFILE);
+		}
+	}
+}
