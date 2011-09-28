Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623Ab1I1WoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:44:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54270 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911Ab1I1WoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:44:03 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:35 2011
Message-Id: <20110928220135.674048151@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jim Garlick <garlick@llnl.gov>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Harsh Prateek Bora <harsh@linux.vnet.ibm.com>
Subject: [098/244] fs/9p: Use protocol-defined value for lock/getlock type field.
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jim Garlick <garlick.jim@gmail.com>

commit 51b8b4fb32271d39fbdd760397406177b2b0fd36 upstream.

Signed-off-by: Jim Garlick <garlick@llnl.gov>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Harsh Prateek Bora <harsh@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/9p/vfs_file.c    |   34 +++++++++++++++++++++++++++-------
 include/net/9p/9p.h |    5 +++++
 2 files changed, 32 insertions(+), 7 deletions(-)

--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -169,7 +169,18 @@ static int v9fs_file_do_lock(struct file
 
 	/* convert posix lock to p9 tlock args */
 	memset(&flock, 0, sizeof(flock));
-	flock.type = fl->fl_type;
+	/* map the lock type */
+	switch (fl->fl_type) {
+	case F_RDLCK:
+		flock.type = P9_LOCK_TYPE_RDLCK;
+		break;
+	case F_WRLCK:
+		flock.type = P9_LOCK_TYPE_WRLCK;
+		break;
+	case F_UNLCK:
+		flock.type = P9_LOCK_TYPE_UNLCK;
+		break;
+	}
 	flock.start = fl->fl_start;
 	if (fl->fl_end == OFFSET_MAX)
 		flock.length = 0;
@@ -245,7 +256,7 @@ static int v9fs_file_getlock(struct file
 
 	/* convert posix lock to p9 tgetlock args */
 	memset(&glock, 0, sizeof(glock));
-	glock.type = fl->fl_type;
+	glock.type  = P9_LOCK_TYPE_UNLCK;
 	glock.start = fl->fl_start;
 	if (fl->fl_end == OFFSET_MAX)
 		glock.length = 0;
@@ -257,17 +268,26 @@ static int v9fs_file_getlock(struct file
 	res = p9_client_getlock_dotl(fid, &glock);
 	if (res < 0)
 		return res;
-	if (glock.type != F_UNLCK) {
-		fl->fl_type = glock.type;
+	/* map 9p lock type to os lock type */
+	switch (glock.type) {
+	case P9_LOCK_TYPE_RDLCK:
+		fl->fl_type = F_RDLCK;
+		break;
+	case P9_LOCK_TYPE_WRLCK:
+		fl->fl_type = F_WRLCK;
+		break;
+	case P9_LOCK_TYPE_UNLCK:
+		fl->fl_type = F_UNLCK;
+		break;
+	}
+	if (glock.type != P9_LOCK_TYPE_UNLCK) {
 		fl->fl_start = glock.start;
 		if (glock.length == 0)
 			fl->fl_end = OFFSET_MAX;
 		else
 			fl->fl_end = glock.start + glock.length - 1;
 		fl->fl_pid = glock.proc_id;
-	} else
-		fl->fl_type = F_UNLCK;
-
+	}
 	return res;
 }
 
--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -344,6 +344,11 @@ enum p9_qid_t {
 /* Room for readdir header */
 #define P9_READDIRHDRSZ	24
 
+/* 9p2000.L lock type */
+#define P9_LOCK_TYPE_RDLCK 0
+#define P9_LOCK_TYPE_WRLCK 1
+#define P9_LOCK_TYPE_UNLCK 2
+
 /**
  * struct p9_str - length prefixed string type
  * @len: length of the string


