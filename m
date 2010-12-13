Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab0LMXq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 18:46:28 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23163 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab0LMXq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 18:46:27 -0500
Date: Tue, 14 Dec 2010 00:40:04 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: linux-raid@vger.kernel.org, dm-devel@redhat.com,
        Neil Brown <neilb@suse.de>
Subject: [PATCH][rfc] md: Close mem leak in userspace_ctr()
Message-ID: <alpine.LNX.2.00.1012140034300.26491@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There's a small memory leak in 
drivers/md/dm-log-userspace-base.c::userspace_ctr().

The call to build_constructor_string() dynamically allocates memory for 
its last argument, but we do not always clean up that allocated memory.
The patch below closes the leak and also removes some unneeded local 
variables and some pointless assignments.

If the patch looks good, please consider applying it - if not, please tell 
me where I messed up.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 dm-log-userspace-base.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

 Compile tested only.

diff --git a/drivers/md/dm-log-userspace-base.c b/drivers/md/dm-log-userspace-base.c
index 1ed0094..71a3049 100644
--- a/drivers/md/dm-log-userspace-base.c
+++ b/drivers/md/dm-log-userspace-base.c
@@ -99,26 +99,22 @@ static int build_constructor_string(struct dm_target *ti,
 				    char **ctr_str)
 {
 	int i, str_size;
-	char *str = NULL;
-
-	*ctr_str = NULL;
 
 	for (i = 0, str_size = 0; i < argc; i++)
 		str_size += strlen(argv[i]) + 1; /* +1 for space between args */
 
 	str_size += 20; /* Max number of chars in a printed u64 number */
 
-	str = kzalloc(str_size, GFP_KERNEL);
-	if (!str) {
+	*ctr_str = kzalloc(str_size, GFP_KERNEL);
+	if (!*ctr_str) {
 		DMWARN("Unable to allocate memory for constructor string");
 		return -ENOMEM;
 	}
 
-	str_size = sprintf(str, "%llu", (unsigned long long)ti->len);
+	str_size = sprintf(*ctr_str, "%llu", (unsigned long long)ti->len);
 	for (i = 0; i < argc; i++)
-		str_size += sprintf(str + str_size, " %s", argv[i]);
+		str_size += sprintf(*ctr_str + str_size, " %s", argv[i]);
 
-	*ctr_str = str;
 	return str_size;
 }
 
@@ -140,7 +136,7 @@ static int userspace_ctr(struct dm_dirty_log *log, struct dm_target *ti,
 {
 	int r = 0;
 	int str_size;
-	char *ctr_str = NULL;
+	char *ctr_str;
 	struct log_c *lc = NULL;
 	uint64_t rdata;
 	size_t rdata_size = sizeof(rdata);
@@ -173,6 +169,7 @@ static int userspace_ctr(struct dm_dirty_log *log, struct dm_target *ti,
 
 	str_size = build_constructor_string(ti, argc - 1, argv + 1, &ctr_str);
 	if (str_size < 0) {
+		kfree(ctr_str);
 		kfree(lc);
 		return str_size;
 	}



-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

