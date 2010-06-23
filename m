Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab0FWHcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 03:32:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55390 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab0FWHcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 03:32:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: -next June 21: WARNING: at include/linux/tty.h
Date: Wed, 23 Jun 2010 09:32:00 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-00068-g1931a4d-dirty; KDE/4.4.85; x86_64; ; )
Cc: Sachin Sant <sachinp@in.ibm.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20100621170056.2fcf10ad.sfr@canb.auug.org.au> <4C204962.70208@in.ibm.com> <20100623165557.d793dc41.sfr@canb.auug.org.au>
In-Reply-To: <20100623165557.d793dc41.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006230932.00445.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+JtiAMDTTomOjqWmoD212GfuWFOYRDkVVq1/A
 K0Xvg4A7coED6od80KPbYyndfjFhh8jr6ehN4xhPTDtm8hAvRZ
 nKUdKSBRnK433clb9+aZQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 June 2010 08:55:57 Stephen Rothwell wrote:
> On Tue, 22 Jun 2010 10:55:54 +0530 Sachin Sant <sachinp@in.ibm.com> wrote:
> >
> > With next-20100621 on a x86_64 box came across this warning :
> > 
> > TCP cubic registered
> > registered taskstats version 1
> > ------------[ cut here ]------------
> > WARNING: at include/linux/tty.h:589 tty_open+0x76/0x57a()
>
> I get this twice for each boot.

Tony Luck also reported this, it's harmless and gets fixed 
by the patch below, which belongs to another series. 
There are still a few dependencies between the other
BKL removal series, which I try to minimize and then
I'll ask you to add those to -next.

---

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
 
