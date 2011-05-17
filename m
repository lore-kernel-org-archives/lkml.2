Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab1EQIIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 04:08:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57910 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab1EQIIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 04:08:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mGZGp/LRuIts0aI46VOEt+edaSzo+MiXSJr/If5kNrWfy6JZ2gevKpzHdu5yJfXI0X
         D9RaML827FCuNclEkxlLEN9zN659ffmnZyARAUrE64aZE9mQDtFZnztqRpfpXwGYbNo5
         9mmg3Eib/F2zIW3LoXNtx3CRqXHeEgnhGqi5s=
Subject: Re: [PATCH] tcp: Expose the initial RTO via a new sysctl.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Benoit Sigoure <tsunanet@gmail.com>
Cc: davem@davemloft.net, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1305618020-72535-2-git-send-email-tsunanet@gmail.com>
References: <1305618020-72535-1-git-send-email-tsunanet@gmail.com>
	 <1305618020-72535-2-git-send-email-tsunanet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 10:07:57 +0200
Message-ID: <1305619677.2850.11.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 17 mai 2011 à 00:40 -0700, Benoit Sigoure a écrit :
> Instead of hardcoding the initial RTO to 3s and requiring
> the kernel to be recompiled to change it, expose it as a
> sysctl that can be tuned at runtime.  Leave the default
> value unchanged.
> 

I wont discuss if introducing a new sysctl is welcomed, only on patch
issues. I believe some work in IETF is done to reduce the 3sec value to
1sec anyway.

> Signed-off-by: Benoit Sigoure <tsunanet@gmail.com>
> ---
>  Documentation/networking/ip-sysctl.txt |    6 ++++++
>  include/linux/sysctl.h                 |    1 +
>  include/net/tcp.h                      |    3 ++-
>  kernel/sysctl_binary.c                 |    1 +
>  net/ipv4/syncookies.c                  |    2 +-
>  net/ipv4/sysctl_net_ipv4.c             |   11 +++++++++++
>  net/ipv4/tcp.c                         |    4 ++--
>  net/ipv4/tcp_input.c                   |    8 ++++----
>  net/ipv4/tcp_ipv4.c                    |    6 +++---
>  net/ipv4/tcp_minisocks.c               |    6 +++---
>  net/ipv4/tcp_output.c                  |    2 +-
>  net/ipv4/tcp_timer.c                   |    9 +++++----
>  net/ipv6/syncookies.c                  |    2 +-
>  net/ipv6/tcp_ipv6.c                    |    6 +++---
>  14 files changed, 44 insertions(+), 23 deletions(-)
> 
> diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
> index d3d653a..c381c68 100644
> --- a/Documentation/networking/ip-sysctl.txt
> +++ b/Documentation/networking/ip-sysctl.txt
> @@ -384,6 +384,12 @@ tcp_retries2 - INTEGER
>  	RFC 1122 recommends at least 100 seconds for the timeout,
>  	which corresponds to a value of at least 8.
>  
> +tcp_initial_rto - INTEGER
> +	This value sets the initial retransmit timeout, that is how long
> +	the kernel will wait before retransmitting the initial SYN packet.
> +
> +	RFC 1122 says that this SHOULD be 3 seconds, which is the default.
> +

units ? seconds ? ms ? jiffies ? I suggest using ms as external
interface.

>  tcp_rfc1337 - BOOLEAN
>  	If set, the TCP stack behaves conforming to RFC1337. If unset,
>  	we are not conforming to RFC, but prevent TCP TIME_WAIT
> diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> index 11684d9..96a9b41 100644
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -425,6 +425,7 @@ enum
>  	NET_TCP_ALLOWED_CONG_CONTROL=123,
>  	NET_TCP_MAX_SSTHRESH=124,
>  	NET_TCP_FRTO_RESPONSE=125,
> +        NET_IPV4_TCP_INITIAL_RTO=126,

We dont add new values here anymore, only anonymous ones.

