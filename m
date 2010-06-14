Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088Ab0FNWVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 18:21:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46343 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063Ab0FNWVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 18:21:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=WjbBzpih+EJ46UHiDjCZ2GNc/Xzp7naDQi5Cd6MQOE+9tGCbfqvThuRHns4s/lbpii
         /u3It7zdZbJFDaEtTYlAabNZogNZoowDNGh8S0ay5LWMUB71NbQsIH0fUpz6ZFkMwM9Y
         K6455bA3OX1p235C2nAPxMJEoxkZhPS3zIT1M=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Clark Williams <williams@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 5/6] hvc_console: Fix race between hvc_close and hvc_remove
Date: Tue, 15 Jun 2010 00:21:26 +0200
Message-Id: <1276554087-3632-6-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1276554087-3632-1-git-send-email-jkacur@redhat.com>
References: <1276554087-3632-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Shah <amit.shah@redhat.com>

Alan pointed out a race in the code where hvc_remove is invoked. The
recent virtio_console work is the first user of hvc_remove().

Alan describes it thus:

The hvc_console assumes that a close and remove call can't occur at the
same time.

In addition tty_hangup(tty) is problematic as tty_hangup is asynchronous
itself....

So this can happen

        hvc_close                               hvc_remove
        hung up ? - no
                                                lock
                                                tty = hp->tty
                                                unlock
        lock
        hp->tty = NULL
        unlock
        notify del
        kref_put the hvc struct
        close completes
        tty is destroyed
                                                tty_hangup dead tty
                                                tty->ops will be NULL
                                                NULL->...

This patch adds some tty krefs and also converts to using tty_vhangup().

Reported-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Amit Shah <amit.shah@redhat.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linuxppc-dev@ozlabs.org
CC: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Upstream-commit: e74d098c66543d0731de62eb747ccd5b636a6f4c
Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/char/hvc_console.c |   31 +++++++++++++++++++++----------
 1 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/char/hvc_console.c b/drivers/char/hvc_console.c
index 416d342..da70f68 100644
--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -312,6 +312,7 @@ static int hvc_open(struct tty_struct *tty, struct file * filp)
 	spin_lock_irqsave(&hp->lock, flags);
 	/* Check and then increment for fast path open. */
 	if (hp->count++ > 0) {
+		tty_kref_get(tty);
 		spin_unlock_irqrestore(&hp->lock, flags);
 		hvc_kick();
 		return 0;
@@ -319,7 +320,7 @@ static int hvc_open(struct tty_struct *tty, struct file * filp)
 
 	tty->driver_data = hp;
 
-	hp->tty = tty;
+	hp->tty = tty_kref_get(tty);
 
 	spin_unlock_irqrestore(&hp->lock, flags);
 
@@ -336,6 +337,7 @@ static int hvc_open(struct tty_struct *tty, struct file * filp)
 		spin_lock_irqsave(&hp->lock, flags);
 		hp->tty = NULL;
 		spin_unlock_irqrestore(&hp->lock, flags);
+		tty_kref_put(tty);
 		tty->driver_data = NULL;
 		kref_put(&hp->kref, destroy_hvc_struct);
 		printk(KERN_ERR "hvc_open: request_irq failed with rc %d.\n", rc);
@@ -363,13 +365,18 @@ static void hvc_close(struct tty_struct *tty, struct file * filp)
 		return;
 
 	hp = tty->driver_data;
+
 	spin_lock_irqsave(&hp->lock, flags);
+	tty_kref_get(tty);
 
 	if (--hp->count == 0) {
 		/* We are done with the tty pointer now. */
 		hp->tty = NULL;
 		spin_unlock_irqrestore(&hp->lock, flags);
 
+		/* Put the ref obtained in hvc_open() */
+		tty_kref_put(tty);
+
 		if (hp->ops->notifier_del)
 			hp->ops->notifier_del(hp, hp->data);
 
@@ -389,6 +396,7 @@ static void hvc_close(struct tty_struct *tty, struct file * filp)
 		spin_unlock_irqrestore(&hp->lock, flags);
 	}
 
+	tty_kref_put(tty);
 	kref_put(&hp->kref, destroy_hvc_struct);
 }
 
@@ -424,10 +432,11 @@ static void hvc_hangup(struct tty_struct *tty)
 	spin_unlock_irqrestore(&hp->lock, flags);
 
 	if (hp->ops->notifier_hangup)
-			hp->ops->notifier_hangup(hp, hp->data);
+		hp->ops->notifier_hangup(hp, hp->data);
 
 	while(temp_open_count) {
 		--temp_open_count;
+		tty_kref_put(tty);
 		kref_put(&hp->kref, destroy_hvc_struct);
 	}
 }
@@ -592,7 +601,7 @@ int hvc_poll(struct hvc_struct *hp)
 	}
 
 	/* No tty attached, just skip */
-	tty = hp->tty;
+	tty = tty_kref_get(hp->tty);
 	if (tty == NULL)
 		goto bail;
 
@@ -672,6 +681,8 @@ int hvc_poll(struct hvc_struct *hp)
 
 		tty_flip_buffer_push(tty);
 	}
+	if (tty)
+		tty_kref_put(tty);
 
 	return poll_mask;
 }
@@ -806,7 +817,7 @@ int hvc_remove(struct hvc_struct *hp)
 	struct tty_struct *tty;
 
 	spin_lock_irqsave(&hp->lock, flags);
-	tty = hp->tty;
+	tty = tty_kref_get(hp->tty);
 
 	if (hp->index < MAX_NR_HVC_CONSOLES)
 		vtermnos[hp->index] = -1;
@@ -818,18 +829,18 @@ int hvc_remove(struct hvc_struct *hp)
 	/*
 	 * We 'put' the instance that was grabbed when the kref instance
 	 * was initialized using kref_init().  Let the last holder of this
-	 * kref cause it to be removed, which will probably be the tty_hangup
+	 * kref cause it to be removed, which will probably be the tty_vhangup
 	 * below.
 	 */
 	kref_put(&hp->kref, destroy_hvc_struct);
 
 	/*
-	 * This function call will auto chain call hvc_hangup.  The tty should
-	 * always be valid at this time unless a simultaneous tty close already
-	 * cleaned up the hvc_struct.
+	 * This function call will auto chain call hvc_hangup.
 	 */
-	if (tty)
-		tty_hangup(tty);
+	if (tty) {
+		tty_vhangup(tty);
+		tty_kref_put(tty);
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(hvc_remove);
-- 
1.6.6.1

