Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab1HNQJA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:09:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36732 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754483Ab1HNQIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:08:55 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:57 2011
Message-Id: <20110812210557.190724106@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [58/90] net: allow netif_carrier to be called safely from IRQ
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: stephen hemminger <shemminger@vyatta.com>

[ Upstream commit 1821f7cd65ad9ea56580b830ac79bf4c4fef59cb ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/core/link_watch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -126,7 +126,7 @@ static void linkwatch_schedule_work(int
 		return;
 
 	/* It's already running which is good enough. */
-	if (!cancel_delayed_work(&linkwatch_work))
+	if (!__cancel_delayed_work(&linkwatch_work))
 		return;
 
 	/* Otherwise we reschedule it again for immediate execution. */


