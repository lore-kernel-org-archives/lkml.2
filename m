Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab0DWENT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 00:13:19 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:40132 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab0DWENS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 00:13:18 -0400
X-Authority-Analysis: v=1.1 cv=mJ2XtCV6gem0td6545d6o4z3SC3BoM2bxxOQ2/EEFjA= c=1 sm=0 a=IkcTkHD0fZMA:10 a=Ojb4KS2nAQbJgCTPCAnicg==:17 a=QqsSVKQqVVKoaNuzjYEA:9 a=ER_NAlhsyLYnRcv1awmPt5tMimsA:4 a=QEXdDO2ut3YA:10 a=Ojb4KS2nAQbJgCTPCAnicg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.121.210.183
Subject: Re: readahead on directories
From: Phillip Susi <psusi@cfl.rr.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: linux-fsdevel@vger.kernel.org, Linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100422224327.GE13951@shareable.org>
References: <20100421161211.GC27575@shareable.org>
	 <4BCF3FAE.7090206@cfl.rr.com> <20100421202209.GV27575@shareable.org>
	 <4BCF6731.1070404@cfl.rr.com> <20100421220612.GD27575@shareable.org>
	 <4BD05C9C.9020101@cfl.rr.com> <20100422175322.GE6265@shareable.org>
	 <4BD0A24B.4060209@cfl.rr.com> <20100422203555.GA13951@shareable.org>
	 <4BD0BE20.4030908@cfl.rr.com>  <20100422224327.GE13951@shareable.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Apr 2010 00:13:15 -0400
Message-ID: <1271995995.2855.48.camel@faldara>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-22 at 23:43 +0100, Jamie Lokier wrote:
> No, that is not the reason.  pwrite needs the mutex too.

Which mutex and what for?

> Now you are describing using threads in the blocking cases.  (Work
> queues, thread pools, same thing.)  Earlier you were saying threads
> are the wrong approach....  Good, good :-)

Sure, in some cases, just not ALL.  If you can't control whether or not
the call blocks then you HAVE to use threads.  If you can be sure it
won't block most of the time, then most of the time you don't need any
other threads, and when you finally do, you need very few.

> A big problem with it, apart from having to change lots of places in
> all the filesystems, is that the work-queues run with the wrong
> security and I/O context.  Network filesystems break permissions, quotas
> break, ionice doesn't work, etc.  It's obviously fixable but more
> involved than just putting a read request on a work queue.

Hrm... good point.

> Fine-grained locking isn't the same thing as using non-sleepable locks.

Yes, it is not the same, but non-sleepable locks can ONLY be used with
fine grained locks.  The two reasons to use a mutex instead of a spin
lock are that you can sleep while holding it, and so it isn't a problem
to hold it for an extended period of time.

> So is read().  And then the calling application usually exits, because
> there's nothing else it can do usefully.  Same if aio_read() ever returns ENOMEM.
> 
> That way lies an application getting ENOMEM often and having to retry
> aio_read in a loop, probably a busy one, which isn't how the interface
> is supposed to work, and is not efficient either.

Simply retrying in a loop would be very stupid.  The programs using aio
are not simple stupid, so they would take more appropriate action.  For
example a server might decide it already has enough data in the pipe and
forget about asking for more until the queues empty, or it might decide
to drop that client, which would free up some more memory, or it might
decide it has some cache it can free up.  Something like readahead could
decide that if there isn't enough memory left then it has no business
trying to read any more, and exit.  Both of these are preferable to
waiting for something else to free up enough memory to continue.


