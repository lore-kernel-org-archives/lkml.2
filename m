Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab2LKXR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 18:17:59 -0500
Received: from vm-emlprdomg-06.its.yale.edu ([130.132.50.169]:34243 "EHLO
	vm-emlprdomg-06.its.yale.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754006Ab2LKXR6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 18:17:58 -0500
X-Greylist: delayed 3286 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Dec 2012 18:17:58 EST
From: Andreas Voellmy <andreas.voellmy@yale.edu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: epoll with ONESHOT possibly fails to deliver events
Date: Tue, 11 Dec 2012 17:23:08 -0500
Message-Id: <BC680BE9-F6EB-4278-819C-C552009CA884@yale.edu>
Cc: Andreas Voellmy <andreas.voellmy@yale.edu>
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
X-Mailer: Apple Mail (2.1499)
X-Proofpoint-SPF-Result: neutral
X-Proofpoint-SPF-Record: v=spf1 ip4:130.132.50.0/24 ip4:130.132.232.0/24 include:_spf.google.com
 ?all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2012-12-11_09:2012-12-11,2012-12-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1207200000 definitions=main-1212110228
X-Yale-Not-Spam: For more info see: http://www.yale.edu/email/spam/content.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

I am using epoll for the Linux (version 3.4.0) implementation of the event notification subsystem of GHC's (Glasgow Haskell Compiler) RTS (runtime system). I am running into a bug that has only popped up using many cores (> 16) and under particular kind of load. I've been debugging for a couple of days now, and I can't find the error in the way that I am using epoll. I'm starting to wonder whether I am either misunderstanding the semantics of epoll and TCP sockets (likely) or there may be a bug in epoll itself (less likely). 

Here is a simplified version of my epoll usage: My program is a multithreaded web server. I have one thread per TCP socket and each socket is marked non-blocking. Each thread serving a client socket repeats the following: 

1. receive a single http request's worth of bytes. 
2. send an http response.

For both steps, the thread will do a non-blocking operation (either recv or send) and if and only if the call returns EWOULDBLOCK or EAGAIN, then it calls epoll_ctl to register the socket and then it blocks on a condition variable. When the condition variable is signaled, it will continue where it left off (either about to recv or about to send). The epoll_ctl is performed with operation EPOLL_CTL_ADD if this is the first time the socket is being registered and otherwise is done with EPOLL_CTL_MOD.  The events field is EPOLLIN | EPOLLET | EPOLLONESHOT. 

Another thread, distinct from all of the threads serving particular sockets, is perfoming epoll_wait calls. When sockets are returned as being ready from an epoll_wait call, the thread signals to the condition variable for the socket. Since I am using EPOLLONESHOT, I assume that there is no need to also perform epoll_ctl with EPOLL_CTL_DEL here. 

This guarantees that I only wait for epoll to signal a file's readiness if (a) we hit EAGAIN or EWOULDBLOCK in a recv or send, and (b) we call epoll_ctl to re-arm (or arm if on the first time) the socket on epoll.

The problem I am encountering is that sometimes a thread will block waiting for the readiness signal and will never get notified, even though there is data to be read. This behavior seems to go away when I remove EPOLLONESHOT flag when registering the event. 

Is my use of epoll (as I described here) OK? Is the following sequence possible? 

1. epoll reports activity on socket previously registered with ONESHOT; now socket is deactivated in epoll.
2. call to recv on socket returns EAGAIN or EWOULDBLOCK
3. data arrives on socket
4. epoll_ctl call rearms socket with epoll (with ONESHOT flag).
5. epoll_wait never returns the socket as being ready.

Do I need to first call epoll_ctl and then call recv until I get to EAGAIN, or is it correct to call epoll_ctl for the file only after I've hit EAGAIN on a recv? 

I have looked over the epoll source here: http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=blob;f=fs/eventpoll.c;h=c0b3c70ee87a2b8e0e46c01a87d63ac692aecc71;hb=refs/heads/linux-3.4.y and I don't see how EPOLLONESHOT could result in the event sequence above, but I'm not that familiar with the code, so it would be great if others can confirm as well. 

I am not subscribed to the kernel list, so please include my email on replies.

Cheers,
Andi