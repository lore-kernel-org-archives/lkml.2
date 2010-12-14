Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512Ab0LNAkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 19:40:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57729 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757363Ab0LNAkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 19:40:42 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=6sVpSMvxGZgA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=drOt6m5kAAAA:8 a=meVymXHHAAAA:8 a=_7-9dzRnF07IyCrmLXsA:9 a=da6W7PgZysJu5_Ao4e-1JRpbcugA:4 a=jEp0ucaQiEUA:10 a=oUQuMaGMe1cA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101214004040.586626794@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 19:38:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] fs: Remove unlikely() from fget_light()
References: <20101214003807.693481687@goodmis.org>
Content-Disposition: inline; filename=0002-fs-Remove-unlikely-from-fget_light.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

There's an unlikely() in fget_light() that assumes the file ref count
will be 1. Running the annotate branch profiler on a desktop that is
performing daily tasks (running firefox, evolution, xchat and is also part
of a distcc farm), it shows that the ref count is not 1 that often.

 correct incorrect      %    Function                  File              Line
 ------- ---------      -    --------                  ----              ----
1035099358 6209599193  85    fget_light              file_table.c         315

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/file_table.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index c3dee38..c3e89ad 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -311,7 +311,7 @@ struct file *fget_light(unsigned int fd, int *fput_needed)
 	struct files_struct *files = current->files;
 
 	*fput_needed = 0;
-	if (likely((atomic_read(&files->count) == 1))) {
+	if (atomic_read(&files->count) == 1) {
 		file = fcheck_files(files, fd);
 	} else {
 		rcu_read_lock();
-- 
1.7.2.3


