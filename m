Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758354Ab0GHRhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 13:37:22 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43362 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755328Ab0GHRhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 13:37:20 -0400
Subject: Re: 2.6.33.5 rt23: sleeping function called from invalid context
From: john stultz <johnstul@us.ibm.com>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <1278561270.5448.2.camel@localhost.localdomain>
References: <1278561270.5448.2.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Jul 2010 10:37:04 -0700
Message-ID: <1278610624.3008.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-07 at 20:54 -0700, Fernando Lopez-Lezcano wrote:
> After a suspend/wake up cycle, just after upgrading to fc12 (I did not
> see this with the same basic kernel - that is, compiled from the same
> source + patches - under fc11). 
> 
> BUG: sleeping function called from invalid context at
> kernel/rtmutex.c:684
> pcnt: 0 0 in_atomic(): 0, irqs_disabled(): 1, pid: 10582, name:
> pm-suspend
> Pid: 10582, comm: pm-suspend Not tainted
> 2.6.33.5-120.rt23.1.fc11.ccrma.i686.rtPAE #1
> Call Trace:
> [<c042eced>] __might_sleep+0xcc/0xd4
> [<c0464f57>] rt_spin_lock_fastlock.clone.1+0x26/0x5f
> [<c0792862>] rt_spin_lock+0x8/0xa
> [<c040dddc>] read_persistent_clock+0x11/0x30
> [<c045d1de>] timekeeping_suspend+0xe/0x4e
> [<c0640c9e>] sysdev_suspend+0x15c/0x356
> [<c0792906>] ? _mutex_unlock+0x8/0xa
> [<c046afc1>] suspend_devices_and_enter+0xea/0x17f
> [<c046b11e>] enter_state+0xc8/0x114
> [<c046a9cf>] state_store+0x93/0xa7
> [<c046a93c>] ? state_store+0x0/0xa7
> [<c05a6505>] kobj_attr_store+0x16/0x22
> [<c0515afa>] sysfs_write_file+0xbf/0xea
> [<c0515a3b>] ? sysfs_write_file+0x0/0xea
> [<c04d26ba>] vfs_write+0x80/0xdf
> [<c0465134>] ? rt_up_read+0x13/0x15
> [<c04d27ad>] sys_write+0x3b/0x5d
> [<c040895f>] sysenter_do_call+0x12/0x28

Huh. Looks like the lock protecting the RTC/CMOS might need to be
converted to a raw spinlock, since suspend/resume is probably done with
irqs off.

A little baffled why the same kernel didn't see this with fc11.

Does this reproduce easily?

thanks
-john

