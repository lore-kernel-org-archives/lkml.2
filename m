Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301Ab2EXPf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 11:35:59 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58950 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab2EXPf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 11:35:58 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] tty: fix ldisc lock inversion trace
To: linux-kernel@vger.kernel.org
Date: Thu, 24 May 2012 16:51:31 +0100
Message-ID: <20120524155121.20241.68413.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This is caused by tty_release using tty_lock_pair to lock both
sides of the pty/tty pair, and then tty_ldisc_release dropping
and relocking one side only. We can drop both fine, so drop both
to avoid any lock ordering concerns.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/tty/tty_ldisc.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)


diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 173a900..833e851 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -912,10 +912,13 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
 	 * race with the set_ldisc code path.
 	 */
 
-	tty_unlock(tty);
+	/* We don't give a monkeys' about the o_tty lock here but we
+	   must do both to avoid lock inversions against another single
+	   locking case */
+	tty_unlock_pair(tty, o_tty);
 	tty_ldisc_halt(tty);
 	tty_ldisc_flush_works(tty);
-	tty_lock(tty);
+	tty_lock_pair(tty, o_tty);
 
 	mutex_lock(&tty->ldisc_mutex);
 	/*

