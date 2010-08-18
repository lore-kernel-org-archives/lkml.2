Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab0HRMuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 08:50:52 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48130 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab0HRMut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 08:50:49 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 18 Aug 2010 14:50:25 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: lockdep false positive? -- firewire-core transaction timer vs.
 scsi-core host lock
To: Clemens Ladisch <clemens@ladisch.de>
cc: Peter Zijlstra <peterz@infradead.org>, Yong Zhang <yong.zhang0@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <4C6BA757.7050108@ladisch.de>
Message-ID: <tkrat.2aa42a952e4df4b1@s5r6.in-berlin.de>
References: <tkrat.1e48e021935dc8b7@s5r6.in-berlin.de> 
 <20100817143509.GC2838@zhy> <4C6AB76C.9060809@s5r6.in-berlin.de> 
 <4C6B8562.1070902@ladisch.de> <1282121942.1926.3552.camel@laptop>
 <4C6BA757.7050108@ladisch.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clemens Ladisch wrote:
> firewire: core: do not use del_timer_sync() in interrupt context
> 
> Because we might be in interrupt context, replace del_timer_sync() with
> del_timer().

OK.  And thanks for the pointers into the locking guide.

> If the timer is already running, we know that it will
> clean up the transaction, so we do not need to do any further processing
> in the normal transaction handler.
> 
> Many thanks to Yong Zhang for diagnosing this.
> 
> Reported-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
> ---
>  drivers/firewire/core-transaction.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> --- a/drivers/firewire/core-transaction.c
> +++ b/drivers/firewire/core-transaction.c
> @@ -81,6 +81,8 @@ static int close_transaction(struct fw_transaction *transaction,
>  	spin_lock_irqsave(&card->lock, flags);
>  	list_for_each_entry(t, &card->transaction_list, link) {
>  		if (t == transaction) {
> +			if (!del_timer(&t->split_timeout_timer))
> +				goto timed_out;

+			if (!del_timer(&t->split_timeout_timer)) {
+				spin_unlock_irqrestore(&card->lock, flags);
+				goto timed_out;
+			}

>  			list_del_init(&t->link);
>  			card->tlabel_mask &= ~(1ULL << t->tlabel);
>  			break;
> @@ -89,11 +91,11 @@ static int close_transaction(struct fw_transaction *transaction,
>  	spin_unlock_irqrestore(&card->lock, flags);
>  
>  	if (&t->link != &card->transaction_list) {
> -		del_timer_sync(&t->split_timeout_timer);
>  		t->callback(card, rcode, NULL, 0, t->callback_data);
>  		return 0;
>  	}
>  
> +timed_out:
>  	return -ENOENT;
>  }
>  
> @@ -921,6 +923,8 @@ void fw_core_handle_response(struct fw_card *card, struct fw_packet *p)
>  	spin_lock_irqsave(&card->lock, flags);
>  	list_for_each_entry(t, &card->transaction_list, link) {
>  		if (t->node_id == source && t->tlabel == tlabel) {
> +			if (!del_timer(&t->split_timeout_timer))
> +				goto timed_out;

Ditto.

>  			list_del_init(&t->link);
>  			card->tlabel_mask &= ~(1ULL << t->tlabel);
>  			break;
> @@ -929,6 +933,7 @@ void fw_core_handle_response(struct fw_card *card, struct fw_packet *p)
>  	spin_unlock_irqrestore(&card->lock, flags);
>  
>  	if (&t->link == &card->transaction_list) {
> +timed_out:
>  		fw_notify("Unsolicited response (source %x, tlabel %x)\n",
>  			  source, tlabel);
>  		return;
> @@ -963,8 +968,6 @@ void fw_core_handle_response(struct fw_card *card, struct fw_packet *p)
>  		break;
>  	}
>  
> -	del_timer_sync(&t->split_timeout_timer);
> -
>  	/*
>  	 * The response handler may be executed while the request handler
>  	 * is still pending.  Cancel the request handler.

Shall I commit with the added spin_unlocks?  Or do you prefer to send an update?
-- 
Stefan Richter
-=====-==-=- =--- =--=-
http://arcgraph.de/sr/

