Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab1EDDGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 23:06:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:20662 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755132Ab1EDDGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 23:06:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,312,1301900400"; 
   d="scan'208";a="917652205"
From: Chen Gong <gong.chen@linux.intel.com>
To: tony.luck@intel.com, ying.huang@intel.com
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Chen Gong <gong.chen@linux.intel.com>
Subject: [PATCH 3/3] fix potential logic issue in pstore read interface
Date: Wed,  4 May 2011 11:06:52 +0800
Message-Id: <1304478412-11843-4-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.7.5.185.g0b9dee
In-Reply-To: <1304478412-11843-1-git-send-email-gong.chen@linux.intel.com>
References: <1304478412-11843-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) in the calling of erst_read, the parameter of buffer size
maybe overflows and cause crash

2) the return value of erst_read should be checked more strictly

Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
---
 drivers/acpi/apei/erst.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index ddb68c4..e6cef8e 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -1006,7 +1006,14 @@ skip:
 	}
 
 	len = erst_read(record_id, &rcd->hdr, sizeof(*rcd) +
-			  erst_erange.size);
+			erst_info.bufsize);
+	/* The record may be cleared by others, try read next record */
+	if (len == -ENOENT)
+		goto skip;
+	else if (len < 0) {
+		rc = -1;
+		goto out;
+	}
 	if (uuid_le_cmp(rcd->hdr.creator_id, CPER_CREATOR_PSTORE) != 0)
 		goto skip;
 
-- 
1.7.5.185.g0b9dee

