Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab1ACJH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 04:07:57 -0500
Received: from www84.your-server.de ([213.133.104.84]:60424 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab1ACJH4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 04:07:56 -0500
Subject: Re: [PATCH] new UDPCP Communication Protocol
From: Stefani Seibold <stefani@seibold.net>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, davem@davemloft.net, netdev@vger.kernel.org,
        shemminger@vyatta.com, daniel.baluta@gmail.com, jochen@jochen.org
In-Reply-To: <alpine.LNX.2.00.1101022356550.11481@swampdragon.chaosbits.net>
References: <1294007971-18878-1-git-send-email-stefani@seibold.net>
	 <1294008562.2535.263.camel@edumazet-laptop>
	 <1294008917.18963.3.camel@wall-e>
	 <alpine.LNX.2.00.1101022356550.11481@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 03 Jan 2011 10:08:52 +0100
Message-ID: <1294045732.19666.6.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 8BIT
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 03.01.2011, 00:04 +0100 schrieb Jesper Juhl:
> On Sun, 2 Jan 2011, Stefani Seibold wrote:
> 
> > Am Sonntag, den 02.01.2011, 23:49 +0100 schrieb Eric Dumazet:
> > > Le dimanche 02 janvier 2011 à 23:39 +0100, stefani@seibold.net a écrit :
> > > > +
> > > > +/*
> > > > + * Create a new destination descriptor for the given IPV4 address and port
> > > > + */
> > > > +static struct udpcp_dest *new_dest(struct sock *sk, __be32 addr, __be16 port)
> > > > +{
> > > > +	struct udpcp_dest *dest;
> > > > +	struct udpcp_sock *usk = udpcp_sk(sk);
> > > > +
> > > > +	if (usk->connections >= udpcp_max_connections)
> > > > +		return NULL;
> > > > +
> > > > +	dest = kzalloc(sizeof(*dest), sk->sk_allocation);
> > > > +
> > > > +	if (dest) {
> > > > +		usk->connections++;
> > > > +		skb_queue_head_init(&dest->xmit);
> > > > +		dest->addr = addr;
> > > > +		dest->port = port;
> > > > +		dest->ackmode = UDPCP_ACK;
> > > > +		list_add_tail(&dest->list, &usk->destlist);
> > > > +	}
> > > > +
> > > > +	return dest;
> > > > +}
> > > > +
> > > 
> > > Hmm, so 'connections' is increased, never decreased.
> > > 
> > > This seems a fatal flaw in this protocol, since a malicious user can
> > > easily fill the list with garbage, and block regular communications.
> > 
> > You are right, there is now way to detect which connection is no longer
> > needed. I have not designed this protocol, so i cannot fix it. 
> > 
> > But in our environment this will be used together with an firewall
> > and/or ipsec. In this case it it safe.
> > 
> 
> Hmm, the first thing that springs into my head as a possible band-aid 
> (which is probbaly wrong for many reasons I've not considered, so feel 
> free to shoot it down) is; couldn't we use a timer (set to some outrageous 
> high value by default and admin tunable) that would decrement 
> 'connections' (discount dead connections) when there has not been any 
> acctivity for a huge period of time? Kill off connections that have been 
> idle for ages.
> 

This will not work for two reasons:

- First there is no way to detect a dead connection. A connection can
stay for a very long time without data transfer.

- Second it will not save against a attack where all communication slots
will be eaten by an attacker and then new valid connections will be not
handled.

The only thing what is possible to make an ioctl call which allows the
user land client to cancel connections. 

But this will be in my opinion dead code, because white lists of trusted
address must be fostered and this will make the upgrading of a
infrastructure to complicate.


