Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965545Ab2EOCSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:18:21 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53051 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964901Ab2EOCQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:35 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 044/179] UBIFS: fix shrinker object count reports
Date: Mon, 14 May 2012 22:12:20 -0400
Message-ID: <1337048075-6132-45-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit cf610bf4199770420629d3bc273494bd27ad6c1d upstream.

Sometimes VM asks the shrinker to return amount of objects it can shrink,
and we return the ubifs_clean_zn_cnt in that case. However, it is possible
that this counter is negative for a short period of time, due to the way
UBIFS TNC code updates it. And I can observe the following warnings sometimes:

shrink_slab: ubifs_shrinker+0x0/0x2b7 [ubifs] negative objects to delete nr=-8541616642706119788

This patch makes sure UBIFS never returns negative count of objects.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ubifs/shrinker.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ubifs/shrinker.c b/fs/ubifs/shrinker.c
index 02feb59..aec6689 100644
--- a/fs/ubifs/shrinker.c
+++ b/fs/ubifs/shrinker.c
@@ -283,7 +283,11 @@ int ubifs_shrinker(int nr, gfp_t gfp_mask)
 	long clean_zn_cnt = atomic_long_read(&ubifs_clean_zn_cnt);
 
 	if (nr == 0)
-		return clean_zn_cnt;
+		/*
+		 * Due to the way UBIFS updates the clean znode counter it may
+		 * temporarily be negative.
+		 */
+		return clean_zn_cnt >= 0 ? clean_zn_cnt : 1;
 
 	if (!clean_zn_cnt) {
 		/*
-- 
1.7.9.6

