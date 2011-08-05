Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab1HEHWA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 03:22:00 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44514 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab1HEHV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 03:21:56 -0400
Date: Fri, 5 Aug 2011 10:20:44 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "lan,Tianyu" <tianyu.lan@intel.com>
Cc: Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Battery: sysfs_remove_battery(): possible circular
 locking
Message-ID: <20110805072044.GB8311@swordfish>
References: <20110805003322.GA8311@swordfish>
 <1312521008.2096.173.camel@lantianyu-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312521008.2096.173.camel@lantianyu-ws>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (08/05/11 13:10), lan,Tianyu wrote:
> I think changing  'the marker' to 'battery->bat.name' will introduce
> problem.
> In the sysfs_add_battery(), when the 'battery->bat.name' is assigned,
> the power_supply_register() and device_create_file() have not been
> invoked. In this time, maybe sysfs_remove_battery() will be invoked and
> cause device_remove_file() and power_supply_unregister() invoked without
> device file created and power supply registered.
>

Hm, good point! It was ~3.30AM when I was writing the patch, so I 
obviously didn't think carefully enought. Here the whole trace (I'll
get back to my laptop within 2 hours):

[14818.477168] 
[14818.477170] =======================================================
[14818.477200] [ INFO: possible circular locking dependency detected ]
[14818.477221] 3.1.0-dbg-07865-g1280ea8-dirty #668
[14818.477236] -------------------------------------------------------
[14818.477257] s2ram/1599 is trying to acquire lock:
[14818.477276]  (s_active#8){++++.+}, at: [<ffffffff81169147>] sysfs_addrm_finish+0x31/0x5a
[14818.477323] 
[14818.477325] but task is already holding lock:
[14818.477350]  (&battery->lock){+.+.+.}, at: [<ffffffffa0047278>] sysfs_remove_battery+0x10/0x4b [battery]
[14818.477395] 
[14818.477397] which lock already depends on the new lock.
[14818.477399] 
[14818.477433] 
[14818.477435] the existing dependency chain (in reverse order) is:
[14818.477461] 
[14818.477463] -> #1 (&battery->lock){+.+.+.}:
[14818.477497]        [<ffffffff810718d2>] lock_acquire+0x138/0x1ac
[14818.477527]        [<ffffffff8148b303>] mutex_lock_nested+0x5e/0x325
[14818.477558]        [<ffffffffa00473bf>] acpi_battery_get_state+0x6a/0x16f [battery]
[14818.477592]        [<ffffffffa00474f1>] acpi_battery_get_property+0x2d/0x1cf [battery]
[14818.477627]        [<ffffffff813c7348>] power_supply_show_property+0x59/0x147
[14818.477662]        [<ffffffff813c74fc>] power_supply_uevent+0x93/0x17f
[14818.477692]        [<ffffffff81386f96>] dev_uevent+0x12f/0x155
[14818.477722]        [<ffffffff813858b8>] show_uevent+0xa9/0xf4
[14818.477750]        [<ffffffff81385d02>] dev_attr_show+0x22/0x49
[14818.477779]        [<ffffffff81168690>] sysfs_read_file+0xb4/0x139
[14818.477809]        [<ffffffff81109171>] vfs_read+0xaa/0x13a
[14818.477840]        [<ffffffff81109246>] sys_read+0x45/0x6c
[14818.477867]        [<ffffffff81492f92>] system_call_fastpath+0x16/0x1b
[14818.477899] 
[14818.477900] -> #0 (s_active#8){++++.+}:
[14818.477938]        [<ffffffff81070cb5>] __lock_acquire+0xfe4/0x164b
[14818.477968]        [<ffffffff810718d2>] lock_acquire+0x138/0x1ac
[14818.477997]        [<ffffffff81168a79>] sysfs_deactivate+0x9b/0xec
[14818.478026]        [<ffffffff81169147>] sysfs_addrm_finish+0x31/0x5a
[14818.478055]        [<ffffffff81167bc5>] sysfs_hash_and_remove+0x54/0x77
[14818.478086]        [<ffffffff811681b9>] sysfs_remove_file+0x12/0x14
[14818.478115]        [<ffffffff81385bf8>] device_remove_file+0x12/0x14
[14818.478145]        [<ffffffff81386504>] device_del+0x119/0x17c
[14818.478172]        [<ffffffff81386575>] device_unregister+0xe/0x1a
[14818.478201]        [<ffffffff813c6ef9>] power_supply_unregister+0x23/0x27
[14818.478233]        [<ffffffffa004729c>] sysfs_remove_battery+0x34/0x4b [battery]
[14818.478267]        [<ffffffffa004778f>] battery_notify+0x2c/0x3a [battery]
[14818.478299]        [<ffffffff8148fe82>] notifier_call_chain+0x74/0xa1
[14818.478330]        [<ffffffff810624b4>] __blocking_notifier_call_chain+0x6c/0x89
[14818.478363]        [<ffffffff810624e0>] blocking_notifier_call_chain+0xf/0x11
[14818.478394]        [<ffffffff8107e40e>] pm_notifier_call_chain+0x15/0x27
[14818.478426]        [<ffffffff8107ee1a>] enter_state+0xa7/0xd5
[14818.478454]        [<ffffffff8107e341>] state_store+0xaa/0xc0
[14818.478482]        [<ffffffff81248837>] kobj_attr_store+0x17/0x19
[14818.478511]        [<ffffffff81167e27>] sysfs_write_file+0x103/0x13f
[14818.478541]        [<ffffffff81109037>] vfs_write+0xad/0x13d
[14818.478568]        [<ffffffff811092b2>] sys_write+0x45/0x6c
[14818.478595]        [<ffffffff81492f92>] system_call_fastpath+0x16/0x1b
[14818.478626] 
[14818.478628] other info that might help us debug this:
[14818.478630] 
[14818.478665]  Possible unsafe locking scenario:
[14818.478668] 
[14818.478694]        CPU0                    CPU1
[14818.478713]        ----                    ----
[14818.478731]   lock(&battery->lock);
[14818.478754]                                lock(s_active);
[14818.478782]                                lock(&battery->lock);
[14818.478810]   lock(s_active);
[14818.478831] 
[14818.478832]  *** DEADLOCK ***
[14818.478835] 
[14818.478868] 5 locks held by s2ram/1599:
[14818.478885]  #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff81167d5b>] sysfs_write_file+0x37/0x13f
[14818.478932]  #1:  (s_active#106){.+.+.+}, at: [<ffffffff81167e06>] sysfs_write_file+0xe2/0x13f
[14818.478980]  #2:  (pm_mutex){+.+...}, at: [<ffffffff8107ed9d>] enter_state+0x2a/0xd5
[14818.479021]  #3:  ((pm_chain_head).rwsem){++++..}, at: [<ffffffff8106249f>] __blocking_notifier_call_chain+0x57/0x89
[14818.479070]  #4:  (&battery->lock){+.+.+.}, at: [<ffffffffa0047278>] sysfs_remove_battery+0x10/0x4b [battery]
[14818.479119] 
[14818.479121] stack backtrace:
[14818.479148] Pid: 1599, comm: s2ram Not tainted 3.1.0-dbg-07865-g1280ea8-dirty #668
[14818.479175] Call Trace:
[14818.479198]  [<ffffffff814828c3>] print_circular_bug+0x293/0x2a4
[14818.479228]  [<ffffffff81070cb5>] __lock_acquire+0xfe4/0x164b
[14818.479260]  [<ffffffff81169147>] ? sysfs_addrm_finish+0x31/0x5a
[14818.479288]  [<ffffffff810718d2>] lock_acquire+0x138/0x1ac
[14818.479316]  [<ffffffff81169147>] ? sysfs_addrm_finish+0x31/0x5a
[14818.479345]  [<ffffffff81168a79>] sysfs_deactivate+0x9b/0xec
[14818.479373]  [<ffffffff81169147>] ? sysfs_addrm_finish+0x31/0x5a
[14818.479405]  [<ffffffff81169147>] sysfs_addrm_finish+0x31/0x5a
[14818.479433]  [<ffffffff81167bc5>] sysfs_hash_and_remove+0x54/0x77
[14818.479461]  [<ffffffff811681b9>] sysfs_remove_file+0x12/0x14
[14818.479488]  [<ffffffff81385bf8>] device_remove_file+0x12/0x14
[14818.479516]  [<ffffffff81386504>] device_del+0x119/0x17c
[14818.479542]  [<ffffffff81386575>] device_unregister+0xe/0x1a
[14818.479570]  [<ffffffff813c6ef9>] power_supply_unregister+0x23/0x27
[14818.479601]  [<ffffffffa004729c>] sysfs_remove_battery+0x34/0x4b [battery]
[14818.479632]  [<ffffffffa004778f>] battery_notify+0x2c/0x3a [battery]
[14818.479662]  [<ffffffff8148fe82>] notifier_call_chain+0x74/0xa1
[14818.479692]  [<ffffffff810624b4>] __blocking_notifier_call_chain+0x6c/0x89
[14818.479722]  [<ffffffff810624e0>] blocking_notifier_call_chain+0xf/0x11
[14818.479751]  [<ffffffff8107e40e>] pm_notifier_call_chain+0x15/0x27
[14818.479770]  [<ffffffff8107ee1a>] enter_state+0xa7/0xd5
[14818.479782]  [<ffffffff8107e341>] state_store+0xaa/0xc0
[14818.479795]  [<ffffffff8107e297>] ? pm_async_store+0x45/0x45
[14818.479807]  [<ffffffff81248837>] kobj_attr_store+0x17/0x19
[14818.479820]  [<ffffffff81167e27>] sysfs_write_file+0x103/0x13f
[14818.479834]  [<ffffffff81109037>] vfs_write+0xad/0x13d
[14818.479847]  [<ffffffff811092b2>] sys_write+0x45/0x6c
[14818.479860]  [<ffffffff81492f92>] system_call_fastpath+0x16/0x1b


	Sergey






> sysfs_remove_battery()  will be invoked in the battery_notify(),
> acpi_battery_refresh() and sysfs_remove_battery() which causes the
> situation. This is also the cause  of bug 35642.
> 
> > I've changed `the marker' from `battery->bat.dev' to `battery->bat.name', so 
> > the basic idea should remain the same, now we just can release battery->lock 
> > more quicker, before device_remove_file() call.
> > 
> > Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > 
> > ---
> > 
> >  drivers/acpi/battery.c |    6 ++++--
> >  1 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
> > index 87c0a8d..398cbfb 100644
> > --- a/drivers/acpi/battery.c
> > +++ b/drivers/acpi/battery.c
> > @@ -574,15 +574,17 @@ static int sysfs_add_battery(struct acpi_battery *battery)
> >  static void sysfs_remove_battery(struct acpi_battery *battery)
> >  {
> >  	mutex_lock(&battery->lock);
> > -	if (!battery->bat.dev) {
> > +	if (!battery->bat.name) {
> >  		mutex_unlock(&battery->lock);
> >  		return;
> >  	}
> >  
> > +	battery->bat.name = NULL;
> > +	mutex_unlock(&battery->lock);
> > +
> >  	device_remove_file(battery->bat.dev, &alarm_attr);
> >  	power_supply_unregister(&battery->bat);
> >  	battery->bat.dev = NULL;
> > -	mutex_unlock(&battery->lock);
> >  }
> >  
> >  /*
> > 
> 
> 
