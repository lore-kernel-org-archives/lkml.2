Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab2FWU4h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 16:56:37 -0400
Received: from minus.inr.ac.ru ([194.67.69.97]:48968 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754673Ab2FWU4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 16:56:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=CVuSqQhhAO0OiGDxnym5p2SZn/zS9bM/bqcllAVV22nrZrmtpfoL++saQmferaOTgk8yIG1OxVzA3XrzN0McH5LJihg43Z039Zn+J7AbfEGaH3Y4ehVqqF9EgOaF2IlNLF0c6K158Lkxfd/bWgWIwHMzEQUIYdFjnKaj/9ENmHU=;
Date: Sun, 24 Jun 2012 00:55:46 +0400
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, johunt@akamai.com, kaber@trash.net,
        dbavatar@gmail.com, netdev@vger.kernel.org, yoshfuji@linux-ipv6.org,
        jmorris@namei.org, pekkas@netcore.fi, linux-kernel@vger.kernel.org,
        Ben Greear <greearb@candelatech.com>
Subject: Re: Bug in net/ipv6/ip6_fib.c:fib6_dump_table()
Message-ID: <20120623205546.GA15964@ms2.inr.ac.ru>
References: <1340353746.4604.9502.camel@edumazet-glaptop> <4FE476A6.1050209@akamai.com> <1340388785.4604.11442.camel@edumazet-glaptop> <20120622.170237.1504103690155447356.davem@davemloft.net> <1340429851.4604.11942.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340429851.4604.11942.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 07:37:31AM +0200, Eric Dumazet wrote:
> All other /proc/net files don't have a such sophisticated walkers aware
> mechanism

I can explain why.

IPv6 routing table has a capital management drawback: core policy rules are mixed
with dynamic cache and addrconf routes in one structure.
(BTW it is one of reasons why I did not want to integrate routing cache to fib for IPv4)

Do you see the problem? F.e. when you do iptables-save, you do not expect
that it can occasionally miss some rules (unless you mess with it in parallel, of course)
The same is here. When you dump routing table, you are allowed to miss some cache routes,
but if you have a chance to miss at least one of important routes just because
unimportant dynamic part is alway under change, it is fatal.

There are a lot of ways to solve the problem, all of them have some flaws.
F.e. I can remember:
* atomic dump like bsd sysctl.
* keeping administrative routes in a separate list, which can be walked using skip/count
etc.

This way with walkers I chose because it looked quite optimal and because
it was an exciting little task for brains . :-)


> (easily DOSable by the way, if some guy opens 10.000 handles
> and suspend in the middle the dumps).

This is true. The easiest way to fix this is just to limit amount of readers,
putting them on hold.

Alexey
