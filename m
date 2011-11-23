Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294Ab1KWAlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:41:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42858 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759237Ab1KWAlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:41:01 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:24:06 2011
Message-Id: <20111123002406.776880320@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:23:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jiri Slaby <jslaby@suse.cz>,
        Dave Young <hidave.darkstar@gmail.com>, Dave Jones <davej@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Dmitriy Matrosov <sgf.dma@gmail.com>
Subject: [23/53] TTY: ldisc, move wait idle to caller
In-Reply-To: <20111123002419.GA8531@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit 300420722e0734a4254f3b634e0f82664495d210 upstream.

It is the only place where reinit is called from. And we really need
to wait for the old ldisc to go once. Actually this is the place where
the waiting originally was (before removed and re-added later).

This will make the fix in the following patch easier to implement.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Dmitriy Matrosov <sgf.dma@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/tty/tty_ldisc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -764,8 +764,6 @@ static int tty_ldisc_reinit(struct tty_s
 	if (IS_ERR(ld))
 		return -1;
 
-	WARN_ON_ONCE(tty_ldisc_wait_idle(tty, 5 * HZ));
-
 	tty_ldisc_close(tty, tty->ldisc);
 	tty_ldisc_put(tty->ldisc);
 	tty->ldisc = NULL;
@@ -849,6 +847,8 @@ void tty_ldisc_hangup(struct tty_struct
 	   it means auditing a lot of other paths so this is
 	   a FIXME */
 	if (tty->ldisc) {	/* Not yet closed */
+		WARN_ON_ONCE(tty_ldisc_wait_idle(tty, 5 * HZ));
+
 		if (reset == 0) {
 
 			if (!tty_ldisc_reinit(tty, tty->termios->c_line))


