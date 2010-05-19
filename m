Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab0ESBqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:46:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:41151 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab0ESBkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:40:11 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH 15/25] kgdb,docs: Update the kgdb docs to include kdb
Date: Tue, 18 May 2010 20:39:25 -0500
Message-Id: <1274233175-3675-16-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
References: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 19 May 2010 01:39:54.0032 (UTC) FILETIME=[2E283300:01CAF6F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the kgdb docs to reflect the new directory structure and API.

Merge in the kdb shell information.

[Randy Dunlap <rdunlap@xenotime.net>: grammatical corrections]

CC: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 Documentation/DocBook/kgdb.tmpl     |  692 ++++++++++++++++++++++++++---------
 Documentation/kernel-parameters.txt |    6 +-
 include/linux/kgdb.h                |   12 +-
 3 files changed, 532 insertions(+), 178 deletions(-)

diff --git a/Documentation/DocBook/kgdb.tmpl b/Documentation/DocBook/kgdb.tmpl
index 5cff41a..55f12ac 100644
--- a/Documentation/DocBook/kgdb.tmpl
+++ b/Documentation/DocBook/kgdb.tmpl
@@ -4,7 +4,7 @@
 
 <book id="kgdbOnLinux">
  <bookinfo>
-  <title>Using kgdb and the kgdb Internals</title>
+  <title>Using kgdb, kdb and the kernel debugger internals</title>
 
   <authorgroup>
    <author>
@@ -17,33 +17,8 @@
     </affiliation>
    </author>
   </authorgroup>
-
-  <authorgroup>
-   <author>
-    <firstname>Tom</firstname>
-    <surname>Rini</surname>
-    <affiliation>
-     <address>
-      <email>trini@kernel.crashing.org</email>
-     </address>
-    </affiliation>
-   </author>
-  </authorgroup>
-
-  <authorgroup>
-   <author>
-    <firstname>Amit S.</firstname>
-    <surname>Kale</surname>
-    <affiliation>
-     <address>
-      <email>amitkale@linsyssoft.com</email>
-     </address>
-    </affiliation>
-   </author>
-  </authorgroup>
-
   <copyright>
-   <year>2008</year>
+   <year>2008,2010</year>
    <holder>Wind River Systems, Inc.</holder>
   </copyright>
   <copyright>
@@ -69,41 +44,76 @@
   <chapter id="Introduction">
     <title>Introduction</title>
     <para>
-    kgdb is a source level debugger for linux kernel. It is used along
-    with gdb to debug a linux kernel.  The expectation is that gdb can
-    be used to "break in" to the kernel to inspect memory, variables
-    and look through call stack information similar to what an
-    application developer would use gdb for.  It is possible to place
-    breakpoints in kernel code and perform some limited execution
-    stepping.
+    The kernel has two different debugger front ends (kdb and kgdb)
+    which interface to the debug core.  It is possible to use either
+    of the debugger front ends and dynamically transition between them
+    if you configure the kernel properly at compile and runtime.
+    </para>
+    <para>
+    Kdb is simplistic shell-style interface which you can use on a
+    system console with a keyboard or serial console.  You can use it
+    to inspect memory, registers, process lists, dmesg, and even set
+    breakpoints to stop in a certain location.  Kdb is not a source
+    level debugger, although you can set breakpoints and execute some
+    basic kernel run control.  Kdb is mainly aimed at doing some
+    analysis to aid in development or diagnosing kernel problems.  You
+    can access some symbols by name in kernel built-ins or in kernel
+    modules if the code was built
+    with <symbol>CONFIG_KALLSYMS</symbol>.
+    </para>
+    <para>
+    Kgdb is intended to be used as a source level debugger for the
+    Linux kernel. It is used along with gdb to debug a Linux kernel.
+    The expectation is that gdb can be used to "break in" to the
+    kernel to inspect memory, variables and look through call stack
+    information similar to the way an application developer would use
+    gdb to debug an application.  It is possible to place breakpoints
+    in kernel code and perform some limited execution stepping.
     </para>
     <para>
-    Two machines are required for using kgdb. One of these machines is a
-    development machine and the other is a test machine.  The kernel
-    to be debugged runs on the test machine. The development machine
-    runs an instance of gdb against the vmlinux file which contains
-    the symbols (not boot image such as bzImage, zImage, uImage...).
-    In gdb the developer specifies the connection parameters and
-    connects to kgdb.  The type of connection a developer makes with
-    gdb depends on the availability of kgdb I/O modules compiled as
-    builtin's or kernel modules in the test machine's kernel.
+    Two machines are required for using kgdb. One of these machines is
+    a development machine and the other is the target machine.  The
+    kernel to be debugged runs on the target machine. The development
+    machine runs an instance of gdb against the vmlinux file which
+    contains the symbols (not boot image such as bzImage, zImage,
+    uImage...).  In gdb the developer specifies the connection
+    parameters and connects to kgdb.  The type of connection a
+    developer makes with gdb depends on the availability of kgdb I/O
+    modules compiled as built-ins or loadable kernel modules in the test
+    machine's kernel.
     </para>
   </chapter>
   <chapter id="CompilingAKernel">
-    <title>Compiling a kernel</title>
+  <title>Compiling a kernel</title>
+  <para>
+  <itemizedlist>
+  <listitem><para>In order to enable compilation of kdb, you must first enable kgdb.</para></listitem>
+  <listitem><para>The kgdb test compile options are described in the kgdb test suite chapter.</para></listitem>
+  </itemizedlist>
+  </para>
+  <sect1 id="CompileKGDB">
+    <title>Kernel config options for kgdb</title>
     <para>
     To enable <symbol>CONFIG_KGDB</symbol> you should first turn on
     "Prompt for development and/or incomplete code/drivers"
     (CONFIG_EXPERIMENTAL) in  "General setup", then under the
-    "Kernel debugging" select "KGDB: kernel debugging with remote gdb".
+    "Kernel debugging" select "KGDB: kernel debugger".
+    </para>
+    <para>
+    While it is not a hard requirement that you have symbols in your
+    vmlinux file, gdb tends not to be very useful without the symbolic
+    data, so you will want to turn
+    on <symbol>CONFIG_DEBUG_INFO</symbol> which is called "Compile the
+    kernel with debug info" in the config menu.
     </para>
     <para>
     It is advised, but not required that you turn on the
-    CONFIG_FRAME_POINTER kernel option.  This option inserts code to
-    into the compiled executable which saves the frame information in
-    registers or on the stack at different points which will allow a
-    debugger such as gdb to more accurately construct stack back traces
-    while debugging the kernel.
+    <symbol>CONFIG_FRAME_POINTER</symbol> kernel option which is called "Compile the
+    kernel with frame pointers" in the config menu.  This option
+    inserts code to into the compiled executable which saves the frame
+    information in registers or on the stack at different points which
+    allows a debugger such as gdb to more accurately construct
+    stack back traces while debugging the kernel.
     </para>
     <para>
     If the architecture that you are using supports the kernel option
@@ -116,38 +126,160 @@
     this option.
     </para>
     <para>
-    Next you should choose one of more I/O drivers to interconnect debugging
-    host and debugged target.  Early boot debugging requires a KGDB
-    I/O driver that supports early debugging and the driver must be
-    built into the kernel directly. Kgdb I/O driver configuration
-    takes place via kernel or module parameters, see following
-    chapter.
+    Next you should choose one of more I/O drivers to interconnect
+    debugging host and debugged target.  Early boot debugging requires
+    a KGDB I/O driver that supports early debugging and the driver
+    must be built into the kernel directly. Kgdb I/O driver
+    configuration takes place via kernel or module parameters which
+    you can learn more about in the in the section that describes the
+    parameter "kgdboc".
     </para>
-    <para>
-    The kgdb test compile options are described in the kgdb test suite chapter.
+    <para>Here is an example set of .config symbols to enable or
+    disable for kgdb:
+    <itemizedlist>
+    <listitem><para># CONFIG_DEBUG_RODATA is not set</para></listitem>
+    <listitem><para>CONFIG_FRAME_POINTER=y</para></listitem>
+    <listitem><para>CONFIG_KGDB=y</para></listitem>
+    <listitem><para>CONFIG_KGDB_SERIAL_CONSOLE=y</para></listitem>
+    </itemizedlist>
     </para>
-
+  </sect1>
+  <sect1 id="CompileKDB">
+    <title>Kernel config options for kdb</title>
+    <para>Kdb is quite a bit more complex than the simple gdbstub
+    sitting on top of the kernel's debug core.  Kdb must implement a
+    shell, and also adds some helper functions in other parts of the
+    kernel, responsible for printing out interesting data such as what
+    you would see if you ran "lsmod", or "ps".  In order to build kdb
+    into the kernel you follow the same steps as you would for kgdb.
+    </para>
+    <para>The main config option for kdb
+    is <symbol>CONFIG_KGDB_KDB</symbol> which is called "KGDB_KDB:
+    include kdb frontend for kgdb" in the config menu.  In theory you
+    would have already also selected an I/O driver such as the
+    CONFIG_KGDB_SERIAL_CONSOLE interface if you plan on using kdb on a
+    serial port, when you were configuring kgdb.
+    </para>
+    <para>If you want to use a PS/2-style keyboard with kdb, you would
+    select CONFIG_KDB_KEYBOARD which is called "KGDB_KDB: keyboard as
+    input device" in the config menu.  The CONFIG_KDB_KEYBOARD option
+    is not used for anything in the gdb interface to kgdb.  The
+    CONFIG_KDB_KEYBOARD option only works with kdb.
+    </para>
+    <para>Here is an example set of .config symbols to enable/disable kdb:
+    <itemizedlist>
+    <listitem><para># CONFIG_DEBUG_RODATA is not set</para></listitem>
+    <listitem><para>CONFIG_FRAME_POINTER=y</para></listitem>
+    <listitem><para>CONFIG_KGDB=y</para></listitem>
+    <listitem><para>CONFIG_KGDB_SERIAL_CONSOLE=y</para></listitem>
+    <listitem><para>CONFIG_KGDB_KDB=y</para></listitem>
+    <listitem><para>CONFIG_KDB_KEYBOARD=y</para></listitem>
+    </itemizedlist>
+    </para>
+  </sect1>
   </chapter>
-  <chapter id="EnableKGDB">
-   <title>Enable kgdb for debugging</title>
-   <para>
-   In order to use kgdb you must activate it by passing configuration
-   information to one of the kgdb I/O drivers.  If you do not pass any
-   configuration information kgdb will not do anything at all.  Kgdb
-   will only actively hook up to the kernel trap hooks if a kgdb I/O
-   driver is loaded and configured.  If you unconfigure a kgdb I/O
-   driver, kgdb will unregister all the kernel hook points.
+  <chapter id="kgdbKernelArgs">
+  <title>Kernel Debugger Boot Arguments</title>
+  <para>This section describes the various runtime kernel
+  parameters that affect the configuration of the kernel debugger.
+  The following chapter covers using kdb and kgdb as well as
+  provides some examples of the configuration parameters.</para>
+   <sect1 id="kgdboc">
+   <title>Kernel parameter: kgdboc</title>
+   <para>The kgdboc driver was originally an abbreviation meant to
+   stand for "kgdb over console".  Today it is the primary mechanism
+   to configure how to communicate from gdb to kgdb as well as the
+   devices you want to use to interact with the kdb shell.
+   </para>
+   <para>For kgdb/gdb, kgdboc is designed to work with a single serial
+   port. It is intended to cover the circumstance where you want to
+   use a serial console as your primary console as well as using it to
+   perform kernel debugging.  It is also possible to use kgdb on a
+   serial port which is not designated as a system console.  Kgdboc
+   may be configured as a kernel built-in or a kernel loadable module.
+   You can only make use of <constant>kgdbwait</constant> and early
+   debugging if you build kgdboc into the kernel as a built-in.
    </para>
+   <sect2 id="kgdbocArgs">
+   <title>kgdboc arguments</title>
+   <para>Usage: <constant>kgdboc=[kbd][[,]serial_device][,baud]</constant></para>
+   <sect3 id="kgdbocArgs1">
+   <title>Using loadable module or built-in</title>
    <para>
-   All drivers can be reconfigured at run time, if
-   <symbol>CONFIG_SYSFS</symbol> and <symbol>CONFIG_MODULES</symbol>
-   are enabled, by echo'ing a new config string to
-   <constant>/sys/module/&lt;driver&gt;/parameter/&lt;option&gt;</constant>.
-   The driver can be unconfigured by passing an empty string.  You cannot
-   change the configuration while the debugger is attached.  Make sure
-   to detach the debugger with the <constant>detach</constant> command
-   prior to trying unconfigure a kgdb I/O driver.
+   <orderedlist>
+   <listitem><para>As a kernel built-in:</para>
+   <para>Use the kernel boot argument: <constant>kgdboc=&lt;tty-device&gt;,[baud]</constant></para></listitem>
+   <listitem>
+   <para>As a kernel loadable module:</para>
+   <para>Use the command: <constant>modprobe kgdboc kgdboc=&lt;tty-device&gt;,[baud]</constant></para>
+   <para>Here are two examples of how you might formate the kgdboc
+   string. The first is for an x86 target using the first serial port.
+   The second example is for the ARM Versatile AB using the second
+   serial port.
+   <orderedlist>
+   <listitem><para><constant>kgdboc=ttyS0,115200</constant></para></listitem>
+   <listitem><para><constant>kgdboc=ttyAMA1,115200</constant></para></listitem>
+   </orderedlist>
    </para>
+   </listitem>
+   </orderedlist></para>
+   </sect3>
+   <sect3 id="kgdbocArgs2">
+   <title>Configure kgdboc at runtime with sysfs</title>
+   <para>At run time you can enable or disable kgdboc by echoing a
+   parameters into the sysfs.  Here are two examples:</para>
+   <orderedlist>
+   <listitem><para>Enable kgdboc on ttyS0</para>
+   <para><constant>echo ttyS0 &gt; /sys/module/kgdboc/parameters/kgdboc</constant></para></listitem>
+   <listitem><para>Disable kgdboc</para>
+   <para><constant>echo "" &gt; /sys/module/kgdboc/parameters/kgdboc</constant></para></listitem>
+   </orderedlist>
+   <para>NOTE: You do not need to specify the baud if you are
+   configuring the console on tty which is already configured or
+   open.</para>
+   </sect3>
+   <sect3 id="kgdbocArgs3">
+   <title>More examples</title>
+   <para>You can configure kgdboc to use the keyboard, and or a serial device
+   depending on if you are using kdb and or kgdb, in one of the
+   following scenarios.
+   <orderedlist>
+   <listitem><para>kdb and kgdb over only a serial port</para>
+   <para><constant>kgdboc=&lt;serial_device&gt;[,baud]</constant></para>
+   <para>Example: <constant>kgdboc=ttyS0,115200</constant></para>
+   </listitem>
+   <listitem><para>kdb and kgdb with keyboard and a serial port</para>
+   <para><constant>kgdboc=kbd,&lt;serial_device&gt;[,baud]</constant></para>
+   <para>Example: <constant>kgdboc=kbd,ttyS0,115200</constant></para>
+   </listitem>
+   <listitem><para>kdb with a keyboard</para>
+   <para><constant>kgdboc=kbd</constant></para>
+   </listitem>
+   </orderedlist>
+   </para>
+   </sect3>
+   <para>NOTE: Kgdboc does not support interrupting the target via the
+   gdb remote protocol.  You must manually send a sysrq-g unless you
+   have a proxy that splits console output to a terminal program.
+   A console proxy has a separate TCP port for the debugger and a separate
+   TCP port for the "human" console.  The proxy can take care of sending
+   the sysrq-g for you.
+   </para>
+   <para>When using kgdboc with no debugger proxy, you can end up
+    connecting the debugger at one of two entry points.  If an
+    exception occurs after you have loaded kgdboc, a message should
+    print on the console stating it is waiting for the debugger.  In
+    this case you disconnect your terminal program and then connect the
+    debugger in its place.  If you want to interrupt the target system
+    and forcibly enter a debug session you have to issue a Sysrq
+    sequence and then type the letter <constant>g</constant>.  Then
+    you disconnect the terminal session and connect gdb.  Your options
+    if you don't like this are to hack gdb to send the sysrq-g for you
+    as well as on the initial connect, or to use a debugger proxy that
+    allows an unmodified gdb to do the debugging.
+   </para>
+   </sect2>
+   </sect1>
    <sect1 id="kgdbwait">
    <title>Kernel parameter: kgdbwait</title>
    <para>
@@ -162,103 +294,204 @@
    </para>
    <para>
    The kernel will stop and wait as early as the I/O driver and
-   architecture will allow when you use this option.  If you build the
-   kgdb I/O driver as a kernel module kgdbwait will not do anything.
+   architecture allows when you use this option.  If you build the
+   kgdb I/O driver as a loadable kernel module kgdbwait will not do
+   anything.
    </para>
    </sect1>
-  <sect1 id="kgdboc">
-  <title>Kernel parameter: kgdboc</title>
-  <para>
-  The kgdboc driver was originally an abbreviation meant to stand for
-  "kgdb over console".  Kgdboc is designed to work with a single
-  serial port. It was meant to cover the circumstance
-  where you wanted to use a serial console as your primary console as
-  well as using it to perform kernel debugging.  Of course you can
-  also use kgdboc without assigning a console to the same port.
+   <sect1 id="kgdbcon">
+   <title>Kernel parameter: kgdbcon</title>
+   <para> The kgdbcon feature allows you to see printk() messages
+   inside gdb while gdb is connected to the kernel.  Kdb does not make
+    use of the kgdbcon feature.
+   </para>
+   <para>Kgdb supports using the gdb serial protocol to send console
+   messages to the debugger when the debugger is connected and running.
+   There are two ways to activate this feature.
+   <orderedlist>
+   <listitem><para>Activate with the kernel command line option:</para>
+   <para><constant>kgdbcon</constant></para>
+   </listitem>
+   <listitem><para>Use sysfs before configuring an I/O driver</para>
+   <para>
+   <constant>echo 1 &gt; /sys/module/kgdb/parameters/kgdb_use_con</constant>
+   </para>
+   <para>
+   NOTE: If you do this after you configure the kgdb I/O driver, the
+   setting will not take effect until the next point the I/O is
+   reconfigured.
+   </para>
+   </listitem>
+   </orderedlist>
+   <para>IMPORTANT NOTE: You cannot use kgdboc + kgdbcon on a tty that is an
+   active system console.  An example incorrect usage is <constant>console=ttyS0,115200 kgdboc=ttyS0 kgdbcon</constant>
+   </para>
+   <para>It is possible to use this option with kgdboc on a tty that is not a system console.
+   </para>
   </para>
-  <sect2 id="UsingKgdboc">
-  <title>Using kgdboc</title>
-  <para>
-  You can configure kgdboc via sysfs or a module or kernel boot line
-  parameter depending on if you build with CONFIG_KGDBOC as a module
-  or built-in.
-  <orderedlist>
-  <listitem><para>From the module load or build-in</para>
-  <para><constant>kgdboc=&lt;tty-device&gt;,[baud]</constant></para>
+  </sect1>
+  </chapter>
+  <chapter id="usingKDB">
+  <title>Using kdb</title>
   <para>
-  The example here would be if your console port was typically ttyS0, you would use something like <constant>kgdboc=ttyS0,115200</constant> or on the ARM Versatile AB you would likely use <constant>kgdboc=ttyAMA0,115200</constant>
+  </para>
+  <sect1 id="quickKDBserial">
+  <title>Quick start for kdb on a serial port</title>
+  <para>This is a quick example of how to use kdb.</para>
+  <para><orderedlist>
+  <listitem><para>Boot kernel with arguments:
+  <itemizedlist>
+  <listitem><para><constant>console=ttyS0,115200 kgdboc=ttyS0,115200</constant></para></listitem>
+  </itemizedlist></para>
+  <para>OR</para>
+  <para>Configure kgdboc after the kernel booted; assuming you are using a serial port console:
+  <itemizedlist>
+  <listitem><para><constant>echo ttyS0 &gt; /sys/module/kgdboc/parameters/kgdboc</constant></para></listitem>
+  </itemizedlist>
   </para>
   </listitem>
-  <listitem><para>From sysfs</para>
-  <para><constant>echo ttyS0 &gt; /sys/module/kgdboc/parameters/kgdboc</constant></para>
+  <listitem><para>Enter the kernel debugger manually or by waiting for an oops or fault.  There are several ways you can enter the kernel debugger manually; all involve using the sysrq-g, which means you must have enabled CONFIG_MAGIC_SYSRQ=y in your kernel config.</para>
+  <itemizedlist>
+  <listitem><para>When logged in as root or with a super user session you can run:</para>
+   <para><constant>echo g &gt; /proc/sysrq-trigger</constant></para></listitem>
+  <listitem><para>Example using minicom 2.2</para>
+  <para>Press: <constant>Control-a</constant></para>
+  <para>Press: <constant>f</constant></para>
+  <para>Press: <constant>g</constant></para>
   </listitem>
-  </orderedlist>
-  </para>
-  <para>
-  NOTE: Kgdboc does not support interrupting the target via the
-  gdb remote protocol.  You must manually send a sysrq-g unless you
-  have a proxy that splits console output to a terminal problem and
-  has a separate port for the debugger to connect to that sends the
-  sysrq-g for you.
+  <listitem><para>When you have telneted to a terminal server that supports sending a remote break</para>
+  <para>Press: <constant>Control-]</constant></para>
+  <para>Type in:<constant>send break</constant></para>
+  <para>Press: <constant>Enter</constant></para>
+  <para>Press: <constant>g</constant></para>
+  </listitem>
+  </itemizedlist>
+  </listitem>
+  <listitem><para>From the kdb prompt you can run the "help" command to see a complete list of the commands that are available.</para>
+  <para>Some useful commands in kdb include:
+  <itemizedlist>
+  <listitem><para>lsmod  -- Shows where kernel modules are loaded</para></listitem>
+  <listitem><para>ps -- Displays only the active processes</para></listitem>
+  <listitem><para>ps A -- Shows all the processes</para></listitem>
+  <listitem><para>summary -- Shows kernel version info and memory usage</para></listitem>
+  <listitem><para>bt -- Get a backtrace of the current process using dump_stack()</para></listitem>
+  <listitem><para>dmesg -- View the kernel syslog buffer</para></listitem>
+  <listitem><para>go -- Continue the system</para></listitem>
+  </itemizedlist>
   </para>
