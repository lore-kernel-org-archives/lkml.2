Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab2H3JO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 05:14:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:32534 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751359Ab2H3JOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 05:14:25 -0400
X-IronPort-AV: E=Sophos;i="4.80,339,1344182400"; 
   d="scan'208";a="5754379"
Message-ID: <503F2F51.8000301@cn.fujitsu.com>
Date: Thu, 30 Aug 2012 17:16:01 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9 V3] workqueue: add non_manager_role_manager_mutex_unlock()
References: <1346259120-6216-1-git-send-email-laijs@cn.fujitsu.com> <1346259120-6216-5-git-send-email-laijs@cn.fujitsu.com> <20120829182510.GB2258@dhcp-172-17-108-109.mtv.corp.google.com>
In-Reply-To: <20120829182510.GB2258@dhcp-172-17-108-109.mtv.corp.google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/30 17:14:10,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/30 17:14:10,
	Serialize complete at 2012/08/30 17:14:10
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2012 02:25 AM, Tejun Heo wrote:
> On Thu, Aug 30, 2012 at 12:51:55AM +0800, Lai Jiangshan wrote:
>> If hotplug code grabbed the manager_mutex and worker_thread try to create
>> a worker, the manage_worker() will return false and worker_thread go to
>> process work items. Now, on the CPU, all workers are processing work items,
>> no idle_worker left/ready for managing. It breaks the concept of workqueue
>> and it is bug.
>>
>> So when this case happens, the last idle should not go to process work,
>> it should go to sleep as usual and wait normal events. but it should
>> also be notified by the event that hotplug code release the manager_mutex.
>>
>> So we add non_manager_role_manager_mutex_unlock() to do this notify.
> 
> Hmmm... how about just running rebind_workers() from a work item?
> That way, it would be guaranteed that there alwyas will be an extra
> worker available on rebind completion.
> 
> Thanks.
> 

gcwq_unbind_fn() is unsafe even it is called from a work item.
so we need non_manager_role_manager_mutex_unlock().

If rebind_workers() is called from a work item, it is safe when there is
no CPU_INTENSIVE items. but we can't disable CPU_INTENSIVE items,
so it is still unsafe, we need non_manager_role_manager_mutex_unlock() too.

non_manager_role_manager_mutex_unlock() approach is good to fix it.
I'm writing V4 patch/approach to fix it too, it is a little more complicated,
but it has some benefit over non_manager_role_manager_mutex_unlock() approach.

Thanks.
Lai
