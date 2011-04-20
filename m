Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab1DTInw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 04:43:52 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:51020 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab1DTIn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 04:43:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH 2/7] Char: nozomi, remove port.count checks
Date: Wed, 20 Apr 2011 10:43:13 +0200
Message-Id: <1303288998-31718-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1303288998-31718-1-git-send-email-jslaby@suse.cz>
References: <1303288998-31718-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before 33dd474a, these were some kind of protection against race with
HUP. They were protected with port->tty_sem at the same time.

By that commit, the counting was switched to tty_port's one, but the
locking remained the old one. So the count was not protected by
any lock anymore.

The driver should not test whether it raced with HUP or not anyways.
With the new refcounted tty model, it just should proceed as nothing
happened because all needed info is still there. In respect to this,
let's drop the useless and unprotected tests (tty_port->count is
protected by tty_port->lock).

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Tested-by: Gerald Pfeifer <gerald@pfeifer.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/nozomi.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/nozomi.c b/drivers/tty/nozomi.c
index acaecc1..c34d622 100644
--- a/drivers/tty/nozomi.c
+++ b/drivers/tty/nozomi.c
@@ -1690,11 +1690,6 @@ static int ntty_write(struct tty_struct *tty, const unsigned char *buffer,
 
 	mutex_lock(&port->tty_sem);
 
-	if (unlikely(!port->port.count)) {
-		DBG1(" ");
-		goto exit;
-	}
-
 	rval = kfifo_in(&port->fifo_ul, (unsigned char *)buffer, count);
 
 	/* notify card */
@@ -1740,8 +1735,7 @@ static int ntty_write_room(struct tty_struct *tty)
 
 	if (dc) {
 		mutex_lock(&port->tty_sem);
-		if (port->port.count)
-			room = kfifo_avail(&port->fifo_ul);
+		room = kfifo_avail(&port->fifo_ul);
 		mutex_unlock(&port->tty_sem);
 	}
 	return room;
@@ -1889,11 +1883,6 @@ static s32 ntty_chars_in_buffer(struct tty_struct *tty)
 		goto exit_in_buffer;
 	}
 
-	if (unlikely(!port->port.count)) {
-		dev_err(&dc->pdev->dev, "No tty open?\n");
-		goto exit_in_buffer;
-	}
-
 	rval = kfifo_len(&port->fifo_ul);
 
 exit_in_buffer:
-- 
1.7.4.2


