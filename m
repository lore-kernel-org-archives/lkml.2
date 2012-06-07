Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890Ab2FGEUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:20:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63306 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850Ab2FGEUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:20:13 -0400
Message-Id: <20120607040345.242563062@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:37 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Sandeen <sandeen@redhat.com>,
        Haogang Chen <haogangchen@gmail.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 61/82] ext4: fix potential integer overflow in alloc_flex_gd()
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haogang Chen <haogangchen@gmail.com>

commit 967ac8af4475ce45474800709b12137aa7634c77 upstream.

In alloc_flex_gd(), when flexbg_size is large, kmalloc size would
overflow and flex_gd->groups would point to a buffer smaller than
expected, causing OOB accesses when it is used.

Note that in ext4_resize_fs(), flexbg_size is calculated using
sbi->s_log_groups_per_flex, which is read from the disk and only bounded
to [1, 31]. The patch returns NULL for too large flexbg_size.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Haogang Chen <haogangchen@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/resize.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -161,6 +161,8 @@ static struct ext4_new_flex_group_data *
 	if (flex_gd == NULL)
 		goto out3;
 
+	if (flexbg_size >= UINT_MAX / sizeof(struct ext4_new_flex_group_data))
+		goto out2;
 	flex_gd->count = flexbg_size;
 
 	flex_gd->groups = kmalloc(sizeof(struct ext4_new_group_data) *


