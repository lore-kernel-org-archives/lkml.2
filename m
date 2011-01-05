Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab1AEXGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:06:43 -0500
Received: from kroah.org ([198.145.64.141]:50842 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347Ab1AEXGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:06:39 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 15:03:26 2011
Message-Id: <20110105230326.581569920@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 15:00:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anton Blanchard <anton@samba.org>, Amit Shah <amit.shah@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [31/49] hvc_console: Fix race between hvc_close and hvc_remove, again
In-Reply-To: <20110105230438.GA26241@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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

---
 drivers/char/hvc_console.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -367,16 +367,12 @@ static void hvc_close(struct tty_struct
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
 


