Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab0DTQJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 12:09:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:52659 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab0DTQJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 12:09:31 -0400
Date: Tue, 20 Apr 2010 18:09:27 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Greg KH <gregkh@suse.de>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       WANG Cong <xiyou.wangcong@gmail.com>, Tejun Heo <tj@kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] sysfs: don't use allocated key for lockdep
In-Reply-To: <20100420131420.GA27126@suse.de>
Message-ID: <alpine.LRH.2.00.1004201805480.28179@twin.jikos.cz>
References: <4BCD246F.4090005@cn.fujitsu.com> <20100420131420.GA27126@suse.de>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Apr 2010, Greg KH wrote:

> > lockdep_init_map() {
> > ......
> > 	/*
> > 	 * Sanity check, the lock-class key must be persistent:
> > 	 */
> > 	if (!static_obj(key)) {
> > 		printk("BUG: key %p not in .data!\n", key);
> > 		DEBUG_LOCKS_WARN_ON(1);
> > 		return;
> > 	}
> > 	lock->key = key;
> > ......
> > }
> > 
> > Could you please fix it.
> 
> All in-kernel attributes should now be fixed, so what exactly is the
> remaining issue?

Are they?

How about my fix to drivers/hwmon/asus_atk0110.c for example, I sent last 
week? http://lkml.org/lkml/2010/4/14/458

> > ----------------
> > One other comment (not relate to this bug, but relate to the commit):
> > It is not a very good idea that use one lockdep class per sysfs attribute.
> > 
> > First: we don't have too much lockdep class resource.
> > Second: lockdep validator is O(N*N) algorithm.
> >         (N is the number of used lockdep class)
> > 
> > So it is recommended that use only one class for a group of locks.
> > 
> > For some nesting requirement, you can use
> > lock_acquire(...,subclass,...nest_lock,...)
> > 
> > Or change the design.
> > --------------------
> > 
> > BUG: key ffff880042c68220 not in .data!
> > ------------[ cut here ]------------
> > WARNING: at kernel/lockdep.c:2706 lockdep_init_map+0xe6/0x4fb()
> > Hardware name: Lenovo WQ T168/T468 G6
> > Modules linked in: mptsas(+) mptscsih mptbase scsi_transport_sas ext4 jbd2 crc16 uhci_hcd ohci_hcd ehci_hcd
> > Pid: 1329, comm: modprobe Not tainted 2.6.34-rc3-22949-gbc8a97a-dirty #1
> 
> Please try 2.6.34-rc5 and let us know if this still shows up.

This particular one should indeed by fixed by upstream commit 
ebd09ec93c90c8 though.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

