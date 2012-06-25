Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699Ab2FYWkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 18:40:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56282 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757430Ab2FYWks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 18:40:48 -0400
Date: Mon, 25 Jun 2012 15:40:47 -0700 (PDT)
Message-Id: <20120625.154047.462435723648654696.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: johunt@akamai.com, kaber@trash.net, dbavatar@gmail.com,
        netdev@vger.kernel.org, yoshfuji@linux-ipv6.org, jmorris@namei.org,
        pekkas@netcore.fi, kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        greearb@candelatech.com
Subject: Re: Bug in net/ipv6/ip6_fib.c:fib6_dump_table()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1340429851.4604.11942.camel@edumazet-glaptop>
References: <1340388785.4604.11442.camel@edumazet-glaptop>
	<20120622.170237.1504103690155447356.davem@davemloft.net>
	<1340429851.4604.11942.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sat, 23 Jun 2012 07:37:31 +0200

> [PATCH] ipv6: fib: fix fib dump restart
> 
> Commit 2bec5a369ee79576a3 (ipv6: fib: fix crash when changing large fib
> while dumping it) introduced ability to restart the dump at tree root,
> but failed to skip correctly a count of already dumped entries. Code
> didn't match Patrick intent.
> 
> We must skip exactly the number of already dumped entries.
> 
> Note that like other /proc/net files or netlink producers, we could
> still dump some duplicates entries.
> 
> Reported-by: Debabrata Banerjee <dbavatar@gmail.com>
> Reported-by: Josh Hunt <johunt@akamai.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

I've applied this.

But I wonder if it does the right thing, to be honest.

When tree change is detected, w->skip is set to w->count

But with your change, w->count won't be the number of entries to
skip from the root after the first time we handle a tree change.

So on the second tree change, we'll skip the wrong number of
entries, since the w->count we save into w->skip will be biased
by the previous w->skip value.  So we'll skip too few entries.

