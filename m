Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab1ABWtc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 17:49:32 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38108 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab1ABWta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 17:49:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Z/r8RoTbRc6P43gorspdYR9ItTf1jX4nFs1SH5ek5pi0DmaIL4/OKOhSpnEBlpl96s
         JNE4js3LoRAcf7xMAW1mvSqQtcNwiIp2x2FgIeuTVNYfM2iFG9y3ZnQ2HPgM3gsPK7OL
         8Yu1R6ZQ3Rfi2KzgMYbqp7Bs5H1PIl5XS8mEA=
Subject: Re: [PATCH] new UDPCP Communication Protocol
From: Eric Dumazet <eric.dumazet@gmail.com>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, netdev@vger.kernel.org, shemminger@vyatta.com,
        jj@chaosbits.net, daniel.baluta@gmail.com, jochen@jochen.org
In-Reply-To: <1294007971-18878-1-git-send-email-stefani@seibold.net>
References: <1294007971-18878-1-git-send-email-stefani@seibold.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 02 Jan 2011 23:49:22 +0100
Message-ID: <1294008562.2535.263.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 02 janvier 2011 à 23:39 +0100, stefani@seibold.net a écrit :
> +
> +/*
> + * Create a new destination descriptor for the given IPV4 address and port
> + */
> +static struct udpcp_dest *new_dest(struct sock *sk, __be32 addr, __be16 port)
> +{
> +	struct udpcp_dest *dest;
> +	struct udpcp_sock *usk = udpcp_sk(sk);
> +
> +	if (usk->connections >= udpcp_max_connections)
> +		return NULL;
> +
> +	dest = kzalloc(sizeof(*dest), sk->sk_allocation);
> +
> +	if (dest) {
> +		usk->connections++;
> +		skb_queue_head_init(&dest->xmit);
> +		dest->addr = addr;
> +		dest->port = port;
> +		dest->ackmode = UDPCP_ACK;
> +		list_add_tail(&dest->list, &usk->destlist);
> +	}
> +
> +	return dest;
> +}
> +

Hmm, so 'connections' is increased, never decreased.

This seems a fatal flaw in this protocol, since a malicious user can
easily fill the list with garbage, and block regular communications.



