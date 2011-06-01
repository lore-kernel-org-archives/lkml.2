Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079Ab1FAOxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 10:53:33 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:35158 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757405Ab1FAOxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 10:53:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BDIyRJFQbqY+E1vLZRAQjW2h1KWY70nyaSECf1ZPmEKonMB5RRBhlD8f7jcFr4sSFw
         Qbf18CACC31v4qFPFObB77kJCw7UW4jvq768t881nlm4x2UZNHKBmwY2JgI4Apdys5vc
         qEfxHecexAm3tHbUKjEeAFs0fqlSMG01VexVQ=
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Matthew L. Creech" <mlcreech@gmail.com>
Subject: [PATCH] UBIFS: fixup merged 'UBIFS: fix-up free space earlier'
Date: Wed,  1 Jun 2011 10:53:28 -0400
Message-Id: <1306940008-28454-1-git-send-email-bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1306923407.4405.94.camel@localhost>
References: <1306923407.4405.94.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the patch 'UBIFS: intialize LPT earlier' was massaged before being applied
the context of the next patch 'UBIFS: fix-up free space earlier' was muddled
sufficiently for the order of allocate-lpt then free-space-fixup was reversed --
I think.

Put the free-space-fixup after allocate-lpt.

Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>

---
With this fixup applied on-top-of the ubifs-2.6 master I am able to mount a
ubinized image containing a UBIFS volume which has the free-space-fixup flag
set. No assertions are displayed.

---
 fs/ubifs/super.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 4722f31..70e8c92 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1284,12 +1284,6 @@ static int mount_ubifs(struct ubifs_info *c)
 
 	init_constants_master(c);
 
-	if (!c->ro_mount && c->space_fixup) {
-		err = ubifs_fixup_free_space(c);
-		if (err)
-			goto out_infos;
-	}
-
 	if ((c->mst_node->flags & cpu_to_le32(UBIFS_MST_DIRTY)) != 0) {
 		ubifs_msg("recovery needed");
 		c->need_recovery = 1;
@@ -1305,6 +1299,12 @@ static int mount_ubifs(struct ubifs_info *c)
 	if (err)
 		goto out_master;
 
+	if (!c->ro_mount && c->space_fixup) {
+		err = ubifs_fixup_free_space(c);
+		if (err)
+			goto out_master;
+	}
+
 	if (!c->ro_mount) {
 		/*
 		 * Set the "dirty" flag so that if we reboot uncleanly we
-- 
1.7.4.1

