Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab2EWGfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:35:10 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:34495 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965165Ab2EWGe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:34:58 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 08/11] resource: only return range with needed align
Date: Tue, 22 May 2012 23:34:34 -0700
Message-Id: <1337754877-19759-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compare align between put range in head and tail, pick small one
to leave big one for future user.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 kernel/resource.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index b4dae55..8277090 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -506,8 +506,20 @@ out:
 	}
 
 	if (!ret) {
-		new->start = avail_start;
+		/* compare which one have max order */
+		new->start = round_down(avail_start + avail_size - size,
+					 constraint->align);
+		new->end = avail_start + avail_size - 1;
+		new->start = constraint->alignf(constraint->alignf_data, new,
+					size, constraint->align);
 		new->end = new->start + size - 1;
+
+		if (new->start < avail_start ||
+		    new->end > (avail_start + avail_size - 1) ||
+		    __ffs64(new->start) >= __ffs64(avail_start)) {
+			new->start = avail_start;
+			new->end = new->start + size - 1;
+		}
 	}
 	return ret;
 }
-- 
1.7.7

