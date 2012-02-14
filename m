Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab2BNA7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 19:59:18 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:39953 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab2BNA7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 19:59:15 -0500
Date: Mon, 13 Feb 2012 19:58:35 -0500 (EST)
Message-Id: <20120213.195835.1573147101037168145.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: mroos@linux.ee, rob.herring@calxeda.com, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120213214623.GJ11077@ponder.secretlab.ca>
References: <20120213080618.GA11077@ponder.secretlab.ca>
	<alpine.SOC.1.00.1202131119040.1488@math.ut.ee>
	<20120213214623.GJ11077@ponder.secretlab.ca>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 13 Feb 2012 16:58:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 13 Feb 2012 14:46:23 -0700

> Ugh; that looks bad.  If it failed there, then the global device node list
> is corrupted.  I hate to ask you this, but would you be able to git bisect to
> narrow down the commit that causes the problem?

Wild guess on all of these bugs, bad OF node reference counting and a
OF node is free'd up prematurely.

If you look at the sparc code that has been subsumed into the generic
drivers/of/ stuff over the past few years, you'll see that we never
consistently did any of the reference counting bits on the sparc side.

I never did it, because I don't anticipate ever having hot-plug
support for OF nodes.

Anyways, if you now start to mix the drivers/of/ stuff which
religiously does the reference counting with of_node_{get,put}()
with the remaining scraps of sparc code that doesn't... it might
not be pretty.

In the crash dump after your test patch, we are in
of_find_node_by_phandle() with a 'np' pointer in the allnodes list
equal to 0x50.

The signature in the original crash dump is identical, except
that time we were in of_find_node_by_path(), but again the 'np'
pointer was 0x50.

Something else that might be suspicious were the memblock changes
that happened this release cycle, so I wouldn't be surprised if
a bisect turned up something in there.

FWIW I've been running current kernels on my niagara boxes without
incident for several weeks.
