Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051Ab2CAThU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:37:20 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46312 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756930Ab2CAThQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:37:16 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 4/6] vt: waitevent is self locked so drop the tty_lock
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Date: Thu, 01 Mar 2012 19:51:33 +0000
Message-ID: <20120301195128.11322.9098.stgit@bob.linux.org.uk>
In-Reply-To: <20120301194831.11322.38295.stgit@bob.linux.org.uk>
References: <20120301194831.11322.38295.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/tty/vt/vt_ioctl.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)


diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index f0b5143..ede2ef1 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -130,7 +130,7 @@ static void vt_event_wait(struct vt_event_wait *vw)
 	list_add(&vw->list, &vt_events);
 	spin_unlock_irqrestore(&vt_event_lock, flags);
 	/* Wait for it to pass */
-	wait_event_interruptible_tty(vt_event_waitqueue, vw->done);
+	wait_event_interruptible(vt_event_waitqueue, vw->done);
 	/* Dequeue it */
 	spin_lock_irqsave(&vt_event_lock, flags);
 	list_del(&vw->list);
@@ -1423,14 +1423,10 @@ int vt_move_to_console(unsigned int vt, int alloc)
 		return -EIO;
 	}
 	console_unlock();
-	/* Review: I don't see why we need tty_lock here FIXME */
-	tty_lock();
 	if (vt_waitactive(vt + 1)) {
 		pr_debug("Suspend: Can't switch VCs.");
-		tty_unlock();
 		return -EINTR;
 	}
-	tty_unlock();
 	return prev;
 }
 

