Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab1BFXqu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:46:50 -0500
Received: from 1wt.eu ([62.212.114.60]:60321 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470Ab1BFXq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:46:28 -0500
Message-Id: <20110206232253.463757617@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 07 Feb 2011 00:23:14 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Anton Blanchard <anton@samba.org>, Amit Shah <amit.shah@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [PATCH 22/23] hvc_console: Fix race between hvc_close and hvc_remove, again
In-Reply-To: <4beed4da27f06efb2c13d6ed48850634@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.58-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 320718ee074acce5ffced6506cb51af1388942aa upstream.

I don't claim to understand the tty layer, but it seems like hvc_open and
hvc_close should be balanced in their kref reference counting.

Right now we get a kref every call to hvc_open:

        if (hp->count++ > 0) {
                tty_kref_get(tty); <----- here
                spin_unlock_irqrestore(&hp->lock, flags);
                hvc_kick();
                return 0;
        } /* else count == 0 */

        tty->driver_data = hp;

        hp->tty = tty_kref_get(tty); <------ or here if hp->count was 0

But hvc_close has:

        tty_kref_get(tty);

        if (--hp->count == 0) {
...
                /* Put the ref obtained in hvc_open() */
                tty_kref_put(tty);
...
        }

        tty_kref_put(tty);

Since the outside kref get/put balance we only do a single kref_put when
count reaches 0.

The patch below changes things to call tty_kref_put once for every
hvc_close call, and with that my machine boots fine.

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>

---
 drivers/char/hvc_console.c |    4 ----
 1 file changed, 4 deletions(-)

Index: longterm-2.6.27/drivers/char/hvc_console.c
===================================================================
--- longterm-2.6.27.orig/drivers/char/hvc_console.c	2011-01-29 15:33:05.169065818 +0100
+++ longterm-2.6.27/drivers/char/hvc_console.c	2011-01-29 15:33:55.140065271 +0100
@@ -368,16 +368,12 @@
 	hp = tty->driver_data;
 
 	spin_lock_irqsave(&hp->lock, flags);
-	tty_kref_get(tty);
 
 	if (--hp->count == 0) {
 		/* We are done with the tty pointer now. */
 		hp->tty = NULL;
 		spin_unlock_irqrestore(&hp->lock, flags);
 
-		/* Put the ref obtained in hvc_open() */
-		tty_kref_put(tty);
-
 		if (hp->ops->notifier_del)
 			hp->ops->notifier_del(hp, hp->data);
 


