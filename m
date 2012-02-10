Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334Ab2BJWun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:50:43 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55384 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933287Ab2BJWu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:50:29 -0500
MIME-Version: 1.0
Message-Id: <20120210224851.620013338@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:47:48 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Namjae Jeon <linkinjeon@gmail.com>,
        Jan Kara <jack@suse.cz>, Dave Jones <davej@redhat.com>
Subject: [09/21] udf: Mark LVID buffer as uptodate before marking it dirty
In-Reply-To: <20120210224858.GA30752@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
 1 file changed, 6 insertions(+)

--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1791,6 +1791,12 @@ static void udf_open_lvid(struct super_b
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