>  };
>  
>  enum {
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index cda30ea..a2bb0f1 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -213,6 +213,7 @@ extern int sysctl_tcp_syn_retries;
>  extern int sysctl_tcp_synack_retries;
>  extern int sysctl_tcp_retries1;
>  extern int sysctl_tcp_retries2;
> +extern int sysctl_tcp_initial_rto;
>  extern int sysctl_tcp_orphan_retries;
>  extern int sysctl_tcp_syncookies;
>  extern int sysctl_tcp_retrans_collapse;
> @@ -295,7 +296,7 @@ static inline void tcp_synq_overflow(struct sock *sk)
>  static inline int tcp_synq_no_recent_overflow(const struct sock *sk)
>  {
>  	unsigned long last_overflow = tcp_sk(sk)->rx_opt.ts_recent_stamp;
> -	return time_after(jiffies, last_overflow + TCP_TIMEOUT_INIT);
> +	return time_after(jiffies, last_overflow + sysctl_tcp_initial_rto);
>  }
>  
>  extern struct proto tcp_prot;
> diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
> index 3b8e028..d608d84 100644
> --- a/kernel/sysctl_binary.c
> +++ b/kernel/sysctl_binary.c
> @@ -354,6 +354,7 @@ static const struct bin_table bin_net_ipv4_table[] = {
>  	{ CTL_INT,	NET_IPV4_TCP_KEEPALIVE_INTVL,		"tcp_keepalive_intvl" },
>  	{ CTL_INT,	NET_IPV4_TCP_RETRIES1,			"tcp_retries1" },
>  	{ CTL_INT,	NET_IPV4_TCP_RETRIES2,			"tcp_retries2" },
> +	{ CTL_INT,	NET_IPV4_TCP_INITIAL_RTO,		"tcp_initial_rto" },

no need here. sysctl() is deprecated.

>  	{ CTL_INT,	NET_IPV4_TCP_FIN_TIMEOUT,		"tcp_fin_timeout" },
>  	{ CTL_INT,	NET_TCP_SYNCOOKIES,			"tcp_syncookies" },
>  	{ CTL_INT,	NET_TCP_TW_RECYCLE,			"tcp_tw_recycle" },
> diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
> index 8b44c6d..089bc92 100644
> --- a/net/ipv4/syncookies.c
> +++ b/net/ipv4/syncookies.c
> @@ -186,7 +186,7 @@ __u32 cookie_v4_init_sequence(struct sock *sk, struct sk_buff *skb, __u16 *mssp)
>   * sysctl_tcp_retries1. It's a rather complicated formula (exponential
>   * backoff) to compute at runtime so it's currently hardcoded here.
>   */
> -#define COUNTER_TRIES 4
> +#define COUNTER_TRIES (sysctl_tcp_initial_rto + 1)

Are you sure of this ?

If HZ=1000, sysctl_tcp_initial_rto is 3000

COUNTER_TRIES goes from 4 to 3004 
  
>  /*
>   * Check if a ack sequence number is a valid syncookie.
>   * Return the decoded mss if it is, or 0 if not.
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index 321e6e8..24dc21d 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -30,6 +30,8 @@ static int tcp_adv_win_scale_min = -31;
>  static int tcp_adv_win_scale_max = 31;
>  static int ip_ttl_min = 1;
>  static int ip_ttl_max = 255;
> +static int tcp_initial_rto_min = TCP_RTO_MIN;

warning its jiffies units here.

> +static int tcp_initial_rto_max = TCP_RTO_MAX;
>  
>  /* Update system visible IP port range */
>  static void set_local_port_range(int range[2])
> @@ -246,6 +248,15 @@ static struct ctl_table ipv4_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= proc_dointvec
>  	},
> +        {
> +		.procname       = "tcp_initial_rto",
> +		.data           = &sysctl_tcp_initial_rto,
> +		.maxlen         = sizeof(int),
> +		.mode           = 0644,
> +		.proc_handler	= proc_dointvec_minmax,

so unit is jiffies ? Really its not a good thing. Use ms instead.

Consider proc_dointvec_ms_jiffies(), here.

> +		.extra1		= &tcp_initial_rto_min,
> +		.extra2		= &tcp_initial_rto_max,
> +	},
>  	{
>  		.procname	= "tcp_fin_timeout",
>  		.data		= &sysctl_tcp_fin_timeout,
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index b22d450..e9e7c3f 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -2352,7 +2352,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
>  	case TCP_DEFER_ACCEPT:
>  		/* Translate value in seconds to number of retransmits */
>  		icsk->icsk_accept_queue.rskq_defer_accept =
> -			secs_to_retrans(val, TCP_TIMEOUT_INIT / HZ,
> +			secs_to_retrans(val, sysctl_tcp_initial_rto / HZ,

Here you assume sysctl_tcp_initial_rto is expressed in jiffies ?
Oh well...

>  					TCP_RTO_MAX / HZ);
>  		break;
>  
> @@ -2539,7 +2539,7 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
>  		break;
>  	case TCP_DEFER_ACCEPT:
>  		val = retrans_to_secs(icsk->icsk_accept_queue.rskq_defer_accept,
> -				      TCP_TIMEOUT_INIT / HZ, TCP_RTO_MAX / HZ);
> +				      sysctl_tcp_initial_rto / HZ, TCP_RTO_MAX / HZ);
>  		break;
>  	case TCP_WINDOW_CLAMP:
>  		val = tp->window_clamp;
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index bef9f04..39f6c27 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -890,7 +890,7 @@ static void tcp_init_metrics(struct sock *sk)
>  	if (dst_metric(dst, RTAX_RTT) == 0)
>  		goto reset;
>  
> -	if (!tp->srtt && dst_metric_rtt(dst, RTAX_RTT) < (TCP_TIMEOUT_INIT << 3))
> +	if (!tp->srtt && dst_metric_rtt(dst, RTAX_RTT) < (sysctl_tcp_initial_rto << 3))

Here you assume jiffies unit again. I wonder how this was tested :(

Please fix this and chose a definitive unit.



