Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab1ETV35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 17:29:57 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:27232
	"EHLO CH1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752996Ab1ETV3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 17:29:53 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zzbb2dKbb2cK9371O1432N98dKzz1202hzz8275bhz2fh668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4DD6DD39.2090302@am.sony.com>
Date: Fri, 20 May 2011 14:29:29 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.de>
CC: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>
Subject: Re: module boot time (was Re: [PATCH] module: Use binary search in
 lookup_symbol())
References: <BANLkTinPG100vbVAN1RZWb3h9Xuu6SKJ0Q@mail.gmail.com> <1305665763-3988-1-git-send-email-abogani@kernel.org> <20110517232241.GA19140@kroah.com> <4DD305B3.3000707@am.sony.com> <20110518075428.GA29998@infradead.org> <4DD3FB1C.3040103@am.sony.com> <20110518192110.GB26945@kroah.com> <4DD435B7.9090702@am.sony.com> <20110518213451.GA23702@kroah.com> <4DD575EF.2060008@suse.de>
In-Reply-To: <4DD575EF.2060008@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2011 12:56 PM, Jeff Mahoney wrote:
> On 05/18/2011 05:34 PM, Greg KH wrote:
>> I don't think that's worth it, there has been talk, and some initial
>> code, about adding kernel modules to the kernel image itself, which
>> would solve a lot of the i/o time of loading modules, and solves some
>> other boot speed problems.  That work was done by Jeff Mahoney, but I
>> think he ran into some "interesting" linker issues and had to shelve it
>> due to a lack of time :(
> 
> I had a few attempts at this before I had to move on to other things. I
> haven't gotten a chance to take another look.
> 
> I had two approaches:
> 
> 1) Statically link in modules post-build. This actually worked but had
> some large caveats. The first was that an un-relocated image (vmlinux.o)
> was needed in order to make it work and a ~ 200 MB footprint to gain a
> fairly small win in boot time didn't seem like a good tradeoff. The
> other issue was more important and is what made me abandon this
> approach: If the entire image is re-linked then the debuginfo package
> that we as a distributor offer but don't typically install becomes
> invalid. Our support teams would not be too thrilled with the idea of
> crash dumps that can't be used.
> 
> 2) Build a "megamodule" that is loaded like an initramfs but is already
> internally linked and requires no additional userspace. I got the
> megamodule creation working but didn't get the loading aspect of it done
> yet.
> 
> In both cases, I added the regular initcall sections to the modules in
> addition to the module sections so they'd be loaded in the order they
> would have been if they were actually statically linked.
> 
> I hadn't thought about it until now and it may not actually work, but it
> could be possible to use the megamodule approach *and* link it into a
> static vmlinux image as an appended section that's optionally used.


What was the use case for this?   My use case is that I want
to use all the modules compiled into the kernel, but I don't
want to run some modules' initcalls until well after kernel
and user-space startup.

My solution is very simple - create a new initcall macro for
the initcalls I want to defer, along with a new 'deferred' initcall
section where the function entries can be accumulated.  Then,
I avoid freeing init memory at standard initcall time.  Once
the main user-space has initialized, it echos to a /proc file
to cause the deferred initcalls to be called, and the init memory
to be freed.

I'm attaching the patch below, because it's short enough to
see what's going on without a lot of digging.

This method eliminates the linking cost for module loading,
saves the memory overhead of the ELF module format, and gives
me control over when the deferred modules will be initialized.
The big downside is that you have to manually change the definition
for the initcall from 'module_init' to 'deferred_module_init'
for the modules you want to defer.  Maybe there's a simple way
to control this with a kernel config? That would make this a pretty
nice, generic, system for deferring module initialization, IMHO.

If your use case is that you want all the modules present, but
want to initialize only some of them later, then maybe a list of
module names could be passed into the /proc interface, and the
routine could selectively initialize the deferred modules.

Patch (for 2.6.27 I believe) follows.  This is for discussion
only, I wouldn't expect it to apply to mainline.

commit 1fab0d6a932d000780cd232b7d10ebfbe69f477c
Author: Tim Bird <tim.bird@am.sony.com>
Date:   Fri Sep 12 11:31:52 2008 -0700

    Add deferred_module_init
    This allows statically linked modules to be initialized sometime after
    the initial bootstrap.  To do this, change the module_init() macro
    to deferred_module_init(), for those init routines you want to defer.

Signed-off-by: Tim Bird <tim.bird@am.sony.com>

diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index a9b8560..f5bdfc4 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -140,11 +140,21 @@ SECTIONS
 	*(.con_initcall.init)
   	__con_initcall_end = .;
   }
