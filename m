Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab1HNQTY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:19:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37334 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548Ab1HNQSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:18:17 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:10:34 2011
Message-Id: <20110812211034.862255062@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:09:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [3/6] ALSA: timer - Fix Oops at closing slave timer
In-Reply-To: <20110812211045.GA6497@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 0584ffa548b6e59aceb027112f23a55f0133400e upstream.

A slave-timer instance has no timer reference, and this results in
NULL-dereference at stopping the timer, typically called at closing
the device.

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=40682

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/core/timer.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -530,6 +530,8 @@ int snd_timer_stop(struct snd_timer_inst
 	if (err < 0)
 		return err;
 	timer = timeri->timer;
+	if (!timer)
+		return -EINVAL;
 	spin_lock_irqsave(&timer->lock, flags);
 	timeri->cticks = timeri->ticks;
 	timeri->pticks = 0;


