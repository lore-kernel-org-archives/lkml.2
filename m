Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab2CCULp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 15:11:45 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53496 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab2CCULo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 15:11:44 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of chunkeey@googlemail.com designates 10.213.3.196 as permitted sender) smtp.mail=chunkeey@googlemail.com; dkim=pass header.i=chunkeey@googlemail.com
Subject: [PATCH 2/6] pcmcia: move unbind/rebind into dev_pm_ops.complete
Cc: linux-kernel@vger.kernel.org, chunkeey@googlemail.com
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-pcmcia@lists.infradead.org
Date: Sat, 3 Mar 2012 21:11:29 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201203032111.29558.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idea of moving rebind procedure into pm.complete
was taken from the usb-subsystem, which has similar
problems with reattaching devices during/after
resume.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
Note: I'm not on the list; please keep the 'CC' if you have
something to say :).

Regards,
	Chr
---
 drivers/pcmcia/cs.c |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/pcmcia/cs.c b/drivers/pcmcia/cs.c
index d9ea192..503596f 100644
--- a/drivers/pcmcia/cs.c
+++ b/drivers/pcmcia/cs.c
@@ -512,6 +512,13 @@ static int socket_late_resume(struct pcmcia_socket *skt)
 		return socket_insert(skt);
 	}
 
+	if (!(skt->state & SOCKET_CARDBUS) && (skt->callback))
+		skt->callback->early_resume(skt);
+	return 0;
+}
+
+static int socket_complete_resume(struct pcmcia_socket *skt)
+{
 #ifdef CONFIG_CARDBUS
 	if (skt->state & SOCKET_CARDBUS) {
 		/* We can't be sure the CardBus card is the same
@@ -519,11 +526,8 @@ static int socket_late_resume(struct pcmcia_socket *skt)
 		 * and re-add... */
 		cb_free(skt);
 		cb_alloc(skt);
-		return 0;
 	}
 #endif
-	if (!(skt->state & SOCKET_CARDBUS) && (skt->callback))
-		skt->callback->early_resume(skt);
 	return 0;
 }
 
@@ -534,11 +538,15 @@ static int socket_late_resume(struct pcmcia_socket *skt)
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
+		socket_complete_resume(skt);
+	return err;
 }
 
 static void socket_remove(struct pcmcia_socket *skt)
@@ -849,6 +857,11 @@ static int __used pcmcia_socket_dev_resume(struct device *dev)
 	return __pcmcia_pm_op(dev, socket_late_resume);
 }
 
+static void __used pcmcia_socket_dev_complete(struct device *dev)
+{
+	__pcmcia_pm_op(dev, socket_complete_resume);
+}
+
 static const struct dev_pm_ops pcmcia_socket_pm_ops = {
 	/* dev_resume may be called with IRQs enabled */
 	SET_SYSTEM_SLEEP_PM_OPS(NULL,
@@ -863,6 +876,7 @@ static const struct dev_pm_ops pcmcia_socket_pm_ops = {
 	.resume_noirq = pcmcia_socket_dev_resume_noirq,
 	.thaw_noirq = pcmcia_socket_dev_resume_noirq,
 	.restore_noirq = pcmcia_socket_dev_resume_noirq,
+	.complete = pcmcia_socket_dev_complete,
 };
 
 #define PCMCIA_SOCKET_CLASS_PM_OPS (&pcmcia_socket_pm_ops)
-- 
1.7.9.1

