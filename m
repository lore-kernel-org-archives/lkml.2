Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760182Ab2IFBxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 21:53:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:27975 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752979Ab2IFBxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 21:53:32 -0400
X-IronPort-AV: E=Sophos;i="4.80,377,1344182400"; 
   d="scan'208";a="5791587"
Message-ID: <50480286.4010405@cn.fujitsu.com>
Date: Thu, 06 Sep 2012 09:55:18 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10 V4] workqueue: add manage_workers_slowpath()
References: <1346516916-1991-1-git-send-email-laijs@cn.fujitsu.com> <1346516916-1991-5-git-send-email-laijs@cn.fujitsu.com> <20120905011235.GC2836@dhcp-172-17-108-109.mtv.corp.google.com>
In-Reply-To: <20120905011235.GC2836@dhcp-172-17-108-109.mtv.corp.google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/06 09:53:07,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/06 09:53:07,
	Serialize complete at 2012/09/06 09:53:07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2012 09:12 AM, Tejun Heo wrote:
> Hello, Lai.
> 
> On Sun, Sep 02, 2012 at 12:28:22AM +0800, Lai Jiangshan wrote:
>> If hotplug code grabbed the manager_mutex and worker_thread try to create
>> a worker, the manage_worker() will return false and worker_thread go to
>> process work items. Now, on the CPU, all workers are processing work items,
>> no idle_worker left/ready for managing. It breaks the concept of workqueue
>> and it is bug.
>>
>> So when manage_worker() failed to grab the manager_mutex, it should
>> try to enter normal process contex and then compete on the manager_mutex
>> instead of return false.
>>
>> To safely do this, we add manage_workers_slowpath() and the worker
>> go to process work items mode to do the managing jobs. thus
>> managing jobs are processed via work item and can free to compete
>> on manager_mutex.
> 
> Ummm.... this seems overly complicated.  How about scheduling rebind
> work to a worker and forcing it to break out of the work processing
> loop?  I think it can be done fairly easily using POOL_MANAGE_WORKERS
> - set it from the rebind function, break out of work processing loop
> if it's set, replace need_to_manage_workers() with POOL_MANAGE_WORKERS
> test (the function really isn't necessary) and always jump back to
> recheck afterwards.  It might need a bit more mangling here and there
> but that should be the essence of it.  I'll give a stab at it later
> today.
> 

This approach is a little like my unsent approach3.(I will explain in other mail)
This approach is most complicated and changing more code if it is implemented.

First we should rebind/unbind separated by pool. because,
	if we queue the rebind-work to high-pri pool, we will break normal-pool
	vice versa

and this forces us move DISASSOCIATED to pool-flags.
and this forces us add more code in cpu-notify

second, reuse POOL_MANAGE_WORKERS, or add new one.

third, need to restruct of rebind/unbind and change a lot in worker_thread.

my partial/unsent approach3 has almost the same problem.
(different, my approach3 don't use work item, it is checked and called from
the "recheck" label of worker_thread. it is called with WORKER_PREP bit set
and it uses "mutex_trylock" to grab lock like manage_workers())

how much code will be changed for only unbind part of this approach:


 kernel/workqueue.c |  103 ++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 76 insertions(+), 27 deletions(-)


Thanks
Lai
