Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027Ab2HOUZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:25:58 -0400
Received: from mail.windriver.com ([147.11.1.11]:36784 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569Ab2HOTuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:25 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Kautuk Consul <consul.kautuk@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 063/165] staging: quatech_usb2: Potential lost wakeup scenario in TIOCMIWAIT
Date: Wed, 15 Aug 2012 15:46:47 -0400
Message-ID: <1345060109-9187-64-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kautuk Consul <consul.kautuk@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/staging/quatech_usb2/quatech_usb2.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/quatech_usb2/quatech_usb2.c b/drivers/staging/quatech_usb2/quatech_usb2.c
index 1561f74..3ca3c2a 100644
--- a/drivers/staging/quatech_usb2/quatech_usb2.c
+++ b/drivers/staging/quatech_usb2/quatech_usb2.c
@@ -921,9 +921,10 @@ static int qt2_ioctl(struct tty_struct *tty, struct file *file,
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
@@ -931,9 +932,12 @@ static int qt2_ioctl(struct tty_struct *tty, struct file *file,
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
@@ -946,6 +950,7 @@ static int qt2_ioctl(struct tty_struct *tty, struct file *file,
 				(arg & TIOCM_CTS &&
 				((prev_msr_value & QT2_SERIAL_MSR_CTS) ==
 					(msr_value & QT2_SERIAL_MSR_CTS)))) {
+				__set_current_state(TASK_RUNNING);
 				return 0;
 			}
 		} /* end inifinite while */
-- 
1.7.12.rc2

