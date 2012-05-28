Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab2E1Jdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 05:33:37 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34534 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab2E1Jdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 05:33:36 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/2] pty: Fix lock inversion
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Mon, 28 May 2012 10:49:10 +0100
Message-ID: <20120528094848.3001.48296.stgit@bob.linux.org.uk>
In-Reply-To: <20120528094741.3001.29866.stgit@bob.linux.org.uk>
References: <20120528094741.3001.29866.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The ptmx_open path takes the tty and devpts locks in the wrong order
because tty_init_dev locks and returns a locked tty. As far as I can tell
this is actually safe anyway because the tty being returned is new so
nobody can get a reference to lock it at this point.

However we don't even need the devpts lock at this point, it's only held as
a byproduct of the way the locks were pushed down.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/tty/pty.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)


diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 59af394..65c7c62 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -633,7 +633,6 @@ static int ptmx_open(struct inode *inode, struct file *filp)
 	mutex_unlock(&devpts_mutex);
 
 	mutex_lock(&tty_mutex);
-	mutex_lock(&devpts_mutex);
 	tty = tty_init_dev(ptm_driver, index);
 
 	if (IS_ERR(tty)) {
@@ -643,7 +642,6 @@ static int ptmx_open(struct inode *inode, struct file *filp)
 
 	/* The tty returned here is locked so we can safely
 	   drop the mutex */
-	mutex_unlock(&devpts_mutex);
 	mutex_unlock(&tty_mutex);
 
 	set_bit(TTY_PTY_LOCK, &tty->flags); /* LOCK THE SLAVE */

