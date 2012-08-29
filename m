Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab2H2TFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 15:05:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60790 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab2H2TFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 15:05:39 -0400
From: anish kumar <anish198519851985@gmail.com>
To: cw00.choi@samsung.com, myungjoo.ham@samsung.com
Cc: linux-kernel@vger.kernel.org, anish kumar <anish198519851985@gmail.com>
Subject: [PATCH 2/2] [2/2] extcon: optimising the check_mutually_exclusive function
Date: Thu, 30 Aug 2012 00:35:10 +0530
Message-Id: <1346267110-29479-2-git-send-email-anish198519851985@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1346267110-29479-1-git-send-email-anish198519851985@gmail.com>
References: <1346267110-29479-1-git-send-email-anish198519851985@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: anish kumar <anish198519851985@gmail.com>

Rather than re-inventing the wheel we can use the hamming function
to calculate the number of bits set to check for violation of
exclusivity.

Signed-off-by: anish kumar <anish198519851985@gmail.com>
---
 drivers/extcon/extcon-class.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index e09a6c3..06df95a 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -89,17 +89,13 @@ static int check_mutually_exclusive(struct extcon_dev *edev, u32 new_state)
 		return 0;
 
 	for (i = 0; edev->mutually_exclusive[i]; i++) {
-		int count = 0, j;
+		int weight;
 		u32 correspondants = new_state & edev->mutually_exclusive[i];
-		u32 exp = 1;
-
-		for (j = 0; j < 32; j++) {
-			if (exp & correspondants)
-				count++;
-			if (count > 1)
-				return i + 1;
-			exp <<= 1;
-		}
+
+		/* calculate the total number of bits set */
+		weight = hweight32(correspondants);
+		if (weight > 1)
+			return i + 1;
 	}
 
 	return 0;
-- 
1.7.1

