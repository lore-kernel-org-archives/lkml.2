Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707Ab2LMOJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:09:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44633 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623Ab2LMOJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:09:10 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 136/241] md/raid10: decrement correct pending counter when writing to replacement.
Date: Thu, 13 Dec 2012 11:58:21 -0200
Message-Id: <1355407206-17100-137-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 884162df2aadd7414bef4935e1a54976fd4e3988 upstream.

When a write to a replacement device completes, we carefully
and correctly found the rdev that the write actually went to
and the blithely called rdev_dec_pending on the primary rdev,
even if this write was to the replacement.

This means that any writes to an array while a replacement
was ongoing would cause the nr_pending count for the primary
device to go negative, so it could never be removed.

This bug has been present since replacement was introduced in
3.3, so it is suitable for any -stable kernel since then.

Reported-by: "George Spelvin" <linux@horizon.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/md/raid10.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0920adf..e97d046 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -485,7 +485,7 @@ static void raid10_end_write_request(struct bio *bio, int error)
 	 */
 	one_write_done(r10_bio);
 	if (dec_rdev)
-		rdev_dec_pending(conf->mirrors[dev].rdev, conf->mddev);
+		rdev_dec_pending(rdev, conf->mddev);
 }
 
 /*
-- 
1.7.9.5