+  .deferred_initcall.init : AT(ADDR(.deferred_initcall.init) - LOAD_OFFSET) {
+  	__def_initcall_start = .;
+	*(.deferred_initcall.init)
+  	__def_initcall_end = .;
+  }
   .x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
 	__x86_cpu_dev_start = .;
 	*(.x86_cpu_dev.init)
 	__x86_cpu_dev_end = .;
   }
+  .x86cpuvendor.init : AT(ADDR(.x86cpuvendor.init) - LOAD_OFFSET) {
+	__x86cpuvendor_start = .;
+	*(.x86cpuvendor.init)
+	__x86cpuvendor_end = .;
+  }
   SECURITY_INIT
   . = ALIGN(4);
   .altinstructions : AT(ADDR(.altinstructions) - LOAD_OFFSET) {
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 59ea42e..a247a8e 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -703,6 +703,22 @@ static int execdomains_read_proc(char *page, char **start, off_t off,
 	return proc_calc_metrics(page, start, off, count, eof, len);
 }

+extern void do_deferred_initcalls(void);
+
+static int deferred_initcalls_read_proc(char *page, char **start, off_t off,
+				 int count, int *eof, void *data)
+{
+	static int deferred_initcalls_done = 0;
+	int len;
+
+	len = sprintf(page, "%d\n", deferred_initcalls_done);
+	if (! deferred_initcalls_done) {
+		do_deferred_initcalls();
+		deferred_initcalls_done = 1;
+	}
+	return proc_calc_metrics(page, start, off, count, eof, len);
+}
+
 #ifdef CONFIG_PROC_PAGE_MONITOR
 #define KPMSIZE sizeof(u64)
 #define KPMMASK (KPMSIZE - 1)
@@ -855,6 +871,7 @@ void __init proc_misc_init(void)
 		{"filesystems",	filesystems_read_proc},
 		{"cmdline",	cmdline_read_proc},
 		{"execdomains",	execdomains_read_proc},
+		{"deferred_initcalls",	deferred_initcalls_read_proc},
 		{NULL,}
 	};
 	for (p = simple_ones; p->name; p++)
diff --git a/include/linux/init.h b/include/linux/init.h
index ad63824..ef61767 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -200,6 +200,7 @@ extern void (*late_time_init)(void);
 #define device_initcall_sync(fn)	__define_initcall("6s",fn,6s)
 #define late_initcall(fn)		__define_initcall("7",fn,7)
 #define late_initcall_sync(fn)		__define_initcall("7s",fn,7s)
+//#define deferred_initcall(fn)		__define_initcall("8",fn,8)

 #define __initcall(fn) device_initcall(fn)

@@ -214,6 +215,10 @@ extern void (*late_time_init)(void);
 	static initcall_t __initcall_##fn \
 	__used __section(.security_initcall.init) = fn

+#define deferred_initcall(fn) \
+	static initcall_t __initcall_##fn \
+	__used __section(.deferred_initcall.init) = fn
+
 struct obs_kernel_param {
 	const char *str;
 	int (*setup_func)(char *);
@@ -254,6 +259,7 @@ void __init parse_early_param(void);
  * be one per module.
  */
 #define module_init(x)	__initcall(x);
+#define deferred_module_init(x)	deferred_initcall(x);

 /**
  * module_exit() - driver exit entry point
diff --git a/init/main.c b/init/main.c
index 27f6bf6..e4bbdb2 100644
--- a/init/main.c
+++ b/init/main.c
@@ -789,12 +789,40 @@ static void run_init_process(char *init_filename)
 	kernel_execve(init_filename, argv_init, envp_init);
 }

+extern initcall_t __def_initcall_start[], __def_initcall_end[];
+
+/* call deferred init routines */
+void do_deferred_initcalls(void)
+{
+	initcall_t *call;
+	static int already_run=0;
+
+	if (already_run) {
+		printk("do_deferred_initcalls() has already run\n");
+		return;
+	}
+
+	already_run=1;
+
+	printk("Running do_deferred_initcalls()\n");
+
+	lock_kernel();	/* make environment similar to early boot */
+
+	for(call = __def_initcall_start; call < __def_initcall_end; call++)
+		do_one_initcall(*call);
+
+	flush_scheduled_work();
+	
+	free_initmem();
+	unlock_kernel();
+}
+
 /* This is a non __init function. Force it to be noinline otherwise gcc
  * makes it inline to init() and it becomes part of init.text section
  */
 static int noinline init_post(void)
 {
-	free_initmem();
+	//free_initmem();
 	unlock_kernel();
 	mark_rodata_ro();
 	system_state = SYSTEM_RUNNING;





=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

