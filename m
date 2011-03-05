Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab1CEQtX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 11:49:23 -0500
Received: from smtp-03.mandic.com.br ([200.225.81.143]:52430 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab1CEQtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 11:49:18 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, Eric B Munson <emunson@mgebm.net>,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCHv2 04/24] sys_swapon: separate swap_info allocation
Date: Sat,  5 Mar 2011 13:42:05 -0300
Message-Id: <1299343345-3984-5-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the swap_info allocation to its own function. Only code movement,
no functional changes.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
---
 mm/swapfile.c |   57 +++++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 37 insertions(+), 20 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 3ef2d67..91ca0f0 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1844,33 +1844,15 @@ static int __init max_swapfiles_check(void)
 late_initcall(max_swapfiles_check);
 #endif
 
-SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
+static struct swap_info_struct *alloc_swap_info(void)
 {
 	struct swap_info_struct *p;
-	char *name = NULL;
-	struct block_device *bdev = NULL;
-	struct file *swap_file = NULL;
-	struct address_space *mapping;
 	unsigned int type;
-	int i, prev;
 	int error;
-	union swap_header *swap_header;
-	unsigned int nr_good_pages;
-	int nr_extents = 0;
-	sector_t span;
-	unsigned long maxpages;
-	unsigned long swapfilepages;
-	unsigned char *swap_map = NULL;
-	struct page *page = NULL;
-	struct inode *inode = NULL;
-	int did_down = 0;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	spin_lock(&swap_lock);
 	for (type = 0; type < nr_swapfiles; type++) {
@@ -1906,6 +1888,41 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	p->next = -1;
 	spin_unlock(&swap_lock);
 
+	return p;
+
+out:
+	return ERR_PTR(error);
+}
+
+SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
+{
+	struct swap_info_struct *p;
+	char *name = NULL;
+	struct block_device *bdev = NULL;
+	struct file *swap_file = NULL;
+	struct address_space *mapping;
+	int i, prev;
+	int error;
+	union swap_header *swap_header;
+	unsigned int nr_good_pages;
+	int nr_extents = 0;
+	sector_t span;
+	unsigned long maxpages;
+	unsigned long swapfilepages;
+	unsigned char *swap_map = NULL;
+	struct page *page = NULL;
+	struct inode *inode = NULL;
+	int did_down = 0;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	p = alloc_swap_info();
+	if (IS_ERR(p)) {
+		error = PTR_ERR(p);
+		goto out;
+	}
+
 	name = getname(specialfile);
 	error = PTR_ERR(name);
 	if (IS_ERR(name)) {
-- 
1.7.4

