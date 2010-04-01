Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab0DAEPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 00:15:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:49622 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867Ab0DAEPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 00:15:07 -0400
Message-ID: <4BB41DAE.3010605@kernel.org>
Date: Thu, 01 Apr 2010 13:14:38 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Cong Wang <amwang@redhat.com>
CC: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Patch] workqueue: move lockdep annotations up to	destroy_workqueue()
References: <20100331105534.5601.50813.sendpatchset@localhost.localdomain> <20100331112559.GA17747@redhat.com> <4BB408AF.4080908@redhat.com> <4BB41988.1030400@kernel.org> <4BB41C72.3090909@redhat.com>
In-Reply-To: <4BB41C72.3090909@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 01 Apr 2010 04:14:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 04/01/2010 01:09 PM, Cong Wang wrote:
>> This seems to be from the original thread of frame#3.  It's grabbing
>> wq lock here but the problem is that the lock will be released
>> immediately, so bond_dev->name (the wq) can't be held by the time it
>> reaches frame#3.  How is this dependency chain completed?  Is it
>> somehow transitive through rtnl_mutex?
> 
> wq lock is held *after* cpu_add_remove_lock, lockdep also said this,
> the process is trying to hold wq lock while having cpu_add_remove_lock.

Yeah yeah, I'm just failing to see how the other direction is
completed.  ie. where does the kernel try to grab cpu_add_remove_lock
*after* grabbing wq lock?

>> Isn't there a circular dependency here?  bonding_exit() calls
>> destroy_workqueue() under rtnl_mutex but destroy_workqueue() should
>> flush works which could be trying to grab rtnl_lock.  Or am I
>> completely misunderstanding locking here?
> 
> Sure, that is why I sent another patch for bonding. :)

Ah... great.  :-)

> After this patch, another lockdep warning appears, it is exactly what
> you expect.

Hmmm... can you please try to see whether this circular locking
warning involving wq->lockdep_map is reproducible w/ the bonding
locking fixed?  I still can't see where wq -> cpu_add_remove_lock
dependency is created.

Thanks.

-- 
tejun
