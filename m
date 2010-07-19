Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179Ab0GSIGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 04:06:13 -0400
Received: from mail-i4.nets.RWTH-Aachen.DE ([137.226.12.21]:46291 "EHLO
	MAIL-i4.nets.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758674Ab0GSIGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 04:06:11 -0400
Message-ID: <4C440771.7080107@nets.rwth-aachen.de>
Date: Mon, 19 Jul 2010 10:06:09 +0200
From: Lennart Schulte <lennart.schulte@nets.rwth-aachen.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
CC: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Tejun Heo <tj@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Fehrmann, Henning" <henning.fehrmann@aei.mpg.de>,
        Carsten Aulbert <carsten.aulbert@aei.mpg.de>
Subject: Re: oops in tcp_xmit_retransmit_queue() w/ v2.6.32.15
References: <4C358AAA.9080400@kernel.org> <alpine.DEB.2.00.1007111825510.15736@melkinpaasi.cs.helsinki.fi> <4C3EF7EA.2040900@nets.rwth-aachen.de> <1279195528.2496.2.camel@edumazet-laptop> <4C3F053F.7090704@nets.rwth-aachen.de> <alpine.DEB.2.00.1007161448330.13946@melkinpaasi.cs.helsinki.fi> <4C404FC5.6040107@nets.rwth-aachen.de> <alpine.DEB.2.00.1007161602510.13946@melkinpaasi.cs.helsinki.fi>
In-Reply-To: <alpine.DEB.2.00.1007161602510.13946@melkinpaasi.cs.helsinki.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I ran tests for about 2 hours with this patch and I got no output from 
the debug patch. This seems to have solved at least my problem :)

Thanks!
> [PATCH] tcp: fix crash in tcp_xmit_retransmit_queue
>
> It can happen that there are no packets in queue while calling
> tcp_xmit_retransmit_queue(). tcp_write_queue_head() then returns
> NULL and that gets deref'ed to get sacked into a local var.
>
> There is no work to do if no packets are outstanding so we just
> exit early.
>
> There may still be another bug affecting this same function.
>
> Signed-off-by: Ilpo Järvinen<ilpo.jarvinen@helsinki.fi>
> Reported-by: Lennart Schulte<lennart.schulte@nets.rwth-aachen.de>
> ---
>   net/ipv4/tcp_output.c |    3 +++
>   1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index b4ed957..7ed9dc1 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -2208,6 +2208,9 @@ void tcp_xmit_retransmit_queue(struct sock *sk)
>   	int mib_idx;
>   	int fwd_rexmitting = 0;
>
> +	if (!tp->packets_out)
> +		return;
> +
>   	if (!tp->lost_out)
>   		tp->retransmit_high = tp->snd_una;
>
>    

