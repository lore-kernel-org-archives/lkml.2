Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab0JQOwG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 10:52:06 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42424 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757117Ab0JQOwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 10:52:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bqzlrcazphjWbo7S9UQ05gCqk7OrTTs4qoUZRYZ9i/0/rCc2OpnsMNm1LYUC3UNVHv
         hXv337KXH+IkXxvfjC5d8dKTgaBMBo+/Zx2cWiXU6fDI/H2iYCpDxGZ2xlLiIjwpRlJ7
         W7jN++XjgctGctNDt4YCF2AsVNFR2Jgbcl4Jo=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, William Hubbs <w.d.hubbs@gmail.com>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: speakup: fix memory leak
Date: Sun, 17 Oct 2010 18:51:57 +0400
Message-Id: <1287327118-9244-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

speakup_init() didn't free first_console if speakup_kobj_init() fails.
Also propagate speakup_kobj_init()'s return code.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 drivers/staging/speakup/main.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/speakup/main.c b/drivers/staging/speakup/main.c
index 2ef3b39..b02a61f 100644
--- a/drivers/staging/speakup/main.c
+++ b/drivers/staging/speakup/main.c
@@ -2255,8 +2255,11 @@ static int __init speakup_init(void)
 	first_console = kzalloc(sizeof(*first_console), GFP_KERNEL);
 	if (!first_console)
 		return -ENOMEM;
-	if (speakup_kobj_init() < 0) 
-		return -ENOMEM;
+	err = speakup_kobj_init();
+	if (err) {
+		kfree(first_console);
+		return err;
+	}
 
 	reset_default_chars();
 	reset_default_chartab();
-- 
1.7.0.4

