Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab1HHLTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 07:19:42 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:53575 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546Ab1HHLSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 07:18:15 -0400
From: Julia Lawall <julia@diku.dk>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: kernel-janitors@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        Stefan Weinhuber <wein@de.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] drivers/s390/block/dasd_ioctl.c: add missing kfree
Date: Mon,  8 Aug 2011 13:17:59 +0200
Message-Id: <1312802283-9107-5-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Data is only used to temporarily hold information to be copied to the user
level, so it should be freed before leaving the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@exists@
local idexpression x;
statement S,S1;
expression E;
identifier fl;
expression *ptr != NULL;
@@

x = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...kfree(x)...+> }
     when any
     when != true x == NULL
x->fl
...>
(
if (x == NULL) S1
|
if (...) { ... when != x
               when forall
(
 return \(0\|<+...x...+>\|ptr\);
|
* return ...;
)
}
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/s390/block/dasd_ioctl.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/block/dasd_ioctl.c b/drivers/s390/block/dasd_ioctl.c
index eb4e034..753636f 100644
--- a/drivers/s390/block/dasd_ioctl.c
+++ b/drivers/s390/block/dasd_ioctl.c
@@ -249,6 +249,7 @@ static int dasd_ioctl_reset_profile(struct dasd_block *block)
 static int dasd_ioctl_read_profile(struct dasd_block *block, void __user *argp)
 {
 	struct dasd_profile_info_t *data;
+	int ret = 0;
 
 	data = kmalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
@@ -279,11 +280,14 @@ static int dasd_ioctl_read_profile(struct dasd_block *block, void __user *argp)
 		spin_unlock_bh(&block->profile.lock);
 	} else {
 		spin_unlock_bh(&block->profile.lock);
-		return -EIO;
+		ret = -EIO;
+		goto out;
 	}
 	if (copy_to_user(argp, data, sizeof(*data)))
-		return -EFAULT;
-	return 0;
+		ret = -EFAULT;
+out:
+	kfree(data);
+	return ret;
 }
 #else
 static int dasd_ioctl_reset_profile(struct dasd_block *block)

