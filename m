Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965730Ab2EOCcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:32:45 -0400
Received: from mail.windriver.com ([147.11.1.11]:49849 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965451Ab2EOCSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:18:04 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 152/179] ALSA: timer - Fix Oops at closing slave timer
Date: Mon, 14 May 2012 22:14:08 -0400
Message-ID: <1337048075-6132-153-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 0584ffa548b6e59aceb027112f23a55f0133400e upstream.

A slave-timer instance has no timer reference, and this results in
NULL-dereference at stopping the timer, typically called at closing
the device.

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=40682

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/core/timer.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/core/timer.c b/sound/core/timer.c
index 5040c7b..ecb2dd5 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -530,6 +530,8 @@ int snd_timer_stop(struct snd_timer_instance *timeri)
 	if (err < 0)
 		return err;
 	timer = timeri->timer;
+	if (!timer)
+		return -EINVAL;
 	spin_lock_irqsave(&timer->lock, flags);
 	timeri->cticks = timeri->ticks;
 	timeri->pticks = 0;
-- 
1.7.9.6