-  <para>When using kgdboc with no debugger proxy, you can end up
-  connecting the debugger for one of two entry points.  If an
-  exception occurs after you have loaded kgdboc a message should print
-  on the console stating it is waiting for the debugger.  In case you
-  disconnect your terminal program and then connect the debugger in
-  its place.  If you want to interrupt the target system and forcibly
-  enter a debug session you have to issue a Sysrq sequence and then
-  type the letter <constant>g</constant>.  Then you disconnect the
-  terminal session and connect gdb.  Your options if you don't like
-  this are to hack gdb to send the sysrq-g for you as well as on the
-  initial connect, or to use a debugger proxy that allows an
-  unmodified gdb to do the debugging.
+  </listitem>
+  <listitem>
+  <para>When you are done using kdb you need to consider rebooting the
+  system or using the "go" command to resuming normal kernel
+  execution.  If you have paused the kernel for a lengthy period of
+  time, applications that rely on timely networking or anything to do
+  with real wall clock time could be adversely affected, so you
+  should take this into consideration when using the kernel
+  debugger.</para>
+  </listitem>
+  </orderedlist></para>
+  </sect1>
+  <sect1 id="quickKDBkeyboard">
+  <title>Quick start for kdb using a keyboard connected console</title>
+  <para>This is a quick example of how to use kdb with a keyboard.</para>
+  <para><orderedlist>
+  <listitem><para>Boot kernel with arguments:
+  <itemizedlist>
+  <listitem><para><constant>kgdboc=kbd</constant></para></listitem>
+  </itemizedlist></para>
+  <para>OR</para>
+  <para>Configure kgdboc after the kernel booted:
+  <itemizedlist>
+  <listitem><para><constant>echo kbd &gt; /sys/module/kgdboc/parameters/kgdboc</constant></para></listitem>
+  </itemizedlist>
   </para>
