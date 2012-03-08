Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968Ab2CHXP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 18:15:28 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:61110 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753165Ab2CHXP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 18:15:27 -0500
Date: Thu, 8 Mar 2012 15:15:21 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>,
        Will Drewry <wad@chromium.org>, Elly Jones <ellyjones@chromium.org>,
        Milan Broz <mbroz@redhat.com>, Olof Johansson <olofj@chromium.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: workqueues and percpu (was: [PATCH] dm: remake of the verity
 target)
Message-ID: <20120308231521.GA2968@htj.dyndns.org>
References: <1330648393-20692-1-git-send-email-msb@chromium.org>
 <Pine.LNX.4.64.1203031340340.10937@file.rdu.redhat.com>
 <20120306215947.GB27051@google.com>
 <Pine.LNX.4.64.1203081656590.31821@file.rdu.redhat.com>
 <20120308143909.bfc4cb4d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308143909.bfc4cb4d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Mar 08, 2012 at 02:39:09PM -0800, Andrew Morton wrote:
> > I looked at it --- and using percpu variables in workqueues isn't safe 
> > because the workqueue can change CPU if the CPU is hot-unplugged.

Generally, I don't think removing preemption enable/disable around
percpu variable access is a worthwhile optimization unles it's on
really really really hot path.  We'll eventually add debug annotations
to percpu accessors and the ones used outside proper preemption
protections would need to be updated anyway.

> > dm-crypt has the same bug --- it also uses workqueue with per-cpu 
> > variables and assumes that the CPU doesn't change for a single work item.
> > 
> > This program shows that work executed in a workqueue can be switched to a 
> > different CPU.
> > 
> > I'm wondering how much other kernel code assumes that workqueues are bound 
> > to a specific CPU, which isn't true if we unplug that CPU.
> 
> ugh.
> 
> We really don't want to have to avoid using workqueues because of some
> daft issue with CPU hot-unplug.

Using or not using wq is orthogonal tho.  Using kthreads directly
requires hooking into CPU hotplug callbacks and one might as well call
flush_work_sync() from there instead of shutting down kthread.

> And yes, there are assumptions in various work handlers that they
> will be pinned to a single CPU.  Finding and fixing those
> assumptions would be painful.
>
> Heck, even debug_smp_processor_id() can be wrong in the presence of the
> cpu-unplug thing.

Yeah, that's a generic problem with cpu unplug.

> I'm not sure what we can do about it really, apart from blocking unplug
> until all the target CPU's workqueues have been cleared.  And/or refusing
> to unplug a CPU until all pinned-to-that-cpu kernel threads have been
> shut down or pinned elsewhere (which is the same thing, only more
> general).
> 
> Tejun, is this new behaviour?  I do recall that a long time ago we
> wrestled with unplug-vs-worker-threads and I ended up OK with the
> result, but I forget what it was.  IIRC Rusty was involved.

Unfortunately, yes, this is a new behavior.  Before, we could have
unbound delays during unplug from work items.  Now, we have CPU
affinity assumption breakage.  The behavior change was primarily to
allow long running work items to use regular workqueues without
worrying about inducing delay across cpu hotplug operations, which is
important as it's also used on suspend / hibernation, especially on
mobile platforms.

During the cmwq conversion, I ended up auditing a lot of (I think I
went through most of them) workqueue users and IIRC there weren't too
many which required stable affinity.

> That being said, I don't think it's worth compromising the DM code
> because of this workqueue wart: lots of other code has the same wart,
> and we should find a centralised fix for it.

Probably the best way to solve this is introducing pinned attribute to
workqueues and have them drained automatically on cpu hotplug events.
It'll require auditing workqueue users but I guess we'll just have to
do it given that we need to actually distinguish the ones need to be
pinned.  Or maybe we can use explicit queue_work_on() to distinguish
the ones which require pinning.

Another approach would be requiring all workqueues to be drained on
cpu offlining and requiring any work item which may stall to use
unbound wq.  IMHO, picking out the ones which may stall would be much
less obvious than the ones which require cpu pinning.

Better ideas?

Thanks.

-- 
tejun
