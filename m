Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761211Ab0J1Vcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:32:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934544Ab0J1VcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:32:24 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 08/20] fanotify: ignore fanotify ignore marks if open writers
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agruen@suse.de, tvrtko.ursulin@sophos.com
Date: Thu, 28 Oct 2010 17:32:20 -0400
Message-ID: <20101028213220.24810.72673.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
References: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fanotify will clear ignore marks if a task changes the contents of an
inode.  The problem is with the races around when userspace finishes
checking a file and when that result is actually attached to the inode.
This race was described as such:

Consider the following scenario with hostile processes A and B, and
victim process C:
1. Process A opens new file for writing. File check request is generated.
2. File check is performed in userspace. Check result is "file has no malware".
3. The "permit" response is delivered to kernel space.
4. File ignored mark set.
5. Process A writes dummy bytes to the file. File ignored flags are cleared.
6. Process B opens the same file for reading. File check request is generated.
7. File check is performed in userspace. Check result is "file has no malware".
8. Process A writes malware bytes to the file. There is no cached response yet.
9. The "permit" response is delivered to kernel space and is cached in fanotify.
10. File ignored mark set.
11. Now any process C will be permitted to open the malware file.
There is a race between steps 8 and 10

While fanotify makes no strong guarantees about systems with hostile
processes there is no reason we cannot harden against this race.  We do
that by simply ignoring any ignore marks if the inode has open writers (aka
i_writecount > 0).  (We actually do not ignore ignore marks if the
FAN_MARK_SURV_MODIFY flag is set)

Reported-by: Vasily Novikov <vasily.novikov@kaspersky.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fanotify/fanotify_user.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 1c09e63..b265936 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -610,6 +610,16 @@ static int fanotify_add_inode_mark(struct fsnotify_group *group,
 
 	pr_debug("%s: group=%p inode=%p\n", __func__, group, inode);
 
+	/*
+	 * If some other task has this inode open for write we should not add
+	 * an ignored mark, unless that ignored mark is supposed to survive
+	 * modification changes anyway.
+	 */
+	if ((flags & FAN_MARK_IGNORED_MASK) &&
+	    !(flags & FAN_MARK_IGNORED_SURV_MODIFY) &&
+	    (atomic_read(&inode->i_writecount) > 0))
+		return 0;
+
 	fsn_mark = fsnotify_find_inode_mark(group, inode);
 	if (!fsn_mark) {
 		int ret;