-  </sect2>
+  </listitem>
+  <listitem><para>Enter the kernel debugger manually or by waiting for an oops or fault.  There are several ways you can enter the kernel debugger manually; all involve using the sysrq-g, which means you must have enabled CONFIG_MAGIC_SYSRQ=y in your kernel config.</para>
+  <itemizedlist>
+  <listitem><para>When logged in as root or with a super user session you can run:</para>
+   <para><constant>echo g &gt; /proc/sysrq-trigger</constant></para></listitem>
+  <listitem><para>Example using a laptop keyboard</para>
+  <para>Press and hold down: <constant>Alt</constant></para>
+  <para>Press and hold down: <constant>Fn</constant></para>
+  <para>Press and release the key with the label: <constant>SysRq</constant></para>
+  <para>Release: <constant>Fn</constant></para>
+  <para>Press and release: <constant>g</constant></para>
+  <para>Release: <constant>Alt</constant></para>
+  </listitem>
+  <listitem><para>Example using a PS/2 101-key keyboard</para>
+  <para>Press and hold down: <constant>Alt</constant></para>
+  <para>Press and release the key with the label: <constant>SysRq</constant></para>
+  <para>Press and release: <constant>g</constant></para>
+  <para>Release: <constant>Alt</constant></para>
+  </listitem>
+  </itemizedlist>
+  </listitem>
+  <listitem>
+  <para>Now type in a kdb command such as "help", "dmesg", "bt" or "go" to continue kernel execution.</para>
+  </listitem>
+  </orderedlist></para>
   </sect1>
