Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536Ab0IHIvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 04:51:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:43613 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758230Ab0IHIvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 04:51:33 -0400
Message-ID: <4C874E90.5040405@kernel.org>
Date: Wed, 08 Sep 2010 10:51:28 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [2.6.36-rc3] Workqueues, XFS, dependencies and deadlocks
References: <20100907072954.GM705@dastard> <4C86003B.6090706@kernel.org> <20100907100108.GN705@dastard> <4C861582.6080102@kernel.org> <4C862F8E.7030507@kernel.org> <20100908082249.GT705@dastard>
In-Reply-To: <20100908082249.GT705@dastard>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Sep 2010 08:51:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/08/2010 10:22 AM, Dave Chinner wrote:
> Ok, it looks as if the WQ_HIGHPRI is all that was required to avoid
> the log IO completion starvation livelocks. I haven't yet pulled
> the tree below, but I've now created about a billion inodes without
> seeing any evidence of the livelock occurring.
> 
> Hence it looks like I've been seeing two livelocks - one caused by
> the VM that Mel's patches fix, and one caused by the workqueue
> changeover that is fixed by the WQ_HIGHPRI change.
> 
> Thanks for you insights, Tejun - I'll push the workqueue change
> through the XFS tree to Linus.

Great, BTW, I have several questions regarding wq usage in xfs.

* Do you think @max_active > 1 could be useful for xfs?  If most works
  queued on the wq are gonna contend for the same (blocking) set of
  resources, it would just make more threads sleeping on those
  resources but otherwise it would help reducing execution latency a
  lot.

* xfs_mru_cache is a singlethread workqueue.  Do you specifically need
  singlethreadedness (strict ordering of works) or is it just to avoid
  creating dedicated per-cpu workers?  If the latter, there's no need
  to use singlethread one anymore.

* Are all four workqueues in xfs used during memory allocation?  With
  the new implementation, the reasons to have dedicated wqs are,

  - Forward progress guarantee in the memory allocation path.  Each
    workqueue w/ WQ_RESCUER has _one_ rescuer thread reserved for
    execution of works on the specific wq, which will be used under
    memory pressure to make forward progress.

  - A wq is a flush domain.  You can flush works on it as a group.

  - A wq is also a attribute domain.  If certain work items need to be
    handled differently (highpri, cpu intensive, execution ordering,
    etc...), they can be queued to a wq w/ those attributes specified.

  Maybe some of those workqueues can drop WQ_RESCUER or merged or just
  use the system workqueue?

Thanks.

-- 
tejun
