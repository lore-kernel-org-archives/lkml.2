Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933871Ab0GSOJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 10:09:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62760 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933591Ab0GSOJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 10:09:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YOH8LdqQs2ynoe1Z3oeVGT53p+MaprABjWpsDYYw+p5FRlZNfsQTBRq5YWRAaxF3ZI
         PE8tJ4DrQh9LrZr/5WdyKlZ+YNFlkrGv3a2dpVG8RxQgRTrj5wznYCWn7OjRNiq1vJty
         uwiLUKeC7g6gvaaLveNNKsYW7PsHcueTGm3vw=
Subject: Re: [PATCHv2] tcp: fix crash in tcp_xmit_retransmit_queue
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: Lennart Schulte <lennart.schulte@nets.rwth-aachen.de>,
        David Miller <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Fehrmann, Henning" <henning.fehrmann@aei.mpg.de>,
        Carsten Aulbert <carsten.aulbert@aei.mpg.de>
In-Reply-To: <alpine.DEB.2.00.1007191319010.13002@wel-95.cs.helsinki.fi>
References: <4C358AAA.9080400@kernel.org>
	 <alpine.DEB.2.00.1007111825510.15736@melkinpaasi.cs.helsinki.fi>
	 <4C3EF7EA.2040900@nets.rwth-aachen.de>
	 <1279195528.2496.2.camel@edumazet-laptop>
	 <4C3F053F.7090704@nets.rwth-aachen.de>
	 <alpine.DEB.2.00.1007161448330.13946@melkinpaasi.cs.helsinki.fi>
	 <4C404FC5.6040107@nets.rwth-aachen.de>
	 <alpine.DEB.2.00.1007161602510.13946@melkinpaasi.cs.helsinki.fi>
	 <4C440771.7080107@nets.rwth-aachen.de>
	 <alpine.DEB.2.00.1007191319010.13002@wel-95.cs.helsinki.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 16:09:15 +0200
Message-ID: <1279548555.2553.51.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 19 juillet 2010 à 14:16 +0300, Ilpo Järvinen a écrit :

> Thanks for testing.
> 
> DaveM, I think this oops was introduced for 2.6.28 (in 
> 08ebd1721ab8fd362e90ae17b461c07b23fa2824 it seems, to be exact) so to 
> stables it should go too please. I've only tweaked the message (so no need 
> for Lennart to retest v2 :-)).
> 
> --
> [PATCHv2] tcp: fix crash in tcp_xmit_retransmit_queue
> 
> It can happen that there are no packets in queue while calling
> tcp_xmit_retransmit_queue(). tcp_write_queue_head() then returns
> NULL and that gets deref'ed to get sacked into a local var.
> 
> There is no work to do if no packets are outstanding so we just
> exit early.
> 
> This oops was introduced by 08ebd1721ab8fd (tcp: remove tp->lost_out
> guard to make joining diff nicer).
> 

But prior to commit 08ebd1721ab8fd3, we were not testing
tp->packets_out, but tp->lost_out

if it was 0, we were not doing the tcp_for_write_queue_from() loop.

Not sure it makes a difference ?

> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
> Reported-by: Lennart Schulte <lennart.schulte@nets.rwth-aachen.de>
> Tested-by: Lennart Schulte <lennart.schulte@nets.rwth-aachen.de>
> ---
>  net/ipv4/tcp_output.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index b4ed957..7ed9dc1 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -2208,6 +2208,9 @@ void tcp_xmit_retransmit_queue(struct sock *sk)
>  	int mib_idx;
>  	int fwd_rexmitting = 0;
>  
> +	if (!tp->packets_out)
> +		return;
> +
>  	if (!tp->lost_out)
>  		tp->retransmit_high = tp->snd_una;
>  


