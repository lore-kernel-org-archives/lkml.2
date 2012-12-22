Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab2LVB6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 20:58:32 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:61521 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab2LVB6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 20:58:23 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        patches@opensource.wolfsonmicro.com
Subject: [PATCH 13/25] sound/wm8350: don't use [delayed_]work_pending()
Date: Fri, 21 Dec 2012 17:57:03 -0800
Message-Id: <1356141435-17340-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356141435-17340-1-git-send-email-tj@kernel.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to test whether a (delayed) work item in pending
before queueing, flushing or cancelling it.  Most uses are unnecessary
and quite a few of them are buggy.

Remove unnecessary pending tests from wm8350.  Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: patches@opensource.wolfsonmicro.com
---
Please let me know how this patch should be routed.  I can take it
through the workqueue tree if necessary.

Thanks.

 sound/soc/codecs/wm8350.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/wm8350.c b/sound/soc/codecs/wm8350.c
index fb92fb4..ec0efc1 100644
--- a/sound/soc/codecs/wm8350.c
+++ b/sound/soc/codecs/wm8350.c
@@ -283,18 +283,16 @@ static int pga_event(struct snd_soc_dapm_widget *w,
 		out->ramp = WM8350_RAMP_UP;
 		out->active = 1;
 
-		if (!delayed_work_pending(&codec->dapm.delayed_work))
-			schedule_delayed_work(&codec->dapm.delayed_work,
-					      msecs_to_jiffies(1));
+		schedule_delayed_work(&codec->dapm.delayed_work,
+				      msecs_to_jiffies(1));
 		break;
 
 	case SND_SOC_DAPM_PRE_PMD:
 		out->ramp = WM8350_RAMP_DOWN;
 		out->active = 0;
 
-		if (!delayed_work_pending(&codec->dapm.delayed_work))
-			schedule_delayed_work(&codec->dapm.delayed_work,
-					      msecs_to_jiffies(1));
+		schedule_delayed_work(&codec->dapm.delayed_work,
+				      msecs_to_jiffies(1));
 		break;
 	}
 
-- 
1.8.0.2

