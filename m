Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab2LOOvC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 09:51:02 -0500
Received: from vm-emlprdomg-04.its.yale.edu ([130.132.50.162]:39817 "EHLO
	vm-emlprdomg-04.its.yale.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751502Ab2LOOvA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 09:51:00 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: epoll with ONESHOT possibly fails to deliver events
From: Andreas Voellmy <andreas.voellmy@yale.edu>
In-Reply-To: <9BE5F9A7-4D5B-4848-A0BA-55004240B6E0@yale.edu>
Date: Sat, 15 Dec 2012 09:50:56 -0500
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "junchang.wang@yale.edu Wang" <junchang.wang@yale.edu>
Content-Transfer-Encoding: 8BIT
Message-Id: <4F40C83D-1C29-4654-8B9C-9DBFB63BDC1D@yale.edu>
References: <BC680BE9-F6EB-4278-819C-C552009CA884@yale.edu> <AF8622CA-CF9D-4F57-B4EB-FE088A752D80@yale.edu> <20121213093242.GA25436@dcvr.yhbt.net> <2F8919C4-395F-4029-8D4F-AD16A3815FC5@yale.edu> <9BE5F9A7-4D5B-4848-A0BA-55004240B6E0@yale.edu>
To: Eric Wong <normalperson@yhbt.net>
X-Mailer: Apple Mail (2.1499)
X-Proofpoint-SPF-Result: neutral
X-Proofpoint-SPF-Record: v=spf1 ip4:130.132.50.0/24 ip4:130.132.232.0/24 include:_spf.google.com
 ?all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2012-12-15_05:2012-12-15,2012-12-15,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1211240000 definitions=main-1212150123
X-Yale-Not-Spam: For more info see: http://www.yale.edu/email/spam/content.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were a couple of errors in the code when I posted my last message. I have fixed those. The epoll bug still occurs. 

-Andi

On Dec 13, 2012, at 7:16 PM, Andreas Voellmy <andreas.voellmy@yale.edu> wrote:

> I believe I have found a bug in epoll. This bug causes the behavior I described in earlier emails. The bug is caused by the interaction of epoll instances which share no files in common. 
> 
> I wrote a C program that behaves similar to my original program and triggers the bug. The bug only arises when I use enough cores and threads (about 16). The program is here: https://github.com/AndreasVoellmy/epollbug/blob/master/epollbug.c  This program is a super-stripped down http server.  It uses a number of threads that serve requests, each with its own epoll instance. There is also a "wakeup" thread that simply monitors an eventfd file and reads from the eventfd file when woken. All the worker threads write to the eventfd file when they process a request. This probably seems like a strange program, but something like this came up in a real system. 
> 
> I test the program using the weighttp http request generator (http://redmine.lighttpd.net/projects/weighttp/wiki). You need to test with enough requests and enough concurrent clients, and enough worker threads to create the problem. For example, I run with './weighttp -n 400000 -c 500 -t 6 -k "10.12.0.1:8080"'. With 16 cores for the server program (epollbug.c) this test workload triggers the bug about once every 3 runs.  The server (epollbug.c) has been hardcoded to work with whatever specific request weighttp sends it.  You need to find out what weighttp is sending from your test machine and then put that at the top of epollbug.c. You will see where it goes. You can uncomment the SHOW_DEBUG flag at the top of the program and run weighttp against it and it will print the request weighttp is sending. Then update the EXPECTED_HTTP_REQUEST with whatever you get.
> 
> I am running Linux 3.4.0.0. 
> 
> Cheers, 
> Andi
> 
> On Dec 13, 2012, at 10:29 AM, Andreas Voellmy <andreas.voellmy@yale.edu> wrote:
> 
>> Hi Eric, 
>> 
>> On Dec 13, 2012, at 4:32 AM, Eric Wong <normalperson@yhbt.net> wrote:
>> 
>>> Andreas Voellmy <andreas.voellmy@yale.edu> wrote:
>>> 
>>>>> Another thread, distinct from all of the threads serving particular
>>>>> sockets, is perfoming epoll_wait calls. When sockets are returned as
>>>>> being ready from an epoll_wait call, the thread signals to the
>>>>> condition variable for the socket.
>>> 
>>> Perhaps there is a bug in the way your epoll_wait thread
>>> uses the condition variable to notify other threads?
>>> 
>> 
>> This is possible; I've tried very hard (e.g. I added assertions to check various error conditions) to ensure that there is problem in signaling the other threads. From everything I can tell, it is working properly.
>> 
>>> 
>>>>> The problem I am encountering is that sometimes a thread will block
>>>>> waiting for the readiness signal and will never get notified, even
>>>>> though there is data to be read. This behavior seems to go away when
>>>>> I remove EPOLLONESHOT flag when registering the event. 
>>> 
>>> Is the thread the one waiting on the condition variable or epoll_wait?
>>> In your situation (stream I/O via multiple threads, single epoll
>>> descriptor), I think EPOLLONESHOT is the /only/ sane thing to do.
>> 
>> The one waiting on the condition variable.
>> 
>> I think I've narrowed down the problem a bit more. In my program I have multiple epoll instances. Most of the epoll instances are for monitoring sockets. One is used for monitoring an eventfd that is written to by other threads. The problem only occurs when I write to the eventfd after servicing each http request on a socket; i.e. the epoll monitoring the eventfd is returning from a blocking epoll_wait call very frequently . If I don't do that write, or if I use a different notification facility, for example poll, to monitor the eventfd, then the problem goes away.  So it looks like there may be some way in which different epoll instances can interfere with each other. 
>> 
>> Probably this setup sounds weird to you, but I'm trying to spare you from understanding my whole application;  this is part of a multicore runtime system for a programming language with user-level threads and to explain the full story of this would probably take more time than you want to spend.   But I can provide more detail if you like. 
>> 
>> -Andi
> 

