Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759890Ab0KRQP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:15:28 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:36032 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759328Ab0KRQMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:12:34 -0500
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: "Nikita V\. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>,
        Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCHv4 04/17] pps: unify timestamp gathering
Date: Thu, 18 Nov 2010 19:00:57 +0300
Message-Id: <b33bb22de561f56a18d7d4e72e6db4806bcb0377.1290087477.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a helper function to gather timestamps. This way clients don't have
to duplicate it.

Acked-by: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
---
 drivers/pps/clients/pps-ktimer.c |    9 ++-------
 drivers/pps/clients/pps-ldisc.c  |   18 ++++++------------
 drivers/pps/kapi.c               |   19 ++++++++++++-------
 include/linux/pps_kernel.h       |   19 ++++++++++++++++++-
 include/linux/serial_core.h      |    5 +++--
 include/linux/tty_ldisc.h        |    5 +++--
 6 files changed, 44 insertions(+), 31 deletions(-)

diff --git a/drivers/pps/clients/pps-ktimer.c b/drivers/pps/clients/pps-ktimer.c
index e7ef5b8..e1bdd8b 100644
--- a/drivers/pps/clients/pps-ktimer.c
+++ b/drivers/pps/clients/pps-ktimer.c
@@ -40,18 +40,13 @@ static struct timer_list ktimer;
 
 static void pps_ktimer_event(unsigned long ptr)
 {
-	struct timespec __ts;
-	struct pps_ktime ts;
+	struct pps_event_time ts;
 
 	/* First of all we get the time stamp... */
-	getnstimeofday(&__ts);
+	pps_get_ts(&ts);
 
 	pr_info("PPS event at %lu\n", jiffies);
 
-	/* ... and translate it to PPS time data struct */
-	ts.sec = __ts.tv_sec;
-	ts.nsec = __ts.tv_nsec;
-
 	pps_event(source, &ts, PPS_CAPTUREASSERT, NULL);
 
 	mod_timer(&ktimer, jiffies + HZ);
diff --git a/drivers/pps/clients/pps-ldisc.c b/drivers/pps/clients/pps-ldisc.c
index 8e1932d..20fc9f7 100644
--- a/drivers/pps/clients/pps-ldisc.c
+++ b/drivers/pps/clients/pps-ldisc.c
@@ -27,26 +27,20 @@
 #define PPS_TTY_MAGIC		0x0001
 
 static void pps_tty_dcd_change(struct tty_struct *tty, unsigned int status,
-				struct timespec *ts)
+				struct pps_event_time *ts)
 {
 	int id = (long)tty->disc_data;
-	struct timespec __ts;
-	struct pps_ktime pps_ts;
+	struct pps_event_time __ts;
 
 	/* First of all we get the time stamp... */
-	getnstimeofday(&__ts);
+	pps_get_ts(&__ts);
 
 	/* Does caller give us a timestamp? */
-	if (ts) {	/* Yes. Let's use it! */
-		pps_ts.sec = ts->tv_sec;
-		pps_ts.nsec = ts->tv_nsec;
-	} else {	/* No. Do it ourself! */
-		pps_ts.sec = __ts.tv_sec;
-		pps_ts.nsec = __ts.tv_nsec;
-	}
+	if (!ts)	/* No. Do it ourself! */
+		ts = &__ts;
 
 	/* Now do the PPS event report */
-	pps_event(id, &pps_ts, status ? PPS_CAPTUREASSERT : PPS_CAPTURECLEAR,
+	pps_event(id, ts, status ? PPS_CAPTUREASSERT : PPS_CAPTURECLEAR,
 			NULL);
 
 	pr_debug("PPS %s at %lu on source #%d\n",
diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
index 3f89f5eb..b431d83 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -268,11 +268,12 @@ EXPORT_SYMBOL(pps_unregister_source);
  *	pps->info.echo(source, event, data);
  */
 
-void pps_event(int source, struct pps_ktime *ts, int event, void *data)
+void pps_event(int source, struct pps_event_time *ts, int event, void *data)
 {
 	struct pps_device *pps;
 	unsigned long flags;
 	int captured = 0;
+	struct pps_ktime ts_real;
 
 	if ((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) == 0) {
 		printk(KERN_ERR "pps: unknown event (%x) for source %d\n",
@@ -284,8 +285,10 @@ void pps_event(int source, struct pps_ktime *ts, int event, void *data)
 	if (!pps)
 		return;
 
-	pr_debug("PPS event on source %d at %llu.%06u\n",
-			pps->id, (unsigned long long) ts->sec, ts->nsec);
+	pr_debug("PPS event on source %d at %ld.%09ld\n",
+			pps->id, ts->ts_real.tv_sec, ts->ts_real.tv_nsec);
+
+	timespec_to_pps_ktime(&ts_real, ts->ts_real);
 
 	spin_lock_irqsave(&pps->lock, flags);
 
@@ -299,10 +302,11 @@ void pps_event(int source, struct pps_ktime *ts, int event, void *data)
 			(pps->params.mode & PPS_CAPTUREASSERT)) {
 		/* We have to add an offset? */
 		if (pps->params.mode & PPS_OFFSETASSERT)
-			pps_add_offset(ts, &pps->params.assert_off_tu);
+			pps_add_offset(&ts_real,
+					&pps->params.assert_off_tu);
 
 		/* Save the time stamp */
-		pps->assert_tu = *ts;
+		pps->assert_tu = ts_real;
 		pps->assert_sequence++;
 		pr_debug("capture assert seq #%u for source %d\n",
 			pps->assert_sequence, source);
@@ -313,10 +317,11 @@ void pps_event(int source, struct pps_ktime *ts, int event, void *data)
 			(pps->params.mode & PPS_CAPTURECLEAR)) {
 		/* We have to add an offset? */
 		if (pps->params.mode & PPS_OFFSETCLEAR)
-			pps_add_offset(ts, &pps->params.clear_off_tu);
+			pps_add_offset(&ts_real,
+					&pps->params.clear_off_tu);
 
 		/* Save the time stamp */
-		pps->clear_tu = *ts;
+		pps->clear_tu = ts_real;
 		pps->clear_sequence++;
 		pr_debug("capture clear seq #%u for source %d\n",
 			pps->clear_sequence, source);
diff --git a/include/linux/pps_kernel.h b/include/linux/pps_kernel.h
index c3aed4b..32aa676 100644
--- a/include/linux/pps_kernel.h
+++ b/include/linux/pps_kernel.h
@@ -43,6 +43,10 @@ struct pps_source_info {
 	struct device *dev;
 };
 
+struct pps_event_time {
+	struct timespec ts_real;
+};
+
 /* The main struct */
 struct pps_device {
 	struct pps_source_info info;		/* PSS source info */
@@ -88,7 +92,20 @@ extern int pps_register_source(struct pps_source_info *info,
 extern void pps_unregister_source(int source);
 extern int pps_register_cdev(struct pps_device *pps);
 extern void pps_unregister_cdev(struct pps_device *pps);
-extern void pps_event(int source, struct pps_ktime *ts, int event, void *data);
+extern void pps_event(int source, struct pps_event_time *ts, int event,
+		void *data);
+
+static inline void timespec_to_pps_ktime(struct pps_ktime *kt,
+		struct timespec ts)
+{
+	kt->sec = ts.tv_sec;
+	kt->nsec = ts.tv_nsec;
+}
+
+static inline void pps_get_ts(struct pps_event_time *ts)
+{
+	getnstimeofday(&ts->ts_real);
+}
 
 #endif /* LINUX_PPS_KERNEL_H */
 
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 563e234..55c8192 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -206,6 +206,7 @@
 #include <linux/tty.h>
 #include <linux/mutex.h>
 #include <linux/sysrq.h>
+#include <linux/pps_kernel.h>
 
 struct uart_port;
 struct serial_struct;
@@ -510,10 +511,10 @@ uart_handle_dcd_change(struct uart_port *uport, unsigned int status)
 	struct uart_state *state = uport->state;
 	struct tty_port *port = &state->port;
 	struct tty_ldisc *ld = tty_ldisc_ref(port->tty);
-	struct timespec ts;
+	struct pps_event_time ts;
 
 	if (ld && ld->ops->dcd_change)
-		getnstimeofday(&ts);
+		pps_get_ts(&ts);
 
 	uport->icount.dcd++;
 #ifdef CONFIG_HARD_PPS
diff --git a/include/linux/tty_ldisc.h b/include/linux/tty_ldisc.h
index 526d66f..763e061 100644
--- a/include/linux/tty_ldisc.h
+++ b/include/linux/tty_ldisc.h
@@ -101,7 +101,7 @@
  *	any pending driver I/O is completed.
  *
  * void (*dcd_change)(struct tty_struct *tty, unsigned int status,
- * 			struct timespec *ts)
+ *			struct pps_event_time *ts)
  *
  *	Tells the discipline that the DCD pin has changed its status and
  *	the relative timestamp. Pointer ts can be NULL.
@@ -109,6 +109,7 @@
 
 #include <linux/fs.h>
 #include <linux/wait.h>
+#include <linux/pps_kernel.h>
 
 struct tty_ldisc_ops {
 	int	magic;
@@ -143,7 +144,7 @@ struct tty_ldisc_ops {
 			       char *fp, int count);
 	void	(*write_wakeup)(struct tty_struct *);
 	void	(*dcd_change)(struct tty_struct *, unsigned int,
-				struct timespec *);
+				struct pps_event_time *);
 
 	struct  module *owner;
 	
-- 
1.7.2.3

