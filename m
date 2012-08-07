Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076Ab2HGXLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:11:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56801 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030475Ab2HGWi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:38:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>, Jan Kara <jack@suse.cz>
Subject: [ 044/109] udf: Improve table length check to avoid possible overflow
Date: Tue,  7 Aug 2012 15:35:03 -0700
Message-Id: <20120807222046.970058242@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 57b9655d01ef057a523e810d29c37ac09b80eead upstream.

When a partition table length is corrupted to be close to 1 << 32, the
check for its length may overflow on 32-bit systems and we will think
the length is valid. Later on the kernel can crash trying to read beyond
end of buffer. Fix the check to avoid possible overflow.

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/udf/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1283,7 +1283,7 @@ static int udf_load_logicalvol(struct su
 	BUG_ON(ident != TAG_IDENT_LVD);
 	lvd = (struct logicalVolDesc *)bh->b_data;
 	table_len = le32_to_cpu(lvd->mapTableLength);
-	if (sizeof(*lvd) + table_len > sb->s_blocksize) {
+	if (table_len > sb->s_blocksize - sizeof(*lvd)) {
 		udf_err(sb, "error loading logical volume descriptor: "
 			"Partition table too long (%u > %lu)\n", table_len,
 			sb->s_blocksize - sizeof(*lvd));


