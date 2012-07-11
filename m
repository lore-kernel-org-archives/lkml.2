Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab2GKGkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 02:40:52 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:19783 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab2GKGkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 02:40:51 -0400
Date: Wed, 11 Jul 2012 09:40:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        kernel-janitors@vger.kernel.org
Subject: [patch] tty: double unlock on error in ptmx_open()
Message-ID: <20120711064040.GH11812@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem here is that we called mutex_unlock(&devpts_mutex) on the
error path when we weren't holding the lock.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index d855883..a0ca083 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -618,13 +618,12 @@ static int ptmx_open(struct inode *inode, struct file *filp)
 	/* find a device that is not in use. */
 	mutex_lock(&devpts_mutex);
 	index = devpts_new_index(inode);
+	mutex_unlock(&devpts_mutex);
 	if (index < 0) {
 		retval = index;
 		goto err_file;
 	}
 
-	mutex_unlock(&devpts_mutex);
-
 	mutex_lock(&tty_mutex);
 	tty = tty_init_dev(ptm_driver, index);
 
@@ -659,7 +658,6 @@ out:
 	mutex_unlock(&tty_mutex);
 	devpts_kill_index(inode, index);
 err_file:
-        mutex_unlock(&devpts_mutex);
 	tty_free_file(filp);
 	return retval;
 }
