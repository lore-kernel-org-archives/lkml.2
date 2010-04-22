Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab0DVQ71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 12:59:27 -0400
Received: from relay.ihostexchange.net ([66.46.182.52]:28741 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab0DVQ70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 12:59:26 -0400
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Apr 2010 12:59:26 EDT
Message-ID: <4BD07F2A.8080808@VirtualLogix.com>
Date: Thu, 22 Apr 2010 18:54:02 +0200
From: Eric Lescouet <Eric.Lescouet@VirtualLogix.com>
Reply-To: Eric Lescouet <eric.lescouet@vlx.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
CC: "usbip-devel@lists.sourceforge.net" 
	<usbip-devel@lists.sourceforge.net>
Subject: [PATCH]: Fix deadlock in USBIP driver (staging), linux-2.6.34-rc5
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
When detaching a port from the client side (usbip --detach 0),
the event thread, on the server side, is going to deadlock.
The "eh" server thread is getting USBIP_EH_RESET event and calls:
  -> stub_device_reset() -> usb_reset_device()
the USB framework is then calling back _in the same "eh" thread_ :
  -> stub_disconnect() -> usbip_stop_eh() -> wait_for_completion()
the "eh" thread is being asleep forever, waiting for its own completion.
The patch checks if "eh" is the current thread, in usbip_stop_eh().

Please Cc me in reply, I'm not in the list.

b.r.

------------------

diff -Nur linux-2.6.34-rc5/drivers/staging/usbip/usbip_event.c 
linux-2.6.34-rc5.new/drivers/staging/usbip/usbip_event.c
--- linux-2.6.34-rc5/drivers/staging/usbip/usbip_event.c    2010-04-20 
01:29:56.000000000 +0200
+++ linux-2.6.34-rc5.new/drivers/staging/usbip/usbip_event.c    
2010-04-22 17:07:36.249588273 +0200
@@ -116,6 +116,13 @@
  void usbip_stop_eh(struct usbip_device *ud)
  {
      struct usbip_task *eh = &ud->eh;
+    int                i_am_eh;
+
+    lock_kernel();
+    i_am_eh = (eh->thread == current);
+    unlock_kernel();
+    if (i_am_eh)
+        return; /* do not wait for myself */

      wait_for_completion(&eh->thread_done);
      usbip_dbg_eh("usbip_eh has finished\n");