-  <sect1 id="kgdbcon">
-  <title>Kernel parameter: kgdbcon</title>
-  <para>
-  Kgdb supports using the gdb serial protocol to send console messages
-  to the debugger when the debugger is connected and running.  There
-  are two ways to activate this feature.
+  </chapter>
+  <chapter id="EnableKGDB">
+   <title>Using kgdb / gdb</title>
+   <para>In order to use kgdb you must activate it by passing
+   configuration information to one of the kgdb I/O drivers.  If you
+   do not pass any configuration information kgdb will not do anything
+   at all.  Kgdb will only actively hook up to the kernel trap hooks
+   if a kgdb I/O driver is loaded and configured.  If you unconfigure
+   a kgdb I/O driver, kgdb will unregister all the kernel hook points.
+   </para>
+   <para> All kgdb I/O drivers can be reconfigured at run time, if
+   <symbol>CONFIG_SYSFS</symbol> and <symbol>CONFIG_MODULES</symbol>
+   are enabled, by echo'ing a new config string to
+   <constant>/sys/module/&lt;driver&gt;/parameter/&lt;option&gt;</constant>.
+   The driver can be unconfigured by passing an empty string.  You cannot
+   change the configuration while the debugger is attached.  Make sure
+   to detach the debugger with the <constant>detach</constant> command
+   prior to trying to unconfigure a kgdb I/O driver.
+   </para>
+  <sect1 id="ConnectingGDB">
+  <title>Connecting with gdb to a serial port</title>
   <orderedlist>
