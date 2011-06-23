Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902Ab1FWR3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:29:42 -0400
Received: from mail.windriver.com ([147.11.1.11]:65182 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932872Ab1FWR3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:29:40 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Clemens Ladisch <clemens@ladisch.de>,
        Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 044/247] ALSA: hrtimer: handle delayed timer interrupts
Date: Thu, 23 Jun 2011 13:25:43 -0400
Message-Id: <1308850146-15061-3-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850146-15061-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850146-15061-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Clemens Ladisch <clemens@ladisch.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit b1d4f7f4bdcf9915c41ff8cfc4425c84dabb1fde upstream.

If a timer interrupt was delayed too much, hrtimer_forward_now() will
forward the timer expiry more than once.  When this happens, the
additional number of elapsed ALSA timer ticks must be passed to
snd_timer_interrupt() to prevent the ALSA timer from falling behind.

This mostly fixes MIDI slowdown problems on highly-loaded systems with
badly behaved interrupt handlers.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Reported-and-tested-by: Arthur Marsh <arthur.marsh@internode.on.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/core/hrtimer.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/core/hrtimer.c b/sound/core/hrtimer.c
index 7730575..07efa29 100644
--- a/sound/core/hrtimer.c
+++ b/sound/core/hrtimer.c
@@ -45,12 +45,13 @@ static enum hrtimer_restart snd_hrtimer_callback(struct hrtimer *hrt)
 {
 	struct snd_hrtimer *stime = container_of(hrt, struct snd_hrtimer, hrt);
 	struct snd_timer *t = stime->timer;
+	unsigned long oruns;
 
 	if (!atomic_read(&stime->running))
 		return HRTIMER_NORESTART;
 
-	hrtimer_forward_now(hrt, ns_to_ktime(t->sticks * resolution));
-	snd_timer_interrupt(stime->timer, t->sticks);
+	oruns = hrtimer_forward_now(hrt, ns_to_ktime(t->sticks * resolution));
+	snd_timer_interrupt(stime->timer, t->sticks * oruns);
 
 	if (!atomic_read(&stime->running))
 		return HRTIMER_NORESTART;
-- 
1.7.4.4

