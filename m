Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab0DTNOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 09:14:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:47268 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509Ab0DTNOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 09:14:31 -0400
Date: Tue, 20 Apr 2010 06:14:20 -0700
From: Greg KH <gregkh@suse.de>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       WANG Cong <xiyou.wangcong@gmail.com>, Tejun Heo <tj@kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] sysfs: don't use allocated key for lockdep
Message-ID: <20100420131420.GA27126@suse.de>
References: <4BCD246F.4090005@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BCD246F.4090005@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 11:50:07AM +0800, Lai Jiangshan wrote:
> Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> The commit 6992f5334995af474c2b58d010d08bc597f0f2fe
> does wrong thing that use allocated key for lockdep_map.
> 
> Lockdep requires keys that are static:
> 
> lockdep_init_map() {
> ......
> 	/*
> 	 * Sanity check, the lock-class key must be persistent:
> 	 */
> 	if (!static_obj(key)) {
> 		printk("BUG: key %p not in .data!\n", key);
> 		DEBUG_LOCKS_WARN_ON(1);
> 		return;
> 	}
> 	lock->key = key;
> ......
> }
> 
> Could you please fix it.

All in-kernel attributes should now be fixed, so what exactly is the
remaining issue?

> ----------------
> One other comment (not relate to this bug, but relate to the commit):
> It is not a very good idea that use one lockdep class per sysfs attribute.
> 
> First: we don't have too much lockdep class resource.
> Second: lockdep validator is O(N*N) algorithm.
>         (N is the number of used lockdep class)
> 
> So it is recommended that use only one class for a group of locks.
> 
> For some nesting requirement, you can use
> lock_acquire(...,subclass,...nest_lock,...)
> 
> Or change the design.
> --------------------
> 
> BUG: key ffff880042c68220 not in .data!
> ------------[ cut here ]------------
> WARNING: at kernel/lockdep.c:2706 lockdep_init_map+0xe6/0x4fb()
> Hardware name: Lenovo WQ T168/T468 G6
> Modules linked in: mptsas(+) mptscsih mptbase scsi_transport_sas ext4 jbd2 crc16 uhci_hcd ohci_hcd ehci_hcd
> Pid: 1329, comm: modprobe Not tainted 2.6.34-rc3-22949-gbc8a97a-dirty #1

Please try 2.6.34-rc5 and let us know if this still shows up.

thanks,

greg k-h
