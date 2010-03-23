Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608Ab0CWKau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 06:30:50 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:37444 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab0CWKas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 06:30:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=b4UvzsnPhnFzTb72HlRaLMCv0pFMpOH9+tiEahZEGa5VlcgB83N2ueRZHZlqP74vHx
         E/McZ5P/G8PzK9rjuaWzDKf8Javs3PZ6KUuwC5SuO5ZXVlwi3LiBisaFm+cN0mIG37fS
         zaJWTVYQPZCqN2iKj1LTgw+SdiBpXfUXIWPE4=
From: Christian Pellegrin <chripell@fsfe.org>
To: feng.tang@intel.com, akpm@linux-foundation.org, greg@kroah.com,
       david-b@pacbell.net, grant.likely@secretlab.ca,
       alan@lxorguk.ukuu.org.uk, spi-devel-general@lists.sourceforge.net,
       linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christian Pellegrin <chripell@fsfe.org>
Subject: [PATCH v1 1/4] max3100: added raise_threaded_irq
Date: Tue, 23 Mar 2010 11:28:25 +0100
Message-Id: <1269340105-6503-1-git-send-email-chripell@fsfe.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <cabda6421003230329w3fe596dbn8e4b37cc36118f9f@mail.gmail.com>
References: <cabda6421003230329w3fe596dbn8e4b37cc36118f9f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

raise_threaded_irq schedules the execution of an interrupt thread

Signed-off-by: Christian Pellegrin <chripell@fsfe.org>
---
 include/linux/interrupt.h |    3 +++
 kernel/irq/manage.c       |   27 +++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 75f3f00..14c0c13 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -144,6 +144,9 @@ request_threaded_irq(unsigned int irq, irq_handler_t handler,
 static inline void exit_irq_thread(void) { }
 #endif
 
+extern int raise_threaded_irq(unsigned int irq);
+
+
 extern void free_irq(unsigned int, void *);
 
 struct device;
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index eb6078c..a7d21e0 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1088,3 +1088,30 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 	return retval;
 }
 EXPORT_SYMBOL(request_threaded_irq);
+
+/**
+ *	raise_threaded_irq - triggers a threded interrupt
+ *	@irq: Interrupt line to trigger
+ */
+int raise_threaded_irq(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct irqaction *action;
+
+	if (!desc)
+		return -ENOENT;
+	action = desc->action;
+	if (!action)
+		return -ENOENT;
+	if (unlikely(!action->thread_fn))
+		return -EINVAL;
+	if (likely(!test_bit(IRQTF_DIED,
+			     &action->thread_flags))) {
+		set_bit(IRQTF_RUNTHREAD, &action->thread_flags);
+		wake_up_process(action->thread);
+	} else {
+		return -ECHILD;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(raise_threaded_irq);
-- 
1.5.6.5

