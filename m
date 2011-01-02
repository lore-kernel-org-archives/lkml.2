Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab1ABLQF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 06:16:05 -0500
Received: from www84.your-server.de ([213.133.104.84]:34446 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab1ABLQD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 06:16:03 -0500
Subject: Re: [PATCH] new UDPCP Communication Protocol
From: Stefani Seibold <stefani@seibold.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, netdev@vger.kernel.org, shemminger@vyatta.com
In-Reply-To: <1293920601.2535.64.camel@edumazet-laptop>
References: <1293918276-28773-1-git-send-email-stefani@seibold.net>
	 <1293920601.2535.64.camel@edumazet-laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sun, 02 Jan 2011 12:17:03 +0100
Message-ID: <1293967023.29525.16.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 8BIT
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, den 01.01.2011, 23:23 +0100 schrieb Eric Dumazet:
> Le samedi 01 janvier 2011 à 22:44 +0100, stefani@seibold.net a écrit :
> > From: Stefani Seibold <stefani@seibold.net>
> > 
> > Changelog:
> > 31.12.2010 first proposal
> > 01.01.2011 code cleanup and fixes suggest by Eric Dumazet
> > 
> > UDPCP is a communication protocol specified by the Open Base Station
> > Architecture Initiative Special Interest Group (OBSAI SIG). The
> > protocol is based on UDP and is designed to meet the needs of "Mobile
> > Communcation Base Station" internal communications. It is widely used by
> > the major networks infrastructure supplier.
> > 
> > The UDPCP communication service supports the following features:
> > 
> > -Connectionless communication for serial mode data transfer
> > -Acknowledged and unacknowledged transfer modes
> > -Retransmissions Algorithm
> > -Checksum Algorithm using Adler32
> > -Fragmentation of long messages (disassembly/reassembly) to match to the MTU
> >  during transport:
> > -Broadcasting and multicasting messages to multiple peers in unacknowledged
> >  transfer mode
> > 
> > UDPCP supports application level messages up to 64 KBytes (limited by 16-bit
> > packet data length field). Messages that are longer than the MTU will be
> > fragmented to the MTU.
> > 
> > UDPCP provides a reliable transport service that will perform message
> > retransmissions in case transport failures occur.
> > 
> > The code is also a nice example how to implement a UDP based protocol as
> > a kernel socket modules.
> > 
> > Due the nature of UDPCP which has no sliding windows support, the latency has a
> > huge impact. The perfomance increase by implementing as a kernel module is
> > about the factor 10, because there are no context switches and data packets or
> > ACKs will be handled in the interrupt service.
> > 
> > There are no side effects to the network subsystems so i ask for merge it
> > into linux-next. Hope you like it.
> > 
> > The patch is against 2.6.37-rc8
> > 
> 
> Hi Stefani
> 
> 1) Please base your next trys on net-next-2.6 : This is the reference
> for stuff like that. It probably does not matter a lot, but still...
> 

Okay.

> 
> 2) I still see some _irq() variants of spinlock(). Its not necessary in
> network stack at the level you are working (process context, and
> softirqs)
> 
> Please only use _bh() variants, it's enough.
> 

Will be fixed...

> 3) I see UDPLITE references in your code. Are you sure UDPCP protocol
> can really work on top of UDPLITE ? I think not, so please remove dead
> code.
> 

I have not tested it yet. But i think i should work, the code is mostly
stolen from the udp.c file. Since the stack not depend on the len field
of the UDP header, it should not matter if UPD or UDP-Lite is used.

> 4) udpcp_release_sock() seems expensive to me. Why not testing
> usk->timeout before releasing sock lock, and save a lock/unlock pair ?
> 
> static inline void udpcp_release_sock(struct sock *sk)
> {
> 	struct udpcp_sock *usk = udpcp_sk(sk);
> 
> 	if (usk->timeout)
> 		udpcp_handle_timeout(sk);
> 	release_sock(sk);
> }
> 

No... What is when a timer occurs between exiting udpcp_handle_timeout()
and release_sock(). This timer will not longer handled.

What about this:?

static inline void udpcp_release_sock(struct sock *sk)
{
	while (usk->timeout) {
		udpcp_handle_timeout(sk);
	release_sock(sk);
        check_timeout(sk);
}

> 5) In udpcp_timeout(), if you find socket is locked by user, you set
> timeout to one and rearm a timer to udpcp_timer(sk, jiffies + 1); 
> 
> Why is it needed, since user process is going to handle the timeout
> indication from udpcp_release_sock() ?
> 

It is only for paranoid reasons, maybe there is a bug in my wonderful
code and than the stack will stop to work.... If it is okay, i didn't
want to remove it, my cuts feels a little bit nervous. 


