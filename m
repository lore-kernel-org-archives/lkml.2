Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab2LUPcx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 10:32:53 -0500
Received: from vm-emlprdomg-07.its.yale.edu ([130.132.50.170]:55713 "EHLO
	vm-emlprdomg-07.its.yale.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751371Ab2LUPcq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 10:32:46 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: epoll with ONESHOT possibly fails to deliver events
From: Andreas Voellmy <andreas.voellmy@yale.edu>
In-Reply-To: <CAErQho6bf+y+7dwtP4sKjNGsjLdDm8aBo4A6KagZHgcRT=KMWA@mail.gmail.com>
Date: Fri, 21 Dec 2012 10:32:45 -0500
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Junchang(Jason) Wang" <junchang.wang@yale.edu>
Content-Transfer-Encoding: 7BIT
Message-Id: <35FB17E6-66E9-4945-AC77-1C66AC18797D@yale.edu>
References: <BC680BE9-F6EB-4278-819C-C552009CA884@yale.edu> <AF8622CA-CF9D-4F57-B4EB-FE088A752D80@yale.edu> <20121213093242.GA25436@dcvr.yhbt.net> <2F8919C4-395F-4029-8D4F-AD16A3815FC5@yale.edu> <9BE5F9A7-4D5B-4848-A0BA-55004240B6E0@yale.edu> <20121220213210.GA22655@dcvr.yhbt.net> <CAErQho6bf+y+7dwtP4sKjNGsjLdDm8aBo4A6KagZHgcRT=KMWA@mail.gmail.com>
To: Eric Wong <normalperson@yhbt.net>
X-Mailer: Apple Mail (2.1499)
X-Proofpoint-SPF-Result: neutral
X-Proofpoint-SPF-Record: v=spf1 ip4:130.132.50.0/24 ip4:130.132.232.0/24 include:_spf.google.com
 ?all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2012-12-21_06:2012-12-21,2012-12-21,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=3 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1211240000 definitions=main-1212210119
X-Yale-Not-Spam: For more info see: http://www.yale.edu/email/spam/content.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric, 

Thanks again for looking at our bug report. I agree with Jason's comments: the bug occurs independently of the socketCheck function; this function waits long enough for the server to stop serving any more requests and then checks the sockets to find out which ones still have data (and therefore should be served).  But I like your suggestion, so I updated the code to use ioctl rather than recv in socketCheck. As we expected, the bug still occurs. 

Cheers, 
Andi

On Dec 20, 2012, at 5:25 PM, "Junchang(Jason) Wang" <junchang.wang@yale.edu> wrote:

> On Thu, Dec 20, 2012 at 4:32 PM, Eric Wong <normalperson@yhbt.net> wrote:
>> Andreas Voellmy <andreas.voellmy@yale.edu> wrote:
>>> I wrote a C program that behaves similar to my original program and
>>> triggers the bug. The bug only arises when I use enough cores and
>>> threads (about 16). The program is here:
>>> https://github.com/AndreasVoellmy/epollbug/blob/master/epollbug.c
>> 
>> I finally took a closer look at your code.   I think your socketCheck()
>> thread is draining socket and causing the normal threads to miss
>> events.
>> 
> 
> Hi Wong,
> 
> Thank you so much for responses. But I think you probably
> misunderstood socketCheck() which we use at the end of the program to
> check whether the bug has occurred (by checking whether some data
> remains in the sockets). Please note there's a sleep(10) (line 237) at
> the very beginning of socketCheck(). In other words, we can guarantee
> recv() (line 239) doesn't execute when the normal threads are running.
> 
> We still believe this is a bug in epoll system even though we can't
> prove that so far. Both Andi and I are very interested in this problem
> and helping you experts solve this it. Just let us know if we can
> help.
> 
> 
> Thanks.
> 
>> Use the FIONREAD ioctl() instead to get unread bytes instead of recv().
>> If you want to recv() without draining the socket, you can also use
>> the MSG_PEEK flag.

