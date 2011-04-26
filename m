Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957Ab1DZCA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 22:00:29 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:59627 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932936Ab1DZCAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 22:00:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=r/IeZiJLbOmYGo8X5fiIR5zD+K1WtSnC3+8OsIn/Dgd+zN4a06T9nStUonwByPW2F0raxhSXvSoUAPmM8k+qgImncG2CGA0MKTRKLSjE7qVr5AQxgRTpNs+aI1e5nN10;
Date: Mon, 25 Apr 2011 19:00:22 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Hui Zhu <teawater@gmail.com>
Cc: linux-kernel@vger.kernel.org, Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        Steven <mqyoung@gmail.com>, colyli@gmail.com,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: KGTP (Linux Kernel debugger and tracer) 20110424 release
Message-Id: <20110425190022.a5a923e3.rdunlap@xenotime.net>
In-Reply-To: <BANLkTinOwu+MazHDhJLtsSZVkJHLBtWSzw@mail.gmail.com>
References: <BANLkTinOwu+MazHDhJLtsSZVkJHLBtWSzw@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Apr 2011 22:28:13 +0800 Hui Zhu wrote:

> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -1253,6 +1253,15 @@ config ASYNC_RAID6_TEST
> 
>  	  If unsure, say N.
> 
> +config GTP
> +	tristate "GDB tracepoint support"
> +	depends on X86 || ARM || MIPS
> +	depends on KPROBES
> +	depends on DEBUG_FS
> +	---help---
> +	  Supply GDB tracepoint interface in /sys/kernel/debug/gtp.
> +          See https://code.google.com/p/kgtp/wiki/HOWTO

Align the 2 help lines by using tab + 2 spaces on them.

Also, the second line (URL) is duplicated in this patch, so consider something
like the following:

	help
	  Supply GDB tracepoint interface in /sys/kernel/debug/gtp.
	  See Documentation/trace/gtp.txt for more info, or
	  https://code.google.com/p/kgtp/wiki/HOWTO may contain more
	  current information.

> +
>  source "samples/Kconfig"
> 
>  source "lib/Kconfig.kgdb"



> --- /dev/null
> +++ b/Documentation/trace/gtp.txt
> @@ -0,0 +1,873 @@
> +		Linux Kernel GDB tracepoint module (KGTP)
> +		=========================================
> +		By Hui Zhu <teawater@gmail.com>
> +		https://code.google.com/p/kgtp/wiki/HOWTO
> +		2011-04-24
> +
> +Table of contents
> +-----------------
> +
> +What is KGTP
> +Report issue about KGTP

          issues

> +Get info about GDB tracepoint
> +Get KGTP through http
> +Get KGTP through svn
> +Config KGTP
> +Compile KGTP
> +Install KGTP
> +Uninstall KGTP
> +Howto use
> +	Exec it
> +	Make GDB connect to gtp
> +	Add module symbols to GDB
> +	Get GDB tracepoint commands
> +	Get registers info from Kernel

	Get register info from Kernel

> +	Get the value of variable from Kernel
> +	How to use use tracepoint condition
> +	How to use trace state variables
> +		Simple trace state variables
> +		Special trace state variables $current_task,
> +		    $current_thread_info, $cpu_id, $dump_stack, $printk_level,
> +		    $printk_format, $printk_tmp and $clock
> +	Show all the traced data of current frame
> +	Get backtrace info from Kernel
> +	Howto let tracepoint output value directly

	Howto get

> +		Output stack dump directly
> +		Switch collect to output the value directly
> +		Use printf command in actions
> +	Get status of KGTP from Kernel
> +	Set the trace buffer into a circular buffer
> +	Do not stop tracepoint when the GDB disconnect

	                       when GDB is disconnected

> +	Howto show the variable that value of it is optimized

	Howto show a variable whose value has been optimized away

> +		Linux kernel "Compile with almost no optimization" patch
> +		Update your GCC
> +	Offline debug
> +
> +
> +
> +
> +What is KGTP
> +------------
> +
> +KGTP is a realtime and lightweight Linux Kernel GDB debugger and tracer that
> +use Kprobe.

   uses Kprobes.

> +
> +It make Linux Kernel supply a GDB remote debug interface. Then GDB in current

   It makes

