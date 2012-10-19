Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131Ab2JSDRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:17:55 -0400
Received: from mail.kernel.org ([198.145.19.201]:54704 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758117Ab2JSDRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 23:17:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Nikola Pajkovsky <npajkovs@redhat.com>, Jan Kara <jack@suse.cz>
Subject: [ 35/37] udf: fix retun value on error path in udf_load_logicalvol
Date: Thu, 18 Oct 2012 20:16:58 -0700
Message-Id: <20121019031308.493119851@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019031302.789593147@linuxfoundation.org>
References: <20121019031302.789593147@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikola Pajkovsky <npajkovs@redhat.com>

commit 68766a2edcd5cd744262a70a2f67a320ac944760 upstream.

In case we detect a problem and bail out, we fail to set "ret" to a
nonzero value, and udf_load_logicalvol will mistakenly report success.

Signed-off-by: Nikola Pajkovsky <npajkovs@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/udf/super.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1316,6 +1316,7 @@ static int udf_load_logicalvol(struct su
 		udf_error(sb, __func__, "error loading logical volume descriptor: "
 			"Partition table too long (%u > %lu)\n", table_len,
 			sb->s_blocksize - sizeof(*lvd));
+		ret = 1;
 		goto out_bh;
 	}
 
@@ -1360,8 +1361,10 @@ static int udf_load_logicalvol(struct su
 						UDF_ID_SPARABLE,
 						strlen(UDF_ID_SPARABLE))) {
 				if (udf_load_sparable_map(sb, map,
-				    (struct sparablePartitionMap *)gpm) < 0)
+				    (struct sparablePartitionMap *)gpm) < 0) {
+					ret = 1;
 					goto out_bh;
+				}
 			} else if (!strncmp(upm2->partIdent.ident,
 						UDF_ID_METADATA,
 						strlen(UDF_ID_METADATA))) {


