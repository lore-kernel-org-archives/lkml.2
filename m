Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443Ab2IGDJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 23:09:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:13219 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759320Ab2IGDIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 23:08:47 -0400
X-IronPort-AV: E=Sophos;i="4.80,384,1344182400"; 
   d="scan'208";a="5799915"
Message-ID: <504965AA.6090107@cn.fujitsu.com>
Date: Fri, 07 Sep 2012 11:10:34 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH wq/for-3.6-fixes 3/3] workqueue: fix possible idle worker
 depletion during CPU_ONLINE
References: <20120906200647.GG29092@google.com> <20120906200723.GH29092@google.com> <20120906200802.GI29092@google.com>
In-Reply-To: <20120906200802.GI29092@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/07 11:08:20,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/07 11:08:20,
	Serialize complete at 2012/09/07 11:08:20
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2012 04:08 AM, Tejun Heo wrote:
>>From 985aafbf530834a9ab16348300adc7cbf35aab76 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Thu, 6 Sep 2012 12:50:41 -0700
> 
> To simplify both normal and CPU hotplug paths, while CPU hotplug is in
> progress, manager_mutex is held to prevent one of the workers from
> becoming a manager and creating or destroying workers; unfortunately,
> it currently may lead to idle worker depletion which in turn can lead
> to deadlock under extreme circumstances.
> 
> Idle workers aren't allowed to become busy if there's no other idle
> worker left to create more idle workers, but during CPU_ONLINE
> gcwq_associate() is holding all managerships and all the idle workers
> can proceed to become busy before gcwq_associate() is finished.
> 
> This patch fixes the bug by releasing manager_mutexes before letting
> the rebound idle workers go.  This ensures that by the time idle
> workers check whether management is necessary, CPU_ONLINE already has
> released the positions.
> 

Could you review manage_workers_slowpath() in V4 patchset.
It has enough changelog and comments.

After the discussion,

We don't move the hotplug code outside hotplug code. it matches this requirement.

Since we introduce manage_mutex(), any palace should be allowed to grab it
when its context allows. So it is not hotplug code's responsibility of this bug.

manage_workers() just use mutex_trylock() to grab the lock, it does not make
hard to do it jobs when need, and it does not try to find out the reason of fail.
so I think it is manage_workers()'s responsibility to handle this bug.
a manage_workers_slowpath() is enough to fix the bug.

=====
manage_workers_slowpath() just adds a little overhead over manage_workers(),
so we can use manage_workers_slowpath() to replace manage_workers(), thus we
can reduce the code of manage_workers() and we can do more cleanup for manage.

Thanks,
Lai
