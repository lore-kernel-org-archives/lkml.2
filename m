Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab0HRJ0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 05:26:35 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:50998 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751992Ab0HRJ0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 05:26:32 -0400
X-Sasl-enc: nrg97SO9r5Faa9Rsj2oNBf8rzApRc5eGgzL3nxZvhztB 1282123591
Message-ID: <4C6BA757.7050108@ladisch.de>
Date: Wed, 18 Aug 2010 11:26:47 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Yong Zhang <yong.zhang0@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: lockdep false positive? -- firewire-core transaction timer vs.
 scsi-core host lock
References: <tkrat.1e48e021935dc8b7@s5r6.in-berlin.de>	 <20100817143509.GC2838@zhy> <4C6AB76C.9060809@s5r6.in-berlin.de>	 <4C6B8562.1070902@ladisch.de> <1282121942.1926.3552.camel@laptop>
In-Reply-To: <1282121942.1926.3552.camel@laptop>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Wed, 2010-08-18 at 09:01 +0200, Clemens Ladisch wrote:
> > +retry:
> >         spin_lock_irqsave(&card->lock, flags);
> >         list_for_each_entry(t, &card->transaction_list, link) {
> >                 if (t == transaction) {
> > +                       if (!del_timer(&t->split_timeout_timer)) {
> > +                               /* wait for the timer to cancel it */
> > +                               spin_unlock_irqrestore(&card->lock, flags);
> > +                               cpu_relax();
> > +                               goto retry;
> > +                       } 
> 
> Open-coding spin loops like that is really ugly, and could cause trouble
> for -rt.
> 
> Also, I believe that if you want the very same semantics as before, you
> need to use try_to_del_timer_sync(), not del_timer().

Like del_timer_sync(), it "must not be called from interrupt contexts."

> Also, if del_timer_sync() is not allowed from any interrupt context
> (including softirq) then doing the spin-loop like that doesn't actually
> solve anything.

Why?

Anyway, my first patch was crap because the loop isn't actually
necessary:

--8<---------------------------------------------------------------->8--
firewire: core: do not use del_timer_sync() in interrupt context

Because we might be in interrupt context, replace del_timer_sync() with
del_timer().  If the timer is already running, we know that it will
clean up the transaction, so we do not need to do any further processing
in the normal transaction handler.

Many thanks to Yong Zhang for diagnosing this.

Reported-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
---
 drivers/firewire/core-transaction.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -81,6 +81,8 @@ static int close_transaction(struct fw_transaction *transaction,
 	spin_lock_irqsave(&card->lock, flags);
 	list_for_each_entry(t, &card->transaction_list, link) {
 		if (t == transaction) {
+			if (!del_timer(&t->split_timeout_timer))
+				goto timed_out;
 			list_del_init(&t->link);
 			card->tlabel_mask &= ~(1ULL << t->tlabel);
 			break;
@@ -89,11 +91,11 @@ static int close_transaction(struct fw_transaction *transaction,
 	spin_unlock_irqrestore(&card->lock, flags);
 
 	if (&t->link != &card->transaction_list) {
-		del_timer_sync(&t->split_timeout_timer);
 		t->callback(card, rcode, NULL, 0, t->callback_data);
 		return 0;
 	}
 
+timed_out:
 	return -ENOENT;
 }
 
@@ -921,6 +923,8 @@ void fw_core_handle_response(struct fw_card *card, struct fw_packet *p)
 	spin_lock_irqsave(&card->lock, flags);
 	list_for_each_entry(t, &card->transaction_list, link) {
 		if (t->node_id == source && t->tlabel == tlabel) {
+			if (!del_timer(&t->split_timeout_timer))
+				goto timed_out;
 			list_del_init(&t->link);
 			card->tlabel_mask &= ~(1ULL << t->tlabel);
 			break;
@@ -929,6 +933,7 @@ void fw_core_handle_response(struct fw_card *card, struct fw_packet *p)
 	spin_unlock_irqrestore(&card->lock, flags);
 
 	if (&t->link == &card->transaction_list) {
+timed_out:
 		fw_notify("Unsolicited response (source %x, tlabel %x)\n",
 			  source, tlabel);
 		return;
@@ -963,8 +968,6 @@ void fw_core_handle_response(struct fw_card *card, struct fw_packet *p)
 		break;
 	}
 
-	del_timer_sync(&t->split_timeout_timer);
-
 	/*
 	 * The response handler may be executed while the request handler
 	 * is still pending.  Cancel the request handler.
