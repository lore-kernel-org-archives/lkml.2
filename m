Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab2HOUPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:15:32 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62990 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756785Ab2HOTvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:51:24 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 099/165] scm: lower SCM_MAX_FD
Date: Wed, 15 Aug 2012 15:47:23 -0400
Message-ID: <1345060109-9187-100-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit bba14de98753cb6599a2dae0e520714b2153522d upstream.

Lower SCM_MAX_FD from 255 to 253 so that allocations for scm_fp_list are
halved. (commit f8d570a4 added two pointers in this structure)

scm_fp_dup() should not copy whole structure (and trigger kmemcheck
warnings), but only the used part. While we are at it, only allocate
needed size.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/net/scm.h |  5 +++--
 net/core/scm.c    | 10 ++++++----
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/include/net/scm.h b/include/net/scm.h
index 8360e47..8b5cccd 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -10,11 +10,12 @@
 /* Well, we should have at least one descriptor open
  * to accept passed FDs 8)
  */
-#define SCM_MAX_FD	255
+#define SCM_MAX_FD	253
 
 struct scm_fp_list {
 	struct list_head	list;
-	int			count;
+	short			count;
+	short			max;
 	struct file		*fp[SCM_MAX_FD];
 };
 
diff --git a/net/core/scm.c b/net/core/scm.c
index b88f6f9..ddc0448 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -79,10 +79,11 @@ static int scm_fp_copy(struct cmsghdr *cmsg, struct scm_fp_list **fplp)
 			return -ENOMEM;
 		*fplp = fpl;
 		fpl->count = 0;
+		fpl->max = SCM_MAX_FD;
 	}
 	fpp = &fpl->fp[fpl->count];
 
-	if (fpl->count + num > SCM_MAX_FD)
+	if (fpl->count + num > fpl->max)
 		return -EINVAL;
 
 	/*
@@ -303,11 +304,12 @@ struct scm_fp_list *scm_fp_dup(struct scm_fp_list *fpl)
 	if (!fpl)
 		return NULL;
 
-	new_fpl = kmalloc(sizeof(*fpl), GFP_KERNEL);
+	new_fpl = kmemdup(fpl, offsetof(struct scm_fp_list, fp[fpl->count]),
+			  GFP_KERNEL);
 	if (new_fpl) {
-		for (i=fpl->count-1; i>=0; i--)
+		for (i = 0; i < fpl->count; i++)
 			get_file(fpl->fp[i]);
-		memcpy(new_fpl, fpl, sizeof(*fpl));
+		new_fpl->max = new_fpl->count;
 	}
 	return new_fpl;
 }
-- 
1.7.12.rc2

