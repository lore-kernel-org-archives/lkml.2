Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab0D1ReJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 13:34:09 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:55359 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab0D1ReG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 13:34:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QS50GHhOJ3qtTlAC9ZdeBSDL0FXWM8KVl0v9Gmxe3ic0uhsI2Kmm5tTjbjgxtZhryE
         RIVRZlaNwrjmTYA3ww40OQ1GMVPZAI5MiQ6KZsT3OYYuNp37ozeT5jSY/SAd6HCeBVzB
         Wd9NzMTfc464jU96hvvAO3psKRB+E8Y60dw74=
Subject: Re: Problem with "tcp: bind() fix when many ports are bound" commit
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: grzegorz.chwesewicz@retis.net.pl, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>
In-Reply-To: <20100428.095032.32709294.davem@davemloft.net>
References: <4BD82B29.3000105@retis.net.pl>
	 <20100428.095032.32709294.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Apr 2010 19:34:00 +0200
Message-ID: <1272476040.2267.87.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 28 avril 2010 à 09:50 -0700, David Miller a écrit :
> From: Grzegorz Chwesewicz <grzegorz.chwesewicz@retis.net.pl>
> Date: Wed, 28 Apr 2010 14:33:45 +0200
> 
> > 	Hi, I have a problem with binding to port with the latest git kernel
> > (my HEAD is at 1600f9def09de07c5dbeb539e978fa73880690dd). Please CC to
> > me as I'm not subscribed to the list.
> 
> Please send networking bug reports CC:'d to netdev and the people
> who wrote and signed off on the commit you've narrowed down the
> problem to.
> 
> Otherwise the appropriate people will take longer to find out about
> your bug, and therefore the bug will take longer to fix than
> necessary.
> 
> Thanks.
> 
> > 
> > Example with buggy kernel:
> > 
> > ensima-hp ~ # /etc/init.d/apache2 start
> >  * Starting apache2 ...
> > (98)Address already in use: make_sock: could not bind to address
> > 127.0.0.1:80
> > no listening sockets available, shutting down
> > Unable to open logs
> > 
> > As you can see nothing is listening on port 80, but there are old
> > connections to port 80 with CLOSE_WAIT and FIN_WAIT2 state.
> > 
> > ensima-hp ~ # netstat -pan --inet|grep 80
> > netstat: no support for `AF INET (sctp)' on this system.
> > tcp        0      0 127.0.0.1:631           0.0.0.0:*
> > LISTEN      4806/cupsd
> > tcp        1      0 127.0.0.1:54040         127.0.0.1:80
> > CLOSE_WAIT  5814/konquerorHk573
> > tcp        0      0 127.0.0.1:80            127.0.0.1:54042
> > FIN_WAIT2   -
> > tcp        0      0 127.0.0.1:80            127.0.0.1:54040
> > FIN_WAIT2   -
> > tcp        1      0 127.0.0.1:54042         127.0.0.1:80
> > CLOSE_WAIT  6175/konquerordx573
> > 
> > So I can't start apache as long as these connections are not fully
> > closed, after that apache starts without problems.
> > 
> > ensima-hp ~ # netstat -pan --inet|grep 80
> > netstat: no support for `AF INET (sctp)' on this system.
> > tcp        0      0 127.0.0.1:631           0.0.0.0:*
> > LISTEN      4806/cupsd
> > 
> > ensima-hp ~ # /etc/init.d/apache2 start
> >  * Starting apache2 ...		[OK]
> > 
> > Problem occured between 2.6.34-rc4 and latest git, bisect shows that the
> > problem is caused by:
> > 
> > commit fda48a0d7a8412cedacda46a9c0bf8ef9cd13559
> > Author: Eric Dumazet <eric.dumazet@gmail.com>
> > Date:   Wed Apr 21 09:26:15 2010 +0000


Oh well...

I am going to test following patch in a couple of hours (I have to
run ...)

Always allowing a reuse LISTEN if no other listener is already active on
same IP.

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 78cbc39..e2076dd 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -78,6 +78,7 @@ int inet_csk_bind_conflict(const struct sock *sk,
 				    sk2_rcv_saddr == sk_rcv_saddr)
 					break;
 			} else if (reuse && sk2->sk_reuse &&
+				   sk->sk_state != TCP_LISTEN &&
 				   sk2_rcv_saddr &&
 				   sk2_rcv_saddr == sk_rcv_saddr)
 				break;


