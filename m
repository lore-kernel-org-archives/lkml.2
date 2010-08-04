Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab0HDH7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 03:59:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60589 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138Ab0HDH7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 03:59:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=GptfqFd0YhLvUw8ZxbdkCz6bSC2Yw+TIcQN+Pv+cJo2C+z31dnQxaCE6yYLm6h1gfK
         VZf8DqzROKDTL32+ZbhXzslqNSVC/LOgM3lkkyzbtCa0o6xJhRsduOa1uoU9BYS5PxX7
         Yg1Yjsx+569bF3JZfjNJzT9gCUO8FANSDDP0A=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 1/3] Input: sysrq - drop tty argument from sysrq ops handlers
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Airlie <airlied@linux.ie>, David Miller <davem@davemloft.net>,
        Fenghua Yu <fenghua.yu@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <linux@arm.linux.org.uk>, Tony Luck <tony.luck@intel.com>
Date: Wed, 04 Aug 2010 00:59:00 -0700
Message-ID: <20100804075900.30647.46910.stgit@localhost.localdomain>
In-Reply-To: <20100804075602.30647.91462.stgit@localhost.localdomain>
References: <20100804075602.30647.91462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noone is using tty argument so let's get rid of it.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 arch/arm/kernel/etm.c           |    2 +-
 arch/powerpc/xmon/xmon.c        |    5 ++---
 arch/sparc/kernel/process_64.c  |    2 +-
 drivers/char/sysrq.c            |   42 ++++++++++++++++++++-------------------
 drivers/gpu/drm/drm_fb_helper.c |    2 +-
 drivers/net/ibm_newemac/debug.c |    2 +-
 include/linux/sysrq.h           |    6 +++++-
 kernel/power/poweroff.c         |    2 +-
 8 files changed, 33 insertions(+), 30 deletions(-)

diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index 8277539..7647593 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -230,7 +230,7 @@ static void etm_dump(void)
 	etb_lock(t);
 }
 
-static void sysrq_etm_dump(int key, struct tty_struct *tty)
+static void sysrq_etm_dump(int key)
 {
 	dev_dbg(tracer.dev, "Dumping ETB buffer\n");
 	etm_dump();
diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index 8bad7d5..654e155 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -2728,15 +2728,14 @@ static void xmon_init(int enable)
 }
 
 #ifdef CONFIG_MAGIC_SYSRQ
-static void sysrq_handle_xmon(int key, struct tty_struct *tty) 
+static void sysrq_handle_xmon(int key)
 {
 	/* ensure xmon is enabled */
 	xmon_init(1);
 	debugger(get_irq_regs());
 }
 
