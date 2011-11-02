Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149Ab1KCCOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 22:14:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50501 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933049Ab1KCBei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:34:38 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:54 2011
Message-Id: <20111102221454.791149646@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kautuk Consul <consul.kautuk@gmail.com>
Subject: [051/107] staging: quatech_usb2: Potential lost wakeup scenario in TIOCMIWAIT
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Kautuk Consul <consul.kautuk@gmail.com>

commit e8df1674d383d2ecc6efa8d7dba74c03aafdfdd7 upstream.

If the usermode app does an ioctl over this serial device  by
using TIOCMIWAIT, then the code will wait by setting the current
task state to TASK_INTERRUPTIBLE and then calling schedule().
This will be woken up by the qt2_process_modem_status on URB
completion when the port_extra->shadowMSR is set to the new
modem status.

However, this could result in a lost wakeup scenario due to a race
in the logic in the qt2_ioctl(TIOCMIWAIT) loop and the URB completion
for new modem status in qt2_process_modem_status.
Due to this, the usermode app's task will continue to sleep despite a
change in the modem status.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/quatech_usb2/quatech_usb2.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/staging/quatech_usb2/quatech_usb2.c
+++ b/drivers/staging/quatech_usb2/quatech_usb2.c
@@ -921,9 +921,10 @@ static int qt2_ioctl(struct tty_struct *
 		dbg("%s() port %d, cmd == TIOCMIWAIT enter",
 			__func__, port->number);
 		prev_msr_value = port_extra->shadowMSR  & QT2_SERIAL_MSR_MASK;
+		barrier();
+		__set_current_state(TASK_INTERRUPTIBLE);
 		while (1) {
 			add_wait_queue(&port_extra->wait, &wait);
-			set_current_state(TASK_INTERRUPTIBLE);
 			schedule();
 			dbg("%s(): port %d, cmd == TIOCMIWAIT here\n",
 				__func__, port->number);
@@ -931,9 +932,12 @@ static int qt2_ioctl(struct tty_struct *
 			/* see if a signal woke us up */
 			if (signal_pending(current))
 				return -ERESTARTSYS;
+			set_current_state(TASK_INTERRUPTIBLE);
 			msr_value = port_extra->shadowMSR & QT2_SERIAL_MSR_MASK;
-			if (msr_value == prev_msr_value)
+			if (msr_value == prev_msr_value) {
+				__set_current_state(TASK_RUNNING);
 				return -EIO;  /* no change - error */
+			}
 			if ((arg & TIOCM_RNG &&
 				((prev_msr_value & QT2_SERIAL_MSR_RI) ==
 					(msr_value & QT2_SERIAL_MSR_RI))) ||
@@ -946,6 +950,7 @@ static int qt2_ioctl(struct tty_struct *
 				(arg & TIOCM_CTS &&
 				((prev_msr_value & QT2_SERIAL_MSR_CTS) ==
 					(msr_value & QT2_SERIAL_MSR_CTS)))) {
+				__set_current_state(TASK_RUNNING);
 				return 0;
 			}
 		} /* end inifinite while */