-  <listitem><para>Activate with the kernel command line option:</para>
-  <para><constant>kgdbcon</constant></para>
+  <listitem><para>Configure kgdboc</para>
+   <para>Boot kernel with arguments:
+   <itemizedlist>
+    <listitem><para><constant>kgdboc=ttyS0,115200</constant></para></listitem>
+   </itemizedlist></para>
+   <para>OR</para>
+   <para>Configure kgdboc after the kernel booted:
+   <itemizedlist>
+    <listitem><para><constant>echo ttyS0 &gt; /sys/module/kgdboc/parameters/kgdboc</constant></para></listitem>
+   </itemizedlist></para>
   </listitem>
-  <listitem><para>Use sysfs before configuring an io driver</para>
-  <para>
-  <constant>echo 1 &gt; /sys/module/kgdb/parameters/kgdb_use_con</constant>
-  </para>
-  <para>
-  NOTE: If you do this after you configure the kgdb I/O driver, the
-  setting will not take effect until the next point the I/O is
-  reconfigured.
-  </para>
+  <listitem>
+  <para>Stop kernel execution (break into the debugger)</para>
+  <para>In order to connect to gdb via kgdboc, the kernel must
+  first be stopped.  There are several ways to stop the kernel which
+  include using kgdbwait as a boot argument, via a sysrq-g, or running
+  the kernel until it takes an exception where it waits for the
+  debugger to attach.
+  <itemizedlist>
+  <listitem><para>When logged in as root or with a super user session you can run:</para>
+   <para><constant>echo g &gt; /proc/sysrq-trigger</constant></para></listitem>
+  <listitem><para>Example using minicom 2.2</para>
+  <para>Press: <constant>Control-a</constant></para>
+  <para>Press: <constant>f</constant></para>
+  <para>Press: <constant>g</constant></para>
   </listitem>
