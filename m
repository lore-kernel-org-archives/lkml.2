Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab1CEQwi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 11:52:38 -0500
Received: from smtp-03.mandic.com.br ([200.225.81.143]:53130 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab1CEQtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 11:49:19 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, Eric B Munson <emunson@mgebm.net>,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCHv2 15/24] sys_swapon: move setting of swapfilepages near use
Date: Sat,  5 Mar 2011 13:42:16 -0300
Message-Id: <1299343345-3984-16-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason I can see to read inode->i_size long before it is
needed. Move its read to just before it is needed, to reduce the
variable lifetime.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
---
 mm/swapfile.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 058cf1b..f3f413b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1975,8 +1975,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (unlikely(error))
 		goto bad_swap;
 
-	swapfilepages = i_size_read(inode) >> PAGE_SHIFT;
-
 	/*
 	 * Read the swap header.
 	 */
@@ -2045,6 +2043,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	error = -EINVAL;
 	if (!maxpages)
 		goto bad_swap;
+	swapfilepages = i_size_read(inode) >> PAGE_SHIFT;
 	if (swapfilepages && maxpages > swapfilepages) {
 		printk(KERN_WARNING
 		       "Swap area shorter than signature indicates\n");
-- 
1.7.4

