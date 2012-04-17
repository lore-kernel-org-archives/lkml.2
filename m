Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab2DQUhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 16:37:32 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246Ab2DQUhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 16:37:31 -0400
From: Richard Weinberger <richard@nod.at>
To: user-mode-linux-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/4] um: Implement um_free_irq()
Date: Tue, 17 Apr 2012 22:37:13 +0200
Message-Id: <1334695036-19977-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using chip->release() we can achieve the same
using a simple wrapper for free_irq().
We have already um_request_irq(), so um_free_irq() is the perfect
counterpart.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/drivers/chan_kern.c       |    9 +++++----
 arch/um/drivers/line.c            |    2 +-
 arch/um/drivers/net_kern.c        |    4 ++--
 arch/um/drivers/port_kern.c       |    2 +-
 arch/um/drivers/xterm_kern.c      |    2 +-
 arch/um/include/shared/irq_kern.h |    2 +-
 arch/um/kernel/irq.c              |    7 +++++++
 7 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/arch/um/drivers/chan_kern.c b/arch/um/drivers/chan_kern.c
index ca4c7eb..45e248c 100644
--- a/arch/um/drivers/chan_kern.c
+++ b/arch/um/drivers/chan_kern.c
@@ -8,6 +8,7 @@
 #include <linux/tty_flip.h>
 #include "chan.h"
 #include "os.h"
+#include "irq_kern.h"
 
 #ifdef CONFIG_NOCONFIG_CHAN
 static void *not_configged_init(char *str, int device,
@@ -213,9 +214,9 @@ void free_irqs(void)
 		chan = list_entry(ele, struct chan, free_list);
 
 		if (chan->input && chan->enabled)
-			free_irq(chan->line->driver->read_irq, chan);
+			um_free_irq(chan->line->driver->read_irq, chan);
 		if (chan->output && chan->enabled)
-			free_irq(chan->line->driver->write_irq, chan);
+			um_free_irq(chan->line->driver->write_irq, chan);
 		chan->enabled = 0;
 	}
 }
@@ -234,9 +235,9 @@ static void close_one_chan(struct chan *chan, int delay_free_irq)
 	}
 	else {
 		if (chan->input && chan->enabled)
-			free_irq(chan->line->driver->read_irq, chan);
+			um_free_irq(chan->line->driver->read_irq, chan);
 		if (chan->output && chan->enabled)
-			free_irq(chan->line->driver->write_irq, chan);
+			um_free_irq(chan->line->driver->write_irq, chan);
 		chan->enabled = 0;
 	}
 	if (chan->ops->close != NULL)
diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index 4ab0d9c..acfd0e0 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -699,7 +699,7 @@ struct winch {
 static void __free_winch(struct work_struct *work)
 {
 	struct winch *winch = container_of(work, struct winch, work);
-	free_irq(WINCH_IRQ, winch);
+	um_free_irq(WINCH_IRQ, winch);
 
 	if (winch->pid != -1)
 		os_kill_process(winch->pid, 1);
diff --git a/arch/um/drivers/net_kern.c b/arch/um/drivers/net_kern.c
index 95f4416..0d60c56 100644
--- a/arch/um/drivers/net_kern.c
+++ b/arch/um/drivers/net_kern.c
@@ -195,7 +195,7 @@ static int uml_net_close(struct net_device *dev)
 
 	netif_stop_queue(dev);
 
-	free_irq(dev->irq, dev);
+	um_free_irq(dev->irq, dev);
 	if (lp->close != NULL)
 		(*lp->close)(lp->fd, &lp->user);
 	lp->fd = -1;
@@ -835,7 +835,7 @@ static void close_devices(void)
 	spin_lock(&opened_lock);
 	list_for_each(ele, &opened) {
 		lp = list_entry(ele, struct uml_net_private, list);
-		free_irq(lp->dev->irq, lp->dev);
+		um_free_irq(lp->dev->irq, lp->dev);
 		if ((lp->close != NULL) && (lp->fd >= 0))
 			(*lp->close)(lp->fd, &lp->user);
 		if (lp->remove != NULL)
diff --git a/arch/um/drivers/port_kern.c b/arch/um/drivers/port_kern.c
index e31680e..11866ff 100644
--- a/arch/um/drivers/port_kern.c
+++ b/arch/um/drivers/port_kern.c
@@ -254,7 +254,7 @@ int port_wait(void *data)
 		 * connection.  Then we loop here throwing out failed
 		 * connections until a good one is found.
 		 */
-		free_irq(TELNETD_IRQ, conn);
+		um_free_irq(TELNETD_IRQ, conn);
 
 		if (conn->fd >= 0)
 			break;
diff --git a/arch/um/drivers/xterm_kern.c b/arch/um/drivers/xterm_kern.c
index 8bd130f..b68bbe2 100644
--- a/arch/um/drivers/xterm_kern.c
+++ b/arch/um/drivers/xterm_kern.c
@@ -65,7 +65,7 @@ int xterm_fd(int socket, int *pid_out)
 	 * isn't set) this will hang... */
 	wait_for_completion(&data->ready);
 
-	free_irq(XTERM_IRQ, data);
+	um_free_irq(XTERM_IRQ, data);
 
 	ret = data->new_fd;
 	*pid_out = data->pid;
diff --git a/arch/um/include/shared/irq_kern.h b/arch/um/include/shared/irq_kern.h
index b05d22f..7a5bfa6 100644
--- a/arch/um/include/shared/irq_kern.h
+++ b/arch/um/include/shared/irq_kern.h
@@ -13,6 +13,6 @@ extern int um_request_irq(unsigned int irq, int fd, int type,
 			  irq_handler_t handler,
 			  unsigned long irqflags,  const char * devname,
 			  void *dev_id);
-
+void um_free_irq(unsigned int irq, void *dev);
 #endif
 
diff --git a/arch/um/kernel/irq.c b/arch/um/kernel/irq.c
index 71b8c94..47a09ee 100644
--- a/arch/um/kernel/irq.c
+++ b/arch/um/kernel/irq.c
@@ -297,6 +297,13 @@ unsigned int do_IRQ(int irq, struct uml_pt_regs *regs)
 	return 1;
 }
 
+void um_free_irq(unsigned int irq, void *dev)
+{
+	free_irq_by_irq_and_dev(irq, dev);
+	free_irq(irq, dev);
+}
+EXPORT_SYMBOL(um_free_irq);
+
 int um_request_irq(unsigned int irq, int fd, int type,
 		   irq_handler_t handler,
 		   unsigned long irqflags, const char * devname,
-- 
1.7.7.3

