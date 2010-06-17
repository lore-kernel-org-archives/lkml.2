Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933211Ab0FQTlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 15:41:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53513 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933009Ab0FQTlG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 15:41:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v3 00/10] BKL conversion in tty layer
Date: Thu, 17 Jun 2010 21:40:45 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.35-rc1-00090-g358f4b6; KDE/4.4.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de> <20100517144130.1d8aa313@lxorguk.ukuu.org.uk> <AANLkTimO08zZV4DenxT0wi3eWp1BngGu14x0GWRyfgO5@mail.gmail.com>
In-Reply-To: <AANLkTimO08zZV4DenxT0wi3eWp1BngGu14x0GWRyfgO5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201006172140.46203.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/NVU2uBW3DwyefMfydaDfHDKCCYrWGOLbjiwk
 qvsyqmvCcEGFBhwCYhSE8+PJfhRfgmPdax6EIcSgkRAFwYwOMc
 2lGp7QjDRF0JitRMl14Dw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 June 2010 21:13:52 Tony Luck wrote:

> These changes showed up in linux-next (tag: next-20100617) ... and I'm seeing
> a few WARN_ON messages on ia64 while booting:
> 
> WARNING: at include/linux/tty.h:589 tty_open+0x160/0xc60()
> ...
> Stack trace for the first of these looks like:
> Call Trace:
> ...
>  [<a0000001001c5270>] do_filp_open+0x2f0/0xb40
>  [<a0000001001a5290>] do_sys_open+0x90/0x200
>  [<a0000001001a54d0>] sys_open+0x50/0x80
>  [<a000000100b907e0>] kernel_init+0x340/0x420
>  [<a000000100013c10>] kernel_thread_helper+0x30/0x60
>  [<a00000010000a0c0>] start_kernel_thread+0x20/0x40
> 
> Does anyone see anything similar on other architectures?  Or is ia64 doing
> something "special" here?

Ah, I forgot to test the tty series without the other patches I have
in my bkl removal repository and without CONFIG_TTY_MUTEX.

Does the patch below make this go away? We should probably include
the 'misc' branch of my BKL repository in -next to fix this.

	Arnd

--
>From 99b699e56b23775c0c9a131208e1a5e13f6cfad3 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 15 Mar 2010 19:00:34 +0100
Subject: [PATCH] init: remove the BKL from startup code

I have shown by code review that no driver takes
the BKL at init time any more, so whatever the
init code was locking against is no longer there
and it is now safe to remove the BKL there.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/init/main.c b/init/main.c
index 3bdb152..81821e1 100644
--- a/init/main.c
+++ b/init/main.c
@@ -434,7 +434,6 @@ static noinline void __init_refok rest_init(void)
 	rcu_read_lock();
 	kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
 	rcu_read_unlock();
-	unlock_kernel();
 
 	/*
 	 * The boot idle thread must execute schedule()
@@ -555,7 +554,6 @@ asmlinkage void __init start_kernel(void)
  * Interrupts are still disabled. Do necessary setups, then
  * enable them
  */
-	lock_kernel();
 	tick_init();
 	boot_cpu_init();
 	page_address_init();
@@ -819,7 +817,6 @@ static noinline int init_post(void)
 	/* need to finish all async __init code before freeing the memory */
 	async_synchronize_full();
 	free_initmem();
-	unlock_kernel();
 	mark_rodata_ro();
 	system_state = SYSTEM_RUNNING;
 	numa_default_policy();
@@ -855,8 +852,6 @@ static noinline int init_post(void)
 
 static int __init kernel_init(void * unused)
 {
-	lock_kernel();
-
 	/*
 	 * init can allocate pages on any node
 	 */
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 086d363..8047ca5 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -734,13 +734,6 @@ __acquires(kernel_lock)
 		return -1;
 	}
 
-	/*
-	 * When this gets called we hold the BKL which means that
-	 * preemption is disabled. Various trace selftests however
-	 * need to disable and enable preemption for successful tests.
-	 * So we drop the BKL here and grab it after the tests again.
-	 */
-	unlock_kernel();
 	mutex_lock(&trace_types_lock);
 
 	tracing_selftest_running = true;
@@ -822,7 +815,6 @@ __acquires(kernel_lock)
 #endif
 
  out_unlock:
-	lock_kernel();
 	return ret;
 }
 
