Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab0LaL0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 06:26:08 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56931 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab0LaL0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 06:26:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OG9uFnSpHGY+3H0OLtMp7A0FjvZcfzHRVj+COwsVHIkPHlLGoeNhUT8aJlciZjjRxA
         L6vb+D2nHFcqiqG+hDAVLbj8mA47jnLxW5AOzEcVNFKYKpHb4cPgZ6tP48cn+L40CGIE
         9I+4f88HqbNJD0+MVVB7Xd+NTBTeCn4PC0EOU=
Subject: Re: [PATCH] UDPCP Communication Protocol
From: Eric Dumazet <eric.dumazet@gmail.com>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, netdev@vger.kernel.org
In-Reply-To: <1293787785-3834-1-git-send-email-stefani@seibold.net>
References: <1293787785-3834-1-git-send-email-stefani@seibold.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 31 Dec 2010 12:25:58 +0100
Message-ID: <1293794758.2973.49.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 31 décembre 2010 à 10:29 +0100, stefani@seibold.net a
écrit :
> +		if (!list_empty(&usk->destlist)) {
> +			state->sk = (struct sock *)usk;
> +			state->dest = list_first_entry(&usk->destlist,
> +					struct udpcp_dest, list);
> +			sock_hold(state->sk);
> +
> +			if (atomic_read(&state->sk->sk_refcnt) != 1) {
> +				spin_unlock_irqrestore(&spinlock, flags);
> +				return state;
> +			}
> +			atomic_dec(&state->sk->sk_refcnt);
> +		}
> +

I am trying to understand what you are doing here.

It seems racy to me.

Apparently, what you want is to take a reference only if actual
sk_refcnt is not zero.

I suggest using atomic_inc_notzero(&state->sk->sk_refcnt) to avoid the
race in atomic_dec().



