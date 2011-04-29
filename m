Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933635Ab1D2TER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 15:04:17 -0400
Received: from kroah.org ([198.145.64.141]:50326 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933201Ab1D2S6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:33 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:55 2011
Message-Id: <20110429185655.670713778@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:55:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [32/55] UBIFS: fix false space checking failure
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

commit 8c230d9a5b5ec7970139acb7e2d165d7a3fe9f9e upstream.

This patch fixes UBIFS mount failure when the debugging support is enabled,
we are recovering from a power cut, we were first mounter R/O and we are
re-mounting R/W. In this case we should not assume that the amount of free
space before we have re-mounted R/W and after are equivalent, because
when we have mounted R/O the file-system is in a non-committed state so
the amount of free space is slightly smaller, due to the fact that we cannot
predict the amount of free space precisely before we commit.

This patch fixes the issue by skipping the debugging check in case of
recovery. This issue was reported by Caizhiyong <caizhiyong@huawei.com>
here: http://thread.gmane.org/gmane.linux.drivers.mtd/34350/focus=34387

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reported-by: Caizhiyong <caizhiyong@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ubifs/super.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1643,15 +1643,27 @@ static int ubifs_remount_rw(struct ubifs
 	if (err)
 		goto out;
 
+	dbg_gen("re-mounted read-write");
+	c->remounting_rw = 0;
+
 	if (c->need_recovery) {
 		c->need_recovery = 0;
 		ubifs_msg("deferred recovery completed");
+	} else {
+		/*
+		 * Do not run the debugging space check if the were doing
+		 * recovery, because when we saved the information we had the
+		 * file-system in a state where the TNC and lprops has been
+		 * modified in memory, but all the I/O operations (including a
+		 * commit) were deferred. So the file-system was in
+		 * "non-committed" state. Now the file-system is in committed
+		 * state, and of course the amount of free space will change
+		 * because, for example, the old index size was imprecise.
+		 */
+		err = dbg_check_space_info(c);
 	}
 
-	dbg_gen("re-mounted read-write");
-	c->remounting_rw = 0;
 	c->always_chk_crc = 0;
-	err = dbg_check_space_info(c);
 	mutex_unlock(&c->umount_mutex);
 	return err;
 


