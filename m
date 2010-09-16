Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab0IPTT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 15:19:59 -0400
Received: from DELFT.AURA.CS.CMU.EDU ([128.2.209.12]:34086 "EHLO
	delft.aura.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab0IPTT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 15:19:57 -0400
X-Greylist: delayed 1080 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Sep 2010 15:19:57 EDT
Date: Thu, 16 Sep 2010 15:00:25 -0400
From: Jan Harkes <jaharkes@cs.cmu.edu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Petr Vandrovec <vandrove@vc.cvut.cz>, Anders Larsen <al@alarsen.net>,
        Jan Kara <jack@suse.cz>, Evgeniy Dushistov <dushistov@mail.ru>,
        Ingo Molnar <mingo@elte.hu>, Samuel Ortiz <samuel@sortiz.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andrew Hendry <andrew.hendry@gmail.com>
Subject: Re: Remaining BKL users, what to do
Message-ID: <20100916190025.GG24296@cs.cmu.edu>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	Christoph Hellwig <hch@infradead.org>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Trond Myklebust <Trond.Myklebust@netapp.com>,
	Petr Vandrovec <vandrove@vc.cvut.cz>,
	Anders Larsen <al@alarsen.net>, Jan Kara <jack@suse.cz>,
	Evgeniy Dushistov <dushistov@mail.ru>, Ingo Molnar <mingo@elte.hu>,
	Samuel Ortiz <samuel@sortiz.org>,
	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Andrew Hendry <andrew.hendry@gmail.com>
References: <201009161632.59210.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009161632.59210.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 11:19:28AM -0400, Arnd Bergmann wrote:
> fs/coda:
> 	Coda seems to have an active community, but not all of their
> 	code is actually part of linux (pioctl!),

Probably more than 99% of the code is running in userspace. And that
isn't really pioctl related, a pioctl is simply an ioctl that can in a
somewhat cross-platform way operate not just on files, but also on
symlinks and directories because it is path based instead of fd based.

These path-ioctls are there for user commands on specific objects
visible in the filesystem, examining and repairing conflicts, forcing
cache refresh or prefetch, accessing extended information such as which
servers store a replica of the object.

Some of this could move to extended attributes, other things might work
without kernel involvement over a unix-domain socket, but the hard part
is that our userspace code is mostly identical across several systems
and such features aren't universally available.

> 	                                          while the last official
> 	release is missing many of the cleanups that were don in Linux.

And some of those might have broken at least mounting the Coda file
system. I haven't bisected yet, but I got a report that on a recent RC
kernel any attempt to start Coda caused some sort of lockup.

> 	Just removing the BKL without the Coda community seems like a heap
> 	of pointless work.

It depends, it might get rid of that mount lockup. There shouldn't be
too much shared state because the kernel module mostly just forwards
requests to userspace and the BKL right now seems to be mostly used to
protects access to the upcall lists and could probably without too much
trouble be replaced with a single 'global' (but Coda-only) or
mount-point specific mutex.

I have to figure out what broke mount first though.

Jan
