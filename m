Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab2DXNUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 09:20:53 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:63892 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab2DXNUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 09:20:51 -0400
Message-ID: <4F96A89C.7080901@mentor.com>
Date: Tue, 24 Apr 2012 21:20:28 +0800
From: Hui Zhu <hui_zhu@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
Subject: KGTP (Linux Kernel debugger and tracer) 20120424 release(doc update)[2/3]doc
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 24 Apr 2012 13:20:40.0159 (UTC) FILETIME=[0B3D86F0:01CD221D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hui Zhu <teawater@gmail.com>
---
  Documentation/gtp/howto.txt      | 1503 +++++++++++++++++++++++++++++++++++++++
  Documentation/gtp/howtocn.txt    | 1319 ++++++++++++++++++++++++++++++++++
  Documentation/gtp/quickstart.txt |  250 ++++++
  3 files changed, 3072 insertions(+)

--- /dev/null
+++ b/Documentation/gtp/howto.txt
@@ -0,0 +1,1503 @@
+		Linux Kernel GDB tracepoint module (KGTP)
+		=========================================
+		By Hui Zhu <teawater@gmail.com>
+		https://code.google.com/p/kgtp/wiki/HOWTO
+
+Update in 2012-04-24
+
+Table of contents
+-----------------
+
+What is KGTP
+Get help or report issues about KGTP
+Preparatory work before use KGTP
+Linux kernel
+If your system use the Linux kernel that is built by yourself
+If your system use the Linux kernel from distribution
+Get KGTP
+Get KGTP through http
+Get KGTP through svn
+Config KGTP
+Compile KGTP
+Normal compile
+Compile KGTP with some special config
+Install and uninstall KGTP
+Use KGTP with DKMS
+Use KGTP patch for Linux kernel
+Install GDB for KGTP
+Howto use
+Exec it
+Make GDB connect to gtp
+GDB on the current machine
+If GDB on remote machine
+Add module symbols to GDB
+How to use getmod.py
+How to use getmod
+Access memory directly
+GDB tracepoint
+Howto use GDB tracepoint
+actions [num]
+Start and stop the tracepoint
+Enable and disable the tracepoint
+tfind
+Use tracepoint get register info from a point of kernel
+Use tracepoint get the value of variable from a point of kernel
+How to use use tracepoint condition
+How to handle "Unsupported operator (null) (52) in expression."
+Show all the traced data of current frame
+Get status of tracepoint
+Set the trace buffer into a circular buffer
+Do not stop tracepoint when the GDB disconnects
+kprobes-optimization and the execution speed of tracepoint
+How to use trace state variables
+Simple trace state variables
+Per_cpu trace state variables
+Special trace state variables $current_task, $current_task_pid,
+$current_thread_info, $cpu_id, $dump_stack, $printk_level,
+$printk_format, $printk_tmp ,$clock, $hardirq_count, $softirq_count and
+$irq_count
+Special trace state variable $no_self_trace
+Trace the function return with $kret
+Use $ignore_error and $last_errno to ignore the error of tstart
+Use $cooked_clock and $cooked_rdtsc the time without KGTP used
+Use $xtime_sec and $xtime_nsec get the timespec
+Howto backtrace (stack dump)
+Collect stack with $bt and use GDB command "backtrace"
+Collect stack of current function's caller with $_ret
+Use $dump_stack to output stack dump through printk
+How to use performance counters
+Define a perf event trace state variable
+Define a per_cpu perf event trace state variable
+The perf event type and config
+Enable and disable all the perf event in a CPU with $pc_pe_en
+GDB scripts to help with set and get the perf event trace state
+variables
+Howto let tracepoint output value directly
+Switch collect to output the value directly
+Howto show a variable whose value has been optimized away
+Update your GCC
+How to get the function pointer point to
+If the debug info of the function pointer is not optimized out
+If the debug info of the function pointer is optimized out
+/sys/kernel/debug/gtpframe and offline debug
+How to use /sys/kernel/debug/gtpframe_pipe
+Get the frame info with GDB
+Get the frame info with cat
+Get the frame info with getframe
+Use $pipe_trace
+How to use add-ons/hotcode.py
+What is KGTP
+KGTP is a realtime and lightweight Linux debugger and tracer.
+
+It makes Linux Kernel supply a GDB remote debug interface. Then GDB in
+current machine or remote machine can debug and trace Linux through GDB
+tracepoint and some other functions without stopping the Linux Kernel.
+And even if the board doesn't have GDB on it and doesn't have interface
+for remote debug. It can debug the Linux Kernel using offline debug (See
+HOWTO#/sys/kernel/debug/gtpframe_and_offline_debug).
+And it can work with Android (See HowToUseKGTPinAndroid).
+Now, it supports X86-32, X86-64, MIPS and ARM.
+
+For new user of KGTP, please go to see Quickstart.
+
+Please go to UPDATE to get more info about KGTP update.
+
+Get help or report issues about KGTP
+You can post it to http://code.google.com/p/kgtp/issues/list, write
+Email to kgtp@freelists.org or write Email to teawater@gmail.com.
+The KGTP team will try our best to help you.
+
+Preparatory work before use KGTP
+Linux kernel
+If your system use the Linux kernel that is built by yourself
+To use KGTP, your Linux kernel need open following options:
+
+General setup  --->
+        [*] Kprobes
+
+Kernel hacking  --->
+        [*] Debug Filesystem
+        [*] Compile the kernel with debug info
+If your system use the Linux kernel from distribution
+You need install some Linux kernel package.
+
+Ubuntu
+Install the Linux kernel debug image
+1) Add debug source to the sources list of Ubuntu.
+
+Create an /etc/apt/sources.list.d/ddebs.list by running the following
+line at a terminal:
+echo "deb http://ddebs.ubuntu.com $(lsb_release -cs) main restricted
+universe multiverse" | \
+sudo tee -a /etc/apt/sources.list.d/ddebs.list
+Stable releases (not alphas and betas) require three more lines adding
+to the same file, which is done by the following terminal command:
+echo "deb http://ddebs.ubuntu.com $(lsb_release -cs)-updates main
+restricted universe multiverse
+deb http://ddebs.ubuntu.com $(lsb_release -cs)-security main restricted
+universe multiverse
+deb http://ddebs.ubuntu.com $(lsb_release -cs)-proposed main restricted
+universe multiverse" | \
+sudo tee -a /etc/apt/sources.list.d/ddebs.list
+Import the debug symbol archive signing key:
+sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 428D7C01
+Then run:
+sudo apt-get update
+
+2) Get Linux kernel debug image.
+
+sudo apt-get install linux-image-$(uname -r)-dbgsym
+Install the Linux kernel headers
+sudo apt-get install linux-headers-generic
+Install the Linux kernel source
+Install the source package:
+sudo apt-get install linux-source
+Uncompress the source package:
+sudo mkdir -p /build/buildd/
+sudo tar vxjf /usr/src/linux-source-$(uname -r | sed 's/-.*//').tar.bz2
+-C /build/buildd/
+sudo mv /build/buildd/linux-source-$(uname -r | sed 's/-.*//')
+/build/buildd/linux-$(uname -r | sed 's/-.*//')
+Fedora
+Install the Linux kernel debug image
+sudo yum --enablerepo=fedora-debuginfo install kernel-debuginfo
+Install the Linux kernel devel package
+sudo yum install kernel-devel-$(uname -r)
+Others
+You need install the Linux kernel debug image package and the Linux
+Kernel source.
+
+Get KGTP
+Get KGTP through http
+Please goto http://code.google.com/p/kgtp/downloads/list OR UPDATE to
+download the package.
+
+Get KGTP through svn
+Some people have trouble with access to KGTP website. You can access
+kgtp through svn:
+
+svn checkout http://kgtp.googlecode.com/svn/ kgtp-read-only
+kgtp-read-only/tags/ Present for each release of KGTP.
+kgtp-read-only/trunk/ Present for the main trunk of KGTP.
+
+Config KGTP
+Following part is the default config of KGTP inside the Makefile. With
+this config, KGTP will build together with current kernel that running
+on this machine.
+
+KERNELDIR := /lib/modules/`uname -r`/build
+CROSS_COMPILE :=
+KERELDIR is set to the directory which holds the kernel you want to
+build for. By default, it is set to the kernel that you are running.
+CROSS_COMPILE is set to the prefix name of compiler that you want to
+build KGTP. Empty to compile with your default compiler.
+ARCH is the architecture.
+
+Or you can choose which kernel you want build with and which compiler
+you want use by change Makefile.
+For example:
+
+KERNELDIR := /home/teawater/kernel/bamd64
+CROSS_COMPILE :=x86_64-glibc_std-
+ARCH := x86_64
+KERNELDIR is set to /home/teawater/kernel/bamd64. Compiler will use
+x86_64-glibc_std-gcc.
+
+Compile KGTP
+Normal compile
+cd kgtp/
+make
+Compile KGTP with some special config
+Most of time, KGTP can auto select right options to build with Various
+versions of Linux kernel.
+But if you want config special options with yourself, you can read
+following part:
+With this option, KGTP will not auto select any build options.
+
+make AUTO=0
+With this option, KGTP will use simple frame instead of KGTP ring
+buffer.
+The simple frame doesn't support gtpframe_pipe. It just for debug KGTP.
+
+make AUTO=0 FRAME_SIMPLE=1
+With this option, $clock will return rdtsc value instead of local_clock.
+
+make AUTO=0 CLOCK_CYCLE=1
+With this option, KGTP will use procfs instead of debugfs.
+
+make AUTO=0 USE_PROC=1
+The options can use together, for example:
+
+make AUTO=0 FRAME_SIMPLE=1 CLOCK_CYCLE=1
+Install and uninstall KGTP
+KGTP don't need to be install because it can insmod directly inside its
+directory (See HOWTO#Exec_it). But if you need, you can install it to
+your system.
+Install:
+
+cd kgtp/
+sudo make install
+Uninstall:
+
+cd kgtp/
+sudo make uninstall
+Use KGTP with DKMS
+You can use KGTP with DKMS if you want it.
+Following commands will copy the files of KGTP to the directory that
+DKMS need.
+
+cd kgtp/
+sudo make dkms
+Then you can use DKMS commands to control KGTP. Please goto
+http://linux.dell.com/dkms/manpage.html to see how to use DKMS.
+
+Use KGTP patch for Linux kernel
+Most of time, you don't need KGTP patch because KGTP can build as a LKM
+and very easy to use. But to help some people include KGTP to them
+special Linux Kernel tree, KGTP supply patches for Linux kernel.
+In the KGTP directory:
+gtp_for_review.patch is the patch for Linux kernel upstream.
+gtp_3.0_to_upstream.patch is the patch for Linux kernel from 3.0 to
+upstream.
+gtp_2.6.39.patch is the patch for Linux kernel 2.6.39.
+gtp_2.6.33_to_2.6.38.patch is the patch for Linux kernel from 2.6.33 to
+2.6.38.
+gtp_older_to_2.6.32.patch is the patch for Linux kernel 2.6.32 and older
+version.
+Install GDB for KGTP
+The GDB that older than 7.3 have some bugs of tracepoint. And some
+functions of GDB are not very well.
+So if your GDB is older than 7.3 please go to
+https://code.google.com/p/gdbt/ to get howto install GDB for KGTP.
+If you have issue about GDB please get help according to
+HOWTO#Report_issues_about_KGTP.
+
+Howto use
+Exec it
+If you have installed KGTP in your system, you can:
+
+sudo modprobe gtp
+Or you can use the kgtp module in the directory.
+
+cd kgtp/
+sudo insmod gtp.ko
+Make GDB connect to gtp
+GDB on the current machine
+sudo gdb ./vmlinux
+(gdb) target remote /sys/kernel/debug/gtp
+Remote debugging using /sys/kernel/debug/gtp
+0x0000000000000000 in ?? ()
+After that, you can begin to use GDB command trace and debug the Linux
+Kernel.
+
+If GDB on remote machine
+#Open the KGTP interface in current machine.
+sudo su
+nc -l 1234 </sys/kernel/debug/gtp >/sys/kernel/debug/gtp
+(nc -l -p 1234 </sys/kernel/debug/gtp >/sys/kernel/debug/gtp for old
+version netcat.)
+#Let gdb connect to the port 1234
+gdb ./vmlinux
+(gdb) target remote xxx.xxx.xxx.xxx:1234
+After that, you can begin to use GDB command trace and debug the Linux
+Kernel.
+
+Add module symbols to GDB
+Sometimes you need to add a Linux kernel module's symbols to GDB to
+debug it.
+Add symbols with hand is not very easy, so KGTP package include an GDB
+python script "getmod.py" and a program "getmod" can help you.
+
+How to use getmod.py
+Connect to KGTP before use the getmod.py.
+
+(gdb) source ~/kgtp/getmod.py
+Then this script will auto load the Linux kernel module's symbols to
+GDB.
+
+How to use getmod
+"getmod" is written by C so you can use it anywhere even if in an
+embedded environment.
+For example:
+
+#Following command save Linux Kernel module info to the file ~/tmp/mi in
+GDB
+#command format.
+sudo getmod >~/tmp/mi
+#in gdb part:
+(gdb) source ~/tmp/mi
+add symbol table from file
+"/lib/modules/2.6.39-rc5+/kernel/fs/nls/nls_iso8859-1.ko" at
+        .text_addr = 0xf80de000
+        .note.gnu.build-id_addr = 0xf80de088
+        .exit.text_addr = 0xf80de074
+        .init.text_addr = 0xf8118000
+        .rodata.str1.1_addr = 0xf80de0ac
+        .rodata_addr = 0xf80de0c0
+        __mcount_loc_addr = 0xf80de9c0
+        .data_addr = 0xf80de9e0
+        .gnu.linkonce.this_module_addr = 0xf80dea00
+#After this GDB command, all the Linux Kernel module info is loaded into
+GDB.
+If you use remote debug or offline debug, maybe you need change the base
+directory. Following example is for it.
+
+#/lib/modules/2.6.39-rc5+/kernel is replaced to sudo ./getmod -r
+/home/teawater/kernel/b26
+sudo ./getmod -r /home/teawater/kernel/b26 >~/tmp/mi
+Access memory directly
+After connect the KGTP, you can access most of memory directly.
+For example, you can access to "jiffies_64" with following command:
+
+(gdb) p jiffies_64
+Or you can access to the first entry of "static LIST_HEAD(modules)" with
+following command:
+
+(gdb) p *((struct module *)((char *)modules->next - ((size_t) &(((struct
+module *)0)->list))))
+Or you can access to the CPU0 memory info of "DEFINE_PER_CPU(struct
+device , mce_device);":
+
+p *(struct device *)(__per_cpu_offset[0]+(uint64_t)(&mce_device))
+GDB tracepoint
+Tracepoint is that GDB define some addresses and some actions and put
+them to the target (KGTP). After tracepoint start, , KGTP will do these
+actions (Some of them will collect data and save them to tracepoint
+frame buffer) when Linux kernel execution to there addresses. After
+that, Linux kernel will keep execution.
+KGTP supply some interfaces that GDB or other programe can take the data
+of tracepoint frame buffer out to parse.
+About these interfaces, this doc have introduced
+"/sys/kernel/debug/gtp". And will introduce "/sys/kernel/debug/gtpframe"
+and "/sys/kernel/debug/gtpframe_pipe" later.
+
+Howto use GDB tracepoint
+Please goto
+http://sourceware.org/gdb/current/onlinedocs/gdb/Tracepoints.html.
+
+trace location
+The trace command is very similar to the break command. Its argument
+location can be a source line, a function name, or an address in the
+target program. The trace command defines a tracepoint, which is a
+address or some addresses that KGTP do some actions in it.
+Here are some examples of using the trace command:
+
+(gdb) trace foo.c:121    // a source file and line number
+
+(gdb) trace +2           // 2 lines forward
+
+(gdb) trace my_function  // first source line of function
+
+(gdb) trace *my_function // EXACT start address of function
+
+(gdb) trace *0x2117c4    // an address
+actions [num]
+This command will prompt for a list of actions to be taken when the
+tracepoint is hit. If the tracepoint number num is not specified, this
+command sets the actions for the one that was most recently defined (so
+that you can define a tracepoint and then say actions without bothering
+about its number). You specify the actions themselves on the following
+lines, one action at a time, and terminate the actions list with a line
+containing just end. So far, the only defined actions are collect,
+teval, and while-stepping.
+
+collect expr1, expr2, ...
+Collect values of the given expressions when the tracepoint is hit. This
+command accepts a comma-separated list of any valid expressions. In
+addition to global, static, or local variables, the following special
+arguments are supported:
+
+$regs   Collect all registers.
+$args   Collect all function arguments.
+$locals Collect all local variables.
+teval expr1, expr2, ...
+Evaluate the given expressions when the tracepoint is hit. This command
+accepts a comma-separated list of expressions. The results are
+discarded, so this is mainly useful for assigning values to trace state
+variables (see HOWTO#Simple_trace_state_variables) without adding those
+values to the trace buffer, as would be the case if the collect action
+were used.
+
+while-stepping n
+Please goto
+HOWTO#If_the_debug_info_of_the_function_pointer_is_optimized_out see
+howto use it.
+
+Start and stop the tracepoint
+Tracepoint will exec actions only when it is starting use this GDB
+command:
+
+(gdb) tstart
+It will stop by this GDB command:
+
+(gdb) tstop
+Enable and disable the tracepoint
+Like breakpoint, tracepoint can be control by GDB commands "enable" and
+"disable". But please note that it only useful when tracepoint stop.
+
+tfind
+GDB command "tfind" is used to select a entry of trace frame bufffer
+when tracepoint stop.
+Please goto http://sourceware.org/gdb/current/onlinedocs/gdb/tfind.html
+get more info about it.
+
+Use tracepoint get register info from a point of kernel
+The following is an example that records the value of all registers when
+"vfs_readdir" is called.
+
+(gdb) target remote /sys/kernel/debug/gtp
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
+#0  0xc01a1ac1 in vfs_readdir (file=0xc5528d00, filler=0xc01a1900
+<filldir64>,
+   buf=0xc0d09f90) at /home/teawater/kernel/linux-2.6/fs/readdir.c:23
+23      /home/teawater/kernel/linux-2.6/fs/readdir.c: No such file or
+directory.
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
+Use tracepoint get the value of variable from a point of kernel
+The following is an example that records the value of "jiffies_64" when
+the function "vfs_readdir" is called:
+
+(gdb) target remote /sys/kernel/debug/gtp
+(gdb) trace vfs_readdir
+Tracepoint 1 at 0xc01ed740: file
+/home/teawater/kernel/linux-2.6/fs/readdir.c, line 24.
+(gdb) actions
+Enter actions for tracepoint 1, one per line.
+End with a line saying just "end".
+>collect jiffies_64
+>collect file->f_path.dentry->d_iname
+>end
+(gdb) tstart
+(gdb) shell ls
+arch    drivers   include  kernel    mm               Module.symvers
+security  System.map  virt
+block   firmware  init     lib       modules.builtin  net
+sound     t           vmlinux
+crypto  fs        ipc      Makefile  modules.order    scripts
+source    usr         vmlinux.o
+(gdb) tstop
+(gdb) tfind
+Found trace frame 0, tracepoint 1
+#0  0xc01ed741 in vfs_readdir (file=0xf4063000, filler=0xc01ed580
+<filldir64>, buf=0xd6dfdf90)
+    at /home/teawater/kernel/linux-2.6/fs/readdir.c:24
+24      {
+(gdb) p jiffies_64
+$1 = 4297248706
+(gdb) p file->f_path.dentry->d_iname
+$1 = "b26", '\000' <repeats 28 times>
+How to use use tracepoint condition
+http://sourceware.org/gdb/current/onlinedocs/gdb/Tracepoint-Conditions.
+html
+Like breakpoints, we can set conditions on tracepoints. The speed of
+tracepoints is faster than breakpoints because KGTP can do all the
+condition checks.
+For example:
+
+(gdb) trace handle_irq
+(gdb) condition 1 (irq == 47)
+This action of tracepoint 1 will work only when irq number is 47.
+
+How to handle "Unsupported operator (null) (52) in expression."
+If you use condition about string, you will got this error when you call
+"tstart".
+To handle it, you can convent the char to int to handle this issue, for
+example:
+
+(gdb) condition 1 (buf[0] == (int)'1')
+Show all the traced data of current frame
+After use "tfind" select an entry, you can use "tdump" to do it.
+
+(gdb) tdump
+Data collected at tracepoint 1, trace frame 0:
+$cr = void
+file->f_path.dentry->d_iname =
+"gtp\000.google.chrome.g05ZYO\000\235\337\000\000\000\000\200\067k\364\
+200\067", <incomplete sequence \364>
+jiffies_64 = 4319751455
+Get status of tracepoint
+Please use GDB command "tstatus".
+
+Set the trace buffer into a circular buffer
+http://sourceware.org/gdb/current/onlinedocs/gdb/Starting-and-Stopping-
+Trace-Experiments.html
+The frame buffer is not a circular buffer by default. When the buffer is
+full, the tracepoint will stop.
+Following command will set frame buffer to a circular buffer. When the
+buffer is full, it will auto discard traceframes (oldest first) and keep
+trace.
+
+(gdb) set circular-trace-buffer on
+Do not stop tracepoint when the GDB disconnects
+http://sourceware.org/gdb/current/onlinedocs/gdb/Starting-and-Stopping-
+Trace-Experiments.html
+KGTP will stop tracepoint and delete the trace frame when GDB
+disconnects with it by default.
+Following command will open the KGTP disconnect-trace. After that, when
+GDB disconnects with KGTP, KGTP will not stop tracepoint. And after GDB
+reconnects to KGTP, it can keep control of KGTP like nothing happened.
+
+(gdb) set disconnected-tracing on
+kprobes-optimization and the execution speed of tracepoint
+The tracepoint is execution together with Linux kernel. So it speed will
+affect the speed the system.
+The KGTP tracepoint base on Linux kernel kprobe. Because the normal
+kprobe base on breakpoint instruction, so it is not very fast.
+
+But if arch of kernel is X86_64 or X86_32 and kernel config didn't open
+"Preemptible Kernel" (PREEMPT), the kprobe is speed up by
+kprobes-optimization (CONFIG_OPTPROBES) that make kprobe very fast.
+To make sure about that, you can use following command in terminal:
+
+sysctl -A | grep kprobe
+debug.kprobes-optimization = 1
+That means that your kernel support kprobes-optimization.
+Please note that some KGTP functions will make this tracepoint use
+simple kprobe even if this Kernel support kprobes-optimization. This doc
+will add note when introduce these functions. Please avoid using them
+when you really care about the tracepoint speed.
+
+How to use trace state variables
+http://sourceware.org/gdb/current/onlinedocs/gdb/Trace-State-Variables.
+html
+Tracepoints have special variables. The variables can be traced
+directly, or used in tracepoint conditions.
+Please note that just GDB 7.2.1 and later versions support use trace
+state variables directly, the old version of GDB can show the value of
+trace state variables through command "info tvariables".
+
+Simple trace state variables
+Define a trace state variable $c.
+
+(gdb) tvariable $c
+Trace state variable $c is created with initial value 0. The following
+action uses $c to count how many irqs happened in the kernel.
+
+(gdb) target remote /sys/kernel/debug/gtp
+(gdb) trace handle_irq
+(gdb) actions
+Enter actions for tracepoint 3, one per line.
+End with a line saying just "end".
+>collect $c     #Save current value of $c to the trace frame buffer.
+>teval $c=$c+1  #Increase the $c.
+>end
+Also, you can set a value of variable to trace state variable, but don't
+forget covert variable to "uint64_t".
+
+>teval $c=(uint64_t)a
+You can get the current value of $c while the trace is running or
+stopped.
+
+(gdb) tstart
+(gdb) info tvariables
+$c              0           31554
+(gdb) p $c
+$5 = 33652
+(gdb) tstop
+(gdb) p $c
+$9 = 105559
+When using tfind, you can parse the trace frame buffer. If the value of
+a trace state variable is collected, you can parse it out.
+
+(gdb) tstop
+(gdb) tfind
+(gdb) info tvariables
+$c              0           0
+(gdb) p $c
+$6 = 0
+(gdb) tfind 100
+(gdb) p $c
+$7 = 100
+If need, the tracepoint action that access the simple trace state
+variables will auto lock a spin lock for trace state variables. So it
+can handle race condition issue about trace state variables.
+The following example is OK even if it running a machine that have more
+than one CPU.
+
+>teval $c=$c+1
+Per_cpu trace state variables
+Per_cpu trace state variables are special simple trace state variables.
+When tracepoint action access to it, it will access to this CPU special
+trace state variables.
+It have 2 advantages:
+1. The tracepoint actions that access to per_cpu trace state variables
+don't have the race conditon issue. So it don't need lock the spin lock
+for trace state variables. It is faster than simple trace state
+variables on multi-core machine. 2. Write the action that count some CPU
+special thing with it is easier than simple trace state variables.
+
+To define per_cpu trace state variables, you need named it in format:
+
+"per_cpu_"+string+CPU_id
+or
+
+"pc_"+string+CPU_id
+Following example will define a series of per_cpu trace state variables
+in a 4 COREs CPU machine with string "count":
+
+(gdb) tvariable $pc_count0
+(gdb) tvariable $pc_count1
+(gdb) tvariable $pc_count2
+(gdb) tvariable $pc_count3
+You can use compatibility better way to do it:
+
+(gdb) set $tmp=0
+(gdb) while $tmp<$cpu_number
+ >eval "tvariable $pc_count%d",$tmp
+ >set $tmp=$tmp+1
+ >end
+Tracepoint action can access anyone of a series of per_cpu trace state
+variables. KGTP will auto access the one of CPU that it running on.
+For example:
+
+(gdb) trace vfs_read
+(gdb) actions
+>teval $pc_count0=$pc_count0+1
+>end
+These GDB commands define a tracepoint that count the times that call
+vfs_read of each CPU.
+
+Special trace state variables $current_task, $current_task_pid,
+$current_thread_info, $cpu_id, $dump_stack, $printk_level,
+$printk_format, $printk_tmp ,$clock, $hardirq_count, $softirq_count and
+$irq_count
+KGTP special trace state variables $current_task, $current_thread_info,
+$cpu_id and $clock can very easy to access to some special value. You
+can see them when GDB connects to the KGTP. You can use them in
+tracepoint conditions or actions.
+Access $current_task in tracepoint condition and action will get that
+returns of get_current().
+Access $current_task_pid in tracepoint condition and action will get
+that returns of get_current()->pid.
+Access $current_thread_info in tracepoint condition and action will get
+that returns of current_thread_info().
+Access $cpu_id in tracepoint condition and action will get that returns
+of smp_processor_id().
+Access $clock in tracepoint condition and action will get that returns
+of local_clock() that return the timestamp in nanoseconds.
+$rdtsc is only available on X86 and X86_64 architecture. Access it in
+anytime will get current value of TSC with instruction RDTSC.
+Access $hardirq_count in tracepoint condition and action will get that
+returns of hardirq_count().
+Access $softirq_count in tracepoint condition and action will get that
+returns of softirq_count().
+Access $irq_count in tracepoint condition and action will get that
+returns of irq_count().
+And KGTP has other special trace state variables $dump_stack,
+$printk_level, $printk_format and $printk_tmp. All of them output their
+values directly, as can be seen in
+HOWTO#Howto_let_tracepoint_output_value_directly.
+The following example counts in $c how many vfs_read calls that process
+16663 does and collects the struct thread_info of current task:
+
+(gdb) target remote /sys/kernel/debug/gtp
+(gdb) trace vfs_read if (((struct task_struct *)$current_task)->pid ==
+16663)
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
+$10 = {task = 0xf0ac6580, exec_domain = 0xc07b1400, flags = 0, status =
+0, cpu = 1, preempt_count = 2, addr_limit = {
+    seg = 4294967295}, restart_block = {fn = 0xc0159fb0
+<do_no_restart_syscall>, {{arg0 = 138300720, arg1 = 11,
+        arg2 = 1, arg3 = 78}, futex = {uaddr = 0x83e4d30, val = 11,
+flags = 1, bitset = 78, time = 977063750,
+        uaddr2 = 0x0}, nanosleep = {index = 138300720, rmtp = 0xb,
+expires = 335007449089}, poll = {
+        ufds = 0x83e4d30, nfds = 11, has_timeout = 1, tv_sec = 78,
+tv_nsec = 977063750}}},
+  sysenter_return = 0xb77ce424, previous_esp = 0, supervisor_stack =
+0xef340044 "", uaccess_err = 0}
+Another example shows how much sys_read() executes in each CPU.
+
+(gdb) tvariable $c0
+(gdb) tvariable $c1
+(gdb) trace sys_read
+(gdb) condition $bpnum ($cpu_id == 0)
+(gdb) actions
+>teval $c0=$c0+1
+>end
+(gdb) trace sys_read
+(gdb) condition $bpnum ($cpu_id == 1)
+(gdb) actions
+>teval $c1=$c1+1
+>end
+(gdb) info tvariables
+Name            Initial     Current
+$current_task   0           <unknown>
+$cpu_id         0           <unknown>
+$c0             0           3255
+$c1             0           1904
+sys_read() execute 3255 times in cpu0 and 1904 times in cpu1. Please
+note that this example just to howto use $cpu_id. Actially, this example
+use per_cpu trace state variables is better.
+
+Special trace state variable $no_self_trace
+$no_self_trace is different with the special trace state variables in
+the previous section. It is used to control the behavior of tracepoint.
+If the action of a tracepoint include a command access to the
+$no_self_trace. The tracepoint will not trace anything if the
+current_task is the a KGTP self process (GDB, netcat, getframe or some
+others process that access to the interface of KGTP).
+For example, if we want trace vfs_read or something that have process
+context, and we don't want trace the operation of KGTP self process. Add
+following command to the action:
+
+>collect $no_self_trace
+Please note that the code that doesn't about process context (Irq
+handler, softirq) doesn't need set this variable.
+
+Trace the function return with $kret
+Sometime, set the tracepoint to the end of function is hard because the
+Kernel is compiled with optimization. At this time, you can get help
+from $kret.
+$kret is a special trace state variable like $no_self_trace. When you
+set value of it inside the action of tracepoint, this tracepoint be set
+with kretprobe instead of kprobe. Then it can trace the end of this
+function.
+Please note that this tracepoint must set in the first address of the
+function in format "function_name".
+
+Following part is an example:
+
+#"*(function_name)" format can make certain that GDB send the first
+address of function to KGTP.
+(gdb) trace *vfs_read
+(gdb) actions
+>teval $kret=0
+#Following part you can set commands that you want.
+Use $ignore_error and $last_errno to ignore the error of tstart
+If KGTP got any error of tstart, this command will get fail.
+But sometime we need ignore this error and let KGTP keep work. For
+example: If you set tracepoint on the inline function spin_lock. This
+tracepoint will be set to a lot of addresses that some of them cannot be
+set kprobe. It will make tstart get fail. You can use "$ignore_error"
+ignore this error.
+And the last error number will available in "$last_errno".
+
+(gdb) tvariable $ignore_error=1
+This command will open ignore.
+
+(gdb) tvariable $ignore_error=0
+This command will close ignore.
+
+Use $cooked_clock and $cooked_rdtsc the time without KGTP used
+Access these two trace state variables can get the time without KGTP
+used. Then we can get more close to really time that a part of code used
+even if the actions of tracepoint is very complex. They will be
+introduce in Cookbook (coming soon).
+
+Use $xtime_sec and $xtime_nsec get the timespec
+Access these two trace state variables will return the time of day in a
+timespec that use getnstimeofday.
+$xtime_sec will access to the second part of a timespec.
+$xtime_nsec will access to the nanosecond part of a timespec.
+
+Howto backtrace (stack dump)
+Each time your program performs a function call, information about the
+call is generated. That information includes the location of the call in
+your program, the arguments of the call, and the local variables of the
+function being called. The information is saved in a block of data
+called a stack frame. The stack frames are allocated in a region of
+memory called the call stack.
+
+Collect stack with $bt and use GDB command "backtrace"
+Because this way is faster (just collect the stack when trace) and parse
+out most of info inside the call stack (it can show all the stack info
+that I introduce). So I suggest you use this way to do the stack dump.
+First we need add the collect the stack command to the tracepoint
+action.
+The general collect the stack command in GDB tracepoint is: In x86_32,
+following command will collect 512 bytes of stack.
+>collect (unsigned char )$esp@512
+In x86_64, following command will collect 512 bytes of stack.
+>collect (unsigned char )$rsp@512
+In MIPS or ARM, following command will collect 512 bytes of stack.
+>collect (unsigned char )$sp@512
+These commands is so hard to remember, and the different arch need
+different command.
+KGTP have an special tracepoint trace state variable $bt. If tracepoint
+action access it, KGTP will auto collect the $bt size (default value is
+512) stack. For example, this command will collect 512 bytes stack
+memory:
+
+>collect $bt
+If you want to change size of $bt, you can use following GDB command
+before "tstart":
+
+(gdb) tvariable $bt=1024
+Following part is an example about howto collect stack and howto use GDB
+parse it:
+
+(gdb) target remote /sys/kernel/debug/gtp
+(gdb) trace vfs_readdir
+Tracepoint 1 at 0xffffffff8118c300: file
+/home/teawater/kernel2/linux/fs/readdir.c, line 24.
+(gdb) actions
+Enter actions for tracepoint 1, one per line.
+End with a line saying just "end".
+>collect $bt
+>end
+(gdb) tstart
+(gdb) shell ls
+1      crypto    fs             include  kernel    mm
+Module.symvers  security  System.map  vmlinux
+arch   drivers   hotcode.html   init     lib       modules.builtin  net
+           sound     usr         vmlinux.o
+block  firmware  hotcode.html~  ipc      Makefile  modules.order
+scripts         source    virt
+(gdb) tstop
+(gdb) tfind
+Found trace frame 0, tracepoint 1
+#0  vfs_readdir (file=0xffff8800c5556d00, filler=0xffffffff8118c4b0
+<filldir>, buf=0xffff880108709f40)
+    at /home/teawater/kernel2/linux/fs/readdir.c:24
+24      {
+(gdb) bt
+#0  vfs_readdir (file=0xffff8800c5556d00, filler=0xffffffff8118c4b0
+<filldir>, buf=0xffff880108709f40)
+    at /home/teawater/kernel2/linux/fs/readdir.c:24
+#1  0xffffffff8118c689 in sys_getdents (fd=<optimized out>,
+dirent=0x1398c58, count=32768) at
+/home/teawater/kernel2/linux/fs/readdir.c:214
+#2  <signal handler called>
+#3  0x00007f00253848a5 in ?? ()
+#4  0x00003efd32cddfc9 in ?? ()
+#5  0x00002c15b7d04101 in ?? ()
+#6  0x000019c0c5704bf1 in ?? ()
+#7  0x0000000900000000 in ?? ()
+#8  0x000009988cc8d269 in ?? ()
+#9  0x000009988cc9b8d1 in ?? ()
+#10 0x0000000000000000 in ?? ()
+(gdb) up
+#1  0xffffffff8118c689 in sys_getdents (fd=<optimized out>,
+dirent=0x1398c58, count=32768) at
+/home/teawater/kernel2/linux/fs/readdir.c:214
+214             error = vfs_readdir(file, filldir, &buf);
+(gdb) p buf
+$1 = {current_dir = 0x1398c58, previous = 0x0, count = 32768, error = 0}
+(gdb) p error
+$3 = -9
+(gdb) frame 0
+#0  vfs_readdir (file=0xffff8800c5556d00, filler=0xffffffff8118c4b0
+<filldir>, buf=0xffff880108709f40)
+    at /home/teawater/kernel2/linux/fs/readdir.c:24
+24      {
+From this example, we can see some GDB commands that parse the the call
+stack:
+bt is the alias of GDB commands backtrace that print a backtrace of the
+entire stack: one line per frame for all frames in the stack.
+up n is move n frames up the stack. For positive numbers n, this
+advances toward the outermost frame, to higher frame numbers, to frames
+that have existed longer. n defaults to one.
+down n is move n frames down the stack. For positive numbers n, this
+advances toward the innermost frame, to lower frame numbers, to frames
+that were created more recently. n defaults to one. You may abbreviate
+down as do.
+frame n is select frame number n. Recall that frame zero is the
+innermost (currently executing) frame, frame one is the frame that
+called the innermost one, and so on. The highest-numbered frame is the
+one for main.
+You can see that when you use up, down or frame to the different calll
+stack frame, you can output the value of the arguments and local
+variables of different call stack frame.
+To get the more info about howto use GDB parse the call stack, please
+see http://sourceware.org/gdb/current/onlinedocs/gdb/Stack.html
+Collect stack of current function's caller with $_ret
+If you just want to collect stack of current function's caller, please
+use $_ret.
+Please note that set the tracepoint that collect $_ret cannot in the
+first address of function.
+For example:
+
+(gdb) list vfs_read
+360     }
+361
+362     EXPORT_SYMBOL(do_sync_read);
+363
+364     ssize_t vfs_read(struct file *file, char __user *buf, size_t
+count, loff_t *pos)
+365     {
+366             ssize_t ret;
+367
+368             if (!(file->f_mode & FMODE_READ))
+369                     return -EBADF;
+(gdb) trace 368
+Tracepoint 2 at 0xffffffff8117a244: file
+/home/teawater/kernel2/linux/fs/read_write.c, line 368.
+(gdb) actions
+Enter actions for tracepoint 2, one per line.
+End with a line saying just "end".
+>collect $_ret
+>end
+(gdb) tstart
+(gdb) tstop
+(gdb) tfind
+Found trace frame 0, tracepoint 2
+#0  vfs_read (file=0xffff880141c46000, buf=0x359bda0 <Address 0x359bda0
+out of bounds>, count=8192, pos=0xffff88012fa49f48)
+    at /home/teawater/kernel2/linux/fs/read_write.c:368
+368             if (!(file->f_mode & FMODE_READ))
+(gdb) bt
+#0  vfs_read (file=0xffff880141c46000, buf=0x359bda0 <Address 0x359bda0
+out of bounds>, count=8192, pos=0xffff88012fa49f48)
+    at /home/teawater/kernel2/linux/fs/read_write.c:368
+#1  0xffffffff8117a3ea in sys_read (fd=<optimized out>,
+buf=<unavailable>, count=<unavailable>)
+    at /home/teawater/kernel2/linux/fs/read_write.c:469
+Backtrace stopped: not enough registers or memory available to unwind
+further
+(gdb) up
+#1  0xffffffff8117a3ea in sys_read (fd=<optimized out>,
+buf=<unavailable>, count=<unavailable>)
+    at /home/teawater/kernel2/linux/fs/read_write.c:469
+469                     ret = vfs_read(file, buf, count, &pos);
+(gdb) p ret
+$2 = -9
+You see that the caller of function vfs_read is sys_read. And the local
+variable ret of sys_read is -9.
+
+Use $dump_stack to output stack dump through printk
+Because this way need parse the stack when tracing and call printk
+inside, so it will be slow, unsafe, unclear and cannot access a lot of
+info of call stack. So I suggest you use the prev way to do stack dump.
+KGTP has special trace state variable $dump_stack, "collect" it will let
+Linux Kernel output stack dump through printk.
+Following example lets Linux Kernel show the stack dump of vfs_readdir:
+
+target remote /sys/kernel/debug/gtp
+trace vfs_readdir
+  commands
+    collect $dump_stack
+  end
+Then your kernel will printk like:
+
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
+[22779.208112]  [<c02db51f>] ?
+__jbd2_journal_temp_unlink_buffer+0x2f/0x110
+[22779.208115]  [<fe655c4c>] gtp_kp_pre_handler+0xcc/0x1c0 [gtp]
+[22779.208118]  [<c05b8a88>] kprobe_exceptions_notify+0x3d8/0x440
+[22779.208121]  [<c05b7d54>] ?
+hw_breakpoint_exceptions_notify+0x14/0x180
+[22779.208124]  [<c05b95eb>] ? sub_preempt_count+0x7b/0xb0
+[22779.208126]  [<c0227ac5>] ? vfs_readdir+0x15/0xb0
+[22779.208128]  [<c0227ac4>] ? vfs_readdir+0x14/0xb0
+[22779.208131]  [<c05b9743>] notifier_call_chain+0x43/0x60
+[22779.208134]  [<c05b9798>] __atomic_notifier_call_chain+0x38/0x50
+[22779.208137]  [<c05b97cf>] atomic_notifier_call_chain+0x1f/0x30
+[22779.208140]  [<c05b980d>] notify_die+0x2d/0x30
+[22779.208142]  [<c05b71c5>] do_int3+0x35/0xa0
+How to use performance counters
+Performance counters are special hardware registers available on most
+modern CPUs. These registers count the number of certain types of hw
+events: such as instructions executed, cachemisses suffered, or branches
+mis-predicted - without slowing down the kernel or applications. These
+registers can also trigger interrupts when a threshold number of events
+have passed - and can thus be used to profile the code that runs on that
+CPU.
+The Linux Performance Counter subsystem called perf event can get the
+value of performance counter. You can access it through KGTP perf event
+trace state variables.
+Please goto read the file tools/perf/design.txt in Linux Kernel to get
+more info about perf event.
+
+Define a perf event trace state variable
+Access an performance counter need define following trace state
+variable:
+
+"pe_cpu_"+tv_name       Define the the CPU id of the performance
+counter.
+"pe_type_"+tv_name      Define the the type of the performance counter.
+"pe_config_"+tv_name    Define the the config of the performance
+counter.
+"pe_en_"+tv_name        This the switch to enable or disable the
+performance counter.
+                        The performance counter is disable in default.
+"pe_val_"+tv_name       Access this variable can get the value of the
+performance counter.
+Define a per_cpu perf event trace state variable
+Define a per_cpu perf event trace state variable is same with define
+HOWTO#Per_cpu_trace_state_variables.
+
+"pc_pe_"+perf_event type+string+CPU_id
+Please note that if you define a per_cpu perf event trace state
+variable, you will not need define the cpu id("pe_cpu") because KGTP
+already get it.
+
+The perf event type and config
+The type of perf event can be:
+
+0       PERF_TYPE_HARDWARE
+1       PERF_TYPE_SOFTWARE
+2       PERF_TYPE_TRACEPOINT
+3       PERF_TYPE_HW_CACHE
+4       PERF_TYPE_RAW
+5       PERF_TYPE_BREAKPOINT
+If the type is 0(PERF_TYPE_HARDWARE), the config can be:
+
+0       PERF_COUNT_HW_CPU_CYCLES
+1       PERF_COUNT_HW_INSTRUCTIONS
+2       PERF_COUNT_HW_CACHE_REFERENCES
+3       PERF_COUNT_HW_CACHE_MISSES
+4       PERF_COUNT_HW_BRANCH_INSTRUCTIONS
+5       PERF_COUNT_HW_BRANCH_MISSES
+6       PERF_COUNT_HW_BUS_CYCLES
+7       PERF_COUNT_HW_STALLED_CYCLES_FRONTEND
+8       PERF_COUNT_HW_STALLED_CYCLES_BACKEND
+
+If the type is 3(PERF_TYPE_HW_CACHE), the config need to divide to 3
+parts: First one is cache id, it need be << 0 before set to config:
+
+0       PERF_COUNT_HW_CACHE_L1D
+1       PERF_COUNT_HW_CACHE_L1I
+2       PERF_COUNT_HW_CACHE_LL
+3       PERF_COUNT_HW_CACHE_DTLB
+4       PERF_COUNT_HW_CACHE_ITLB
+5       PERF_COUNT_HW_CACHE_BPU
+Second one is cache op id, it need be << 8 before set to config:
+
+0       PERF_COUNT_HW_CACHE_OP_READ
+1       PERF_COUNT_HW_CACHE_OP_WRITE
+2       PERF_COUNT_HW_CACHE_OP_PREFETCH
+Last one is cache op result id, it need be << 16 before set to config:
+
+0       PERF_COUNT_HW_CACHE_RESULT_ACCESS
+1       PERF_COUNT_HW_CACHE_RESULT_MISS
+If you want get the perf count of PERF_COUNT_HW_CACHE_L1I(1),
+PERF_COUNT_HW_CACHE_OP_WRITE(1) and PERF_COUNT_HW_CACHE_RESULT_MISS(1),
+you can use:
+
+(gdb) tvariable $pe_config_cache=1 | (1 << 8) | (1 << 16)
+tools/perf/design.txt in Linux Kernel have more info about type and
+config of perf event.
+
+Enable and disable all the perf event in a CPU with $pc_pe_en
+I think the best way that count a part of code with performance counters
+is enable all the count in the begin of the code and disable all of them
+in the end. You can do it with "pe_en". But if you have a lot of perf
+event trace state variables. That will make the tracepoint action very
+big. $pc_pe_en is for this issue. You can enable all the perf event
+trace state variables in current CPU with following action:
+
+>teval $pc_pe_en=1
+Disable them with set $pc_pe_en to 0.
+
+>teval $pc_pe_en=0
+GDB scripts to help with set and get the perf event trace state
+variables
+Following is a GDB script define two commands dpe and spe to help define
+and show the perf event trace state variables.
+You can put it to the ~/.gdbinit or your tracepoint script. Then you can
+use this two commands in GDB directly.
+
+define dpe
+  if ($argc < 2)
+    printf "Usage: dpe pe_type pe_config [enable]\n"
+  end
+  if ($argc >= 2)
+    set $tmp=0
+    while $tmp<$cpu_number
+      eval "tvariable $pc_pe_type_%d%d_%d=%d",$arg0, $arg1, $tmp, $arg0
+      eval "tvariable $pc_pe_config_%d%d_%d=%d",$arg0, $arg1, $tmp,
+$arg1
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
+Usage: dpe pe_type pe_config [enable]
+end
+
+define spe
+  if ($argc != 2 && $argc != 3)
+    printf "Usage: spe pe_type pe_config [cpu_id]\n"
+  end
+  if ($argc == 2)
+    set $tmp=0
+    while $tmp<$cpu_number
+      eval "printf \"$pc_pe_val_%%d%%d_%%d=%%ld\\n\",$arg0, $arg1, $tmp,
+$pc_pe_val_%d%d_%d", $arg0, $arg1, $tmp
+      set $tmp=$tmp+1
+    end
+  end
+  if ($argc == 3)
+    eval "printf \"$pc_pe_val_%%d%%d_%%d=%%ld\\n\",$arg0, $arg1, $tmp,
+$pc_pe_val_%d%d_%d", $arg0, $arg1, $arg2
+  end
+end
+
+document spe
+Usage: spe pe_type pe_config [cpu_id]
+end
+Following is an example to use it get the performance counters of
+function tcp_v4_rcv:
+
+#Connect to KGTP
+(gdb) target remote /sys/kernel/debug/gtp
+#Define 3 pe tvs for PERF_COUNT_HW_CPU_CYCLES,
+PERF_COUNT_HW_CACHE_MISSES and PERF_COUNT_HW_BRANCH_MISSES.
+(gdb) dpe 0 0
+(gdb) dpe 0 3
+(gdb) dpe 0 5
+#enable the performance counters of this CPU in the begin of this
+function.
+(gdb) trace tcp_v4_rcv
+(gdb) action
+>teval $pc_pe_en=1
+>end
+#$kret make this hanler the end of function tcp_v4_rcv.
+(gdb) trace *(tcp_v4_rcv)
+(gdb) action
+>teval $kret=0
+#disable all performance counters of this CPU
+>teval $pc_pe_en=0
+#Access the per cpu perf event tv will access to the current cpu pe tv.
+>collect $pc_pe_val_00_0
+>collect $pc_pe_val_03_0
+>collect $pc_pe_val_05_0
+#Set all the pe tv to 0
+>teval $pc_pe_val_00_0=0
+>teval $pc_pe_val_03_0=0
+>teval $pc_pe_val_05_0=0
+>end
+tstart
+#Wait some time that current pc receive some tcp package.
+(gdb) tstop
+(gdb) tfind
+(gdb) spe 0 0 $cpu_id
+$pc_pe_val_00_2=12676
+(gdb) spe 0 3 $cpu_id
+$pc_pe_val_03_2=7
+(gdb) spe 0 5 $cpu_id
+$pc_pe_val_05_2=97
+Howto let tracepoint output value directly
+In the previous parts, you may understand that to get a value from Linux
+kernel, you need to use a tracepoint "collect" action to save the value
+to the tracepoint frame and use the GDB command "tfind" to parse the
+value from the frame data.
+But we want get the value directly sometimes, so KGTP supports two ways
+to output values directly.
+
+Switch collect to output the value directly
+KGTP has special trace state variables $printk_level, $printk_format and
+$printk_tmp to support this function.
+$printk_level: if its value is 8 (this is the default value), "collect"
+action will save value to the tracepoint frame in the simple behavior.
+If its value is 0-7, "collect" will output the value through "printk"
+directly, and value will be the level of printk. The level is:
+
+0       KERN_EMERG      system is unusable
+1       KERN_ALERT      action must be taken immediately
+2       KERN_CRIT       critical conditions
+3       KERN_ERR        error conditions
+4       KERN_WARNING    warning conditions
+5       KERN_NOTICE     normal but significant condition
+6       KERN_INFO       informational
+7       KERN_DEBUG      debug-level messages
+$printk_format, collect printk will output value in the format that is
+set by it. The format is:
+
+0       This is the default value.
+        If the size of collect value is 1, 2, 4 or 8, it will be output
+as an unsigned decimal.
+        If not, it will be output as a hexadecimal string.
+1       Output value in signed decimal.
+2       Output value in unsigned decimal.
+3       Output value in unsigned hexadecimal.
+4       Output value as a string.
+5       Output value as a hexadecimal string.
+$printk_tmp, to output the value of global variable need set to it
+first.
+
+Following example shows a count number, pid, jiffies_64 and the file
+name that call vfs_readdir:
+
+(gdb) target remote /sys/kernel/debug/gtp
+(gdb) tvariable $c
+(gdb) trace vfs_readdir
+(gdb) actions
+>teval $printk_level=0
+>collect $c=$c+1
+>collect ((struct task_struct *)$current_task)->pid
+>collect $printk_tmp=jiffies_64
+>teval $printk_format=4
+>collect file->f_path.dentry->d_iname
+>end
+Then your kernel will printk like:
+
+gtp 1:$c=$c+1=41
+gtp 1:((struct task_struct *)$current_task)->pid=12085
+gtp 1:$printk_tmp=jiffies_64=4322021438
+gtp 1:file->f_path.dentry->d_iname=b26
+gtp 1:$c=$c+1=42
+gtp 1:((struct task_struct *)$current_task)->pid=12085
+gtp 1:$printk_tmp=jiffies_64=4322021438
+gtp 1:file->f_path.dentry->d_iname=b26
+"gtp 1" means that it was output by tracepoint 1.
+
+Howto show a variable whose value has been optimized away
+Sometimes, GDB will output some value like:
+
+inode has been optimized out of existence.
+res has been optimized out of existence.
+That is because value of inode and res is optimized. Linux Kernel is
+built with -O2 so you will get this trouble sometimes.
+There are 2 ways to handle it:
+
+Update your GCC
+The VTA branch (http://gcc.gnu.org/wiki/Var_Tracking_Assignments) was
+merged for GCC 4.5. This helps a lot with generating dwarf for
+previously "optimized out" values.
+
+How to get the function pointer point to
+If the debug info of the function pointer is not optimized out
+You can collect it directly and print what it point to. For example:
+
+377                     count = ret;
+378                     if (file->f_op->read)
+379                             ret = file->f_op->read(file, buf, count,
+pos);
+(gdb)
+(gdb) trace 379
+Tracepoint 1 at 0xffffffff81173ba5: file
+/home/teawater/kernel/linux/fs/read_write.c, line 379.
+(gdb) actions
+Enter actions for tracepoint 1, one per line.
+End with a line saying just "end".
+>collect file->f_op->read
+>end
+(gdb) tstart
+(gdb) tstop
+(gdb) tfind
+(gdb) p file->f_op->read
+$5 = (ssize_t (*)(struct file *, char *, size_t, loff_t *))
+0xffffffff81173190 <do_sync_read>
+#Then you know file->f_op->read point to do_sync_read.
+If the debug info of the function pointer is optimized out
+You can use tracepoint step to handle it. For example:
+
+#Find out which instrunction that it is called.
+(gdb) disassemble /rm vfs_read
+379                             ret = file->f_op->read(file, buf, count,
+pos);
+   0xffffffff81173ba5 <+181>:   48 89 da        mov    %rbx,%rdx
+   0xffffffff81173ba8 <+184>:   4c 89 e9        mov    %r13,%rcx
+   0xffffffff81173bab <+187>:   4c 89 e6        mov    %r12,%rsi
+   0xffffffff81173bae <+190>:   4c 89 f7        mov    %r14,%rdi
+   0xffffffff81173bb1 <+193>:   ff d0   callq  *%rax
+   0xffffffff81173bb3 <+195>:   48 89 c3        mov    %rax,%rbx
+(gdb) trace *0xffffffff81173bb1
+Tracepoint 1 at 0xffffffff81173bb1: file
+/home/teawater/kernel/linux/fs/read_write.c, line 379.
+(gdb) actions
+Enter actions for tracepoint 1, one per line.
+End with a line saying just "end".
+>while-stepping 1
+ >collect $reg
+ >end
+>end
+(gdb) tstart
+(gdb) tstop
+(gdb) tfind
+#0  tty_read (file=0xffff88006ca74900, buf=0xb6b7dc <Address 0xb6b7dc
+out of bounds>, count=8176,
+    ppos=0xffff88006e197f48) at
+/home/teawater/kernel/linux/drivers/tty/tty_io.c:960
+960     {
+#Then you know file->f_op->read point to tty_read.
+Please note that while-stepping will make tracepoint cannot use
+kprobes-optimization.
+
+/sys/kernel/debug/gtpframe and offline debug
+/sys/kernel/debug/gtpframe supplies trace frame in tfile format (GDB can
+parse it) when KGTP is stop.
+In the PC that can run the GDB:
+Change the "target remote XXXX" to
+
+(gdb) target remote | perl ./getgtprsp.pl
+After that, set tracepoint and start it as usual:
+
+(gdb) trace vfs_readdir
+Tracepoint 1 at 0xffffffff8114f3c0: file
+/home/teawater/kernel/linux-2.6/fs/readdir.c, line 24.
+(gdb) actions
+Enter actions for tracepoint 1, one per line.
+End with a line saying just "end".
+#If your GDB support tracepoint "printf" (see "Howto use tracepoint
+printf"), use it to show the value directly is better.
+>collect $reg
+>end
+(gdb) tstart
+(gdb) stop
+(gdb) quit
+Then you can find files gtpstart and gtpstop in current directory. Copy
+it to the machine that you want to debug.
+
+In the debugged machine after insmod the gtp.ko:
+Start the tracepoint:
+
+cat gtpstart > /sys/kernel/debug/gtp
+Stop the tracepoint:
+
+cat gtpstop > /sys/kernel/debug/gtp
+You can let Linux Kernel show the value directly, please see
+HOWTO#Howto_let_tracepoint_output_value_directly.
+
+If you want to save the value to the trace frame and parse later, you
+can use file "/sys/kernel/debug/gtpframe" that has the trace frame. Copy
+it to the PC that has GDB.
+Please note that some "cp" cannot handle it very well, please use "cat
+/sys/kernel/debug/gtpframe > ./gtpframe" to copy it.
+In the PC that can run the GDB:
+(gdb) target tfile ./gtpframe
+Tracepoint 1 at 0xffffffff8114f3dc: file
+/home/teawater/kernel/linux-2.6/fs/readdir.c, line 24.
+Created tracepoint 1 for target's tracepoint 1 at 0xffffffff8114f3c0.
+(gdb) tfind
+Found trace frame 0, tracepoint 1
+#0  vfs_readdir (file=0xffff880036e8f300, filler=0xffffffff8114f240
+<filldir>, buf=0xffff880001e5bf38)
+    at /home/teawater/kernel/linux-2.6/fs/readdir.c:24
+24      {
+How to use /sys/kernel/debug/gtpframe_pipe
+This interface supplies same format trace frame with "gtpframe". But it
+can work when KGTP is running. After data is read, it will auto deleted
+from trace frame like "trace_pipe" of ftrace.
+
+Get the frame info with GDB
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
+This way is better to work with python to parse Kernel.
+add-ons/hotcode.py is an example of python script.
+
+Get the frame info with cat
+sudo cat /sys/kernel/debug/gtpframe_pipe > g
+Then all the trace frame will be saved in file "g".
+
+Get the frame info with getframe
+KGTP package include a program "getframe" can help you save the trace
+frame to files.
+Following part is the help of it:
+
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
+Use $pipe_trace
+For the lock safe, KGTP will ignore the task that read the
+/sys/kernel/debug/gtpframe_pipe in default.
+If you really need trace this task, and be sure that is safe. You can
+use following command before call "tstart":
+
+(gdb) tvariable $pipe_trace=1
+Then KGTP will not ignore the task that read
+/sys/kernel/debug/gtpframe_pipe.
+
+How to use add-ons/hotcode.py
+This script can show the hotest code line in the Linux kernel or user
+space program through parse and record the pc address in the interrupt
+handler.
+Please goto http://code.google.com/p/kgtp/wiki/hotcode see howto use it.
--- /dev/null
+++ b/Documentation/gtp/howtocn.txt
@@ -0,0 +1,1319 @@
+		Linux Kernel GDB tracepoint module (KGTP)
+		=========================================
+		By Hui Zhu <teawater@gmail.com>
+		https://code.google.com/p/kgtp/wiki/HOWTOCN
+
+Update in 2012-04-24
+
+目录
+----
+
+什么是KGTP
+需要帮助或者汇报问题
+使用KGTP前的准备工作
+Linux内核
+如果你的系统内核是自己编译的
+如果你的系统内核是发行版自带的
+取得KGTP
+通过http下载KGTP
+通过svn下载KGTP
+配置KGTP
+编译KGTP
+普通编译
+用一些特殊选项编译KGTP
+安装和卸载 KGTP
+和DKMS一起使用KGTP
+使用KGTP Linux内核patch
+安装可以和KGTP一起使用的GDB
+如何使用
+执行
+让GDB连接到KGTP
+GDB在本地主机上
+如果GDB在远程主机上
+增加模块的符号信息到GDB
+如何使用getmod.py
+如何使用getmod
+直接访问内存
+GDB tracepoint
+如何使用GDB tracepoint
+actions [num]
+启动和停止 tracepoint
+Enable 和 disable tracepoint
+tfind
+用tracepoint从内核中某点取得寄存器信息
+用tracepoint从内核中某点取得变量的值
+如何设置条件tracepoint
+如何处理 "Unsupported operator (null) (52) in expression."
+显示当前这一条trace缓存里存储的所有信息
+取得 tracepoint 的状态
+设置trace缓存为循环缓存
+GDB断开的时候不要停止tracepoint
+kprobes-optimization和tracepoint的执行速度
+如果使用trace状态变量
+普通trace状态变量
+Per_cpu trace状态变量
+特殊trace状态变量
+$current_task，$current_task_pid，$current_thread_info，$cpu_id，$dump_stack
+，$printk_level，$printk_format，$printk_tmp，$clock，$hardirq_count，$softirq
+_count 和 $irq_count
+特殊trace状态变量 $no_self_trace
+用$kret trace函数的结尾
+用 $ignore_error 和 $last_errno 忽略tstart的错误
+使用 $cooked_clock 和 $cooked_rdtsc 取得不包含KGTP运行时间的时间信息
+使用 $xtime_sec 和 $xtime_nsec 取得 timespec
+如何 backtrace (stack dump)
+通过$bt收集栈并用GDB命令"backtrace"进行分析
+用 $_ret 来取得当前函数的调用函数的栈
+用 $dump_stack 输出栈分析到printk里
+如何使用性能计数器
+定义一个perf event trace状态变量
+定义一个per_cpu perf event trace状态变量
+perf event的类型和配置
+用$pc_pe_en打开和关闭一个CPU上所有的perf event
+用来帮助设置和取得perf event trace状态变量的GDB脚本
+如何让tracepoint直接输出信息
+切换collect为直接输出数据
+如何显示被优化掉的变量值
+升级你的GCC
+如何取得函数指针指向的函数
+如果函数指针没有被优化掉
+如果函数指针被优化掉了
+/sys/kernel/debug/gtpframe和离线调试
+如何使用 /sys/kernel/debug/gtpframe_pipe
+用GDB读帧信息
+用cat读帧信息
+用getframe读帧信息
+使用 $pipe_trace
+如何使用 add-ons/hotcode.py
+什么是KGTP
+KGTP 是一个 实时 轻量级 Linux 调试器 和 跟踪器 。
+
+其让Linux内核提供一个远程GDB调试接口，于是在本地或者远程的主机上的GDB可以在不需要停止内核的情况下用GDB
+tracepoint和其他一些功能 调试 和 跟踪 Linux。
+即使板子上没有GDB而且其没有可用的远程接口，KGTP也可以用离线调试的功能调试内核（见http://code.google.com/p/
+kgtp/wiki/HOWTOCN#/sys/kernel/debug/gtpframe和离线调试）。
+KGTP可以用在 Android 上 （见 HowToUseKGTPinAndroid）。
+现在，KGTP支持 X86-32，X86-64，MIPS 和 ARM。
+
+KGTP新用户可以去看一下 Quickstart 。
+
+请到 UPDATE 去看KGTP的更新信息。
+
+需要帮助或者汇报问题
+你可以把问题发到 http://code.google.com/p/kgtp/issues/list
+或者写信到kgtp@freelists.org或者写信到 teawater@gmail.com。
+KGTP小组将尽全力帮助你。
+
+使用KGTP前的准备工作
+Linux内核
+如果你的系统内核是自己编译的
+要使用KGTP，你需要打开下面这些内核选项：
+
+General setup  --->
+        [*] Kprobes
+
+Kernel hacking  --->
+        [*] Debug Filesystem
+        [*] Compile the kernel with debug info
+如果你的系统内核是发行版自带的
+你需要安装一些Linux内核软件包。
+
+Ubuntu
+安装Linux内核调试镜像
+1) 增加调试源到Ubuntu源列表。
+
+在命令行按照下面的命令创建文件 /etc/apt/sources.list.d/ddebs.list：
+echo "deb http://ddebs.ubuntu.com $(lsb_release -cs) main restricted
+universe multiverse" | \
+sudo tee -a /etc/apt/sources.list.d/ddebs.list
+稳定版本（不能是alpha或者betas）需要用命令行增加下面几行：
+echo "deb http://ddebs.ubuntu.com $(lsb_release -cs)-updates main
+restricted universe multiverse
+deb http://ddebs.ubuntu.com $(lsb_release -cs)-security main restricted
+universe multiverse
+deb http://ddebs.ubuntu.com $(lsb_release -cs)-proposed main restricted
+universe multiverse" | \
+sudo tee -a /etc/apt/sources.list.d/ddebs.list
+导入调试符号签名key：
+sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 428D7C01
+运行：
+sudo apt-get update
+
+2) 安装Linux内核调试镜像。
+
+sudo apt-get install linux-image-$(uname -r)-dbgsym
+安装内核头文件包
+sudo apt-get install linux-headers-generic
+安装内核源码
+安装源码包：
+sudo apt-get install linux-source
+解压缩源码：
+sudo mkdir -p /build/buildd/
+sudo tar vxjf /usr/src/linux-source-$(uname -r | sed 's/-.*//').tar.bz2
+-C /build/buildd/
+sudo mv /build/buildd/linux-source-$(uname -r | sed 's/-.*//')
+/build/buildd/linux-$(uname -r | sed 's/-.*//')
+Fedora
+安装Linux内核调试镜像
+sudo yum --enablerepo=fedora-debuginfo install kernel-debuginfo
+安装Linux内核开发包
+sudo yum install kernel-devel-$(uname -r)
+其他系统
+需要安装Linux内核调试镜像和Linux内核源码包。
+
+取得KGTP
+通过http下载KGTP
+请到 http://code.google.com/p/kgtp/downloads/list 或者 UPDATE 去下载源码包。
+
+通过svn下载KGTP
+有些人访问KGTP站点有问题，你可以通过svn访问KGTP。
+
+svn checkout http://kgtp.googlecode.com/svn/ kgtp-read-only
+kgtp-read-only/tags/ 这里是KGTP每个发布的版本。
+kgtp-read-only/trunk/ 这里是KGTP的主干。
+
+配置KGTP
+下面这部分是在KGTP Makefile里的配置。用这个配置，KGTP将自动和当前系统的内核一起编译。
+
+KERNELDIR := /lib/modules/`uname -r`/build
+CROSS_COMPILE :=
+KERELDIR 设置了你要一起编译的内核，默认情况下，KGTP会和当前的内核一起编译。
+CROSS_COMPILE 设置编译KGTP的编译器前缀名。留空则使用默认编译器。
+ARCH 是体系结构。
+
+或者你可以通过修改KGTP目录里的Makefile选择你要和哪个内核一起编译以及你用什么编译器编译KGTP。
+例如：
+
+KERNELDIR := /home/teawater/kernel/bamd64
+CROSS_COMPILE :=x86_64-glibc_std-
+ARCH := x86_64
+KERNELDIR 设置为 /home/teawater/kernel/bamd64。 Compiler 设置为
+x86_64-glibc_std-gcc。
+
+编译KGTP
+普通编译
+cd kgtp/
+make
+用一些特殊选项编译KGTP
+大部分时候，KGTP可以自动选择正确的参数和和各种版本的Linux内核一起编译。
+但是如果你想配置一些特殊选项，可以按照下面的介绍来做：
+用这个选项，KGTP将不自动选择任何编译选项。
+
+make AUTO=0
+用这个选项，KGTP将使用简单frame替代KGTP ring buffer。
+简单frame不支持gtpframe_pipe，它现在只用来调试KGTP。
+
+make AUTO=0 FRAME_SIMPLE=1
+用这个选项，$clock将返回rdtsc的值而不是local_clock。
+
+make AUTO=0 CLOCK_CYCLE=1
+用这个选项，KGTP可以用procfs替代debugfs。
+
+make AUTO=0 USE_PROC=1
+这些选线可以一起使用，例如：
+
+make AUTO=0 FRAME_SIMPLE=1 CLOCK_CYCLE=1
+安装和卸载 KGTP
+因为KGTP可以直接在编译目录里insmod，所以不编译后不安装也可以直接使用（见
+http://code.google.com/p/kgtp/wiki/HOWTOCN#执行）。但是如果需要也可以将其安装到系统中。 安装：
+
+cd kgtp/
+sudo make install
+卸载：
+
+cd kgtp/
+sudo make uninstall
+和DKMS一起使用KGTP
+如果你需要的话，你还可以让DKMS来使用KGTP。
+下面的命令将拷贝KGTP的文件到DKMS需要的目录中。
+
+cd kgtp/
+sudo make dkms
+于是你可以用DKMS命令控制KGTP。请到 http://linux.dell.com/dkms/manpage.html
+去看如何使用DKMS。
+
+使用KGTP Linux内核patch
+大多数时候，你不需要KGTP
+patch，因为KGTP以一个LKM的形式编译安装更为方便。但是为了帮助人们集成KGTP到他们自己的内核树，KGTP也提供了patch.
+在KGTP目录中：
+gtp_for_review.patch 是给Linux kernel upstream的patch。
+gtp_3.0_to_upstream.patch 是给Linux kernel 从3.0到upstream的patch。
+gtp_2.6.39.patch 是给Linux kernel 2.6.39的patch。
+gtp_2.6.33_to_2.6.38.patch 是给Linux kernel 从2.6.33到2.6.38的patch。
+gtp_older_to_2.6.32.patch 是给Linux kernel 2.6.32以及更早版本的patch。
+安装可以和KGTP一起使用的GDB
+早于7.3版本的GDB的tracepoint功能有一些bug，而且还有一些功能做的不是很好。
+所以如果你的GDB小于7.3请到 https://code.google.com/p/gdbt/ 去安装可以和KGTP一起使用的GDB。
+如果你有GDB的问题，请根据这里的信息HOWTO#Report_issues_about_KGTP取得帮助。
+
+如何使用
+执行
+如果你已经安装了KGTP在你的系统中，你可以：
+
+sudo modprobe gtp
+或者你可以直接使用KGTP目录里的文件：
+
+cd kgtp/
+sudo insmod gtp.ko
+让GDB连接到KGTP
+GDB在本地主机上
+sudo gdb ./vmlinux
+(gdb) target remote /sys/kernel/debug/gtp
+Remote debugging using /sys/kernel/debug/gtp
+0x0000000000000000 in ?? ()
+然后你就可以用GDB命令调试和跟踪Linux内核了。
+
+如果GDB在远程主机上
+#在当前主机打开KGTP
+sudo su
+nc -l 1234 </sys/kernel/debug/gtp >/sys/kernel/debug/gtp
+(nc -l -p 1234 </sys/kernel/debug/gtp >/sys/kernel/debug/gtp for old
+version netcat.)
+#让GDB连接1234端口
+gdb ./vmlinux
+(gdb) target remote xxx.xxx.xxx.xxx:1234
+然后你就可以用GDB命令调试和跟踪Linux内核了。
+
+增加模块的符号信息到GDB
+有时你需要添加一个Linux内核模块的符号信息到GDB好调试其。
+手动增加符号信息不太容易，所以KGTP包里包含了GDB Python脚本"getmod.py"和程序"getmod"可以帮到你。
+
+如何使用getmod.py
+在使用getmod.py前连接到KGTP。
+
+(gdb) source ~/kgtp/getmod.py
+于是这个脚本将自动装载Linux内核模块到GDB中。
+
+如何使用getmod
+"getmod" 是用C写的所以你可以把它用在任何地方即使是一个嵌入式环境。
+例如：
+
+#下面的命令将把Linux内核模块信息以GDB命令的格式保存到文件~/tmp/mi。
+sudo getmod >~/tmp/mi
+#在GDB那边：
+(gdb) source ~/tmp/mi
+add symbol table from file
+"/lib/modules/2.6.39-rc5+/kernel/fs/nls/nls_iso8859-1.ko" at
+        .text_addr = 0xf80de000
+        .note.gnu.build-id_addr = 0xf80de088
+        .exit.text_addr = 0xf80de074
+        .init.text_addr = 0xf8118000
+        .rodata.str1.1_addr = 0xf80de0ac
+        .rodata_addr = 0xf80de0c0
+        __mcount_loc_addr = 0xf80de9c0
+        .data_addr = 0xf80de9e0
+        .gnu.linkonce.this_module_addr = 0xf80dea00
+#这条GDB命令后，所有Linux内核模块信息都被装载进GDB了。
+#After this GDB command, all the Linux Kernel module info is loaded into
+GDB.
+如果你使用远程调试或者离线调试，你可以需要修改基本目录。下面是一个例子： If you use remote debug or offline
+debug, maybe you need change the base directory. Following example is
+for it.
+
+#/home/teawater/kernel/b26是GDB所在主机上内核模块所在的路径
+sudo ./getmod -r /home/teawater/kernel/b26 >~/tmp/mi
+直接访问内存
+连接上KGTP以后，你可以直接访问大部分内存。
+例如你可以用下面的命令访问"jiffies_64"：
+
+(gdb) p jiffies_64
+或者你可以用下面的命令访问"static LIST_HEAD(modules)"的第一条记录：
+
+(gdb) p *((struct module *)((char *)modules->next - ((size_t) &(((struct
+module *)0)->list))))
+Or you can access to the CPU0 memory info of "DEFINE_PER_CPU(struct
+device , mce_device);": 或者你可以访问"DEFINE_PER_CPU(struct device ,
+mce_device);"CPU0的数据：
+
+p *(struct device *)(__per_cpu_offset[0]+(uint64_t)(&mce_device))
+GDB tracepoint
+tracepoint就是GDB定义一些地址和一些动作。在tracepoint启动之后，当Linux内核执行到那些地址的时候，KGTP将执行这些动
+作(它们中的有些会收集数据并存入tracepoint帧缓冲)并把它们发给调试目标(KGTP)。而后，Linux内核将继续执行。
+KGTP提供了一些接口可以让GDB或者其他程序取出tracepoint帧缓冲的数据做分析。
+关于这些接口，文档前面已经介绍了"/sys/kernel/debug/gtp"，将在后面介绍"/sys/kernel/debug/
+gtpframe" 和 "/sys/kernel/debug/gtpframe_pipe"。
+
+如何使用GDB tracepoint
+请到 http://sourceware.org/gdb/current/onlinedocs/gdb/Tracepoints.html。
+
+trace 位置
+trace命令非常类似break命令，它的参数可以是文件行，函数名或者一个地址。trace将定义一个或者多个地址定义一个tracepoint，K
+GTP将在这个点做一些动作。
+这是一些使用trace命令的例子：
+
+(gdb) trace foo.c:121    // 一个文件和行号
+
+(gdb) trace +2           // 2行以后
+
+(gdb) trace my_function  // 函数的第一行
+
+(gdb) trace *my_function // 函数的第一个地址
+
+(gdb) trace *0x2117c4    // 一个地址
+actions [num]
+这个命令将设置一组action当tracepoint
+num触发的时候执行。如果没有设置num则将设置action到最近创建的tracepoint上(
+因此你可以定义一个tracepoint然后直接输入actions而不需要参数)
+。然后就要在后面输入action，最后以end为结束。到目前为止，支持的action有collect，teval和while-stepping。
+
+collect expr1, expr2, ...
+当tracepoint触发的时候，收集表达式的值。这个命令可接受用逗号分割的一组列表，这些列表除了可以是全局，局部或者本地变量，还可以是下面的这
+些参数：
+
+$regs   收集全部寄存器。
+$args   收集函数参数。
+$locals 收集全部局部变量。
+teval expr1, expr2, ...
+当tracepoint触发的时候，执行指定的表达式。这个命令可接受用逗号分割的一组列表。表达式的结果将被删除，所以最主要的作用是把值设置到tra
+ce状态变量中 (see
+http://code.google.com/p/kgtp/wiki/HOWTOCN#普通trace状态变量)
+，而不用想collect一样把这些值存到trace帧中。
+
+while-stepping n
+请到 http://code.google.com/p/kgtp/wiki/HOWTOCN#如果函数指针被优化掉了 去看如何使用它。
+
+启动和停止 tracepoint
+tracepoint只有在用下面的GDB命令启动后才可以执行action：
+
+(gdb) tstart
+它可以用下面的命令停止：
+
+(gdb) tstop
+Enable 和 disable tracepoint
+和breakpoint一样，tracepoint可以使用GDB命令 "enable" 和 "disable"。但是请 注意
+它们只在tracepoint停止的时候有效。
+
+tfind
+tracepoint停止的时候，GDB命令"tfind"可以用来选择trace帧缓存里面的条目。
+请到 http://sourceware.org/gdb/current/onlinedocs/gdb/tfind.html 取得它的详细信息。
+
+用tracepoint从内核中某点取得寄存器信息
+下面是记录内核调用函数"vfs_readdir"时的寄存器信息的例子：
+
+(gdb) target remote /sys/kernel/debug/gtp
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
+#0  0xc01a1ac1 in vfs_readdir (file=0xc5528d00, filler=0xc01a1900
+<filldir64>,
+   buf=0xc0d09f90) at /home/teawater/kernel/linux-2.6/fs/readdir.c:23
+23      /home/teawater/kernel/linux-2.6/fs/readdir.c: No such file or
+directory.
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
+用tracepoint从内核中某点取得变量的值
+下面是记录内核调用函数"vfs_readdir"时"jiffies_64"的值的例子：
+
+(gdb) target remote /sys/kernel/debug/gtp
+(gdb) trace vfs_readdir
+Tracepoint 1 at 0xc01ed740: file
+/home/teawater/kernel/linux-2.6/fs/readdir.c, line 24.
+(gdb) actions
+Enter actions for tracepoint 1, one per line.
+End with a line saying just "end".
+>collect jiffies_64
+>collect file->f_path.dentry->d_iname
+>end
+(gdb) tstart
+(gdb) shell ls
+arch    drivers   include  kernel    mm               Module.symvers
+security  System.map  virt
+block   firmware  init     lib       modules.builtin  net
+sound     t           vmlinux
+crypto  fs        ipc      Makefile  modules.order    scripts
+source    usr         vmlinux.o
+(gdb) tstop
+(gdb) tfind
+Found trace frame 0, tracepoint 1
+#0  0xc01ed741 in vfs_readdir (file=0xf4063000, filler=0xc01ed580
+<filldir64>, buf=0xd6dfdf90)
+    at /home/teawater/kernel/linux-2.6/fs/readdir.c:24
+24      {
+(gdb) p jiffies_64
+$1 = 4297248706
+(gdb) p file->f_path.dentry->d_iname
+$1 = "b26", '\000' <repeats 28 times>
+如何设置条件tracepoint
+http://sourceware.org/gdb/current/onlinedocs/gdb/Tracepoint-Conditions.
+html
+和breakpoint一样，我们可以设置tracepoint的触发条件。而且因为条件检查是在KGTP执行的，所以速度比breakpoint的条件
+检查快很多。
+例如：
+
+(gdb) trace handle_irq
+(gdb) condition 1 (irq == 47)
+tracepoint 1的动作将只在irq是47的时候才被执行。
+
+如何处理 "Unsupported operator (null) (52) in expression."
+如果你使用关于字符串的条件tracepoint，你在调用"tstart"的时候可能得到这个出错信息。
+你可以转化char为int来处理这个问题，例如：
+
+(gdb) condition 1 (buf[0] == (int)'1')
+显示当前这一条trace缓存里存储的所有信息
+在用"tfind"选择好一个条目后，你可以用"tdump"。
+
+(gdb) tdump
+Data collected at tracepoint 1, trace frame 0:
+$cr = void
+file->f_path.dentry->d_iname =
+"gtp\000.google.chrome.g05ZYO\000\235\337\000\000\000\000\200\067k\364\
+200\067", <incomplete sequence \364>
+jiffies_64 = 4319751455
+取得 tracepoint 的状态
+请用GDB命令"tstatus"。
+
+设置trace缓存为循环缓存
+http://sourceware.org/gdb/current/onlinedocs/gdb/Starting-and-Stopping-
+Trace-Experiments.html
+帧缓存默认情况下不是循环缓存。当缓存满了的时候，tracepoint将停止。
+下面的命令将设置trace缓存为循环缓存，当缓存满了的时候，其将自动删除最早的数据并继续trace。
+
+(gdb) set circular-trace-buffer on
+GDB断开的时候不要停止tracepoint
+http://sourceware.org/gdb/current/onlinedocs/gdb/Starting-and-Stopping-
+Trace-Experiments.html
+默认情况下，当GDB断开KGTP的时候将自动停止tracepoint并删除trace帧。
+下面的命令将打开KGTP
+disconnect-
+trace。在设置之后，当GDB断开KGTP的时候，KGTP将不停止tracepoint。GDB重新连到KGTP的时候，其可以继续控制KGTP。
+
+(gdb) set disconnected-tracing on
+kprobes-optimization和tracepoint的执行速度
+因为tracepoint是和Linux内核一起执行，所以它的速度将影响到系统执行的速度。
+KGTP tracepoint是基于Linux内核kprobe。因为普通kprobe是基于断点指令，所以它的速度不是很快。
+
+但是如果你的arch是X86_64 或者 X86_32 而且内核配置没有打开"Preemptible Kernel"
+(PREEMPT)，kprobe的速度将被kprobes-optimization (CONFIG_OPTPROBES)提高很多。
+可以用下面的命令来确认：
+
+sysctl -A | grep kprobe
+debug.kprobes-optimization = 1
+这个的意思就是你的系统支持kprobes-optimization。
+请 注意
+一些KGTP的功能会导致tracepoint只能使用普通kprobe即使系统支持kprobes-
+optimization。文档将在介绍这些功能的时候增加提醒，如果你很介意tracepoint的速度就请避免使用这些功能。
+
+如果使用trace状态变量
+http://sourceware.org/gdb/current/onlinedocs/gdb/Trace-State-Variables.
+html
+Tracepoint 有特殊变量。这些变量可以被直接trace或者在tracepoint条件中使用。
+请 注意 GDB 7.2.1和更晚的版本直接访问trace状态变量，比他们老的GDB只能通过命令"info
+tvariables"取得trace状态变量的值。
+
+普通trace状态变量
+定义trace状态变量$c.
+
+(gdb) tvariable $c
+trace状态变量 $c 被创建并初始化0。 下面的action将使用$c记录内核里发生了多少次IRQ。
+
+(gdb) target remote /sys/kernel/debug/gtp
+(gdb) trace handle_irq
+(gdb) actions
+Enter actions for tracepoint 3, one per line.
+End with a line saying just "end".
+>collect $c     #Save current value of $c to the trace frame buffer.
+>teval $c=$c+1  #Increase the $c.
+>end
+你还可以将某个变量的值传到状态变量里，但是别忘记转化这个值为"uint64_t"。
+
+>teval $c=(uint64_t)a
+你可以取得$c的值当trace在运行或者停止的时候。
+
+(gdb) tstart
+(gdb) info tvariables
+$c              0           31554
+(gdb) p $c
+$5 = 33652
+(gdb) tstop
+(gdb) p $c
+$9 = 105559
+当使用tfind的时候，你可以分析trace frame buffer。如果trace状态变量被收集了，你可以把它取出来。
+
+(gdb) tstop
+(gdb) tfind
+(gdb) info tvariables
+$c              0           0
+(gdb) p $c
+$6 = 0
+(gdb) tfind 100
+(gdb) p $c
+$7 = 100
+如果需要的时候，访问trace状态变量的tracepoint action将自动加锁，所以其可以很好的处理trace状态变量的竞态条件问题。
+下面这个例子即使在一个多CPU的环境也可以正常使用。
+
+>teval $c=$c+1
+Per_cpu trace状态变量
+Per_cpu trace状态变量是一种特殊的普通trace状态变量。 当一个tracepoint
+action访问到其的时候，其将自动访问这个CPU的Per_cpu trace状态变量。
+它有两个优点：
+1. 访问Per_cpu trace状态变量的tracepoint
+actions不存在竞态条件问题，所以其不需要对trace状态变量加锁。所以其在多核的机器上速度更快。 2.
+写针对记录某个CPU的tracepoint actions比普通trace状态变量更容易。
+
+想定义一个Per_cpu trace状态变量你需要使用如下格式的命名：
+
+"per_cpu_"+string+CPU_id
+或者
+
+"pc_"+string+CPU_id
+下面是一个在4核的主机上用"count"命名一组per_cpu trace状态变量的例子：
+
+(gdb) tvariable $pc_count0
+(gdb) tvariable $pc_count1
+(gdb) tvariable $pc_count2
+(gdb) tvariable $pc_count3
+下面是一个兼容性更好的方法：
+
+(gdb) set $tmp=0
+(gdb) while $tmp<$cpu_number
+ >eval "tvariable $pc_count%d",$tmp
+ >set $tmp=$tmp+1
+ >end
+在tracepoint action可以访问这些per_cpu
+trace状态变量的任意一个，KGTP将自动访问当前CPU的那个trace状态变量。
+例如：
+
+(gdb) trace vfs_read
+(gdb) actions
+>teval $pc_count0=$pc_count0+1
+>end
+这些GDB命令定义了一个记录调用在每个CPU调用了vfs_read多少次的tracepoint。
+
+特殊trace状态变量
+$current_task，$current_task_pid，$current_thread_info，$cpu_id，$dump_stack
+，$printk_level，$printk_format，$printk_tmp，$clock，$hardirq_count，$softirq
+_count 和 $irq_count
+KGTP特殊trace状态变量$current_task，$current_thread_info，$cpu_id 和
+$clock可以很容易的访问各种特殊的值，当你用GDB连到KGTP后就可以访问到他们。
+你可以在tracepoint条件和actions里使用他们。
+在tracepoint条件和actions里访问$current_task可以取得get_current()的返回值。
+在tracepoint条件和actions里访问$current_task_pid可以取得get_current()->pid的值。
+在tracepoint条件和actions里访问$current_thread_info可以取得current_thread_info()
+的返回值。
+在tracepoint条件和actions里访问$cpu_id可以取得smp_processor_id()的返回值。
+在tracepoint条件和actions里访问$clock可以取得local_clock()的返回值，也就是取得纳秒为单位的时间戳。
+$rdtsc只在体系结构是X86或者X86_64的时候访问的到，任何时候访问它可以取得用指令RDTSC取得的TSC的值。
+在tracepoint条件和actions里访问$hardirq_count可以取得hardirq_count()的返回值。
+在tracepoint条件和actions里访问$softirq_count可以取得softirq_count()的返回值。
+在tracepoint条件和actions里访问$irq_count可以取得irq_count()的返回值。
+KGTP还有一些特殊trace状态变量$dump_stack，$printk_level，$printk_format 和
+$printk_tmp。他们可以用来直接显示值，请看http://code.google.com/p/kgtp/wiki/
+HOWTOCN#如何让tracepoint直接输出信息。
+下面是一个用$c记录进程16663调用多少次vfs_read并收集thread_info结构的例子：
+
+(gdb) target remote /sys/kernel/debug/gtp
+(gdb) trace vfs_read if (((struct task_struct *)$current_task)->pid ==
+16663)
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
+$10 = {task = 0xf0ac6580, exec_domain = 0xc07b1400, flags = 0, status =
+0, cpu = 1, preempt_count = 2, addr_limit = {
+    seg = 4294967295}, restart_block = {fn = 0xc0159fb0
+<do_no_restart_syscall>, {{arg0 = 138300720, arg1 = 11,
+        arg2 = 1, arg3 = 78}, futex = {uaddr = 0x83e4d30, val = 11,
+flags = 1, bitset = 78, time = 977063750,
+        uaddr2 = 0x0}, nanosleep = {index = 138300720, rmtp = 0xb,
+expires = 335007449089}, poll = {
+        ufds = 0x83e4d30, nfds = 11, has_timeout = 1, tv_sec = 78,
+tv_nsec = 977063750}}},
+  sysenter_return = 0xb77ce424, previous_esp = 0, supervisor_stack =
+0xef340044 "", uaccess_err = 0}
+这是一个记录每个CPU调用了多少次sys_read()的例子。
+
+(gdb) tvariable $c0
+(gdb) tvariable $c1
+(gdb) trace sys_read
+(gdb) condition $bpnum ($cpu_id == 0)
+(gdb) actions
+>teval $c0=$c0+1
+>end
+(gdb) trace sys_read
+(gdb) condition $bpnum ($cpu_id == 1)
+(gdb) actions
+>teval $c1=$c1+1
+>end
+(gdb) info tvariables
+Name            Initial     Current
+$current_task   0           <unknown>
+$cpu_id         0           <unknown>
+$c0             0           3255
+$c1             0           1904
+sys_read() 在CPU0上被执行了3255次，CPU1上执行了1904次。请 注意
+这个例子只是为了显示如何使用$cpu_id，实际上用per_cpu trace状态变量写更好。
+
+特殊trace状态变量 $no_self_trace
+$no_self_trace和前面介绍的特殊trace状态变量不同，它是用来控制tracepoint的行为的。
+如果一个tracepoint包含一个访问到$no_self_trace的action，则当当前task是KGTP自己的进程（GDB，netcat
+，getframe或者其他访问KGTP接口的进程）的时候，其将不进行记录。
+例如，如果你要记录vfs_read或者其他有进程上下文的东西时候而且你不想trace KGTP自己的进程的时候，增加下面的命令到action里：
+
+>collect $no_self_trace
+请 注意 不和进程上下文（Irq handler, softirq）有关的部分不需要设置这个变量。
+
+用$kret trace函数的结尾
+有时，因为内核是用优化编译的，所以在函数结尾设置tracepoint有时很困难。这时你可以用$kret帮助你。
+$kret是一个类似$no_self_trace的特殊trace状态变量。当你在tracepoint
+action里设置它的值的时候，这个tracepoint将用kretprobe而不是kprobe注册。于是其就可以trace一个函数的结尾。
+请 注意 这个tracepoint 必须用 "function_name" 的格式设置在函数的第一个地址上。
+
+下面的部分是一个例子：
+
+#"*(function_name)" format can make certain that GDB send the first
+address of function to KGTP.
+(gdb) trace *vfs_read
+(gdb) actions
+>teval $kret=0
+#Following part you can set commands that you want.
+用 $ignore_error 和 $last_errno 忽略tstart的错误
+当KGTP在tstart取得错误，这个命令将失败。
+但有时我们需要忽略这个错误信息并让KGTP工作。例如：如果你在inline函数spin_lock设置tracepoint，这个tracepoin
+t将被设置到很多地址上，有一些地址不能设置kprobe，于是它就会让tstart出错。这时你就可以用"$ignore_error"忽略这些错误。
+最后一个错误信息将存在"$last_errno"中。
+
+(gdb) tvariable $ignore_error=1
+这个命令将打开忽略。
+
+(gdb) tvariable $ignore_error=0
+这个命令将关闭忽略。
+
+使用 $cooked_clock 和 $cooked_rdtsc 取得不包含KGTP运行时间的时间信息
+访问这两个trace状态变量可以取得不包含KGTP运行时间的时间信息，于是我们可以取得一段代码更真实的执行时间即使这个tracepoint的ac
+tion比较复杂。
+
+使用 $xtime_sec 和 $xtime_nsec 取得 timespec
+访问trace状态变量将返回用getnstimeofday取得的timespec时间信息。
+$xtime_sec 将返回timespec秒的部分。
+$xtime_nsec 将返回timespec纳秒的部分。
+
+如何 backtrace (stack dump)
+每次你的程序做一个函数调用的时候，
+这次调用的信息就会生成。这些信息包括调用函数的地址，调用参数，局部变量的值。这些信息被存储在我们称为栈帧的地方，栈帧是从调用栈中分配而来。
+
+通过$bt收集栈并用GDB命令"backtrace"进行分析
+因为这个方法更快（因为在trace的时候只收集）而且可以分析出大部分的调用栈中的信息（前面介绍的栈信息都可以分析出来），所以时间你使用这个方法做
+栈分析。
+首先我们需要在tracepoint action中增加命令收集栈。
+GDB收集栈的通常命令是： 在x86_32, 下面的命令将收集512字节的栈内容。
+>collect (unsigned char )$esp@512
+在x86_64, 下面的命令将收集512字节的栈内容。
+>collect (unsigned char )$rsp@512
+在MIPS或者ARM, 下面的命令将收集512字节的栈内容。
+>collect (unsigned char )$sp@512
+这些命令很难记，而且不同的体系结构需要不同的命令。
+KGTP有一个特殊trace状态变量$bt。如果tracepoint
+action访问到它，KGTP将自动收集$bt长度（默认值是512）的栈。下面这个action将收集512字节的栈内存：
+
+>collect $bt
+如果你想改变$bt的值，你可以在"tstart"使用下面这个GDB命令：
+
+(gdb) tvariable $bt=1024
+下面的部分是一个收集栈并用GDB进行分析的例子：
+
+(gdb) target remote /sys/kernel/debug/gtp
+(gdb) trace vfs_readdir
+Tracepoint 1 at 0xffffffff8118c300: file
+/home/teawater/kernel2/linux/fs/readdir.c, line 24.
+(gdb) actions
+Enter actions for tracepoint 1, one per line.
+End with a line saying just "end".
+>collect $bt
+>end
+(gdb) tstart
+(gdb) shell ls
+1      crypto    fs             include  kernel    mm
+Module.symvers  security  System.map  vmlinux
+arch   drivers   hotcode.html   init     lib       modules.builtin  net
+           sound     usr         vmlinux.o
+block  firmware  hotcode.html~  ipc      Makefile  modules.order
+scripts         source    virt
+(gdb) tstop
+(gdb) tfind
+Found trace frame 0, tracepoint 1
+#0  vfs_readdir (file=0xffff8800c5556d00, filler=0xffffffff8118c4b0
+<filldir>, buf=0xffff880108709f40)
+    at /home/teawater/kernel2/linux/fs/readdir.c:24
+24      {
+(gdb) bt
+#0  vfs_readdir (file=0xffff8800c5556d00, filler=0xffffffff8118c4b0
+<filldir>, buf=0xffff880108709f40)
+    at /home/teawater/kernel2/linux/fs/readdir.c:24
+#1  0xffffffff8118c689 in sys_getdents (fd=<optimized out>,
+dirent=0x1398c58, count=32768) at
+/home/teawater/kernel2/linux/fs/readdir.c:214
+#2  <signal handler called>
+#3  0x00007f00253848a5 in ?? ()
+#4  0x00003efd32cddfc9 in ?? ()
+#5  0x00002c15b7d04101 in ?? ()
+#6  0x000019c0c5704bf1 in ?? ()
+#7  0x0000000900000000 in ?? ()
+#8  0x000009988cc8d269 in ?? ()
+#9  0x000009988cc9b8d1 in ?? ()
+#10 0x0000000000000000 in ?? ()
+(gdb) up
+#1  0xffffffff8118c689 in sys_getdents (fd=<optimized out>,
+dirent=0x1398c58, count=32768) at
+/home/teawater/kernel2/linux/fs/readdir.c:214
+214             error = vfs_readdir(file, filldir, &buf);
+(gdb) p buf
+$1 = {current_dir = 0x1398c58, previous = 0x0, count = 32768, error = 0}
+(gdb) p error
+$3 = -9
+(gdb) frame 0
+#0  vfs_readdir (file=0xffff8800c5556d00, filler=0xffffffff8118c4b0
+<filldir>, buf=0xffff880108709f40)
+    at /home/teawater/kernel2/linux/fs/readdir.c:24
+24      {
+从这个例子，我们可以看到一些分析调用栈的GDB命令：
+bt 是GDB命令 backtrace 的别名，这个命令将打印stack中的信息：每一行是一个调用栈。
+up n 是向上移动n个帧。如果n是正数，则向外到更高的帧，一直到这个栈最大的一行。n的默认值是1。
+down n 是向下移动n个帧。如果n是正数，则向内到更低的帧，一直到最新创建的那个栈帧。n的默认值是1。
+is move n frames down the stack. For positive numbers n, this advances
+toward the innermost frame, to lower frame numbers, to frames that were
+created more recently. n defaults to one. 你可以把 down 缩写为 do。
+frame n 是选择帧n。帧0是最近创建的帧，帧1调用这个帧的帧。所以最高的帧是main。
+你还可以看到当你用up，down或者frame来选择调用栈帧的时候，你可以输出不同帧的参数和局部变量。
+要取得更多关于如何使用GDB分析调用栈的信息，请到http://sourceware.org/gdb/current/onlinedocs/
+gdb/Stack.html。
+用$_ret来取得当前函数的调用函数的栈
+如果你只想取得当前函数的调用函数的栈，可以用$_ret。
+请 注意 使用$_ret的tracepoint不能设置在函数的第一个地址上。
+例如：
+
+(gdb) list vfs_read
+360     }
+361
+362     EXPORT_SYMBOL(do_sync_read);
+363
+364     ssize_t vfs_read(struct file *file, char __user *buf, size_t
+count, loff_t *pos)
+365     {
+366             ssize_t ret;
+367
+368             if (!(file->f_mode & FMODE_READ))
+369                     return -EBADF;
+(gdb) trace 368
+Tracepoint 2 at 0xffffffff8117a244: file
+/home/teawater/kernel2/linux/fs/read_write.c, line 368.
+(gdb) actions
+Enter actions for tracepoint 2, one per line.
+End with a line saying just "end".
+>collect $_ret
+>end
+(gdb) tstart
+(gdb) tstop
+(gdb) tfind
+Found trace frame 0, tracepoint 2
+#0  vfs_read (file=0xffff880141c46000, buf=0x359bda0 <Address 0x359bda0
+out of bounds>, count=8192, pos=0xffff88012fa49f48)
+    at /home/teawater/kernel2/linux/fs/read_write.c:368
+368             if (!(file->f_mode & FMODE_READ))
+(gdb) bt
+#0  vfs_read (file=0xffff880141c46000, buf=0x359bda0 <Address 0x359bda0
+out of bounds>, count=8192, pos=0xffff88012fa49f48)
+    at /home/teawater/kernel2/linux/fs/read_write.c:368
+#1  0xffffffff8117a3ea in sys_read (fd=<optimized out>,
+buf=<unavailable>, count=<unavailable>)
+    at /home/teawater/kernel2/linux/fs/read_write.c:469
+Backtrace stopped: not enough registers or memory available to unwind
+further
+(gdb) up
+#1  0xffffffff8117a3ea in sys_read (fd=<optimized out>,
+buf=<unavailable>, count=<unavailable>)
+    at /home/teawater/kernel2/linux/fs/read_write.c:469
+469                     ret = vfs_read(file, buf, count, &pos);
+(gdb) p ret
+$2 = -9
+我们可以看到调用vfs_read的函数是sys_read，函数sys_read的局部变量ret的值是-9。
+
+用 $dump_stack 输出栈分析到printk里
+因为这个方法需要在trace的时候分析栈并调用printk，所以它比较慢，不安全，不清晰也不能访问调用栈中的很多内容，所以我建议你上一部分介绍的
+方法
+KGTP有一个特殊的trace状态变量$dump_stack，收集这个变量可以令GDB调用栈分析并用printk输出。
+下面是一个让内核输出vfs_readdir栈分析的例子：
+
+target remote /sys/kernel/debug/gtp
+trace vfs_readdir
+  commands
+    collect $dump_stack
+  end
+于是你的内核就会printk这样的信息：
+
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
+[22779.208112]  [<c02db51f>] ?
+__jbd2_journal_temp_unlink_buffer+0x2f/0x110
+[22779.208115]  [<fe655c4c>] gtp_kp_pre_handler+0xcc/0x1c0 [gtp]
+[22779.208118]  [<c05b8a88>] kprobe_exceptions_notify+0x3d8/0x440
+[22779.208121]  [<c05b7d54>] ?
+hw_breakpoint_exceptions_notify+0x14/0x180
+[22779.208124]  [<c05b95eb>] ? sub_preempt_count+0x7b/0xb0
+[22779.208126]  [<c0227ac5>] ? vfs_readdir+0x15/0xb0
+[22779.208128]  [<c0227ac4>] ? vfs_readdir+0x14/0xb0
+[22779.208131]  [<c05b9743>] notifier_call_chain+0x43/0x60
+[22779.208134]  [<c05b9798>] __atomic_notifier_call_chain+0x38/0x50
+[22779.208137]  [<c05b97cf>] atomic_notifier_call_chain+0x1f/0x30
+[22779.208140]  [<c05b980d>] notify_die+0x2d/0x30
+[22779.208142]  [<c05b71c5>] do_int3+0x35/0xa0
+如何使用性能计数器
+性能计数器是大部分现代CPU都有的特殊硬件寄存器。这些寄存器对一些硬件事件进行计数：例如指令执行数量，cachemisses数量，分支预测失败数
+，而且这些计数不会让应用程序或者内核变慢。其还可以设置到达一定的值的时候发生中断，这些就可以用来分析在某CPU上执行程序的性能。
+Linux性能计数器子系统perf event可以用来取得性能计数器的值。你可以用KGTP perf event trace状态变量访问这些值。
+请读内核目录里的tools/perf/design.txt文件取得perf event的更多信息。
+
+定义一个perf event trace状态变量
+访问一个性能计数器需要定义下面的trace状态变量：
+
+"pe_cpu_"+tv_name       定义性能计数器的CPU ID。
+"pe_type_"+tv_name      定义性能计数器的类型。
+"pe_config_"+tv_name    定义性能计数器的配置。
+"pe_en_"+tv_name        定义性能计数器的启动开关。
+                        默认情况下性能计数器是关闭的。
+"pe_val_"+tv_name       访问这个变量能取得性能计数器的值。
+定义一个per_cpu perf event trace状态变量
+定义一个per_cpu perf event
+trace状态变量和http://code.google.com/p/kgtp/wiki/
+HOWTOCN#Per_cpu_trace状态变量一样。
+
+"pc_pe_"+perf_event type+string+CPU_id
+请 注意 如果定义一个per_cpu perf event trace状态变量，就不需要在定义cpu
+id("pe_cpu")因为KGTP已经取得了CPU的ID。
+
+perf event的类型和配置
+类型可以是：
+
+0       PERF_TYPE_HARDWARE
+1       PERF_TYPE_SOFTWARE
+2       PERF_TYPE_TRACEPOINT
+3       PERF_TYPE_HW_CACHE
+4       PERF_TYPE_RAW
+5       PERF_TYPE_BREAKPOINT
+如果类型是0(PERF_TYPE_HARDWARE)，配置可以是：
+
+0       PERF_COUNT_HW_CPU_CYCLES
+1       PERF_COUNT_HW_INSTRUCTIONS
+2       PERF_COUNT_HW_CACHE_REFERENCES
+3       PERF_COUNT_HW_CACHE_MISSES
+4       PERF_COUNT_HW_BRANCH_INSTRUCTIONS
+5       PERF_COUNT_HW_BRANCH_MISSES
+6       PERF_COUNT_HW_BUS_CYCLES
+7       PERF_COUNT_HW_STALLED_CYCLES_FRONTEND
+8       PERF_COUNT_HW_STALLED_CYCLES_BACKEND
+
+如果类型是3(PERF_TYPE_HW_CACHE)，配置要分为3部分： 第一部分是cache id，其在设置进配置的时候需要 << 0：
+
+0       PERF_COUNT_HW_CACHE_L1D
+1       PERF_COUNT_HW_CACHE_L1I
+2       PERF_COUNT_HW_CACHE_LL
+3       PERF_COUNT_HW_CACHE_DTLB
+4       PERF_COUNT_HW_CACHE_ITLB
+5       PERF_COUNT_HW_CACHE_BPU
+第二部分是cache op id，其在设置进配置的时候需要 << 8：
+
+0       PERF_COUNT_HW_CACHE_OP_READ
+1       PERF_COUNT_HW_CACHE_OP_WRITE
+2       PERF_COUNT_HW_CACHE_OP_PREFETCH
+第三部分是cache op result id，其在设置进配置的时候需要 << 16：
+
+0       PERF_COUNT_HW_CACHE_RESULT_ACCESS
+1       PERF_COUNT_HW_CACHE_RESULT_MISS
+如果你想取得PERF_COUNT_HW_CACHE_L1I(1), PERF_COUNT_HW_CACHE_OP_WRITE(1) and
+PERF_COUNT_HW_CACHE_RESULT_MISS(1)你需要使用：
+
+(gdb) tvariable $pe_config_cache=1 | (1 << 8) | (1 << 16)
+内核目录中的tools/perf/design.txt是关于perf event的类型和配置。
+
+用$pc_pe_en打开和关闭一个CPU上所有的perf event
+我认为取得一段代码的性能计数器信息比较好的办法是在函数开头打开计数器在函数结束的时候关闭计数器。你可以用"pe_en"设置他们，但是如果你有多个
+perf event trace状态变量的时候，这样会让tracepoint action很大。$pc_pe_en就是处理这种问题的。
+你可以打开所有perf event trace状态变量在当前CPU上用下面的action：
+
+>teval $pc_pe_en=1
+设置$pc_pe_en为0来关闭他们。
+
+>teval $pc_pe_en=0
+用来帮助设置和取得perf event trace状态变量的GDB脚本
+下面这个GDB脚本定义了2个命令dpe和spe来帮助定义和显示perf event trace状态变量。
+你可以把他们存在~/.gdbinit或者你自己的tracepoint脚本中。于是你就可以在GDB中直接使用这2个命令。
+
+define dpe
+  if ($argc < 2)
+    printf "Usage: dpe pe_type pe_config [enable]\n"
+  end
+  if ($argc >= 2)
+    set $tmp=0
+    while $tmp<$cpu_number
+      eval "tvariable $pc_pe_type_%d%d_%d=%d",$arg0, $arg1, $tmp, $arg0
+      eval "tvariable $pc_pe_config_%d%d_%d=%d",$arg0, $arg1, $tmp,
+$arg1
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
+Usage: dpe pe_type pe_config [enable]
+end
+
+define spe
+  if ($argc != 2 && $argc != 3)
+    printf "Usage: spe pe_type pe_config [cpu_id]\n"
+  end
+  if ($argc == 2)
+    set $tmp=0
+    while $tmp<$cpu_number
+      eval "printf \"$pc_pe_val_%%d%%d_%%d=%%ld\\n\",$arg0, $arg1, $tmp,
+$pc_pe_val_%d%d_%d", $arg0, $arg1, $tmp
+      set $tmp=$tmp+1
+    end
+  end
+  if ($argc == 3)
+    eval "printf \"$pc_pe_val_%%d%%d_%%d=%%ld\\n\",$arg0, $arg1, $tmp,
+$pc_pe_val_%d%d_%d", $arg0, $arg1, $arg2
+  end
+end
+
+document spe
+Usage: spe pe_type pe_config [cpu_id]
+end
+下面是一个取得函数tcp_v4_rcv性能计数器的例子：
+
+#连接KGTP
+(gdb) target remote /sys/kernel/debug/gtp
+#定义3个perf event
+trace状态变量PERF_COUNT_HW_CPU_CYCLES，PERF_COUNT_HW_CACHE_MISSES和PERF_COUNT_
+HW_BRANCH_MISSES。
+(gdb) dpe 0 0
+(gdb) dpe 0 3
+(gdb) dpe 0 5
+#在函数开头打开这个CPU的性能寄存器
+(gdb) trace tcp_v4_rcv
+(gdb) action
+>teval $pc_pe_en=1
+>end
+#$kret 让我们可以处理到函数tcp_v4_rcv的结尾：
+(gdb) trace *(tcp_v4_rcv)
+(gdb) action
+>teval $kret=0
+#关闭这个CPU上的所有性能计数器
+>teval $pc_pe_en=0
+#访问这些perf event trace状态变量将取得他们的值
+>collect $pc_pe_val_00_0
+>collect $pc_pe_val_03_0
+>collect $pc_pe_val_05_0
+#设置这些perf event trace状态变量为0
+>teval $pc_pe_val_00_0=0
+>teval $pc_pe_val_03_0=0
+>teval $pc_pe_val_05_0=0
+>end
+tstart
+#等一会让每个CPU收一些TCP包
+(gdb) tstop
+(gdb) tfind
+(gdb) spe 0 0 $cpu_id
+$pc_pe_val_00_2=12676
+(gdb) spe 0 3 $cpu_id
+$pc_pe_val_03_2=7
+(gdb) spe 0 5 $cpu_id
+$pc_pe_val_05_2=97
+如何让tracepoint直接输出信息
+在前面的章节，你可以看到如果想取得Linux内核的信息，你需要用tracepoint "collect"
+action来保存信息到tracepoint帧中并用GDB tfind命来来分析这些数据帧。
+但是有时我们希望直接取得这些数据，所以KGTP提供了一种直接取得这些数据的方法。
+
+切换collect为直接输出数据
+KGTP有特殊trace状态变量$printk_level，$printk_format 和 $printk_tmp支持这个功能。
+$printk_level，如果这个值是8（这是默认值），"collect" action将是普通行为也就是保存数据到tracepoint帧中。
+如果值是0-7，"collect" 将以这个数字为printk级别输出信息，这些级别是：
+
+0       KERN_EMERG      system is unusable
+1       KERN_ALERT      action must be taken immediately
+2       KERN_CRIT       critical conditions
+3       KERN_ERR        error conditions
+4       KERN_WARNING    warning conditions
+5       KERN_NOTICE     normal but significant condition
+6       KERN_INFO       informational
+7       KERN_DEBUG      debug-level messages
+$printk_format，collect printk将按照这里设置的格式进行输出。 这些格式是：
+
+0       这是默认值。
+        如果collect的长度是1，2，4，8则其将输出一个无符号十进制数。
+        如果不是，则其将输出十六进制字串。
+1       输出值是有符号十进制数。
+2       输出值是无符号十进制数。
+3       输出值是无符号十六进制数。
+4       输出值是字符串。
+5       输出值是十六进制字串。
+如果要输出一个全局变量，需要将其先设置到$printk_tmp中。
+
+下面是一个显示调用vfs_readdir时的计数，pid，jiffies_64和文件名的例子：
+
+(gdb) target remote /sys/kernel/debug/gtp
+(gdb) tvariable $c
+(gdb) trace vfs_readdir
+(gdb) actions
+>teval $printk_level=0
+>collect $c=$c+1
+>collect ((struct task_struct *)$current_task)->pid
+>collect $printk_tmp=jiffies_64
+>teval $printk_format=4
+>collect file->f_path.dentry->d_iname
+>end
+于是内核将printk这些信息：
+
+gtp 1:$c=$c+1=41
+gtp 1:((struct task_struct *)$current_task)->pid=12085
+gtp 1:$printk_tmp=jiffies_64=4322021438
+gtp 1:file->f_path.dentry->d_iname=b26
+gtp 1:$c=$c+1=42
+gtp 1:((struct task_struct *)$current_task)->pid=12085
+gtp 1:$printk_tmp=jiffies_64=4322021438
+gtp 1:file->f_path.dentry->d_iname=b26
+"gtp 1" 的意思是数据是tracepoint 1输出的。
+
+如何显示被优化掉的变量值
+有时GDB会这样输出信息：
+
+inode has been optimized out of existence.
+res has been optimized out of existence.
+这是因为inode和res的值被优化掉了。内核用-O2编译的所以你有时会碰到这个问题。
+有两个方法处理这个问题：
+
+升级你的GCC
+VTA branch (http://gcc.gnu.org/wiki/Var_Tracking_Assignments)已经整合进GCC
+4.5，其可以帮助生成之前被标记为"optimized out"的值的调试信息。
+
+如何取得函数指针指向的函数
+如果函数指针没有被优化掉
+你可以直接collect这个指针，例如：
+
+377                     count = ret;
+378                     if (file->f_op->read)
+379                             ret = file->f_op->read(file, buf, count,
+pos);
+(gdb)
+(gdb) trace 379
+Tracepoint 1 at 0xffffffff81173ba5: file
+/home/teawater/kernel/linux/fs/read_write.c, line 379.
+(gdb) actions
+Enter actions for tracepoint 1, one per line.
+End with a line saying just "end".
+>collect file->f_op->read
+>end
+(gdb) tstart
+(gdb) tstop
+(gdb) tfind
+(gdb) p file->f_op->read
+$5 = (ssize_t (*)(struct file *, char *, size_t, loff_t *))
+0xffffffff81173190 <do_sync_read>
+#于是就知道file->f_op->read指向do_sync_read。
+如果函数指针被优化掉了
+可以用tracepoint step处理这个问题，例如：
+
+#找到调用指针的指令
+(gdb) disassemble /rm vfs_read
+379                             ret = file->f_op->read(file, buf, count,
+pos);
+   0xffffffff81173ba5 <+181>:   48 89 da        mov    %rbx,%rdx
+   0xffffffff81173ba8 <+184>:   4c 89 e9        mov    %r13,%rcx
+   0xffffffff81173bab <+187>:   4c 89 e6        mov    %r12,%rsi
+   0xffffffff81173bae <+190>:   4c 89 f7        mov    %r14,%rdi
+   0xffffffff81173bb1 <+193>:   ff d0   callq  *%rax
+   0xffffffff81173bb3 <+195>:   48 89 c3        mov    %rax,%rbx
+(gdb) trace *0xffffffff81173bb1
+Tracepoint 1 at 0xffffffff81173bb1: file
+/home/teawater/kernel/linux/fs/read_write.c, line 379.
+(gdb) actions
+Enter actions for tracepoint 1, one per line.
+End with a line saying just "end".
+>while-stepping 1
+ >collect $reg
+ >end
+>end
+(gdb) tstart
+(gdb) tstop
+(gdb) tfind
+#0  tty_read (file=0xffff88006ca74900, buf=0xb6b7dc <Address 0xb6b7dc
+out of bounds>, count=8176,
+    ppos=0xffff88006e197f48) at
+/home/teawater/kernel/linux/drivers/tty/tty_io.c:960
+960     {
+#于是就知道file->f_op->read指向tty_read。
+请 注意 while-stepping 将让tracepoint不能使用kprobes-optimization。
+
+/sys/kernel/debug/gtpframe和离线调试
+/sys/kernel/debug/gtpframe是一个当KGTP停止时的tfine格式（GDB可以读取它）的接口。
+在运行GDB的主机上：
+改变 "target remote XXXX" 为：
+
+(gdb) target remote | perl ./getgtprsp.pl
+之后像平时一样设置tracepoint：
+
+(gdb) trace vfs_readdir
+Tracepoint 1 at 0xffffffff8114f3c0: file
+/home/teawater/kernel/linux-2.6/fs/readdir.c, line 24.
+(gdb) actions
+Enter actions for tracepoint 1, one per line.
+End with a line saying just "end".
+#If your GDB support tracepoint "printf" (see "Howto use tracepoint
+printf"), use it to show the value directly is better.
+>collect $reg
+>end
+(gdb) tstart
+(gdb) stop
+(gdb) quit
+于是你可以在当前目录找到文件gtpstart和gtpstop，把他们拷贝到你想调试的主机上。
+
+在被调试主机insmod gtp.ko之后：
+启动tracepoint：
+
+cat gtpstart > /sys/kernel/debug/gtp
+停止tracepoint：
+
+cat gtpstop > /sys/kernel/debug/gtp
+可以按照http://code.google.com/p/kgtp/wiki/
+HOWTOCN#如何让tracepoint直接输出信息直接在板子上显示信息。
+
+如果要保存trace帧之后再分析，你可以拷贝文件"/sys/kernel/debug/gtpframe"到有GDB的主机上。
+请 注意 有些"cp"不能很好的处理这个问题，可以用"cat /sys/kernel/debug/gtpframe >
+./gtpframe"拷贝它。
+在运行GDB的主机上：
+(gdb) target tfile ./gtpframe
+Tracepoint 1 at 0xffffffff8114f3dc: file
+/home/teawater/kernel/linux-2.6/fs/readdir.c, line 24.
+Created tracepoint 1 for target's tracepoint 1 at 0xffffffff8114f3c0.
+(gdb) tfind
+Found trace frame 0, tracepoint 1
+#0  vfs_readdir (file=0xffff880036e8f300, filler=0xffffffff8114f240
+<filldir>, buf=0xffff880001e5bf38)
+    at /home/teawater/kernel/linux-2.6/fs/readdir.c:24
+24      {
+如何使用 /sys/kernel/debug/gtpframe_pipe
+这个接口提供和"gtpframe"同样的数据，但是可以在KGTP
+tracepoint运行的时候也可以使用。在数据读出之后，其将自动从trace帧里删除类似ftrace "trace_pipe"。
+
+用GDB读帧信息
+#连接到接口上
+(gdb) target tfile /sys/kernel/debug/gtpframe_pipe
+#取得一个trace帧条目
+(gdb) tfind 0
+Found trace frame 0, tracepoint 1
+#取得下一个
+(gdb) tfind
+Target failed to find requested trace frame.
+(gdb) tfind 0
+Found trace frame 0, tracepoint 1
+这个方法和python一起分析内核比较好，add-ons/hotcode.py就是这样的例子。
+
+用cat读帧信息
+sudo cat /sys/kernel/debug/gtpframe_pipe > g
+于是所有帧信息都被存入了文件"g"。
+
+用getframe读帧信息
+KGTP包含一个"getframe"可以用来帮助取得trace帧。
+下面这里是它的帮助：
+
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
+使用 $pipe_trace
+为了锁安全，KGTP默认将自动忽略读/sys/kernel/debug/gtpframe_pipe的任务。
+如果你真希望trace这个任务而且确定这是安全的，你可以使用"tstart"之前使用下面的命令：
+
+(gdb) tvariable $pipe_trace=1
+于是KGTP将不再忽略读/sys/kernel/debug/gtpframe_pipe的任务。
+
+如何使用 add-ons/hotcode.py
+这个脚本可以通过记录并分析中断处理时候的取得的PC值从而得到Linux kernel或者用户层程序的热点代码。
+请到 http://code.google.com/p/kgtp/wiki/hotcode 去看如何使用它。
--- /dev/null
+++ b/Documentation/gtp/quickstart.txt
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
+echo "deb http://ddebs.ubuntu.com $(lsb_release -cs) main restricted universe multiverse" | \
+sudo tee -a /etc/apt/sources.list.d/ddebs.list
+
+Stable releases (not alphas and betas) require three more lines adding to the
+same file, which is done by the following terminal command:
+echo "deb http://ddebs.ubuntu.com $(lsb_release -cs)-updates main restricted universe multiverse
+deb http://ddebs.ubuntu.com $(lsb_release -cs)-security main restricted universe multiverse
+deb http://ddebs.ubuntu.com $(lsb_release -cs)-proposed main restricted universe multiverse" | \
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
+sudo tar vxjf /usr/src/linux-source-$(uname -r | sed 's/-.*//').tar.bz2 -C /build/buildd/
+sudo mv /build/buildd/linux-source-$(uname -r | sed 's/-.*//') /build/buildd/linux-$(uname -r | sed 's/-.*//')
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
+Tracepoint 1 at 0xc02289f0: file /build/buildd/linux-2.6.35/fs/readdir.c, line 23.
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
+#0  vfs_readdir (file=0x0, filler=0x163d8ae3, buf=0x18c0) at readdir.c:23
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
+co.patch                  getframe      getmod.c   gtp.mod.c  gtp.txt         perf_event.c
+dkms.conf                 getframe.c    getmod.py  gtp.mod.o  Makefile        ring_buffer.c
+dkms_others_install.sh    getgtprsp.pl  gtp.c      gtp.o      modules.order   ring_buffer.h
+dkms_others_uninstall.sh  getmod        gtp.ko     gtp.patch  Module.symvers
+(gdb) tstop
+(gdb) tfind
+Found trace frame 0, tracepoint 1
+#0  vfs_readdir (file=0xffff880019d3df00, filler=0xffffffff8110eb16 <filldir>, buf=0xffff880003b39f38)
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