> +machine or remote machine(see "Make GDB connect to gtp") can debug Linux

                     machine (see

> +through GDB tracepoint without stop the Linux Kernel.

                                  stopping

> +And even if the board doesn't have GDB on it and doesn't have interface for
> +remote debug. It can debug the Linux Kernel use offline debug (See "Offline

          debug, it can debug the Linux Kernel using offline

> +debug").
> +It support X86-32, X86-64, MIPS and ARM.

      supports

> +http://www.tudou.com/programs/view/_p6VTgxmCRA/ This is a video(in Chinese)

                                                             video (in Chinese)

> +to show how to use it.
> +
> +
> +
> +
> +Report issue about KGTP

          issues

> +-----------------------
> +You can post it in https://code.google.com/p/kgtp/issues/list or write Email
> +to teawater@gmail.com.
> +
> +
> +
> +
> +Get info about GDB tracepoint
> +-----------------------------
> +Please goto http://sourceware.org/gdb/current/onlinedocs/gdb/Tracepoints.html
> +
> +
> +
> +
> +Get KGTP through http
> +---------------------
> +Please goto http://code.google.com/p/kgtp/downloads/list OR UPDATE to down

                                                                         download

> +the package.
> +
> +
> +
> +
> +Get KGTP through svn
> +--------------------
> +Some people have trouble with access to KGTP website. You can access kgtp
> +through svn:
> +
> +------------------------------------------------------------
> +svn checkout http://kgtp.googlecode.com/svn/ kgtp-read-only
> +------------------------------------------------------------
> +
> +kgtp-read-only/tags/ There is the each release of KGTP.

(maybe this?)
                         Present for each release of KGTP.

> +kgtp-read-only/trunk/ There is the main trunk of KGTP.

                          Present for the main trunk of KGTP.

> +
> +
> +
> +
> +Config KGTP
> +-----------
> +
> +Before compile KGTP, you can choice which Kernel you want build with and

          compiling KGTP, you can choose

> +which compiler you want through change the Makefile. For example:

                           by making changes to the Makefile.  For example:

> +
> +-------------------------------------------
> +KERNELDIR := /lib/modules/`uname -r`/build
> +CROSS_COMPILE :=
> +-------------------------------------------
> +
> +KERNELDIR is set the directory which Kernel you want build for. Now it set to

                set to the directory of the Kernel that you want to build for.
   Now it is set to the current kernel that is running.

> +the current kernel that you use.
> +CROSS_COMPILE is set the compiler that you want to build the KGTP. Empty mean

                 is set to the compiler that you want to use to build the KGTP.
   Empty means to use the current compiler.

> +use current compiler.
> +ARCH is the architecture.
> +
> +------------------------------------------
> +KERNELDIR := /home/teawater/kernel/bamd64
> +CROSS_COMPILE :=x86_64-glibc_std-
> +ARCH := x86_64
> +------------------------------------------
> +
> +KERNELDIR is set to /home/teawater/kernel/bamd64. Compiler will
> +use x86_64-glibc_std-gcc.
> +
> +
> +
> +
> +Compile KGTP
> +------------
> +
> +For normal use:
> +
> +---------
> +cd kgtp/
> +make
> +---------
> +
> +If you want KGTP out the debug message,please use following (It is available

                    to output debug messages, please

> +after 20100825):
> +
> +---------
> +cd kgtp/
> +make D=1
> +---------
> +
> +
> +
> +
> +Install KGTP
> +------------
> +
> +------------------
> +cd kgtp/
> +sudo make install
> +------------------
> +
> +
> +
> +
> +Uninstall KGTP
> +--------------
> +
> +--------------------
> +cd kgtp/
> +sudo make uninstall
> +--------------------
> +
> +
> +
> +
> +Howto use
> +---------
> +
> +Exec it
> +-------
> +
> +If you had installed the KGTP in your system, you can:

          have installed KGTP in

> +
> +------------------
> +sudo modprobe gtp
> +------------------
> +
> +Or you can use the kgtp module in the directory.
> +
> +-------------------
> +cd kgtp/
> +sudo insmod gtp.ko
> +-------------------
> +
> +
> +
> +Make GDB connect to gtp
> +-----------------------
> +
> +In current machine:
> +
> +---------------------------------
> +sudo gdb ./vmlinux
> +(gdb) target remote /sys/kernel/debug/gtp
> +Remote debugging using /sys/kernel/debug/gtp
> +0x0000000000000000 in ?? ()
> +---------------------------------
> +
> +In remote machine:
> +
> +---------------------------------------------
> +#Open the KGTP interface in current machine.
> +sudo su

Are both of those needed?

> +nc -l 1234 </sys/kernel/debug/gtp >/sys/kernel/debug/gtp
> +(nc -l -p 1234 </sys/kernel/debug/gtp >/sys/kernel/debug/gtp for old version
> +netcat.)
> +#Let gdb connect to the port 1234
> +gdb ./vmlinux
> +(gdb) target remote xxx.xxx.xxx.xxx:1234
> +---------------------------------------------
> +
> +
> +
> +Add module symbols to GDB
> +-------------------------
> +
> +Sometime, you need add the Linux Kernel module(lkm) symbols to GDB to debug it.

   Sometimes you need to add a Linux kernel module's symbols to GDB to debug it.

> +Following a example howto add ext3.ko's symbols to GDB:

   Following is an example of howto add ext.ko's symbols to GDB:

> +
> +--------------------------------------------------------------------------------
> +cat /proc/modules  | grep ext
> +ext3 116512 3 - Live 0xf9083000
> +#Get the address 0xf9083000.
> +modinfo ext3
> +filename:       /lib/modules/2.6.36-rc2+/kernel/fs/ext3/ext3.ko
> +#Get the directory name of ext3.
> +(gdb) add-symbol-file /lib/modules/2.6.36-rc2+/kernel/fs/ext3/ext3.ko
> 0xf9083000
> +#Then, GDB get the symbols of ext3.
> +--------------------------------------------------------------------------------
> +
> +You will see that it just add the text section info to GDB, sometime you need

                             adds                         GDB. Sometimes you need

> +add another section info of other section, for example:

   to add section info of another section, for example:

> +
> +--------------------------------------------------------------------------------
> +cat /sys/module/ext3/sections/.bss
> +0xf908170c
> +#Get the bss address 0xf908170c.
> +(gdb) add-symbol-file /lib/modules/2.6.36-rc2+/kernel/fs/ext3/ext3.ko
> 0xf9083000 -s .bss 0xf908170c
> +#Then, GDB get the symbols of ext3.
> +--------------------------------------------------------------------------------
> +
> +
> +
> +Get GDB tracepoint commands
> +---------------------------
> +
> +Please goto http://sourceware.org/gdb/current/onlinedocs/gdb/Tracepoints.html
> +
> +
> +Get registers info from Kernel

       register info

> +------------------------------
> +
> +Following part is an example that record the value of all registers when Linux

                                     records

> +Kernel call function "vfs_readdir".

          calls

> +
> +--------------------------------------------------------------------------------
> +(gdb) trace vfs_readdir
> +Tracepoint 1 at 0xc01a1ac0: file
> +/home/teawater/kernel/linux-2.6/fs/readdir.c, line 23.
> +(gdb) actions
> +Enter actions for tracepoint 1, one per line.
> +End with a line saying just "end".
> +>collect $reg
> +>end
> +(gdb) tstart
> +(gdb) shell ls
> +(gdb) tstop
> +(gdb) tfind
> +Found trace frame 0, tracepoint 1
> +#0  0xc01a1ac1 in vfs_readdir (file=0xc5528d00, filler=0xc01a1900 <filldir64>,
> +   buf=0xc0d09f90) at /home/teawater/kernel/linux-2.6/fs/readdir.c:23
> +23      /home/teawater/kernel/linux-2.6/fs/readdir.c: No such file or
> directory.
> +       in /home/teawater/kernel/linux-2.6/fs/readdir.c
> +(gdb) info reg
> +eax            0xc5528d00       -984445696
> +ecx            0xc0d09f90       -1060069488
> +edx            0xc01a1900       -1072031488
> +ebx            0xfffffff7       -9
> +esp            0xc0d09f8c       0xc0d09f8c
> +ebp            0x0      0x0
> +esi            0x8061480        134616192
> +edi            0xc5528d00       -984445696
> +eip            0xc01a1ac1       0xc01a1ac1 <vfs_readdir+1>
> +eflags         0x286    [ PF SF IF ]
> +cs             0x60     96
> +ss             0x8061480        134616192
> +ds             0x7b     123
> +es             0x7b     123
> +fs             0x0      0
> +gs             0x0      0
> +(gdb) tfind
> +Found trace frame 1, tracepoint 1
> +0xc01a1ac1      23      in /home/teawater/kernel/linux-2.6/fs/readdir.c
> +(gdb) info reg
> +eax            0xc5528d00       -984445696
> +ecx            0xc0d09f90       -1060069488
> +edx            0xc01a1900       -1072031488
> +ebx            0xfffffff7       -9
> +esp            0xc0d09f8c       0xc0d09f8c
> +ebp            0x0      0x0
> +esi            0x8061480        134616192
> +edi            0xc5528d00       -984445696
> +eip            0xc01a1ac1       0xc01a1ac1 <vfs_readdir+1>
> +eflags         0x286    [ PF SF IF ]
> +cs             0x60     96
> +ss             0x8061480        134616192
> +ds             0x7b     123
> +es             0x7b     123
> +fs             0x0      0
> +gs             0x0      0
> +--------------------------------------------------------------------------------
> +
> +
> +
> +Get the value of variable from Kernel
> +-------------------------------------
> +
> +Following part is an example that record the value of "jiffies_64" when Linux

                                     records

> +Kernel call function "vfs_readdir".

          calls

> +
> +--------------------------------------------------------------------------------
> +(gdb) trace vfs_readdir
> +Tracepoint 1 at 0xc01ed740: file
> /home/teawater/kernel/linux-2.6/fs/readdir.c, line 24.
> +(gdb) actions
> +Enter actions for tracepoint 1, one per line.
> +End with a line saying just "end".
> +>collect jiffies_64
> +>collect file->f_path.dentry->d_iname
> +>end
> +(gdb) tstart
> +(gdb) shell ls
> +arch    drivers   include  kernel    mm               Module.symvers
> security  System.map  virt
> +block   firmware  init     lib       modules.builtin  net
> sound     t           vmlinux
> +crypto  fs        ipc      Makefile  modules.order    scripts
> source    usr         vmlinux.o
> +(gdb) tstop
> +(gdb) tfind
> +Found trace frame 0, tracepoint 1
> +#0  0xc01ed741 in vfs_readdir (file=0xf4063000, filler=0xc01ed580
> <filldir64>, buf=0xd6dfdf90)
> +    at /home/teawater/kernel/linux-2.6/fs/readdir.c:24
> +24      {
> +(gdb) p jiffies_64
> +$1 = 4297248706
> +(gdb) p file->f_path.dentry->d_iname
> +$1 = "b26", '\000' <repeats 28 times>
> +--------------------------------------------------------------------------------
> +
> +
> +
> +How to use use tracepoint condition
> +-----------------------------------
> +
> +http://sourceware.org/gdb/current/onlinedocs/gdb/Tracepoint-Conditions.html
> +Like the breakpoint, we can set condition to tracepoint. But it speed is more

   Like breakpoints, we can set conditions on tracepoints.  But its speed is

> +fast than breakpoint's condition because KGTP do all the condition check.

   faster than breakpoint conditions because KGTP does all of the condition checks.

> +For example:
> +
> +------------------------------
> +(gdb) trace handle_irq
> +(gdb) condition 1 (irq == 47)
> +------------------------------
> +
> +This action of tracepoint 1 will work only when irq number is 47.
> +
> +
> +
> +How to use trace state variables
> +--------------------------------
> +
> +http://sourceware.org/gdb/current/onlinedocs/gdb/Trace-State-Variables.html
> +Tracepoint have special variables. You can trace it or use it in tracepoint

   Tracepoints have                           trace them or use them in

> +condition.

   conditions.

> +Note that only GDB 7.2.1 and later version support use trace state variables

                                later versions support trace state variables

> +directly, the old version GDB just can show the value of trace state variables

   directly; the older GDB versions can just show the value of

> +through command "info tvariables".
> +
> +
> +Simple trace state variables
> +----------------------------
> +
> +Define a trace state variable $c.
> +
> +-------------------
> +(gdb) tvariable $c
> +-------------------
> +
> +Trace state variable $c created, with initial value 0.
> +Use it in the action. Follow action will use $c to count how much irq happen

                         The following action uses $c to count how much irqs happen

> +in Kernel.
> +
> +-----------------------------------------------------------------------
> +(gdb) trace handle_irq
> +(gdb) actions
> +Enter actions for tracepoint 3, one per line.
> +End with a line saying just "end".
> +>collect $c     #Save current value of $c to the trace frame buffer.
> +>teval $c=$c+1  #Increase the $c.
> +>end
> +-----------------------------------------------------------------------
> +
> +You can get the current value of $c when the trace is running or stop.
> +
> +----------------------------------
> +(gdb) tstart
> +(gdb) info tvariables
> +$c              0           31554
> +(gdb) p $c
> +$5 = 33652
> +(gdb) tstop
> +(gdb) p $c
> +$9 = 105559
> +----------------------------------
> +
> +When use the tfind parse the trace frame buffer, if the value of trace state
> +variable is collect. You can use it.

Maybe this?

When using tfind, you can parse the trace frame buffer.  If the value of a trace state
variable is collected, you can use it.

> +
> +------------------------------
> +(gdb) tstop
> +(gdb) tfind
> +(gdb) info tvariables
> +$c              0           0
> +(gdb) p $c
> +$6 = 0
> +(gdb) tfind 100
> +(gdb) p $c
> +$7 = 100
> +------------------------------
> +
> +
> +Special trace state variables $current_task, $current_thread_info, $cpu_id,
> +$dump_stack, $printk_level, $printk_format, $printk_tmp and $clock
> +--------------------------------------------------------------------------
> +
> +KGTP have special trace state variables $current_task, $current_thread_info,

        drop "have"

> +$cpu_id and $clock can very easy to access to some special value. You can see
> +them when GDB connect to the KGTP. You can use them in tracepoint condition

                 connects                                            conditions

> +or actions.
> +Access $current_task in tracepoint condition and action will get the return
> +of get_current().
> +Access $current_thread_info in tracepoint condition and action will get the
> +return of current_thread_info().
> +Access $cpu_id in tracepoint condition and action will get the return of
> +smp_processor_id().
> +Access $clock in tracepoint condition and action will get the return of
> +local_clock() that return the timestamp in nanoseconds.

                 that returns

> +
> +And KGTP have other special trace state variables $dump_stack, $printk_level,

            has

> +$printk_format and $printk_tmp, all of them are for output value directly that

                      $printk_tmp. All of them output their values directly, as

> +will introduce in "Howto let tracepoint output value directly".

   can be seen in "Howto get tracepoint output values directly".

> +
> +Following example will count process 16663 call how many sys_read in $c

   The following example counts in $c how many sys_read calls that process 16663 does

> +and collect the struct thread_info of current task:

   and collects

but I don't see it qualifies these traces with "sys_read".
Should it be vfs_read instead?  or you are just equating sys_read -> vfs_read?


> +
> +--------------------------------------------------------------------------------
> +(gdb) trace vfs_read if ((*(struct task_struct *)$current_task)->pid == 16663)
> +(gdb) tvariable $c
> +(gdb) actions
> +Enter actions for tracepoint 4, one per line.
> +End with a line saying just "end".
> +>teval $c=$c+1
> +>collect (*(struct thread_info *)$current_thread_info)
> +>end
> +(gdb) tstart
> +(gdb) info tvariables
> +Name            Initial     Current
> +$c              0           184
> +$current_task   0           <unknown>
> +$current_thread_info 0           <unknown>
> +$cpu_id         0           <unknown>
> +(gdb) tstop
> +(gdb) tfind
> +(gdb) p *(struct thread_info *)$current_thread_info
> +$10 = {task = 0xf0ac6580, exec_domain = 0xc07b1400, flags = 0, status
> = 0, cpu = 1, preempt_count = 2, addr_limit = {
> +    seg = 4294967295}, restart_block = {fn = 0xc0159fb0
> <do_no_restart_syscall>, {{arg0 = 138300720, arg1 = 11,
> +        arg2 = 1, arg3 = 78}, futex = {uaddr = 0x83e4d30, val = 11,
> flags = 1, bitset = 78, time = 977063750,
> +        uaddr2 = 0x0}, nanosleep = {index = 138300720, rmtp = 0xb,
> expires = 335007449089}, poll = {
> +        ufds = 0x83e4d30, nfds = 11, has_timeout = 1, tv_sec = 78,
> tv_nsec = 977063750}}},
> +  sysenter_return = 0xb77ce424, previous_esp = 0, supervisor_stack =
> 0xef340044 "", uaccess_err = 0}
> +--------------------------------------------------------------------------------
> +
> +nother example can show how much sys_read() execute in each cpu.

   Another example shows how much sys_read() executes in each CPU.

> +
> +--------------------------------------
> +tvariable $c0
> +tvariable $c1
> +trace sys_read
> +  condition $bpnum ($cpu_id == 0)
> +  commands
> +    teval $c0=$c0+1
> +  end
> +trace sys_read
> +  condition $bpnum ($cpu_id == 1)
> +  commands
> +    teval $c1=$c1+1
> +  end
> +info tvariables
> +Name            Initial     Current
> +$current_task   0           <unknown>
> +$cpu_id         0           <unknown>
> +$c0             0           3255
> +$c1             0           1904
> +--------------------------------------
> +
> +sys_read() execute 3255 times in cpu0 and 1904 times in cpu1.
> +
> +
> +
> +Show all the traced data of current frame
> +-----------------------------------------
> +
> +--------------------------------------------------------------------------------
> +(gdb) tdump
> +Data collected at tracepoint 1, trace frame 0:
> +$cr = void
> +file->f_path.dentry->d_iname =
> "gtp\000.google.chrome.g05ZYO\000\235", <incomplete sequence \364>
> +jiffies_64 = 4319751455
> +--------------------------------------------------------------------------------
> +
> +
> +
> +Get backtrace info from Kernel
> +------------------------------
> +
> +We can get the backtrace through collect the stack.

   We can get a backtrace by collecting the stack.

> +In x86_32, following action command will collect 512 bytes of stack.
> +
> +-----------------------------------
> +collect *(unsigned char *)$esp@512
> +-----------------------------------
> +
> +In x86_64, following command will collect 512 bytes of stack.
> +
> +-----------------------------------
> +collect *(unsigned char *)$rsp@512
> +-----------------------------------
> +
> +In MIPS or ARM, following command will collect 512 bytes of stack.
> +----------------------------------
> +collect *(unsigned char *)$sp@512
> +-----------------------------------
> +
> +Following part is an example about howto backtrace in x86_64:
> +
> +--------------------------------------------------------------------------------
> +(gdb) trace vfs_readdir
> +Tracepoint 1 at 0xffffffff8113f7fc: file
> /home/teawater/kernel/linux-2.6/fs/readdir.c, line 24.
> +(gdb) actions
> +Enter actions for tracepoint 1, one per line.
> +End with a line saying just "end".
> +>collect *(unsigned char *)$rsp@512
> +>end
> +(gdb) tstart
> +(gdb) shell ls
> +2      block    firmware  i        ipc     Makefile
> modules.order   scripts   source      t~    vmlinux
> +a.out  crypto   fs        include  kernel  mm
> Module.symvers  security  System.map  usr   vmlinux.o
> +arch   drivers  gdb.txt   init     lib     modules.builtin  net
>       sound     t           virt
> +(gdb) tstop
> +(gdb) tfind
> +Found trace frame 0, tracepoint 1
> +#0  0xffffffff8113f7fd in vfs_readdir (file=0xffff880075f00780,
> filler=0xffffffff8113f630 <filldir>, buf=0xffff880005785f38)
> +    at ./linux-2.6/fs/readdir.c:24
> +24      {
> +(gdb) bt
> +#0  0xffffffff8113f7fd in vfs_readdir (file=0xffff880075f00780,
> filler=0xffffffff8113f630 <filldir>, buf=0xffff880005785f38)
> +    at ./linux-2.6/fs/readdir.c:24
> +#1  0xffffffff8113fa14 in sys_getdents (fd=<value optimized out>,
> dirent=0x801108, count=32768)
> +    at ./linux-2.6/fs/readdir.c:214
> +#2  0xffffffff8100af42 in ?? () at ./linux-2.6/arch/x86/kernel/entry_64.S:487
> +--------------------------------------------------------------------------------
> +
> +
> +
> +Howto let tracepoint output value directly

   Howto get (?: makes more sense to me)

