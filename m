Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab0HKRCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 13:02:10 -0400
Received: from exprod7og114.obsmtp.com ([64.18.2.215]:39276 "EHLO
	exprod7og114.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab0HKRCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 13:02:04 -0400
Message-ID: <4C62D73E.6090302@genband.com>
Date: Wed, 11 Aug 2010 11:00:46 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Rob Donovan <rob@proivrc.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: FCNTL Performance problem
References: <013501cb372f$912ce420$b386ac60$@proivrc.com> <4C607608.8080305@genband.com> <001d01cb3971$0677e700$1367b500$@com>
In-Reply-To: <001d01cb3971$0677e700$1367b500$@com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Aug 2010 17:00:48.0294 (UTC) FILETIME=[BEF67C60:01CB3976]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-17564.000
X-TM-AS-Result: No--18.491800-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2010 10:19 AM, Rob Donovan wrote:
> Hi,
> 
> Not sure it's about read or write 'priority' so much is it?
> 
> I wouldn't want to particularly favour writes over reads either, or it will
> just make the problem happen for reads wouldn't it?

No, because readers can always share the lock with other readers if
there is no writer waiting.

If you have one or more readers already holding the lock, with a writer
waiting, you have two choices:  1) let the new reader in under the
assumption that they'll be quick and won't extend the current "read"
usage by much, or 2) block the new reader until after any waiting
writers get a chance to get in.  The first is called reader priority,
the second is writer priority.

> And to do this, and make it favour writes, I presume it would have to be
> coded into the kernel to do this, there isn't any 'switch' for me to try?

The locks are written by glibc and the kernel.  I haven't looked at
fcntl locking so I'm not sure where the bulk of the code is.  I'd
suspect in the kernel.

> Could we not have it 'fairly' process locks? So that if a read lock comes
> along, and there is a write lock waiting for another read lock to unlock,
> then the 2nd read has to wait for the write lock. Not particularly because
> the write lock has priority, but because it was requested after the write
> lock was.

The behaviour you describe is called "writer priority".

> To me, it seems like there needs to be something in the fcntl() routines so
> that when a lock is called with F_SETLKW, if it gets blocked then it needs
> to put its 'request' in some kind of queue, so that if any more reads come
> along, they know there is already a lock waiting to get the lock before it,
> so they queue up behind it. 

Again, this would be implementing writer priority.

POSIX doesn't guarantee either form, so if you need a writer-priority
lock then fcntl() isn't a good choice.  In fact in most cases I suspect
you'll find that read/write locks are implemented as reader priority
since the expectation is that writes are infrequent.

Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
