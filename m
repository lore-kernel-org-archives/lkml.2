Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030215Ab2KUVUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 16:20:00 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:44273 "EHLO
	95-31-19-74.broadband.corbina.ru" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964856Ab2KUVT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 16:19:57 -0500
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Nov 2012 16:19:57 EST
Message-ID: <50AD43DB.4030800@ilyx.ru>
Date: Thu, 22 Nov 2012 01:12:59 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Andrew McGregor <andrew.mcgregor@alliedtelesis.co.nz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [PATCH] tty: Add driver unthrottle in ioctl(...,TCFLSH,..).
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revert 'tty: fix "IRQ45: nobody cared"'

This revert commit 7b292b4bf9a9d6098440d85616d6ca4c608b8304

Function reset_buffer_flags() also invoked during the
ioctl(...,TCFLSH,..). At the time of request we can have full buffers
and throttled driver too. If we don't unthrottle driver, we can get
forever throttled driver, because after request, we will have
empty buffers and throttled driver and there is no place to unthrottle driver.
It simple reproduce with "pty" pair then one side sleep on tty->write_wait,
and other side do ioctl(...,TCFLSH,..). Then there is no place to do writers wake up.

About 'tty: fix "IRQ45: nobody cared"':
We don't call tty_unthrottle() if release last filp - ('tty->count == 0')
In other case it must be safely. Maybe we have bug in other place.

Signed-off-by: Ilya Zykov <ilya@ilyx.ru>
---

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 26f0d0e..a783d0e 100644

--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -184,6 +184,7 @@ static void reset_buffer_flags(struct tty_struct *tty)
        tty->canon_head = tty->canon_data = tty->erasing = 0;
        memset(&tty->read_flags, 0, sizeof tty->read_flags);
        n_tty_set_room(tty);
+       check_unthrottle(tty);
 }
 
 /**
@@ -1585,7 +1586,6 @@ static int n_tty_open(struct tty_struct *tty)
                        return -ENOMEM;
        }
        reset_buffer_flags(tty);
-       tty_unthrottle(tty);
        tty->column = 0;
        n_tty_set_termios(tty, NULL);
        tty->minimum_to_wake = 1;