> +------------------------------------------
> +

Maybe:

> +In the previous parts, you can get that to get the value from Linux Kernel you

                          you may understand that to get a value from Linux kernel, you

> +need use tracepoint action "collect" save value to the tracepoint frame and

   need to use a tracepoint "collect" action to save the value to the tracepoint frame and

> +use GDB command "tfind" parse the the value out from the frame.

   use the GDB command "tfind" to parse the value from the frame data.

> +But we want get the value directly sometime, so KGTP support two ways to output

                                      sometimes,        supports

> +value directly.

   values

> +
> +
> +Output stack dump directly
> +--------------------------
> +KGTP have special trace state variables $dump_stack, "collect" it will let

        has                      variable             ;

> +Linux Kernel output stack dump directly.
> +
> +Following example let Linux Kernel show the stack dump of vfs_readdir:

                     lets

> +
> +--------------------------------------------------------------------------------
> +trace vfs_readdir
> +  commands
> +    collect $dump_stack
> +  end
> +--------------------------------------------------------------------------------
> +
> +Then your kernel will printk like:
> +
> +--------------------------------------------------------------------------------
> +[22779.208064] gtp 1:Pid: 441, comm: python Not tainted 2.6.39-rc3+ #46
> +[22779.208068] Call Trace:
> +[22779.208072]  [<fe653cca>] gtp_get_var+0x4a/0xa0 [gtp]
> +[22779.208076]  [<fe653d79>] gtp_collect_var+0x59/0xa0 [gtp]
> +[22779.208080]  [<fe655974>] gtp_action_x+0x1bb4/0x1dc0 [gtp]
> +[22779.208084]  [<c05b6408>] ? _raw_spin_unlock+0x18/0x40
> +[22779.208088]  [<c023f152>] ? __find_get_block_slow+0xd2/0x160
> +[22779.208091]  [<c01a8c56>] ? delayacct_end+0x96/0xb0
> +[22779.208100]  [<c023f404>] ? __find_get_block+0x84/0x1d0
> +[22779.208103]  [<c05b6408>] ? _raw_spin_unlock+0x18/0x40
> +[22779.208106]  [<c02e0838>] ? find_revoke_record+0xa8/0xc0
> +[22779.208109]  [<c02e0c45>] ? jbd2_journal_cancel_revoke+0xd5/0xe0
> +[22779.208112]  [<c02db51f>] ? __jbd2_journal_temp_unlink_buffer+0x2f/0x110
> +[22779.208115]  [<fe655c4c>] gtp_kp_pre_handler+0xcc/0x1c0 [gtp]
> +[22779.208118]  [<c05b8a88>] kprobe_exceptions_notify+0x3d8/0x440
> +[22779.208121]  [<c05b7d54>] ? hw_breakpoint_exceptions_notify+0x14/0x180
> +[22779.208124]  [<c05b95eb>] ? sub_preempt_count+0x7b/0xb0
> +[22779.208126]  [<c0227ac5>] ? vfs_readdir+0x15/0xb0
> +[22779.208128]  [<c0227ac4>] ? vfs_readdir+0x14/0xb0
> +[22779.208131]  [<c05b9743>] notifier_call_chain+0x43/0x60
> +[22779.208134]  [<c05b9798>] __atomic_notifier_call_chain+0x38/0x50
> +[22779.208137]  [<c05b97cf>] atomic_notifier_call_chain+0x1f/0x30
> +[22779.208140]  [<c05b980d>] notify_die+0x2d/0x30
> +[22779.208142]  [<c05b71c5>] do_int3+0x35/0xa0
> +--------------------------------------------------------------------------------
> +
> +
> +Switch collect to output the value directly
> +-------------------------------------------
> +
> +KGTP have special trace state variables $printk_level, $printk_format

        has

