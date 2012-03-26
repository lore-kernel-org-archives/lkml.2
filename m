Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099Ab2CZRXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 13:23:19 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52331 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932742Ab2CZRXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 13:23:18 -0400
Date: Mon, 26 Mar 2012 14:23:13 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: perf crashes related to map/sym mismatch
Message-ID: <20120326172313.GM25820@infradead.org>
References: <20120325.015719.1170644257291462749.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120325.015719.1170644257291462749.davem@davemloft.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Mar 25, 2012 at 01:57:19AM -0400, David Miller escreveu:
> 
> I have perf crashes that eminate in two different ways, but the cause
> seems to be identical.  The two symptoms are:
> 
> 1) SYM rbtree corruption, pointers have their low bits set.
> 
> 2) segmentation fault in symbol__inc_addr_samples
> 
>    h->addr[offset]++ crashes because offset is "huge" and
>    offset is "huge" because addr < sym->start
> 
> It turns out that #2 is what causes #1, incrementing random addresses
> eventually hits a SYM rbtree linkage address thus corrupting the
> pointer to be odd.

Agreed
 
> Why is "addr" smaller than sym->start?  It's because the 'map' used to
> perform ->map_ip() and adjust "ip" in perf_top__record_precise_ip() is
> different from the 'map' used earlier to invoke ->map_ip() to
> calculate the final al->addr value in thread__find_addr_map().
> 
> Basically if al->map != he->ms.map we are in trouble.
> 
> As best I can tell this happens because the hist entry sort routines
> do not take the map into account when doing comparisons of whether the
> symbols of two hist entries are equal.

And this seems the problematic part
 
> So you can end up with a hist entry from a lookup which uses a 'map'
> on a DSO which is stale and has subsequently been updated from a more
> recent MMAP event.  In my case we have two map objects of libc, the
> older one in the hist_entry covers:
> 
> start = 0xf77bc000
> end = 0xf7928000
> 
> whereas the newer one in the al->map covers:
> 
> start = 0xf765c000
> end = 0xf77c8000

Having multiple hists seems the way to go, i.e. we still would have the
hits that happened to that old map constrained to it, i.e.  annotation,
etc would work on them and the new hits, that take place after the
previous one was retired would be associated with the new one, no?
 
> The hist_entry map is probably in the current thread's removed_maps
> tree, and indeed there is an explicit comment about this in
> map_groups__flush()
> 
> So it looks like we did a lookup on a symbol in libc pre-exec() and
> created a hist_entry for it, then we flush the map groups on the
> exec() and in the newly exec'd program we then do a lookup on the same
> symbol and this is where we find the hist_entry with the out-of-date
> map information.
> 
> Perhaps that the right thing to do is to explicitly detect this
> situation and flush out the hist_entry with the stale map information
> so we can create one with more uptodate mapping info.

Checking hist_entry->ms.map would solve this case, I think.

Will read this code a bit more to check possible complications...

- Arnaldo
