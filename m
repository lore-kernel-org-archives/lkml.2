Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759764Ab1FWQzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 12:55:33 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62170 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759359Ab1FWQzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 12:55:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=tUB2fA0MoSbzJiWyF4iGjBrjyY3+3L9r3YKjgnzfK4FiukmxRP/ARXIqUr3ShSmPgp
         4cb0+rJjScZbOIwrMZYvTB8FLLpuR7CgTZ3WfaNX44fBLhpK0S9SHwnm7aSvz5e4FiQb
         nEaJq0zZsPXTlN3POj4D3o40i6hc8PQ36FSFM=
Message-ID: <4E037001.8090306@gmail.com>
Date: Thu, 23 Jun 2011 18:55:29 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alex Elder <aelder@sgi.com>
CC: xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] xfs: Silence bounds checking compiler warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc with -Warray-bounds generates a false positive on this
since xfs defines the struct with u8 name[1]; to be able to
add a tag at the end.

Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
---
 fs/xfs/xfs_dir2_block.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index 580d99c..2c5f287 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -1148,7 +1148,7 @@ xfs_dir2_sf_to_block(
 		((char *)block + XFS_DIR2_DATA_DOTDOT_OFFSET);
 	dep->inumber = cpu_to_be64(xfs_dir2_sf_get_inumber(sfp, &sfp->hdr.parent));
 	dep->namelen = 2;
-	dep->name[0] = dep->name[1] = '.';
+	memset(dep->name, '.', 2);
 	tagp = xfs_dir2_data_entry_tag_p(dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)block);
 	xfs_dir2_data_log_entry(tp, bp, dep);
-- 
1.7.5.4

v2: memset looks like the cleanest solution, other options rely on ugly casts

