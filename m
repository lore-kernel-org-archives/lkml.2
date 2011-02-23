Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751292Ab1BWFUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 00:20:50 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53543 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab1BWFUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 00:20:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CD1RyOgb8e+Oa2MNGQ8wMHTAQHz4Yo69xP5zsn8iiKmUYi6MPts4CHeOG+/VqkQLKm
         aiak2ULDKnvQ+3hlGwvMHR/ZYdxmzz1YLek4E2dobRjFtp+5hIpAPY3cJwaJO71Ar2BG
         J9FkUmMAQ+9453xz3ZcMjuqovgW4HbzcCF6dA=
Date: Tue, 22 Feb 2011 21:20:42 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "pantherchen@versanet.de" <pantherchen@versanet.de>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Boot time regression in 2.6.38 after initial wq merge
Message-ID: <20110223052042.GA19269@core.coreip.homeip.net>
References: <20110222081752.GP31267@htj.dyndns.org>
 <20110222085223.GC11681@core.coreip.homeip.net>
 <20110222090255.GR31267@htj.dyndns.org>
 <B04A0050-5AE7-4072-BE6F-279E24B0DA64@gmail.com>
 <4D63D062.3040404@versanet.de>
 <20110222172254.GA13114@core.coreip.homeip.net>
 <20110222175955.GA27991@core.coreip.homeip.net>
 <4D640F67.3040109@versanet.de>
 <20110222195257.GA13256@core.coreip.homeip.net>
 <4D641936.90404@versanet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D641936.90404@versanet.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 09:14:46PM +0100, pantherchen@versanet.de wrote:
> On 02/22/2011 08:52 PM, Dmitry Torokhov wrote:
> >Ewww... tty/ldisc...
> >
> >Does it help if you change drivers/input/serio/serio.c::serio_queue_event()
> >from calling
> >
> >	schedule_work(&serio_event_work);
> >
> >to call
> >
> >	queue_work(system_long_wq,&serio_event_work);
> >
> >?
> 
> Yes, that works: http://img.xrmb2.net/images/499337.png
> 

Great!

OK, so below is properly formatted patch. I am going to send it upstream
unless somebody objects.

Thanks.

-- 
Dmitry


Input: serio/gameport - use 'long' system workqueue

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Commit 8ee294cd9def0004887da7f44b80563493b0a097 converted serio
subsystem event handling from using a dedicated thread to using
common workqueue. Unfortunately, this regressed our boot times,
due to the fact that serio jobs take long time to execute. While
the new concurrency managed workqueue code manages long-playing
works just fine and schedules additional workers as needed, such
works wreck havoc among remaining users of flush_scheduled_work().

To solve this problem let's move serio/gameport works from system_wq
to system_long_wq which nobody tries to flush.

Reported-and-tested-by: Hernando Torque <pantherchen@versanet.de>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/gameport/gameport.c |    2 +-
 drivers/input/serio/serio.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/input/gameport/gameport.c b/drivers/input/gameport/gameport.c
index 23cf8fc..5b8f59d 100644
--- a/drivers/input/gameport/gameport.c
+++ b/drivers/input/gameport/gameport.c
@@ -360,7 +360,7 @@ static int gameport_queue_event(void *object, struct module *owner,
 	event->owner = owner;
 
 	list_add_tail(&event->node, &gameport_event_list);
-	schedule_work(&gameport_event_work);
+	queue_work(system_long_wq, &gameport_event_work);
 
 out:
 	spin_unlock_irqrestore(&gameport_event_lock, flags);
diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
index 7c38d1f..ba70058 100644
--- a/drivers/input/serio/serio.c
+++ b/drivers/input/serio/serio.c
@@ -299,7 +299,7 @@ static int serio_queue_event(void *object, struct module *owner,
 	event->owner = owner;
 
 	list_add_tail(&event->node, &serio_event_list);
-	schedule_work(&serio_event_work);
+	queue_work(system_long_wq, &serio_event_work);
 
 out:
 	spin_unlock_irqrestore(&serio_event_lock, flags);
