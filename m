Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758442Ab1EZTur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 15:50:47 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:37308 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758364Ab1EZTuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 15:50:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PJWBxphJpNxGGcBSufjjpflFII7iHzPP/aPm5HiDfFTyAOsjBKgCRHOYWduNwWQ7Ze
         j4ruTZbRkpT7Fez3zKetcMN1rmxeSRwuxh93/BQLQHPAshrdPKEQ3+1ulgWFZcAF3bx+
         9vQhdIwtLRFJKQaekmY5WeMTtkp14LBI0EqHo=
From: Jim Cromie <jim.cromie@gmail.com>
To: mingo@elte.hu
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 2/3] perf-stat: fix +- nan% in -Aa runs
Date: Thu, 26 May 2011 13:50:05 -0600
Message-Id: <1306439406-18037-3-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1306439406-18037-1-git-send-email-jim.cromie@gmail.com>
References: <BANLkTimJp9o5_P73eNn5rMJbfRC2sCRdJA@mail.gmail.com>
 <1306439406-18037-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

without this patch, I get computations like this:

[jimc@groucho perf]$ sudo ./perf stat -r3 -Aa  perl -e '$i++ for 1..100000'

 Performance counter stats for 'perl -e $i++ for 1..100000' (3 runs):

CPU0             12.391883 task-clock-msecs         #      0.966 CPUs    ( +-    -nan% )
CPU1             12.446571 task-clock-msecs         #      0.970 CPUs    ( +-    -nan% )
CPU2             12.408014 task-clock-msecs         #      0.967 CPUs    ( +-    -nan% )
CPU3             12.422264 task-clock-msecs         #      0.968 CPUs    ( +-    -nan% )

I couldnt see anything wrong in the caller, so fixed it in stddev_stats()

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 tools/perf/builtin-stat.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 71bbf72..c59d199 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -151,8 +151,13 @@ static double avg_stats(struct stats *stats)
  */
 static double stddev_stats(struct stats *stats)
 {
-	double variance = stats->M2 / (stats->n - 1);
-	double variance_mean = variance / stats->n;
+	double variance, variance_mean;
+
+	if (!stats->n)
+		return 0.0;
+
+	variance = stats->M2 / (stats->n - 1);
+	variance_mean = variance / stats->n;
 
 	return sqrt(variance_mean);
 }
-- 
1.7.4.4

