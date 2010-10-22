Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab0JVX6O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:58:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755702Ab0JVX6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:58:12 -0400
Date: Fri, 22 Oct 2010 16:57:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christian Bahls <lkml@qb352.de>
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: __pm_runtime_resume() returns -1 Was: Regression in 2.6.36
Message-Id: <20101022165734.d7ed2582.akpm@linux-foundation.org>
In-Reply-To: <AANLkTinPyg2ijrBydVyoGJiQJCpL7j1_vnyQWnx0eucz@mail.gmail.com>
References: <AANLkTinPyg2ijrBydVyoGJiQJCpL7j1_vnyQWnx0eucz@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010 15:38:01 +0200
Christian Bahls <lkml@qb352.de> wrote:

> Thanks to the help by Matthias Schniedermeyer
>  i was able to bisect the change in less than 24 hours
> 
> The regression seems to have been introduced by the merge:
>   92b4522f72916ff2675060e29e4b24cf26ab59ce
> 
> Parent: 67a3e12b05e055c0415c556a315a3d3eb637e29e (Linux 2.6.35-rc1)
> Parent: 2903037400a26e7c0cc93ab75a7d62abfacdf485 (net: fix
> sk_forward_alloc corruptions)
> Branches: compile, remotes/origin/master, work
> Follows: v2.6.35-rc1
> Precedes: v2.6.36-rc1
> 
>     Merge branch 'master' of
> master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6
> 
> Which (according to git bisect visualize) contains following Change:
> 
> Author: Eric Dumazet <eric.dumazet@gmail.com>  2010-05-29 09:20:48
> Committer: David S. Miller <davem@davemloft.net>  2010-05-29 09:20:48
> Child:  92b4522f72916ff2675060e29e4b24cf26ab59ce (Merge branch
> 'master' of master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6)
> Branches: compile, master, remotes/origin/master, remotes/v35/master, work
> Follows: v2.6.34
> Precedes: first_bad, v2.6.35-rc2
> 
>     net: fix sk_forward_alloc corruptions
> 
>     As David found out, sock_queue_err_skb() should be called with socket
>     lock hold, or we risk sk_forward_alloc corruption, since we use non
>     atomic operations to update this field.
> 
>     This patch adds bh_lock_sock()/bh_unlock_sock() pair to three spots.
>     (BH already disabled)
> 
>     1) skb_tstamp_tx()
>     2) Before calling ip_icmp_error(), in __udp4_lib_err()
>     3) Before calling ipv6_icmp_error(), in __udp6_lib_err()

I suspect your bisection went wrong :(

> 
> ------------------------------ net/core/skbuff.c ------------------------------
> index 4667d4d..f2913ae 100644
> @@ -2992,7 +2992,11 @@ void skb_tstamp_tx(struct sk_buff *orig_skb,
>  	memset(serr, 0, sizeof(*serr));
>  	serr->ee.ee_errno = ENOMSG;
>  	serr->ee.ee_origin = SO_EE_ORIGIN_TIMESTAMPING;
> +
> +	bh_lock_sock(sk);
>  	err = sock_queue_err_skb(sk, skb);
> +	bh_unlock_sock(sk);
> +
>  	if (err)
>  		kfree_skb(skb);
>  }
> 
> -------------------------------- net/ipv4/udp.c --------------------------------
> index b9d0d40..acdc9be 100644
> @@ -634,7 +634,9 @@ void __udp4_lib_err(struct sk_buff *skb, u32 info,
> struct udp_table *udptable)
>  		if (!harderr || sk->sk_state != TCP_ESTABLISHED)
>  			goto out;
>  	} else {
> +		bh_lock_sock(sk);
>  		ip_icmp_error(sk, skb, err, uh->dest, info, (u8 *)(uh+1));
> +		bh_unlock_sock(sk);
>  	}
>  	sk->sk_err = err;
>  	sk->sk_error_report(sk);
> 
> -------------------------------- net/ipv6/udp.c --------------------------------
> index 87be586..3048f90 100644
> @@ -466,9 +466,11 @@ void __udp6_lib_err(struct sk_buff *skb, struct
> inet6_skb_parm *opt,
>  	if (sk->sk_state != TCP_ESTABLISHED && !np->recverr)
>  		goto out;
> 
> -	if (np->recverr)
> +	if (np->recverr) {
> +		bh_lock_sock(sk);
>  		ipv6_icmp_error(sk, skb, err, uh->dest, ntohl(info), (u8 *)(uh+1));
> -
> +		bh_unlock_sock(sk);
> +	}
>  	sk->sk_err = err;
>  	sk->sk_error_report(sk);
>  out:

It's really hard to see how that change could break the resume
operation.

