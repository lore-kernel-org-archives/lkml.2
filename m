Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760168Ab1CEA7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 19:59:54 -0500
Received: from kroah.org ([198.145.64.141]:50105 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760052Ab1CEA7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 19:59:52 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:35 2011
Message-Id: <20110305005635.088686930@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Amit Shah <amitshah@gmx.net>, baoyb <baoyb@avit.org.cn>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [05/73] USB: serial/usb_wwan, fix tty NULL dereference
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit 38237fd2be9421c104f84cc35665097bdce89013 upstream.

tty_port_tty_get may return without any problems NULL. Handle this
case and do not oops in usb_wwan_indat_callback by dereferencing it.

The oops:
Unable to handle kernel paging request for data at address 0x000000d8
Faulting instruction address: 0xc0175b3c
Oops: Kernel access of bad area, sig: 11 [#1]
PowerPC 40x Platform
last sysfs file:
/sys/devices/pci0000:00/0000:00:00.0/0000:01:00.0/0000:02:09.2/usb1/idVendor
Modules linked in:
NIP: c0175b3c LR: c0175e7c CTR: c0215c90
REGS: c77f7d50 TRAP: 0300   Not tainted  (2.6.37-rc5)
MSR: 00021030 <ME,CE,IR,DR>  CR: 88482028  XER: 2000005f
DEAR: 000000d8, ESR: 00000000
TASK = c7141b90[1149] 'wvdial' THREAD: c2750000
GPR00: 00021030 c77f7e00 c7141b90 00000000 0000000e 00000000 0000000e c0410680
GPR08: c683db00 00000000 00000001 c03c81f8 88482028 10073ef4 ffffffb9 ffffff94
GPR16: 00000000 fde036c0 00200200 00100100 00000001 ffffff8d c34fabcc 00000000
GPR24: c71120d4 00000000 00000000 0000000e 00021030 00000000 00000000 0000000e
NIP [c0175b3c] tty_buffer_request_room+0x2c/0x194
LR [c0175e7c] tty_insert_flip_string_fixed_flag+0x3c/0xb0
Call Trace:
[c77f7e00] [00000003] 0x3 (unreliable)
[c77f7e30] [c0175e7c] tty_insert_flip_string_fixed_flag+0x3c/0xb0
[c77f7e60] [c0215df4] usb_wwan_indat_callback+0x164/0x170
...

References: https://bugzilla.kernel.org/show_bug.cgi?id=24582
Cc: Amit Shah <amitshah@gmx.net>
Cc: baoyb <baoyb@avit.org.cn>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/usb_wwan.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -216,12 +216,15 @@ static void usb_wwan_indat_callback(stru
 		    __func__, status, endpoint);
 	} else {
 		tty = tty_port_tty_get(&port->port);
-		if (urb->actual_length) {
-			tty_insert_flip_string(tty, data, urb->actual_length);
-			tty_flip_buffer_push(tty);
-		} else
-			dbg("%s: empty read urb received", __func__);
-		tty_kref_put(tty);
+		if (tty) {
+			if (urb->actual_length) {
+				tty_insert_flip_string(tty, data,
+						urb->actual_length);
+				tty_flip_buffer_push(tty);
+			} else
+				dbg("%s: empty read urb received", __func__);
+			tty_kref_put(tty);
+		}
 
 		/* Resubmit urb so we continue receiving */
 		if (status != -ESHUTDOWN) {


