Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab2DVPl2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 11:41:28 -0400
Received: from edge.cmeerw.net ([84.200.12.152]:58644 "EHLO edge.cmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126Ab2DVPl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 11:41:27 -0400
X-Greylist: delayed 556 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Apr 2012 11:41:26 EDT
Date: Sun, 22 Apr 2012 17:32:07 +0200
From: Christof Meerwald <cmeerw@cmeerw.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Strange EPOLLOUT|EPOLLET behaviour (spurious events)
Message-ID: <20120422153207.GK22644@edge.cmeerw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-PGP-Key: 1024D/2B10BE68, 1998-06-29
X-PGP-Fingerprint: 0289 5466 C1F5 B03C DBA7  6304 8CAF 9782 2B10 BE68
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am seeing some unexpected behaviour with EPOLLOUT in edge-triggered
mode - some example code is available from
http://svn.cmeerw.net/src/nginetd/trunk/test/eptest-out.c

What seems to be happening is that I get an EPOLLOUT event after each
send on the socket (even in edge-triggered mode). This is what strace
shows me:

epoll_create(1024)                      = 3
socketpair(PF_FILE, SOCK_DGRAM, 0, [4, 5]) = 0
fcntl(5, F_GETFL)                       = 0x2 (flags O_RDWR)
fcntl(5, F_SETFL, O_RDWR|O_NONBLOCK)    = 0
epoll_ctl(3, EPOLL_CTL_ADD, 5, {EPOLLIN|EPOLLOUT|EPOLLET, {u32=5, u64=5}}) = 0
sendto(5, "\0\0\0\0", 4, 0, NULL, 0)    = 4
recvfrom(4, "\0\0\0\0", 4, 0, NULL, NULL) = 4
epoll_wait(3, {{EPOLLOUT, {u32=5, u64=5}}}, 16, 0) = 1
sendto(5, "\1\0\0\0", 4, 0, NULL, 0)    = 4
recvfrom(4, "\1\0\0\0", 4, 0, NULL, NULL) = 4
epoll_wait(3, {{EPOLLOUT, {u32=5, u64=5}}}, 16, 0) = 1
sendto(5, "\2\0\0\0", 4, 0, NULL, 0)    = 4
recvfrom(4, "\2\0\0\0", 4, 0, NULL, NULL) = 4
epoll_wait(3, {{EPOLLOUT, {u32=5, u64=5}}}, 16, 0) = 1

But as I am using EPOLLET, I wouldn't expect to get any EPOLLOUT
events on that socket as send never returns EAGAIN (and there isn't
any state transition).

BTW, I have seen https://lkml.org/lkml/2011/11/17/48 , but my case is
different (as there isn't any EPOLLIN event on that socket either).

Am I missing something here?


Christof

-- 

http://cmeerw.org                              sip:cmeerw at cmeerw.org
mailto:cmeerw at cmeerw.org                   xmpp:cmeerw at cmeerw.org
