Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab1LSGIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 01:08:51 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:59971 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab1LSGI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 01:08:27 -0500
Message-ID: <1324274866.25089.32.camel@mengcong>
Subject: Re: [PATCH] VFS: br_write_lock locks on possible CPUs other than
 online CPUs
From: mengcong <mc@linux.vnet.ibm.com>
Reply-To: mc@linux.vnet.ibm.com
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, Dave Chinner <david@fromorbit.com>
Date: Mon, 19 Dec 2011 14:07:46 +0800
In-Reply-To: <20111219050037.GO23662@dastard>
References: <1324265775.25089.20.camel@mengcong>
	 <20111219041142.GH2203@ZenIV.linux.org.uk> <20111219050037.GO23662@dastard>
Organization: LTC, IBM
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11121819-5490-0000-0000-0000005E36F9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-19 at 16:00 +1100, Dave Chinner wrote:
> On Mon, Dec 19, 2011 at 04:11:42AM +0000, Al Viro wrote:
> > On Mon, Dec 19, 2011 at 11:36:15AM +0800, mengcong wrote:
> > > In a heavily loaded system, when frequently turning on and off CPUs, the
> > > kernel will detect soft-lockups on multiple CPUs. The detailed bug report
> > > is at https://lkml.org/lkml/2011/8/24/185.
> > > 
> > > The root cause is that brlock functions, i.e. br_write_lock() and
> > > br_write_unlock(), only locks/unlocks the per-CPU spinlock of CPUs that
> > > are online, which means, if one online CPU is locked and then goes
> > > offline, any later unlocking operation happens during its offline state
> > > will not touch it; and when it goes online again, it has the incorrect
> > > brlock state. This has been verified in current kernel.
> > > 
> > > I can reproduce this bug on the intact 3.1 kernel. After my patch applied, 
> > > I've ran an 8-hours long test(test script provided by the bug reporter), 
> > > and no soft lockup happened again.
> > 
> > Argh...  OK, that's seriously nasty.  I agree that this is broken, but
> > your patch makes br_write_lock() very costly on kernels build with
> > huge number of possible CPUs, even when it's run on a box with few
> > CPUs ;-/
> 
> I fixed this problem with the XFS per-cpu superblock counters
> (bit lock + counters in per-cpu structs) back in 2006. It basically
> uses a lglock-like local/global locking structure and iterates them
> using for_each_online_cpu().
> 
> I fixed it simply by registering a hotplug notifier and
> draining/reinitialising counters on the appropriate event under a
> global lock context. i.e. make CPU hotplug serialise against
> concurrent lock operations. See commit e8234a68 ("[XFS] Add support
> for hotplug CPUs...")
> 

how about to register a cpu hotplug notifier to align the brlock as what
Dave did?

> Cheers,
> 
> Dave.


