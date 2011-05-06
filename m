Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab1EFWaO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 18:30:14 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33041 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab1EFWaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 18:30:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=xTwv2D97k8AwCZVGBEQGQRVj5WlI7d4etMLm3eOV9J6hhR2roCiTpIAsEPTpyMnjb4
         /8DeqygdkqFr37lYJNEN69yXRkeZRv83Ie1dwS1ejAA/3ywbdfFRA0BlziyufkgwVzsT
         O68hL62jwH2Gjxgv+rfau3Fr+uGbP/ZMQBoSA=
Subject: Re: [RFC] time: xtime_lock is held too long
From: Eric Dumazet <eric.dumazet@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1304713443.20980.124.camel@work-vm>
References: <1304574244.32152.666.camel@edumazet-laptop>
	 <1304576495.2943.40.camel@work-vm>
	 <1304604284.3032.78.camel@edumazet-laptop>
	 <alpine.LFD.2.02.1105051630390.3005@ionos>
	 <1304608095.3032.95.camel@edumazet-laptop>
	 <alpine.LFD.2.02.1105051750540.3005@ionos>
	 <20110505210118.GI2925@one.firstfloor.org>
	 <alpine.LFD.2.02.1105061117220.3005@ionos>
	 <20110506165913.GF11636@one.firstfloor.org>
	 <1304703767.3066.211.camel@edumazet-laptop>
	 <20110506175051.GL11636@one.firstfloor.org>
	 <1304710003.2821.0.camel@edumazet-laptop>
	 <1304712267.2821.29.camel@edumazet-laptop>
	 <1304713443.20980.124.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 May 2011 00:30:04 +0200
Message-ID: <1304721004.2821.148.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 06 mai 2011 à 13:24 -0700, john stultz a écrit :

> So would the easier solution be to just break out timekeeper locking
> from the xtime_lock?
> 
> So basically we would just add a timekeeper.lock seqlock and use it to
> protect only the timekeeping code? We can still keep xtime_lock around
> for the tick/jiffies protection (well, until tglx kills jiffies :), but
> gettimeofday and friends wouldn't be blocked for so long.
> 
> That should be pretty straight forward now that the timekeeper data is
> completely static to timkeeeping.c.
> 

Yes :)

I can see many cpus entering tick_do_update_jiffies64() and all are
calling write_seqlock(&xtime_lock);

Only first one can perform the work, but all others are waiting on the
spinlock, get it, change seqcount, and realize they have nothing to
do...

Meanwhile, a reader must wait that all writers are finished, because of
all seqcount changes storm.

Following patch helps. Of course we might find out why so many cpus (on
my 8 cpus machine !) are calling tick_do_update_jiffies64() at the same
time...


This is basically what I said in my first mail : 

Separate logical sections to reduce windows where readers are blocked/spinning.


diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d5097c4..251b2fe 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -56,7 +56,7 @@ static void tick_do_update_jiffies64(ktime_t now)
 		return;
 
 	/* Reevalute with xtime_lock held */
-	write_seqlock(&xtime_lock);
+	spin_lock(&xtime_lock.lock);
 
 	delta = ktime_sub(now, last_jiffies_update);
 	if (delta.tv64 >= tick_period.tv64) {
@@ -74,12 +74,15 @@ static void tick_do_update_jiffies64(ktime_t now)
 			last_jiffies_update = ktime_add_ns(last_jiffies_update,
 							   incr * ticks);
 		}
+		xtime_lock.sequence++;
+		smp_wmb();
 		do_timer(++ticks);
-
+		smp_wmb();
+		xtime_lock.sequence++;
 		/* Keep the tick_next_period variable up to date */
 		tick_next_period = ktime_add(last_jiffies_update, tick_period);
 	}
-	write_sequnlock(&xtime_lock);
+	spin_unlock(&xtime_lock.lock);
 }
 
 /*





