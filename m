Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab2EGUgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:36:00 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:50932 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180Ab2EGUaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:30:23 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 05/21] resource: adjust_resource handle resource without parent
Date: Mon,  7 May 2012 13:29:50 -0700
Message-Id: <1336422606-4244-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
References: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for no parent no siling case.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 kernel/resource.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 7e8ea66..51ade23 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -722,14 +722,12 @@ int adjust_resource(struct resource *res, resource_size_t start, resource_size_t
 
 	write_lock(&resource_lock);
 
+	if (!parent)
+		goto skip;
+
 	if ((start < parent->start) || (end > parent->end))
 		goto out;
 
-	for (tmp = res->child; tmp; tmp = tmp->sibling) {
-		if ((tmp->start < start) || (tmp->end > end))
-			goto out;
-	}
-
 	if (res->sibling && (res->sibling->start <= end))
 		goto out;
 
@@ -741,6 +739,11 @@ int adjust_resource(struct resource *res, resource_size_t start, resource_size_t
 			goto out;
 	}
 
+skip:
+	for (tmp = res->child; tmp; tmp = tmp->sibling)
+		if ((tmp->start < start) || (tmp->end > end))
+			goto out;
+
 	res->start = start;
 	res->end = end;
 	result = 0;
-- 
1.7.7

