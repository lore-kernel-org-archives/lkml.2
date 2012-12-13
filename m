Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab2LMJkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 04:40:19 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:36042 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597Ab2LMJkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 04:40:14 -0500
X-Greylist: delayed 450 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Dec 2012 04:40:14 EST
Date: Thu, 13 Dec 2012 09:32:42 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Andreas Voellmy <andreas.voellmy@yale.edu>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: epoll with ONESHOT possibly fails to deliver events
Message-ID: <20121213093242.GA25436@dcvr.yhbt.net>
References: <BC680BE9-F6EB-4278-819C-C552009CA884@yale.edu>
 <AF8622CA-CF9D-4F57-B4EB-FE088A752D80@yale.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AF8622CA-CF9D-4F57-B4EB-FE088A752D80@yale.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Voellmy <andreas.voellmy@yale.edu> wrote:
> Using strace, I checked that my program is using epoll api as I
> described. Here is a fragment of the strace output that demonstrates
> my use: 
> 
> recvfrom(161, "GET / HTTP/1.1\r\nHost: 10.12.0.1:"..., 90, 0, NULL, NULL) = 90
> sendto(161, "HTTP/1.1 200 OK\r\nDate: Tue, 09 O"..., 323, 0, NULL, 0) = 323
> write(6, "\1\0\0\0\0\0\0\0", 8)         = 8
> recvfrom(161, 0x7f05ef6c3070, 90, 0, 0, 0) = -1 EAGAIN (Resource temporarily unavailable)
> epoll_ctl(7, EPOLL_CTL_MOD, 161, {EPOLLIN|EPOLLONESHOT|EPOLLET, {u32=161, u64=4294967457}}) = 0
> epoll_wait(7, {{EPOLLIN, {u32=161, u64=4294967457}}, {EPOLLIN, {u32=160, u64=16673999036704882848}}, {EPOLLIN, {u32=162, u64=22028646743015586}}}, 64, 0) = 3
> 
> I.e. we do the following (1) receive until EAGAIN, (2) register socket
> with epoll_ctl. In addition epoll_wait is called repeatedly, often
> following (2), as in the fragment above.
> 
> Is this considered a correct usage of the epoll API? If not, what is
> wrong with this usage?

It looks right to me.

> On Dec 11, 2012, at 5:23 PM, Andreas Voellmy <andreas.voellmy@yale.edu> wrote:
> > I am using epoll for the Linux (version 3.4.0) implementation of the
> > event notification subsystem of GHC's (Glasgow Haskell Compiler) RTS
> > (runtime system). I am running into a bug that has only popped up
> > using many cores (> 16) and under particular kind of load. I've been
> > debugging for a couple of days now, and I can't find the error in
> > the way that I am using epoll. I'm starting to wonder whether I am
> > either misunderstanding the semantics of epoll and TCP sockets
> > (likely) or there may be a bug in epoll itself (less likely). 

Everything you describe with your epoll usage seems valid and lines up
with my use of it.

> > Another thread, distinct from all of the threads serving particular
> > sockets, is perfoming epoll_wait calls. When sockets are returned as
> > being ready from an epoll_wait call, the thread signals to the
> > condition variable for the socket.

Perhaps there is a bug in the way your epoll_wait thread
uses the condition variable to notify other threads?

Fwiw, I just use epoll_wait(maxevents=1) in my normal threads (right
after I call epoll_ctl()).  This means I can avoid both the condition
variable and also avoid using a dedicated thread calling epoll_wait().

> > Since I am using EPOLLONESHOT, I assume that there is no need to
> > also perform epoll_ctl with EPOLL_CTL_DEL here. 

Correct.

> > The problem I am encountering is that sometimes a thread will block
> > waiting for the readiness signal and will never get notified, even
> > though there is data to be read. This behavior seems to go away when
> > I remove EPOLLONESHOT flag when registering the event. 

Is the thread the one waiting on the condition variable or epoll_wait?
In your situation (stream I/O via multiple threads, single epoll
descriptor), I think EPOLLONESHOT is the /only/ sane thing to do.
