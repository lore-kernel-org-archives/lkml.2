Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab1HWAkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 20:40:18 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60660 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab1HWAkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 20:40:16 -0400
Date: Mon, 22 Aug 2011 17:40:13 -0700 (PDT)
Message-Id: <20110822.174013.353730308624819543.davem@davemloft.net>
To: tim.c.chen@linux.intel.com
Cc: eric.dumazet@gmail.com, viro@zeniv.linux.org.uk, ebiederm@xmission.com,
        ak@linux.intel.com, matt.fleming@linux.intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [Patch] Scm: Remove unnecessary pid & credential references in
 Unix socket's send and receive path
From: David Miller <davem@davemloft.net>
In-Reply-To: <1313772298.2576.2916.camel@schen9-DESK>
References: <1313625374.2576.2908.camel@schen9-DESK>
	<20110818.220432.1711182086933489213.davem@davemloft.net>
	<1313772298.2576.2916.camel@schen9-DESK>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 22 Aug 2011 17:40:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Chen <tim.c.chen@linux.intel.com>
Date: Fri, 19 Aug 2011 09:44:58 -0700

> -		/* Only send the fds in the first buffer */
> -		err = unix_scm_to_skb(siocb->scm, skb, !fds_sent);
> +		/* Only send the fds and no ref to pid in the first buffer */
> +		if (fds_sent)
> +			err = unix_scm_to_skb(siocb->scm, skb, !fds_sent, true);
> +		else
> +			err = unix_scm_to_skb(siocb->scm, skb, !fds_sent, false);

Just set this final boolean the way the third argument is, there is no
reason to replicate the entire function call twice just to set the
final argument to what "fds_sent" evaluates to as a boolean.

		err = unix_scm_to_skb(siocb->scm, skb, !fds_sent, fds_sent);

ought to suffice.
