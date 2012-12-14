Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab2LNXE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:04:57 -0500
Received: from mail.kernel.org ([198.145.19.201]:41019 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756892Ab2LNXEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:04:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dan Williams <dcbw@redhat.com>, Oliver Neukum <oneukum@suse.de>,
        Aleksander Morgado <aleksander@gnu.org>
Subject: [ 33/37] cdc-acm: implement TIOCSSERIAL to avoid blocking close(2)
Date: Fri, 14 Dec 2012 15:01:10 -0800
Message-Id: <20121214222258.232400129@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20121214222252.781413287@linuxfoundation.org>
References: <20121214222252.781413287@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit ba2d8ce9db0a61505362bb17b8899df3d3326146 upstream.

Some devices (ex Nokia C7) simply don't respond at all when data is sent
to some of their USB interfaces.  The data gets stuck in the TTYs queue
and sits there until close(2), which them blocks because closing_wait
defaults to 30 seconds (even though the fd is O_NONBLOCK).  This is
rarely desired.  Implement the standard mechanism to adjust closing_wait
and let applications handle it how they want to.

See also 02303f73373aa1da19dbec510ec5a4e2576f9610 for usb_wwan.c.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Acked-by: Oliver Neukum <oneukum@suse.de>
Tested-by: Aleksander Morgado <aleksander@gnu.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-acm.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -788,6 +788,10 @@ static int get_serial_info(struct acm *a
 	tmp.flags = ASYNC_LOW_LATENCY;
 	tmp.xmit_fifo_size = acm->writesize;
 	tmp.baud_base = le32_to_cpu(acm->line.dwDTERate);
+	tmp.close_delay	= acm->port.close_delay / 10;
+	tmp.closing_wait = acm->port.closing_wait == ASYNC_CLOSING_WAIT_NONE ?
+				ASYNC_CLOSING_WAIT_NONE :
+				acm->port.closing_wait / 10;
 
 	if (copy_to_user(info, &tmp, sizeof(tmp)))
 		return -EFAULT;
@@ -795,6 +799,37 @@ static int get_serial_info(struct acm *a
 		return 0;
 }
 
+static int set_serial_info(struct acm *acm,
+				struct serial_struct __user *newinfo)
+{
+	struct serial_struct new_serial;
+	unsigned int closing_wait, close_delay;
+	int retval = 0;
+
+	if (copy_from_user(&new_serial, newinfo, sizeof(new_serial)))
+		return -EFAULT;
+
+	close_delay = new_serial.close_delay * 10;
+	closing_wait = new_serial.closing_wait == ASYNC_CLOSING_WAIT_NONE ?
+			ASYNC_CLOSING_WAIT_NONE : new_serial.closing_wait * 10;
+
+	mutex_lock(&acm->port.mutex);
+
+	if (!capable(CAP_SYS_ADMIN)) {
+		if ((close_delay != acm->port.close_delay) ||
+		    (closing_wait != acm->port.closing_wait))
+			retval = -EPERM;
+		else
+			retval = -EOPNOTSUPP;
+	} else {
+		acm->port.close_delay  = close_delay;
+		acm->port.closing_wait = closing_wait;
+	}
+
+	mutex_unlock(&acm->port.mutex);
+	return retval;
+}
+
 static int acm_tty_ioctl(struct tty_struct *tty,
 					unsigned int cmd, unsigned long arg)
 {
@@ -805,6 +840,9 @@ static int acm_tty_ioctl(struct tty_stru
 	case TIOCGSERIAL: /* gets serial port data */
 		rv = get_serial_info(acm, (struct serial_struct __user *) arg);
 		break;
+	case TIOCSSERIAL:
+		rv = set_serial_info(acm, (struct serial_struct __user *) arg);
+		break;
 	}
 
 	return rv;


