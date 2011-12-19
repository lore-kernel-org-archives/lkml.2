Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204Ab1LSFAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 00:00:45 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:40804 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750713Ab1LSFAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 00:00:42 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EABHC7k55LOCn/2dsb2JhbAA7CKtagQaBcgEBBTocIxAIAxguFCUDIROIArZdBBOIO4M2BJR9iRuJKA
Date: Mon, 19 Dec 2011 16:00:38 +1100
From: Dave Chinner <david@fromorbit.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: mengcong <mc@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH] VFS: br_write_lock locks on possible CPUs other than
 online CPUs
Message-ID: <20111219050037.GO23662@dastard>
References: <1324265775.25089.20.camel@mengcong>
 <20111219041142.GH2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111219041142.GH2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 04:11:42AM +0000, Al Viro wrote:
> On Mon, Dec 19, 2011 at 11:36:15AM +0800, mengcong wrote:
> > In a heavily loaded system, when frequently turning on and off CPUs, the
> > kernel will detect soft-lockups on multiple CPUs. The detailed bug report
> > is at https://lkml.org/lkml/2011/8/24/185.
> > 
> > The root cause is that brlock functions, i.e. br_write_lock() and
> > br_write_unlock(), only locks/unlocks the per-CPU spinlock of CPUs that
> > are online, which means, if one online CPU is locked and then goes
> > offline, any later unlocking operation happens during its offline state
> > will not touch it; and when it goes online again, it has the incorrect
> > brlock state. This has been verified in current kernel.
> > 
> > I can reproduce this bug on the intact 3.1 kernel. After my patch applied, 
> > I've ran an 8-hours long test(test script provided by the bug reporter), 
> > and no soft lockup happened again.
> 
> Argh...  OK, that's seriously nasty.  I agree that this is broken, but
> your patch makes br_write_lock() very costly on kernels build with
> huge number of possible CPUs, even when it's run on a box with few
> CPUs ;-/

I fixed this problem with the XFS per-cpu superblock counters
(bit lock + counters in per-cpu structs) back in 2006. It basically
uses a lglock-like local/global locking structure and iterates them
using for_each_online_cpu().

I fixed it simply by registering a hotplug notifier and
draining/reinitialising counters on the appropriate event under a
global lock context. i.e. make CPU hotplug serialise against
concurrent lock operations. See commit e8234a68 ("[XFS] Add support
for hotplug CPUs...")

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
