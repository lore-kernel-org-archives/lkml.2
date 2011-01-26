Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab1AZSpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 13:45:43 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:48979 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab1AZSpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 13:45:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=iCr0UtzNrWjnOv4JCAL/5E45YDjub0jEas2buSEuLoHwzFGQCENo+0Hxqinc9erXDl
         uk4AxckTo6IBJdB81xrxLIZCL3Q5SUbitbZ4qnvC2PqmD4a+XmedMezBwEzwSQxw2Z3V
         VCwrk/HibkFuhSC1OonbADiLKYZv6ERxBcdAQ=
Subject: Re: sys_epoll_wait high CPU load in 2.6.37
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>, Simon Kirby <sim@hostway.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1296065900.2899.108.camel@edumazet-laptop>
References: <20110126000932.GA23089@hostway.ca>
	 <1296026298.2633.19.camel@edumazet-laptop>
	 <1296040578.2899.59.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1101260714280.1889@localhost6.localdomain6>
	 <1296056600.2899.66.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1101260747320.1889@localhost6.localdomain6>
	 <1296057590.2899.73.camel@edumazet-laptop>
	 <1296058409.2899.81.camel@edumazet-laptop>
	 <20110126172006.GA9568@BohrerMBP.rgmadvisors.com>
	 <1296064311.2899.90.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1101261001550.14705@localhost6.localdomain6>
	 <1296065900.2899.108.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jan 2011 19:45:37 +0100
Message-ID: <1296067537.2899.153.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 26 janvier 2011 à 19:18 +0100, Eric Dumazet a écrit :
> Le mercredi 26 janvier 2011 à 10:06 -0800, Davide Libenzi a écrit :
> 
> > Eric, if you look at fs/select.c (~line 925), poll does exactly the same 
> > thing as epoll do.
> > It too, ignores the eventual return value of poll_select_set_timeout(), so 
> > maybe a little bit more optimized ktime_get_ts+timespec_add_ms could make 
> > sense.
> > 
> 
> OK, I'll post a V3 ;)

Well in the poll() case we handle a zero timeout, not in epoll().

So the helper function cannot be shared and can be static to epoll.


[PATCH v3] epoll: epoll_wait() should not use timespec_add_ns()

commit 95aac7b1cd224f (epoll: make epoll_wait() use the hrtimer range
feature) added a performance regression because it uses
timespec_add_ns() with potential very large 'ns' values.

Reported-by: Simon Kirby <sim@hostway.ca>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Shawn Bohrer <shawn.bohrer@gmail.com>
CC: Davide Libenzi <davidel@xmailserver.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 fs/eventpoll.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index cc8a9b7..d517aa3 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1114,6 +1114,17 @@ static int ep_send_events(struct eventpoll *ep,
 	return ep_scan_ready_list(ep, ep_send_events_proc, &esed);
 }
 
+static inline struct timespec epoll_set_mstimeout(long ms)
+{
+	struct timespec now, ts = {
+		.tv_sec = ms / MSEC_PER_SEC,
+		.tv_nsec = NSEC_PER_MSEC * (ms % MSEC_PER_SEC),
+	};
+
+	ktime_get_ts(&now);
+	return timespec_add_safe(now, ts);
+}
+
 static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		   int maxevents, long timeout)
 {
@@ -1121,12 +1132,11 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 	unsigned long flags;
 	long slack;
 	wait_queue_t wait;
-	struct timespec end_time;
 	ktime_t expires, *to = NULL;
 
 	if (timeout > 0) {
-		ktime_get_ts(&end_time);
-		timespec_add_ns(&end_time, (u64)timeout * NSEC_PER_MSEC);
+		struct timespec end_time = epoll_set_mstimeout(timeout);
+
 		slack = select_estimate_accuracy(&end_time);
 		to = &expires;
 		*to = timespec_to_ktime(end_time);


