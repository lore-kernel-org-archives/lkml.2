Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185Ab0IXSAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:00:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39805 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757168Ab0IXSAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:00:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QSiAEzlP9Wf37gTuc5omps4D6GAEdtqmEgFPnHoj/MqvqbnN4FKO3AFqyGSackwkeK
         TIy1jU/NNXvZXAcSgFtqATpxKQS5ahx7v/itU8sBW7KpG77NQMAKevcS243u/Gs0paX2
         99vcg37DyGcMT4IiKXaJBlmU8SWseuVm67OWw=
Subject: Re: [PATCH 4/5] AF_UNIX: find peers on multicast Unix stream
 sockets
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alban Crequy <alban.crequy@collabora.co.uk>
Cc: "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Ian Molton <ian.molton@collabora.co.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dbus@freedesktop.org
In-Reply-To: <1285349116-17529-4-git-send-email-alban.crequy@collabora.co.uk>
References: <20100924182257.11abd9a6@chocolatine.cbg.collabora.co.uk>
	 <1285349116-17529-4-git-send-email-alban.crequy@collabora.co.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Sep 2010 20:00:37 +0200
Message-ID: <1285351237.2478.7.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 24 septembre 2010 à 18:25 +0100, Alban Crequy a écrit :

> @@ -1612,7 +1671,12 @@ static int unix_stream_sendmsg(struct kiocb *kiocb, struct socket *sock,
>  	} else {
>  		sunaddr = NULL;
>  		err = -ENOTCONN;
> -		other = NULL; /* FIXME: get the list of other connection */
> +		max_others = atomic_read(&unix_nr_multicast_socks);
> +		others = kzalloc((max_others + 1) * sizeof(void *), GFP_KERNEL);
> +		unix_find_other(sock_net(sk), u->addr->name,
> +		    u->addr->len, 0, u->addr->hash, 1, others, max_others, &err);
> +		other = others[0];
> +		kfree(others);
>  		if (!other)
>  			goto out_err;
>  	}

Seriously, this block sizing against unix_nr_multicast_socks is not
scalable. What happens if we have 1000 sockets ?
kzalloc() to clear 8000 bytes ?
Its also unsafe.

(say you kzalloc() a buffer for 2 sockets, and another cpu inserts a new
socket. unix_find_socket_byname() can overflow the buffer)


You should use a list, and allocates elements in
unix_find_socket_byname()

struct item {
	struct item *next;
	struct sock *s;
};


