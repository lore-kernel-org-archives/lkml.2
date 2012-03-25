Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab2CYF51 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 01:57:27 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:47315 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab2CYF50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 01:57:26 -0400
Date: Sun, 25 Mar 2012 01:57:19 -0400 (EDT)
Message-Id: <20120325.015719.1170644257291462749.davem@davemloft.net>
To: acme@ghostprotocols.net
CC: linux-kernel@vger.kernel.org
Subject: perf crashes related to map/sym mismatch
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 24 Mar 2012 22:57:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have perf crashes that eminate in two different ways, but the cause
seems to be identical.  The two symptoms are:

1) SYM rbtree corruption, pointers have their low bits set.

2) segmentation fault in symbol__inc_addr_samples

   h->addr[offset]++ crashes because offset is "huge" and
   offset is "huge" because addr < sym->start

It turns out that #2 is what causes #1, incrementing random addresses
eventually hits a SYM rbtree linkage address thus corrupting the
pointer to be odd.

Why is "addr" smaller than sym->start?  It's because the 'map' used to
perform ->map_ip() and adjust "ip" in perf_top__record_precise_ip() is
different from the 'map' used earlier to invoke ->map_ip() to
calculate the final al->addr value in thread__find_addr_map().

Basically if al->map != he->ms.map we are in trouble.

As best I can tell this happens because the hist entry sort routines
do not take the map into account when doing comparisons of whether the
symbols of two hist entries are equal.

So you can end up with a hist entry from a lookup which uses a 'map'
on a DSO which is stale and has subsequently been updated from a more
recent MMAP event.  In my case we have two map objects of libc, the
older one in the hist_entry covers:

start = 0xf77bc000
end = 0xf7928000

whereas the newer one in the al->map covers:

start = 0xf765c000
end = 0xf77c8000

The hist_entry map is probably in the current thread's removed_maps
tree, and indeed there is an explicit comment about this in
map_groups__flush()

So it looks like we did a lookup on a symbol in libc pre-exec() and
created a hist_entry for it, then we flush the map groups on the
exec() and in the newly exec'd program we then do a lookup on the same
symbol and this is where we find the hist_entry with the out-of-date
map information.

Perhaps that the right thing to do is to explicitly detect this
situation and flush out the hist_entry with the stale map information
so we can create one with more uptodate mapping info.