> +and $printk_tmp to support this function.
> +
> +$printk_level, if its value is 8 (this is the default value), "collect" will

   $printk_level:

> +save value to the tracepoint frame.

will save what value to the tracepoint frame??

> +If its value is 0-7, "collect" will output the value through "printk" directly,
> +and value will be the level of printk.  The level is:
> +0	KERN_EMERG	system is unusable
> +1	KERN_ALERT	action must be taken immediately
> +2	KERN_CRIT	critical conditions
> +3	KERN_ERR	error conditions
> +4	KERN_WARNING	warning conditions
> +5	KERN_NOTICE	normal but significant condition
> +6	KERN_INFO	informational
> +7	KERN_DEBUG	debug-level messages
> +
> +$printk_format, collect printk will output value in the format that set by it.

                                                                  that is set by it.

> +The format is:
> +0	This is the default value.
> +	If the size of collect value is 1, 2, 4 or 8, it will be outputted as

	                                                         output as

> +	a unsigned decimal.

	an unsigned decimal.

> +	If not, it will be outputted as a hexadecimal string.

	                   output

> +1	Output value in signed decimal.
> +2	Output value in unsigned decimal.
> +3	Output value in unsigned hexadecimal.
> +4	Output value as a string.
> +5	Output value as a hexadecimal string.
> +
> +$printk_tmp, to output the value of global variable need set to it first.
> +
> +Following example show the a count number, pid, jiffies_64 and the file name

                     shows a count number, ...

