Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab1EGMMq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 08:12:46 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60647 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab1EGMMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 08:12:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=xXaJFZ7nnmVeHHovwcBJ6Loz+UHvWGRG++hotA30SiyW1j/2lF0bP9votroel4d1s6
         3bM5gDgVAV7RGkM8c0sSFwScnoZ9q5B4hXkKLU1dk/x4vSoX/wXb3mOd1BIKw9st2Yxq
         f9pLtb4NuHR/nyMkZs1veLVVuhHIt1z4EF63w=
Subject: Re: bug in select(2) regarding non-blocking connect(2) completion?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Michael Shuldman <michaels@inet.no>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        karls@inet.no, netdev <netdev@vger.kernel.org>
In-Reply-To: <20110507105152.GA13459@jensen.inet.no>
References: <20110507105152.GA13459@jensen.inet.no>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 May 2011 14:12:38 +0200
Message-ID: <1304770358.2821.1139.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 07 mai 2011 à 12:51 +0200, Michael Shuldman a écrit :
> Hello, I am occasionally encountering what I belive is a bug in the
> kernel.
> 
> Below is a strace that I believe shows how the bug manifests itself,
> with my comments.
> 
> 
> # first select.  All fd's in the write set ([15 17 ... 51 55]) are 
> # non-blocking sockets that have had a connect(2) previously issued on
> # them, and which have yet to finish connecting as far as we know
> # at the time we call select(2).

We dont see the return from connect() : maybe the error was already
returned there.

Only EINPROGRESS is valid here (or fd should be closed right now)

> 03:55:31.808548 select(58, [4 8 11 12 13 14 16 18 19 20 21 22 23 24 26 27 30 31
> 32 33 34 35 36 37 39 40 41 43 44 46 48 49 50 52 53 54 57], [15 17 25 29 45 47 51
>  55], [11 12 13 14 16 18 19 20 21 22 23 24 26 27 30 31 32 33 34 35 36 37 39 40 4
> 1 43 44 46 48 49 50 52 53 54 57], {1, 0}) = 3 (in [16 26], out [51], left {1, 0}
> )
> 
> # As indicated by the results returned by the above select(2), fd 51 should
> # have finished the connect attempt, but when we try to find out whether 
> # the connect(2) succeeded or failed, the results are conflicting.
> 

If connect() attempt is rejected by remote peer, then select() says your
fd is 'writeable', in the sense you have the definitive answer to your
non blocking connect().

> 03:55:31.808622 getpeername(51, 0x7fff5d2eaa8c, [0]) = -1 ENOTCONN (Transport en
> dpoint is not connected)

This means end point is non connected : other peer sent RST or no answer
to SYN packets.


> 03:55:31.808900 getsockopt(51, SOL_SOCKET, SO_ERROR, [0], [4]) = 0
> 

Hmm, interesting... Are you sure a previous call was not already done
(since this clears the error) ?

> # getpeername(2) failing on a socket that has finished connecting should 
> # indicate that the connect(2) failed.  Yet when we try to fetch the
> # SO_ERROR of the socket, it says no error is currently set.
> # We then loop around with select(2) again, and again the same thing
> # happens:
> 
> 03:55:31.809259 select(58, [4 8 11 12 13 14 16 18 19 20 21 22 23 24 26 27 30 31
> 32 33 34 35 36 37 39 40 41 43 44 46 48 49 50 52 53 54 57], [15 17 25 29 45 47 51
>  55], [11 12 13 14 16 18 19 20 21 22 23 24 26 27 30 31 32 33 34 35 36 37 39 40 4
> 1 43 44 46 48 49 50 52 53 54 57], {1, 0}) = 3 (in [16 26], out [51], left {1, 0}
> )
> 03:55:31.809329 getpeername(51, 0x7fff5d2eaa8c, [0]) = -1 ENOTCONN (Transport en
> dpoint is not connected)
> 03:55:31.809640 getsockopt(51, SOL_SOCKET, SO_ERROR, [0], [4]) = 0
> 

Well, if you missed the original error report, all next getpeername()
and SO_ERROR will do the same, and select() says fd is ready for 'write'

> ...
> 
> # finally, getsockopt(2) returns that the connect(2) failed.
> 03:55:32.521146 getpeername(51, 0x7fff5d2eaa8c, [0]) = -1 ENOTCONN (Transport en
> dpoint is not connected)
> 03:55:32.521614 getsockopt(51, SOL_SOCKET, SO_ERROR, [101], [4]) = 0
> 
> In other words, select(2) says the socket has finished connecting,
> getpeername(2) neither confirms nor denies this (it can only confirm
> if the connect finished successfully).  getsockopt(2) and SO_ERROR
> however says there is no error on the socket, which coupled
> with getpeername(2) failing, indicates that the connect(2) has
> not yet finished
> 
> 
> 
> This does not happen all the time.  E.g., I watched the system for
> an hour yesterday, as things were staring up and the number of
> concurrent tcp clients gradually increased from zero to around 700,
> with no observable problems.  However after a while, the problem
> starts occurring, related to an increasing number of clients or
> something else, I do not know.
> 
> Currently the system has a little over 3,000 clients and the problem
> occurs now and then, sometimes several times a minute, while sometimes
> it can take dozens of minutes between each time.  At the moment,
> the last time the problem was detected was 40 minutes ago.
> 
> The software the above strace is related to is a proxy server, and
> if there are 3000 clients (incoming TCP sessions), there would
> normally be 3000 outgoing TCP sessions also.  
> 
> uname -a on the system in question reports 
> 2.6.18-238.9.1.el5 #1 SMP Tue Apr 12 18:10:13 EDT 2011 x86_64 x86_64
> x86_64 GNU/Linux
> 
> Thankful for any hints or pointers related to this problem.
> With kind regards,
> 

Make sure you dont miss an error in connect() system call.



