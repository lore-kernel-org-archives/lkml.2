Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933815Ab1KJDU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:20:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41666 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757026Ab1KJDU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:20:56 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:00 2011
Message-Id: <20111109212700.720001011@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:25:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jiri Slaby <jslaby@suse.cz>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: [004/262] TTY: drop driver reference in tty_open fail path
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit c290f8358acaeffd8e0c551ddcc24d1206143376 upstream.

When tty_driver_lookup_tty fails in tty_open, we forget to drop a
reference to the tty driver. This was added by commit 4a2b5fddd5 (Move
tty lookup/reopen to caller).

Fix that by adding tty_driver_kref_put to the fail path.

I will refactor the code later. This is for the ease of backporting to
stable.

Introduced-in: v2.6.28-rc2
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Acked-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/tty/tty_io.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1872,6 +1872,7 @@ got_driver:
 		if (IS_ERR(tty)) {
 			tty_unlock();
 			mutex_unlock(&tty_mutex);
+			tty_driver_kref_put(driver);
 			return PTR_ERR(tty);
 		}
 	}


