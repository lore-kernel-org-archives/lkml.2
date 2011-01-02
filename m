Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab1ABIF4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:05:56 -0500
Received: from mail.windriver.com ([147.11.1.11]:34572 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab1ABHWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:13 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 056/260] ALSA: seq/oss - Fix double-free at error path of snd_seq_oss_open()
Date: Sun,  2 Jan 2011 02:15:52 -0500
Message-Id: <1293952756-15010-57-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:07.0163 (UTC) FILETIME=[9F4712B0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 27f7ad53829f79e799a253285318bff79ece15bd upstream.

The error handling in snd_seq_oss_open() has several bad codes that
do dereferecing released pointers and double-free of kmalloc'ed data.
The object dp is release in free_devinfo() that is called via
private_free callback.  The rest shouldn't touch this object any more.

The patch changes delete_port() to call kfree() in any case, and gets
rid of unnecessary calls of destructors in snd_seq_oss_open().

Fixes CVE-2010-3080.

Reported-and-tested-by: Tavis Ormandy <taviso@cmpxchg8b.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/core/seq/oss/seq_oss_init.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/sound/core/seq/oss/seq_oss_init.c b/sound/core/seq/oss/seq_oss_init.c
index 6857122..69cd7b3 100644
--- a/sound/core/seq/oss/seq_oss_init.c
+++ b/sound/core/seq/oss/seq_oss_init.c
@@ -281,13 +281,10 @@ snd_seq_oss_open(struct file *file, int level)
 	return 0;
 
  _error:
-	snd_seq_oss_writeq_delete(dp->writeq);
-	snd_seq_oss_readq_delete(dp->readq);
 	snd_seq_oss_synth_cleanup(dp);
 	snd_seq_oss_midi_cleanup(dp);
-	delete_port(dp);
 	delete_seq_queue(dp->queue);
-	kfree(dp);
+	delete_port(dp);
 
 	return rc;
 }
@@ -350,8 +347,10 @@ create_port(struct seq_oss_devinfo *dp)
 static int
 delete_port(struct seq_oss_devinfo *dp)
 {
-	if (dp->port < 0)
+	if (dp->port < 0) {
+		kfree(dp);
 		return 0;
+	}
 
 	debug_printk(("delete_port %i\n", dp->port));
 	return snd_seq_event_port_detach(dp->cseq, dp->port);
-- 
1.7.3.3

