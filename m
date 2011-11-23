Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279Ab1KWAlB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:41:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42852 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759237Ab1KWAk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:40:58 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:24:06 2011
Message-Id: <20111123002406.684133086@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:23:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jiri Slaby <jslaby@suse.cz>,
        Dave Young <hidave.darkstar@gmail.com>, Dave Jones <davej@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Dmitriy Matrosov <sgf.dma@gmail.com>
Subject: [22/53] TTY: ldisc, allow waiting for ldisc arbitrarily long
In-Reply-To: <20111123002419.GA8531@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit df92d0561de364de53c42abc5d43e04ab6f326a5 upstream.

To fix a nasty bug in ldisc hup vs. reinit we need to wait infinitely
long for ldisc to be gone. So here we add a parameter to
tty_ldisc_wait_idle to allow that.

This is only a preparation for the real fix which is done in the
following patches.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Dmitriy Matrosov <sgf.dma@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/tty/tty_ldisc.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -548,15 +548,16 @@ static void tty_ldisc_flush_works(struct
 /**
  *	tty_ldisc_wait_idle	-	wait for the ldisc to become idle
  *	@tty: tty to wait for
+ *	@timeout: for how long to wait at most
  *
  *	Wait for the line discipline to become idle. The discipline must
  *	have been halted for this to guarantee it remains idle.
  */
-static int tty_ldisc_wait_idle(struct tty_struct *tty)
+static int tty_ldisc_wait_idle(struct tty_struct *tty, long timeout)
 {
-	int ret;
+	long ret;
 	ret = wait_event_timeout(tty_ldisc_idle,
-			atomic_read(&tty->ldisc->users) == 1, 5 * HZ);
+			atomic_read(&tty->ldisc->users) == 1, timeout);
 	if (ret < 0)
 		return ret;
 	return ret > 0 ? 0 : -EBUSY;
@@ -666,7 +667,7 @@ int tty_set_ldisc(struct tty_struct *tty
 
 	tty_ldisc_flush_works(tty);
 
-	retval = tty_ldisc_wait_idle(tty);
+	retval = tty_ldisc_wait_idle(tty, 5 * HZ);
 
 	tty_lock();
 	mutex_lock(&tty->ldisc_mutex);
@@ -763,7 +764,7 @@ static int tty_ldisc_reinit(struct tty_s
 	if (IS_ERR(ld))
 		return -1;
 
-	WARN_ON_ONCE(tty_ldisc_wait_idle(tty));
+	WARN_ON_ONCE(tty_ldisc_wait_idle(tty, 5 * HZ));
 
 	tty_ldisc_close(tty, tty->ldisc);
 	tty_ldisc_put(tty->ldisc);


