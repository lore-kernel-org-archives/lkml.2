Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819Ab2HHWut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 18:50:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47301 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab2HHWur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 18:50:47 -0400
Date: Wed, 08 Aug 2012 15:50:46 -0700 (PDT)
Message-Id: <20120808.155046.820543563969484712.davem@davemloft.net>
To: mgorman@suse.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad@darnok.org,
        Ian.Campbell@eu.citrix.com, akpm@linux-foundation.org
Subject: Re: [PATCH] netvm: check for page == NULL when propogating the
 skb->pfmemalloc flag
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120807085554.GF29814@suse.de>
References: <20120807085554.GF29814@suse.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mel Gorman <mgorman@suse.de>
Date: Tue, 7 Aug 2012 09:55:55 +0100

> Commit [c48a11c7: netvm: propagate page->pfmemalloc to skb] is responsible
> for the following bug triggered by a xen network driver
 ...
> The problem is that the xenfront driver is passing a NULL page to
> __skb_fill_page_desc() which was unexpected. This patch checks that
> there is a page before dereferencing.
> 
> Reported-and-Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

That call to __skb_fill_page_desc() in xen-netfront.c looks completely bogus.
It's the only driver passing NULL here.

That whole song and dance figuring out what to do with the head
fragment page, depending upon whether the length is greater than the
RX_COPY_THRESHOLD, is completely unnecessary.

Just use something like a call to __pskb_pull_tail(skb, len) and all
that other crap around that area can simply be deleted.
