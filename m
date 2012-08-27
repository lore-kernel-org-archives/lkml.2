Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab2H0SxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 14:53:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37991 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab2H0SxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 14:53:16 -0400
Date: Mon, 27 Aug 2012 11:53:12 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] workqueue: wait on manager_mutex instead of
 rebind_hold
Message-ID: <20120827185312.GA13094@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346090307-3020-1-git-send-email-laijs@cn.fujitsu.com>
 <1346090307-3020-2-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346090307-3020-2-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Tue, Aug 28, 2012 at 01:58:21AM +0800, Lai Jiangshan wrote:
>     this thread is finally scheduled,		  .
>     sees the WORKER_REBIND is not cleared,	  .
>     go to sleep again waiting for (another)	  .
>     rebind_workers() to wake up me.	<--bug->  waiting for the idles' ACK.
> 
> The two thread wait each other. It is bug.

Ooh, nice catch.  Has this actually happened in the wild?  Can you
reproduce it?

> This fix:
> The idle_worker_rebind() don't wait on rebind_hold, it waits on manager_mutex
> instead. When mutex_lock(manager_mutex) returns, the idles know that
> the corresponding rebind_workers() is finish up, the idle_worker_rebind() can
> returns.

Hmm... I can't really see how this change makes any difference tho.
While the exact wait condition changes, the mechanics doesn't.

	IDLE WORKER			HOTPLUG
					- online
	- rebind and kicks completion
	- wait on manager_mutex
					- finishes onlining
					- offline
					- online again, re-enters rebind_workers()
	- wakes up but blocked on
	  manager_mutex

So, we're just deadlocked on a different thing.  It seems what we need
is another interlocked step to make hotplug onlining wait for idle
worker finishes the last step, no?

Thanks.

-- 
tejun
