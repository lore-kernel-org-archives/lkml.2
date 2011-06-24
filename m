Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab1FXFEM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 01:04:12 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39119 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab1FXFEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 01:04:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=nt/blvH/bZz/h1qJHhvyZ4vT7uBHevaJa0WihC/+vT1XkjKAlWbHdXqWHtRKK1/45i
         JLN6F8pwmof1gqobqR1cBmu7bmL4z4mzmsyrs/Tmkn2LrmQF1EI8iKnUMTpugmNtagv9
         TAROrm3kMdHTs7mzcVDDAVHiui9cvtvXK5eLs=
From: Namhyung Kim <namhyung@gmail.com>
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] md/raid5: fix possible NULL pointer dereference in debug routine
Date: Fri, 24 Jun 2011 14:04:00 +0900
Message-Id: <1308891840-5683-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I ran dynamic debug, I encountered a NULL pointer dereference
bug in add_stripe_bio(). Prior to second call to pr_debug(), @bi
was reused in order to check whether the request is partial write
or not, and it could lead to set @bi to NULL.

Since we save original @bi pointer into local variable 'bip', use
it instead of NULL-able @bi.

Also changed confusing 'bh' to 'bi' in the first message.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/md/raid5.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 82c07fb38961..c814a6075c79 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2139,7 +2139,7 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 	raid5_conf_t *conf = sh->raid_conf;
 	int firstwrite=0;
 
-	pr_debug("adding bh b#%llu to stripe s#%llu\n",
+	pr_debug("adding bi b#%llu to stripe s#%llu\n",
 		(unsigned long long)bi->bi_sector,
 		(unsigned long long)sh->sector);
 
@@ -2181,7 +2181,7 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 	spin_unlock_irq(&conf->device_lock);
 
 	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
-		(unsigned long long)bi->bi_sector,
+		(unsigned long long)(*bip)->bi_sector,
 		(unsigned long long)sh->sector, dd_idx);
 
 	if (conf->mddev->bitmap && firstwrite) {
-- 
1.7.5.2

