Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab2AaJAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 04:00:40 -0500
Received: from smtp.sgsi.ucl.ac.be ([130.104.5.67]:45716 "EHLO
	smtp5.sgsi.ucl.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab2AaJAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 04:00:38 -0500
X-Greylist: delayed 553 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jan 2012 04:00:38 EST
X-DKIM: Sendmail DKIM Filter v2.8.3 smtp5.sgsi.ucl.ac.be F0DAD11E0EE
Message-ID: <4F27AB86.5080009@uclouvain.be>
Date: Tue, 31 Jan 2012 09:51:18 +0100
From: Christoph Paasch <christoph.paasch@uclouvain.be>
Reply-To: christoph.paasch@uclouvain.be
Organization: =?ISO-8859-15?Q?Universit=E9_Catholique_de_Louvain?=
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Arun Sharma <asharma@fb.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Glauber Costa <glommer@parallels.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] net: Disambiguate kernel message
References: <1327963304-24828-1-git-send-email-asharma@fb.com>
In-Reply-To: <1327963304-24828-1-git-send-email-asharma@fb.com>
X-TagToolbar-Keys: D20120131095118759
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
X-Sgsi-Spamcheck: SASL authenticated, 
X-SGSI-MailScanner-ID: F0DAD11E0EE.A8083
X-SGSI-MailScanner: Found to be clean
X-SGSI-From: christoph.paasch@uclouvain.be
X-SGSI-Spam-Status: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2012 11:41 PM, Arun Sharma wrote:
> Some of our machines were reporting:
> 
> TCP: too many of orphaned sockets
> 
> even when the number of orphaned sockets was well below the
> limit.
> 
> We print a different message depending on whether we're out
> of TCP memory or there are too many orphan sockets.
> 
> Signed-off-by: Arun Sharma <asharma@fb.com>
> Suggested-by: Mohan Srinivasan <mohan@fb.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: David Miller <davem@davemloft.net>
> Cc: Glauber Costa <glommer@parallels.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  include/net/tcp.h    |   12 ++++++++----
>  net/ipv4/tcp.c       |   14 +++++++++++++-
>  net/ipv4/tcp_timer.c |    9 +++++++--
>  3 files changed, 28 insertions(+), 7 deletions(-)
> 
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 0118ea9..92965dd 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -273,6 +273,14 @@ static inline int between(__u32 seq1, __u32 seq2, __u32 seq3)
>  	return seq3 - seq2 >= seq1 - seq2;
>  }
>  
> +static inline bool tcp_out_of_memory(struct sock *sk)
> +{
> +	if (sk->sk_wmem_queued > SOCK_MIN_SNDBUF &&
> +	    sk_memory_allocated(sk) > sk_prot_mem_limits(sk, 2))
> +		return true;
> +	return false;
> +}
> +
>  static inline bool tcp_too_many_orphans(struct sock *sk, int shift)
>  {
>  	struct percpu_counter *ocp = sk->sk_prot->orphan_count;
> @@ -283,10 +291,6 @@ static inline bool tcp_too_many_orphans(struct sock *sk, int shift)
>  		if (orphans << shift > sysctl_tcp_max_orphans)
>  			return true;
>  	}
> -
> -	if (sk->sk_wmem_queued > SOCK_MIN_SNDBUF &&
> -	    sk_memory_allocated(sk) > sk_prot_mem_limits(sk, 2))
> -		return true;
>  	return false;
>  }
>  
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 9bcdec3..395a4ef 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -2015,10 +2015,22 @@ adjudge_to_death:
>  	}
>  	if (sk->sk_state != TCP_CLOSE) {
>  		sk_mem_reclaim(sk);
> -		if (tcp_too_many_orphans(sk, 0)) {
> +		bool too_many_orphans = tcp_too_many_orphans(sk, 0);
> +		bool out_of_socket_memory = tcp_out_of_memory(sk);

This introduces a compiler warning because you have the declarations
after the code (sk_mem_reclaim()):

Cheers,
Christoph



-- 
Christoph Paasch
PhD Student

IP Networking Lab --- http://inl.info.ucl.ac.be
MultiPath TCP in the Linux Kernel --- http://mptcp.info.ucl.ac.be
Université Catholique de Louvain
-- 
