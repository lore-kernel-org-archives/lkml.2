Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933336Ab1FAKLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 06:11:17 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43397 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933302Ab1FAKLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 06:11:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HxoJ8EKpHKw0fyvc0nRHbdh0xkcwiX8qorjI0qT0wLnO8W/HEj0jW1Qd1/ZIA1MUvU
         2YSgHZOxWOk5wbZNnKWxSpFnpvhUVQ+Mwl83vEYQ6EzKPOojHnpMBWlpX+Cz76z+AgbI
         xkxbjLCZt3qwa/3cYcXwFQGsLywI5CND8Yqnc=
Subject: Re: [PATCH 2/3] UBIFS: intialize the LPT earlier
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ben Gardiner <bengardiner@nanometrics.ca>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Matthew L. Creech" <mlcreech@gmail.com>
In-Reply-To: <e0fb2d40ab7314049654d85b86a4c27e9a1801ef.1306780983.git.bengardiner@nanometrics.ca>
References: <cover.1306780983.git.bengardiner@nanometrics.ca>
	 <e0fb2d40ab7314049654d85b86a4c27e9a1801ef.1306780983.git.bengardiner@nanometrics.ca>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 13:06:50 +0300
Message-ID: <1306922810.4405.91.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

thanks for the patch, however

On Mon, 2011-05-30 at 14:56 -0400, Ben Gardiner wrote: 
> +	err = ubifs_lpt_init(c, 1, !c->ro_mount);
> +	if (err)
> +		goto out_lpt;

You cannot call ubifs_lpt_init()

> +
>  	if ((c->mst_node->flags & cpu_to_le32(UBIFS_MST_DIRTY)) != 0) {
>  		ubifs_msg("recovery needed");
>  		c->need_recovery = 1;
>  		if (!c->ro_mount) {
>  			err = ubifs_recover_inl_heads(c, c->sbuf);

Before ubifs_recover_inl_heads() is called in case of dirty FS.

I've massaged your patch and pushed the following analogous patch to the
ubifs tree, please check/test:



>From 678ef9ad3daa453723f04f84f9db6a22994e7343 Mon Sep 17 00:00:00 2001
From: Ben Gardiner <bengardiner@nanometrics.ca>
Date: Mon, 30 May 2011 14:56:15 -0400
Subject: [PATCH] UBIFS: intialize LPT earlier

The current 'mount_ubifs()' implementation does not initialize the LPT until the
the master node is marked dirty. Move the LPT initialization to before marking
the master node dirty. This is a preparation for the next patch which will move
the free-space-fixup check to before marking the master node dirty, because we
have to fix-up the free space before doing any writes.

Artem: massaged the patch and commit message.

Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/super.c |   29 ++++++++++++++++-------------
 1 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 1e40db7..6d357fd 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1282,17 +1282,24 @@ static int mount_ubifs(struct ubifs_info *c)
 	if (err)
 		goto out_master;
 
-	init_constants_master(c);
-
 	if ((c->mst_node->flags & cpu_to_le32(UBIFS_MST_DIRTY)) != 0) {
 		ubifs_msg("recovery needed");
 		c->need_recovery = 1;
-		if (!c->ro_mount) {
-			err = ubifs_recover_inl_heads(c, c->sbuf);
-			if (err)
-				goto out_master;
-		}
-	} else if (!c->ro_mount) {
+	}
+
+	init_constants_master(c);
+
+	if (c->need_recovery && !c->ro_mount) {
+		err = ubifs_recover_inl_heads(c, c->sbuf);
+		if (err)
+			goto out_master;
+	}
+
+	err = ubifs_lpt_init(c, 1, !c->ro_mount);
+	if (err)
+		goto out_master;
+
+	if (!c->ro_mount) {
 		/*
 		 * Set the "dirty" flag so that if we reboot uncleanly we
 		 * will notice this immediately on the next mount.
@@ -1300,13 +1307,9 @@ static int mount_ubifs(struct ubifs_info *c)
 		c->mst_node->flags |= cpu_to_le32(UBIFS_MST_DIRTY);
 		err = ubifs_write_master(c);
 		if (err)
-			goto out_master;
+			goto out_lpt;
 	}
 
-	err = ubifs_lpt_init(c, 1, !c->ro_mount);
-	if (err)
-		goto out_lpt;
-
 	err = dbg_check_idx_size(c, c->bi.old_idx_sz);
 	if (err)
 		goto out_lpt;
-- 
1.7.2.3



-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