> +that call vfs_readdir:
> +
> +--------------------------------------------------------------------------------
> +tvariable $c
> +trace vfs_readdir
> +  commands
> +    teval $printk_level=0
> +    collect $c=$c+1
> +    collect (*(struct task_struct *)$current_task)->pid
> +    collect $printk_tmp=jiffies_64
> +    teval $printk_format=4
> +    collect file->f_path.dentry->d_iname
> +  end
> +--------------------------------------------------------------------------------
> +
> +Then your kernel will printk like:
> +
> +--------------------------------------------------------------------------------
> +gtp 1:$c=$c+1=41
> +gtp 1:(*(struct task_struct *)$current_task)->pid=12085
> +gtp 1:$printk_tmp=jiffies_64=4322021438
> +gtp 1:file->f_path.dentry->d_iname=b26
> +gtp 1:$c=$c+1=42
> +gtp 1:(*(struct task_struct *)$current_task)->pid=12085
> +gtp 1:$printk_tmp=jiffies_64=4322021438
> +gtp 1:file->f_path.dentry->d_iname=b26
> +--------------------------------------------------------------------------------
> +
> +"gtp 1" mean that it output by tracepoint 1.

           means that it was output by tracepoint 1.

> +
> +
> +Use printf command in actions
> +-----------------------------
> +
> +This way have a trouble is GDB is still not accept the patch that make

   This method has a proble: GDB still has not accepted the patch that makes

