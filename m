Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469Ab1KQQAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 11:00:11 -0500
Received: from mail2.shareable.org ([80.68.89.115]:56971 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331Ab1KQQAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 11:00:09 -0500
X-Greylist: delayed 1895 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Nov 2011 11:00:08 EST
Date: Thu, 17 Nov 2011 15:28:32 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Robin Dong <hao.bigrat@gmail.com>
Cc: linux-api@vger.kernel.org, linux-netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davidel@xmailserver.org
Subject: Re: [Bug] epoll_wait return EPOLLOUT even with EPOLLET flag
Message-ID: <20111117152832.GA4525@jl-vm1.vm.bytemark.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFZ0FUWptNqUJUkoj8=3eLSMrGKPKB5c7NcFv_5iJfJLuJF+sw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Dong wrote:
> Hi,
> 
> I am a linux user and I found some question when using epoll with EPOLLET.
> 
> My program's step:
> 
> 1. create a socket (sfd) and connect to server
> 2. create epoll (efd)
> 3. add socket descriptor (sfd) to epoll (efd) with flag EPOLLET
> 4. get a EPOLLOUT event through epoll_wait
> 
> After that, the program will nerver get a EPOLLOUT event because ituse
> EPOLLET mode (the same event will not be got twice)

Hi Robin,

With EPOLLET|EPOLLOUT, you should get a message from epoll whenever
the fd's status changes from "cannot output" to "can output".

So you should get a message when sfd transitions from write()
returning EAGAIN to write() accepting more data.

Until you get EAGAIN while writing, your program should assume the
socket is still writable.  "man epoll" has a few things to say about
this (look for all the places here it says EAGAIN).

> BUT，when a message comes from server，the client socket will get aevent
> and this event contains EPOLLOUT and EPOLLIN, looks epoll_waitreturn
> too much events than it should

The message always contains the latest status, so says EPOLLOUT|EPOLLIN.

It's doesn't mean there's an EPOLLOUT "event", it just means a message
is triggered (by the socket becoming readable) so you get a status
update.  In theory the program doesn't need to be told about EPOLLOUT
here (it should be assuming the socket is writable already), but it
doesn't do any harm.

EPOLLET is just a way to reduce the number of messages from epoll when
you call epoll_wait().  In effect you are telling the kernel "don't
send me repeated status messages and I'll maintain my own flags".  But
it doesn't change the status value in messages that are sent.

Enjoy,
-- Jamie
