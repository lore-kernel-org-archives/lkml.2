Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab0D1I3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 04:29:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44229 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab0D1I3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 04:29:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=GepIzA0Oe8XN+JY/43BdoYVTY/AD3W7W7Py/68Z78Ux3Z3+mdnWAuR1ATkOWCU6URQ
         deYgts0zGCIV7Lk7I26COACA16zSOjDsNclMlqWfgqG4QDy5hNV7NU9tkR4bSO3xLvyf
         IS2VUvA7rdzHuIycLFZibaz1fGdz5KCr96aaY=
Date: Wed, 28 Apr 2010 10:29:14 +0200
From: Dan Carpenter <error27@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: alsa-devel@alsa-project.org, Jaroslav Kysela <perex@perex.cz>,
       Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Subject: [patch] take tu->qlock with irqs disabled
Message-ID: <20100428082914.GA24513@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	alsa-devel@alsa-project.org, Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
References: <tkrat.3cb3230c2c45e983@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tkrat.3cb3230c2c45e983@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should disable irqs when we take the tu->qlock because it is used in
the irq handler.  The only place that doesn't is
snd_timer_user_ccallback().  Most of the time snd_timer_user_ccallback()
is called with interrupts disabled but the the first ti->ccallback()
call in snd_timer_notify1() has interrupts enabled.

This was caught by lockdep which generates the following message:

> =================================
> [ INFO: inconsistent lock state ]
> 2.6.34-rc5 #5
> ---------------------------------
> inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
> dolphin/4003 [HC1[1]:SC0[0]:HE0:SE1] takes:
> (&(&tu->qlock)->rlock){?.+...}, at: [<f84ec472>] snd_timer_user_tinterrupt+0x28/0x132 [snd_timer]
> {HARDIRQ-ON-W} state was registered at:
>   [<c1048de9>] __lock_acquire+0x654/0x1482
>   [<c1049c73>] lock_acquire+0x5c/0x73
>   [<c125ac3e>] _raw_spin_lock+0x25/0x34
>   [<f84ec370>] snd_timer_user_ccallback+0x55/0x95 [snd_timer]
>   [<f84ecc4b>] snd_timer_notify1+0x53/0xca [snd_timer]

Reported-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/sound/core/timer.c b/sound/core/timer.c
index 7394365..5040c7b 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -1160,6 +1160,7 @@ static void snd_timer_user_ccallback(struct snd_timer_instance *timeri,
 {
 	struct snd_timer_user *tu = timeri->callback_data;
 	struct snd_timer_tread r1;
+	unsigned long flags;
 
 	if (event >= SNDRV_TIMER_EVENT_START &&
 	    event <= SNDRV_TIMER_EVENT_PAUSE)
@@ -1169,9 +1170,9 @@ static void snd_timer_user_ccallback(struct snd_timer_instance *timeri,
 	r1.event = event;
 	r1.tstamp = *tstamp;
 	r1.val = resolution;
-	spin_lock(&tu->qlock);
+	spin_lock_irqsave(&tu->qlock, flags);
 	snd_timer_user_append_to_tqueue(tu, &r1);
-	spin_unlock(&tu->qlock);
+	spin_unlock_irqrestore(&tu->qlock, flags);
 	kill_fasync(&tu->fasync, SIGIO, POLL_IN);
 	wake_up(&tu->qchange_sleep);
 }