-  </orderedlist>
-  </para>
-  <para>
-  IMPORTANT NOTE: Using this option with kgdb over the console
-  (kgdboc) is not supported.
+  <listitem><para>When you have telneted to a terminal server that supports sending a remote break</para>
+  <para>Press: <constant>Control-]</constant></para>
+  <para>Type in:<constant>send break</constant></para>
+  <para>Press: <constant>Enter</constant></para>
+  <para>Press: <constant>g</constant></para>
+  </listitem>
+  </itemizedlist>
   </para>
-  </sect1>
-  </chapter>
-  <chapter id="ConnectingGDB">
-  <title>Connecting gdb</title>
-    <para>
-    If you are using kgdboc, you need to have used kgdbwait as a boot
-    argument, issued a sysrq-g, or the system you are going to debug
-    has already taken an exception and is waiting for the debugger to
-    attach before you can connect gdb.
-    </para>
-    <para>
-    If you are not using different kgdb I/O driver other than kgdboc,
-    you should be able to connect and the target will automatically
-    respond.
-    </para>
+  </listitem>
+  <listitem>
+    <para>Connect from from gdb</para>
     <para>
-    Example (using a serial port):
+    Example (using a directly connected port):
     </para>
     <programlisting>
     % gdb ./vmlinux
@@ -266,7 +499,7 @@
     (gdb) target remote /dev/ttyS0
     </programlisting>
     <para>
-    Example (kgdb to a terminal server on tcp port 2012):
+    Example (kgdb to a terminal server on TCP port 2012):
     </para>
     <programlisting>
     % gdb ./vmlinux
@@ -283,6 +516,83 @@
     communications.  You do this prior to issuing the <constant>target
     remote</constant> command by typing in: <constant>set debug remote 1</constant>
     </para>
