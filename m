Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab0J3Mxp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 08:53:45 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53502 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab0J3Mxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 08:53:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lzKMDE0tz7svKjtkseA49yfgu3cfZ4Hl4p9NzhPLWp3vBqlcOM3nDfL6M/G1lkHNVL
         +Lm4aeHW1DCTazncKJzgbq7S/TRGZxYTqtzwWzPePeZlSBEq2VuhfrpnkH0ub+jGnOyy
         NPPSD1zG64y8U1n3gin1gdf5SqLlAqkDHxPaQ=
Subject: Re: [PATCH 0/1] RFC: poll/select performance on datagram sockets
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alban Crequy <alban.crequy@collabora.co.uk>
Cc: "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pauli Nieminen <pauli.nieminen@collabora.co.uk>,
        Rainer Weikusat <rweikusat@mssgmbh.com>,
        Davide Libenzi <davidel@xmailserver.org>
In-Reply-To: <20101030123403.5e01540d@chocolatine.cbg.collabora.co.uk>
References: <20101029191857.5f789d56@chocolatine.cbg.collabora.co.uk>
	 <1288380431.2680.3.camel@edumazet-laptop>
	 <20101030123403.5e01540d@chocolatine.cbg.collabora.co.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Oct 2010 14:53:37 +0200
Message-ID: <1288443217.2680.962.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 30 octobre 2010 à 12:34 +0100, Alban Crequy a écrit :
> Le Fri, 29 Oct 2010 21:27:11 +0200,
> Eric Dumazet <eric.dumazet@gmail.com> a écrit :
> 
> > Le vendredi 29 octobre 2010 à 19:18 +0100, Alban Crequy a écrit :
> > > Hi,
> > > 
> > > When a process calls the poll or select, the kernel calls (struct
> > > file_operations)->poll on every file descriptor and returns a mask
> > > of events which are ready. If the process is only interested by
> > > POLLIN events, the mask is still computed for POLLOUT and it can be
> > > expensive. For example, on Unix datagram sockets, a process running
> > > poll() with POLLIN will wakes-up when the remote end call read().
> > > This is a performance regression introduced when fixing another bug
> > > by 3c73419c09a5ef73d56472dbfdade9e311496e9b and
> > > ec0d215f9420564fc8286dcf93d2d068bb53a07e.
> > > 
> > > The attached program illustrates the problem. It compares the
> > > performance of sending/receiving data on an Unix datagram socket and
> > > select(). When the datagram sockets are not connected, the
> > > performance problem is not triggered, but when they are connected
> > > it becomes a lot slower. On my computer, I have the following time:
> > > 
> > > Connected datagram sockets: >4 seconds
> > > Non-connected datagram sockets: <1 second
> > > 
> > > The patch attached in the next email fixes the performance problem:
> > > it becomes <1 second for both cases. I am not suggesting the patch
> > > for inclusion; I would like to change the prototype of (struct
> > > file_operations)->poll instead of adding ->poll2. But there is a
> > > lot of poll functions to change (grep tells me 337 functions).
> > > 
> > > Any opinions?
> > 
> > My opinion would be to use epoll() for this kind of workload.
> 
> I found a problem with epoll() with the following program. When there
> is several datagram sockets connected to the same server and the
> receiving queue is full, epoll(EPOLLOUT) wakes up only the emitter who
> has its skb removed from the queue, and not all the emitters. It is
> because sock_wfree() runs sk->sk_write_space() only for one emitter.
> 

I dont think this is the reason.

sock_wfree() really is good here, since it copes with one socket (the
one that sent the message)

Problem is the peer_wait, that epoll doesnt seem to be plugged into.

Bug is in unix_dgram_poll()

It calls sock_poll_wait( ... &unix_sk(other)->peer_wait,) only if socket
is 'writable'. Its a clear bug

Try this patch please ?

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 0ebc777..315716c 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2092,7 +2092,7 @@ static unsigned int unix_dgram_poll(struct file *file, struct socket *sock,
 
 	/* writable? */
 	writable = unix_writable(sk);
-	if (writable) {
+	if (1 /*writable*/) {
 		other = unix_peer_get(sk);
 		if (other) {
 			if (unix_peer(other) != sk) {




