Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab2LMP3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:29:19 -0500
Received: from vm-emlprdomg-06.its.yale.edu ([130.132.50.169]:44185 "EHLO
	vm-emlprdomg-06.its.yale.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753031Ab2LMP3S convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:29:18 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: epoll with ONESHOT possibly fails to deliver events
From: Andreas Voellmy <andreas.voellmy@yale.edu>
In-Reply-To: <20121213093242.GA25436@dcvr.yhbt.net>
Date: Thu, 13 Dec 2012 10:29:17 -0500
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <2F8919C4-395F-4029-8D4F-AD16A3815FC5@yale.edu>
References: <BC680BE9-F6EB-4278-819C-C552009CA884@yale.edu> <AF8622CA-CF9D-4F57-B4EB-FE088A752D80@yale.edu> <20121213093242.GA25436@dcvr.yhbt.net>
To: Eric Wong <normalperson@yhbt.net>
X-Mailer: Apple Mail (2.1499)
X-Proofpoint-SPF-Result: neutral
X-Proofpoint-SPF-Record: v=spf1 ip4:130.132.50.0/24 ip4:130.132.232.0/24 include:_spf.google.com
 ?all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2012-12-13_06:2012-12-13,2012-12-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1211240000 definitions=main-1212130119
X-Yale-Not-Spam: For more info see: http://www.yale.edu/email/spam/content.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric, 

On Dec 13, 2012, at 4:32 AM, Eric Wong <normalperson@yhbt.net> wrote:

> Andreas Voellmy <andreas.voellmy@yale.edu> wrote:
> 
>>> Another thread, distinct from all of the threads serving particular
>>> sockets, is perfoming epoll_wait calls. When sockets are returned as
>>> being ready from an epoll_wait call, the thread signals to the
>>> condition variable for the socket.
> 
> Perhaps there is a bug in the way your epoll_wait thread
> uses the condition variable to notify other threads?
> 

This is possible; I've tried very hard (e.g. I added assertions to check various error conditions) to ensure that there is problem in signaling the other threads. From everything I can tell, it is working properly.

> 
>>> The problem I am encountering is that sometimes a thread will block
>>> waiting for the readiness signal and will never get notified, even
>>> though there is data to be read. This behavior seems to go away when
>>> I remove EPOLLONESHOT flag when registering the event. 
> 
> Is the thread the one waiting on the condition variable or epoll_wait?
> In your situation (stream I/O via multiple threads, single epoll
> descriptor), I think EPOLLONESHOT is the /only/ sane thing to do.

The one waiting on the condition variable.

I think I've narrowed down the problem a bit more. In my program I have multiple epoll instances. Most of the epoll instances are for monitoring sockets. One is used for monitoring an eventfd that is written to by other threads. The problem only occurs when I write to the eventfd after servicing each http request on a socket; i.e. the epoll monitoring the eventfd is returning from a blocking epoll_wait call very frequently . If I don't do that write, or if I use a different notification facility, for example poll, to monitor the eventfd, then the problem goes away.  So it looks like there may be some way in which different epoll instances can interfere with each other. 

Probably this setup sounds weird to you, but I'm trying to spare you from understanding my whole application;  this is part of a multicore runtime system for a programming language with user-level threads and to explain the full story of this would probably take more time than you want to spend.   But I can provide more detail if you like. 

-Andi