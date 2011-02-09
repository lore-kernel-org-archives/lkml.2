Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab1BIOQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 09:16:59 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:33363 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab1BIOQ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 09:16:58 -0500
Date: Wed, 9 Feb 2011 14:14:44 +0000
From: Alban Crequy <alban.crequy@collabora.co.uk>
To: Alban Crequy <alban.crequy@collabora.co.uk>
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Lennart Poettering <lennart@poettering.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ian Molton <ian.molton@collabora.co.uk>
Subject: Re: [PATCH 7/8] af_unix: implement poll(POLLOUT) for multicast
 sockets
Message-ID: <20110209141444.6f496013@chocolatine.cbg.collabora.co.uk>
In-Reply-To: <1295620788-6002-7-git-send-email-alban.crequy@collabora.co.uk>
References: <20110121143751.57b1453d@chocolatine.cbg.collabora.co.uk>
	<1295620788-6002-7-git-send-email-alban.crequy@collabora.co.uk>
Organization: Collabora
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.23.90; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Fri, 21 Jan 2011 14:39:47 +0000,
Alban Crequy <alban.crequy@collabora.co.uk> a écrit :

> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 4147d64..138d9a2 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
...
>  	sock_poll_wait(file, sk_sleep(sk), wait);
                             ^^^^^^^^^^^^
> +#ifdef CONFIG_UNIX_MULTICAST
> +	/*
> +	 * On multicast sockets, we need to check if the receiving queue is
> +	 * full on all peers who don't have UNIX_MREQ_DROP_WHEN_FULL.
> +	 */
> +	if (!other || !unix_sk(other)->mcast_group)
> +		goto skip_multicast;
> +	others = unix_find_multicast_recipients(sk,
> +		unix_sk(other)->mcast_group, &err);
> +	if (!others)
> +		goto skip_multicast;
> +	for (i = others->offset ; i < others->cnt ; i++) {
> +		if (others->items[i].flags & UNIX_MREQ_DROP_WHEN_FULL)
> +			continue;
> +		if (unix_peer(others->items[i].s) != sk) {
> +			sock_poll_wait(file,
> +				&unix_sk(others->items[i].s)->peer_wait, wait);
                                                              ^^^^^^^^^

This code does not work correctly: a poller cannot sleep on two wait
queues at the same time. When the poller is added in ->peer_wait, it
will not be in sk_sleep(sk) so it will miss POLLIN events.

I think I need another wait queue at the group level for waiters of
POLLIN|POLLOUT events. Waiters on that global wait queue would be woken
up when a message is delivered to any peer (in unix_dgram_sendmsg along
sk_data_ready) and when a member of the group receives a message (in
unix_dgram_recvmsg along wake_up_interruptible_sync_poll).

