Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab2LSTAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 14:00:13 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:60438 "EHLO
	95-31-19-74.broadband.corbina.ru" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751184Ab2LSTAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 14:00:08 -0500
Message-ID: <50D20EB5.30900@ilyx.ru>
Date: Wed, 19 Dec 2012 23:00:05 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH] tty: Fix ptmx open without closed slave.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we are opening ptmx, we have closed pts, by description.
Now only if we open and after close all pts' descriptions, pty_close() sets
this bit correctly

Signed-off-by: Ilya Zykov <ilya@ilyx.ru>
---
 drivers/tty/pty.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 1ce1362..7b69307 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -659,6 +659,7 @@ static int ptmx_open(struct inode *inode, struct file *filp)
 	retval = ptm_driver->ops->open(tty, filp);
 	if (retval)
 		goto err_release;
+	set_bit(TTY_OTHER_CLOSED, &tty->flags); /* THE SLAVE STILL CLOSED */
 
 	tty_unlock(tty);
 	return 0;
