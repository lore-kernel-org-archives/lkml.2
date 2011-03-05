Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab1CEQxf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 11:53:35 -0500
Received: from smtp-03.mandic.com.br ([200.225.81.143]:37158 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab1CEQtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 11:49:18 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, Eric B Munson <emunson@mgebm.net>,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCHv2 09/24] sys_swapon: remove did_down variable
Date: Sat,  5 Mar 2011 13:42:10 -0300
Message-Id: <1299343345-3984-10-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since mutex_lock(&inode->i_mutex) is called just after setting inode,
did_down is always equivalent to (inode && S_ISREG(inode->i_mode)).

Use this fact to remove the did_down variable.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
---
 mm/swapfile.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 55a50ef..c655389 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1907,7 +1907,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	unsigned char *swap_map = NULL;
 	struct page *page = NULL;
 	struct inode *inode = NULL;
-	int did_down = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -1962,7 +1961,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	} else if (S_ISREG(inode->i_mode)) {
 		p->bdev = inode->i_sb->s_bdev;
 		mutex_lock(&inode->i_mutex);
-		did_down = 1;
 		if (IS_SWAPFILE(inode)) {
 			error = -EBUSY;
 			goto bad_swap;
@@ -2163,7 +2161,7 @@ out:
 	}
 	if (name)
 		putname(name);
-	if (did_down) {
+	if (inode && S_ISREG(inode->i_mode)) {
 		if (!error)
 			inode->i_flags |= S_SWAPFILE;
 		mutex_unlock(&inode->i_mutex);
-- 
1.7.4

