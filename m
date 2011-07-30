Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab1G3MRP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 08:17:15 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33546 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab1G3MRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 08:17:12 -0400
Subject: Re: RCU: how to suppress warnings from rcu_assign_pointer?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: paulmck@linux.vnet.ibm.com, Michael Chan <mchan@broadcom.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110729105058.2cb9fa86@nehalam.ftrdhcpuser.net>
References: <20110728142723.77a2c308@nehalam.ftrdhcpuser.net>
	 <20110728214442.GV2403@linux.vnet.ibm.com>
	 <20110728145510.0ec0db01@nehalam.ftrdhcpuser.net>
	 <20110729003843.GA2373@linux.vnet.ibm.com>
	 <20110729105058.2cb9fa86@nehalam.ftrdhcpuser.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Jul 2011 14:17:05 +0200
Message-ID: <1312028225.2873.104.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 29 juillet 2011 à 10:50 -0700, Stephen Hemminger a écrit :
> Gcc now generates warnings from rcu_assign_pointer when passed the
> address of something for example:
> 	rcu_assign_pointer(dev_queue->qdisc, &noop_qdisc);
> This warning is harmless and should be surpressed but there maybe
> other cases where we want that Gcc warning.
> 
> I tried various combinations of in rcu_assign_pointer macro
>   #pragma GCC diagnostic push
>   #pragma GCC diagnostic ignored "-Wlogical-op"
>   ...
>   #pragma GCC diagnostic pop
> but macro's and pragma's don't nest with the correct scope for
> this.
> 
> Maybe some one with more Gcc foo and time to waste could take
> a crack at it.

I would just remove the test from rcu_assign_pointer().

We now have RCU_INIT_POINTER() for places we dont want/afford the
smp_wmb()


diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 8f4f881..f372e88 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -365,9 +365,7 @@ extern int rcu_my_thread_group_empty(void);
 	})
 #define __rcu_assign_pointer(p, v, space) \
 	({ \
-		if (!__builtin_constant_p(v) || \
-		    ((v) != NULL)) \
-			smp_wmb(); \
+		smp_wmb(); \
 		(p) = (typeof(*v) __force space *)(v); \
 	})
 


