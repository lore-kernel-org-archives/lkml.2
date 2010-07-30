Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760238Ab0G3SSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:18:42 -0400
Received: from kroah.org ([198.145.64.141]:58836 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760033Ab0G3R4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:56:41 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:45 2010
Message-Id: <20100730175145.328089286@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jon Povey <jon.povey@racelogic.co.uk>, Maulik Mankad <x0082077@ti.com>,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: [125/205] USB: g_serial: dont set low_latency flag
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

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
@@ -536,17 +536,11 @@ recycle:
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
 
 
@@ -784,11 +778,6 @@ static int gs_open(struct tty_struct *tt
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


