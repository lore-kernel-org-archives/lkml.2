Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab0IPWP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:15:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514Ab0IPWP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:15:26 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 34/34] union-mount: Call union lookup functions in lookup path
Date: Thu, 16 Sep 2010 15:12:25 -0700
Message-Id: <1284675145-4391-35-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Union mounts hook into the lookup path in two places: do_lookup() and
lookup_hash().

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 7656442..bbce934 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -931,6 +931,11 @@ done:
 	path->mnt = mnt;
 	path->dentry = dentry;
 	__follow_mount(path);
+	if (needs_lookup_union(&nd->path, path)) {
+		int err = do_lookup_union(nd, name, path);
+		if (err < 0)
+			return err;
+	}
 	return 0;
 
 need_lookup:
@@ -1402,8 +1407,13 @@ static int lookup_hash(struct nameidata *nd, struct qstr *name,
 		err = PTR_ERR(path->dentry);
 		path->dentry = NULL;
 		path->mnt = NULL;
+		return err;
 	}
+
+	if (needs_lookup_union(&nd->path, path))
+		err = lookup_union(nd, name, path);
 	return err;
+
 }
 
 static int __lookup_one_len(const char *name, struct qstr *this,
-- 
1.6.3.3

