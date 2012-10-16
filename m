Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab2JPBqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 21:46:50 -0400
Received: from noserose.net ([66.220.18.76]:43875 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755542Ab2JPBqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 21:46:49 -0400
Date: Mon, 15 Oct 2012 18:46:43 -0700
Message-Id: <39cacfd76d5a79a894fb0227edf341474de5977e.1350331035.git.ecashin@coraid.com>
In-Reply-To: <cover.1350331035.git.ecashin@coraid.com>
References: <cover.1350331035.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 4/9] aoe: support the forgetting (flushing) of a user-specified AoE target
To: akpm@linux-foundation.org
Cc: ecashin@coraid.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Users sometimes want to cause the aoe driver to forget a
particular previously discovered device when it is no longer
online.  The aoetools provide an "aoe-flush" command that users
run to perform this administrative task.  The changes below
provide the support needed in the driver.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoedev.c |   44 ++++++++++++++++++++++++++++++++++++++------
 1 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index 90e5b53..63b2660 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -241,6 +241,30 @@ aoedev_freedev(struct aoedev *d)
 	kfree(d);
 }
 
+/* return whether the user asked for this particular
+ * device to be flushed
+ */
+static int
+user_req(char *s, size_t slen, struct aoedev *d)
+{
+	char *p;
+	size_t lim;
+
+	if (!d->gd)
+		return 0;
+	p = strrchr(d->gd->disk_name, '/');
+	if (!p)
+		p = d->gd->disk_name;
+	else
+		p += 1;
+	lim = sizeof(d->gd->disk_name);
+	lim -= p - d->gd->disk_name;
+	if (slen < lim)
+		lim = slen;
+
+	return !strncmp(s, p, lim);
+}
+
 int
 aoedev_flush(const char __user *str, size_t cnt)
 {
@@ -249,6 +273,7 @@ aoedev_flush(const char __user *str, size_t cnt)
 	struct aoedev *rmd = NULL;
 	char buf[16];
 	int all = 0;
+	int specified = 0;	/* flush a specific device */
 
 	if (cnt >= 3) {
 		if (cnt > sizeof buf)
@@ -256,26 +281,33 @@ aoedev_flush(const char __user *str, size_t cnt)
 		if (copy_from_user(buf, str, cnt))
 			return -EFAULT;
 		all = !strncmp(buf, "all", 3);
+		if (!all)
+			specified = 1;
 	}
 
 	spin_lock_irqsave(&devlist_lock, flags);
 	dd = &devlist;
 	while ((d = *dd)) {
 		spin_lock(&d->lock);
-		if ((!all && (d->flags & DEVFL_UP))
+		if (specified) {
+			if (!user_req(buf, cnt, d))
+				goto skip;
+		} else if ((!all && (d->flags & DEVFL_UP))
 		|| (d->flags & (DEVFL_GDALLOC|DEVFL_NEWSIZE))
 		|| d->nopen
-		|| d->ref) {
-			spin_unlock(&d->lock);
-			dd = &d->next;
-			continue;
-		}
+		|| d->ref)
+			goto skip;
+
 		*dd = d->next;
 		aoedev_downdev(d);
 		d->flags |= DEVFL_TKILL;
 		spin_unlock(&d->lock);
 		d->next = rmd;
 		rmd = d;
+		continue;
+skip:
+		spin_unlock(&d->lock);
+		dd = &d->next;
 	}
 	spin_unlock_irqrestore(&devlist_lock, flags);
 	while ((d = rmd)) {
-- 
1.7.1

