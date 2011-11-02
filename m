Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934948Ab1KCBnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:43:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51527 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934878Ab1KCBnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:43:14 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:48 2011
Message-Id: <20111102222748.365822355@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:27:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [094/101] scm: lower SCM_MAX_FD
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

commit bba14de98753cb6599a2dae0e520714b2153522d upstream.

Lower SCM_MAX_FD from 255 to 253 so that allocations for scm_fp_list are
halved. (commit f8d570a4 added two pointers in this structure)

scm_fp_dup() should not copy whole structure (and trigger kmemcheck
warnings), but only the used part. While we are at it, only allocate
needed size.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/net/scm.h |    5 +++--
 net/core/scm.c    |   10 ++++++----
 2 files changed, 9 insertions(+), 6 deletions(-)

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
 
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -78,10 +78,11 @@ static int scm_fp_copy(struct cmsghdr *c
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
@@ -302,11 +303,12 @@ struct scm_fp_list *scm_fp_dup(struct sc
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


