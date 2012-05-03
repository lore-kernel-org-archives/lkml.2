Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715Ab2ECVGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 17:06:41 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58114 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab2ECVGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 17:06:39 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/3] tty_lock: undo the old tty_lock use on the ctty
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Date: Thu, 03 May 2012 22:21:53 +0100
Message-ID: <20120503212151.568.91854.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

get_current_tty has its own consistent locking. That means a pile of the
tty lock cases are not needed. As get_current_tty also keeps a reference the
tty object lifetime means we can propogate the lock removal out.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/tty/tty_io.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)


diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index d939bd7..b425c79 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -855,10 +855,11 @@ void disassociate_ctty(int on_exit)
  */
 void no_tty(void)
 {
+	/* FIXME: Review locking here. The tty_lock never covered any race
+	   between a new association and proc_clear_tty but possible we need
+	   to protect against this anyway */
 	struct task_struct *tsk = current;
-	tty_lock();
 	disassociate_ctty(0);
-	tty_unlock();
 	proc_clear_tty(tsk);
 }
 
@@ -1800,6 +1801,9 @@ int tty_release(struct inode *inode, struct file *filp)
  *
  *	We cannot return driver and index like for the other nodes because
  *	devpts will not work then. It expects inodes to be from devpts FS.
+ *
+ *	We need to move to returning a refcounted object from all the lookup
+ *	paths including this one.
  */
 static struct tty_struct *tty_open_current_tty(dev_t device, struct file *filp)
 {
@@ -1816,6 +1820,7 @@ static struct tty_struct *tty_open_current_tty(dev_t device, struct file *filp)
 	/* noctty = 1; */
 	tty_kref_put(tty);
 	/* FIXME: we put a reference and return a TTY! */
+	/* This is only safe because the caller holds tty_mutex */
 	return tty;
 }
 