> +tracepoint support printf, So if you want use it, you need patch the patch in

   tracepoints support printf, so if you want to use it, you need to apply the patch in

> +http://sourceware.org/ml/gdb-patches/2011-03/msg00022.html and build your
> +GDB with yourself.

   GDB yourself.

> +
> +Following example show the a count number, pid and the file name that call

   Following example shows a count number, ...

> +vfs_readdir:
> +
> +--------------------------------------------------------------------------------
> +tvariable $c
> +trace vfs_readdir
> +  commands
> +    printf "<0>%d pid=%d name:%s\n", $c=$c+1, (*(struct task_struct
> *)$current_task)->pid, file->f_path.dentry->d_iname
> +  end
> +--------------------------------------------------------------------------------
> +
> +Then your kernel will printk like:
> +
> +--------------------------------------------------------------------------------
> +1 pid=10888 name:bin
> +2 pid=10888 name:bin
> +3 pid=10893 name:teawater
> +4 pid=10893 name:teawater
> +--------------------------------------------------------------------------------
> +
> +Like what we use printk in Linux Kernel, please add kernel loglevel

                use with printk in

> in the begin

  at the beginning

> +and add "\n" in the end.
> +The kernel loglevel is:
> +KERN_EMERG	"<0>"	system is unusable
> +KERN_ALERT	"<1>"	action must be taken immediately
> +KERN_CRIT	"<2>"	critical conditions
> +KERN_ERR	"<3>"	error conditions
> +KERN_WARNING	"<4>"	warning conditions
> +KERN_NOTICE	"<5>"	normal but significant condition
> +KERN_INFO	"<6>"	informational
> +KERN_DEBUG	"<7>"	debug-level messages
> +
> +
> +
> +Get status of KGTP from Kernel
> +------------------------------
> +Please use GDB command "tstatus"
> +
> +
> +
> +Set the trace buffer into a circular buffer
> +-------------------------------------------
> +http://sourceware.org/gdb/current/onlinedocs/gdb/Starting-and-Stopping-Trace-Experiments.html
> +The frame buffer is not a circular buffer by default. When the buffer is full,
> +the tracepoint will stop.
> +
> +-----------------------------
> +set circular-trace-buffer on
> +-----------------------------
> +
> +Set frame buffer to a circular buffer. When the buffer is full, it will auto
> +discard traceframes (oldest first) and keep trace.
> +
> +
> +
> +Do not stop tracepoint when the GDB disconnect

                                GDB disconnects