-static struct sysrq_key_op sysrq_xmon_op = 
-{
+static struct sysrq_key_op sysrq_xmon_op = {
 	.handler =	sysrq_handle_xmon,
 	.help_msg =	"Xmon",
 	.action_msg =	"Entering xmon",
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index dbe81a3..25b01b4 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -303,7 +303,7 @@ void arch_trigger_all_cpu_backtrace(void)
 
 #ifdef CONFIG_MAGIC_SYSRQ
 
-static void sysrq_handle_globreg(int key, struct tty_struct *tty)
+static void sysrq_handle_globreg(int key)
 {
 	arch_trigger_all_cpu_backtrace();
 }
diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index 878ac0c..a892a3c 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -76,7 +76,7 @@ static int __init sysrq_always_enabled_setup(char *str)
 __setup("sysrq_always_enabled", sysrq_always_enabled_setup);
 
 
-static void sysrq_handle_loglevel(int key, struct tty_struct *tty)
+static void sysrq_handle_loglevel(int key)
 {
 	int i;
 
@@ -93,7 +93,7 @@ static struct sysrq_key_op sysrq_loglevel_op = {
 };
 
 #ifdef CONFIG_VT
-static void sysrq_handle_SAK(int key, struct tty_struct *tty)
+static void sysrq_handle_SAK(int key)
 {
 	struct work_struct *SAK_work = &vc_cons[fg_console].SAK_work;
 	schedule_work(SAK_work);
@@ -109,7 +109,7 @@ static struct sysrq_key_op sysrq_SAK_op = {
 #endif
 
 #ifdef CONFIG_VT
-static void sysrq_handle_unraw(int key, struct tty_struct *tty)
+static void sysrq_handle_unraw(int key)
 {
 	struct kbd_struct *kbd = &kbd_table[fg_console];
 
@@ -126,7 +126,7 @@ static struct sysrq_key_op sysrq_unraw_op = {
 #define sysrq_unraw_op (*(struct sysrq_key_op *)NULL)
 #endif /* CONFIG_VT */
 
-static void sysrq_handle_crash(int key, struct tty_struct *tty)
+static void sysrq_handle_crash(int key)
 {
 	char *killer = NULL;
 
@@ -141,7 +141,7 @@ static struct sysrq_key_op sysrq_crash_op = {
 	.enable_mask	= SYSRQ_ENABLE_DUMP,
 };
 
-static void sysrq_handle_reboot(int key, struct tty_struct *tty)
+static void sysrq_handle_reboot(int key)
 {
 	lockdep_off();
 	local_irq_enable();
@@ -154,7 +154,7 @@ static struct sysrq_key_op sysrq_reboot_op = {
 	.enable_mask	= SYSRQ_ENABLE_BOOT,
 };
 
-static void sysrq_handle_sync(int key, struct tty_struct *tty)
+static void sysrq_handle_sync(int key)
 {
 	emergency_sync();
 }
@@ -165,7 +165,7 @@ static struct sysrq_key_op sysrq_sync_op = {
 	.enable_mask	= SYSRQ_ENABLE_SYNC,
 };
 
-static void sysrq_handle_show_timers(int key, struct tty_struct *tty)
+static void sysrq_handle_show_timers(int key)
 {
 	sysrq_timer_list_show();
 }
@@ -176,7 +176,7 @@ static struct sysrq_key_op sysrq_show_timers_op = {
 	.action_msg	= "Show clockevent devices & pending hrtimers (no others)",
 };
 
-static void sysrq_handle_mountro(int key, struct tty_struct *tty)
+static void sysrq_handle_mountro(int key)
 {
 	emergency_remount();
 }
@@ -188,7 +188,7 @@ static struct sysrq_key_op sysrq_mountro_op = {
 };
 
 #ifdef CONFIG_LOCKDEP
-static void sysrq_handle_showlocks(int key, struct tty_struct *tty)
+static void sysrq_handle_showlocks(int key)
 {
 	debug_show_all_locks();
 }
@@ -226,7 +226,7 @@ static void sysrq_showregs_othercpus(struct work_struct *dummy)
 
 static DECLARE_WORK(sysrq_showallcpus, sysrq_showregs_othercpus);
 
-static void sysrq_handle_showallcpus(int key, struct tty_struct *tty)
+static void sysrq_handle_showallcpus(int key)
 {
 	/*
 	 * Fall back to the workqueue based printing if the
@@ -252,7 +252,7 @@ static struct sysrq_key_op sysrq_showallcpus_op = {
 };
 #endif
 
-static void sysrq_handle_showregs(int key, struct tty_struct *tty)
+static void sysrq_handle_showregs(int key)
 {
 	struct pt_regs *regs = get_irq_regs();
 	if (regs)
@@ -266,7 +266,7 @@ static struct sysrq_key_op sysrq_showregs_op = {
 	.enable_mask	= SYSRQ_ENABLE_DUMP,
 };
 
-static void sysrq_handle_showstate(int key, struct tty_struct *tty)
+static void sysrq_handle_showstate(int key)
 {
 	show_state();
 }
@@ -277,7 +277,7 @@ static struct sysrq_key_op sysrq_showstate_op = {
 	.enable_mask	= SYSRQ_ENABLE_DUMP,
 };
 
-static void sysrq_handle_showstate_blocked(int key, struct tty_struct *tty)
+static void sysrq_handle_showstate_blocked(int key)
 {
 	show_state_filter(TASK_UNINTERRUPTIBLE);
 }
@@ -291,7 +291,7 @@ static struct sysrq_key_op sysrq_showstate_blocked_op = {
 #ifdef CONFIG_TRACING
 #include <linux/ftrace.h>
 
-static void sysrq_ftrace_dump(int key, struct tty_struct *tty)
+static void sysrq_ftrace_dump(int key)
 {
 	ftrace_dump(DUMP_ALL);
 }
@@ -305,7 +305,7 @@ static struct sysrq_key_op sysrq_ftrace_dump_op = {
 #define sysrq_ftrace_dump_op (*(struct sysrq_key_op *)NULL)
 #endif
 
-static void sysrq_handle_showmem(int key, struct tty_struct *tty)
+static void sysrq_handle_showmem(int key)
 {
 	show_mem();
 }
@@ -330,7 +330,7 @@ static void send_sig_all(int sig)
 	}
 }
 
-static void sysrq_handle_term(int key, struct tty_struct *tty)
+static void sysrq_handle_term(int key)
 {
 	send_sig_all(SIGTERM);
 	console_loglevel = 8;
@@ -349,7 +349,7 @@ static void moom_callback(struct work_struct *ignored)
 
 static DECLARE_WORK(moom_work, moom_callback);
 
-static void sysrq_handle_moom(int key, struct tty_struct *tty)
+static void sysrq_handle_moom(int key)
 {
 	schedule_work(&moom_work);
 }
@@ -361,7 +361,7 @@ static struct sysrq_key_op sysrq_moom_op = {
 };
 
 #ifdef CONFIG_BLOCK
-static void sysrq_handle_thaw(int key, struct tty_struct *tty)
+static void sysrq_handle_thaw(int key)
 {
 	emergency_thaw_all();
 }
@@ -373,7 +373,7 @@ static struct sysrq_key_op sysrq_thaw_op = {
 };
 #endif
 
-static void sysrq_handle_kill(int key, struct tty_struct *tty)
+static void sysrq_handle_kill(int key)
 {
 	send_sig_all(SIGKILL);
 	console_loglevel = 8;
@@ -385,7 +385,7 @@ static struct sysrq_key_op sysrq_kill_op = {
 	.enable_mask	= SYSRQ_ENABLE_SIGNAL,
 };
 
-static void sysrq_handle_unrt(int key, struct tty_struct *tty)
+static void sysrq_handle_unrt(int key)
 {
 	normalize_rt_tasks();
 }
@@ -520,7 +520,7 @@ void __handle_sysrq(int key, struct tty_struct *tty, int check_mask)
 		if (!check_mask || sysrq_on_mask(op_p->enable_mask)) {
 			printk("%s\n", op_p->action_msg);
 			console_loglevel = orig_log_level;
-			op_p->handler(key, tty);
+			op_p->handler(key);
 		} else {
 			printk("This sysrq operation is disabled.\n");
 		}
diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 7196620..9598ae7 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -295,7 +295,7 @@ static void drm_fb_helper_restore_work_fn(struct work_struct *ignored)
 }
 static DECLARE_WORK(drm_fb_helper_restore_work, drm_fb_helper_restore_work_fn);
 
-static void drm_fb_helper_sysrq(int dummy1, struct tty_struct *dummy3)
+static void drm_fb_helper_sysrq(int dummy1)
 {
 	schedule_work(&drm_fb_helper_restore_work);
 }
diff --git a/drivers/net/ibm_newemac/debug.c b/drivers/net/ibm_newemac/debug.c
index 3995faf..8c6c1e2 100644
--- a/drivers/net/ibm_newemac/debug.c
+++ b/drivers/net/ibm_newemac/debug.c
@@ -238,7 +238,7 @@ void emac_dbg_dump_all(void)
 }
 
 #if defined(CONFIG_MAGIC_SYSRQ)
-static void emac_sysrq_handler(int key, struct tty_struct *tty)
+static void emac_sysrq_handler(int key)
 {
 	emac_dbg_dump_all();
 }
diff --git a/include/linux/sysrq.h b/include/linux/sysrq.h
index 609e8ca..4ee6503 100644
--- a/include/linux/sysrq.h
+++ b/include/linux/sysrq.h
@@ -31,7 +31,7 @@ struct tty_struct;
 #define SYSRQ_ENABLE_RTNICE	0x0100
 
 struct sysrq_key_op {
-	void (*handler)(int, struct tty_struct *);
+	void (*handler)(int);
 	char *help_msg;
 	char *action_msg;
 	int enable_mask;
@@ -58,6 +58,10 @@ static inline void handle_sysrq(int key, struct tty_struct *tty)
 {
 }
 
+static inline void __handle_sysrq(int key, struct tty_struct *tty, int check_mask);
+{
+}
+
 static inline int register_sysrq_key(int key, struct sysrq_key_op *op)
 {
 	return -EINVAL;
diff --git a/kernel/power/poweroff.c b/kernel/power/poweroff.c
index e8b3370..d523593 100644
--- a/kernel/power/poweroff.c
+++ b/kernel/power/poweroff.c
@@ -24,7 +24,7 @@ static void do_poweroff(struct work_struct *dummy)
 
 static DECLARE_WORK(poweroff_work, do_poweroff);
 
-static void handle_poweroff(int key, struct tty_struct *tty)
+static void handle_poweroff(int key)
 {
 	/* run sysrq poweroff on boot cpu */
 	schedule_work_on(cpumask_first(cpu_online_mask), &poweroff_work);

