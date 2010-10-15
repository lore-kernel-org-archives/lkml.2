Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab0JOMnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 08:43:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:38199 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755411Ab0JOMne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 08:43:34 -0400
Message-ID: <4CB84C6E.5010401@kernel.org>
Date: Fri, 15 Oct 2010 14:43:26 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Karsten Keil <isdn@linux-pingi.de>, Armin Schindler <mac@melware.de>,
        lkml <linux-kernel@vger.kernel.org>, Jan Kiszka <jan.kiszka@web.de>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2.6.36-rc7 2/2] isdn/capi: make kcapi use a separate workqueue
References: <4CB84C4C.6040204@kernel.org>
In-Reply-To: <4CB84C4C.6040204@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Oct 2010 12:43:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flush_scheduled_work() is deprecated and will be removed.  Because
kcapi uses fire-and-forget type works, it's impossible to flush each
work explicitly.  Create and use a dedicated workqueue instead.

Please note that with recent workqueue changes, each workqueue doesn't
reserve a lot of resources and using it as a flush domain is fine.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/isdn/capi/kcapi.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

Index: work/drivers/isdn/capi/kcapi.c
===================================================================
--- work.orig/drivers/isdn/capi/kcapi.c
+++ work/drivers/isdn/capi/kcapi.c
@@ -38,6 +38,7 @@
 #include <linux/rcupdate.h>

 static int showcapimsgs = 0;
+static struct workqueue_struct *kcapi_wq;

 MODULE_DESCRIPTION("CAPI4Linux: kernel CAPI layer");
 MODULE_AUTHOR("Carsten Paeth");
@@ -282,7 +283,7 @@ static int notify_push(unsigned int even
 	event->type = event_type;
 	event->controller = controller;

-	schedule_work(&event->work);
+	queue_work(kcapi_wq, &event->work);
 	return 0;
 }

@@ -399,7 +400,7 @@ void capi_ctr_handle_message(struct capi
 		goto error;
 	}
 	skb_queue_tail(&ap->recv_queue, skb);
-	schedule_work(&ap->recv_work);
+	queue_work(kcapi_wq, &ap->recv_work);
 	rcu_read_unlock();

 	return;
@@ -734,7 +735,7 @@ u16 capi20_release(struct capi20_appl *a

 	mutex_unlock(&capi_controller_lock);

-	flush_scheduled_work();
+	flush_workqueue(kcapi_wq);
 	skb_queue_purge(&ap->recv_queue);

 	if (showcapimsgs & 1) {
@@ -1276,21 +1277,30 @@ static int __init kcapi_init(void)
 {
 	int err;

+	kcapi_wq = alloc_workqueue("kcapi", 0, 0);
+	if (!kcapi_wq)
+		return -ENOMEM;
+
 	register_capictr_notifier(&capictr_nb);

 	err = cdebug_init();
-	if (!err)
-		kcapi_proc_init();
-	return err;
+	if (err) {
+		unregister_capictr_notifier(&capictr_nb);
+		destroy_workqueue(kcapi_wq);
+		return err;
+	}
+
+	kcapi_proc_init();
+	return 0;
 }

 static void __exit kcapi_exit(void)
 {
         kcapi_proc_exit();

-	/* make sure all notifiers are finished */
-	flush_scheduled_work();
+	unregister_capictr_notifier(&capictr_nb);
 	cdebug_exit();
+	destroy_workqueue(kcapi_wq);
 }

 module_init(kcapi_init);
