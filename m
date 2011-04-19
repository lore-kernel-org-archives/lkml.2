Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab1DSUQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:16:51 -0400
Received: from kroah.org ([198.145.64.141]:47544 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128Ab1DSUQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:16:50 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:43 2011
Message-Id: <20110419201043.708049479@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [05/70] cifs: check for private_data before trying to put it
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 7797069305d13252fd66cf722aa8f2cbeb3c95cd upstream.

cifs_close doesn't check that the filp->private_data is non-NULL before
trying to put it. That can cause an oops in certain error conditions
that can occur on open or lookup before the private_data is set.

Reported-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/file.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -575,8 +575,10 @@ reopen_error_exit:
 
 int cifs_close(struct inode *inode, struct file *file)
 {
-	cifsFileInfo_put(file->private_data);
-	file->private_data = NULL;
+	if (file->private_data != NULL) {
+		cifsFileInfo_put(file->private_data);
+		file->private_data = NULL;
+	}
 
 	/* return code from the ->release op is always ignored */
 	return 0;


