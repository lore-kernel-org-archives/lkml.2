Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760348Ab0G3TEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 15:04:10 -0400
Received: from kroah.org ([198.145.64.141]:51668 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757996Ab0G3RSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:18:51 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:06 2010
Message-Id: <20100730171505.989307303@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:14:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jon Povey <jon.povey@racelogic.co.uk>, Maulik Mankad <x0082077@ti.com>,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: [070/165] USB: g_serial: dont set low_latency flag
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jon Povey <jon.povey@racelogic.co.uk>

commit 44a0c0190b500ee6bcfc0976fe540f65dee2cd67 upstream.

No longer set low_latency flag as it causes this warning backtrace:

  WARNING: at kernel/mutex.c:207 __mutex_lock_slowpath+0x6c/0x288()

Fix associated locking and wakeups.

Signed-off-by: Jon Povey <jon.povey@racelogic.co.uk>
Cc: Maulik Mankad <x0082077@ti.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/u_serial.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

--- a/drivers/usb/gadget/u_serial.c
+++ b/drivers/usb/gadget/u_serial.c
@@ -535,17 +535,11 @@ recycle:
 		list_move(&req->list, &port->read_pool);
 	}
 
-	/* Push from tty to ldisc; this is immediate with low_latency, and
-	 * may trigger callbacks to this driver ... so drop the spinlock.
+	/* Push from tty to ldisc; without low_latency set this is handled by
+	 * a workqueue, so we won't get callbacks and can hold port_lock
 	 */
 	if (tty && do_push) {
-		spin_unlock_irq(&port->port_lock);
 		tty_flip_buffer_push(tty);
-		wake_up_interruptible(&tty->read_wait);
-		spin_lock_irq(&port->port_lock);
-
-		/* tty may have been closed */
-		tty = port->port_tty;
 	}
 
 
@@ -783,11 +777,6 @@ static int gs_open(struct tty_struct *tt
 	port->open_count = 1;
 	port->openclose = false;
 
-	/* low_latency means ldiscs work in tasklet context, without
-	 * needing a workqueue schedule ... easier to keep up.
-	 */
-	tty->low_latency = 1;
-
 	/* if connected, start the I/O stream */
 	if (port->port_usb) {
 		struct gserial	*gser = port->port_usb;


