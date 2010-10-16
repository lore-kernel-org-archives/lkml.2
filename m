Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab0JPKE4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 06:04:56 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:32906 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751266Ab0JPKEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 06:04:55 -0400
Date: Sat, 16 Oct 2010 21:04:41 +1100
From: Dave Chinner <david@fromorbit.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/19] fs: Convert nr_inodes and nr_unused to per-cpu
 counters
Message-ID: <20101016100441.GP4681@dastard>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
 <1287216853-17634-4-git-send-email-david@fromorbit.com>
 <1287217776.2799.69.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1287217776.2799.69.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 10:29:36AM +0200, Eric Dumazet wrote:
> Le samedi 16 octobre 2010 à 19:13 +1100, Dave Chinner a écrit :
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The number of inodes allocated does not need to be tied to the
> > addition or removal of an inode to/from a list. If we are not tied
> > to a list lock, we could update the counters when inodes are
> > initialised or destroyed, but to do that we need to convert the
> > counters to be per-cpu (i.e. independent of a lock). This means that
> > we have the freedom to change the list/locking implementation
> > without needing to care about the counters.
> > 
> > Based on a patch originally from Eric Dumazet.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> 
> NACK
> 
> Some people believe percpu_counter object is the right answer to such
> distributed counters, because the loop is done on 'online' cpus instead
> of 'possible' cpus. "It must be better if number of possible cpus is
> 4096 and only one or two cpus are online"...
> 
> But if we do this loop only on rare events, like
> "cat /proc/sys/fs/inode-nr", then the percpu_counter() is more
> expensive, because percpu_add() _is_ more expensive :
> 
> - Its a function call and lot of instructions/cycles per call, while
> this_cpu_inc(nr_inodes) is a single instruction, using no register on
> x86.
> 
> - Its possibly accessing a shared spinlock and counter when the percpu
> counter reaches the batch limit.
> 
> 
> To recap : nr_inodes is not a counter that needs to be estimated in real
> time, since we have not limit on number of inodes in the machine (limit
> is the memory allocator).
> 
> Unless someone can prove "cat /proc/sys/fs/inode-nr" must be performed
> thousand of times per second on their setup, the choice I made to scale
> nr_inodes is better over the 'obvious percpu_counter choice'

get_nr_inodes_unused() is called on every single shrinker call. i.e.
for every 128 inodes we attempt to reclaim. Given that I'm seeing
inode reclaim rate in the order of a million per second on a 8p box,
that meets your criteria for using the generic percpu counter
infrastructure.

Also, get_nr_inodes() is also called by get_nr_dirty_inodes(), which is
called by the high level inode writeback code, so will typically be
called in the order of tens of times per second, and the number of
calls increased depending on the number of filesystems that are
active. It's still much higher frequency than your "cat
/proc/sys/fs/inode-nr" example indicates it might be called.

So I'd say that by your reasoning, the choice of using the generic
percpu counters is the right one to make.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
