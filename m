Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab1INIsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 04:48:33 -0400
Received: from mail-fx0-f66.google.com ([209.85.161.66]:58190 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab1INIsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 04:48:23 -0400
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Wed, 14 Sep 2011 16:47:37 +0800
Message-ID: <CANFwon0DRqfUFVw9YU52En6A-ri_XT0kSgOt6pfR-W6s-LuPOQ@mail.gmail.com>
Subject: KGTP (Linux Kernel debugger and tracer) 20110912 release (quickstart available)
To: linux-kernel@vger.kernel.org
Cc: Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        Steven <mqyoung@gmail.com>, colyli@gmail.com,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KGTP is a realtime and lightweight Linux Kernel GDB debugger and tracer.

It makes Linux Kernel supply a GDB remote debug interface. Then GDB in
current machine or remote machine can debug and trace Linux through
GDB tracepoint without stopping the Linux Kernel.
Now, it supports X86-32, X86-64, MIPS and ARM.

Now, KGTP 20110912 release.
You can get the package for it from
http://kgtp.googlecode.com/files/kgtp_20110912.tar.bz2
or
svn co https://kgtp.googlecode.com/svn/tags/20110912

The main change of this version is add quickstart for ubuntu and
fedora, you can access gtp_quickstart.txt or
https://code.google.com/p/kgtp/wiki/Quickstart
To get other change info please goto https://code.google.com/p/kgtp/wiki/UPDATE

According to the comments of Christoph.  I make a patch for Linux
Kernel and make it looks OK with checkpatch.pl.

Thanks,
Hui

Signed-off-by: Hui Zhu <teawater@gmail.com>
---
 Documentation/trace/gtp.txt            | 1440 ++++++
 Documentation/trace/gtp_quickstart.txt |  250 +
 arch/arm/include/asm/gtp.h             |   13
 arch/mips/include/asm/gtp.h            |   18
 arch/x86/include/asm/gtp.h             |   18
 include/linux/perf_event.h             |    3
 kernel/events/core.c                   |   16
 lib/Kconfig.debug                      |   11
 lib/Makefile                           |    2
 lib/gtp.c                              | 7323 +++++++++++++++++++++++++++++++++
 scripts/getgtprsp.pl                   |  102
 11 files changed, 9194 insertions(+), 2 deletions(-)

--- /dev/null
+++ b/Documentation/trace/gtp.txt
@@ -0,0 +1,1440 @@
+		Linux Kernel GDB tracepoint module (KGTP)
+		=========================================
+		By Hui Zhu <teawater@gmail.com>
+		https://code.google.com/p/kgtp/wiki/HOWTO
+		2011-09-12
+
+Table of contents
+-----------------
+
+What is KGTP
+Report issues about KGTP
+Get info about GDB tracepoint
+Install GDB for KGTP
+Get KGTP through http
+Get KGTP through svn
+Config KGTP
+Compile KGTP
+Install KGTP
+Uninstall KGTP
+Use KGTP with DKMS
+How to get new version GDB
+Howto use
+	Exec it
+	Make GDB connect to gtp
+		If GDB on current machine
+		If GDB on remote machine
+	How to use /sys/kernel/debug/gtpframe
+	How to use /sys/kernel/debug/gtpframe_pipe
+		Get the frame info with cat
+		Get the frame info with getframe
+		Get the frame info with GDB
+	Add module symbols to GDB
+		How to use getmod.py
+		How to use getmod
+	Get GDB tracepoint commands
+	Get register info from Kernel
+	Get the value of variable from Kernel
+	How to use use tracepoint condition
+	How to use trace state variables
+		Simple trace state variables
+		Per_cpu trace state variables
+		Special trace state variables $current_task,
+		    $current_thread_info, $cpu_id, $dump_stack, $printk_level,
+		    $printk_format, $printk_tmp, $clock, $rdtsc, $hardirq_count,
+		    $softirq_count and $irq_count
+		Special trace state variable $no_self_trace
+		Trace the function return with $kret
+		Use $ignore_error and $last_errno to ignore the error of tstart
+		Use $cooked_clock and $cooked_rdtsc the time without KGTP used
+		Use $xtime_sec and $xtime_nsec get the timespec
+	How to use performance counters
+	Show all the traced data of current frame
+	Get backtrace info(stack dump) from Kernel
+	Howto let tracepoint output value directly
+		Output stack dump directly
+		Switch collect to output the value directly
+		Use printf command in actions
+	Get status of KGTP from Kernel
+	Set the trace buffer into a circular buffer
+	Do not stop tracepoint when the GDB disconnects
+	Howto show a variable whose value has been optimized away
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
+KGTP is a realtime and lightweight Linux Kernel GDB debugger and tracer.
+
+It makes Linux Kernel supply a GDB remote debug interface. Then GDB in current
+machine or remote machine (see "Make GDB connect to gtp") can debug and trace
+Linux through GDB tracepoint without stopping the Linux Kernel.
+And even if the board doesn't have GDB on it and doesn't have interface for
+remote debug. It can debug the Linux Kernel using offline debug (See "Offline
+debug").
+It supports X86-32, X86-64, MIPS and ARM.
+
+For new user of KGTP, please go to see gtp_quickstart.txt.
+
+
+
+
+Report issues about KGTP
+------------------------
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
+Install GDB for KGTP
+------------------------
+The GDB that older than 7.3 have some bugs of tracepoint.  And some functions
+of GDB are not very well.
+So please goto https://code.google.com/p/gdbt/ to install GDB for KGTP.
+
+
+
+
+Get KGTP through http
+---------------------
+Please goto http://code.google.com/p/kgtp/downloads/list OR UPDATE to download
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
+kgtp-read-only/tags/ Present for each release of KGTP.
+kgtp-read-only/trunk/ Present for the main trunk of KGTP.
+
+
+
+
+Config KGTP
+-----------
+
+Before compiling KGTP, you can choose which kernel you want build with and
+which compiler you want by making changes to the Makefile in your KGTP
+repository.
+For example:
+
+-------------------------------------------
+KERNELDIR := /lib/modules/`uname -r`/build
+CROSS_COMPILE :=
+-------------------------------------------
+
+KERELDIR is set to the directory which holds the kernel you want to build for.
+By default, it is set to the kernel that you are running.
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
+
+
+
+Compile KGTP with old Linux Kernel
+----------------------------------
+
+Most of time, KGTP can auto select right options to build with old
Linux Kernel.
+But if you want config special options with yourself, you can read following
+part.
+
+--------------------
+make AUTO=0
+--------------------
+With this option, KGTP will not auto select any build options.
+
+--------------------
+make AUTO=0 FRAME_SIMPLE=1
+--------------------
+With this option, KGTP will use simple frame instead of ring buffer.
+The simple frame doesn't support gtpframe_pipe.  Use it can make KGTP can build
+with old Kernel that doesn't support ring buffer.
+
+--------------------
+make AUTO=0 CLOCK_CYCLE=1
+--------------------
+With this option, $clock will return rdtsc value instead of local_clock.
+
+--------------------
+make AUTO=0 USE_PROC=1
+--------------------
+With this option, KGTP will use procfs instead of debugfs.
+
+The options can use together, for example:
+-----------------------------------
+make AUTO=0 FRAME_SIMPLE=1  CLOCK_CYCLE=1
+-----------------------------------
+This build command make KGTP build success with Linux Kernel 2.6.18.
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
+Use KGTP with DKMS
+------------------
+
+--------------------
+cd kgtp/
+sudo make dkms
+--------------------
+This commands will copy the files of KGTP to the directory that DKMS need.
+Then you can use DKMS commands to control KGTP.
+Please goto http://linux.dell.com/dkms/manpage.html to see how to use DKMS.
+
+
+
+
+How to get new version GDB
+--------------------------
+
+The old version GDB such as GDB 7.2 have some bugs about tracepoint that KGTP
+need.  So I suggest you update your version older than 7.2.
+If you use UBUNTU, use can get the new version from
+https://lkml.org/lkml/2011/6/4/65
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
+If you have installed KGTP in your system, you can:
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
+
+If GDB on current machine
+-------------------------
+
+---------------------------------
+sudo gdb ./vmlinux
+(gdb) target remote /sys/kernel/debug/gtp
+Remote debugging using /sys/kernel/debug/gtp
+0x0000000000000000 in ?? ()
+---------------------------------
+After that, you can begin to use GDB command trace the Linux Kernel.
+
+
+If GDB on remote machine
+------------------------
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
+After that, you can begin to use GDB command trace the Linux Kernel.
+
+
+
+How to use /sys/kernel/debug/gtpframe
+-------------------------------------
+
+This interface supplies trace frame in tfile format (GDB can parse it) when
+KGTP is stop.
+Please goto "Offline debug" to get more info about how to use it.
+
+
+
+How to use /sys/kernel/debug/gtpframe_pipe
+------------------------------------------
+
+This interface supplies same format trace frame with "gtpframe".
+But it can work when KGTP is running.  And it is a consumer like "trace_pipe".
+
+
+Get the frame info with cat
+---------------------------
+
+sudo cat /sys/kernel/debug/gtpframe_pipe > g
+Then all the trace frame will be saved in file "g".
+
+
+Get the frame info with getframe
+--------------------------------
+
+KGTP package include a program "getframe" can help you save the trace frame to
+files.
+Following part is the help of it:
+
+-------------------------------------------------------------------
+getframe -h
+Get the trace frame of KGTP and save them in current
+directory with tfile format.
+Usage: ./getframe [option]
+
+  -g n    Set the minimum free size limit to n G.
+          When free size of current disk is smaller than n G,
+          ./getframe will exit (-q) or wait some seconds (-w).
+          The default value of it is 2 G.
+
+  -q      Quit when current disk is smaller than
+          minimum free size limit (-g).
+
+  -w n    Wait n seconds when current disk is smaller
+          than minimum free size limit (-g).
+
+  -e n    Set the entry number of each tfile to n.
+          The default value of it is 1000.
+
+  -h      Display this information.
+-------------------------------------------------------------------
+
+
+Get the frame info with GDB
+---------------------------
+
+----------------------------------------------------
+#connect to the interface
+(gdb) target tfile /sys/kernel/debug/gtpframe_pipe
+#Get one trace frame entry
+(gdb) tfind 0
+Found trace frame 0, tracepoint 1
+#Get the next one
+(gdb) tfind
+Target failed to find requested trace frame.
+(gdb) tfind 0
+Found trace frame 0, tracepoint 1
+----------------------------------------------------
+This way is better to work with python to parse Kernel.
+I will introduce them in example.
+
+
+
+Add module symbols to GDB
+-------------------------
+
+Sometimes you need to add a Linux kernel module's symbols to GDB to debug it.
+Add symbols with hand is not very easy, so KGTP package include an GDB python
+script "getmod.py" and a program "getmod" can help you.
+
+
+How to use getmod.py
+--------------------
+
+Connect to KGTP before use the getmod.py.
+(gdb) source ~/kgtp/getmod.py
+Then this script will auto load the Linux kernel module's symbols to GDB.
+
+
+How to use getmod
+-----------------
+"getmod" is written by C so you can use it anywhere even if in an embedded
+environment.
+For example:
+
+--------------------------------------------------------------------------------
+#Following command save Linux Kernel module info to the file ~/tmp/mi in GDB
+#command format.
+sudo getmod >~/tmp/mi
+#in gdb part:
+(gdb) source ~/tmp/mi
+add symbol table from file
"/lib/modules/2.6.39-rc5+/kernel/fs/nls/nls_iso8859-1.ko" at
+	.text_addr = 0xf80de000
+	.note.gnu.build-id_addr = 0xf80de088
+	.exit.text_addr = 0xf80de074
+	.init.text_addr = 0xf8118000
+	.rodata.str1.1_addr = 0xf80de0ac
+	.rodata_addr = 0xf80de0c0
+	__mcount_loc_addr = 0xf80de9c0
+	.data_addr = 0xf80de9e0
+	.gnu.linkonce.this_module_addr = 0xf80dea00
+#After this GDB command, all the Linux Kernel module info is loaded into GDB.
+--------------------------------------------------------------------------------
+
+If you use remote debug or offline debug, maybe you need change the base
+directory.  Following example is for it.
+
+--------------------------------------------------------------------------------
+#/lib/modules/2.6.39-rc5+/kernel is replaced to sudo ./getmod -r
/home/teawater/kernel/b26
+sudo ./getmod -r /home/teawater/kernel/b26 >~/tmp/mi
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
+Get register info from Kernel
+-----------------------------
+
+The following is an example that records the value of all registers
+when "vfs_readdir" is called.
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
+   buf=0xc0d09f90) at readdir.c:23
+23      readdir.c: No such file or directory.
+       in readdir.c
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
+0xc01a1ac1      23      in readdir.c
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
+The following is an example that records the value of "jiffies_64" when the
+function "vfs_readdir" is called:
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
+    at readdir.c:24
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
+Like breakpoints, we can set conditions on tracepoints.  The speed of
+tracepoints is faster than breakpoints because KGTP can do all the condition
+checks.
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
+Tracepoints have special variables.  The variables can be traced directly,
+or used in tracepoint conditions.
+Note that just GDB 7.2.1 and later versions support use trace state variables
+directly, the old version of GDB  can show the value of trace state variables
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
+Trace state variable $c is created with initial value 0.
+The following action uses $c to count how many irqs happened in the kernel.
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
+Also, you can set a value of variable to trace state variable, but don't forget
+covert variable to "uint64_t".
+
+-----------------------------------------------------------------------
+>teval $c=(uint64_t)jiffies_64
+-----------------------------------------------------------------------
+
+You can get the current value of $c while the trace is running or stopped.
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
+When using tfind, you can parse the trace frame buffer.  If the value of a
+trace state variable is collected, you can parse it out.
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
+If need, the tracepoint action that access the simple trace state
variables will
+auto lock the spin lock for trace state variables.  So it can handle race
+condition about trace state variables.
+The following example is OK even if it running a machine that have more than
+one CPU.
+-------------------------------------
+teval $c=$c+1
+-------------------------------------
+
+
+Per_cpu trace state variables
+-----------------------------
+
+Per_cpu trace state variables are special simple trace state variables.
+When tracepoint action access to it, it will access to this CPU special trace
+state variables.
+
+It have 2 advantages:
+1. The tracepoint actions that access to per_cpu trace state variables don't
+have the race conditon issue.  So it don't need lock the spin lock for trace
+state variables.  It is faster than simple trace state variables on multi-core
+machine.
+2. Write the action that count some CPU special thing with it is easier than
+simple trace state variables.
+
+To define per_cpu trace state variables, you need named it in
+format:
+"per_cpu_"+string+CPU_id
+or
+"pc_"+string+CPU_id
+Following example will define a series of per_cpu trace state variables
+in a 4 COREs CPU machine with string "count":
+-------------------------------------
+tvariable $pc_count0
+tvariable $pc_count1
+tvariable $pc_count2
+tvariable $pc_count3
+-------------------------------------
+
+You can use compatibility better way to do it:
+-----------------------------------------
+set $tmp=0
+while $tmp<$cpu_number
+  eval "tvariable $pc_count%d",$tmp
+  set $tmp=$tmp+1
+end
+-----------------------------------------
+
+Tracepoint action can access anyone of a series of per_cpu trace state
+variables.  KGTP will auto access the one of CPU that it running on.
+For example:
+----------------------------------------
+trace vfs_read
+actions
+teval $pc_count0=$pc_count0+1
+end
+----------------------------------------
+These GDB commands define a tracepoint that count the times that call vfs_read
+of each CPU.
+
+
+Special trace state variables $current_task, $current_thread_info, $cpu_id,
+$dump_stack, $printk_level, $printk_format, $printk_tmp, $clock, $rdtsc,
+$hardirq_count, $softirq_count and $irq_count
+---------------------------------------------------------------------------
+
+KGTP special trace state variables $current_task, $current_thread_info,
+$cpu_id and $clock can very easy to access to some special value. You can see
+them when GDB connects to the KGTP. You can use them in tracepoint conditions
+or actions.
+Access $current_task in tracepoint condition and action will get that returns
+of get_current().
+Access $current_thread_info in tracepoint condition and action will get that
+returns of current_thread_info().
+Access $cpu_id in tracepoint condition and action will get that returns of
+smp_processor_id().
+Access $clock in tracepoint condition and action will get that returns of
+local_clock() that return the timestamp in nanoseconds.
+$rdtsc is only available on X86 and X86_64 architecture.  Access it in anytime
+will get current value of TSC with instruction RDTSC.
+Access $hardirq_count in tracepoint condition and action will get that returns
+of hardirq_count().
+Access $softirq_count in tracepoint condition and action will get that returns
+of softirq_count().
+Access $irq_count in tracepoint condition and action will get that returns
+of irq_count().
+
+And KGTP has other special trace state variables $dump_stack, $printk_level,
+$printk_format and $printk_tmp.  All of them output their values directly,
+as can be seen in "Howto let tracepoint output value directly".
+
+The following example counts in $c how many vfs_read calls that process 16663
+does and collects the struct thread_info of current task:
+
+--------------------------------------------------------------------------------
+(gdb) trace vfs_read if (((struct task_struct *)$current_task)->pid == 16663)
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
+Another example shows how much sys_read() executes in each CPU.
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
+Special trace state variable $no_self_trace
+--------------------------------------------
+
+$no_self_trace is different with the special trace state variables in the
+previous section.  It is used to control the behavior of tracepoint.
+If the action of a tracepoint include a command access to the $no_self_trace.
+The tracepoint will not trace anything if the current_task is the a KGTP self
+process (GDB, netcat, getframe or some others process that access to the
+interface of KGTP).
+For example, if we want trace vfs_read or something that have process context,
+and we don't want trace the operation of KGTP self process.  Add following
+command to the action:
+
+--------------------------------------
+collect $no_self_trace
+--------------------------------------
+
+Please note that the code that doesn't have process context (Irq handler,
+softirq) doesn't need set this variable.
+
+
+Trace the function return with $kret
+------------------------------------
+
+Sometime, set the tracepoint to the end of function is hard because the Kernel
+is compiled with optimization.  At this time, you can get help from $kret.
+
+$kret is a special trace state variable like $no_self_trace.  When you set
+value of it inside the action of tracepoint, this tracepoint be set with
+kretprobe instead of kprobe.  Then it can trace the end of this function.
+
+Following part is an example:
+
+------------------------------------------------------------------------------
+#"*(function_name)" format can make certain that GDB send the first address
+#of function to KGTP.
+trace *(vfs_read)
+action
+teval $kret=0
+#Following part you can set commands that you want.
+------------------------------------------------------------------------------
+
+
+Use $ignore_error and $last_errno to ignore the error of tstart
+---------------------------------------------------------------
+
+If KGTP got any error of tstart, this command will get fail.
+But sometime we need ignore this error and let KGTP keep work.
+For example: If you set tracepoint on the inline function spin_lock.
+This tracepoint will be set to a lot of addresses that some of them cannot
+be set kprobe.  It will make tstart get fail.  You can use "$ignore_error"
+ignore this error.
+And the last error number will available in "$last_errno".
+
+---------------------------------
+tvariable $ignore_error
+---------------------------------
+This command will open ignore.
+
+---------------------------------
+delete tvariable $ignore_error
+---------------------------------
+This command will close ignore.
+
+
+Use $cooked_clock and $cooked_rdtsc the time without KGTP used
+--------------------------------------------------------------
+
+Access these two trace state variables can get the time without KGTP used.
+Then we can get more close to really time that a part of code used even if the
+actions of tracepoint is very complex.  They will be introduce in
+Cookbook (coming soon).
+
+
+Use $xtime_sec and $xtime_nsec get the timespec
+-----------------------------------------------
+
+Access these two trace state variables will return the time of day in
+a timespec that use getnstimeofday.
+$xtime_sec will access to the second part of a timespec.
+$xtime_nsec will access to the nanosecond part of a timespec.
+
+
+
+How to use performance counters
+-------------------------------
+
+Performance counters are special hardware registers available on most modern
+CPUs. These registers count the number of certain types of hw events: such as
+instructions executed, cachemisses suffered, or branches
mis-predicted - without
+slowing down the kernel or applications. These registers can also trigger
+interrupts when a threshold number of events have passed - and can thus be
+used to profile the code that runs on that CPU.
+
+The Linux Performance Counter subsystem called perf event can get the value of
+performance counter.  You can access it through KGTP perf event trace state
+variables.
+
+Please goto read the file tools/perf/design.txt in Linux Kernel to get more
+info about perf event.
+
+
+Define a perf event trace state variable
+----------------------------------------
+
+Access an performance counter need define following trace state variable:
+-----------------------------------------------------------------------------
+"pe_cpu_"+tv_name	Define the the CPU id of the performance counter.
+"pe_type_"+tv_name	Define the the type of the performance counter.
+"pe_config_"+tv_name	Define the the config of the performance counter.
+"pe_en_"+tv_name	This the switch to enable or disable the performance
+			counter.
+			The performance counter is disable in default.
+"pe_val_"+tv_name	Access this variable can get the value of the
+			performance counter.
+-----------------------------------------------------------------------------
+
+
+Define a per_cpu perf event trace state variable
+------------------------------------------------
+
+Define a per_cpu perf event trace state variable is same with define
+"Per_cpu_trace_state_variables".
+
+------------------------------------------
+"pc_pe_"+perf_event type+string+CPU_id
+------------------------------------------
+
+Note that if you define a per_cpu perf event trace state variable, you will not
+need define the "pe_cpu_" because KGTP already get it from per_cpu id.
+
+
+The perf event type and config
+------------------------------
+
+The type of perf event can be:
+-----------------------------------------------------------
+0	PERF_TYPE_HARDWARE
+1	PERF_TYPE_SOFTWARE
+2	PERF_TYPE_TRACEPOINT
+3	PERF_TYPE_HW_CACHE
+4	PERF_TYPE_RAW
+5	PERF_TYPE_BREAKPOINT
+-----------------------------------------------------------
+
+If the type is 0(PERF_TYPE_HARDWARE), the config can be:
+-----------------------------------------------------------
+0	PERF_COUNT_HW_CPU_CYCLES
+1	PERF_COUNT_HW_INSTRUCTIONS
+2	PERF_COUNT_HW_CACHE_REFERENCES
+3	PERF_COUNT_HW_CACHE_MISSES
+4	PERF_COUNT_HW_BRANCH_INSTRUCTIONS
+5	PERF_COUNT_HW_BRANCH_MISSES
+6	PERF_COUNT_HW_BUS_CYCLES
+7	PERF_COUNT_HW_STALLED_CYCLES_FRONTEND
+8	PERF_COUNT_HW_STALLED_CYCLES_BACKEND
+-----------------------------------------------------------
+
+If the type is 3(PERF_TYPE_HW_CACHE), the config need to divide to 3 parts:
+First one is cache id, it need be << 0 before set to config:
+-----------------------------------------------------------
+0	PERF_COUNT_HW_CACHE_L1D
+1	PERF_COUNT_HW_CACHE_L1I
+2	PERF_COUNT_HW_CACHE_LL
+3	PERF_COUNT_HW_CACHE_DTLB
+4	PERF_COUNT_HW_CACHE_ITLB
+5	PERF_COUNT_HW_CACHE_BPU
+-----------------------------------------------------------
+Second one is cache op id, it need be << 8 before set to config:
+-----------------------------------------------------------
+0	PERF_COUNT_HW_CACHE_OP_READ
+1	PERF_COUNT_HW_CACHE_OP_WRITE
+2	PERF_COUNT_HW_CACHE_OP_PREFETCH
+-----------------------------------------------------------
+Last one is cache op result id, it need be << 16 before set to config:
+-----------------------------------------------------------
+0	PERF_COUNT_HW_CACHE_RESULT_ACCESS
+1	PERF_COUNT_HW_CACHE_RESULT_MISS
+-----------------------------------------------------------
+If you want get the perf count of PERF_COUNT_HW_CACHE_L1I(1),
+PERF_COUNT_HW_CACHE_OP_WRITE(1) and PERF_COUNT_HW_CACHE_RESULT_MISS(1),
+you can use:
+-----------------------------------------------------------
+tvariable $pe_config_cache=1 | (1 << 8) | (1 << 16)
+-----------------------------------------------------------
+
+tools/perf/design.txt in Linux Kernel have more info about type and config
+of perf event.
+
+
+Enable and disable all the perf event in a CPU with $pc_pe_en
+-------------------------------------------------------------
+
+I think the best way that count a part of code with performance counters is
+enable all the count in the  begin of the code and disable all of them in the
+end.  You can do it with "pe_en_".  But if you have a lot of perf event trace
+state variables.  That will make the tracepoint action very big.  $pc_pe_en is
+for this issue.
+
+You can enable all the perf event trace state variables in current CPU with
+following action:
+--------------------
+teval $pc_pe_en=1
+--------------------
+Disable them with set $pc_pe_en to 0.
+--------------------
+teval $pc_pe_en=0
+--------------------
+
+
+GDB scripts to help with set and get the perf event trace state variables
+-------------------------------------------------------------------------
+
+Following is a GDB script define two commands dpe and spe to help define and
+show the perf event trace state variables.
+You can put it to the ~/.gdbinit or your tracepoint script.  Then you can use
+this two commands in GDB directly.
+-------------------------------------------------------------------------------
+define dpe
+  if ($argc < 2)
+    printf "Usage: dpe pe_type pe_config [enable]\n"
+  end
+  if ($argc >= 2)
+    set $tmp=0
+    while $tmp<$cpu_number
+      eval "tvariable $pc_pe_type_%d%d_%d=%d",$arg0, $arg1, $tmp, $arg0
+      eval "tvariable $pc_pe_config_%d%d_%d=%d",$arg0, $arg1, $tmp, $arg1
+      eval "tvariable $pc_pe_val_%d%d_%d=0",$arg0, $arg1, $tmp
+      if ($argc >= 3)
+        eval "tvariable $pc_pe_en_%d%d_%d=%d",$arg0, $arg1, $tmp, $arg2
+      end
+      set $tmp=$tmp+1
+    end
+  end
+end
+
+document dpe
+Usage: dpe pe_type pe_config [cpu_id]
+end
+
+define spe
+  if ($argc != 2 && $argc != 3)
+    printf "Usage: spe pe_type pe_config [cpu_id]\n"
+  end
+  if ($argc == 2)
+    set $tmp=0
+    while $tmp<$cpu_number
+      eval "printf \"$pc_pe_val_%%d%%d_%%d=%%ld\\n\",$arg0, $arg1,
$tmp, $pc_pe_val_%d%d_%d", $arg0, $arg1, $tmp
+      set $tmp=$tmp+1
+    end
+  end
+  if ($argc == 3)
+    eval "printf \"$pc_pe_val_%%d%%d_%%d=%%ld\\n\",$arg0, $arg1,
$tmp, $pc_pe_val_%d%d_%d", $arg0, $arg1, $arg2
+  end
+end
+
+document spe
+Usage: spe pe_type pe_config [cpu_id]
+end
+-------------------------------------------------------------------------------
+
+Following is an example to use it get the performance counters of
function tcp_v4_rcv:
+-------------------------------------------------------------------------------
+#Connect to kgtp
+target remote /sys/kernel/debug/gtp
+#Define 3 pe tvs for PERF_COUNT_HW_CPU_CYCLES,
PERF_COUNT_HW_CACHE_MISSES and PERF_COUNT_HW_BRANCH_MISSES.
+dpe 0 0
+dpe 0 3
+dpe 0 5
+#enable the performance counters of this CPU in the begin of this function.
+trace tcp_v4_rcv
+  action
+    teval $pc_pe_en=1
+  end
+#$kret make this hanler the end of function tcp_v4_rcv.
+trace *(tcp_v4_rcv)
+  action
+    teval $kret=0
+    #disable all performance counters of this CPU
+    teval $pc_pe_en=0
+    #Access the per cpu perf event tv will access to the current cpu pe tv.
+    collect $pc_pe_val_00_0
+    collect $pc_pe_val_03_0
+    collect $pc_pe_val_05_0
+    #Set all the pe tv to 0
+    teval $pc_pe_val_00_0=0
+    teval $pc_pe_val_03_0=0
+    teval $pc_pe_val_05_0=0
+  end
+tstart
+#Wait some time that current pc receive some tcp package.
+tstop
+tfind
+spe 0 0 $cpu_id
+$pc_pe_val_00_2=12676
+spe 0 3 $cpu_id
+$pc_pe_val_03_2=7
+spe 0 5 $cpu_id
+$pc_pe_val_05_2=97
+-------------------------------------------------------------------------------
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
+Get backtrace info(stack dump) from Kernel
+------------------------------------------
+
+We can get a backtrace(stack dump) by collecting the stack.
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
+In the previous parts, you may understand that to get a value from
Linux Kernel,
+you need to use a tracepoint "collect" action to save the value to the
+tracepoint frame and use the GDB command "tfind" to parse the value from the
+frame data.
+But we want get the value directly sometimes, so KGTP supports two ways to
+output values directly.
+
+
+Output stack dump directly
+--------------------------
+KGTP has special trace state variable $dump_stack, "collect" it will let Linux
+Kernel output stack dump directly.
+Following example lets Linux Kernel show the stack dump of vfs_readdir:
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
+KGTP has special trace state variables $printk_level, $printk_format
+and $printk_tmp to support this function.
+
+$printk_level: if its value is 8 (this is the default value), "collect" action
+will save value to the tracepoint frame in the simple behavior.
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
+$printk_format, collect printk will output value in the format that is set
+by it.
+The format is:
+0	This is the default value.
+	If the size of collect value is 1, 2, 4 or 8, it will be output as an
+	unsigned decimal.
+	If not, it will be output as a hexadecimal string.
+1	Output value in signed decimal.
+2	Output value in unsigned decimal.
+3	Output value in unsigned hexadecimal.
+4	Output value as a string.
+5	Output value as a hexadecimal string.
+
+$printk_tmp, to output the value of global variable need set to it first.
+
+Following example shows a count number, pid, jiffies_64 and the file name
+that call vfs_readdir:
+
+--------------------------------------------------------------------------------
+tvariable $c
+trace vfs_readdir
+  commands
+    teval $printk_level=0
+    collect $c=$c+1
+    collect ((struct task_struct *)$current_task)->pid
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
+gtp 1:((struct task_struct *)$current_task)->pid=12085
+gtp 1:$printk_tmp=jiffies_64=4322021438
+gtp 1:file->f_path.dentry->d_iname=b26
+gtp 1:$c=$c+1=42
+gtp 1:((struct task_struct *)$current_task)->pid=12085
+gtp 1:$printk_tmp=jiffies_64=4322021438
+gtp 1:file->f_path.dentry->d_iname=b26
+--------------------------------------------------------------------------------
+
+"gtp 1" means that it was output by tracepoint 1.
+
+
+Use printf command in actions
+-----------------------------
+
+This way have a trouble is GDB is still not accept the patch that make
+tracepoint support printf, So if you want use it, you need patch the patch in
+http://sourceware.org/ml/gdb-patches/2011-03/msg00022.html and build your
+GDB yourself.
+
+Following example show the a count number, pid and the file name that call
+vfs_readdir:
+
+--------------------------------------------------------------------------------
+tvariable $c
+trace vfs_readdir
+  commands
+    printf "<0>%d pid=%d name:%s\n", $c=$c+1, ((struct task_struct
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
+Like what we use with printk in Linux Kernel, please add kernel loglevel at the
+beginning and add "\n" in the end.
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
+Do not stop tracepoint when the GDB disconnects
+---------------------------------------------------
+
+http://sourceware.org/gdb/current/onlinedocs/gdb/Starting-and-Stopping-Trace-Experiments.html
+KGTP will stop and delete the trace frame when GDB disconnects with it by
+default.
+
+----------------------------
+set disconnected-tracing on
+----------------------------
+will open the KGTP disconnect-trace. After that, when GDB disconnects with
+KGTP, KGTP will not stop trace. And after GDB reconnects to KGTP, it can keep
+control of KGTP like nothing happened.
+
+
+
+Howto show a variable whose value has been optimized away
+---------------------------------------------------------
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
+patch co.patch include in the source of KGTP or goto
+http://code.google.com/p/kgtp/downloads/detail?name=co.patch to get it.  It add
+a option in "Kernel hacking" called "Compile with almost no optimization". It
+will make kernel be built without -O2. It support x86_32, x86_64 and arm.
+
+Update your GCC
+---------------
+The VTA branch (http://gcc.gnu.org/wiki/Var_Tracking_Assignments) was merged
+for GCC 4.5.  This helps a lot with generating dwarf for previously
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
+want to debug.
+
+
+In the debugged machine after insmod the gtp.ko:
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
+If you want to save the value to the trace frame and parse later, you can use
+file "/sys/kernel/debug/gtpframe" that has the trace frame. Copy it to the PC
+that has GDB.
+Please note that some "cp" cannot handle it very well, please use
+"cat /sys/kernel/debug/gtpframe > ./gtpframe" to copy it.
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
+    at readdir.c:24
+24      {
+--------------------------------------------------------------------------------
--- /dev/null
+++ b/Documentation/trace/gtp_quickstart.txt
@@ -0,0 +1,250 @@
+		Linux Kernel GDB tracepoint module (KGTP) quick start
+		=====================================================
+		By Hui Zhu <teawater@gmail.com>
+		https://code.google.com/p/kgtp/wiki/Quickstart
+		2011-09-12
+
+Table of contents
+-----------------
+Ubuntu
+Fedora
+
+
+
+
+Ubuntu
+------
+
+Install GDB for KGTP
+--------------------
+
+This GDB's filename is different with the current GDB that you are using.
+So please don't worry that it affect current GDB that your are using.
+
+For the Ubuntu 10.04 or later, running the following line at a terminal:
+sudo add-apt-repository ppa:teawater/gdb-$(lsb_release -rs)
+sudo apt-get update
+sudo apt-get install gdb-release
+
+For the Ubuntu older than 10.04, please go to https://code.google.com/p/gdbt/
+get howto install GDB for KGTP from source.
+
+
+
+Install Linux kernel packages that KGTP need
+--------------------------------------------
+
+Please ignore this section if the Linux kernel of your system is built by
+yourself.
+
+Install the Linux kernel debug image
+------------------------------------
+
+Add debug source to the sources list of Ubuntu
+----------------------------------------------
+
+Create an /etc/apt/sources.list.d/ddebs.list by running the following line at
+a terminal:
+echo "deb http://ddebs.ubuntu.com $(lsb_release -cs) main restricted
universe multiverse" | \
+sudo tee -a /etc/apt/sources.list.d/ddebs.list
+
+Stable releases (not alphas and betas) require three more lines adding to the
+same file, which is done by the following terminal command:
+echo "deb http://ddebs.ubuntu.com $(lsb_release -cs)-updates main
restricted universe multiverse
+deb http://ddebs.ubuntu.com $(lsb_release -cs)-security main
restricted universe multiverse
+deb http://ddebs.ubuntu.com $(lsb_release -cs)-proposed main
restricted universe multiverse" | \
+sudo tee -a /etc/apt/sources.list.d/ddebs.list
+
+Import the debug symbol archive signing key:
+sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 428D7C01
+
+Then run:
+sudo apt-get update
+
+Get Linux kernel debug image
+----------------------------
+sudo apt-get install linux-image-$(uname -r)-dbgsym
+
+
+Install the Linux kernel headers
+--------------------------------
+
+Please ignore this section if the Linux kernel of your system is built by
+yourself.
+sudo apt-get install linux-headers-generic
+
+
+Install the Linux kernel source
+-------------------------------
+
+Install the source package:
+sudo apt-get install linux-source
+
+Uncompress the source package:
+sudo mkdir -p /build/buildd/
+sudo tar vxjf /usr/src/linux-source-$(uname -r | sed
's/-.*//').tar.bz2 -C /build/buildd/
+sudo mv /build/buildd/linux-source-$(uname -r | sed 's/-.*//')
/build/buildd/linux-$(uname -r | sed 's/-.*//')
+
+
+
+Install GCC
+-----------
+
+sudo apt-get install gcc
+
+
+
+Get and build KGTP
+------------------
+
+Install subversion:
+sudo apt-get install subversion
+
+Get the source of KGTP with subversion and put it to directory "kgtp":
+svn checkout https://kgtp.googlecode.com/svn/trunk kgtp
+
+Build KGTP:
+cd kgtp
+make
+
+
+
+Use KGTP
+--------
+
+Mount the sysfs and debugfs:
+sudo mount -t sysfs none /sys/
+sudo mount -t debugfs none /sys/kernel/debug/
+
+Insert the KGTP module to the current Linux Kernel:
+cd kgtp
+sudo insmod gtp.ko
+
+Use GDB connect to KGTP:
+sudo gdb-release /usr/lib/debug/boot/vmlinux-$(uname -r)
+(gdb) target remote /sys/kernel/debug/gtp
+
+Do a very simple trace:
+(gdb) trace vfs_readdir
+Tracepoint 1 at 0xc02289f0: file
/build/buildd/linux-2.6.35/fs/readdir.c, line 23.
+(gdb) actions
+Enter actions for tracepoint 1, one per line.
+End with a line saying just "end".
+>collect $reg
+>end
+(gdb) tstart
+(gdb) shell ls
+vmlinux-2.6.35-30-generic
+(gdb) tstop
+(gdb) tfind
+Found trace frame 0, tracepoint 1
+#0  vfs_readdir (file=0x0, filler=0x163d8ae3, buf=0x18c0) at
/build/buildd/linux-2.6.35/fs/readdir.c:23
+23      {
+
+
+
+End
+---
+
+Now, you can begin to rock and roll your Linux kernel with KGTP and GDB.
+Please go to see gtp.txt to get more message about howto use KGTP.
+
+
+
+
+Fedora
+------
+
+Install GDB for KGTP
+--------------------
+
+Please go to https://code.google.com/p/gdbt/ get howto install GDB for KGTP
+from source.
+
+
+
+Install Linux kernel packages that KGTP need
+--------------------------------------------
+
+Please ignore this section if the Linux kernel of your system is built
+by yourself.
+
+
+Install the Linux kernel debug image
+------------------------------------
+
+sudo yum --enablerepo=fedora-debuginfo install kernel-debuginfo
+
+
+Install the Linux kernel devel package
+--------------------------------------
+
+sudo yum install kernel-devel-$(uname -r)
+
+
+
+Install GCC
+-----------
+
+sudo yum install gcc
+
+
+
+Get and build KGTP
+------------------
+
+Install subversion:
+sudo yum install subversion
+
+Get the source of KGTP with subversion and put it to directory "kgtp":
+svn checkout https://kgtp.googlecode.com/svn/trunk kgtp
+
+Build KGTP:
+cd kgtp
+make
+
+
+
+Use KGTP
+--------
+
+Mount the sysfs and debug fs:
+sudo mount -t sysfs none /sys/
+sudo mount -t debugfs none /sys/kernel/debug/
+
+Insert the KGTP module to the current Linux Kernel:
+cd kgtp
+sudo insmod gtp.ko
+
+Use GDB connect to KGTP:
+sudo gdb-release /usr/lib/debug/lib/modules/$(uname -r)/vmlinux
+(gdb) target remote /sys/kernel/debug/gtp
+
+Do a very simple trace:
+(gdb) trace vfs_readdir
+Tracepoint 1 at 0xffffffff8110ec9b: file fs/readdir.c, line 23.
+(gdb) actions
+Enter actions for tracepoint 1, one per line.
+End with a line saying just "end".
+>collect $reg
+>end
+(gdb) tstart
+(gdb) shell ls
+co.patch                  getframe      getmod.c   gtp.mod.c  gtp.txt
        perf_event.c
+dkms.conf                 getframe.c    getmod.py  gtp.mod.o
Makefile        ring_buffer.c
+dkms_others_install.sh    getgtprsp.pl  gtp.c      gtp.o
modules.order   ring_buffer.h
+dkms_others_uninstall.sh  getmod        gtp.ko     gtp.patch  Module.symvers
+(gdb) tstop
+(gdb) tfind
+Found trace frame 0, tracepoint 1
+#0  vfs_readdir (file=0xffff880019d3df00, filler=0xffffffff8110eb16
<filldir>, buf=0xffff880003b39f38)
+    at fs/readdir.c:23
+23      {
+
+
+
+End
+---
+
+Now, you can begin to rock and roll your Linux kernel with KGTP and GDB.
+Please go to HOWTO to get more message about howto use KGTP.
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
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1134,9 +1134,12 @@ extern void perf_output_copy(struct perf
 			     const void *buf, unsigned int len);
 extern int perf_swevent_get_recursion_context(void);
 extern void perf_swevent_put_recursion_context(int rctx);
+extern int __perf_event_enable(void *info);
+extern int __perf_event_disable(void *info);
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 extern void perf_event_task_tick(void);
+extern void perf_event_set(struct perf_event *event, u64 val);
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *task)			{ }
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1187,7 +1187,7 @@ retry:
 /*
  * Cross CPU call to disable a performance event
  */
-static int __perf_event_disable(void *info)
+int __perf_event_disable(void *info)
 {
 	struct perf_event *event = info;
 	struct perf_event_context *ctx = event->ctx;
@@ -1224,6 +1224,7 @@ static int __perf_event_disable(void *in

 	return 0;
 }
+EXPORT_SYMBOL_GPL(__perf_event_disable);

 /*
  * Disable a event.
@@ -1279,6 +1280,7 @@ retry:
 	}
 	raw_spin_unlock_irq(&ctx->lock);
 }
+EXPORT_SYMBOL_GPL(perf_event_disable);

 static void perf_set_shadow_time(struct perf_event *event,
 				 struct perf_event_context *ctx,
@@ -1633,7 +1635,7 @@ static void __perf_event_mark_enabled(st
 /*
  * Cross CPU call to enable a performance event
  */
-static int __perf_event_enable(void *info)
+int __perf_event_enable(void *info)
 {
 	struct perf_event *event = info;
 	struct perf_event_context *ctx = event->ctx;
@@ -1697,6 +1699,7 @@ unlock:

 	return 0;
 }
+EXPORT_SYMBOL_GPL(__perf_event_enable);

 /*
  * Enable a event.
@@ -1763,6 +1766,7 @@ retry:
 out:
 	raw_spin_unlock_irq(&ctx->lock);
 }
+EXPORT_SYMBOL_GPL(perf_event_enable);

 int perf_event_refresh(struct perf_event *event, int refresh)
 {
@@ -3164,6 +3168,14 @@ static void perf_event_reset(struct perf
 	perf_event_update_userpage(event);
 }

+void perf_event_set(struct perf_event *event, u64 val)
+{
+	(void)perf_event_read(event);
+	local64_set(&event->count, val);
+	perf_event_update_userpage(event);
+}
+EXPORT_SYMBOL_GPL(perf_event_set);
+
 /*
  * Holding the top-level event's child_mutex means that any
  * descendant process that has inherited this event will block
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1256,6 +1256,17 @@ config ASYNC_RAID6_TEST

 	  If unsure, say N.

+config GTP
+	tristate "GDB tracepoint support"
+	depends on X86 || ARM || MIPS
+	depends on KPROBES
+	depends on DEBUG_FS
+	select RING_BUFFER
+	---help---
+	  Supply GDB tracepoint interface in /sys/kernel/debug/gtp.
+	  See Documentation/trace/gtp.txt or
+	  https://code.google.com/p/kgtp/wiki/HOWTO for more info.
+
 source "samples/Kconfig"

 source "lib/Kconfig.kgdb"
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -117,6 +117,8 @@ obj-$(CONFIG_CORDIC) += cordic.o

 obj-$(CONFIG_LLIST) += llist.o

+obj-$(CONFIG_GTP) += gtp.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h

--- /dev/null
+++ b/lib/gtp.c
@@ -0,0 +1,7323 @@
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
+#include <linux/interrupt.h>
+#include <linux/debugfs.h>
+#include <linux/slab.h>
+#include <linux/ring_buffer.h>
+#include <asm/gtp.h>
+
+/* If define GTP_FRAME_SIMPLE, KGTP will use simple frame allocer replace
+   ring buffer.  */
+/* #define GTP_FRAME_SIMPLE */
+
+/* If define GTP_CLOCK_CYCLE, $clock will return rdtscll.  */
+/* #define GTP_CLOCK_CYCLE */
+
+#ifdef GTP_FRAME_SIMPLE
+/* This define is for simple frame alloc record, then we can get how many
+   memory are weste by FRAME_ALIGN. */
+/* #define FRAME_ALLOC_RECORD */
+#endif
+
+#define KERN_NULL
+
+#ifdef GTPDEBUG
+#define GTP_DEBUG		KERN_WARNING
+#endif
+
+#define GTP_RW_MAX		16384
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
+/* GTP_FRAME_SIZE must align with FRAME_ALIGN_SIZE if use GTP_FRAME_SIMPLE.  */
+#define GTP_FRAME_SIZE		5242880
+#ifdef GTP_FRAME_SIMPLE
+#define FRAME_ALIGN_SIZE	sizeof(unsigned int)
+#define FRAME_ALIGN(x)		((x + FRAME_ALIGN_SIZE - 1) \
+				 & (~(FRAME_ALIGN_SIZE - 1)))
+#define GTP_FRAME_HEAD_SIZE	(FID_SIZE + sizeof(char *) + sizeof(ULONGEST))
+#define GTP_FRAME_REG_SIZE	(FID_SIZE + sizeof(char *) \
+				 + sizeof(struct pt_regs))
+#define GTP_FRAME_MEM_SIZE	(FID_SIZE + sizeof(char *) \
+				 + sizeof(struct gtp_frame_mem))
+#define GTP_FRAME_VAR_SIZE	(FID_SIZE + sizeof(char *) \
+				 + sizeof(struct gtp_frame_var))
+#else
+#define GTP_FRAME_HEAD_SIZE	(FID_SIZE + sizeof(ULONGEST))
+#define GTP_FRAME_REG_SIZE	(FID_SIZE + sizeof(struct pt_regs))
+#define GTP_FRAME_MEM_SIZE	(FID_SIZE + sizeof(struct gtp_frame_mem))
+#define GTP_FRAME_VAR_SIZE	(FID_SIZE + sizeof(struct gtp_frame_var))
+#endif
+#include <linux/perf_event.h>
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
+	int			kpreg;
+	int			no_self_trace;
+	int			nopass;
+	int			have_printk;
+	ULONGEST		num;
+	struct action		*cond;
+	struct action		*action_list;
+	atomic_t		current_pass;
+	struct gtpsrc		*printk_str;
+	enum gtp_stop_type	reason;
+	struct tasklet_struct	tasklet;
+	struct work_struct	work;
+	struct gtp_entry	*next;
+	struct kretprobe	kp;
+	int			disable;
+	int			is_kretprobe;
+	ULONGEST		addr;
+	ULONGEST		pass;
+	struct gtpsrc		*src;
+	ULONGEST		step;
+};
+
+#ifdef CONFIG_PERF_EVENTS
+struct pe_tv_s	{
+	struct pe_tv_s		*pc_next;
+	int			en;
+	struct perf_event	*event;
+	int			cpu;
+	u64			val;
+	u64			enabled;	/* The perf inside timer */
+	u64			running;	/* The perf inside timer */
+	char			*name;
+	struct perf_event_attr	attr;
+};
+#endif
+
+enum pe_tv_id {
+	pe_tv_unknown = 0,
+	pe_tv_cpu,
+	pe_tv_type,
+	pe_tv_config,
+	pe_tv_en,
+	pe_tv_val,
+	pe_tv_enabled,
+	pe_tv_running,
+};
+
+struct gtp_var {
+	struct gtp_var	*next;
+	unsigned int	num;
+	uint64_t	val;
+	char		*src;
+	struct gtp_var	**per_cpu;
+#ifdef CONFIG_PERF_EVENTS
+	enum pe_tv_id	ptid;
+	struct pe_tv_s	*pts;
+#endif
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
+static pid_t			gtp_gtp_pid;
+static unsigned int		gtp_gtp_pid_count;
+static pid_t			gtp_gtpframe_pid;
+static unsigned int		gtp_gtpframe_pid_count;
+#ifndef GTP_FRAME_SIMPLE
+static pid_t			gtp_gtpframe_pipe_pid;
+static unsigned int		gtp_gtpframe_pipe_pid_count;
+#endif
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
+static int			gtp_cpu_number;
+
+static DEFINE_SPINLOCK(gtp_var_lock);
+static struct gtp_var		*gtp_var_list;
+static unsigned int		gtp_var_head;
+static unsigned int		gtp_var_tail;
+static struct gtp_var		**gtp_var_array;
+static struct gtp_var		*current_gtp_var;
+
+enum {
+	GTP_VAR_SPECIAL_MIN = 1,
+	GTP_VAR_CURRENT_TASK_ID = GTP_VAR_SPECIAL_MIN,
+	GTP_VAR_CURRENT_THREAD_INFO_ID,
+	GTP_VAR_CLOCK_ID,
+	GTP_VAR_COOKED_CLOCK_ID,
+#ifdef CONFIG_X86
+	GTP_VAR_RDTSC_ID,
+	GTP_VAR_COOKED_RDTSC_ID,
+#endif
+	GTP_VAR_CPU_ID,
+	GTP_VAR_PRINTK_TMP_ID,
+	GTP_VAR_PRINTK_LEVEL_ID,
+	GTP_VAR_PRINTK_FORMAT_ID,
+	GTP_VAR_DUMP_STACK_ID,
+	GTP_VAR_NO_SELF_TRACE_ID,
+	GTP_VAR_CPU_NUMBER_ID,
+	GTP_VAR_PC_PE_EN_ID,
+	GTP_VAR_KRET_ID,
+	GTP_VAR_XTIME_SEC_ID,
+	GTP_VAR_XTIME_NSEC_ID,
+	GTP_VAR_LAST_ERRNO_ID,
+	GTP_VAR_HARDIRQ_COUNT_ID,
+	GTP_VAR_SOFTIRQ_COUNT_ID,
+	GTP_VAR_IRQ_COUNT_ID,
+	GTP_VAR_SPECIAL_MAX = GTP_VAR_IRQ_COUNT_ID,
+};
+#define PREV_VAR	NULL
+static struct gtp_var		gtp_var_current_task = {
+	.next		= PREV_VAR,
+	.num		= GTP_VAR_CURRENT_TASK_ID,
+	.src		= "0:1:63757272656e745f7461736b",
+	.per_cpu	= NULL,
+};
+#undef PREV_VAR
+#define PREV_VAR	(&gtp_var_current_task)
+static struct gtp_var		gtp_var_current_thread_info = {
+	.next		= PREV_VAR,
+	.num		= GTP_VAR_CURRENT_THREAD_INFO_ID,
+	.src		= "0:1:63757272656e745f7468726561645f696e666f",
+	.per_cpu	= NULL,
+};
+#undef PREV_VAR
+#define PREV_VAR	(&gtp_var_current_thread_info)
+static struct gtp_var		gtp_var_clock = {
+	.next		= PREV_VAR,
+	.num		= GTP_VAR_CLOCK_ID,
+	.src		= "0:1:636c6f636b",
+	.per_cpu	= NULL,
+};
+#undef PREV_VAR
+#define PREV_VAR	(&gtp_var_clock)
+static struct gtp_var		gtp_var_cooked_clock = {
+	.next		= PREV_VAR,
+	.num		= GTP_VAR_COOKED_CLOCK_ID,
+	.src		= "0:1:636f6f6b65645f636c6f636b",
+	.per_cpu	= NULL,
+};
+#undef PREV_VAR
+#define PREV_VAR	(&gtp_var_cooked_clock)
+#ifdef CONFIG_X86
+static struct gtp_var		gtp_var_rdtsc = {
+	.next		= PREV_VAR,
+	.num		= GTP_VAR_RDTSC_ID,
+	.src		= "0:1:7264747363",
+	.per_cpu	= NULL,
+};
+#undef PREV_VAR
+#define PREV_VAR	(&gtp_var_rdtsc)
+static struct gtp_var		gtp_var_cooked_rdtsc = {
+	.next		= PREV_VAR,
+	.num		= GTP_VAR_COOKED_RDTSC_ID,
+	.src		= "0:1:636f6f6b65645f7264747363",
+	.per_cpu	= NULL,
+};
+#undef PREV_VAR
+#define PREV_VAR	(&gtp_var_cooked_rdtsc)
+#endif
+static struct gtp_var		gtp_var_cpu_id = {
+	.next		= PREV_VAR,
+	.num		= GTP_VAR_CPU_ID,
+	.src		= "0:1:6370755f6964",
+	.per_cpu	= NULL,
+};
+#undef PREV_VAR
+#define PREV_VAR	(&gtp_var_cpu_id)
+static struct gtp_var		gtp_var_printk_tmp = {
+	.next		= PREV_VAR,
+	.num		= GTP_VAR_PRINTK_TMP_ID,
+	.src		= "0:1:7072696e746b5f746d70",
+	.per_cpu	= NULL,
+};
+#undef PREV_VAR
+#define PREV_VAR	(&gtp_var_printk_tmp)
+static struct gtp_var		gtp_var_printk_level = {
+	.next		= PREV_VAR,
+	.num		= GTP_VAR_PRINTK_LEVEL_ID,
+	.src		= "8:1:7072696e746b5f6c6576656c",
+	.per_cpu	= NULL,
+};
+#undef PREV_VAR
+#define PREV_VAR	(&gtp_var_printk_level)
+static struct gtp_var		gtp_var_printk_format = {
+	.next		= PREV_VAR,
+	.num		= GTP_VAR_PRINTK_FORMAT_ID,
+	.src		= "0:1:7072696e746b5f666f726d6174",
+	.per_cpu	= NULL,
+};
+#undef PREV_VAR
+#define PREV_VAR	(&gtp_var_printk_format)
+static struct gtp_var		gtp_var_dump_stack = {
+	.next		= PREV_VAR,
+	.num		= GTP_VAR_DUMP_STACK_ID,
+	.src		= "0:1:64756d705f737461636b",
+	.per_cpu	= NULL,
+};
+#undef PREV_VAR
+#define PREV_VAR	(&gtp_var_dump_stack)
+static struct gtp_var		gtp_var_no_self_trace = {
+	.next		= PREV_VAR,
+	.num		= GTP_VAR_NO_SELF_TRACE_ID,
+	.src		= "0:1:6e6f5f73656c665f7472616365",
+	.per_cpu	= NULL,
+};
+#undef PREV_VAR
+#define PREV_VAR	(&gtp_var_no_self_trace)
+static struct gtp_var		gtp_var_cpu_number = {
+	.next		= PREV_VAR,
+	.num		= GTP_VAR_CPU_NUMBER_ID,
+	.src		= "0:1:6370755f6e756d626572",
+	.per_cpu	= NULL,
+};
+#undef PREV_VAR
+#define PREV_VAR	(&gtp_var_cpu_number)
+static struct gtp_var		gtp_var_pc_pe_en = {
+	.next		= PREV_VAR,
+	.num		= GTP_VAR_PC_PE_EN_ID,
+	.src		= "0:1:70635f70655f656e",
+	.per_cpu	= NULL,
+};
+#undef PREV_VAR
+#define PREV_VAR	(&gtp_var_pc_pe_en)
+static struct gtp_var		gtp_var_kret = {
+	.next		= PREV_VAR,
+	.num		= GTP_VAR_KRET_ID,
+	.src		= "0:1:6b726574",
+	.per_cpu	= NULL,
+};
+#undef PREV_VAR
+#define PREV_VAR	(&gtp_var_kret)
+static struct gtp_var		gtp_var_xtime_sec = {
+	.next		= PREV_VAR,
+	.num		= GTP_VAR_XTIME_SEC_ID,
+	.src		= "0:1:7874696d655f736563",
+	.per_cpu	= NULL,
+};
+#undef PREV_VAR
+#define PREV_VAR	(&gtp_var_xtime_sec)
+static struct gtp_var		gtp_var_xtime_nsec = {
+	.next		= PREV_VAR,
+	.num		= GTP_VAR_XTIME_NSEC_ID,
+	.src		= "0:1:7874696d655f6e736563",
+	.per_cpu	= NULL,
+};
+#undef PREV_VAR
+#define PREV_VAR	(&gtp_var_xtime_nsec)
+static struct gtp_var		gtp_var_last_errno = {
+	.next		= PREV_VAR,
+	.num		= GTP_VAR_LAST_ERRNO_ID,
+	.src		= "0:1:6c6173745f6572726e6f",
+	.per_cpu	= NULL,
+};
+#undef PREV_VAR
+#define PREV_VAR	(&gtp_var_last_errno)
+static struct gtp_var		gtp_var_hardirq_count = {
+	.next		= PREV_VAR,
+	.num		= GTP_VAR_HARDIRQ_COUNT_ID,
+	.src		= "0:1:686172646972715f636f756e74",
+	.per_cpu	= NULL,
+};
+#undef PREV_VAR
+#define PREV_VAR	(&gtp_var_hardirq_count)
+static struct gtp_var		gtp_var_softirq_count = {
+	.next		= PREV_VAR,
+	.num		= GTP_VAR_SOFTIRQ_COUNT_ID,
+	.src		= "0:1:736f66746972715f636f756e74",
+	.per_cpu	= NULL,
+};
+#undef PREV_VAR
+#define PREV_VAR	(&gtp_var_softirq_count)
+static struct gtp_var		gtp_var_irq_count = {
+	.next		= PREV_VAR,
+	.num		= GTP_VAR_IRQ_COUNT_ID,
+	.src		= "0:1:6972715f636f756e74",
+	.per_cpu	= NULL,
+};
+#undef PREV_VAR
+#define GTP_VAR_LIST_FIRST		(&gtp_var_irq_count)
+
+#define GTP_VAR_IS_SPECIAL(x)		((x) >= GTP_VAR_SPECIAL_MIN \
+					 && (x) <= GTP_VAR_SPECIAL_MAX)
+#define GTP_VAR_NOT_GETV(x)		((x) == GTP_VAR_PRINTK_LEVEL_ID \
+					 || (x) == GTP_VAR_PRINTK_FORMAT_ID \
+					 || (x) == GTP_VAR_PC_PE_EN_ID \
+					 || (x) == GTP_VAR_KRET_ID)
+#define GTP_VAR_NOT_SETV(x)		(((x) >= GTP_VAR_CURRENT_TASK_ID \
+					  && (x) <= GTP_VAR_CPU_ID) \
+					 || (x) == GTP_VAR_DUMP_STACK_ID \
+					 || (x) == GTP_VAR_CPU_NUMBER_ID \
+					 || (x) == GTP_VAR_KRET_ID)
+#define GTP_VAR_NOT_TRACEV(x)		(((x) >= GTP_VAR_PRINTK_LEVEL_ID \
+					 && (x) <= GTP_VAR_PRINTK_FORMAT_ID) \
+					 || (x) == GTP_VAR_PC_PE_EN_ID \
+					 || (x) == GTP_VAR_KRET_ID)
+#define GTP_VAR_AUTO_TRACEV(x)		((x) == GTP_VAR_CLOCK_ID \
+					 || (x) == GTP_VAR_CPU_ID)
+
+static int			gtp_frame_current_num;
+static ULONGEST			gtp_frame_current_tpe;
+static atomic_t			gtp_frame_create;
+static char			*gtp_frame_file;
+static size_t			gtp_frame_file_size;
+static DECLARE_WAIT_QUEUE_HEAD(gtpframe_wq);
+#ifdef GTP_FRAME_SIMPLE
+static DEFINE_SPINLOCK(gtp_frame_lock);
+static char			*gtp_frame;
+static char			*gtp_frame_r_start;
+static char			*gtp_frame_w_start;
+static char			*gtp_frame_end;
+static int			gtp_frame_is_circular;
+static char			*gtp_frame_current;
+#else
+static struct ring_buffer	*gtp_frame;
+static struct ring_buffer_iter	*gtp_frame_iter[NR_CPUS];
+static int			gtp_frame_current_cpu;
+static u64			gtp_frame_current_clock;
+
+static DECLARE_WAIT_QUEUE_HEAD(gtpframe_pipe_wq);
+static atomic_t			gtpframe_pipe_wq_v;
+static struct tasklet_struct	gtpframe_pipe_wq_tasklet;
+#endif
+
+static struct gtpro_entry	*gtpro_list;
+
+#define GTP_PRINTF_MAX		256
+static DEFINE_PER_CPU(char[GTP_PRINTF_MAX], gtp_printf);
+
+static DEFINE_PER_CPU(u64, rdtsc_current);
+static DEFINE_PER_CPU(u64, local_clock_current);
+static DEFINE_PER_CPU(u64, rdtsc_offset);
+static DEFINE_PER_CPU(u64, local_clock_offset);
+
+#define GTP_LOCAL_CLOCK	local_clock()
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
+#ifdef CONFIG_PERF_EVENTS
+static DEFINE_PER_CPU(int, pc_pe_list_all_disabled);
+static DEFINE_PER_CPU(struct pe_tv_s *, pc_pe_list);
+
+static void
+pc_pe_list_disable(void)
+{
+	struct pe_tv_s *ppl;
+
+	if (__get_cpu_var(pc_pe_list_all_disabled))
+		return;
+
+	for (ppl = __get_cpu_var(pc_pe_list); ppl; ppl = ppl->pc_next) {
+		if (ppl->en)
+			__perf_event_disable(ppl->event);
+	}
+}
+
+static void
+pc_pe_list_enable(void)
+{
+	struct pe_tv_s *ppl;
+
+	if (__get_cpu_var(pc_pe_list_all_disabled))
+		return;
+
+	for (ppl = __get_cpu_var(pc_pe_list); ppl; ppl = ppl->pc_next) {
+		if (ppl->en)
+			__perf_event_enable(ppl->event);
+	}
+}
+
+static void
+gtp_pc_pe_en(int enable)
+{
+	struct pe_tv_s *ppl = __get_cpu_var(pc_pe_list);
+
+	for (ppl = __get_cpu_var(pc_pe_list); ppl; ppl = ppl->pc_next)
+		ppl->en = enable;
+
+	__get_cpu_var(pc_pe_list_all_disabled) = !enable;
+}
+
+static void
+gtp_pe_set_en(struct pe_tv_s *pts, int enable)
+{
+	if (pts->event->cpu != smp_processor_id()) {
+		if (enable)
+			perf_event_enable(pts->event);
+		else
+			perf_event_disable(pts->event);
+	}
+	pts->en = enable;
+}
+#else
+static void
+gtp_pc_pe_en(int enable)
+{
+}
+#endif	/* CONFIG_PERF_EVENTS */
+
+#ifdef GTP_FRAME_SIMPLE
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
+		frame = gtp_frame_end;
+		break;
+	default:
+		return NULL;
+		break;
+	}
+
+	return frame;
+}
+#endif
+
+#ifdef GTP_FRAME_SIMPLE
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
+			if (tmp == gtp_frame_end)
+				gtp_frame_r_start = gtp_frame;
+			else
+				gtp_frame_r_start = tmp;
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
+#endif
+
+struct gtp_trace_s {
+	struct gtp_entry		*tpe;
+	struct pt_regs			*regs;
+#ifdef GTP_FRAME_SIMPLE
+	char				**next;
+#else
+	char				*next;
+#endif
+	struct kretprobe_instance	*ri;
+	int				*run;
+	struct timespec			xtime;
+	ULONGEST			printk_tmp;
+	unsigned int			printk_level;
+	unsigned int			printk_format;
+	struct gtpsrc			*printk_str;
+};
+
+#define GTP_PRINTK_FORMAT_A	0
+#define GTP_PRINTK_FORMAT_D	1
+#define GTP_PRINTK_FORMAT_U	2
+#define GTP_PRINTK_FORMAT_X	3
+#define GTP_PRINTK_FORMAT_S	4
+#define GTP_PRINTK_FORMAT_B	5
+
+#ifndef GTP_FRAME_SIMPLE
+#define GTP_FRAME_RINGBUFFER_ALLOC(size)				\
+	do {								\
+		rbe = ring_buffer_lock_reserve(gtp_frame, size);	\
+		if (rbe == NULL) {					\
+			gts->tpe->reason = gtp_stop_frame_full;		\
+			return -1;					\
+		}							\
+		tmp = ring_buffer_event_data(rbe);			\
+	} while (0)
+#endif
+
+static struct gtp_var	*gtp_gtp_var_array_find(unsigned int num);
+static int		gtp_collect_var(struct gtp_trace_s *gts,
+					struct gtp_var *tve);
+
+static int
+gtp_action_head(struct gtp_trace_s *gts)
+{
+	char				*tmp;
+	ULONGEST			*trace_nump;
+#ifndef GTP_FRAME_SIMPLE
+	struct ring_buffer_event	*rbe;
+#endif
+
+	/* Get the head.  */
+#ifdef GTP_FRAME_SIMPLE
+	tmp = gtp_frame_alloc(GTP_FRAME_HEAD_SIZE);
+	if (!tmp) {
+		gts->tpe->reason = gtp_stop_frame_full;
+		return -1;
+	}
+#else
+	GTP_FRAME_RINGBUFFER_ALLOC(GTP_FRAME_HEAD_SIZE);
+#endif
+
+	FID(tmp) = FID_HEAD;
+	tmp += FID_SIZE;
+
+#ifdef GTP_FRAME_SIMPLE
+	gts->next = (char **)tmp;
+	*(gts->next) = NULL;
+	tmp += sizeof(char *);
+#endif
+
+	trace_nump = (ULONGEST *)tmp;
+	*trace_nump = gts->tpe->num;
+
+#ifndef GTP_FRAME_SIMPLE
+	ring_buffer_unlock_commit(gtp_frame, rbe);
+	gts->next = (char *)1;
+#endif
+
+#ifdef GTP_FRAME_SIMPLE
+	/* Trace $cpu_id and $clock.  */
+	{
+		struct gtp_var	*tve;
+
+		tve = gtp_gtp_var_array_find(GTP_VAR_CLOCK_ID);
+		if (!tve) {
+			gts->tpe->reason = gtp_stop_agent_expr_code_error;
+			return -1;
+		}
+		if (gtp_collect_var(gts, tve))
+			return -1;
+		tve = gtp_gtp_var_array_find(GTP_VAR_CPU_ID);
+		if (!tve) {
+			gts->tpe->reason = gtp_stop_agent_expr_code_error;
+			return -1;
+		}
+		if (gtp_collect_var(gts, tve))
+			return -1;
+	}
+#endif
+
+	return 0;
+}
+
+static int
+gtp_action_printk(struct gtp_trace_s *gts, ULONGEST addr, size_t size)
+{
+	unsigned int	printk_format = gts->printk_format;
+	char		*pbuf = __get_cpu_var(gtp_printf);
+
+	if (gts->printk_str == NULL) {
+		gts->tpe->reason = gtp_stop_agent_expr_code_error;
+		printk(KERN_WARNING "gtp_action_printk: id:%d addr:%p "
+				    "printk doesn't have var name.  Please "
+				    "check actions of it.\n",
+			(int)gts->tpe->num, (void *)(CORE_ADDR)gts->tpe->addr);
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
+			printk(KERN_WARNING "gtp_action_printk: id:%d addr:%p "
+					    "read %p %u get error.\n",
+			       (int)gts->tpe->num,
+			       (void *)(CORE_ADDR)gts->tpe->addr,
+			       (void *)(CORE_ADDR)addr,
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
+			printk(KERN_WARNING "gtp_action_printk: id:%d addr:%p "
+					    "size %d cannot printk.\n",
+			       (int)gts->tpe->num,
+			       (void *)(CORE_ADDR)gts->tpe->addr,
+			       (unsigned int)size);
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
+			printk(KERN_WARNING "gtp_action_printk: id:%d addr:%p"
+					    "size %d cannot printk.\n",
+			       (int)gts->tpe->num,
+			       (void *)(CORE_ADDR)gts->tpe->addr,
+			       (unsigned int)size);
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
+			printk(KERN_WARNING "gtp_action_printk: id:%d addr:%p "
+					    "size %d cannot printk.\n",
+			       (int)gts->tpe->num,
+			       (void *)(CORE_ADDR)gts->tpe->addr,
+			       (unsigned int)size);
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
+		printk(KERN_WARNING "gtp_action_printk: id:%d addr:%p "
+				    "printk format %u is not support.\n",
+		       (int)gts->tpe->num, (void *)(CORE_ADDR)gts->tpe->addr,
+		       gts->printk_format);
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
+	char				*tmp;
+	struct gtp_frame_mem		*fm;
+#ifndef GTP_FRAME_SIMPLE
+	struct ring_buffer_event	*rbe;
+#endif
+
+	if (reg >= 0)
+		addr += (CORE_ADDR) gtp_action_reg_read(gts->regs,
+							gts->tpe, reg);
+	if (gts->tpe->reason != gtp_stop_normal)
+		return -1;
+
+	if (gts->next == NULL) {
+		if (gtp_action_head(gts))
+			return -1;
+	}
+
+#ifdef GTP_FRAME_SIMPLE
+	tmp = gtp_frame_alloc(GTP_FRAME_MEM_SIZE + size);
+	if (!tmp) {
+		gts->tpe->reason = gtp_stop_frame_full;
+		return -1;
+	}
+	*gts->next = tmp;
+#else
+	GTP_FRAME_RINGBUFFER_ALLOC(GTP_FRAME_MEM_SIZE + size);
+#endif
+
+	FID(tmp) = FID_MEM;
+	tmp += FID_SIZE;
+
+#ifdef GTP_FRAME_SIMPLE
+	gts->next = (char **)tmp;
+	*gts->next = NULL;
+	tmp += sizeof(char *);
+#endif
+
+	fm = (struct gtp_frame_mem *)tmp;
+	fm->addr = addr;
+	fm->size = size;
+	tmp += sizeof(struct gtp_frame_mem);
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_action_memory_read: id:%d addr:%p %p %u\n",
+	       (int)gts->tpe->num, (void *)(CORE_ADDR)gts->tpe->addr,
+	       (void *)addr, (unsigned int)size);
+#endif
+
+	if (probe_kernel_read(tmp, (void *)addr, size)) {
+		gts->tpe->reason = gtp_stop_efault;
+#ifdef GTP_FRAME_SIMPLE
+		memset(tmp, 0, size);
+#else
+		ring_buffer_discard_commit(gtp_frame, rbe);
+#endif
+		printk(KERN_WARNING "gtp_action_memory_read: id:%d addr:%p "
+				    "read %p %u get error.\n",
+		       (int)gts->tpe->num, (void *)(CORE_ADDR)gts->tpe->addr,
+		       (void *)addr, (unsigned int)size);
+		return -1;
+	}
+
+#ifndef GTP_FRAME_SIMPLE
+	ring_buffer_unlock_commit(gtp_frame, rbe);
+#endif
+
+	return 0;
+}
+
+static int
+gtp_action_r(struct gtp_trace_s *gts, struct action *ae)
+{
+	struct pt_regs			*regs;
+	char				*tmp;
+#ifndef GTP_FRAME_SIMPLE
+	struct ring_buffer_event	*rbe;
+#endif
+
+	if (gts->next == NULL) {
+		if (gtp_action_head(gts))
+			return -1;
+	}
+
+#ifdef GTP_FRAME_SIMPLE
+	tmp = gtp_frame_alloc(GTP_FRAME_REG_SIZE);
+	if (!tmp) {
+		gts->tpe->reason = gtp_stop_frame_full;
+		return -1;
+	}
+	*gts->next = tmp;
+#else
+	GTP_FRAME_RINGBUFFER_ALLOC(GTP_FRAME_REG_SIZE);
+#endif
+
+	FID(tmp) = FID_REG;
+	tmp += FID_SIZE;
+
+#ifdef GTP_FRAME_SIMPLE
+	gts->next = (char **)tmp;
+	*gts->next = NULL;
+	tmp += sizeof(char *);
+#endif
+
+	regs = (struct pt_regs *)tmp;
+
+	memcpy(regs, gts->regs, sizeof(struct pt_regs));
+#ifdef CONFIG_X86_32
+	regs->sp = (unsigned long)&regs->sp;
+#endif	/* CONFIG_X86_32 */
+
+	if (gts->ri)
+		GTP_REGS_PC(regs) = (CORE_ADDR)gts->ri->ret_addr;
+#ifdef CONFIG_X86
+	else
+		GTP_REGS_PC(regs) -= 1;
+#endif	/* CONFIG_X86 */
+
+#ifndef GTP_FRAME_SIMPLE
+	ring_buffer_unlock_commit(gtp_frame, rbe);
+#endif
+
+	return 0;
+}
+
+static struct gtp_var *
+gtp_gtp_var_array_find(unsigned int num)
+{
+	struct gtp_var	*ret;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_gtp_var_array_find: num:%u %u %u\n",
+	       gtp_var_head, gtp_var_tail, num);
+#endif
+
+	if (num < gtp_var_head || num > gtp_var_tail)
+		return NULL;
+
+	ret = gtp_var_array[num - gtp_var_head];
+	if (ret->per_cpu)
+		ret = ret->per_cpu[smp_processor_id()];
+
+	return ret;
+}
+
+uint64_t
+gtp_get_var(struct gtp_trace_s *gts, struct gtp_var *tve)
+{
+	switch (tve->num) {
+	case GTP_VAR_CURRENT_TASK_ID:
+		if (gts->ri)
+			return (uint64_t)(CORE_ADDR)gts->ri->task;
+		else
+			return (uint64_t)(CORE_ADDR)get_current();
+		break;
+	case GTP_VAR_CURRENT_THREAD_INFO_ID:
+		return (uint64_t)(CORE_ADDR)current_thread_info();
+		break;
+	case GTP_VAR_CLOCK_ID:
+		return (uint64_t)GTP_LOCAL_CLOCK;
+		break;
+	case GTP_VAR_COOKED_CLOCK_ID:
+		return (uint64_t)(__get_cpu_var(local_clock_current)
+					- __get_cpu_var(local_clock_offset));
+		break;
+	case GTP_VAR_COOKED_CLOCK_ID:
+		return (uint64_t)(__get_cpu_var(local_clock_current)
+					- __get_cpu_var(local_clock_offset));
+		break;
+#ifdef CONFIG_X86
+	case GTP_VAR_RDTSC_ID:
+		{
+			unsigned long long a;
+			rdtscll(a);
+			return (uint64_t)a;
+		}
+		break;
+	case GTP_VAR_COOKED_RDTSC_ID:
+		return (uint64_t)(__get_cpu_var(rdtsc_current)
+					- __get_cpu_var(rdtsc_offset));
+		break;
+	case GTP_VAR_COOKED_RDTSC_ID:
+		return (uint64_t)(__get_cpu_var(rdtsc_current)
+					- __get_cpu_var(rdtsc_offset));
+		break;
+#endif
+	case GTP_VAR_CPU_ID:
+		return (uint64_t)(CORE_ADDR)smp_processor_id();
+		break;
+	case GTP_VAR_CPU_NUMBER_ID:
+		return (uint64_t)gtp_cpu_number;
+		break;
+	case GTP_VAR_PRINTK_TMP_ID:
+		return gts->printk_tmp;
+		break;
+	case GTP_VAR_DUMP_STACK_ID:
+		printk(KERN_NULL "gtp %d %p:", (int)gts->tpe->num,
+		       (void *)(CORE_ADDR)gts->tpe->addr);
+		dump_stack();
+		return 0;
+		break;
+	case GTP_VAR_XTIME_SEC_ID:
+		if (gts->xtime.tv_sec == 0 && gts->xtime.tv_nsec == 0)
+			getnstimeofday(&gts->xtime);
+		return (uint64_t)gts->xtime.tv_sec;
+		break;
+	case GTP_VAR_XTIME_NSEC_ID:
+		if (gts->xtime.tv_sec == 0 && gts->xtime.tv_nsec == 0)
+			getnstimeofday(&gts->xtime);
+		return (uint64_t)gts->xtime.tv_nsec;
+		break;
+	case GTP_VAR_HARDIRQ_COUNT_ID:
+		return (uint64_t)hardirq_count();
+		break;
+	case GTP_VAR_SOFTIRQ_COUNT_ID:
+		return (uint64_t)softirq_count();
+		break;
+	case GTP_VAR_IRQ_COUNT_ID:
+		return (uint64_t)irq_count();
+		break;
+	}
+
+#ifdef CONFIG_PERF_EVENTS
+	if (tve->ptid == pe_tv_val || tve->ptid == pe_tv_enabled
+	    || tve->ptid == pe_tv_running) {
+		tve->pts->val = perf_event_read_value(tve->pts->event,
+						      &(tve->pts->enabled),
+						      &(tve->pts->running));
+		switch (tve->ptid) {
+		case pe_tv_val:
+			return (uint64_t)(tve->pts->val);
+			break;
+		case pe_tv_enabled:
+			return (uint64_t)(tve->pts->enabled);
+			break;
+		case pe_tv_running:
+			return (uint64_t)(tve->pts->running);
+			break;
+		default:
+			return 0;
+			break;
+		}
+	}
+#endif
+
+	return tve->val;
+}
+
+static int
+gtp_collect_var(struct gtp_trace_s *gts, struct gtp_var *tve)
+{
+	struct gtp_frame_var		*fvar;
+	char				*tmp;
+#ifndef GTP_FRAME_SIMPLE
+	struct ring_buffer_event	*rbe;
+#endif
+
+	if (gts->next == NULL) {
+		if (gtp_action_head(gts))
+			return -1;
+	}
+
+#ifdef GTP_FRAME_SIMPLE
+	tmp = gtp_frame_alloc(GTP_FRAME_VAR_SIZE);
+	if (!tmp) {
+		gts->tpe->reason = gtp_stop_frame_full;
+		return -1;
+	}
+	*gts->next = tmp;
+#else
+	GTP_FRAME_RINGBUFFER_ALLOC(GTP_FRAME_VAR_SIZE);
+#endif
+
+	FID(tmp) = FID_VAR;
+	tmp += FID_SIZE;
+
+#ifdef GTP_FRAME_SIMPLE
+	gts->next = (char **)tmp;
+	*gts->next = NULL;
+	tmp += sizeof(char *);
+#endif
+
+	fvar = (struct gtp_frame_var *) tmp;
+	fvar->num = tve->num;
+	fvar->val = gtp_get_var(gts, tve);
+
+#ifndef GTP_FRAME_SIMPLE
+	ring_buffer_unlock_commit(gtp_frame, rbe);
+#endif
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
+#ifdef CONFIG_PERF_EVENTS
+#define gtp_action_x_setv_pe						\
+	do {								\
+		if (tve->ptid == pe_tv_en)				\
+			gtp_pe_set_en(tve->pts, (int)top);		\
+		else if (tve->ptid == pe_tv_val)			\
+			perf_event_set(tve->pts->event, (u64)top);	\
+	} while (0)
+#else
+#define gtp_action_x_setv_pe
+#endif
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
+		case GTP_VAR_PC_PE_EN_ID:				\
+			gtp_pc_pe_en((int)top);				\
+			break;						\
+		default: {						\
+				struct gtp_var	*tve;			\
+									\
+				tve = gtp_gtp_var_array_find(arg);	\
+				if (!tve)				\
+					goto code_error_out;		\
+				gtp_action_x_setv_pe;			\
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
+		if (!gts->tpe->have_printk				\
+		    || !GTP_VAR_AUTO_TRACEV(arg)) {			\
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
+	char		*pbuf = __get_cpu_var(gtp_printf);
+	ULONGEST	*stack = __get_cpu_var(action_x_stack);
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
+	printk(KERN_WARNING "gtp_action_x: tracepoint %d addr:%p"
+			    "action X get error in pc %u.\n",
+		(int)gts->tpe->num, (void *)(CORE_ADDR)gts->tpe->addr, pc);
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
+#ifndef GTP_FRAME_SIMPLE
+static void
+gtp_kp_pre_handler_end(void)
+{
+	FID_TYPE	eid = FID_END;
+	ring_buffer_write(gtp_frame, FID_SIZE, &eid);
+
+	if (atomic_read(&gtpframe_pipe_wq_v) > 0) {
+		atomic_dec(&gtpframe_pipe_wq_v);
+		add_preempt_count(HARDIRQ_OFFSET);
+		tasklet_schedule(&gtpframe_pipe_wq_tasklet);
+		sub_preempt_count(HARDIRQ_OFFSET);
+	}
+}
+#endif
+
+static int
+gtp_handler(struct gtp_trace_s *gts)
+{
+	struct action		*ae;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_handler: tracepoint %d %p\n",
+	       (int)gts->tpe->num, (void *)(CORE_ADDR)gts->tpe->addr);
+#endif
+
+	if (gts->tpe->kpreg == 0)
+		return 0;
+
+	if (gts->tpe->no_self_trace) {
+		if (get_current()->pid == gtp_gtp_pid
+		    || get_current()->pid == gtp_gtpframe_pid)
+			return 0;
+#ifndef GTP_FRAME_SIMPLE
+		if (get_current()->pid == gtp_gtpframe_pipe_pid)
+			return 0;
+#endif
+	}
+
+	if (gts->tpe->have_printk) {
+		gts->printk_level = 8;
+		gts->printk_str = gts->tpe->printk_str;
+	}
+
+	/* Condition.  */
+	if (gts->tpe->cond) {
+		int	run;
+
+		gts->run = &run;
+		if (gtp_action_x(gts, gts->tpe->cond))
+			goto tpe_stop;
+		if (!run)
+			return 0;
+	}
+
+	gts->run = NULL;
+
+	/* Pass.  */
+	if (!gts->tpe->nopass) {
+		if (atomic_dec_return(&gts->tpe->current_pass) < 0)
+			goto tpe_stop;
+	}
+
+	atomic_inc(&gtp_frame_create);
+
+	/* Handle actions.  */
+	for (ae = gts->tpe->action_list; ae; ae = ae->next) {
+		switch (ae->type) {
+		case 'R':
+			if (gtp_action_r(gts, ae))
+				goto tpe_stop;
+			break;
+		case 'X':
+		case 0xff:
+			if (gtp_action_x(gts, ae))
+				goto tpe_stop;
+			break;
+		case 'M':
+			if (gtp_action_memory_read(gts, ae->u.m.regnum,
+						   ae->u.m.offset,
+						   ae->u.m.size))
+				goto tpe_stop;
+			break;
+		}
+	}
+
+#ifndef GTP_FRAME_SIMPLE
+	if (gts->next)
+		gtp_kp_pre_handler_end();
+#endif
+
+	return 0;
+
+tpe_stop:
+#ifndef GTP_FRAME_SIMPLE
+	if (gts->next)
+		gtp_kp_pre_handler_end();
+#endif
+	gts->tpe->kpreg = 0;
+	add_preempt_count(HARDIRQ_OFFSET);
+	tasklet_schedule(&gts->tpe->tasklet);
+	sub_preempt_count(HARDIRQ_OFFSET);
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_kp_pre_handler: tracepoint %d %p stop.\n",
+		(int)gts->tpe->num, (void *)(CORE_ADDR)gts->tpe->addr);
+#endif
+	return 0;
+}
+
+static void
+gtp_handler_begin(void)
+{
+	if (__get_cpu_var(rdtsc_current) == 0) {
+		u64	a;
+
+		rdtscll(a);
+		__get_cpu_var(rdtsc_current) = a;
+
+		__get_cpu_var(local_clock_current) = GTP_LOCAL_CLOCK;
+#ifdef CONFIG_PERF_EVENTS
+		pc_pe_list_disable();
+#endif
+	}
+}
+
+static void
+gtp_handler_end(void)
+{
+	if (__get_cpu_var(rdtsc_current) != 0) {
+		u64	a;
+
+#ifdef CONFIG_PERF_EVENTS
+		pc_pe_list_enable();
+#endif
+
+		__get_cpu_var(local_clock_offset) += GTP_LOCAL_CLOCK
+					- __get_cpu_var(local_clock_current);
+		__get_cpu_var(local_clock_current) = 0;
+
+		rdtscll(a);
+		__get_cpu_var(rdtsc_offset) += a - __get_cpu_var(rdtsc_current);
+		__get_cpu_var(rdtsc_current) = 0;
+	}
+}
+
+static int
+gtp_kp_pre_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct kretprobe	*kp;
+	struct gtp_trace_s	gts;
+
+	gtp_handler_begin();
+
+	memset(&gts, 0, sizeof(struct gtp_trace_s));
+	kp = container_of(p, struct kretprobe, kp);
+	gts.tpe = container_of(kp, struct gtp_entry, kp);
+	gts.regs = regs;
+
+	return gtp_handler(&gts);
+}
+
+static void
+gtp_kp_post_handler(struct kprobe *p, struct pt_regs *regs, unsigned
long flags)
+{
+	gtp_handler_end();
+}
+
+static int
+gtp_kp_ret_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
+{
+	int			ret;
+	struct gtp_trace_s	gts;
+
+	gtp_handler_begin();
+
+	memset(&gts, 0, sizeof(struct gtp_trace_s));
+	gts.tpe = container_of(ri->rp, struct gtp_entry, kp);
+	gts.regs = regs;
+	gts.ri = ri;
+
+	ret = gtp_handler(&gts);
+
+	gtp_handler_end();
+
+	return ret;
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
+		case 0xff:
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
+	printk(GTP_DEBUG "gtp_stop: tracepoint %d %p\n", (int)tpe->num,
+	       (void *)(CORE_ADDR)tpe->addr);
+#endif
+
+	if (tpe->is_kretprobe)
+		unregister_kretprobe(&tpe->kp);
+	else
+		unregister_kprobe(&tpe->kp.kp);
+}
+
+static struct gtp_entry *
+gtp_list_add(ULONGEST num, ULONGEST addr)
+{
+	struct gtp_entry	*ret = kcalloc(1, sizeof(struct gtp_entry),
+					       GFP_KERNEL);
+
+	if (!ret)
+		goto out;
+	memset(ret, '\0', sizeof(struct gtp_entry));
+	ret->num = num;
+	ret->addr = addr;
+	ret->kp.kp.addr = (kprobe_opcode_t *) (CORE_ADDR)addr;
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
+gtp_list_find(ULONGEST num, ULONGEST addr)
+{
+	struct gtp_entry	*tpe;
+
+	for (tpe = gtp_list; tpe; tpe = tpe->next) {
+		if (tpe->num == num && tpe->addr == addr)
+			return tpe;
+	}
+
+	return NULL;
+}
+
+/* If more than one gtp entry have same num, return NULL.  */
+
+static struct gtp_entry *
+gtp_list_find_without_addr(ULONGEST num)
+{
+	struct gtp_entry	*tpe, *ret = NULL;
+
+	for (tpe = gtp_list; tpe; tpe = tpe->next) {
+		if (tpe->num == num) {
+			if (ret)
+				return NULL;
+			else
+				ret = tpe;
+		}
+	}
+
+	return ret;
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
+#ifndef GTP_FRAME_SIMPLE
+static void
+gtp_frame_iter_open(void)
+{
+	int	cpu;
+
+
+	for_each_online_cpu(cpu)
+		gtp_frame_iter[cpu] = ring_buffer_read_prepare(gtp_frame, cpu);
+	ring_buffer_read_prepare_sync();
+	for_each_online_cpu(cpu) {
+		ring_buffer_read_start(gtp_frame_iter[cpu]);
+	}
+}
+
+static void
+gtp_frame_iter_reset(void)
+{
+	int	cpu;
+
+	for_each_online_cpu(cpu)
+		ring_buffer_iter_reset(gtp_frame_iter[cpu]);
+	gtp_frame_current_num = -1;
+}
+
+static int
+gtp_frame_iter_peek_head(void)
+{
+	int	cpu;
+	int	ret = -1;
+	u64	min = 0;
+
+	for_each_online_cpu(cpu) {
+		struct ring_buffer_event	*rbe;
+		char				*tmp;
+		u64				ts;
+
+		while (1) {
+			rbe = ring_buffer_iter_peek(gtp_frame_iter[cpu], &ts);
+			if (rbe == NULL)
+				break;
+			tmp = ring_buffer_event_data(rbe);
+			if (FID(tmp) == FID_HEAD)
+				break;
+			ring_buffer_read(gtp_frame_iter[cpu], NULL);
+		}
+
+		if (rbe) {
+			if ((min && ts < min) || !min) {
+				min = ts;
+				ret = cpu;
+			}
+		}
+	}
+
+	if (ret < 0)
+		gtp_frame_current_num = -1;
+	else
+		gtp_frame_current_num++;
+	return ret;
+}
+
+static void
+gtp_frame_iter_close(void)
+{
+	int	cpu;
+
+	for_each_online_cpu(cpu) {
+		if (gtp_frame_iter[cpu]) {
+			ring_buffer_read_finish(gtp_frame_iter[cpu]);
+			gtp_frame_iter[cpu] = NULL;
+		}
+	}
+}
+#endif
+
+static void
+gtp_frame_reset(void)
+{
+	gtp_frame_current_num = -1;
+#ifdef GTP_FRAME_SIMPLE
+	gtp_frame_r_start = gtp_frame;
+	gtp_frame_w_start = gtp_frame;
+	gtp_frame_end = gtp_frame + GTP_FRAME_SIZE;
+	gtp_frame_is_circular = 0;
+	gtp_frame_current = NULL;
+#else
+	gtp_frame_iter_close();
+	if (gtp_frame)
+		ring_buffer_reset(gtp_frame);
+#endif
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
+	if (u64)
+		*u64 = 0;
+	while (hex2int(pkg[0], &i)) {
+		pkg++;
+		if (u64) {
+			*u64 = (*u64) << 4;
+			*u64 |= i & 0xf;
+		}
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
+#ifdef CONFIG_PERF_EVENTS
+static struct gtp_var *
+gtp_var_add(unsigned int num, uint64_t val, char *src,
+	    struct gtp_var **per_cpu, int per_cpu_id,
+	    enum pe_tv_id ptid, struct pe_tv_s *pts)
+#else
+static struct gtp_var *
+gtp_var_add(unsigned int num, uint64_t val, char *src,
+	    struct gtp_var **per_cpu, int per_cpu_id)
+#endif
+{
+	struct gtp_var *var = kcalloc(1, sizeof(struct gtp_var), GFP_KERNEL);
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
+	var->per_cpu = per_cpu;
+	if (per_cpu)
+		var->per_cpu[per_cpu_id] = var;
+
+#ifdef CONFIG_PERF_EVENTS
+	var->ptid = ptid;
+	var->pts = pts;
+#endif
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
+
+		if (tve->per_cpu) {
+			struct gtp_var	*tve1;
+
+			for (tve1 = gtp_var_list; tve1; tve1 = tve1->next) {
+				if (tve1->per_cpu == tve->per_cpu)
+					tve1->per_cpu = NULL;
+			}
+
+			kfree(tve->per_cpu);
+		}
+
+#ifdef CONFIG_PERF_EVENTS
+		if (tve->pts) {
+			struct gtp_var	*tve1;
+
+			for (tve1 = gtp_var_list; tve1; tve1 = tve1->next) {
+				if (tve1->pts == tve->pts) {
+					tve1->pts = NULL;
+					tve1->ptid = pe_tv_unknown;
+				}
+			}
+
+			if (tve->pts->event)
+				perf_event_release_kernel(tve->pts->event);
+			kfree(tve->pts);
+		}
+#endif
+
+		kfree(tve->src);
+		kfree(tve);
+	}
+
+	gtp_start_ignore_error = 0;
+}
+
+static int
+gtp_gdbrsp_qtstop(void)
+{
+	struct gtp_entry	*tpe;
+#ifdef CONFIG_PERF_EVENTS
+	struct gtp_var		*tve;
+#endif
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
+			if (tpe->is_kretprobe)
+				unregister_kretprobe(&tpe->kp);
+			else
+				unregister_kprobe(&tpe->kp.kp);
+			tpe->kpreg = 0;
+		}
+		tasklet_kill(&tpe->tasklet);
+	}
+
+#ifdef CONFIG_PERF_EVENTS
+	for (tve = gtp_var_list; tve; tve = tve->next) {
+		if (tve->pts == NULL)
+			continue;
+		if (tve->pts->event == NULL)
+			continue;
+
+		tve->pts->val = perf_event_read_value(tve->pts->event,
+						      &(tve->pts->enabled),
+						      &(tve->pts->running));
+		perf_event_release_kernel(tve->pts->event);
+		tve->pts->event = NULL;
+	}
+#endif
+
+	kfree(gtp_var_array);
+	gtp_var_array = NULL;
+
+#ifndef GTP_FRAME_SIMPLE
+	if (gtp_frame) {
+		gtp_frame_iter_open();
+		gtp_frame_iter_reset();
+	}
+#endif
+
+	gtp_start = 0;
+#ifndef GTP_FRAME_SIMPLE
+	if (atomic_read(&gtpframe_pipe_wq_v) > 0) {
+		atomic_dec(&gtpframe_pipe_wq_v);
+		tasklet_schedule(&gtpframe_pipe_wq_tasklet);
+	}
+	tasklet_kill(&gtpframe_pipe_wq_tasklet);
+#endif
+	wake_up_interruptible_nr(&gtpframe_wq, 1);
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
+				}
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
+				if (arg == GTP_VAR_NO_SELF_TRACE_ID) {
+					tpe->no_self_trace = 1;
+					ret = 1;
+					goto release_out;
+				}
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
+				if (arg == GTP_VAR_NO_SELF_TRACE_ID) {
+					tpe->no_self_trace = 1;
+					ret = 1;
+					goto release_out;
+				} else if (arg == GTP_VAR_KRET_ID) {
+					/* XXX: still not set it value to
+					   maxactive.  */
+					tpe->is_kretprobe = 1;
+					ret = 1;
+					goto release_out;
+				}
+
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
+				if (arg == GTP_VAR_NO_SELF_TRACE_ID) {
+					tpe->no_self_trace = 1;
+					ret = 1;
+					goto release_out;
+				}
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
+		struct gtp_var *var;
+
+		vtmp = vlist;
+		vlist = vlist->next;
+
+		/* Get the var of vtmp.  */
+		var = gtp_var_find(vtmp->num);
+		if (var == NULL) {
+			printk(KERN_WARNING "gtp_check_x: cannot find "
+					    "tvar %d.\n", vtmp->num);
+			ret = -EINVAL;
+		} else {
+			if (var->per_cpu == NULL) {
+				if ((vtmp->flags & 2)
+				    && ((vtmp->flags & 1) || (vtmp->flags & 4)))
+					ae->u.exp.need_var_lock = 1;
+			}
+		}
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
+#ifndef GTP_FRAME_SIMPLE
+static void
+gtpframe_pipe_wq_wake_up(unsigned long data)
+{
+	wake_up_interruptible_nr(&gtpframe_pipe_wq, 1);
+}
+#endif
+
+static void
+gtp_wq_add_work(unsigned long data)
+{
+	queue_work(gtp_wq, (struct work_struct *)data);
+}
+
+static int
+gtp_gdbrsp_qtstart(void)
+{
+	int			cpu;
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
+#ifndef GTP_FRAME_SIMPLE
+	if (!tracing_is_on()) {
+		printk(KERN_WARNING "qtstart: Ring buffer is off.  Please use "
+		       "command "
+		       "\"echo 1 > /sys/kernel/debug/tracing/tracing_on\" "
+		       "open it.\n");
+		return -EIO;
+	}
+#endif
+
+	for (tpe = gtp_list; tpe; tpe = tpe->next) {
+		int		ret;
+		struct action	*ae, *prev_ae = NULL;
+
+		/* Check cond.  */
+		if (tpe->cond) {
+			ret = gtp_check_x(tpe, tpe->cond);
+			if (ret > 0) {
+				kfree(tpe->cond->u.exp.buf);
+				kfree(tpe->cond);
+				tpe->cond = NULL;
+			} else if (ret < 0)
+				return ret;
+		}
+
+		/* Check X.  */
+		for (ae = tpe->action_list; ae; ae = ae->next) {
+re_check:
+			if (ae->type == 'X' || ae->type == 0xff) {
+				ret = gtp_check_x(tpe, ae);
+				if (ret > 0) {
+					struct action	*old_ae = ae;
+
+					/* Remove ae from action_list.  */
+					ae = ae->next;
+					if (prev_ae)
+						prev_ae->next = ae;
+					else
+						tpe->action_list = ae;
+
+					kfree(old_ae->u.exp.buf);
+					kfree(old_ae);
+
+					if (ae)
+						goto re_check;
+					else
+						break;
+				} else if (ret < 0)
+					return ret;
+			}
+
+			prev_ae = ae;
+		}
+
+		/* Check the tracepoint that have printk.  */
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
+					       "of tp %d %p is not right.  "
+					       "Please put global variable to "
+					       "trace state variable "
+					       "$printk_tmp before print it.\n",
+					       (int)tpe->num,
+					       (void *)(CORE_ADDR)tpe->addr);
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
+				char		tmp[30];
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
+							    "from tp %d %p"
+							    "command %s.\n",
+					       (int)tpe->num,
+					       (void *)(CORE_ADDR)tpe->addr,
+					       str);
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
+				snprintf(tmp, 30, "gtp %d %p:", (int)tpe->num,
+					 (void *)(CORE_ADDR)tpe->addr);
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
+#ifdef GTP_FRAME_SIMPLE
+		gtp_frame = vmalloc(GTP_FRAME_SIZE);
+#else
+		gtp_frame = ring_buffer_alloc(GTP_FRAME_SIZE,
+					      gtp_circular ? RB_FL_OVERWRITE
+							     : 0);
+#endif
+		if (!gtp_frame)
+			return -ENOMEM;
+
+		gtp_frame_reset();
+	}
+
+	for_each_online_cpu(cpu) {
+		per_cpu(rdtsc_current, cpu) = 0;
+		per_cpu(local_clock_current, cpu) = 0;
+		per_cpu(rdtsc_offset, cpu) = 0;
+		per_cpu(local_clock_offset, cpu) = 0;
+	}
+
+	gtp_start = 1;
+
+	gtp_var_array = kmalloc(sizeof(struct gtp_var *)
+				* (gtp_var_tail - gtp_var_head + 1),
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
+#ifdef CONFIG_PERF_EVENTS
+	/* Clear pc_pe_list.  */
+	for_each_online_cpu(cpu) {
+		per_cpu(pc_pe_list, cpu) = NULL;
+		per_cpu(pc_pe_list_all_disabled, cpu) = 1;
+	}
+	for (tve = gtp_var_list; tve; tve = tve->next) {
+		if (tve->ptid == pe_tv_unknown)
+			continue;
+		if (tve->pts->event)
+			continue;
+
+		/* Get event.  */
+		tve->pts->event =
+			perf_event_create_kernel_counter(&(tve->pts->attr),
+							 tve->pts->cpu,
+							 NULL, NULL, NULL);
+		if (IS_ERR(tve->pts->event)) {
+			int	ret = PTR_ERR(tve->pts->event);
+
+			printk(KERN_WARNING "gtp_gdbrsp_qtstart:"
+			       "create perf_event %d got error.\n",
+			       (int)tve->num);
+			tve->pts->event = NULL;
+			gtp_gdbrsp_qtstop();
+			return ret;
+		}
+
+		/* Add event to pc_pe_list.  */
+		if (tve->pts->cpu >= 0) {
+			struct pe_tv_s *ppl = per_cpu(pc_pe_list,
+						      tve->pts->cpu);
+			if (ppl == NULL) {
+				per_cpu(pc_pe_list, tve->pts->cpu) = tve->pts;
+				tve->pts->pc_next = NULL;
+			} else {
+				tve->pts->pc_next = ppl;
+				per_cpu(pc_pe_list,
+					tve->pts->cpu) = tve->pts;
+			}
+			if (tve->pts->en)
+				per_cpu(pc_pe_list_all_disabled, tve->pts->cpu)
+					= 0;
+		}
+	}
+#endif
+
+#ifndef GTP_FRAME_SIMPLE
+	tasklet_init(&gtpframe_pipe_wq_tasklet, gtpframe_pipe_wq_wake_up, 0);
+#endif
+
+	gtp_start_last_errno = 0;
+
+	for (tpe = gtp_list; tpe; tpe = tpe->next) {
+		tpe->reason = gtp_stop_normal;
+		if (!tpe->disable && tpe->addr != (CORE_ADDR)register_kprobe) {
+			int	ret;
+
+			if (!tpe->nopass)
+				atomic_set(&tpe->current_pass, tpe->pass);
+
+			tasklet_init(&tpe->tasklet, gtp_wq_add_work,
+				     (unsigned long)&tpe->work);
+
+			if (tpe->is_kretprobe) {
+				tpe->kp.handler = gtp_kp_ret_handler;
+				ret = register_kretprobe(&tpe->kp);
+			} else {
+				tpe->kp.kp.pre_handler = gtp_kp_pre_handler;
+				tpe->kp.kp.post_handler = gtp_kp_post_handler;
+				ret = register_kprobe(&tpe->kp.kp);
+			}
+			if (ret < 0) {
+				printk(KERN_WARNING "gtp_gdbrsp_qtstart:"
+				"register tracepoint %d %p got error.\n",
+				(int)tpe->num, (void *)(CORE_ADDR)tpe->addr);
+				if (gtp_start_ignore_error) {
+					gtp_start_last_errno = (uint64_t)ret;
+					continue;
+				} else {
+					gtp_gdbrsp_qtstop();
+					return ret;
+				}
+			}
+			tpe->kpreg = 1;
+		}
+	}
+
+	return 0;
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
+	tpe = gtp_list_find(num, addr);
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
+					if (ret) {
+						kfree(ae);
+						ae = NULL;
+
+						if (ret < 0)
+							return ret;
+					}
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
+				if ((ae->type == 'X' || ae->type == 0xff)
+				    && addnew && !tpe->cond) {
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
+	tpe = gtp_list_find(num, addr);
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
+
+		gtp_circular = (int)setting;
+		if (gtp_frame)
+			ring_buffer_change_overwrite(gtp_frame, (int)setting);
+
+		return 0;
+	}
+
+	return 1;
+}
+
+static int
+gtp_frame_head_find_num(int num)
+{
+#ifdef GTP_FRAME_SIMPLE
+	int	tfnum = 0;
+	char	*tmp = gtp_frame_r_start;
+
+	do {
+		if (tmp == gtp_frame_end)
+			tmp = gtp_frame;
+
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
+	} while (tmp != gtp_frame_w_start);
+#else
+	if (gtp_frame_current_num >= num)
+		gtp_frame_iter_reset();
+
+	while (1) {
+		int	cpu;
+
+		cpu = gtp_frame_iter_peek_head();
+		if (cpu < 0)
+			break;
+
+		if (num == gtp_frame_current_num)
+			return cpu;
+
+		ring_buffer_read(gtp_frame_iter[cpu], NULL);
+	}
+#endif
+
+	return -1;
+}
+
+static int
+gtp_frame_head_find_addr(int inside, unsigned long lo,
+			 unsigned long hi)
+{
+#ifdef GTP_FRAME_SIMPLE
+	int	tfnum = gtp_frame_current_num;
+	char	*tmp;
+
+	if (gtp_frame_current)
+		tmp = gtp_frame_current;
+	else
+		tmp = gtp_frame_r_start;
+
+	do {
+		if (tmp == gtp_frame_end)
+			tmp = gtp_frame;
+
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
+	} while (tmp != gtp_frame_w_start);
+#else
+	while (1) {
+		int				cpu;
+		struct ring_buffer_event	*rbe;
+		char				*tmp;
+		struct pt_regs			*regs = NULL;
+
+		cpu = gtp_frame_iter_peek_head();
+		if (cpu < 0)
+			break;
+
+		while (1) {
+			ring_buffer_read(gtp_frame_iter[cpu], NULL);
+			rbe = ring_buffer_iter_peek(gtp_frame_iter[cpu], NULL);
+			if (rbe == NULL)
+				break;
+
+			tmp = ring_buffer_event_data(rbe);
+			if (FID(tmp) == FID_HEAD)
+				break;
+			if (FID(tmp) == FID_REG) {
+				regs = (struct pt_regs *)(tmp + FID_SIZE);
+				break;
+			}
+		}
+
+		if (regs
+		    && ((inside
+			  && GTP_REGS_PC(regs) >= lo
+			  && GTP_REGS_PC(regs) <= hi)
+			|| (!inside
+			    && (GTP_REGS_PC(regs) < lo
+				|| GTP_REGS_PC(regs) > hi))))
+			return gtp_frame_head_find_num(gtp_frame_current_num);
+	}
+#endif
+
+	return -1;
+}
+
+static int
+gtp_frame_head_find_trace(ULONGEST trace)
+{
+#ifdef GTP_FRAME_SIMPLE
+	int	tfnum = gtp_frame_current_num;
+	char	*tmp;
+
+	if (gtp_frame_current)
+		tmp = gtp_frame_current;
+	else
+		tmp = gtp_frame_r_start;
+
+	do {
+		if (tmp == gtp_frame_end)
+			tmp = gtp_frame;
+
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
+	} while (tmp != gtp_frame_w_start);
+#else
+	while (1) {
+		int				cpu;
+		struct ring_buffer_event	*rbe;
+		char				*tmp;
+
+		cpu = gtp_frame_iter_peek_head();
+		if (cpu < 0)
+			break;
+
+		rbe = ring_buffer_iter_peek(gtp_frame_iter[cpu], NULL);
+		if (rbe == NULL) {
+			/* It will not happen, just for safe.  */
+			return -1;
+		}
+		tmp = ring_buffer_event_data(rbe);
+		if (trace == *(ULONGEST *) (tmp + FID_SIZE))
+			return cpu;
+
+		ring_buffer_read(gtp_frame_iter[cpu], NULL);
+	}
+#endif
+
+	return -1;
+}
+
+static int
+gtp_gdbrsp_qtframe(char *pkg)
+{
+	int	ret = -1;
+#ifndef GTP_FRAME_SIMPLE
+	int	old_num = gtp_frame_current_num;
+#endif
+
+	if (gtp_start)
+		return -EBUSY;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_gdbrsp_qtframe: %s\n", pkg);
+#endif
+
+	/* XXX: If this check is removed, add a check for gtp_frame.  */
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
+		ret = gtp_frame_head_find_addr(1, (unsigned long)addr,
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
+		ret = gtp_frame_head_find_trace(trace);
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
+		ret = gtp_frame_head_find_addr(1, (unsigned long)start,
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
+		ret = gtp_frame_head_find_addr(0, (unsigned long)start,
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
+#ifdef GTP_FRAME_SIMPLE
+			gtp_frame_current = NULL;
+			gtp_frame_current_num = -1;
+#else
+			gtp_frame_iter_reset();
+#endif
+
+			return 0;
+		}
+		ret = gtp_frame_head_find_num((int) num);
+	}
+
+out:
+	if (ret < 0) {
+#ifndef GTP_FRAME_SIMPLE
+		/* Set frame back to old_num.  */
+		if (old_num < 0)
+			gtp_frame_iter_reset();
+		else
+			gtp_frame_head_find_num(old_num);
+#endif
+		strcpy(gtp_rw_bufp, "F-1");
+		gtp_rw_bufp += 3;
+		gtp_rw_size += 3;
+	} else {
+#ifdef GTP_FRAME_SIMPLE
+		gtp_frame_current_tpe = *(ULONGEST *)(gtp_frame_current
+						      + FID_SIZE
+						      + sizeof(char *));
+		sprintf(gtp_rw_bufp, "F%xT%x", gtp_frame_current_num,
+			(unsigned int) gtp_frame_current_tpe);
+#else
+		struct ring_buffer_event	*rbe;
+		char				*tmp;
+
+		rbe = ring_buffer_read(gtp_frame_iter[ret],
+				       &gtp_frame_current_clock);
+		if (rbe == NULL) {
+			/* It will not happen, just for safe.  */
+			ret = -1;
+			goto out;
+		}
+		gtp_frame_current_cpu = ret;
+		tmp = ring_buffer_event_data(rbe);
+		gtp_frame_current_tpe = *(ULONGEST *)(tmp + FID_SIZE);
+		sprintf(gtp_rw_bufp, "F%xT%x", gtp_frame_current_num,
+			(unsigned int) gtp_frame_current_tpe);
+#endif
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
+	char		*src_no_val;
+	int		src_no_val_size;
+	int		per_cpu_id = 0;
+	struct gtp_var	**per_cpu = NULL;
+	int		per_cpu_alloced = 0;
+	int		ret = -EINVAL;
+#ifdef CONFIG_PERF_EVENTS
+	enum pe_tv_id	ptid = pe_tv_unknown;
+	struct pe_tv_s	*pts = NULL;
+	int		pts_alloced = 0;
+#endif
+
+	pkg = hex2ulongest(pkg, &num);
+	if (GTP_VAR_IS_SPECIAL(num))
+		return 0;
+	if (pkg[0] != ':')
+		goto error_out;
+	pkg++;
+	src = pkg;
+	pkg = hex2ulongest(pkg, &val);
+	if (pkg[0] != ':')
+		goto error_out;
+
+	/* src_no_val is not include the val but the ':' after it. */
+	src_no_val = pkg;
+	src_no_val_size = strlen(src_no_val);
+
+	pkg++;
+
+	var = gtp_var_find(num);
+	if (var)
+		goto error_out;
+
+	/* Check if this is a "ignore_error" trace state variable.  */
+	if (strcasecmp(pkg, "0:69676e6f72655f6572726f72") == 0)
+		gtp_start_ignore_error = 1;
+
+	/* Check if this is a "pc_" or "per_cpu_" trace state variable.  */
+	if (strncasecmp(pkg, "0:70635f", 8) == 0
+	    || strncasecmp(pkg, "0:7065725f6370755f", 18) == 0) {
+		int		name_size;
+		char		*id_s;
+		int		mul = 1;
+		struct gtp_var	*tve;
+
+		if (strncasecmp(pkg, "0:70635f", 8) == 0)
+			pkg += 8;
+		else
+			pkg += 18;
+		name_size = strlen(pkg);
+
+		/* Get the cpu id of this variable.  */
+		if (name_size % 2 != 0)
+			goto error_out;
+		for (id_s = pkg + name_size - 2; id_s > pkg; id_s -= 2) {
+			int	i, j;
+
+			if (!hex2int(id_s[0], &i))
+				goto error_out;
+			if (!hex2int(id_s[1], &j))
+				goto error_out;
+			j |= (i << 4);
+			if (j < 0x30 || j > 0x39)
+				break;
+			j -= 0x30;
+			per_cpu_id += mul * j;
+			mul *= 10;
+			/* src_no_val_size will not include the cpu id.  */
+			src_no_val_size -= 2;
+		}
+		if (mul == 1)
+			goto error_out;
+		if (per_cpu_id >= gtp_cpu_number) {
+			printk(KERN_WARNING "gtp_gdbrsp_qtdv: id %d is bigger "
+					    "than cpu number %d.\n",
+			       per_cpu_id, gtp_cpu_number);
+			goto error_out;
+		}
+
+		/* Find the per cpu array per_cpu.  */
+		for (tve = gtp_var_list; tve; tve = tve->next) {
+			if (tve->per_cpu) {
+				char	*gtp_var_src;
+				/* Let gtp_var_src point after the value.  */
+				gtp_var_src = hex2ulongest(tve->src, NULL);
+
+				if (strncmp(gtp_var_src, src_no_val,
+					    src_no_val_size) == 0) {
+					per_cpu = tve->per_cpu;
+					break;
+				}
+			}
+		}
+		if (per_cpu == NULL) {
+			per_cpu = kcalloc(gtp_cpu_number,
+					  sizeof(struct gtp_var *),
+					  GFP_KERNEL);
+			if (per_cpu == NULL) {
+				ret = -ENOMEM;
+				goto error_out;
+			}
+			per_cpu_alloced = 1;
+#ifdef GTP_DEBUG
+			printk(GTP_DEBUG "gtp_gdbrsp_qtdv: Create a "
+					 "new per_cpu list for %s and set var "
+					 "to cpu %d.\n",
+			       src_no_val, per_cpu_id);
+#endif
+		} else {
+#ifdef GTP_DEBUG
+			printk(GTP_DEBUG "gtp_gdbrsp_qtdv: Find a "
+					 "per_cpu list for %s and set var "
+					 "to cpu %d.\n",
+			       src_no_val, per_cpu_id);
+#endif
+		}
+	} else {
+		/* Remove first "0:" for following code.  */
+		if (strlen(pkg) <= 2)
+			goto error_out;
+		pkg += 2;
+	}
+
+	/* Check if this is a "pe_" OR "perf_event_" trace state variable.  */
+	if (strncasecmp(pkg, "70655f", 6) == 0
+	    || strncasecmp(pkg, "706572665f6576656e745f", 22) == 0) {
+#ifdef CONFIG_PERF_EVENTS
+		struct gtp_var	*tve;
+
+		if (strncasecmp(pkg, "70655f", 6) == 0)
+			pkg += 6;
+		else
+			pkg += 22;
+
+		if (strncasecmp(pkg, "6370755f", 8) == 0) {
+			/* "cpu_" */
+			pkg += 8;
+			ptid = pe_tv_cpu;
+		} else if (strncasecmp(pkg, "747970655f", 10) == 0) {
+			/* "type_" */
+			pkg += 10;
+			ptid = pe_tv_type;
+		} else if (strncasecmp(pkg, "636f6e6669675f", 14) == 0) {
+			/* "config_" */
+			pkg += 14;
+			ptid = pe_tv_config;
+		} else if (strncasecmp(pkg, "656e5f", 6) == 0) {
+			/* "en_" */
+			pkg += 6;
+			ptid = pe_tv_en;
+		} else if (strncasecmp(pkg, "76616c5f", 8) == 0) {
+			/* "val_" */
+			pkg += 8;
+			ptid = pe_tv_val;
+		} else if (strncasecmp(pkg, "656e61626c65645f", 16) == 0) {
+			/* "enabled_" */
+			pkg += 16;
+			ptid = pe_tv_enabled;
+		} else if (strncasecmp(pkg, "72756e6e696e675f", 16) == 0) {
+			/* "running_" */
+			pkg += 16;
+			ptid = pe_tv_running;
+		} else
+			goto pe_format_error;
+
+		if (strlen(pkg) <= 0)
+			goto pe_format_error;
+
+		/* Find the pe_tv that name is pkg.  */
+		for (tve = gtp_var_list; tve; tve = tve->next) {
+			if (tve->ptid != pe_tv_unknown) {
+				if (strcmp(tve->pts->name, pkg) == 0)
+					break;
+			}
+		}
+
+		if (tve)
+			pts = tve->pts;
+		else {
+			pts = kcalloc(1, sizeof(struct pe_tv_s), GFP_KERNEL);
+			if (pts == NULL) {
+				ret = -ENOMEM;
+				goto error_out;
+			}
+			pts_alloced = 1;
+			/* Init the value in pts to default value.  */
+			pts->name = gtp_strdup(pkg, NULL);
+			if (per_cpu)
+				pts->cpu = per_cpu_id;
+			else
+				pts->cpu = -1;
+			pts->en = 0;
+			pts->attr.type = PERF_TYPE_HARDWARE;
+			pts->attr.config = PERF_COUNT_HW_CPU_CYCLES;
+			pts->attr.disabled = 1;
+			pts->attr.pinned = 1;
+			pts->attr.size = sizeof(struct perf_event_attr);
+		}
+
+		/* Set current val to pts.  */
+		switch (ptid) {
+		case pe_tv_cpu:
+			pts->cpu = (int)(LONGEST)val;
+			break;
+		case pe_tv_type:
+			pts->attr.type = val;
+			break;
+		case pe_tv_config:
+			pts->attr.config = val;
+			break;
+		case pe_tv_en:
+			if (val) {
+				pts->attr.disabled = 0;
+				pts->en = 1;
+			} else {
+				pts->attr.disabled = 1;
+				pts->en = 0;
+			}
+			break;
+		case pe_tv_val:
+		case pe_tv_enabled:
+		case pe_tv_running:
+			break;
+		default:
+			goto pe_format_error;
+			break;
+		}
+#else
+		printk(KERN_WARNING "Current Kernel doesn't open "
+				    "CONFIG_PERF_EVENTS\n");
+		ret = -ENXIO;
+		goto error_out;
+#endif
+	}
+
+#ifdef CONFIG_PERF_EVENTS
+	if (!gtp_var_add((unsigned int)num, (uint64_t)val, src,
+			 per_cpu, per_cpu_id, ptid, pts)) {
+#else
+	if (!gtp_var_add((unsigned int)num, (uint64_t)val, src,
+			 per_cpu, per_cpu_id)) {
+#endif
+		ret = -ENOMEM;
+		goto error_out;
+	}
+
+	return 0;
+
+#ifdef CONFIG_PERF_EVENTS
+pe_format_error:
+	printk(KERN_WARNING "The format of this perf event "
+			    "trace state variables is not right.\n");
+#endif
+
+error_out:
+#ifdef CONFIG_PERF_EVENTS
+	if (pts_alloced)
+		kfree(pts);
+#endif
+	if (per_cpu_alloced)
+		kfree(per_cpu);
+	return ret;
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
+#ifdef GTP_FRAME_SIMPLE
+		char	*tmp = gtp_frame_r_start;
+
+		do {
+			if (tmp == gtp_frame_end)
+				tmp = gtp_frame;
+
+			if (FID(tmp) == FID_HEAD)
+				tfnum++;
+
+			tmp = gtp_frame_next(tmp);
+			if (!tmp)
+				break;
+		} while (tmp != gtp_frame_w_start);
+#else
+		if (gtp_start) {
+			/* XXX: It is just the number of entries.  */
+			tfnum = (int)ring_buffer_entries(gtp_frame);
+		} else {
+			int	old_num = gtp_frame_current_num;
+			int	cpu;
+
+			gtp_frame_iter_reset();
+
+			for_each_online_cpu(cpu) {
+				char				*tmp;
+				struct ring_buffer_event	*rbe;
+
+				while (1) {
+					rbe = ring_buffer_read
+						(gtp_frame_iter[cpu], NULL);
+					if (rbe == NULL)
+						break;
+					tmp = ring_buffer_event_data(rbe);
+					if (FID(tmp) == FID_HEAD)
+						tfnum++;
+				}
+			}
+
+			if (old_num == -1)
+				gtp_frame_iter_reset();
+			else if (old_num >= 0) {
+				gtp_frame_head_find_num(old_num);
+				ring_buffer_read
+					(gtp_frame_iter[gtp_frame_current_cpu],
+					 NULL);
+			}
+		}
+#endif
+	}
+
+	sprintf(buf, "tframes:%x;", tfnum);
+	size += strlen(buf);
+	buf += strlen(buf);
+
+	sprintf(buf, "tcreated:%x;", atomic_read(&gtp_frame_create));
+	size += strlen(buf);
+	buf += strlen(buf);
+
+#ifdef GTP_FRAME_SIMPLE
+	sprintf(buf, "tsize:%x;", GTP_FRAME_SIZE);
+#else
+	if (gtp_frame)
+		sprintf(buf, "tsize:%lx;", ring_buffer_size(gtp_frame));
+	else
+		sprintf(buf, "tsize:%x;", GTP_FRAME_SIZE * num_online_cpus());
+#endif
+	size += strlen(buf);
+	buf += strlen(buf);
+
+#ifdef GTP_FRAME_SIMPLE
+	spin_lock(&gtp_frame_lock);
+	if (gtp_frame_is_circular)
+		tmpaddr = 0;
+	else
+		tmpaddr = GTP_FRAME_SIZE - (gtp_frame_w_start - gtp_frame);
+	spin_unlock(&gtp_frame_lock);
+#else
+	/* XXX: Ring buffer don't have interface to get the size of free
+	   buffer. */
+	tmpaddr = 0;
+#endif
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
+	uint64_t		val = 0;
+
+	pkg = hex2ulongest(pkg, &num);
+
+	if (num == GTP_VAR_CPU_NUMBER_ID) {
+		val = (uint64_t)gtp_cpu_number;
+		goto output_value;
+	} else if (num == GTP_VAR_LAST_ERRNO_ID) {
+		val = (uint64_t)gtp_start_last_errno;
+		goto output_value;
+	}
+
+#ifdef GTP_FRAME_SIMPLE
+	if (gtp_start || !gtp_frame_current) {
+#else
+	if (gtp_start || gtp_frame_current_num < 0) {
+#endif
+		if (num == GTP_VAR_CLOCK_ID) {
+			val = (uint64_t)GTP_LOCAL_CLOCK;
+			goto output_value;
+		} else if (num == GTP_VAR_RDTSC_ID) {
+			unsigned long long a;
+			rdtscll(a);
+			val = (uint64_t)a;
+			goto output_value;
+		} else if (num == GTP_VAR_XTIME_SEC_ID
+			   || num == GTP_VAR_XTIME_NSEC_ID) {
+			struct timespec	time;
+
+			getnstimeofday(&time);
+			if (num == GTP_VAR_XTIME_SEC_ID)
+				val = (uint64_t)time.tv_sec;
+			else
+				val = (uint64_t)time.tv_nsec;
+
+			goto output_value;
+		}
+
+		if (GTP_VAR_IS_SPECIAL(num))
+			goto out;
+		var = gtp_var_find(num);
+		if (var == NULL)
+			goto out;
+#ifdef CONFIG_PERF_EVENTS
+		if (var->ptid == pe_tv_val
+		    || var->ptid == pe_tv_enabled
+		    || var->ptid == pe_tv_running) {
+			if (gtp_start)
+				var->pts->val =
+					perf_event_read_value(var->pts->event,
+							&(var->pts->enabled),
+							&(var->pts->running));
+			switch (var->ptid) {
+			case pe_tv_val:
+				val = (uint64_t)(var->pts->val);
+				break;
+			case pe_tv_enabled:
+				val = (uint64_t)(var->pts->enabled);
+				break;
+			case pe_tv_running:
+				val = (uint64_t)(var->pts->running);
+				break;
+			default:
+				break;
+			}
+			goto out;
+		}
+#endif
+		val = var->val;
+	} else {
+#ifdef GTP_FRAME_SIMPLE
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
+#else
+		int				is_first = 1;
+		struct ring_buffer_event	*rbe;
+		char				*tmp;
+
+		/* Handle $cpu_id and $clock.  */
+		if (GTP_VAR_AUTO_TRACEV(num)) {
+			if (num == GTP_VAR_CLOCK_ID)
+				val = gtp_frame_current_clock;
+			else if (num == GTP_VAR_CPU_ID)
+				val = gtp_frame_current_cpu;
+			goto output_value;
+		}
+re_find:
+		while (1) {
+			rbe = ring_buffer_iter_peek
+				(gtp_frame_iter[gtp_frame_current_cpu], NULL);
+			if (rbe == NULL)
+				break;
+			tmp = ring_buffer_event_data(rbe);
+			if (FID(tmp) == FID_HEAD)
+				break;
+			if (FID(tmp) == FID_VAR) {
+				vr = (struct gtp_frame_var *)(tmp + FID_SIZE);
+				if (vr->num == (unsigned int)num)
+					goto while_stop;
+			}
+			ring_buffer_read(gtp_frame_iter[gtp_frame_current_cpu],
+					 NULL);
+		}
+		if (is_first) {
+			gtp_frame_head_find_num(gtp_frame_current_num);
+			ring_buffer_read(gtp_frame_iter[gtp_frame_current_cpu],
+					 NULL);
+			is_first = 0;
+			goto re_find;
+		}
+#endif
+		vr = NULL;
+while_stop:
+		if (vr)
+			val = vr->val;
+	}
+
+out:
+	if (var || vr) {
+output_value:
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
+#ifdef GTP_FRAME_SIMPLE
+	if (gtp_start || !gtp_frame_current) {
+#else
+	if (gtp_start || gtp_frame_current_num < 0) {
+#endif
+		if (probe_kernel_read(gtp_m_buffer, (void *)(CORE_ADDR)addr,
+					(size_t)len))
+			return -EFAULT;
+	} else {
+#ifdef GTP_FRAME_SIMPLE
+		char	*next;
+#endif
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
+#ifdef GTP_FRAME_SIMPLE
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
+#else
+		gtp_frame_head_find_num(gtp_frame_current_num);
+		ring_buffer_read(gtp_frame_iter[gtp_frame_current_cpu], NULL);
+
+		while (1) {
+			struct ring_buffer_event	*rbe;
+			char				*tmp;
+
+			rbe = ring_buffer_iter_peek
+				(gtp_frame_iter[gtp_frame_current_cpu], NULL);
+			if (rbe == NULL)
+				break;
+			tmp = ring_buffer_event_data(rbe);
+			if (FID(tmp) == FID_HEAD)
+				break;
+			if (FID(tmp) == FID_MEM) {
+				struct gtp_frame_mem	*mr;
+				ULONGEST		cur_start, cur_end;
+				uint8_t			*buf;
+
+				mr = (struct gtp_frame_mem *)
+				     (tmp + FID_SIZE);
+				buf = tmp + GTP_FRAME_MEM_SIZE;
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
+			ring_buffer_read(gtp_frame_iter[gtp_frame_current_cpu],
+					 NULL);
+		}
+#endif
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
+#ifdef GTP_FRAME_SIMPLE
+	char		*next;
+#endif
+	struct pt_regs	*regs;
+
+	if (GTP_RW_MAX - 4 - gtp_rw_size < GTP_REG_ASCII_SIZE)
+		return -E2BIG;
+
+#ifdef GTP_FRAME_SIMPLE
+	if (gtp_start || !gtp_frame_current) {
+#else
+	if (gtp_start || gtp_frame_current_num < 0) {
+#endif
+		memset(gtp_rw_bufp, '0', GTP_REG_ASCII_SIZE);
+		goto out;
+	}
+
+	/* Get the regs.  */
+	regs = NULL;
+#ifdef GTP_FRAME_SIMPLE
+	for (next = *(char **)(gtp_frame_current + FID_SIZE); next;
+	     next = *(char **)(next + FID_SIZE)) {
+		if (FID(next) == FID_REG) {
+			regs = (struct pt_regs *)
+			       (next + FID_SIZE + sizeof(char *));
+			break;
+		}
+	}
+#else
+	{
+		int				is_first = 1;
+		struct ring_buffer_event	*rbe;
+		char				*tmp;
+
+re_find:
+		while (1) {
+			rbe = ring_buffer_iter_peek
+				(gtp_frame_iter[gtp_frame_current_cpu], NULL);
+			if (rbe == NULL)
+				break;
+			tmp = ring_buffer_event_data(rbe);
+			if (FID(tmp) == FID_HEAD)
+				break;
+			if (FID(tmp) == FID_REG) {
+				regs = (struct pt_regs *)(tmp + FID_SIZE);
+				is_first = 0;
+				break;
+			}
+			ring_buffer_read(gtp_frame_iter[gtp_frame_current_cpu],
+					 NULL);
+		}
+		if (is_first) {
+			gtp_frame_head_find_num(gtp_frame_current_num);
+			ring_buffer_read(gtp_frame_iter[gtp_frame_current_cpu],
+					 NULL);
+			is_first = 0;
+			goto re_find;
+		}
+	}
+#endif
+	if (regs)
+		gtp_regs2ascii(regs, gtp_rw_bufp);
+	else {
+		struct pt_regs		pregs;
+		struct gtp_entry	*tpe;
+
+		memset(&pregs, '\0', sizeof(struct pt_regs));
+		tpe = gtp_list_find_without_addr(gtp_frame_current_tpe);
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
+static unsigned int	gtp_frame_count;
+
+static void
+gtp_frame_count_release(void)
+{
+	gtp_frame_count--;
+	if (gtp_frame_count == 0) {
+		if (!gtp_disconnected_tracing) {
+			gtp_gdbrsp_qtstop();
+			gtp_gdbrsp_qtinit();
+			if (gtp_frame) {
+#ifdef GTP_FRAME_SIMPLE
+				vfree(gtp_frame);
+#else
+				ring_buffer_free(gtp_frame);
+#endif
+				gtp_frame = NULL;
+			}
+		}
+	}
+}
+
+static int
+gtp_open(struct inode *inode, struct file *file)
+{
+	int	ret = 0;
+
+	down(&gtp_rw_lock);
+	if (gtp_gtp_pid >= 0) {
+		if (get_current()->pid != gtp_gtp_pid) {
+			ret = -EBUSY;
+			goto out;
+		}
+	}
+
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
+	gtp_frame_count++;
+
+	gtp_gtp_pid_count++;
+	if (gtp_gtp_pid < 0)
+		gtp_gtp_pid = get_current()->pid;
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
+	if (gtp_rw_count == 0)
+		vfree(gtp_rw_buf);
+
+	gtp_frame_count_release();
+
+	gtp_gtp_pid_count--;
+	if (gtp_gtp_pid_count == 0)
+		gtp_gtp_pid = -1;
+
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
+	size = min_t(size_t, size, GTP_RW_MAX);
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
+struct gtp_realloc_s {
+	char	*buf;
+	size_t	size;
+	size_t	real_size;
+};
+
+static char *
+gtp_realloc(struct gtp_realloc_s *grs, size_t size, int is_end)
+{
+	char	*tmp;
+
+	if ((grs->real_size < grs->size + size)
+	    || (is_end && grs->real_size != grs->size + size)) {
+		grs->real_size = grs->size + size;
+		if (!is_end)
+			grs->real_size += 100;
+
+		tmp = vmalloc(grs->real_size);
+		if (!tmp) {
+			vfree(grs->buf);
+			memset(grs, 0, sizeof(struct gtp_realloc_s));
+			return NULL;
+		}
+
+		memcpy(tmp, grs->buf, grs->size);
+		vfree(grs->buf);
+		grs->buf = tmp;
+	}
+
+	return grs->buf + grs->size;
+}
+
+static int
+gtp_frame2file_r(struct gtp_realloc_s *grs, uint32_t *data_size, char *frame)
+{
+	char	*wbuf;
+
+	wbuf = gtp_realloc(grs, GTP_REG_BIN_SIZE + 1, 0);
+	if (!wbuf)
+		return -1;
+
+	wbuf[0] = 'R';
+#ifdef GTP_FRAME_SIMPLE
+	gtp_regs2bin((struct pt_regs *)(frame + FID_SIZE + sizeof(char *)),
+		     wbuf + 1);
+#else
+	gtp_regs2bin((struct pt_regs *)(frame + FID_SIZE), wbuf + 1);
+#endif
+	grs->size += GTP_REG_BIN_SIZE + 1;
+
+	*data_size += GTP_REG_BIN_SIZE + 1;
+
+	return 0;
+}
+
+static int
+gtp_frame2file_m(struct gtp_realloc_s *grs, uint32_t *data_size, char *frame)
+{
+	struct gtp_frame_mem	*mr;
+	uint8_t			*buf;
+	ULONGEST		addr;
+	size_t			remaining;
+
+#ifdef GTP_FRAME_SIMPLE
+	mr = (struct gtp_frame_mem *) (frame + FID_SIZE + sizeof(char *));
+#else
+	mr = (struct gtp_frame_mem *) (frame + FID_SIZE);
+#endif
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
+		wbuf = gtp_realloc(grs, sp, 0);
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
+		grs->size += sp;
+		*data_size += sp;
+	}
+
+	return 0;
+}
+
+static int
+gtp_frame2file_v(struct gtp_realloc_s *grs, uint32_t *data_size, char *frame)
+{
+	struct gtp_frame_var	*vr;
+	size_t			sp = 1 + sizeof(unsigned int)
+				     + sizeof(uint64_t);
+	char			*wbuf;
+
+	wbuf = gtp_realloc(grs, sp, 0);
+	if (!wbuf)
+		return -1;
+
+#ifdef GTP_FRAME_SIMPLE
+	vr = (struct gtp_frame_var *) (frame + FID_SIZE + sizeof(char *));
+#else
+	vr = (struct gtp_frame_var *) (frame + FID_SIZE);
+#endif
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
+	grs->size += sp;
+	*data_size += sp;
+
+	return 0;
+}
+
+static int
+#ifdef GTP_FRAME_SIMPLE
+gtp_frame2file(struct gtp_realloc_s *grs, char *frame)
+#else
+gtp_frame2file(struct gtp_realloc_s *grs, int cpu)
+#endif
+{
+	int16_t				*tmp16p;
+	char				*next;
+	char				*wbuf;
+	uint32_t			data_size;
+#ifndef GTP_FRAME_SIMPLE
+	struct ring_buffer_event	*rbe;
+	u64				clock;
+#endif
+
+	/* Head.  */
+	tmp16p = (int16_t *)gtp_realloc(grs, 2, 0);
+	if (!tmp16p)
+		return -1;
+#ifdef GTP_FRAME_SIMPLE
+	*tmp16p = (int16_t)*(ULONGEST *)(frame + FID_SIZE + sizeof(char *));
+#else
+	rbe = ring_buffer_read(gtp_frame_iter[cpu], &clock);
+	if (rbe == NULL) {
+		/* It will not happen, just for safe.  */
+		return -1;
+	}
+	next = ring_buffer_event_data(rbe);
+	*tmp16p = (int16_t)*(ULONGEST *)(next + FID_SIZE);
+#endif
+	grs->size += 2;
+	/* This part is for the data_size.  */
+	wbuf = gtp_realloc(grs, 4, 0);
+	if (!wbuf)
+		return -1;
+	grs->size += 4;
+
+	/* Body.  */
+	data_size = 0;
+
+#ifndef GTP_FRAME_SIMPLE
+	{
+		/* Handle $cpu_id and $clock.  */
+		struct gtp_frame_var	*vr;
+		char			frame[GTP_FRAME_VAR_SIZE];
+
+
+		vr = (struct gtp_frame_var *) (frame + FID_SIZE);
+		vr->num = GTP_VAR_CLOCK_ID;
+		vr->val = clock;
+		if (gtp_frame2file_v(grs, &data_size, frame))
+			return -1;
+		vr->num = GTP_VAR_CPU_ID;
+		vr->val = cpu;
+		if (gtp_frame2file_v(grs, &data_size, frame))
+			return -1;
+	}
+#endif
+
+#ifdef GTP_FRAME_SIMPLE
+	for (next = *(char **)(frame + FID_SIZE); next;
+	     next = *(char **)(next + FID_SIZE)) {
+#else
+	while (1) {
+		rbe = ring_buffer_iter_peek(gtp_frame_iter[cpu], NULL);
+		if (rbe == NULL)
+			break;
+		next = ring_buffer_event_data(rbe);
+#endif
+		switch (FID(next)) {
+		case FID_REG:
+			if (gtp_frame2file_r(grs, &data_size, next))
+				return -1;
+			break;
+
+		case FID_MEM:
+			if (gtp_frame2file_m(grs, &data_size, next))
+				return -1;
+			break;
+
+		case FID_VAR:
+			if (gtp_frame2file_v(grs, &data_size, next))
+				return -1;
+			break;
+
+#ifndef GTP_FRAME_SIMPLE
+		case FID_HEAD:
+			goto out;
+			break;
+#endif
+		}
+#ifndef GTP_FRAME_SIMPLE
+		ring_buffer_read(gtp_frame_iter[cpu], NULL);
+#endif
+	}
+
+#ifndef GTP_FRAME_SIMPLE
+out:
+#endif
+	/* Set the data_size.  */
+	memcpy(grs->buf + grs->size - data_size - 4,
+	       &data_size, 4);
+
+	return 0;
+}
+
+static int
+gtp_frame_file_header(struct gtp_realloc_s *grs, int is_end)
+{
+	char			*wbuf;
+	struct gtp_entry	*tpe;
+	struct gtp_var		*tvar;
+	int			tmpsize;
+	char			tmpbuf[200];
+	int			ret = -1;
+
+	/* Head. */
+	wbuf = gtp_realloc(grs, 8, 0);
+	strcpy(wbuf, "\x7fTRACE0\n");
+	grs->size += 8;
+
+	/* BUG: will be a new value.  */
+	snprintf(tmpbuf, 200, "R %x\n", GTP_REG_BIN_SIZE);
+	wbuf = gtp_realloc(grs, strlen(tmpbuf), 0);
+	if (!wbuf)
+		goto out;
+	strcpy(wbuf, tmpbuf);
+	grs->size += strlen(tmpbuf);
+
+	strcpy(tmpbuf, "status 0;");
+	wbuf = gtp_realloc(grs, strlen(tmpbuf), 0);
+	if (!wbuf)
+		goto out;
+	strcpy(wbuf, tmpbuf);
+	grs->size += strlen(tmpbuf);
+
+	for (tpe = gtp_list; tpe; tpe = tpe->next) {
+		if (tpe->reason != gtp_stop_normal)
+			break;
+	}
+	tmpsize = gtp_get_status(tpe, tmpbuf);
+	wbuf = gtp_realloc(grs, tmpsize, 0);
+	if (!wbuf)
+		goto out;
+	memcpy(wbuf, tmpbuf, tmpsize);
+	grs->size += tmpsize;
+
+	wbuf = gtp_realloc(grs, 1, 0);
+	if (!wbuf)
+		goto out;
+	wbuf[0] = '\n';
+	grs->size += 1;
+
+	/* Tval. */
+	for (tvar = gtp_var_list; tvar; tvar = tvar->next) {
+		snprintf(tmpbuf, 200, "tsv %x:%s\n", tvar->num, tvar->src);
+		wbuf = gtp_realloc(grs, strlen(tmpbuf), 0);
+		if (!wbuf)
+			goto out;
+		strcpy(wbuf, tmpbuf);
+		grs->size += strlen(tmpbuf);
+	}
+
+	/* Tracepoint.  */
+	for (tpe = gtp_list; tpe; tpe = tpe->next) {
+		struct action	*ae;
+		struct gtpsrc	*src;
+
+		/* Tpe.  */
+		gtp_report_tracepoint(tpe, tmpbuf);
+		wbuf = gtp_realloc(grs, strlen(tmpbuf) + 5, 0);
+		if (!wbuf)
+			goto out;
+		sprintf(wbuf, "tp %s\n", tmpbuf);
+		grs->size += strlen(tmpbuf) + 4;
+		/* Action.  */
+		for (ae = tpe->action_list; ae; ae = ae->next) {
+			gtp_report_action(tpe, ae, tmpbuf);
+			wbuf = gtp_realloc(grs, strlen(tmpbuf) + 5, 0);
+			if (!wbuf)
+				goto out;
+			sprintf(wbuf, "tp %s\n", tmpbuf);
+			grs->size += strlen(tmpbuf) + 4;
+		}
+		/* Src.  */
+		for (src = tpe->src; src; src = src->next) {
+			gtp_report_src(tpe, src, tmpbuf);
+			wbuf = gtp_realloc(grs, strlen(tmpbuf) + 5, 0);
+			if (!wbuf)
+				goto out;
+			sprintf(wbuf, "tp %s\n", tmpbuf);
+			grs->size += strlen(tmpbuf) + 4;
+		}
+	}
+
+	wbuf = gtp_realloc(grs, 1, is_end);
+	if (!wbuf)
+		goto out;
+	wbuf[0] = '\n';
+	grs->size += 1;
+
+	ret = 0;
+out:
+	return ret;
+}
+
+static ssize_t
+gtpframe_read(struct file *file, char __user *buf, size_t size,
+	      loff_t *ppos)
+{
+	ssize_t	ret = -ENOMEM;
+#ifndef GTP_FRAME_SIMPLE
+	int	old_num = -2;
+#endif
+
+recheck:
+	down(&gtp_rw_lock);
+	if (gtp_start) {
+		up(&gtp_rw_lock);
+		if (wait_event_interruptible(gtpframe_wq,
+					     !gtp_start) == -ERESTARTSYS)
+			return -ERESTARTSYS;
+#ifdef GTP_DEBUG
+		printk(GTP_DEBUG "gtpframe_read: goto recheck\n");
+#endif
+		goto recheck;
+	}
+
+	/* Set gtp_frame_file if need.  */
+	if (!gtp_frame_file) {
+		char			*wbuf;
+#ifdef GTP_FRAME_SIMPLE
+		char			*frame;
+#endif
+		struct gtp_realloc_s	gr;
+
+#ifdef GTP_FRAME_SIMPLE
+		if (gtp_frame_is_circular)
+			gr.real_size = GTP_FRAME_SIZE;
+		else
+			gr.real_size = gtp_frame_w_start - gtp_frame;
+#else
+		gr.real_size =
+			ring_buffer_entries(gtp_frame) * GTP_FRAME_HEAD_SIZE;
+#endif
+		gr.real_size += 200;
+		gr.buf = vmalloc(gr.real_size);
+		if (!gr.buf)
+			goto out;
+		gr.size = 0;
+
+		if (gtp_frame_file_header(&gr, 0))
+			goto out;
+
+		/* Frame.  */
+		if (atomic_read(&gtp_frame_create) == 0)
+			goto end;
+#ifdef GTP_FRAME_SIMPLE
+		frame = gtp_frame_r_start;
+		do {
+			if (frame == gtp_frame_end)
+				frame = gtp_frame;
+
+			if (FID(frame) == FID_HEAD) {
+				if (gtp_frame2file(&gr, frame))
+					goto out;
+			}
+
+			frame = gtp_frame_next(frame);
+			if (!frame)
+				break;
+		} while (frame != gtp_frame_w_start);
+#else
+		old_num = gtp_frame_current_num;
+		gtp_frame_iter_reset();
+		while (1) {
+			int	cpu;
+
+			cpu = gtp_frame_iter_peek_head();
+			if (cpu < 0)
+				break;
+
+			if (gtp_frame2file(&gr, cpu))
+				goto out;
+		}
+#endif
+
+end:
+		/* End.  */
+		wbuf = gtp_realloc(&gr, 2, 1);
+		if (!wbuf)
+			goto out;
+		wbuf[0] = '\0';
+		wbuf[1] = '\0';
+		gr.size += 2;
+
+		gtp_frame_file = gr.buf;
+		gtp_frame_file_size = gr.size;
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
+#ifndef GTP_FRAME_SIMPLE
+	if (old_num == -1)
+		gtp_frame_iter_reset();
+	else if (old_num >= 0) {
+		gtp_frame_head_find_num(old_num);
+		ring_buffer_read(gtp_frame_iter[gtp_frame_current_cpu], NULL);
+	}
+#endif
+	up(&gtp_rw_lock);
+	return ret;
+}
+
+static int
+gtpframe_open(struct inode *inode, struct file *file)
+{
+recheck:
+	down(&gtp_rw_lock);
+	if (!gtp_frame) {
+		up(&gtp_rw_lock);
+		if (wait_event_interruptible(gtpframe_wq,
+					     gtp_frame) == -ERESTARTSYS)
+			return -ERESTARTSYS;
+#ifdef GTP_DEBUG
+		printk(GTP_DEBUG "gtpframe_open: goto recheck\n");
+#endif
+		goto recheck;
+	}
+
+	if (gtp_gtpframe_pid >= 0) {
+		if (get_current()->pid != gtp_gtpframe_pid) {
+			up(&gtp_rw_lock);
+			return -EBUSY;
+		}
+	}
+
+	gtp_frame_count++;
+
+	gtp_gtpframe_pid_count++;
+	if (gtp_gtpframe_pid < 0)
+		gtp_gtpframe_pid = get_current()->pid;
+
+	up(&gtp_rw_lock);
+	return 0;
+}
+
+static int
+gtpframe_release(struct inode *inode, struct file *file)
+{
+	down(&gtp_rw_lock);
+	gtp_frame_count_release();
+
+	gtp_gtpframe_pid_count--;
+	if (gtp_gtpframe_pid_count == 0)
+		gtp_gtpframe_pid = -1;
+	up(&gtp_rw_lock);
+
+	return 0;
+}
+
+#ifndef GTP_FRAME_SIMPLE
+struct gtpframe_pipe_s {
+	loff_t			begin;
+	struct gtp_realloc_s	*grs;
+	int			llseek_move;
+};
+
+static int	gtpframe_pipe_is_running;
+
+static int
+gtpframe_pipe_open(struct inode *inode, struct file *file)
+{
+	int			ret = -ENOMEM;
+	struct gtpframe_pipe_s	*gps = NULL;
+
+	/* Check gtpframe_pipe_is_running.  */
+	down(&gtp_rw_lock);
+	if (gtpframe_pipe_is_running) {
+		up(&gtp_rw_lock);
+		return -EBUSY;
+	}
+	gtpframe_pipe_is_running = 1;
+
+recheck:
+	if (!gtp_frame) {
+		up(&gtp_rw_lock);
+		atomic_inc(&gtpframe_pipe_wq_v);
+		if (wait_event_interruptible(gtpframe_pipe_wq,
+					     gtp_frame) == -ERESTARTSYS)
+			return -ERESTARTSYS;
+#ifdef GTP_DEBUG
+		printk(GTP_DEBUG "gtpframe_pipe_open: goto recheck\n");
+#endif
+		down(&gtp_rw_lock);
+		goto recheck;
+	}
+
+	if (gtp_gtpframe_pipe_pid >= 0) {
+		if (get_current()->pid != gtp_gtpframe_pipe_pid) {
+			ret = -EBUSY;
+			goto out;
+		}
+	}
+
+	gps = kmalloc(sizeof(struct gtpframe_pipe_s), GFP_KERNEL);
+	if (gps == NULL)
+		goto out;
+	memset(gps, 0, sizeof(struct gtpframe_pipe_s));
+	gps->grs = kmalloc(sizeof(struct gtp_realloc_s), GFP_KERNEL);
+	if (gps->grs == NULL)
+		goto out;
+	memset(gps->grs, 0, sizeof(struct gtp_realloc_s));
+
+	file->private_data = gps;
+
+	gtp_frame_count++;
+
+	gtp_gtpframe_pipe_pid_count++;
+	if (gtp_gtpframe_pipe_pid < 0)
+		gtp_gtpframe_pipe_pid = get_current()->pid;
+
+	ret = 0;
+out:
+	if (ret && gps) {
+		kfree(gps->grs);
+		kfree(gps);
+	}
+	up(&gtp_rw_lock);
+	return ret;
+}
+
+static int
+gtpframe_pipe_release(struct inode *inode, struct file *file)
+{
+	struct gtpframe_pipe_s	*gps = file->private_data;
+
+	down(&gtp_rw_lock);
+	gtp_frame_count_release();
+
+	gtp_gtpframe_pipe_pid_count--;
+	if (gtp_gtpframe_pipe_pid_count == 0)
+		gtp_gtpframe_pipe_pid = -1;
+
+	gtpframe_pipe_is_running = 0;
+
+	up(&gtp_rw_lock);
+
+	if (gps) {
+		if (gps->grs) {
+			if (gps->grs->buf)
+				vfree(gps->grs->buf);
+			kfree(gps->grs);
+		}
+		kfree(gps);
+	}
+
+	return 0;
+}
+
+static int
+gtpframe_pipe_peek(void)
+{
+	u64				min = 0;
+	u64				ts;
+	int				cpu;
+	struct ring_buffer_event	*rbe;
+	char				*next;
+	int				ret = -1;
+
+	for_each_online_cpu(cpu) {
+		while (1) {
+			rbe = ring_buffer_peek(gtp_frame, cpu, &ts, NULL);
+			if (rbe == NULL)
+				break;
+			next = ring_buffer_event_data(rbe);
+			if (FID(next) == FID_HEAD)
+				break;
+			ring_buffer_consume(gtp_frame, cpu, &ts, NULL);
+		}
+
+		if (rbe) {
+			if ((min && ts < min) || !min) {
+				min = ts;
+				ret = cpu;
+			}
+		}
+	}
+
+	return ret;
+}
+
+static int
+gtpframe_pipe_get_entry(struct gtp_realloc_s *grs)
+{
+	int				cpu;
+	struct ring_buffer_event	*rbe;
+	char				*next;
+	u64				ts;
+	int16_t				*tmp16p;
+	uint32_t			data_size;
+
+	grs->size = 0;
+
+recheck:
+#define GTP_PIPE_PEEK	(cpu = gtpframe_pipe_peek())
+	GTP_PIPE_PEEK;
+	if (cpu < 0) {
+		/* Didn't get the buffer that have event.
+		   Wait and recheck.*/
+		atomic_inc(&gtpframe_pipe_wq_v);
+		if (wait_event_interruptible(gtpframe_pipe_wq,
+					     GTP_PIPE_PEEK >= 0)
+			== -ERESTARTSYS)
+			return -ERESTARTSYS;
+	}
+#undef GTP_PIPE_PEEK
+
+	/* Head.  */
+	rbe = ring_buffer_consume(gtp_frame, cpu, &ts, NULL);
+	if (rbe == NULL)
+		goto recheck;
+	next = ring_buffer_event_data(rbe);
+	if (FID(next) != FID_HEAD)
+		goto recheck;
+	tmp16p = (int16_t *)gtp_realloc(grs, 2, 0);
+	if (!tmp16p)
+		return -ENOMEM;
+	*tmp16p = (int16_t)*(ULONGEST *)(next + FID_SIZE);
+	grs->size += 2;
+	/* This part is for the data_size.  */
+	if (gtp_realloc(grs, 4, 0) == NULL)
+		return -ENOMEM;
+	grs->size += 4;
+	data_size = 0;
+
+	{
+		/* Handle $cpu_id and $clock.  */
+		struct gtp_frame_var	*vr;
+		char			frame[GTP_FRAME_VAR_SIZE];
+
+
+		vr = (struct gtp_frame_var *) (frame + FID_SIZE);
+		vr->num = GTP_VAR_CLOCK_ID;
+		vr->val = ts;
+		if (gtp_frame2file_v(grs, &data_size, frame))
+			return -ENOMEM;
+		vr->num = GTP_VAR_CPU_ID;
+		vr->val = cpu;
+		if (gtp_frame2file_v(grs, &data_size, frame))
+			return -ENOMEM;
+	}
+
+	while (1) {
+#define GTP_PIPE_CONSUME (rbe = ring_buffer_consume(gtp_frame, cpu,
NULL, NULL))
+		GTP_PIPE_CONSUME;
+		if (rbe == NULL) {
+			if (!gtp_start)
+				break;
+
+			atomic_inc(&gtpframe_pipe_wq_v);
+			if (wait_event_interruptible(gtpframe_pipe_wq,
+							GTP_PIPE_CONSUME
+							!= NULL)
+					== -ERESTARTSYS)
+				return -ERESTARTSYS;
+			continue;
+		}
+#undef GTP_PIPE_CONSUME
+		next = ring_buffer_event_data(rbe);
+
+		switch (FID(next)) {
+		case FID_REG:
+			if (gtp_frame2file_r(grs, &data_size, next))
+				return -ENOMEM;
+			break;
+
+		case FID_MEM:
+			if (gtp_frame2file_m(grs, &data_size, next))
+				return -ENOMEM;
+			break;
+
+		case FID_VAR:
+			if (gtp_frame2file_v(grs, &data_size, next))
+				return -ENOMEM;
+			break;
+
+		case FID_HEAD:
+		case FID_END:
+			goto while_out;
+			break;
+		}
+	}
+while_out:
+	/* Set the data_size.  */
+	memcpy(grs->buf + grs->size - data_size - 4, &data_size, 4);
+
+	return 0;
+}
+
+static ssize_t
+gtpframe_pipe_read(struct file *file, char __user *buf, size_t size,
+		   loff_t *ppos)
+{
+	ssize_t			ret = -ENOMEM;
+	struct gtpframe_pipe_s	*gps = file->private_data;
+	loff_t			entry_offset;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtpframe_pipe_read: size=%u *ppos=%lld\n",
+	       size, *ppos);
+#endif
+
+	if (gps->grs->buf == NULL) {
+		gps->grs->real_size = 200;
+		gps->grs->buf = vmalloc(gps->grs->real_size);
+		if (!gps->grs->buf)
+			goto out;
+		gps->grs->size = 0;
+	} else if (*ppos < gps->begin
+		   || *ppos >= (gps->begin + gps->grs->size)) {
+		gps->grs->size = 0;
+
+		if (gps->llseek_move) {
+			if (clear_user(buf, size)) {
+				ret = -EFAULT;
+				goto out;
+			}
+			gps->begin = 0;
+			gps->llseek_move = 0;
+			ret = size;
+			goto out;
+		}
+	}
+
+	if (gps->grs->size == 0) {
+		if (*ppos == 0) {
+
+			if (gtp_frame_file_header(gps->grs, 1))
+				goto out;
+#ifdef GTP_DEBUG
+			printk(GTP_DEBUG "gtpframe_pipe_read: Get header.\n");
+#endif
+		} else {
+			ret = gtpframe_pipe_get_entry(gps->grs);
+			if (ret < 0)
+				goto out;
+#ifdef GTP_DEBUG
+			printk(GTP_DEBUG "gtpframe_pipe_read: Get entry.\n");
+#endif
+		}
+		gps->begin = *ppos;
+	}
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtpframe_pipe_read: gps->begin=%lld "
+			 "gps->grs->size=%u\n",
+	       gps->begin, gps->grs->size);
+#endif
+
+	entry_offset = *ppos - gps->begin;
+	ret = size;
+	if (entry_offset + size > gps->grs->size)
+		ret = gps->grs->size - entry_offset;
+	if (copy_to_user(buf, gps->grs->buf + entry_offset, ret)) {
+		ret = -EFAULT;
+		goto out;
+	}
+	*ppos += ret;
+
+out:
+	return ret;
+}
+
+static loff_t
+gtpframe_pipe_llseek(struct file *file, loff_t offset, int origin)
+{
+	struct gtpframe_pipe_s	*gps = file->private_data;
+	loff_t			ret = default_llseek(file, offset, origin);
+
+	if (ret < 0)
+		return ret;
+
+	if (ret >= gps->begin + gps->grs->size && gps->begin)
+		gps->llseek_move = 1;
+
+	return ret;
+}
+#endif
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
+	.open		= gtpframe_open,
+	.release	= gtpframe_release,
+	.read		= gtpframe_read,
+	.llseek		= default_llseek,
+};
+
+#ifndef GTP_FRAME_SIMPLE
+static const struct file_operations gtpframe_pipe_operations = {
+	.owner		= THIS_MODULE,
+	.open		= gtpframe_pipe_open,
+	.release	= gtpframe_pipe_release,
+	.read		= gtpframe_pipe_read,
+	.llseek		= gtpframe_pipe_llseek,
+};
+#endif
+
+struct dentry	*gtp_dir;
+struct dentry	*gtpframe_dir;
+#ifndef GTP_FRAME_SIMPLE
+struct dentry	*gtpframe_pipe_dir;
+#endif
+
+static int __init gtp_init(void)
+{
+	int		ret = -ENOMEM;
+
+	gtp_gtp_pid = -1;
+	gtp_gtp_pid_count = 0;
+	gtp_gtpframe_pid = -1;
+	gtp_gtpframe_pid_count = 0;
+#ifndef GTP_FRAME_SIMPLE
+	gtp_gtpframe_pipe_pid = -1;
+	gtp_gtpframe_pipe_pid_count = 0;
+#endif
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
+	gtp_frame_current_num = -1;
+	gtp_frame_current_tpe = 0;
+#ifdef GTP_FRAME_SIMPLE
+	gtp_frame_r_start = NULL;
+	gtp_frame_w_start = NULL;
+	gtp_frame_end = NULL;
+	gtp_frame_current = NULL;
+	gtp_frame_is_circular = 0;
+#else
+	{
+		int	cpu;
+
+		for_each_online_cpu(cpu)
+			gtp_frame_iter[cpu] = NULL;
+	}
+	gtp_frame_current_cpu = 0;
+	atomic_set(&gtpframe_pipe_wq_v, 0);
+	gtpframe_pipe_is_running = 0;
+#endif
+	atomic_set(&gtp_frame_create, 0);
+	gtp_rw_count = 0;
+	gtp_frame_count = 0;
+	current_gtp = NULL;
+	current_gtp_action = NULL;
+	current_gtp_src = NULL;
+	gtpro_list = NULL;
+	gtp_frame_file = NULL;
+	gtp_frame_file_size = 0;
+	gtp_dir = NULL;
+	gtpframe_dir = NULL;
+#ifndef GTP_FRAME_SIMPLE
+	gtpframe_pipe_dir = NULL;
+#endif
+	{
+		int	cpu;
+
+		gtp_cpu_number = 0;
+		for_each_online_cpu(cpu) {
+			if (cpu > gtp_cpu_number)
+				gtp_cpu_number = cpu;
+		}
+		gtp_cpu_number++;
+	}
+	gtp_start_last_errno = 0;
+	gtp_start_ignore_error = 0;
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
+#ifndef GTP_FRAME_SIMPLE
+	gtpframe_pipe_dir = debugfs_create_file("gtpframe_pipe",
+						S_IFIFO | S_IRUSR, NULL, NULL,
+						&gtpframe_pipe_operations);
+	if (gtpframe_pipe_dir == NULL
+	    || gtpframe_pipe_dir == ERR_PTR(-ENODEV)) {
+		gtpframe_pipe_dir = NULL;
+		goto out;
+	}
+#endif
+
+	ret = 0;
+out:
+	if (ret < 0) {
+		if (gtp_wq)
+			destroy_workqueue(gtp_wq);
+
+		if (gtp_dir)
+			debugfs_remove_recursive(gtp_dir);
+		if (gtpframe_dir)
+			debugfs_remove_recursive(gtpframe_dir);
+#ifndef GTP_FRAME_SIMPLE
+		if (gtpframe_pipe_dir)
+			debugfs_remove_recursive(gtpframe_pipe_dir);
+#endif
+	}
+
+	return ret;
+}
+
+static void __exit gtp_exit(void)
+{
+	if (gtp_dir)
+		debugfs_remove_recursive(gtp_dir);
+	if (gtpframe_dir)
+		debugfs_remove_recursive(gtpframe_dir);
+#ifndef GTP_FRAME_SIMPLE
+	if (gtpframe_pipe_dir)
+		debugfs_remove_recursive(gtpframe_pipe_dir);
+#endif
+
+	gtp_gdbrsp_qtstop();
+	gtp_gdbrsp_qtinit();
+	if (gtp_frame) {
+#ifdef GTP_FRAME_SIMPLE
+		vfree(gtp_frame);
+#else
+		ring_buffer_free(gtp_frame);
+#endif
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
