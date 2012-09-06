Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102Ab2IFKnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 06:43:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:27194 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756917Ab2IFKnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 06:43:08 -0400
X-IronPort-AV: E=Sophos;i="4.80,380,1344182400"; 
   d="scan'208";a="5796997"
Message-ID: <50487EA5.3060900@cn.fujitsu.com>
Date: Thu, 06 Sep 2012 18:44:53 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/11 V5] workqueue: unbind/rebind without manager_mutex
References: <1346841475-4422-1-git-send-email-laijs@cn.fujitsu.com> <1346841475-4422-11-git-send-email-laijs@cn.fujitsu.com> <20120905200411.GD13737@google.com>
In-Reply-To: <20120905200411.GD13737@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/06 18:42:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/06 18:42:41,
	Serialize complete at 2012/09/06 18:42:41
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 04:04 AM, Tejun Heo wrote:
> Hello, Lai.
> 
> On Wed, Sep 05, 2012 at 06:37:47PM +0800, Lai Jiangshan wrote:
>> gcwq_unbind_fn() unbind manager by ->manager pointer.
>>
>> rebinding-manger, unbinding/rebinding newly created worker are done by
>> other place. so we don't need manager_mutex any more.
>>
>> Also change the comment of @bind accordingly.
> 
> Please don't scatter small prep patches like this.  Each piece in
> isolation doesn't make much sense to me and the patch descriptions
> don't help much.  Please collect the prep patches and explain in more
> detail.

There are 4 different tasks. unbind/rebind manager/newbie

1 task for 1 patch. if I collect them into one patch, it will be hard
to explain which code do which task.

> 
> In general, I'm not sure about this approach.  I'd really like the
> hotplug logic to be contained in hotplug logic proper as much as
> possible.  This scatters around hotplug handling to usual code paths
> and seems too invasive for 3.6-fixes.

I don't expect to fix it in 3.6. no approach is simple.

> 
> Also, can you please talk to me before going ahead and sending me
> completely new 10 patch series every other day?  You're taking
> disproportionate amount of my time and I can't continue to do this.
> Please discuss with me or at least explain the high-level approach in
> the head message in detail.  Going through the patch series to figure
> out high-level design which is constantly flipping is rather
> inefficient and unfortunately your patch descriptions aren't too
> helpful.  :(
> 

I'm not good in English, so I prefer to attach code when I show my idea.
(and the code can prove the idea). I admit that my changelog and comments
are always bad.


I have 4 idea/approach for bug of hotplug VS manage_workers().
there all come up to my mind last week. 
NOTE: (this V5 patch is my approach2)

(list with the order they came into my mind)
Approach 1	V3 patchset		non_manager_role_manager_mutex_unlock()
Approach 2	V5 patchset		"rebind manager, unbind/rebind newbie" are done outside. no manage mutex for hotplug
Approach 3	un-implemented		move unbind/rebind to worker_thread and handle them as POOL_MANAGE_WORKERS
Approach 4	V4 parchset		manage_workers_slowpath()

Approach 2,3 is partial implemented last week, but Approach2 is quickly finished yesterday.
Approach 3 is too complicated to finish.


Approach 1: the simplest. after it, we can use manage_mutex anywhere as needed, but we need to use non_manager_role_manager_mutex_unlock() to unlock.

Approach 2: the binding of manager and newly created worker is handled outside of hotplug code. thus hoplug code don't need manage_mutex. manage_mutex is typical protect-code-pattern, it is not good. we should always use lock to protect data instead of protecting code. although in linux kernel, there are many lock which are only used for protecting code, I think we can reduce them as possible. the removing of BIG-KERNEL-LOCK is an example. the line of code is also less in this approach, but it touch 2 place outside of hotplug code and the logic/path are increasing. GOOD to me: disallow manage_mutex(for future), not too much code.

Approach 3: complicated. make unbind/rebind 's calle-site and context are the same as manage_workers(). BAD: we can't free to use manage_mutex in future when need. encounter some other problems.(you suggested approach will also have some problem I encountered)

Approach 4: the problem comes from manage_worker(), just add manage_workers_slowpath() to fix it inside manage_worker(). it fixs problem in only 1 bulk of code. after it, we can use manage_mutex anywhere as needed. the line of code is more, but it just in one place. GOOD: the most clean approach.

Thanks
Lai

