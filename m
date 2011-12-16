Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891Ab1LPTwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:52:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45113 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932836Ab1LPTuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:50:54 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:45:59 2011
Message-Id: <20111216194559.388964698@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:45:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [33/53] xen/pm_idle: Make pm_idle be default_idle under Xen.
In-Reply-To: <20111216194613.GA18395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit e5fd47bfab2df0c2184cc0bf4245d8e1bb7724fb upstream.

The idea behind commit d91ee5863b71 ("cpuidle: replace xen access to x86
pm_idle and default_idle") was to have one call - disable_cpuidle()
which would make pm_idle not be molested by other code.  It disallows
cpuidle_idle_call to be set to pm_idle (which is excellent).

But in the select_idle_routine() and idle_setup(), the pm_idle can still
be set to either: amd_e400_idle, mwait_idle or default_idle.  This
depends on some CPU flags (MWAIT) and in AMD case on the type of CPU.

In case of mwait_idle we can hit some instances where the hypervisor
(Amazon EC2 specifically) sets the MWAIT and we get:

  Brought up 2 CPUs
  invalid opcode: 0000 [#1] SMP

  Pid: 0, comm: swapper Not tainted 3.1.0-0.rc6.git0.3.fc16.x86_64 #1
  RIP: e030:[<ffffffff81015d1d>]  [<ffffffff81015d1d>] mwait_idle+0x6f/0xb4
  ...
  Call Trace:
   [<ffffffff8100e2ed>] cpu_idle+0xae/0xe8
   [<ffffffff8149ee78>] cpu_bringup_and_idle+0xe/0x10
  RIP  [<ffffffff81015d1d>] mwait_idle+0x6f/0xb4
   RSP <ffff8801d28ddf10>

In the case of amd_e400_idle we don't get so spectacular crashes, but we
do end up making an MSR which is trapped in the hypervisor, and then
follow it up with a yield hypercall.  Meaning we end up going to
hypervisor twice instead of just once.

The previous behavior before v3.0 was that pm_idle was set to
default_idle regardless of select_idle_routine/idle_setup.

We want to do that, but only for one specific case: Xen.  This patch
does that.

Fixes RH BZ #739499 and Ubuntu #881076
Reported-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/system.h |    1 +
 arch/x86/kernel/process.c     |    8 ++++++++
 arch/x86/xen/setup.c          |    2 +-
 3 files changed, 10 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -401,6 +401,7 @@ extern unsigned long arch_align_stack(un
 extern void free_init_pages(char *what, unsigned long begin, unsigned long end);
 
 void default_idle(void);
+bool set_pm_idle_to_default(void);
 
 void stop_this_cpu(void *dummy);
 
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -403,6 +403,14 @@ void default_idle(void)
 EXPORT_SYMBOL(default_idle);
 #endif
 
+bool set_pm_idle_to_default(void)
+{
+	bool ret = !!pm_idle;
+
+	pm_idle = default_idle;
+
+	return ret;
+}
 void stop_this_cpu(void *dummy)
 {
 	local_irq_disable();
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -448,6 +448,6 @@ void __init xen_arch_setup(void)
 #endif
 	disable_cpuidle();
 	boot_option_idle_override = IDLE_HALT;
-
+	WARN_ON(set_pm_idle_to_default());
 	fiddle_vdso();
 }


