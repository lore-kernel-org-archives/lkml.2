Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab0I3SQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 14:16:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755736Ab0I3SQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 14:16:48 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 15/17] autofs4 - fix wait validation
To: viro@ftp.linux.org.uk, jmoyer@redhat.com
Cc: linux-fs@vger.kernel.org, autofs@linux.kernel.org,
        linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        Ian Kent <raven@themaw.net>, David Howells <dhowells@redhat.com>
Date: Thu, 30 Sep 2010 19:16:12 +0100
Message-ID: <20100930181612.30939.30493.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100930181455.30939.53914.stgit@warthog.procyon.org.uk>
References: <20100930181455.30939.53914.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Kent <raven@themaw.net>

It is possible for the check in wait.c:validate_request() to return
an incorrect result if the dentry that was mounted upon has changed
during the callback.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/autofs4/waitq.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index 2341375..f3792ff 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -296,6 +296,9 @@ static int validate_request(struct autofs_wait_queue **wait,
 	 * completed while we waited on the mutex ...
 	 */
 	if (notify == NFY_MOUNT) {
+		struct dentry *new = NULL;
+		int valid = 1;
+
 		/*
 		 * If the dentry was successfully mounted while we slept
 		 * on the wait queue mutex we can return success. If it
@@ -303,8 +306,20 @@ static int validate_request(struct autofs_wait_queue **wait,
 		 * a multi-mount with no mount at it's base) we can
 		 * continue on and create a new request.
 		 */
+		if (!IS_ROOT(dentry)) {
+			if (dentry->d_inode && d_unhashed(dentry)) {
+				struct dentry *parent = dentry->d_parent;
+				new = d_lookup(parent, &dentry->d_name);
+				if (new)
+					dentry = new;
+			}
+		}
 		if (have_submounts(dentry))
-			return 0;
+			valid = 0;
+
+		if (new)
+			dput(new);
+		return valid;
 	}
 
 	return 1;

