Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab1BWRrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:47:47 -0500
Received: from usindmx04.hds.com ([207.126.252.15]:37615 "EHLO
	usindmx04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab1BWRrp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:47:45 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jarod@redhat.com" <jarod@redhat.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "ying.huang@intel.com" <ying.huang@intel.com>
CC: Satoru Moriya <satoru.moriya@hds.com>
Date: Wed, 23 Feb 2011 12:46:54 -0500
Subject: [RFC][PATCH] Execute kmsg_dump() reliably in kdump path
Thread-Topic: [RFC][PATCH] Execute kmsg_dump() reliably in kdump path
Thread-Index: AcvTgaiNIX96v06QSYmqA0L+T0ebsw==
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C14B5A307@USINDEVS01.corp.hds.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry.
I resend this patch because some mail address ,linux-kernel@vger.kernel.org and 
kosaki.motohiro@jp.fujitsu.com, were missing.

Seiji

Hi,

This patch tries to execute kmsg_dump() reliably in kdump path.

[Needs for kmsg_dump() in kdump path]
 
 From our support service experience, we always need to detect root cause of OS panic.
 Customers in enterprise area never forgive us if kdump fails and  we can't detect the root  cause of panic due to lack of materials for investigation.

 On the other hand, kdump could be unreliable for following reason.
    - Before booting 2nd kernel, kdump checks its sha256 checksum and if it fails to
      verify the correctness, kdump doesn't start 2nd kernel. In other words, we may 
      loose materials for detecting root cause of kernel panic when memory corruption happens.

 For avoiding losing materials, we want two mechanisms in place. 
  - One is light weight ,kmsg_dump, which tries to save kernel buffers in NVRAM/flush memory.
  - The other is heavy weight one ,kdump, which tries to save the entire/filtered kernel core.

[Discussion about kmsg_dump() in kdump path]

 Eric(and others) think that kmsg_dump() should be removed from kdump path because code of
 kmsg_dump() is unreliable and it may cause kdump failure.
 The patch has already been proposed.
 https://lkml.org/lkml/2011/2/1/33

 On the other hand, Hitachi would like to store kernel buffers to NVRAM in kdump path because  we may not have any information after the crash if kdump fails.

 For executing kmsg_dump() reliably and avoiding losing materials, Vivek suggested an idea.
 This is overview of his idea.
   - Share common parts ,stopping other cpus by NMI/IPI, of kdump/panic.
   - Save kernel buffer in NVRAM/flush memory after stopping other cpus.
   - Introduce new mutex_lock for sending IPI/NMI reliably when two cpus panics 
     at the same time.

 Detailed explanation is following. 
 https://lkml.org/lkml/2011/2/8/223

[Patch Description]

 This patch is developed based on Vivek's idea above.

 <changelog>
  - Merge machine_crash_shutdown() and smp_send_stop() into stop_cpus_on_panic() for sharing
    common parts ,stopping other cpus by NMI/IPI, of kdump/panic. 
  - Move kmsg_dump(KMSG_DUMP_PANIC) just after stop_cpus_on_panic() for saving kernel buffer
    in NVRAM/flush memory reliably.
  - Introduce panic_mutex for sending IPI/NMI reliably when two cpus panics at the same time.

  <flowchart>
   panic happens
    - printing panic strings and stacks. (dumpstack, etc)
    - Stop other cpus. (stop_cpus_on_panic())
    - Dump kernel buffer to NVRAM or flash memory.(kmsg_dump(KMSG_DUMP_PANIC))
    - When kdump is enabled, 2nd kernel boots.(crash_kexec())
    - When kdump is disabled, panic_notifier() is called.

  <new function call>
  stop_cpus_on_panic()
   - When kdump is enabled, crash_setup_regs(), crash_save_vmcoreinfo() 
     and machine_crash_shutdown() is called.
   - When kdump is disabled, smp_send_stop() is called.

  <modified function call>
  crash_kexec()
   - When kdump is enabled, machine_kexec() is called.
   - When kdump is disabled, returns with doing nothing.

  <new mutex_lock>
  panic_mutex
   It is introduced for sending IPI/NMI reliably when two cpus panics at the same time.

[Build status]
 This patch is built against 2.6.38-rc6.

[Test Status]

<simple regression test>

 - Case 1
 Condition
    kernel panics when kdump is enabled.
 Result
   - kmsg_dump() is called.
   - 2nd kernel boots and dumps memory successfully.
 
- Case 2
  Condition
      kernel panics when kdump is disabled.
  Result
     panic notifier is called successfully.

<checking timing issue of kexec_mutex and value of kexec_crash_image>

- Case 3
  Condition
     cpuX panics while cpuX is getting kexec_mutex, 2nd kernel is not loaded.
  Result
     kmsg_dump() and panic notifier are called successfully.

- Case 4
  Condition
     cpuX panics while cpuX is getting kexec_mutex, 2nd kernel is loaded.
  Result
     kmsg_dump() and panic notifier are called successfully.

- Case 5
  Condition
      cpuY panics while cpuX is getting kexec_mutex, 2nd kernel is not loaded.
  Result
     kmsg_dump() and panic notifier are called successfully.

- Case 6
  Condition
     cpuY panics while cpuX is getting kexec_mutex, 2nd kernel is loaded.
  Result
     kmsg_dump() and panic notifier are called successfully.


<checking timing issue of panic_mutex>

- Case 7
  Condition
      cpuX and cpuY panics at the same time when kdump is enabled.
  Result
    - kmsg_dump() is called,
    - 2nd kernel boots and memory dump succeed

- Case 8
  Condition
      cpuX and cpuY panics at the same time when kdump is disabled.
  Result
      kmsg_dump() and panic notifier are called successfully.


Any comments and suggestions are welcome.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

---
 include/linux/kexec.h |    2 ++
 include/linux/smp.h   |   12 ++++++++++++
 kernel/kexec.c        |   30 +++++++++++++++++++-----------
 kernel/panic.c        |   23 +++++++++++++----------
 4 files changed, 46 insertions(+), 21 deletions(-)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h index 03e8e8d..8860ee9 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -125,6 +125,8 @@ extern asmlinkage long compat_sys_kexec_load(unsigned long entry,  #endif  extern struct page *kimage_alloc_control_pages(struct kimage *image,
 						unsigned int order);
+extern void crash_kexec_prepare(struct pt_regs *); extern void 
+stop_cpus_on_panic(void);
 extern void crash_kexec(struct pt_regs *);  int kexec_should_crash(struct task_struct *);  void crash_save_cpu(struct pt_regs *regs, int cpu); diff --git a/include/linux/smp.h b/include/linux/smp.h index 6dc95ca..164d9a9 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -46,6 +46,12 @@ int smp_call_function_single(int cpuid, smp_call_func_t func, void *info,
  */
 extern void smp_send_stop(void);
 
+#ifdef CONFIG_KEXEC
+extern void stop_cpus_on_panic(void);
+#else
+static inline void stop_cpus_on_panic(void){ smp_send_stop(); } #endif
+
 /*
  * sends a 'reschedule' event to another CPU:
  */
@@ -119,6 +125,12 @@ extern unsigned int setup_max_cpus;
 
 static inline void smp_send_stop(void) { }
 
+#ifdef CONFIG_KEXEC
+extern void stop_cpus_on_panic(void);
+#else
+static inline void stop_cpus_on_panic(void) { } #endif
+
 /*
  *	These macros fold the SMP functionality into a single CPU system
  */
diff --git a/kernel/kexec.c b/kernel/kexec.c index ec19b92..f68ea03 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -49,6 +49,8 @@ u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
 size_t vmcoreinfo_size;
 size_t vmcoreinfo_max_size = sizeof(vmcoreinfo_data);
 
+static int kexec_mutex_is_locked;
+
 /* Location of the reserved area for the crash kernel */  struct resource crashk_res = {
 	.name  = "Crash kernel",
@@ -1064,6 +1066,21 @@ asmlinkage long compat_sys_kexec_load(unsigned long entry,  }  #endif
 
+void stop_cpus_on_panic(void)
+{
+	if (mutex_trylock(&kexec_mutex)) {
+		kexec_mutex_is_locked = 1;
+		if (kexec_crash_image) {
+			struct pt_regs fixed_regs;
+			crash_setup_regs(&fixed_regs, NULL);
+			crash_save_vmcoreinfo();
+			machine_crash_shutdown(&fixed_regs);
+			return;
+		}
+	}
+	smp_send_stop();
+}
+
 void crash_kexec(struct pt_regs *regs)
 {
 	/* Take the kexec_mutex here to prevent sys_kexec_load @@ -1074,17 +1091,8 @@ void crash_kexec(struct pt_regs *regs)
 	 * of memory the xchg(&kexec_crash_image) would be
 	 * sufficient.  But since I reuse the memory...
 	 */
-	if (mutex_trylock(&kexec_mutex)) {
-		if (kexec_crash_image) {
-			struct pt_regs fixed_regs;
-
-			kmsg_dump(KMSG_DUMP_KEXEC);
-
-			crash_setup_regs(&fixed_regs, regs);
-			crash_save_vmcoreinfo();
-			machine_crash_shutdown(&fixed_regs);
-			machine_kexec(kexec_crash_image);
-		}
+	if ((kexec_mutex_is_locked == 1) && kexec_crash_image) {
+		machine_kexec(kexec_crash_image);
 		mutex_unlock(&kexec_mutex);
 	}
 }
diff --git a/kernel/panic.c b/kernel/panic.c index 991bb87..9dd5fdd 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -40,6 +40,8 @@ ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
 
 EXPORT_SYMBOL(panic_notifier_list);
 
+static DEFINE_MUTEX(panic_mutex);
+
 static long no_blink(int state)
 {
 	return 0;
@@ -86,16 +88,17 @@ NORET_TYPE void panic(const char * fmt, ...)
 	 * everything else.
 	 * Do we want to call this before we try to display a message?
 	 */
-	crash_kexec(NULL);
-
-	kmsg_dump(KMSG_DUMP_PANIC);
-
-	/*
-	 * Note smp_send_stop is the usual smp shutdown function, which
-	 * unfortunately means it may not be hardened to work in a panic
-	 * situation.
-	 */
-	smp_send_stop();
+	if (mutex_trylock(&panic_mutex)) {
+		stop_cpus_on_panic();
+		kmsg_dump(KMSG_DUMP_PANIC);
+		crash_kexec(NULL);
+		mutex_unlock(&panic_mutex);
+	} else {
+		/* Waiting for NMI or IPI from panicked cpu. */
+		local_irq_enable();
+		while (1)
+			cpu_relax();
+	}
 
 	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
 
--
1.7.1

