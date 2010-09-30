Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab0I3T1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 15:27:01 -0400
Received: from bhuna.collabora.co.uk ([93.93.128.226]:50707 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869Ab0I3T07 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 15:26:59 -0400
Date: Thu, 30 Sep 2010 20:24:29 +0100
From: Alban Crequy <alban.crequy@collabora.co.uk>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Ian Molton <ian.molton@collabora.co.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] AF_UNIX: find peers on multicast Unix stream 
 sockets
Message-ID: <20100930202429.42808a38@chocolatine.cbg.collabora.co.uk>
In-Reply-To: <1285351237.2478.7.camel@edumazet-laptop>
References: <20100924182257.11abd9a6@chocolatine.cbg.collabora.co.uk>
 <1285349116-17529-4-git-send-email-alban.crequy@collabora.co.uk>
 <1285351237.2478.7.camel@edumazet-laptop>
Organization: Collabora
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.21.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Fri, 24 Sep 2010 20:00:37 +0200,
Eric Dumazet <eric.dumazet@gmail.com> a écrit :

> Le vendredi 24 septembre 2010 à 18:25 +0100, Alban Crequy a écrit :
> 
> > @@ -1612,7 +1671,12 @@ static int unix_stream_sendmsg(struct kiocb
> > *kiocb, struct socket *sock, } else {
> >  		sunaddr = NULL;
> >  		err = -ENOTCONN;
> > -		other = NULL; /* FIXME: get the list of other
> > connection */
> > +		max_others = atomic_read(&unix_nr_multicast_socks);
> > +		others = kzalloc((max_others + 1) * sizeof(void
> > *), GFP_KERNEL);
> > +		unix_find_other(sock_net(sk), u->addr->name,
> > +		    u->addr->len, 0, u->addr->hash, 1, others,
> > max_others, &err);
> > +		other = others[0];
> > +		kfree(others);
> >  		if (!other)
> >  			goto out_err;
> >  	}
> 
> Seriously, this block sizing against unix_nr_multicast_socks is not
> scalable. What happens if we have 1000 sockets ?
> kzalloc() to clear 8000 bytes ?
> Its also unsafe.
> 
> (say you kzalloc() a buffer for 2 sockets, and another cpu inserts a
> new socket. unix_find_socket_byname() can overflow the buffer)
> 
> 
> You should use a list, and allocates elements in
> unix_find_socket_byname()
> 
> struct item {
> 	struct item *next;
> 	struct sock *s;
> };

Thanks for your review.

I cannot allocate elements directly in unix_find_socket_byname()
iteration after iteration because the spinlock "unix_table_lock" is
held. If I release the spinlock to allocate, the number of sockets in
the table may change.

I changed the code to count the sockets with the lock held and then
allocate. In the unfortunate case where the allocation is not big
enough (if another process inserts a new socket), it just tries again.

The code is available here. Please pull from:

git://git.collabora.co.uk/git/user/alban/linux-2.6.35.y/.git unix-multicast2

It is still a work in progress. Missing pieces:

- The flow control does not work correctly: poll/select does not match
  the reality

- Atomic delivery: if a process is killed or interrupted in the middle
  of a delivery, only a subset of the recipients will get the message 

- Some locking to provide the same delivery order to all the recipients
  when several senders run concurrently.

Feedback welcome,

Alban Crequy

