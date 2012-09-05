Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292Ab2IELG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 07:06:56 -0400
Received: from ni.piap.pl ([195.187.100.4]:43755 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab2IELGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 07:06:54 -0400
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Sep 2012 07:06:54 EDT
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: linux-kernel@vger.kernel.org
Date: Wed, 05 Sep 2012 12:56:03 +0200
MIME-Version: 1.0
Message-ID: <m3k3w8g2m4.fsf@t19.piap.pl>
Content-Type: text/plain
Subject: 3.4.10 N_GSM tty_io WARNING and lockup
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20120905 #7764031, check: 20120905 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to use GSM tty line discipline. Basically

echo AT+CMUX=0 > /dev/ttyS0

set termios (speed etc.)
int ldisc = N_GSM0710;
ioctl(fd, TIOCSETD, &ldisc);

...

The ioctl first fails with EIO (probably due to inactive DCD line) in
tty_set_ldisc():

	if (test_bit(TTY_HUPPED, &tty->flags)) {
		/* We were raced by the hangup method. It will have stomped
		   the ldisc data and closed the ldisc down */
		clear_bit(TTY_LDISC_CHANGING, &tty->flags);
		mutex_unlock(&tty->ldisc_mutex);
		tty_ldisc_put(new_ldisc);
		tty_unlock();
		return -EIO;                         <<<<<< HERE
	}


Now trying to run the program again:

------------[ cut here ]------------
WARNING: at /home/khalasa/src/linux-3.4/drivers/tty/tty_io.c:1368 tty_open+0x2e8/0x55c()
Modules linked in: m25p80 ag71xx
Call Trace:
 [<8030a02c>] dump_stack+0x8/0x34
 [<8007a35c>] warn_slowpath_common+0x78/0xa4
 [<8007a3a0>] warn_slowpath_null+0x18/0x24
 [<80193cac>] tty_open+0x2e8/0x55c
 [<800f1500>] chrdev_open+0x120/0x164
 [<800eb320>] __dentry_open.isra.12+0x1bc/0x318
 [<800fae54>] do_last.isra.32+0x774/0x78c
 [<800fb094>] path_openat+0xcc/0x3b4
 [<800fb498>] do_filp_open+0x3c/0xa4
 [<800ec3dc>] do_sys_open+0x13c/0x1ec
 [<80068dc4>] stack_done+0x20/0x40

---[ end trace 5958cc366bfb54c4 ]---

then it locks up (task "D" state, though interruptible).

A known problem probably?
Any ideas? (I know about CLOCAL).
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
