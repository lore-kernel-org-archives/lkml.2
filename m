Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176Ab2ENWA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 18:00:28 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:59806 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757935Ab2ENWAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 18:00:25 -0400
Date: Mon, 14 May 2012 17:59:21 -0400 (EDT)
Message-Id: <20120514.175921.1196526858340183817.davem@davemloft.net>
To: levinsasha928@gmail.com
Cc: edumazet@google.com, dave.taht@bufferbloat.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: codel: fix build errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <1337032626-7104-1-git-send-email-levinsasha928@gmail.com>
References: <1337032626-7104-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 14 May 2012 14:59:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <levinsasha928@gmail.com>
Date: Mon, 14 May 2012 23:57:06 +0200

> Fix the following build error:
  ...
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>

Applied, but:

>  	struct tc_fq_codel_xstats st = {
>  		.type				= TCA_FQ_CODEL_XSTATS_QDISC,
> -		.qdisc_stats.maxpacket		= q->cstats.maxpacket,
> -		.qdisc_stats.drop_overlimit	= q->drop_overlimit,
> -		.qdisc_stats.ecn_mark		= q->cstats.ecn_mark,
> -		.qdisc_stats.new_flow_count	= q->new_flow_count,
>  	};
>  	struct list_head *pos;
>  
> +	st.qdisc_stats.maxpacket = q->cstats.maxpacket;
> +	st.qdisc_stats.drop_overlimit = q->drop_overlimit;
> +	st.qdisc_stats.ecn_mark = q->cstats.ecn_mark;
> +	st.qdisc_stats.new_flow_count = q->new_flow_count;
> +

This is now a very inefficient initialization of this structure.

GCC is going to fill all the non-explictly-initialized fields with
zero, then we'll write to the same fields again in the st.qdisc*
assignments.

Eric please resolve this, I hate knowing we have code like this :-)
