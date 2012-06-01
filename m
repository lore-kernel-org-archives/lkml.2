Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964895Ab2FAP3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:29:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861Ab2FAP3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 11:29:20 -0400
Subject: Re: seq_file: Use larger buffer to reduce time traversing lists
From: Steven Whitehouse <swhiteho@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        Al Viro <viro@zeniv.linux.org.uk>, nstraz@redhat.com
In-Reply-To: <1338562627.2760.1526.camel@edumazet-glaptop>
References: <1338547193.2708.16.camel@menhir>
	 <1338552626.2760.1510.camel@edumazet-glaptop>
	 <1338553486.2708.25.camel@menhir>
	 <1338554890.2760.1517.camel@edumazet-glaptop>
	 <1338556468.2708.41.camel@menhir>
	 <1338557229.2760.1520.camel@edumazet-glaptop>
	 <1338560283.2708.59.camel@menhir>
	 <1338562627.2760.1526.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Fri, 01 Jun 2012 16:28:20 +0100
Message-ID: <1338564500.2708.73.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2012-06-01 at 16:57 +0200, Eric Dumazet wrote:
> On Fri, 2012-06-01 at 15:18 +0100, Steven Whitehouse wrote:
> > 	0m0.374s
> > 
> > So even with the current tcp scheme this appears to speed things up by
> > nearly 3x. Also that was with only 28000 entries in the file,
> 
> Initial speedup was 100x, not 3x.
> 
According to the patch description, that 100x was with 182k entries.
That is not comparing like with like, although I accept that that did
provide a really good improvement. I'm not suggesting that we should
have one approach or the other, but that both are worth considering.
I'll certainly have a look at the hash table based approach too.

> Of course using a 32KB buffer instead of 4KB will help.
> 
> And If someones need 100.000 active unix sockets and fast /proc/net/udp
> file as well, patch is welcome. If I have time I can do it eventually.
> 
> Really, kmalloc(2 MB) is not going to happen, even using __GFP_NOWARN
> 
It is designed so that if this allocation fails, then we just fall back
to the old slow way, so I'm not sure that this is an issue. It will not
fail to work just because the initial kmalloc fails, so we would be no
worse off than with the current code, and we could also trim down the
top size limit to something a bit smaller than KMALLOC_MAX_SIZE and
still get most of the benefit. I just chose that as a convenient upper
limit to show the principle.

Also, I think it wouldn't be unreasonable to argue that if the
probability of a KMALLOC_MAX_SIZE allocation failing is so high that it
is very unlikely to ever succeed, then perhaps KMALLOC_MAX_SIZE is too
large.

So I know that I might have not convinced you :-) but I still think that
perhaps something along these lines is worth considering. I had looked
at various other possible ways of achieving a similar effect but all of
those I rejected in the end, as they fell foul of some of the subtleties
of the seq_read() code,

Steve.


