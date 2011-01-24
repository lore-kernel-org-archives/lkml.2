Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab1AXQyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 11:54:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40645 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab1AXQyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 11:54:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Uo91Ylipzoit7ZH5BcUz56NbwYVu1DyD+/hSWStx3+fu5PQMBkXkCBmvKWxTyO95kI
         I55IAXcSPcEeMmlwNKVgAi/JoqCimkKHgbDP0aWc9vtzrNvO00wlYMkozVxcrySxxq11
         EAb7fwj1WU3H6EjgUwRc58QCGAnKmASbc9+Pg=
Date: Mon, 24 Jan 2011 17:54:12 +0100
From: Tejun Heo <tj@kernel.org>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tty_ldisc: don't use flush_scheduled_work()
Message-ID: <20110124165412.GF27510@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flush_scheduled_work() is scheduled to be deprecated.  Explicitly sync
flush the used work items instead.  Note that before this change,
flush_scheduled_work() wouldn't have properly flushed tty->buf.work if
it were on timer.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>
---
 drivers/tty/tty_ldisc.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

Index: work/drivers/tty/tty_ldisc.c
===================================================================
--- work.orig/drivers/tty/tty_ldisc.c
+++ work/drivers/tty/tty_ldisc.c
@@ -535,6 +535,19 @@ static int tty_ldisc_halt(struct tty_str
 }
 
 /**
+ *	tty_ldisc_flush_works	-	flush all works of a tty
+ *	@tty: tty device to flush works for
+ *
+ *	Sync flush all works belonging to @tty.
+ */
+static void tty_ldisc_flush_works(struct tty_struct *tty)
+{
+	flush_work_sync(&tty->hangup_work);
+	flush_work_sync(&tty->SAK_work);
+	flush_delayed_work_sync(&tty->buf.work);
+}
+
+/**
  *	tty_ldisc_wait_idle	-	wait for the ldisc to become idle
  *	@tty: tty to wait for
  *
@@ -653,7 +666,7 @@ int tty_set_ldisc(struct tty_struct *tty
 
 	mutex_unlock(&tty->ldisc_mutex);
 
-	flush_scheduled_work();
+	tty_ldisc_flush_works(tty);
 
 	retval = tty_ldisc_wait_idle(tty);
 
@@ -905,7 +918,7 @@ void tty_ldisc_release(struct tty_struct
 
 	tty_unlock();
 	tty_ldisc_halt(tty);
-	flush_scheduled_work();
+	tty_ldisc_flush_works(tty);
 	tty_lock();
 
 	mutex_lock(&tty->ldisc_mutex);
