Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab1CEQyJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 11:54:09 -0500
Received: from smtp-03.mandic.com.br ([200.225.81.143]:40529 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab1CEQtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 11:49:18 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, Eric B Munson <emunson@mgebm.net>,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCHv2 06/24] sys_swapon: simplify error flow in alloc_swap_info
Date: Sat,  5 Mar 2011 13:42:07 -0300
Message-Id: <1299343345-3984-7-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since there is no cleanup to do, there is no reason to jump to a label.
Return directly instead.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
---
 mm/swapfile.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 8969b37..c97dc4b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1848,7 +1848,6 @@ static struct swap_info_struct *alloc_swap_info(void)
 {
 	struct swap_info_struct *p;
 	unsigned int type;
-	int error;
 
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
@@ -1859,11 +1858,10 @@ static struct swap_info_struct *alloc_swap_info(void)
 		if (!(swap_info[type]->flags & SWP_USED))
 			break;
 	}
-	error = -EPERM;
 	if (type >= MAX_SWAPFILES) {
 		spin_unlock(&swap_lock);
 		kfree(p);
-		goto out;
+		return ERR_PTR(-EPERM);
 	}
 	if (type >= nr_swapfiles) {
 		p->type = type;
@@ -1889,9 +1887,6 @@ static struct swap_info_struct *alloc_swap_info(void)
 	spin_unlock(&swap_lock);
 
 	return p;
-
-out:
-	return ERR_PTR(error);
 }
 
 SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
-- 
1.7.4

