Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579Ab2AMSVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 13:21:35 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40220 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400Ab2AMSVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 13:21:33 -0500
Date: Fri, 13 Jan 2012 22:21:25 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>
Cc: kernel-team@android.com, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: android: lowmemorykiller: Don't wait more than one
 second for a process to die
Message-ID: <20120113182125.GA15495@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

If a process forked and the child process was killed by the
lowmemorykiller, the lowmemory killer would be disabled until
the parent process reaped the child or it died itself.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---

Noticed that the patch is missing. Any reason for not wanting it
in staging?

 drivers/staging/android/lowmemorykiller.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index 2d8d2b7..efc7dc1 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -54,6 +54,7 @@ static size_t lowmem_minfree[6] = {
 static int lowmem_minfree_size = 4;
 
 static struct task_struct *lowmem_deathpending;
+static unsigned long lowmem_deathpending_timeout;
 
 #define lowmem_print(level, x...)			\
 	do {						\
@@ -103,7 +104,8 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 	 * Note: Currently you need CONFIG_PROFILING
 	 * for this to work correctly.
 	 */
-	if (lowmem_deathpending)
+	if (lowmem_deathpending &&
+	    time_before_eq(jiffies, lowmem_deathpending_timeout))
 		return 0;
 
 	if (lowmem_adj_size < array_size)
@@ -178,6 +180,7 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 		 */
 #ifdef CONFIG_PROFILING
 		lowmem_deathpending = selected;
+		lowmem_deathpending_timeout = jiffies + HZ;
 		task_handoff_register(&task_nb);
 #endif
 		force_sig(SIGKILL, selected);
-- 
1.7.7.3
