Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab2IGT3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:29:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33233 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508Ab2IGT3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:29:43 -0400
Date: Fri, 7 Sep 2012 12:29:39 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH wq/for-3.6-fixes 3/3] workqueue: fix possible idle
 worker depletion during CPU_ONLINE
Message-ID: <20120907192939.GF9426@google.com>
References: <20120906200647.GG29092@google.com>
 <20120906200723.GH29092@google.com>
 <20120906200802.GI29092@google.com>
 <504965AA.6090107@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504965AA.6090107@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 07, 2012 at 11:10:34AM +0800, Lai Jiangshan wrote:
> > This patch fixes the bug by releasing manager_mutexes before letting
> > the rebound idle workers go.  This ensures that by the time idle
> > workers check whether management is necessary, CPU_ONLINE already has
> > released the positions.
> 
> Could you review manage_workers_slowpath() in V4 patchset.
> It has enough changelog and comments.
> 
> After the discussion,
> 
> We don't move the hotplug code outside hotplug code. it matches this requirement.

Was that the one which deferred calling manager function to a work
item on trylock failure?

> Since we introduce manage_mutex(), any palace should be allowed to grab it
> when its context allows. So it is not hotplug code's responsibility of this bug.
> 
> manage_workers() just use mutex_trylock() to grab the lock, it does not make
> hard to do it jobs when need, and it does not try to find out the reason of fail.
> so I think it is manage_workers()'s responsibility to handle this bug.
> a manage_workers_slowpath() is enough to fix the bug.

It doesn't really matter how the synchronization between regular
manager and hotplug path is done.  The point is that hotplug path, as
much as possible, should be responsible for any incurred complexities,
so I'd really like to stay away from adding a completely different
path manager can be invoked in the usual path if at all possible.
Let's try to solve this from the hotplug side.

Thanks.

-- 
tejun
