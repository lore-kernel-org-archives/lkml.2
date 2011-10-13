Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165Ab1JMPnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 11:43:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53911 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab1JMPnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 11:43:40 -0400
Message-ID: <1318520635.2393.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: (splice socket -> pipe) + EPOLLET -> epoll_wait does not not
 wake up !
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?UTF-8?Q?=D0=9C=D0=B0=D1=80=D0=BA_?=
	 =?UTF-8?Q?=D0=9A=D0=BE=D1=80=D0=B5=D0=BD=D0=B1=D0=B5=D1=80=D0=B3?= 
	<socketpair@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 13 Oct 2011 17:43:55 +0200
In-Reply-To: <CAEmTpZFt=j-TQjk_8Hx1Yv781SH8MFR_=OrnfH+vke9Q8JZpFA@mail.gmail.com>
References: <CAEmTpZG5MN8Ha4=ZcCnWC3jJP9x4Bw7ZEC2vQdOGJZiaG4QYkA@mail.gmail.com>
	 <CAEmTpZFt=j-TQjk_8Hx1Yv781SH8MFR_=OrnfH+vke9Q8JZpFA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 13 octobre 2011 à 20:48 +0600, Марк Коренберг a écrit :
> The problem:
> 
> man 7 epoll said:
> For  stream-oriented  files  (e.g.,  pipe, FIFO, stream socket), the
> condition that the read/write I/O space is exhausted can also be
> detected by checking the amount of data read from / written to the
> target file descriptor.  For example, if you call read(2) by asking to
> read a certain amount of data and read(2) returns a lower number of
> bytes, you  can  be  sure of having exhausted the read I/O space for
> the file descriptor.
> 
> I decide to use splice socket -> pipe instead of recv. So I have
> registered socket's fd in epoll with EPOLLIN|EPOLLET.
> 
> When data appear in socket faster than I splice() it from socket, the
> following sometimes appear:
> 
> 1. in my code I sure, that pipe is empty.
> 2. my code do splice(socket, pipe, 65536)
> 3. splice return, say, 53248
> 4. my code accordingly to man, decide not to fire splice() again, as
> it thinks that it will return EWOULDBLOCK=EAGAIN.
> 5. so, my code go to epoll_wait to wait for EPOLLIN on socket
> 6. epoll hangs.
> 
> This is not appear if I do just recv(). But it may be because speed is
> lower, and some race condition in effect.
> 
> The hacked version of strace output is attached.

Your assumptions about splice() are false.

splice() can transfert partial pages.

So you can hit the 16 pages pipe limit, and splice() doesnt necessarly
returns 16*PAGE_SIZE.

With TCP frames, usually 1460 bytes per PAGE are used.

You must call splice() again and again, unless 0 bytes (EAGAIN) are
returned.



