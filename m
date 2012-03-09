Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255Ab2CIAvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 19:51:25 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:45860 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752115Ab2CIAvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 19:51:24 -0500
Date: Thu, 8 Mar 2012 16:51:18 -0800
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
Message-ID: <20120309005118.GC2968@htj.dyndns.org>
References: <1330648393-20692-1-git-send-email-msb@chromium.org>
 <Pine.LNX.4.64.1203031340340.10937@file.rdu.redhat.com>
 <20120306215947.GB27051@google.com>
 <Pine.LNX.4.64.1203081656590.31821@file.rdu.redhat.com>
 <20120308143909.bfc4cb4d.akpm@linux-foundation.org>
 <20120308231521.GA2968@htj.dyndns.org>
 <20120308153048.4a80de34.akpm@linux-foundation.org>
 <20120309003309.GB2968@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120309003309.GB2968@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding a bit..

On Thu, Mar 08, 2012 at 04:33:09PM -0800, Tejun Heo wrote:
> ISTR there was something already broken about having specific CPU
> assumption w/ workqueue even before cmwq when using queue_work_on()
> unless it was explicitly synchronizing using cpu hotplug callback.
> Hmmm... what was it... I think it was that there was no protection
> against queueing on workqueue on dead CPU and workqueue was flushed
> only once during cpu shutdown meaning that queue_work_on() or
> requeueing work items could end up queued on a workqueue of a dead
> CPU.

I think the crux of the problem is that we didn't have the interface
to indicate the intention of workqueue users.  Per-cpu workqueues were
the normal ones and the per-cpuness is used both as optimization
(local queueing is much cheaper and a work item is likely to access
the same stuff its queuer was accessing) and pinning.  Single-threaded
workqueues were used for both non-reentrancy and resource
optimization.

For the short term, the easiest fix would be adding flush_work_sync()
from cpu hotplug callback for the pinned ones.  For the longer term, I
think the most natural fix would be making work items queued with
explicit queue_work_on() handled differently and adding debug code to
enforce it.

Thanks.

-- 
tejun
