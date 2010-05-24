Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab0EXX3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:29:31 -0400
Received: from kroah.org ([198.145.64.141]:59407 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932516Ab0EXXXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:23:41 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:18:15 2010
Message-Id: <20100524231814.995659071@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 16:15:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [20/39] tty: Fix unbalanced BKL handling in error path
In-Reply-To: <20100524231840.GA17857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Cox <alan@linux.intel.com>

commit 77945febbe60a69e9dcab7f49d33a1aa1e436973 upstream.

Arnd noted:

After the "retry_open:" label, we first get the tty_mutex
and then the BKL. However a the end of tty_open, we jump
back to retry_open with the BKL still held. If we run into
this case, the tty_open function will be left with the BKL
still held.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tty_io.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1875,6 +1875,7 @@ got_driver:
 		 */
 		if (filp->f_op == &hung_up_tty_fops)
 			filp->f_op = &tty_fops;
+		unlock_kernel();
 		goto retry_open;
 	}
 	unlock_kernel();


