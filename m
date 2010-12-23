Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab0LWIYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 03:24:39 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35631 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab0LWIYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 03:24:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qyuAWkj9lxMOMz2qPUENZ8GMahhC5eodAVgenGIHiXsC3mPK6lZMxTDEISaGVKkZOp
         OwyKLGVriC4YJqW3I9fHAa8HtTA6Ex+AITrpDe/URbetvpV1+To8a+2xYuqy6Is/oqNO
         LmyOwmQTfhiYbLKL5owvsA77/I+ragtQtFOtk=
Subject: Re: [PATCH] tcp: cleanup of cwnd initialization in
 tcp_init_metrics()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
        Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
In-Reply-To: <alpine.LNX.2.00.1012221938030.16569@pobox.suse.cz>
References: <alpine.LNX.2.00.1012221938030.16569@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Dec 2010 09:24:31 +0100
Message-ID: <1293092671.2679.44.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 22 décembre 2010 à 19:39 +0100, Jiri Kosina a écrit :
> Commit 86bcebafc5e7f5 ("tcp: fix >2 iw selection") fixed a case when 
> congestion window initialization has been mistakenly omitted by 
> introducing cwnd label and putting backwards jump from the end of the 
> function.
> 
> This makes the code unnecessarily tricky to read and understand on a first 
> sight.
> 
> Shuffle the code around a little bit to make it more obvious.

Well in fine you have

	if (inet_csk(sk)->icsk_rto < TCP_TIMEOUT_INIT && !tp->rx_opt.saw_tstamp)
		goto reset;
	goto out;
reset:

Is that really more obvious ? ;)

> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
>  net/ipv4/tcp_input.c |   10 ++++------
>  1 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 6d8ab1c..dddff6d 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -915,11 +915,7 @@ static void tcp_init_metrics(struct sock *sk)
>  	if (inet_csk(sk)->icsk_rto < TCP_TIMEOUT_INIT && !tp->rx_opt.saw_tstamp)
>  		goto reset;
>  
> -cwnd:
> -	tp->snd_cwnd = tcp_init_cwnd(tp, dst);
> -	tp->snd_cwnd_stamp = tcp_time_stamp;
> -	return;
> -
> +	goto out;
>  reset:
>  	/* Play conservative. If timestamps are not
>  	 * supported, TCP will fail to recalculate correct
> @@ -930,7 +926,9 @@ reset:
>  		tp->mdev = tp->mdev_max = tp->rttvar = TCP_TIMEOUT_INIT;
>  		inet_csk(sk)->icsk_rto = TCP_TIMEOUT_INIT;
>  	}
> -	goto cwnd;
> +out:
> +	tp->snd_cwnd = tcp_init_cwnd(tp, dst);
> +	tp->snd_cwnd_stamp = tcp_time_stamp;
>  }
>  
>  static void tcp_update_reordering(struct sock *sk, const int metric,




