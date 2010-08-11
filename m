Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab0HKQTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 12:19:53 -0400
Received: from smtpauth01.csee.onr.siteprotect.com ([64.26.60.145]:58296 "EHLO
	smtpauth01.csee.onr.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752537Ab0HKQTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 12:19:52 -0400
From: "Rob Donovan" <rob@proivrc.com>
To: "'Chris Friesen'" <chris.friesen@genband.com>
Cc: <linux-kernel@vger.kernel.org>
References: <013501cb372f$912ce420$b386ac60$@proivrc.com> <4C607608.8080305@genband.com>
In-Reply-To: <4C607608.8080305@genband.com>
Subject: RE: FCNTL Performance problem
Date: Wed, 11 Aug 2010 17:19:48 +0100
Message-ID: <001d01cb3971$0677e700$1367b500$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acs4C7v+nLx4zqNcRJm8NfixaoFsJQBLCXCQ
Content-Language: en-gb
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020207.4C62CDA7.0248,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Not sure it's about read or write 'priority' so much is it?

I wouldn't want to particularly favour writes over reads either, or it will
just make the problem happen for reads wouldn't it?

And to do this, and make it favour writes, I presume it would have to be
coded into the kernel to do this, there isn't any 'switch' for me to try?

Could we not have it 'fairly' process locks? So that if a read lock comes
along, and there is a write lock waiting for another read lock to unlock,
then the 2nd read has to wait for the write lock. Not particularly because
the write lock has priority, but because it was requested after the write
lock was.

In my example, if you run 15 of the read process, the write process never
gets the chance to lock, ever, as its continually blocked by 1 or more of
the reads.

Running 15 of the read processes is much more load than our real system
gets, so we don't get writes blocked totally like that, but they can block
for 10 or more seconds sometimes. Which is quite excessive for 1 write.

To me, it seems like there needs to be something in the fcntl() routines so
that when a lock is called with F_SETLKW, if it gets blocked then it needs
to put its 'request' in some kind of queue, so that if any more reads come
along, they know there is already a lock waiting to get the lock before it,
so they queue up behind it. 

Or is that kind of checking / queuing going to slow down the calls to much,
maybe?

Example of what is happening in my test:

Process 1, creates a read lock
Process 2, tries to create a write wait lock, but cant because of process 1,
so it sleeps.
Process 3, creates a read lock (since nothing is blocking this) 
Process 1, unlocks and wakes up any waiting locks, i.e. the write lock
process 2.
Process 2, gets waken up, and tries to lock, but cant because of process 3
read lock, so sleeps again.
Process 4, creates a read lock (since nothing is blocking this)
Process 3, unlocks and wakes up any waiting locks, i.e. the write lock
process 2.
Process 2, gets waken up, and tries to lock, but cant because of process 4
read lock, so sleeps again.
Process 5, creates a read lock....

This can go on and on until the write lock becomes 'lucky' enough to get
waken up when just when the last read lock gets unlocked and before another
read lock starts. Then it can get its lock.

We moved to RHEL5 recently (from Tru64) and we have massive problems with
fcntl calls, because of the way RHEL5 does its BKL. The more read fcntl
calls the system got the slower the fcntl syscall became, globally. We're
now testing RHEL6 beta which has changes to the BKL (spin-locks vs
semaphores I believe), and now the read fcntl calls are much quicker and
don't effect each other so much, which I think has caused this 'write' locks
problem for us. Because now we get lots more fcntl read locks as they are
quicker. (However, I'm still testing this with systemtap to 'prove' it)

I don't think I can start writing my own lock objects :) .... We are using
CISAM from IBM, and don't actually have control of the FCNTL calls.

Rob.

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org
[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Chris Friesen
Sent: 09 August 2010 22:41
To: Rob Donovan
Cc: linux-kernel@vger.kernel.org
Subject: Re: FCNTL Performance problem

On 08/08/2010 01:26 PM, Rob Donovan wrote:


> The problem is, when you have lots of F_RDLCK locks being created and
> released, then it slows down any F_WRLCK with F_SETLKW locks massively.

> Is there anything that can possibly be done in the kernel to help this, as
I
> would have thought this could cause problems with other people?
> 
> One possible solution would be that when the write lock tries to get a
lock
> and cant, its actually puts its lock in a queue of some kind, so that the
> other reads that are about to start can see that, and they 'queue' and
wait
> for the write lock first.. I'm obviously not a kernel coder, so I have no
> idea of the effects of something like that, hence this post. 

What you're seeing is classical "reader priority" behaviour.  The
alternative is "writer priority".  I don't think POSIX specifies which
behaviour to use, so it's up to the various implementations.

If you really need writer priority, how about building your own lock
object in userspace on top of fcntl locks?

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

