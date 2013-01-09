Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab3AIOwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 09:52:09 -0500
Received: from dcmx03.tekelec.com ([198.89.35.103]:9935 "EHLO
	dcexchedge02.tekelec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757828Ab3AIOwI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 09:52:08 -0500
From: "Hassink, Brian" <Brian.Hassink@tekelec.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 9 Jan 2013 09:51:39 -0500
Subject: RE: epoll and listener sockets
Thread-Topic: epoll and listener sockets
Thread-Index: Ac3t7SwE22BkCpU1QE2Q6D8cn7ZT0wAAqFXQACF23BAAAJBeYA==
Message-ID: <F4F95B37FBE5E644988011E91104C7620A8F199A96@MAIL1.tekelec.com>
References: <F4F95B37FBE5E644988011E91104C7620A8F199879@MAIL1.tekelec.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With further tinkering, I have another interesting observation...

As I mentioned below, I have a configurable pool of concurrent threads in an epoll_wait() loop while the listener is being added to the epoll set.  The pool is just one thread by default, and I would see the listener fail somewhere in the range of 10-20% of the time.  Increasing the pool to two threads makes the listener fail nearly 100% of the time.

I had understood the epoll API to be thread safe.  Is that not correct?

-Brian

-----Original Message-----
From: Hassink, Brian 
Sent: Wednesday, January 09, 2013 9:36 AM
To: linux-kernel@vger.kernel.org
Subject: RE: epoll and listener sockets

I have a little more information on this problem...

I modified my test so that after the connection attempt is made, I force the listener to do an accept() and found that the connection is in the listener queue.

As I mentioned below, the connection attempt is made a full second after the listener is added to the epoll set, so there should not be any sort of race condition occurring.

-Brian

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Hassink, Brian
Sent: Tuesday, January 08, 2013 5:32 PM
To: linux-kernel@vger.kernel.org
Subject: epoll and listener sockets

$ uname -r
2.6.32-279.5.2.el6prerel6.0.0_80.23.0.x86_64
$ cat /etc/issue
CentOS release 6.3 (Final)

I sincerely hope this is the correct forum in which to ask about this, and apologize profusely if it is not.

I have a listener socket in an epoll set, and it will occasionally fail to receive an EPOLLIN event for a connection.  I have looked at a few example programs, which typically have the following sequence...

  1. call socket()
  2. call bind()
  3. call fcntl() to make fd non-blocking
  4. call epoll_ctl() to add the fd with (EPOLLET | EPOLLONESHOT | EPOLLIN)
  5. call listen()
  6. enter epoll_wait() loop

...where the listener socket is added to the epoll set before the epoll_wait() loop.

In my application, concurrent threads are running in an epoll_wait() loop and a listener socket may be created at any time.  I had initially tried this sequence...

  1. call socket()
  2. call bind()
  3. call fcntl() to make fd non-blocking
  4. call epoll_ctl() to add the fd with (EPOLLET | EPOLLONESHOT | EPOLLIN)
  5. call listen()

...but often received an EPOLLHUP event because of a concurrent epoll_wait() call between step 4 and 5.  So I switched the sequence to...

  1. call socket()
  2. call bind()
  3. call fcntl() to make fd non-blocking
  4. call listen()
  5. call epoll_ctl() to add the fd with (EPOLLET | EPOLLONESHOT | EPOLLIN)

In my testing there is only one connection attempt to the listener port, so EPOLLONESHOT should not be a factor.  I have also tried level-triggered with the same result.

I should also note that the connection attempt is made exactly one second after the listener is created.  So there isn't a race where the connection attempt is already queued before the listener is added to the epoll set.

I saw that there was a recent patch for EPOLL_CTL_MOD and EPOLLONESHOT, but I don't think that is relevant here.  Any thoughts on what the problem might be?

Thanks in advance,
Brian
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

