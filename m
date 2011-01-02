Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab1ABHYt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:24:49 -0500
Received: from mail.windriver.com ([147.11.1.11]:36624 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526Ab1ABHYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:47 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 187/260] wext: fix potential private ioctl memory content leak
Date: Sun,  2 Jan 2011 02:18:03 -0500
Message-Id: <1293952756-15010-188-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:35.0807 (UTC) FILETIME=[F7E058F0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit df6d02300f7c2fbd0fbe626d819c8e5237d72c62 upstream.

When a driver doesn't fill the entire buffer, old
heap contents may remain, and if it also doesn't
update the length properly, this old heap content
will be copied back to userspace.

It is very unlikely that this happens in any of
the drivers using private ioctls since it would
show up as junk being reported by iwpriv, but it
seems better to be safe here, so use kzalloc.

Reported-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/wireless/wext-priv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/wext-priv.c b/net/wireless/wext-priv.c
index 3feb28e..674d426 100644
--- a/net/wireless/wext-priv.c
+++ b/net/wireless/wext-priv.c
@@ -152,7 +152,7 @@ static int ioctl_private_iw_point(struct iw_point *iwp, unsigned int cmd,
 	} else if (!iwp->pointer)
 		return -EFAULT;
 
-	extra = kmalloc(extra_size, GFP_KERNEL);
+	extra = kzalloc(extra_size, GFP_KERNEL);
 	if (!extra)
 		return -ENOMEM;
 
-- 
1.7.3.3

