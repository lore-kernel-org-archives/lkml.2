Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab0LVKAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 05:00:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37338 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992Ab0LVKAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 05:00:41 -0500
Date: Wed, 22 Dec 2010 11:00:39 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>
Subject: Re: [PATCH] tcp: use RTAX_CWND for outgoing connections properly
In-Reply-To: <alpine.LNX.2.00.1012172310400.16569@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1012221059340.16569@pobox.suse.cz>
References: <alpine.LNX.2.00.1012172310400.16569@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Dec 2010, Jiri Kosina wrote:

> For outgoing connections, the initial value of cwnd is always set to 2 (in 
> tcp_v4_init_sock()) regardless of setting of RTAX_CWND. For incoming 
> connections, this is handled properly in tcp_init_metrics().
> 
> As a result of this, Linux TCP stack always uses cwnd == 2 at the beginning of
> outgoing TCP session (i.e. waits for ACK after 2 packets once the connection
> has been established) and grows it in accordance with slow-start algorithm
> only after it receives ACK for first two packets.
> 
> When slow-start triggers later during the connection (e.g. after idle), 
> cwnd is properly re-initialized to RTAX_CWND value (if specified) through 
> tcp_cwnd_restart() -> tcp_init_cwnd().
> 
> Initialize tp->snd_cwnd properly so that RTAX_CWND value is being used 
> also in the slow-start phase for the first packets in the connection.

This should of course read RTAX_INITCWND instead of RTAX_CWND in the whole 
changelog, sorry.

Besides that, any comments on this, please?

Thanks.

> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
>  net/ipv4/tcp_output.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 61c2463..6dbc55b 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -2572,6 +2572,8 @@ static void tcp_connect_init(struct sock *sk)
>  				  &rcv_wscale,
>  				  dst_metric(dst, RTAX_INITRWND));
>  
> +	tp->snd_cwnd = tcp_init_cwnd(tp, dst);
> +
>  	tp->rx_opt.rcv_wscale = rcv_wscale;
>  	tp->rcv_ssthresh = tp->rcv_wnd;
>  
> -- 
> 1.7.3.1
> 
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
