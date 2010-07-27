Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab0G0MBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 08:01:33 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59116 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab0G0MBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 08:01:32 -0400
Date: Tue, 27 Jul 2010 07:57:54 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Xiaotian Feng <dfeng@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH] sysrq: don't hold the sysrq_key_table_lock during
 the handler
Message-ID: <20100727115754.GC6303@hmsreliant.think-freely.org>
References: <1280138042-1576-1-git-send-email-dfeng@redhat.com>
 <20100726105148.GB14198@hmsreliant.think-freely.org>
 <20100726174153.GD14609@core.coreip.homeip.net>
 <20100726203420.GB18789@hmsreliant.think-freely.org>
 <20100727081552.GB32084@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100727081552.GB32084@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 01:15:52AM -0700, Dmitry Torokhov wrote:
> On Mon, Jul 26, 2010 at 04:34:20PM -0400, Neil Horman wrote:
> > On Mon, Jul 26, 2010 at 10:41:54AM -0700, Dmitry Torokhov wrote:
> > > On Mon, Jul 26, 2010 at 06:51:48AM -0400, Neil Horman wrote:
> > > > On Mon, Jul 26, 2010 at 05:54:02PM +0800, Xiaotian Feng wrote:
> > > > <snip>
> > > > 
> > > > This creates the possibility of a race in the handler.  Not that it happens
> > > > often, but sysrq keys can be registered and unregistered dynamically.  If that
> > > > lock isn't held while we call the keys handler, the code implementing that
> > > > handler can live in a module that gets removed while its executing, leading to
> > > > an oops, etc.  I think the better solution would be to use an rcu lock here.
> > > 
> > > I'd simply changed spinlock to a mutex.
> > > 
> > I don't think you can do that safely in this path, as sysrqs will be looked up
> > in both process (echo t > /proc/sysrq-trigger) context and in interrupt
> > (alt-sysrq-t) context.  If a mutex is locked and you try to take it in interrupt
> > context, you get a sleeping-in-interrupt panic IIRC
> > 
> 
> Yes, indeed. But then even RCU will not really help us since keyboard
> driver will have inpterrupts disabled anyways.
> 

Hm, thats true.  I suppose the right thing to do then is grab a reference on any
sysrq implemented within code that might be considered transient before
releasing the lock.  I've not tested this patch out, but it should do what we
need, in that it allows us to release the lock without having to worry about the
op list changing underneath us, or having the module with the handler code
dissappear

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>



 arch/arm/kernel/etm.c           |    1 +
 arch/powerpc/xmon/xmon.c        |    1 +
 arch/sparc/kernel/process_64.c  |    1 +
 drivers/char/sysrq.c            |   19 ++++++++++++++++++-
 drivers/gpu/drm/drm_fb_helper.c |    1 +
 drivers/net/ibm_newemac/debug.c |    1 +
 include/linux/sysrq.h           |    1 +
 kernel/debug/debug_core.c       |    1 +
 kernel/power/poweroff.c         |    1 +
 9 files changed, 26 insertions(+), 1 deletion(-)


diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index 8277539..fb7c393 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -240,6 +240,7 @@ static struct sysrq_key_op sysrq_etm_op = {
 	.handler = sysrq_etm_dump,
 	.help_msg = "ETM buffer dump",
 	.action_msg = "etm",
+	.module = THIS_MODULE,
 };
 
 static int etb_open(struct inode *inode, struct file *file)
diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index 8bad7d5..b9b7aee 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -2740,6 +2740,7 @@ static struct sysrq_key_op sysrq_xmon_op =
 	.handler =	sysrq_handle_xmon,
 	.help_msg =	"Xmon",
 	.action_msg =	"Entering xmon",
+	.module =	THIS_MODULE,
 };
 
 static int __init setup_xmon_sysrq(void)
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index dbe81a3..f5a2efc 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -312,6 +312,7 @@ static struct sysrq_key_op sparc_globalreg_op = {
 	.handler	= sysrq_handle_globreg,
 	.help_msg	= "Globalregs",
 	.action_msg	= "Show Global CPU Regs",
+	.module		= THIS_MODULE,
 };
 
 static int __init sparc_globreg_init(void)
diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index 878ac0c..3dd4034 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -520,7 +520,24 @@ void __handle_sysrq(int key, struct tty_struct *tty, int check_mask)
 		if (!check_mask || sysrq_on_mask(op_p->enable_mask)) {
 			printk("%s\n", op_p->action_msg);
 			console_loglevel = orig_log_level;
-			op_p->handler(key, tty);
+
+			/*
+			 * We want to run the handler any time we can get
+			 * a reference on the module, or anytime we don't
+			 * have any module to get.  In both of these cases
+			 * its safe to do a module_put, as NULLS are skipped
+			 * there.
+			 */
+			if ((try_module_get(op_p->module) == 0) ||
+			    (!op_p->module)) {
+				spin_unlock_irqrestore(&sysrq_key_table_lock,
+						       flags);
+				op_p->handler(key, tty);
+				module_put(op_p->module);
+			} else
+				printk("Could not lock this sysrq key\n");
+
+			return;
 		} else {
 			printk("This sysrq operation is disabled.\n");
 		}
diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 7196620..623e701 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -304,6 +304,7 @@ static struct sysrq_key_op sysrq_drm_fb_helper_restore_op = {
 	.handler = drm_fb_helper_sysrq,
 	.help_msg = "force-fb(V)",
 	.action_msg = "Restore framebuffer console",
+	.module	= THIS_MODULE,
 };
 #else
 static struct sysrq_key_op sysrq_drm_fb_helper_restore_op = { };
diff --git a/drivers/net/ibm_newemac/debug.c b/drivers/net/ibm_newemac/debug.c
index 3995faf..b82aa35 100644
--- a/drivers/net/ibm_newemac/debug.c
+++ b/drivers/net/ibm_newemac/debug.c
@@ -247,6 +247,7 @@ static struct sysrq_key_op emac_sysrq_op = {
 	.handler = emac_sysrq_handler,
 	.help_msg = "emaC",
 	.action_msg = "Show EMAC(s) status",
+	.module	= THIS_MODULE,
 };
 
 int __init emac_init_debug(void)
diff --git a/include/linux/sysrq.h b/include/linux/sysrq.h
index 609e8ca..4f219de 100644
--- a/include/linux/sysrq.h
+++ b/include/linux/sysrq.h
@@ -35,6 +35,7 @@ struct sysrq_key_op {
 	char *help_msg;
 	char *action_msg;
 	int enable_mask;
+	struct module *module;
 };
 
 #ifdef CONFIG_MAGIC_SYSRQ
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 8bc5eef..6b64063 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -761,6 +761,7 @@ static struct sysrq_key_op sysrq_dbg_op = {
 	.handler	= sysrq_handle_dbg,
 	.help_msg	= "debug(G)",
 	.action_msg	= "DEBUG",
+	.module		= THIS_MODULE,
 };
 #endif
 
diff --git a/kernel/power/poweroff.c b/kernel/power/poweroff.c
index e8b3370..58df039 100644
--- a/kernel/power/poweroff.c
+++ b/kernel/power/poweroff.c
@@ -35,6 +35,7 @@ static struct sysrq_key_op	sysrq_poweroff_op = {
 	.help_msg       = "powerOff",
 	.action_msg     = "Power Off",
 	.enable_mask	= SYSRQ_ENABLE_BOOT,
+	.module		= THIS_MODULE,
 };
 
 static int pm_sysrq_init(void)

> -- 
> Dmitry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
