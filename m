Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab0KWQIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 11:08:46 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39013 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab0KWQIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 11:08:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oiWaYIpNJe1xCgmSefv7+K6AeiZazxynYpbNwb/CnkXLrrdx7lUQtw4/N0rU55ndaR
         j4Yx8MCKKMfyCs1pprjqc8Ks8jogMSPfFehOIc7OJe7yyJAEa8/35kXZeJuKjupD7zw4
         aEIq7Vt/a4LWmswiEALDl7g60Zy67tq64uetE=
Subject: Re: [PATCH 4/9] AF_UNIX: find the recipients for multicast messages
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alban Crequy <alban.crequy@collabora.co.uk>
Cc: David Miller <davem@davemloft.net>, shemminger@vyatta.com,
        gorcunov@openvz.org, adobriyan@gmail.com, lennart@poettering.net,
        kay.sievers@vrfy.org, ian.molton@collabora.co.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101123150315.4e67a139@chocolatine.cbg.collabora.co.uk>
References: <20101122183447.124afce5@chocolatine.cbg.collabora.co.uk>
	 <1290450982-17480-4-git-send-email-alban.crequy@collabora.co.uk>
	 <20101122.110519.39205345.davem@davemloft.net>
	 <20101123150315.4e67a139@chocolatine.cbg.collabora.co.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Nov 2010 17:08:37 +0100
Message-ID: <1290528517.3046.91.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 23 novembre 2010 à 15:03 +0000, Alban Crequy a écrit :
> Le Mon, 22 Nov 2010 11:05:19 -0800 (PST),
> David Miller <davem@davemloft.net> a écrit :
> 
> > From: Alban Crequy <alban.crequy@collabora.co.uk>
> > Date: Mon, 22 Nov 2010 18:36:17 +0000
> > 
> > > unix_find_multicast_recipients() builds an array of recipients. It
> > > can either find the peers of a specific multicast address, or find
> > > all the peers of all multicast group the sender is part of.
> > > 
> > > Signed-off-by: Alban Crequy <alban.crequy@collabora.co.uk>
> > 
> > You really should use RCU to lock this stuff, this way sends run
> > lockless and have less worries wrt. the memory allocation.  You'll
> > also only take a spinlock in the write paths which change the
> > multicast groups, which ought to be rare.
> 
> I understand the benefit to use RCU in order to have lockless sends.
> 
> But with RCU I will still have worries about the memory allocation:
> 
> - I cannot allocate inside a rcu_read_lock()-rcu_read_unlock() block.
> 

Thats not true.

Sames rules than inside a spin_lock() or write_lock() apply.

We already allocate memory inside rcu_read_lock() in network stack.

> - If I iterate locklessly over the multicast group members with 
>   hlist_for_each_entry_rcu(), new members can be added, so the
>   array can be allocated with the wrong size and I have to try again
>   ("goto try_again") when this rare case occurs.

You are allowed to allocate memory to add stuff while doing your loop
iteration.

Nothing prevents you to use a chain of items, each item holding up to
128 sockets for example. If full, allocate a new item.

We have such schem in poll()/select() for example 

fs/select.c  function poll_get_entry()

Use a small embedded struct on stack, and allocate extra items if number
of fd is too big.

(If you cant allocate memory to hold pointers, chance is you wont be
able to clone skbs anyway. One skb is about 400 bytes.)

If new members are added to the group while you are iterating the list,
they wont receive a copy of the message.

Or just chain skbs while you clone them, store in skb->sk the socket...
no need for extra memory allocations.

> 
> - Another idea would be to avoid completely the allocation by inlining
>   unix_find_multicast_recipients() inside unix_dgram_sendmsg() and
>   delivering the messages to the recipients as long as the list is
>   being iterated locklessly. But I want to provide atomicity of
>   delivery: the message must be delivered with skb_queue_tail() either
>   to all the recipients or to none of them in case of interruption or
>   memory pressure. I don't see how I can achieve that without
>   iterating several times on the list of recipients, hence the
>   allocation and the copy in the array. I also want to guarantee the
>   order of delivery as described in multicast-unix-sockets.txt and for
>   this, I am taking lots of spinlocks anyway. I don't see how to avoid
>   that, but I would be happy to be wrong and have a better solution.
> 


So if one destination has a full receive queue, you want nobody receive
the message ? That seems a bit risky to me, if someone sends SIGSTOP to
one of your process...



> 
> To give an idea of the number of members in a multicast group for the
> D-Bus use case, I have 90 D-Bus connections on my session bus:
> 
> $ dbus-send --print-reply --dest=org.freedesktop.DBus \
> /org/freedesktop/DBus org.freedesktop.DBus.ListNames | grep '":'|wc -l
> 90
> 
> In common cases, there should be only a few real recipients (1 or 2?)
> after the socket filters eliminate most of them, but
> unix_find_multicast_recipients() will still allocate an array of
> about that size.
> 

I am not sure if doing 90 clones of skb and filtering them one by one is
going to be fast :-(





