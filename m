Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab1LSELr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 23:11:47 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:50779 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab1LSELo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 23:11:44 -0500
Date: Mon, 19 Dec 2011 04:11:42 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: mengcong <mc@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH] VFS: br_write_lock locks on possible CPUs other than
 online CPUs
Message-ID: <20111219041142.GH2203@ZenIV.linux.org.uk>
References: <1324265775.25089.20.camel@mengcong>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324265775.25089.20.camel@mengcong>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 11:36:15AM +0800, mengcong wrote:
> In a heavily loaded system, when frequently turning on and off CPUs, the
> kernel will detect soft-lockups on multiple CPUs. The detailed bug report
> is at https://lkml.org/lkml/2011/8/24/185.
> 
> The root cause is that brlock functions, i.e. br_write_lock() and
> br_write_unlock(), only locks/unlocks the per-CPU spinlock of CPUs that
> are online, which means, if one online CPU is locked and then goes
> offline, any later unlocking operation happens during its offline state
> will not touch it; and when it goes online again, it has the incorrect
> brlock state. This has been verified in current kernel.
> 
> I can reproduce this bug on the intact 3.1 kernel. After my patch applied, 
> I've ran an 8-hours long test(test script provided by the bug reporter), 
> and no soft lockup happened again.

Argh...  OK, that's seriously nasty.  I agree that this is broken, but
your patch makes br_write_lock() very costly on kernels build with
huge number of possible CPUs, even when it's run on a box with few
CPUs ;-/

That sucks.  Worse, AFAICS, the only way to prevent on-/off-line status
changes is blocking (and both directions are bad - if the thing goes online
between br_write_lock() and br_write_unlock(), we'll get spin_unlock without
spin_lock).  And I really don't want to make vfsmount_lock writers blocking -
we *probably* could get away with that, but it'll suck very badly.  Especially
since we'll have that nested inside namespace_sem...

Alternative is to do get_online_cpus/put_online_cpus around the stuff in
fs/namespace.c, putting it *outside* everything but actual IO.  We can
do that (since right now vfsmount_lock is non-blocking and the only
potentially blocking operations under namespace_sem is kmalloc()), but
I'm not particulary comfortable doing that - I never played with the code
in kernel/cpu.c and I don't know if there's anything subtle to watch out
for.

The same issue exists for lg_global_lock_online(), but that beast is
never used (and the only remaining user of lg_global_lock() is
hardly time-critical - with Miklos' patches it's only done on
mount -o remount,force,ro).

Nick, any comments?  That's your code...
