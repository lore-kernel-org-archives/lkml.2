Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933206Ab1ERODo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 10:03:44 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:53750 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932856Ab1ERODm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 10:03:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=i7Poes+OSjLZQJ2zNWnDUAgCo/0pGn7cltElGbBewZyysqxV5cpa5vx99//mPAzzk+
         MMVWGUZzeYPJppFdw0Ig23Jy4jag3ncv/iZoFTlPSFbvC8fJoKJg75FzOo9txRSPOVvr
         sJ2BY/F0+RYNyCKlejJIYoaSiJY7PRB4xpBgY=
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Cc: Jaroslav Kysela <perex@perex.cz>, Clemens Ladisch <clemens@ladisch.de>,
        linux-kernel@vger.kernel.org,
        Ben Gardiner <bengardiner@nanometrics.ca>
Subject: [PATCH] sound, core, pcm_lib: xrun_log: log also in_interrupt
Date: Wed, 18 May 2011 10:03:34 -0400
Message-Id: <1305727414-17623-1-git-send-email-bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When debugging pcm drivers I found the "period" or "hw" prefix printed
by either XRUN_DEBUG_PERIODUPDATE or XRUN_DEBUG_PERIODUPDATE events, 
respectively to be very useful is observing the interplay between
interrupt-context updates and syscall-context updates.

Similarly, when debugging overruns with XRUN_DEBUG_LOG it is useful to
see the context of the last 10 positions.

Add an in_interrupt member to hwptr_log_entry which stores the value of
the in_interrupt parameter of snd_pcm_update_hw_ptr0 when the log entry
is created. Print a "[Q]" prefix when dumping the log entries if
in_interrupt was true.

Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
---
 sound/core/pcm_lib.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index 64449cb..c8c8091 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -189,6 +189,7 @@ static void xrun(struct snd_pcm_substream *substream)
 #define XRUN_LOG_CNT	10
 
 struct hwptr_log_entry {
+	unsigned int in_interrupt;
 	unsigned long jiffies;
 	snd_pcm_uframes_t pos;
 	snd_pcm_uframes_t period_size;
@@ -204,7 +205,7 @@ struct snd_pcm_hwptr_log {
 };
 
 static void xrun_log(struct snd_pcm_substream *substream,
-		     snd_pcm_uframes_t pos)
+		     snd_pcm_uframes_t pos, int in_interrupt)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct snd_pcm_hwptr_log *log = runtime->hwptr_log;
@@ -220,6 +221,7 @@ static void xrun_log(struct snd_pcm_substream *substream,
 			return;
 	}
 	entry = &log->entries[log->idx];
+	entry->in_interrupt = in_interrupt;
 	entry->jiffies = jiffies;
 	entry->pos = pos;
 	entry->period_size = runtime->period_size;
@@ -246,9 +248,11 @@ static void xrun_log_show(struct snd_pcm_substream *substream)
 		entry = &log->entries[idx];
 		if (entry->period_size == 0)
 			break;
-		snd_printd("hwptr log: %s: j=%lu, pos=%ld/%ld/%ld, "
+		snd_printd("hwptr log: %s: %sj=%lu, pos=%ld/%ld/%ld, "
 			   "hwptr=%ld/%ld\n",
-			   name, entry->jiffies, (unsigned long)entry->pos,
+			   name, entry->in_interrupt ? "[Q] " : "",
+			   entry->jiffies,
+			   (unsigned long)entry->pos,
 			   (unsigned long)entry->period_size,
 			   (unsigned long)entry->buffer_size,
 			   (unsigned long)entry->old_hw_ptr,
@@ -326,7 +330,7 @@ static int snd_pcm_update_hw_ptr0(struct snd_pcm_substream *substream,
 	}
 	pos -= pos % runtime->min_align;
 	if (xrun_debug(substream, XRUN_DEBUG_LOG))
-		xrun_log(substream, pos);
+		xrun_log(substream, pos, in_interrupt);
 	hw_base = runtime->hw_ptr_base;
 	new_hw_ptr = hw_base + pos;
 	if (in_interrupt) {
-- 
1.7.4.1

