Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab1CPPul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 11:50:41 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:23103 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab1CPPuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 11:50:35 -0400
Date: Wed, 16 Mar 2011 10:50:33 -0500
From: scameron@beardog.cce.hp.com
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, axboe@kernel.dk, scameron@beardog.cce.hp.com, dab@hp.com,
        mike.miller@hp.com
Subject: Question about driver ioctl, big kernel lock, mutexes
Message-ID: <20110316155033.GQ12760@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I just noticed the existence of this change (I guess
I'm a little slow):

	commit 2a48fc0ab24241755dc93bfd4f01d68efab47f5a
	Author: Arnd Bergmann <arnd@arndb.de>
	Date:   Wed Jun 2 14:28:52 2010 +0200

	    block: autoconvert trivial BKL users to private mutex
	    
	    The block device drivers have all gained new lock_kernel
	    calls from a recent pushdown, and some of the drivers
	    were already using the BKL before.
	    
	    This turns the BKL into a set of per-driver mutexes.
	    Still need to check whether this is safe to do.

This changes the behavior of, for example, the CCISS_PASSTHRU and 
other ioctls.  Previously, these were "protected" by the Big
Kernel Lock.  Now, from what I understand and what I've observed,
the Big Kernel Lock is kind of strange, in that it auto-releases 
whenever you sleep.  This means that the ioctl path in cciss used
to allow concurrency (which is fine, they should all be thread
safe.  I'm kind of wondering why the BKL was there in the first
place.  I guess I assumed it was necessary for reasons having to
do with the upper layers.)  

Now, if I understand things correctly, with this new driver specific mutex
surrounding the ioctl path, only one thread is permitted in the ioctl path at a
time, and whether it sleeps or not, the mutex is not released until it's done.

That's a pretty big change in behavior.  Some commands sent through
the passthrough ioctls may take awhile, and they're going to block
any other ioctls from getting started while they're going.  Previously,
it was possible to saturate the controller using multiple threads or
processes hammering on the ioctl path.  This would appear to no longer
be the case.

That being said, there was previously no real limit (other than
pci_alloc_consistent eventually failing) on how many commands
could be shoved through the cciss ioctl path at once, which was probably
a bug.  It has occurred to me to put a limit on this, and return
-EBUSY when the limit is hit, though I don't know if programs using
the ioctl are prepared to receive EBUSY... but maybe that's not my
problem.

Thoughts?

I'm thinking that if there's no reason the ioctl path can't allow
concurrency, then it should allow concurrency.

-- steve




