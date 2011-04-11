Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab1DKOdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:33:10 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:38360 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab1DKOdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:33:08 -0400
Date: Mon, 11 Apr 2011 16:33:03 +0200 (CEST)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@c4eb
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: sysfs: cannot create duplicate filename
In-Reply-To: <20110411141309.GA8924@suse.de>
Message-ID: <alpine.LFD.2.02.1104111622490.1938@c4eb>
References: <alpine.LFD.2.02.1104111556280.1938@c4eb> <20110411141309.GA8924@suse.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Organization: "IBM Deutschland Research & Development GmbH Vorsitzender des Aufsichtsrats: Martin Jetter Geschaeftsfuehrung: Dirk Wittkopp Sitz der Gesellschaft: Boeblingen Registergericht: Amtsgericht Stuttgart, HRB 243294"
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Apr 2011, Greg KH wrote:

> On Mon, Apr 11, 2011 at 04:04:08PM +0200, Sebastian Ott wrote:
> > Hi,
> > 
> > i've seen this warning which looks to be caused by a race between device_add
> > and driver_register
> > 
> > [   80.893594] sysfs: cannot create duplicate filename '/bus/ccw/drivers/qeth/0.0.b57d'
> 
> Isn't the problem here the fact that you are creating 2 directories of
> the same name?
I'm sure this isn't the case here. The bus code just calls device_add and
at the same time on a different thread a module is loaded which registers
a driver at the bus.

I was able to reproduce this with a module which creates a dummy bus
and registers drivers and devices on this bus on 2 different workqueues.

> 
> 
> > [   80.893611] ------------[ cut here ]------------
> > [   80.893614] WARNING: at /home/autobuild/BUILD/linux-2.6.38.2-20110404/fs/sysfs/dir.c:455
> > [   80.893617] Modules linked in: qeth ccwgroup
> > [   80.893623] Modules linked in: qeth ccwgroup
> > [   80.893629] CPU: 1 Not tainted 2.6.38.2-48.x.20110404-s390xdefault #1
> > [   80.893632] Process kworker/u:1 (pid: 25, task: 000000007e6c5a40, ksp: 000000007e6cb980)
> > [   80.893635] Krnl PSW : 0704000180000000 00000000002b676c (sysfs_add_one+0xd0/0xe8)
> > [   80.893643]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:0 PM:0 EA:3
> > [   80.893647] Krnl GPRS: 00000000000000bd 0000000000000000 000000000000005e 0000000000000001
> > [   80.893651]            0000000000589daa 00000000005a1248 0000000000000000 0000000000000000
> > [   80.893654]            0000000000000000 0000000000000001 000000007865c000 000000007e6cbbd8
> > [   80.893657]            000000007c704398 00000000ffffffef 00000000002b6768 000000007e6cbb00
> > [   80.893668] Krnl Code: 00000000002b675c: c0200020041d        larl    %r2,6b6f96
> > [   80.893672]            00000000002b6762: c0e500169afb        brasl   %r14,589d58
> > [   80.893676]            00000000002b6768: a7f40001            brc     15,2b676a
> > [   80.893680]           >00000000002b676c: b904002a            lgr     %r2,%r10
> > [   80.893684]            00000000002b6770: c0e5fffb6236        brasl   %r14,222bdc
> > [   80.893687]            00000000002b6776: a7f4ffad            brc     15,2b66d0
> > [   80.893692]            00000000002b677a: e320c0480004        lg      %r2,72(%r12)
> > [   80.893695]            00000000002b6780: a7f4ffec            brc     15,2b6758
> > [   80.893699] Call Trace:
> > [   80.893701] ([<00000000002b6768>] sysfs_add_one+0xcc/0xe8)
> > [   80.893705]  [<00000000002b7046>] sysfs_do_create_link+0xda/0x268
> > [   80.893708]  [<0000000000409f26>] driver_sysfs_add+0x66/0xcc
> > [   80.893713]  [<000000000040a0a2>] device_bind_driver+0x26/0x48
> > [   80.893717]  [<000000000040a110>] device_attach+0x4c/0xd4
> > [   80.893720]  [<0000000000409734>] bus_probe_device+0x4c/0x5c
> > [   80.893724]  [<0000000000406c52>] device_add+0x61e/0x73c
> > [   80.893728]  [<00000000004631a6>] ccw_device_todo+0x31a/0x380
> > [   80.893733]  [<000000000015f5b6>] process_one_work+0x1f6/0x4f0
> > [   80.893739]  [<0000000000163358>] worker_thread+0x17c/0x370
> > [   80.893742]  [<00000000001690ca>] kthread+0xa6/0xb0
> > [   80.893747]  [<000000000058f5f2>] kernel_thread_starter+0x6/0xc
> > [   80.893752]  [<000000000058f5ec>] kernel_thread_starter+0x0/0xc
> > [   80.893756] 4 locks held by kworker/u:1/25:
> > [   80.893758]  #0:  (cio){++++.+}, at: [<000000000015f524>] process_one_work+0x164/0x4f0
> > [   80.893766]  #1:  ((&cdev->private->todo_work)){+.+.+.}, at: [<000000000015f524>] process_one_work+0x164/0x4f0
> > [   80.893773]  #2:  (&__lockdep_no_validate__){+.+.+.}, at: [<000000000040a0fc>] device_attach+0x38/0xd4
> > [   80.893780]  #3:  (sysfs_mutex){+.+.+.}, at: [<00000000002b7030>] sysfs_do_create_link+0xc4/0x268
> > [   80.893787] Last Breaking-Event-Address:
> > [   80.893790]  [<00000000002b6768>] sysfs_add_one+0xcc/0xe8
> > [   80.893795] ---[ end trace ded2f91fcf2c6165 ]---
> > 
> > 
> > * device_add attached the device to the bus /*break*/
> > * driver_register walks the list of devices and tries to bind
> >   unbound devices
> > * /*continue*/ device_add calls device_attach which gets confused
> >   that the device is already bound to a driver
> 
> Why would your bus code ever allow this to happen?  It's the caller's
> responsiblity to do things in the correct order, right?
I don't think the bus code which calls device_register can (or should)
prevent drivers from beeing registered at this bus at the same time.

> 
> > to fix this we could:
> > * hold the device lock in device_add (from bus_add_device to
> >   bus_probe_device)  ..but this means we have to extract the lock
> >   from the inside of some of these functions and i'm not sure about
> >   holding the lock while the blocking_notifier_call_chain thing..
> > 
> > * add a bus mutex, preventing concurrent registrations of devices
> >   and drivers to a bus
> > 
> > * change device_attach to detect an already bound device..something
> >   like the following:
> 
> How about fix your caller code?
> 
> thanks,
> 
> greg k-h
> 
