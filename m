Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738Ab2KVVv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:51:27 -0500
Received: from mail.kernel.org ([198.145.19.201]:49605 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754974Ab2KVSkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Vit Zahradka <vit.zahradka@tiscali.cz>,
        Sachin Prabhu <sprabhu@redhat.com>
Subject: [ 14/83] cifs: Do not lookup hashed negative dentry in cifs_atomic_open
Date: Wed, 21 Nov 2012 16:41:36 -0800
Message-Id: <20121122004214.037973534@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sachin Prabhu <sprabhu@redhat.com>

commit 3798f47aa276b332c30da499cb4df4577e2f8872 upstream.

We do not need to lookup a hashed negative directory since we have
already revalidated it before and have found it to be fine.

This also prevents a crash in cifs_lookup() when it attempts to rehash
the already hashed negative lookup dentry.

The patch has been tested using the reproducer at
https://bugzilla.redhat.com/show_bug.cgi?id=867344#c28

Reported-by: Vit Zahradka <vit.zahradka@tiscali.cz>
Signed-off-by: Sachin Prabhu <sprabhu@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/dir.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -392,7 +392,16 @@ cifs_atomic_open(struct inode *inode, st
 	 * in network traffic in the other paths.
 	 */
 	if (!(oflags & O_CREAT)) {
-		struct dentry *res = cifs_lookup(inode, direntry, 0);
+		struct dentry *res;
+
+		/*
+		 * Check for hashed negative dentry. We have already revalidated
+		 * the dentry and it is fine. No need to perform another lookup.
+		 */
+		if (!d_unhashed(direntry))
+			return -ENOENT;
+
+		res = cifs_lookup(inode, direntry, 0);
 		if (IS_ERR(res))
 			return PTR_ERR(res);
 


