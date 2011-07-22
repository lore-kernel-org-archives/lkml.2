Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab1GVWxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 18:53:52 -0400
Received: from mail.vyatta.com ([76.74.103.46]:42009 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252Ab1GVWxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 18:53:51 -0400
Date: Fri, 22 Jul 2011 15:53:56 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>
Cc: Francois Romieu <romieu@fr.zoreil.com>,
        Ben Greear <greearb@candelatech.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David <david@unsolicited.net>, Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: [PATCH] net: allow netif_carrier to be called safely from IRQ
Message-ID: <20110722155356.5911225f@nehalam.ftrdhcpuser.net>
In-Reply-To: <20110722150956.5b341488@nehalam.ftrdhcpuser.net>
References: <CA+55aFxakA2U+oMJ1T7awTYa+p6xp9N0aCbfrUqgkF7BJ8gnQw@mail.gmail.com>
	<4E29CB5B.4040408@unsolicited.net>
	<CA+55aFy1FnVGH4C_0T8fXwZPUdz5-SCczMwy1K8kydLwTx89RQ@mail.gmail.com>
	<4E29D326.7070403@candelatech.com>
	<20110722133220.0baf2199@nehalam.ftrdhcpuser.net>
	<20110722212629.GA10833@electric-eye.fr.zoreil.com>
	<20110722150956.5b341488@nehalam.ftrdhcpuser.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As reported by Ben Greer and Froncois Romieu. The code path in 
the netif_carrier code leads it to try and disable
a late workqueue to reenable it immediately
netif_carrier_on
-> linkwatch_fire_event
   -> linkwatch_schedule_work
      -> cancel_delayed_work
         -> del_timer_sync  

If __cancel_delayed_work is used instead then there is no
problem of waiting for running linkwatch_event.

There is a race between linkwatch_event running re-scheduling
but it is harmless to schedule an extra scan of the linkwatch queue.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>


--- a/net/core/link_watch.c	2011-07-22 15:25:31.027533604 -0700
+++ b/net/core/link_watch.c	2011-07-22 15:31:27.531520028 -0700
@@ -126,7 +126,7 @@ static void linkwatch_schedule_work(int
 		return;
 
 	/* It's already running which is good enough. */
-	if (!cancel_delayed_work(&linkwatch_work))
+	if (!__cancel_delayed_work(&linkwatch_work))
 		return;
 
 	/* Otherwise we reschedule it again for immediate execution. */

