Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133Ab2GUXP2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 19:15:28 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:55723 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab2GUXP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 19:15:26 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-pcmcia@lists.infradead.org
Subject: [PATCH v2] pcmcia: move unbind/rebind into dev_pm_ops.complete
Date: Sun, 22 Jul 2012 01:15:20 +0200
User-Agent: KMail/1.13.7 (Linux/3.5.0-rc7-wl; KDE/4.8.4; x86_64; ; )
Cc: stern@rowland.harvard.edu, Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
References: <201207100119.25214.chunkeey@googlemail.com>
In-Reply-To: <201207100119.25214.chunkeey@googlemail.com>
MIME-Version: 1.0
X-Length: 5279
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207220115.21062.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the device rebind procedures
for cardbus devices from the pm.resume into the
pm.complete callback.

The reasons for moving the code is:"
[...] The PM code needs to send suspend and resume
messages to every device in the right order, and it
can't do that if new devices are being added at the
same time. [...]

However the situation really isn't quite that rigid.
In particular, adding new children during a resume
callback shouldn't cause much of problem because
the children don't need to be resumed anyway (since
they were never suspended).  On the other hand, if
you do it you will get a dev_warn() from the PM
core, something like 'parent should not be sleeping'.

Still, it is considered bad form and should be avoided
if possible."

(Alan Stern's full comment about the topic can
be found here: <https://lkml.org/lkml/2012/7/10/254>)

Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
I think I left everyone enough of a chance to
reply and/or file complains.

The change from v1 is mainly the updated change log
and I hope it now sufficiently explains why a patch
like this is needed (Of course, if any of you have
an alternative suggestion, then please let's hear it!).

Note: It would be nice to know what the patch
does for older (not cardbus) cards in the
suspend/resume case. So, if you got a machine
and the hardware, please let us/me know if it
works or causes crash/boom and bangs.

PS: I'm not on the pcmcia/kernel list, so please
keep my address in the 'CC' at all times.

Regards,
	Christian
---
diff --git a/drivers/pcmcia/cs.c b/drivers/pcmcia/cs.c
index 673c14e..18fb100 100644
--- a/drivers/pcmcia/cs.c
+++ b/drivers/pcmcia/cs.c
@@ -484,7 +484,7 @@ static int socket_early_resume(struct pcmcia_socket *skt)
 
 static int socket_late_resume(struct pcmcia_socket *skt)
 {
-	int ret;
+	int ret = 0;
 
 	mutex_lock(&skt->ops_mutex);
 	skt->state &= ~SOCKET_SUSPEND;
@@ -511,19 +511,31 @@ static int socket_late_resume(struct pcmcia_socket *skt)
 		return socket_insert(skt);
 	}
 
+	if (!(skt->state & SOCKET_CARDBUS) && (skt->callback))
+		ret = skt->callback->early_resume(skt);
+	return ret;
+}
+
+/*
+ * Finalize the resume. In case of a cardbus socket, we have
+ * to rebind the devices as we can't be certain that it has been
+ * replaced, or not.
+ */
+static int socket_complete_resume(struct pcmcia_socket *skt)
+{
+	int ret = 0;
 #ifdef CONFIG_CARDBUS
 	if (skt->state & SOCKET_CARDBUS) {
 		/* We can't be sure the CardBus card is the same
 		 * as the one previously inserted. Therefore, remove
 		 * and re-add... */
 		cb_free(skt);
-		cb_alloc(skt);
-		return 0;
+		ret = cb_alloc(skt);
+		if (ret)
+			cb_free(skt);
 	}
 #endif
-	if (!(skt->state & SOCKET_CARDBUS) && (skt->callback))
-		skt->callback->early_resume(skt);
-	return 0;
+	return ret;
 }
 
 /*
@@ -533,11 +545,15 @@ static int socket_late_resume(struct pcmcia_socket *skt)
  */
 static int socket_resume(struct pcmcia_socket *skt)
 {
+	int err;
 	if (!(skt->state & SOCKET_SUSPEND))
 		return -EBUSY;
 
 	socket_early_resume(skt);
-	return socket_late_resume(skt);
+	err = socket_late_resume(skt);
+	if (!err)
+		err = socket_complete_resume(skt);
+	return err;
 }
 
 static void socket_remove(struct pcmcia_socket *skt)
@@ -848,6 +864,12 @@ static int __used pcmcia_socket_dev_resume(struct device *dev)
 	return __pcmcia_pm_op(dev, socket_late_resume);
 }
 
+static void __used pcmcia_socket_dev_complete(struct device *dev)
+{
+	WARN(__pcmcia_pm_op(dev, socket_complete_resume),
+		"failed to complete resume");
+}
+
 static const struct dev_pm_ops pcmcia_socket_pm_ops = {
 	/* dev_resume may be called with IRQs enabled */
 	SET_SYSTEM_SLEEP_PM_OPS(NULL,
@@ -862,6 +884,7 @@ static const struct dev_pm_ops pcmcia_socket_pm_ops = {
 	.resume_noirq = pcmcia_socket_dev_resume_noirq,
 	.thaw_noirq = pcmcia_socket_dev_resume_noirq,
 	.restore_noirq = pcmcia_socket_dev_resume_noirq,
+	.complete = pcmcia_socket_dev_complete,
 };
 
 #define PCMCIA_SOCKET_CLASS_PM_OPS (&pcmcia_socket_pm_ops)
