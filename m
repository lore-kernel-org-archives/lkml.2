Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964976Ab2EWDXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 23:23:17 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53860 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729Ab2EWDXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 23:23:16 -0400
Date: Tue, 22 May 2012 23:23:10 -0400 (EDT)
Message-Id: <20120522.232310.911242148705021745.davem@davemloft.net>
To: yanmin_zhang@linux.intel.com
Cc: kunx.jiang@intel.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv4: fix the rcu race between free_fib_info and
 ip_route_output_slow
From: David Miller <davem@davemloft.net>
In-Reply-To: <1337742123.14538.175.camel@ymzhang.sh.intel.com>
References: <4FBB6105.2060808@intel.com>
	<20120522.151554.106838106733194160.davem@davemloft.net>
	<1337742123.14538.175.camel@ymzhang.sh.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 22 May 2012 20:23:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Date: Wed, 23 May 2012 11:02:03 +0800

> 1) Why does free_fib_info call call_rcu instead of releasing fi directly?
> I assume other cpu might be accessing it. nexthop_nh->nh_dev is in fi.
> If other cpu are accessing it, here resetting to NULL would cause other
> cpu panic.

Because fib trie lookups are done with RCU locking, therefore we must
use RCU freeing to release the object.

What I was trying to impart to you is that removing the NULL
assignment is wrong and that an alternative fix is warranted (hint:
consider moving something into the RCU release).
