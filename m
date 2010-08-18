Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751006Ab0HRHBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 03:01:45 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:46043 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750757Ab0HRHBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 03:01:41 -0400
X-Sasl-enc: Ko4f/imtTTfHI+8VhkjFFzTkxPxBsBXNLx+23IqPczuB 1282114899
Message-ID: <4C6B8562.1070902@ladisch.de>
Date: Wed, 18 Aug 2010 09:01:54 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Yong Zhang <yong.zhang0@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: lockdep false positive? -- firewire-core transaction timer vs.
 scsi-core host lock
References: <tkrat.1e48e021935dc8b7@s5r6.in-berlin.de>	<20100817143509.GC2838@zhy> <4C6AB76C.9060809@s5r6.in-berlin.de>
In-Reply-To: <4C6AB76C.9060809@s5r6.in-berlin.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Yong Zhang wrote:
> > I suspect it's introduced by commit 5c40cbfefa828208c671e2f58789e4dd04f79563
> > which call del_timer_sync() in softirq.
> > 
> > comments on del_timer_sync() say "It must not be called from interrupt contexts."
> 
> I hope the del_timer_sync kerneldoc comment is about hardIRQ context,

Then both the comment and its lockdep code would be wrong.

> *otherwise* commit 5c40cbfe is defective indeed.

--8<---------------------------------------------------------------->8--
firewire: core: do not use del_timer_sync() in interrupt context

Because we might be in interrupt context, replace del_timer_sync() with
del_timer().  If the timer was already running when we tried to delete
it, explicitly wait for it to finish to ensure that it does not access
the transaction data after the normal completion code might have freed
it.

Many thanks to Yong Zhang for diagnosing this and to Rusty Russell for
his Locking Guide.

Reported-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
---
 drivers/firewire/core-transaction.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -78,9 +78,16 @@ static int close_transaction(struct fw_t
 	struct fw_transaction *t;
 	unsigned long flags;
 
+retry:
 	spin_lock_irqsave(&card->lock, flags);
 	list_for_each_entry(t, &card->transaction_list, link) {
 		if (t == transaction) {
+			if (!del_timer(&t->split_timeout_timer)) {
+				/* wait for the timer to cancel it */
+				spin_unlock_irqrestore(&card->lock, flags);
+				cpu_relax();
+				goto retry;
+			}
 			list_del_init(&t->link);
 			card->tlabel_mask &= ~(1ULL << t->tlabel);
 			break;
@@ -89,7 +96,6 @@ static int close_transaction(struct fw_t
 	spin_unlock_irqrestore(&card->lock, flags);
 
 	if (&t->link != &card->transaction_list) {
-		del_timer_sync(&t->split_timeout_timer);
 		t->callback(card, rcode, NULL, 0, t->callback_data);
 		return 0;
 	}
@@ -918,9 +924,16 @@ void fw_core_handle_response(struct fw_c
 	source	= HEADER_GET_SOURCE(p->header[1]);
 	rcode	= HEADER_GET_RCODE(p->header[1]);
 
+retry:
 	spin_lock_irqsave(&card->lock, flags);
 	list_for_each_entry(t, &card->transaction_list, link) {
 		if (t->node_id == source && t->tlabel == tlabel) {
+			if (!del_timer(&t->split_timeout_timer)) {
+				/* wait for the timer to cancel it */
+				spin_unlock_irqrestore(&card->lock, flags);
+				cpu_relax();
+				goto retry;
+			}
 			list_del_init(&t->link);
 			card->tlabel_mask &= ~(1ULL << t->tlabel);
 			break;
@@ -963,8 +976,6 @@ void fw_core_handle_response(struct fw_c
 		break;
 	}
 
-	del_timer_sync(&t->split_timeout_timer);
-
 	/*
 	 * The response handler may be executed while the request handler
 	 * is still pending.  Cancel the request handler.