> +----------------------------------------------
> +
> +http://sourceware.org/gdb/current/onlinedocs/gdb/Starting-and-Stopping-Trace-Experiments.html
> +The KGTP will stop and delete the trace frame when GDB disconnect with it by

   KGTP will stop and ...                                 disconnects

> +default.
> +
> +----------------------------
> +set disconnected-tracing on
> +----------------------------
> +will open the KGTP disconnect-trace. After that, when GDB disconnect with KGTP,

                                                             disconnects

> +KGTP will not stop trace. And after GDB reconnect to KGTP, it can keep control

                                           reconnects

> +the KGTP like nothing happen.

   of KGTP like nothing happened.

> +
> +
> +
> +Howto show the variable that value of it is optimized

   Howto show a variable whose value has been optimized away

> +-----------------------------------------------------
> +
> +Sometimes, GDB will output some value like:
> +
> +-------------------------------------------
> +inode has been optimized out of existence.
> +res has been optimized out of existence.
> +-------------------------------------------
> +
> +That is because value of inode and res is optimized. Linux Kernel is built
> +with -O2 so you will get this trouble sometimes.
> +There are 2 ways to handle it:
> +
> +Linux kernel "Compile with almost no optimization" patch
> +--------------------------------------------------------
> +If you do not care about the speed when you debug the Kernel, you can use the
> +patch for Linux Kernel in
> +http://code.google.com/p/kgtp/downloads/detail?name=co.patch It add a option

                                                                       an option

