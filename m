Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab0IESc1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 14:32:27 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46186 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab0IEScZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 14:32:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=sr4nhTp8ilbvRaC0o3jKAylJx+rbj64sYYA0xAVYrUlC6ohizUBjQN8/cn/OLmhV3T
         0zOxrWU+19Q4tg+bgkjtQpvDHYgXFYGtjK0mt4CcvpOQUu+7pfmxEFkLcO6bAttxsFos
         5Tf3Gy2rctCnMLhf22SO0TOcVjnJT8DuvCRdE=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Vasiliy Kulikov <segooon@gmail.com>, Neil Brown <neilb@suse.de>,
        Jens Axboe <jaxboe@fusionio.com>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] md: do not use ++ in rcu_dereference() argument
Date: Sun,  5 Sep 2010 22:32:18 +0400
Message-Id: <1283711539-7123-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segooon@gmail.com>

rcu_dereference() is macro, so it might use its argument twice.
Argument must not has side effects.

It was found by compiler warning:
drivers/md/raid1.c: In function ‘read_balance’:
drivers/md/raid1.c:445: warning: operation on ‘new_disk’ may be undefined

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 drivers/md/raid1.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index ad83a4d..12194df 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -442,7 +442,7 @@ static int read_balance(conf_t *conf, r1bio_t *r1_bio)
 		     r1_bio->bios[new_disk] == IO_BLOCKED ||
 		     !rdev || !test_bit(In_sync, &rdev->flags)
 			     || test_bit(WriteMostly, &rdev->flags);
-		     rdev = rcu_dereference(conf->mirrors[++new_disk].rdev)) {
+		     rdev = rcu_dereference(conf->mirrors[new_disk].rdev)) {
 
 			if (rdev && test_bit(In_sync, &rdev->flags) &&
 				r1_bio->bios[new_disk] != IO_BLOCKED)
@@ -452,6 +452,7 @@ static int read_balance(conf_t *conf, r1bio_t *r1_bio)
 				new_disk = wonly_disk;
 				break;
 			}
+			new_disk++;
 		}
 		goto rb_out;
 	}
-- 
1.7.0.4

