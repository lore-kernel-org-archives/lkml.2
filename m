Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab0EJWwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:52:15 -0400
Received: from kroah.org ([198.145.64.141]:32949 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932340Ab0EJWvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:51:52 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:19 2010
Message-Id: <20100510223319.190984548@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:31:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Lescouet <eric@lescouet.org>
Subject: [022/117] staging: usbip: Fix deadlock
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Lescouet <lescouet@virtuallogix.com>

commit d01f42a22ef381ba973958e977209ac9a8667d57 upstream.

When detaching a port from the client side (usbip --detach 0),
the event thread, on the server side, is going to deadlock.
The "eh" server thread is getting USBIP_EH_RESET event and calls:
  -> stub_device_reset() -> usb_reset_device()
the USB framework is then calling back _in the same "eh" thread_ :
  -> stub_disconnect() -> usbip_stop_eh() -> wait_for_completion()
the "eh" thread is being asleep forever, waiting for its own completion.
This patch checks if "eh" is the current thread, in usbip_stop_eh().

Signed-off-by: Eric Lescouet <eric@lescouet.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/usbip/usbip_event.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/staging/usbip/usbip_event.c
+++ b/drivers/staging/usbip/usbip_event.c
@@ -117,6 +117,9 @@ void usbip_stop_eh(struct usbip_device *
 {
 	struct usbip_task *eh = &ud->eh;
 
+	if (eh->thread == current)
+		return; /* do not wait for myself */
+
 	wait_for_completion(&eh->thread_done);
 	usbip_dbg_eh("usbip_eh has finished\n");
 }


