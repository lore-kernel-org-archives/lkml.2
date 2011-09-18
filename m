Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab1IRSHL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 14:07:11 -0400
Received: from imr3.ericy.com ([198.24.6.13]:60263 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801Ab1IRSHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 14:07:09 -0400
Date: Sun, 18 Sep 2011 11:05:29 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Rudolf Marek <r.marek@assembler.cz>, lm-sensors@lm-sensors.org,
        "R, Durgadoss" <durgadoss.r@intel.com>
Subject: Re: coretemp breaks lockdep. (MAX_LOCKDEP_ENTRIES too low!)
Message-ID: <20110918180529.GA30710@ericsson.com>
References: <20110915193018.GA10256@redhat.com>
 <20110916160752.GA10978@ericsson.com>
 <20110916162929.GB2714@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110916162929.GB2714@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 12:29:29PM -0400, Dave Jones wrote:
> On Fri, Sep 16, 2011 at 09:07:52AM -0700, Guenter Roeck wrote:
>  > On Thu, Sep 15, 2011 at 03:30:18PM -0400, Dave Jones wrote:
>  > > just had a user report this against rc6..
>  > > 
>  > > # while true; do rmmod coretemp; modprobe coretemp; done
>  > > 
>  > > 
>  > > [15811.924167] BUG: MAX_LOCKDEP_ENTRIES too low!
>  > > [15811.924171] turning off the locking correctness validator.
>  > > [15811.924175] Pid: 10598, comm: modprobe Not tainted 3.1.0-rc6+ #5
>  > > [15811.924178] Call Trace:
>  > > [15811.924187]  [<ffffffff81081205>] ? up+0x39/0x3e
>  > > [15811.924193]  [<ffffffff8108e556>] add_lock_to_list.constprop.22+0x45/0xa7
>  > > [15811.924198]  [<ffffffff81090c05>] __lock_acquire+0xb7f/0xd0c
>  > > [15811.924204]  [<ffffffff81091594>] ? mark_held_locks+0x6d/0x95
>  > > [15811.924210]  [<ffffffff814e27d5>] ? __slab_alloc+0x41c/0x43d
>  > > [15811.924216]  [<ffffffff812701d0>] ? kobject_add_internal+0x9b/0x18c
>  > > [15811.924221]  [<ffffffff81091295>] lock_acquire+0xf3/0x13e
>  > > [15811.924225]  [<ffffffff812701d0>] ? kobject_add_internal+0x9b/0x18c
>  > > [15811.924230]  [<ffffffff812701d0>] ? kobject_add_internal+0x9b/0x18c
>  > > [15811.924236]  [<ffffffff814e96a3>] _raw_spin_lock+0x40/0x73
>  > > [15811.924241]  [<ffffffff812701d0>] ? kobject_add_internal+0x9b/0x18c
>  > > [15811.924245]  [<ffffffff8127012e>] ? kobject_get+0x18/0x1f
>  > > [15811.924250]  [<ffffffff812701d0>] kobject_add_internal+0x9b/0x18c
>  > > [15811.924255]  [<ffffffff812705fa>] kobject_add+0x91/0xa2
>  > > [15811.924260]  [<ffffffff814c5afd>] ? klist_init+0x33/0x46
>  > > [15811.924265]  [<ffffffff81337bc3>] device_add+0xd5/0x576
>  > > [15811.924271]  [<ffffffff81336ac3>] ? dev_set_name+0x41/0x43
>  > > [15811.924277]  [<ffffffff8133b8f1>] platform_device_add+0x111/0x15b
>  > > [15811.924283]  [<ffffffffa0606cbd>] get_core_online+0x9b/0x143 [coretemp]
>  > > [15811.924290]  [<ffffffffa0050000>] ? 0xffffffffa004ffff
>  > > [15811.924296]  [<ffffffffa005004b>] coretemp_init+0x4b/0x1000 [coretemp]
>  > > [15811.924302]  [<ffffffffa0050000>] ? 0xffffffffa004ffff
>  > > [15811.924308]  [<ffffffff81002099>] do_one_initcall+0x7f/0x13a
>  > > [15811.924313]  [<ffffffffa0050000>] ? 0xffffffffa004ffff
>  > > [15811.924319]  [<ffffffff8109cacf>] sys_init_module+0x114/0x267
>  > > [15811.924324]  [<ffffffff814f0202>] system_call_fastpath+0x16/0x1b
>  > > 
>  > > 
[ ... ]

Turns out I can trigger a similar message with any module which creates platform devices
and/or sysfs attributes.

Example with w83627ehf, using "while true; do rmmod w83627ehf; modprobe w83627ehf; done":

Sep 18 10:25:47 groeck-desktop kernel: [  377.823865] BUG: MAX_STACK_TRACE_ENTRIES too low!
Sep 18 10:25:47 groeck-desktop kernel: [  377.823871] turning off the locking correctness validator.
Sep 18 10:25:47 groeck-desktop kernel: [  377.823878] Pid: 1621, comm: rmmod Not tainted 3.1.0-rc6+ #1
Sep 18 10:25:47 groeck-desktop kernel: [  377.823882] Call Trace:
Sep 18 10:25:47 groeck-desktop kernel: [  377.823894]  [<ffffffff810a02ef>] save_trace+0xcf/0xe0
Sep 18 10:25:47 groeck-desktop kernel: [  377.823901]  [<ffffffff810a3003>] mark_lock+0x123/0x410
Sep 18 10:25:47 groeck-desktop kernel: [  377.823907]  [<ffffffff810a3c56>] __lock_acquire+0x206/0x15d0
Sep 18 10:25:47 groeck-desktop kernel: [  377.823914]  [<ffffffff810a3829>] ? debug_check_no_locks_freed+0xa9/0x170
Sep 18 10:25:47 groeck-desktop kernel: [  377.823920]  [<ffffffff810a36e5>] ? trace_hardirqs_on_caller+0x105/0x190
Sep 18 10:25:47 groeck-desktop kernel: [  377.823926]  [<ffffffff810a5602>] lock_acquire+0xa2/0x130
Sep 18 10:25:47 groeck-desktop kernel: [  377.823935]  [<ffffffff811ef393>] ? sysfs_addrm_finish+0x43/0x70
Sep 18 10:25:47 groeck-desktop kernel: [  377.823943]  [<ffffffff811eecb7>] sysfs_deactivate+0x117/0x160
Sep 18 10:25:47 groeck-desktop kernel: [  377.823949]  [<ffffffff811ef393>] ? sysfs_addrm_finish+0x43/0x70
Sep 18 10:25:47 groeck-desktop kernel: [  377.823957]  [<ffffffff811ef393>] sysfs_addrm_finish+0x43/0x70
Sep 18 10:25:47 groeck-desktop kernel: [  377.823963]  [<ffffffff811ed5ab>] sysfs_hash_and_remove+0x9b/0xa0
Sep 18 10:25:47 groeck-desktop kernel: [  377.823969]  [<ffffffff811ee287>] sysfs_remove_file+0x17/0x20
Sep 18 10:25:47 groeck-desktop kernel: [  377.823977]  [<ffffffff813de4b7>] device_remove_file+0x17/0x20
Sep 18 10:25:47 groeck-desktop kernel: [  377.823985]  [<ffffffffa03931c2>] w83627ehf_device_remove_files+0x102/0x300

I have seen the same message with lm90, jc42, and ltc4261.

Looking through the code, it appears the the lockdep checking code adds entries whenever
a lock is added, but never removes anything (or I missed the removals). So I am not
convinced that this is really a coretemp problem, but instead a generic problem caused
by the way lockdep checks are implemented.  The reason for getting a MAX_LOCKDEP_ENTRIES
instead of MAX_STACK_TRACE_ENTRIES error for coretemp might simply be that it generates
more platform devices per instance than the other drivers.

Thanks,
Guenter
