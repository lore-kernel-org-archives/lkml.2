Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab2KTSyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 13:54:13 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:42764 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab2KTSyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 13:54:11 -0500
Date: Tue, 20 Nov 2012 13:54:09 -0500 (EST)
Message-Id: <20121120.135409.1810847883436963918.davem@davemloft.net>
To: paolo.valente@unimore.it
Cc: jhs@mojatatu.com, shemminger@vyatta.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rizzo@iet.unipi.it, fchecconi@gmail.com
Subject: Re: [PATCH] pkt_sched: QFQ Plus: fair-queueing service at DRR cost
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121120174513.GA21618@paolo-ThinkPad-W520>
References: <20121120174513.GA21618@paolo-ThinkPad-W520>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo Valente <paolo.valente@unimore.it>
Date: Tue, 20 Nov 2012 18:45:13 +0100

> -	struct sk_buff *skb;
> +	struct sk_buff *skb = NULL;

This is not really an improvement, now the compiler can think
that NULL is passed eventually into qdisc_bstats_update().

Please make the logic easier for the compiler to digest.

For example, restructure the top-level logic into something like:

	skb = NULL;
	if (!list_empty(&in_serv_agg->active))
		skb = qfq_peek_skb(in_serv_agg, &cl, &len);
	else
		len = 0; /* no more active classes in the in-service agg */

	if (len == 0 || in_serv_agg->budget < len) {
 ...
		/*
		 * If we get here, there are other aggregates queued:
		 * choose the new aggregate to serve.
		 */
		in_serv_agg = q->in_serv_agg = qfq_choose_next_agg(q);
		skb = qfq_peek_skb(in_serv_agg, &cl, &len);
	}
	if (!skb)
		return NULL;

That way it is clearer, to both humans and the compiler, what is
going on here.

Thanks.