+  </listitem>
+  </orderedlist>
+  <para>Remember if you continue in gdb, and need to "break in" again,
+  you need to issue an other sysrq-g.  It is easy to create a simple
+  entry point by putting a breakpoint at <constant>sys_sync</constant>
+  and then you can run "sync" from a shell or script to break into the
+  debugger.</para>
+  </sect1>
+  </chapter>
+  <chapter id="switchKdbKgdb">
+  <title>kgdb and kdb interoperability</title>
+  <para>It is possible to transition between kdb and kgdb dynamically.
+  The debug core will remember which you used the last time and
+  automatically start in the same mode.</para>
+  <sect1>
+  <title>Switching between kdb and kgdb</title>
+  <sect2>
+  <title>Switching from kgdb to kdb</title>
+  <para>
+  There are two ways to switch from kgdb to kdb: you can use gdb to
+  issue a maintenance packet, or you can blindly type the command $3#33.
+  Whenever kernel debugger stops in kgdb mode it will print the
+  message <constant>KGDB or $3#33 for KDB</constant>.  It is important
+  to note that you have to type the sequence correctly in one pass.
+  You cannot type a backspace or delete because kgdb will interpret
+  that as part of the debug stream.
+  <orderedlist>
+  <listitem><para>Change from kgdb to kdb by blindly typing:</para>
+  <para><constant>$3#33</constant></para></listitem>
+  <listitem><para>Change from kgdb to kdb with gdb</para>
+  <para><constant>maintenance packet 3</constant></para>
+  <para>NOTE: Now you must kill gdb. Typically you press control-z and
+  issue the command: kill -9 %</para></listitem>
+  </orderedlist>
+  </para>
+  </sect2>
+  <sect2>
+  <title>Change from kdb to kgdb</title>
+  <para>There are two ways you can change from kdb to kgdb.  You can
+  manually enter kgdb mode by issuing the kgdb command from the kdb
+  shell prompt, or you can connect gdb while the kdb shell prompt is
+  active.  The kdb shell looks for the typical first commands that gdb
+  would issue with the gdb remote protocol and if it sees one of those
+  commands it automatically changes into kgdb mode.</para>
+  <orderedlist>
+  <listitem><para>From kdb issue the command:</para>
+  <para><constant>kgdb</constant></para>
+  <para>Now disconnect your terminal program and connect gdb in its place</para></listitem>
+  <listitem><para>At the kdb prompt, disconnect the terminal program and connect gdb in its place.</para></listitem>
+  </orderedlist>
+  </sect2>
+  </sect1>
+  <sect1>
+  <title>Running kdb commands from gdb</title>
+  <para>It is possible to run a limited set of kdb commands from gdb,
+  using the gdb monitor command.  You don't want to execute any of the
+  run control or breakpoint operations, because it can disrupt the
+  state of the kernel debugger.  You should be using gdb for
+  breakpoints and run control operations if you have gdb connected.
+  The more useful commands to run are things like lsmod, dmesg, ps or
+  possibly some of the memory information commands.  To see all the kdb
+  commands you can run <constant>monitor help</constant>.</para>
+  <para>Example:
+  <informalexample><programlisting>
+(gdb) monitor ps
+1 idle process (state I) and
+27 sleeping system daemon (state M) processes suppressed,
+use 'ps A' to see all.
+Task Addr       Pid   Parent [*] cpu State Thread     Command
+
+0xc78291d0        1        0  0    0   S  0xc7829404  init
+0xc7954150      942        1  0    0   S  0xc7954384  dropbear
+0xc78789c0      944        1  0    0   S  0xc7878bf4  sh
+(gdb)
+  </programlisting></informalexample>
+  </para>
+  </sect1>
   </chapter>
   <chapter id="KGDBTestSuite">
     <title>kgdb Test Suite</title>
@@ -309,34 +619,36 @@
     </para>
   </chapter>
   <chapter id="CommonBackEndReq">
-  <title>KGDB Internals</title>
+  <title>Kernel Debugger Internals</title>
   <sect1 id="kgdbArchitecture">
     <title>Architecture Specifics</title>
       <para>
-      Kgdb is organized into three basic components:
+      The kernel debugger is organized into a number of components:
       <orderedlist>
-      <listitem><para>kgdb core</para>
+      <listitem><para>The debug core</para>
       <para>
-      The kgdb core is found in kernel/kgdb.c.  It contains:
+      The debug core is found in kernel/debugger/debug_core.c.  It contains:
       <itemizedlist>
-      <listitem><para>All the logic to implement the gdb serial protocol</para></listitem>
-      <listitem><para>A generic OS exception handler which includes sync'ing the processors into a stopped state on an multi cpu system.</para></listitem>
+      <listitem><para>A generic OS exception handler which includes
+      sync'ing the processors into a stopped state on an multi-CPU
+      system.</para></listitem>
       <listitem><para>The API to talk to the kgdb I/O drivers</para></listitem>
-      <listitem><para>The API to make calls to the arch specific kgdb implementation</para></listitem>
+      <listitem><para>The API to make calls to the arch-specific kgdb implementation</para></listitem>
       <listitem><para>The logic to perform safe memory reads and writes to memory while using the debugger</para></listitem>
       <listitem><para>A full implementation for software breakpoints unless overridden by the arch</para></listitem>
+      <listitem><para>The API to invoke either the kdb or kgdb frontend to the debug core.</para></listitem>
       </itemizedlist>
       </para>
       </listitem>
