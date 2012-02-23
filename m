Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab2BWXkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 18:40:11 -0500
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:50114 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab2BWXkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 18:40:09 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Date: Thu, 23 Feb 2012 23:40:05 +0000 (GMT)
From: Anton Altaparmakov <aia21@cam.ac.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] Restore direct_io / truncate locking API
Message-ID: <Pine.LNX.4.64.1202232321390.1668@hermes-2.csi.cam.ac.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With kernel 3.1, Christoph removed i_alloc_sem and replaced it with calls 
(namely inode_dio_wait() and inode_dio_done()) which are 
EXPORT_SYMBOL_GPL() thus they cannot be used by non-GPL file systems and 
further inode_dio_wait() was pushed from notify_change() into the file 
system ->setattr() method but no non-GPL file system can make this call.

That means non-GPL file systems cannot exist any more unless they do not 
use any VFS functionality related to reading/writing as far as I can tell 
or at least as long as they want to implement direct i/o.

Both Linus and Al (and others) have said on LKML that this breakage of the
VFS API should not have happened and that the change was simply missed as
it was not documented in the change logs of the patches that did those 
changes.

This patch changes the two function exports in question to be 
EXPORT_SYMBOL() thus restoring the VFS API as it used to be - accessible 
for all modules.

Christoph, who introduced the two functions and exported them GPL-only is 
CC-ed on this patch to give him the opportunity to object to the symbols 
being changed in this manner if he did indeed intend them to be GPL-only 
and does not want them to become available to all modules.

Signed-off-by: Anton Altaparmakov <anton@tuxera.com>
CC: Christoph Hellwig <hch@infradead.org>
---

diff linux/fs/direct-io.c.old linux/fs/direct-io.c
--- linux/fs/direct-io.c.old	2012-02-23 23:20:26.000000000 +0000
+++ linux/fs/direct-io.c	2012-02-23 23:20:46.000000000 +0000
@@ -173,7 +173,7 @@ void inode_dio_wait(struct inode *inode)
 	if (atomic_read(&inode->i_dio_count))
 		__inode_dio_wait(inode);
 }
-EXPORT_SYMBOL_GPL(inode_dio_wait);
+EXPORT_SYMBOL(inode_dio_wait);
 
 /*
  * inode_dio_done - signal finish of a direct I/O requests
@@ -187,7 +187,7 @@ void inode_dio_done(struct inode *inode)
 	if (atomic_dec_and_test(&inode->i_dio_count))
 		wake_up_bit(&inode->i_state, __I_DIO_WAKEUP);
 }
-EXPORT_SYMBOL_GPL(inode_dio_done);
+EXPORT_SYMBOL(inode_dio_done);
 
 /*
  * How many pages are in the queue?
