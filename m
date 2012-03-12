Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab2CLAwO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 20:52:14 -0400
Received: from 1wt.eu ([62.212.114.60]:63129 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660Ab2CLAwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 20:52:03 -0400
Message-Id: <20120312004411.483751904@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 Mar 2012 01:44:15 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 04/13] udf: Mark LVID buffer as uptodate before marking it dirty
In-Reply-To: <fec4dd6c17083169f2e217caca7375ef@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 853a0c25baf96b028de1654bea1e0c8857eadf3d upstream.

When we hit EIO while writing LVID, the buffer uptodate bit is cleared.
This then results in an anoying warning from mark_buffer_dirty() when we
write the buffer again. So just set uptodate flag unconditionally.

Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/super.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 1e4543c..ee6b3af 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1791,6 +1791,12 @@ static void udf_open_lvid(struct super_block *sb)
 			le16_to_cpu(lvid->descTag.descCRCLength)));
 
 	lvid->descTag.tagChecksum = udf_tag_checksum(&lvid->descTag);
+	/*
+	 * We set buffer uptodate unconditionally here to avoid spurious
+	 * warnings from mark_buffer_dirty() when previous EIO has marked
+	 * the buffer as !uptodate
+	 */
+	set_buffer_uptodate(bh);
 	mark_buffer_dirty(bh);
 	sbi->s_lvid_dirty = 0;
 }
-- 
1.7.2.1.45.g54fbc



