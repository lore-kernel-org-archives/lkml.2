Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab0HYWeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 18:34:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36973
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753469Ab0HYWeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 18:34:09 -0400
Date: Wed, 25 Aug 2010 15:34:24 -0700 (PDT)
Message-Id: <20100825.153424.246521475.davem@davemloft.net>
To: kosaki.motohiro@jp.fujitsu.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yoshfuji@linux-ipv6.org
Subject: Re: [PATCH] tcp: select(writefds) don't hang up when a peer close
 connection
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100825110049.F3C9.A69D9226@jp.fujitsu.com>
References: <20100825110049.F3C9.A69D9226@jp.fujitsu.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Wed, 25 Aug 2010 11:05:48 +0900 (JST)

> This issue come from ruby language community. Below test program
> hang up when only run on Linux.
> 
> 	% uname -mrsv
> 	Linux 2.6.26-2-486 #1 Sat Dec 26 08:37:39 UTC 2009 i686
> 	% ruby -rsocket -ve '
> 	BasicSocket.do_not_reverse_lookup = true
> 	serv = TCPServer.open("127.0.0.1", 0)
> 	s1 = TCPSocket.open("127.0.0.1", serv.addr[1])
> 	s2 = serv.accept
> 	s2.close
> 	s1.write("a") rescue p $!
> 	s1.write("a") rescue p $!
> 	Thread.new {
> 	  s1.write("a")
> 	}.join'
> 	ruby 1.9.3dev (2010-07-06 trunk 28554) [i686-linux]
> 	#<Errno::EPIPE: Broken pipe>
> 	[Hang Here]
> 
> FreeBSD, Solaris, Mac doesn't. because Ruby's write() method call
> select() internally. and tcp_poll has a bug.

In your opinion.

> SUS defined 'ready for writing' of select() as following.
> 
> |  A descriptor shall be considered ready for writing when a call to an output
> |  function with O_NONBLOCK clear would not block, whether or not the function
> |  would transfer data successfully.
> 
> That said, EPIPE situation is clearly one of 'ready for writing'.

How Linux should behave is defined by many things, and often it is
simply defined by how we've behaved for a very long time.  This is
because changing behavior can often break as many applications as it
can fix.  Standards don't necessarily tell us how we must behave,
since often is it impractical to follow their definions.

And in this case here, I call into question the behavior of Ruby and
the application from two perspectives:

1) Unlike all of the other conditions signalled by poll() this is
   one the application explicitly created and therefore knows about.

   If the application calls close() or shutdown() with the send flag
   set, IT KNOWS what is going to happen on a write() attempt.

2) Ruby and this script will have to deal with the past 13 years
   worth of Linux kernels.  Even if I were to apply this fix now
   it is not going to propagate onto a user's system any time soon.

   Many systems would never ever get this fix.

   Therefore it behooves Ruby and this script to make a very reasonable
   change, which is to track when close() or send shutdown() calls occur
   and behave appropriately on a write() call.

I'm therefore not applying this patch, because not only can applications
handle this properly with information they already have, the change has
the potential to break applications.
