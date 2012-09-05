Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab2IEBMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 21:12:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40266 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab2IEBMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 21:12:39 -0400
Date: Tue, 4 Sep 2012 18:12:35 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10 V4] workqueue: add manage_workers_slowpath()
Message-ID: <20120905011235.GC2836@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346516916-1991-1-git-send-email-laijs@cn.fujitsu.com>
 <1346516916-1991-5-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346516916-1991-5-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Sun, Sep 02, 2012 at 12:28:22AM +0800, Lai Jiangshan wrote:
> If hotplug code grabbed the manager_mutex and worker_thread try to create
> a worker, the manage_worker() will return false and worker_thread go to
> process work items. Now, on the CPU, all workers are processing work items,
> no idle_worker left/ready for managing. It breaks the concept of workqueue
> and it is bug.
> 
> So when manage_worker() failed to grab the manager_mutex, it should
> try to enter normal process contex and then compete on the manager_mutex
> instead of return false.
> 
> To safely do this, we add manage_workers_slowpath() and the worker
> go to process work items mode to do the managing jobs. thus
> managing jobs are processed via work item and can free to compete
> on manager_mutex.

Ummm.... this seems overly complicated.  How about scheduling rebind
work to a worker and forcing it to break out of the work processing
loop?  I think it can be done fairly easily using POOL_MANAGE_WORKERS
- set it from the rebind function, break out of work processing loop
if it's set, replace need_to_manage_workers() with POOL_MANAGE_WORKERS
test (the function really isn't necessary) and always jump back to
recheck afterwards.  It might need a bit more mangling here and there
but that should be the essence of it.  I'll give a stab at it later
today.

Thanks.

-- 
tejun