-      <listitem><para>kgdb arch specific implementation</para>
+      <listitem><para>kgdb arch-specific implementation</para>
       <para>
       This implementation is generally found in arch/*/kernel/kgdb.c.
       As an example, arch/x86/kernel/kgdb.c contains the specifics to
       implement HW breakpoint as well as the initialization to
       dynamically register and unregister for the trap handlers on
-      this architecture.  The arch specific portion implements:
+      this architecture.  The arch-specific portion implements:
       <itemizedlist>
-      <listitem><para>contains an arch specific trap catcher which
+      <listitem><para>contains an arch-specific trap catcher which
       invokes kgdb_handle_exception() to start kgdb about doing its
       work</para></listitem>
       <listitem><para>translation to and from gdb specific packet format to pt_regs</para></listitem>
@@ -347,11 +659,35 @@
       </itemizedlist>
       </para>
       </listitem>
+      <listitem><para>gdbstub frontend (aka kgdb)</para>
+      <para>The gdbstub is located in kernel/debug/gdbstub.c. It contains:</para>
+      <itemizedlist>
+        <listitem><para>All the logic to implement the gdb serial protocol</para></listitem>
+      </itemizedlist>
+      </listitem>
+      <listitem><para>kdb frontend</para>
+      <para>The kdb debugger shell is broken down into a number of
+      components.  The kdb core is located in kernel/debug/kdb.  There
+      are a number of helper functions in some of the other kernel
+      components to make it possible for kdb to examine and report
+      information about the kernel without taking locks that could
+      cause a kernel deadlock.  The kdb core contains implements the following functionality.</para>
+      <itemizedlist>
+        <listitem><para>A simple shell</para></listitem>
+        <listitem><para>The kdb core command set</para></listitem>
+        <listitem><para>A registration API to register additional kdb shell commands.</para>
+        <para>A good example of a self-contained kdb module is the "ftdump" command for dumping the ftrace buffer.  See: kernel/trace/trace_kdb.c</para></listitem>
+        <listitem><para>The implementation for kdb_printf() which
+        emits messages directly to I/O drivers, bypassing the kernel
+        log.</para></listitem>
+        <listitem><para>SW / HW breakpoint management for the kdb shell</para></listitem>
+      </itemizedlist>
+      </listitem>
       <listitem><para>kgdb I/O driver</para>
       <para>
-      Each kgdb I/O driver has to provide an implemenation for the following:
+      Each kgdb I/O driver has to provide an implementation for the following:
       <itemizedlist>
-      <listitem><para>configuration via builtin or module</para></listitem>
+      <listitem><para>configuration via built-in or module</para></listitem>
       <listitem><para>dynamic configuration and kgdb hook registration calls</para></listitem>
       <listitem><para>read and write character interface</para></listitem>
       <listitem><para>A cleanup handler for unconfiguring from the kgdb core</para></listitem>
@@ -416,15 +752,15 @@
   underlying low level to the hardware driver having "polling hooks"
   which the to which the tty driver is attached.  In the initial
   implementation of kgdboc it the serial_core was changed to expose a
-  low level uart hook for doing polled mode reading and writing of a
+  low level UART hook for doing polled mode reading and writing of a
   single character while in an atomic context.  When kgdb makes an I/O
   request to the debugger, kgdboc invokes a call back in the serial
-  core which in turn uses the call back in the uart driver.  It is
-  certainly possible to extend kgdboc to work with non-uart based
+  core which in turn uses the call back in the UART driver.  It is
+  certainly possible to extend kgdboc to work with non-UART based
   consoles in the future.
   </para>
   <para>
-  When using kgdboc with a uart, the uart driver must implement two callbacks in the <constant>struct uart_ops</constant>. Example from drivers/8250.c:<programlisting>
+  When using kgdboc with a UART, the UART driver must implement two callbacks in the <constant>struct uart_ops</constant>. Example from drivers/8250.c:<programlisting>
 #ifdef CONFIG_CONSOLE_POLL
 	.poll_get_char = serial8250_get_poll_char,
 	.poll_put_char = serial8250_put_poll_char,
@@ -434,7 +770,7 @@
   <constant>#ifdef CONFIG_CONSOLE_POLL</constant>, as shown above.
   Keep in mind that polling hooks have to be implemented in such a way
   that they can be called from an atomic context and have to restore
-  the state of the uart chip on return such that the system can return
+  the state of the UART chip on return such that the system can return
   to normal when the debugger detaches.  You need to be very careful
   with any kind of lock you consider, because failing here is most
   going to mean pressing the reset button.
@@ -453,6 +789,10 @@
 		<itemizedlist>
 		<listitem><para>Jason Wessel<email>jason.wessel@windriver.com</email></para></listitem>
 		</itemizedlist>
+                In Jan 2010 this document was updated to include kdb.
+		<itemizedlist>
+		<listitem><para>Jason Wessel<email>jason.wessel@windriver.com</email></para></listitem>
+		</itemizedlist>
 	</para>
   </chapter>
 </book>
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 293b0e0..414347e 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -58,6 +58,7 @@ parameter is applicable:
 	ISAPNP	ISA PnP code is enabled.
 	ISDN	Appropriate ISDN support is enabled.
 	JOY	Appropriate joystick support is enabled.
+	KGDB	Kernel debugger support is enabled.
 	KVM	Kernel Virtual Machine support is enabled.
 	LIBATA  Libata driver is enabled
 	LP	Printer support is enabled.
@@ -1112,13 +1113,16 @@ and is between 256 and 4096 characters. It is defined in the file
 			use the HighMem zone if it exists, and the Normal
 			zone if it does not.
 
-	kgdboc=		[HW] kgdb over consoles.
+	kgdboc=		[KGDB,HW] kgdb over consoles.
 			Requires a tty driver that supports console polling,
 			or a supported polling keyboard driver (non-usb).
 			Serial only format: <serial_device>[,baud]
 			keyboard only format: kbd
 			keyboard and serial format: kbd,<serial_device>[,baud]
 
+	kgdbwait	[KGDB] Stop kernel execution and enter the
+			kernel debugger at the earliest opportunity.
+
 	kmac=		[MIPS] korina ethernet MAC address.
 			Configure the RouterBoard 532 series on-chip
 			Ethernet adapter MAC address.
diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 5b37df0..407edb1 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -204,6 +204,17 @@ kgdb_arch_handle_exception(int vector, int signo, int err_code,
  */
 extern void kgdb_roundup_cpus(unsigned long flags);
 
+/**
+ *	kgdb_arch_set_pc - Generic call back to the program counter
+ *	@regs: Current &struct pt_regs.
+ *  @pc: The new value for the program counter
+ *
+ *	This function handles updating the program counter and requires an
+ *	architecture specific implementation.
+ */
+extern void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long pc);
+
+
 /* Optional functions. */
 extern int kgdb_validate_break_address(unsigned long addr);
 extern int kgdb_arch_set_breakpoint(unsigned long addr, char *saved_instr);
@@ -264,7 +275,6 @@ extern struct kgdb_arch		arch_kgdb_ops;
 
 extern unsigned long __weak kgdb_arch_pc(int exception, struct pt_regs *regs);
 
-extern void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long pc);
 extern int kgdb_register_io_module(struct kgdb_io *local_kgdb_io_ops);
 extern void kgdb_unregister_io_module(struct kgdb_io *local_kgdb_io_ops);
 extern struct kgdb_io *dbg_io_ops;
-- 
1.6.3.3

