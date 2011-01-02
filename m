Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab1ABIKO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:10:14 -0500
Received: from mail.windriver.com ([147.11.1.11]:34353 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab1ABHV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:21:56 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Hank Janssen <hjanssen@microsoft.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 038/260] staging: hv: Fixed bounce kmap problem by using correct index
Date: Sun,  2 Jan 2011 02:15:34 -0500
Message-Id: <1293952756-15010-39-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:48.0101 (UTC) FILETIME=[93EA7150:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hank Janssen <hjanssen@microsoft.com>

commit 0c47a70a9a8a6d1ec37a53d2f9cb82f8b8ef8aa2 upstream.

Fixed bounce offset kmap problem by using correct index.
The symptom of the problem is that in some NAS appliances this problem
represents Itself by a unresponsive VM under a load with many clients writing
small files.

Signed-off-by:Hank Janssen <hjanssen@microsoft.com>
Signed-off-by:Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/staging/hv/storvsc_drv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 8a58272..060da9e 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -524,7 +524,7 @@ static unsigned int copy_to_bounce_buffer(struct scatterlist *orig_sgl,
 
 		ASSERT(orig_sgl[i].offset + orig_sgl[i].length <= PAGE_SIZE);
 
-		if (j == 0)
+		if (bounce_addr == 0)
 			bounce_addr = (unsigned long)kmap_atomic(sg_page((&bounce_sgl[j])), KM_IRQ0);
 
 		while (srclen) {
@@ -585,7 +585,7 @@ static unsigned int copy_from_bounce_buffer(struct scatterlist *orig_sgl,
 		destlen = orig_sgl[i].length;
 		ASSERT(orig_sgl[i].offset + orig_sgl[i].length <= PAGE_SIZE);
 
-		if (j == 0)
+		if (bounce_addr == 0)
 			bounce_addr = (unsigned long)kmap_atomic(sg_page((&bounce_sgl[j])), KM_IRQ0);
 
 		while (destlen) {
-- 
1.7.3.3

