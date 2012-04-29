Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab2D2IqP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 04:46:15 -0400
Received: from hosting.visp.net.lb ([194.146.153.11]:52969 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab2D2IqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 04:46:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sun, 29 Apr 2012 11:46:05 +0300
From: Denys Fedoryshchenko <denys@visp.net.lb>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: <netdev@vger.kernel.org>, <davem@davemloft.net>, <jmorris@namei.org>,
        <yoshfuji@linux-ipv6.org>, <kaber@trash.net>,
        <linux-kernel@vger.kernel.org>, Glauber Costa <glommer@parallels.com>
Subject: Re: inconsistent lock/deadlock crash, vanilla 3.3.4, 32bit, tcp
In-Reply-To: <1335688036.2900.80.camel@edumazet-glaptop>
References: <13fc59c8e3be34ddb3c7bb5c17b1bdf8@visp.net.lb>
 <1335688036.2900.80.camel@edumazet-glaptop>
Message-ID: <4ba0969cecac9a8e677d1b1eed1a5742@visp.net.lb>
User-Agent: VISP Webmail/0.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-29 11:27, Eric Dumazet wrote:
>
>
> OK, so when we have memory pressure we can call
> percpu_counter_read_positive() with SOFTIRQ enabled, and lockdep
> complains...
>
> This bug was probably added in 2008, in commit 1748376b6626a
> (net: Use a percpu_counter for sockets_allocated)
>
> I'll have to backport the following patch, can you test it please ?
>
> Thanks !
>
>  net/core/sock.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/core/sock.c b/net/core/sock.c
> index b2e14c0..08fc929 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1818,7 +1818,9 @@ int __sk_mem_schedule(struct sock *sk, int
> size, int kind)
>
>  		if (!sk_under_memory_pressure(sk))
>  			return 1;
> +		local_bh_disable();
>  		alloc = sk_sockets_allocated_read_positive(sk);
> +		local_bh_enable();
>  		if (sk_prot_mem_limits(sk, 2) > alloc *
>  		    sk_mem_pages(sk->sk_wmem_queued +
>  				 atomic_read(&sk->sk_rmem_alloc) +

I will try to deploy it and test as soon as someone will powercycle 
server on other side.