> +in "Kernel hacking" called "Compile with almost no optimization". It will make
> +kernel be built without -O2. It support x86_32, x86_64 and arm.
> +
> +Update your GCC
> +---------------
> +The VTA branch(http://gcc.gnu.org/wiki/Var_Tracking_Assignments) was merged

           branch (http:// ...

> +for GCC 4.5 Which helps a lot with generating dwarf for previously

   for GCC 4.5.  This helps a lot ...

> +"optimized out" values.
> +
> +
> +
> +Offline debug
> +-------------
> +
> +In the PC that can run the GDB:
> +Change the "target remote XXXX" to
> +
> +------------------------------------------
> +(gdb) target remote | perl ./getgtprsp.pl
> +------------------------------------------.
> +
> +After that, set tracepoint and start it as usual:
> +
> +--------------------------------------------------------------------------------
> +(gdb) trace vfs_readdir
> +Tracepoint 1 at 0xffffffff8114f3c0: file
> /home/teawater/kernel/linux-2.6/fs/readdir.c, line 24.
> +(gdb) actions
> +Enter actions for tracepoint 1, one per line.
> +End with a line saying just "end".
> +#If your GDB support tracepoint "printf" (see "Howto use tracepoint
> printf"), use it to show the value directly is better.
> +>collect $reg
> +>end
> +(gdb) tstart
> +(gdb) stop
> +(gdb) quit
> +--------------------------------------------------------------------------------
> +
> +Then you can find files gtpstart and gtpstop. Copy it to the machine that you
> +want debug.

   want to debug.

> +
> +
> +In the debuged machine after insmod the gtp.ko:

          debugged

> +Start the tracepoint:
> +
> +------------------------------------
> +cat gtpstart > /sys/kernel/debug/gtp
> +------------------------------------
> +
> +Stop the tracepoint:
> +
> +-----------------------------------
> +cat gtpstop > /sys/kernel/debug/gtp
> +-----------------------------------
> +
> +You can let Linux Kernel show the value directly, please see "Howto let
> +tracepoint output value directly".
> +
> +If you want save the value to the trace frame and parse later, you can use file

          want to save

> +"/sys/kernel/debug/gtpframe" that have the trace frame. Copy it to the PC that

                                that has the

> +has GDB.
> +
> +In the PC that can run the GDB:
> +
> +--------------------------------------------------------------------------------
> +(gdb) target tfile ./gtpframe
> +Tracepoint 1 at 0xffffffff8114f3dc: file
> /home/teawater/kernel/linux-2.6/fs/readdir.c, line 24.
> +Created tracepoint 1 for target's tracepoint 1 at 0xffffffff8114f3c0.
> +(gdb) tfind
> +Found trace frame 0, tracepoint 1
> +#0  vfs_readdir (file=0xffff880036e8f300, filler=0xffffffff8114f240
> <filldir>, buf=0xffff880001e5bf38)
> +    at /home/teawater/kernel/linux-2.6/fs/readdir.c:24
> +24      {
> +--------------------------------------------------------------------------------



Hope that helps.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
