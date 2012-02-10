Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100Ab2BJWsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:48:50 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45193 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933049Ab2BJWp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:45:29 -0500
MIME-Version: 1.0
Message-Id: <20120210223442.478488563@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:33:29 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Namjae Jeon <linkinjeon@gmail.com>,
        Jan Kara <jack@suse.cz>, Dave Jones <davej@redhat.com>
Subject: [patch 25/55] udf: Mark LVID buffer as uptodate before marking it dirty
In-Reply-To: <20120210223500.GA24178@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1830,6 +1830,12 @@ static void udf_close_lvid(struct super_
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
 	mutex_unlock(&sbi->s_alloc_mutex);


