Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973Ab0ICMW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 08:22:58 -0400
Received: from reaktio.net ([194.89.68.22]:38056 "EHLO ydin.reaktio.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757646Ab0ICMW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 08:22:56 -0400
Date: Fri, 3 Sep 2010 15:22:53 +0300
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Doug Neal <dneallkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: I/O scheduler deadlocks on Xen virtual block devices
Message-ID: <20100903122253.GL2804@reaktio.net>
References: <AANLkTi=O6Tpiz8TRFFknEpW7MMTGBAtqCpr7zH3abO67@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=O6Tpiz8TRFFknEpW7MMTGBAtqCpr7zH3abO67@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 03:17:25PM +0100, Doug Neal wrote:
> Hello all,
> 
> I believe I have found a bug in the I/O scheduler which results in
> access to a block device being blocked indefinitely.
> 
> The setup:
>  * Xen dom0 version 3.4.2.
>  * domU: Ubuntu 10.04, x86_64, with kernel 2.6.32.15+drm33.5.
>  * Paravirtual disks and network interfaces.
>  * Root filesystem on /dev/xvdb1
>  * A scratch filesystem for the purposes of my tests on /dev/xvda
> mounted on /mnt
>  * Both filesystems are ext3, formatted and mounted with defaults
>  * XVBDs are backed by LVM on top of an iSCSI SAN in the dom0.
> 

Hmm.. recently there was some patches to the Xen block device frontend driver
(sent to lkml). Maybe you should try if those make a difference? 

Jeremy: What do you think? 

-- Pasi

> 
> Activities leading up to the incident:
> 
> To reproduce the bug, I run the VM on a Xen host which has a moderate
> workload of other VMs. (It seems to manifest itself more readily than
> if the host is otherwise idle).
> 
> I repeatedly rsync the contents of a Linux install CD to an arbitrary
> location on the scratch filesystem, e.g. /mnt/test, then rm -rf the
> lot, and rsync again. It can sometimes take a few iterations before
> the bug is triggered. Sometimes it's triggered on the rsync, sometimes
> on the rm.
> 
> At some point during either the rsync or the rm, all the processes
> accessing /dev/xvda (rsync, kjournald, flush) become stuck in the D
> state. After 120 seconds the warnings start to appear in dmesg:
> 
>   [  840.070508] INFO: task rm:1455 blocked for more than 120 seconds.
>   [  840.070514] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> 
> Full dmesg output is below, including call traces which show that each
> of these processes is stuck in io_schedule or sync_buffer called from
> io_schedule.
> 
> 
> I believe I have eliminated:
>  * Problems with the underlying physical device
>    - The same bug has manifested itself on two completely separate
> sets of hardware, with different servers, switches, and SANs.
> 
>  * Problems with the host's iSCSI initiator
>    - Other VMs depending on the same iSCSI session are unaffected
>    - Other XVBDs within the same VM (in this case: /dev/xvdb1 mounted
> on /) are unaffected
> 
> Things I've tried:
>  * Noop, deadline, cfq and anticipatory elevators.
>  * Reducing the VM's vCPU count to 1. I _wasn't_ able to trigger the
> bug under only one vCPU.
> 
> Unfortunately the steps to reproduce are rather long winded once you
> factor in setting up the Xen dom0 which is in this case Citrix
> XenServer, so if there is any way I can help with that please let me
> know, e.g. by arranging remote access to my existing test environment
> or by supplying a VM template image. However I don't believe this
> problem is limited to this environment as I have seen quite a few
> reports of similar or identical issues elsewhere (but not on LKML...):
> 
> http://lists.xensource.com/archives/html/xen-devel/2010-06/msg00590.html
> - same issue reported with a non-commercial and more recent Xen
> version than mine. Also links to three Redhat bug reports showing
> similar behaviour.
> 
> 
> Thanks for your time,
> 
> Doug
> 
> 
> 
> [  720.070103] INFO: task kjournald:1011 blocked for more than 120 seconds.
> [  720.070121] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  720.070131] kjournald     D ffff8800035bcbc0     0  1011      2 0x00000000
> [  720.070140]  ffff880002dc1a30 0000000000000246 0000000000015bc0
> 0000000000015bc0
> [  720.070149]  ffff8800574db1a0 ffff880002dc1fd8 0000000000015bc0
> ffff8800574dade0
> [  720.070156]  0000000000015bc0 ffff880002dc1fd8 0000000000015bc0
> ffff8800574db1a0
> [  720.070164] Call Trace:
> [  720.070177]  [<ffffffff81558bb7>] io_schedule+0x47/0x70
> [  720.070184]  [<ffffffff812a095e>] get_request_wait+0xce/0x1a0
> [  720.070191]  [<ffffffff81085090>] ? autoremove_wake_function+0x0/0x40
> [  720.070195]  [<ffffffff812a1045>] __make_request+0x95/0x4a0
> [  720.070201]  [<ffffffff810f6595>] ? mempool_alloc_slab+0x15/0x20
> [  720.070208]  [<ffffffff8100f37f>] ? xen_restore_fl_direct_end+0x0/0x1
> [  720.070213]  [<ffffffff8129f7a1>] generic_make_request+0x1b1/0x4f0
> [  720.070218]  [<ffffffff810f6595>] ? mempool_alloc_slab+0x15/0x20
> [  720.070223]  [<ffffffff8129fb60>] submit_bio+0x80/0x110
> [  720.070229]  [<ffffffff8116d399>] submit_bh+0xf9/0x140
> [  720.070235]  [<ffffffff8121495c>] journal_submit_data_buffers+0x24c/0x320
> [  720.070240]  [<ffffffff81214d02>] journal_commit_transaction+0x2d2/0xe40
> [  720.070245]  [<ffffffff8100f37f>] ? xen_restore_fl_direct_end+0x0/0x1
> [  720.070250]  [<ffffffff8155ab5e>] ? _spin_unlock_irqrestore+0x1e/0x30
> [  720.070256]  [<ffffffff81077719>] ? try_to_del_timer_sync+0x79/0xd0
> [  720.070261]  [<ffffffff8100f37f>] ? xen_restore_fl_direct_end+0x0/0x1
> [  720.070265]  [<ffffffff8155ab5e>] ? _spin_unlock_irqrestore+0x1e/0x30
> [  720.070270]  [<ffffffff81218c1d>] kjournald+0xed/0x250
> [  720.070275]  [<ffffffff81085090>] ? autoremove_wake_function+0x0/0x40
> [  720.070279]  [<ffffffff81218b30>] ? kjournald+0x0/0x250
> [  720.070284]  [<ffffffff81084d16>] kthread+0x96/0xa0
> [  720.070289]  [<ffffffff810141ea>] child_rip+0xa/0x20
> [  720.070295]  [<ffffffff810133d1>] ? int_ret_from_sys_call+0x7/0x1b
> [  720.070299]  [<ffffffff81013b5d>] ? retint_restore_args+0x5/0x6
> [  720.070313]  [<ffffffff810141e0>] ? child_rip+0x0/0x20
> [  720.070317] INFO: task rm:1455 blocked for more than 120 seconds.
> [  720.070323] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  720.070329] rm            D ffff8800035dabc0     0  1455    980 0x00000000
> [  720.070333]  ffff880058bedb68 0000000000000286 0000000000015bc0
> 0000000000015bc0
> [  720.070338]  ffff880002d39ab0 ffff880058bedfd8 0000000000015bc0
> ffff880002d396f0
> [  720.070343]  0000000000015bc0 ffff880058bedfd8 0000000000015bc0
> ffff880002d39ab0
> [  720.070348] Call Trace:
> [  720.070351]  [<ffffffff8116e5d0>] ? sync_buffer+0x0/0x50
> [  720.070354]  [<ffffffff81558bb7>] io_schedule+0x47/0x70
> [  720.070357]  [<ffffffff8116e615>] sync_buffer+0x45/0x50
> [  720.070360]  [<ffffffff8155908a>] __wait_on_bit_lock+0x5a/0xc0
> [  720.070363]  [<ffffffff8116e5d0>] ? sync_buffer+0x0/0x50
> [  720.070366]  [<ffffffff81559168>] out_of_line_wait_on_bit_lock+0x78/0x90
> [  720.070369]  [<ffffffff810850d0>] ? wake_bit_function+0x0/0x40
> [  720.070373]  [<ffffffff8116d259>] ? try_to_free_buffers+0x79/0xc0
> [  720.070376]  [<ffffffff8116e796>] __lock_buffer+0x36/0x40
> [  720.070379]  [<ffffffff812136d6>] journal_invalidatepage+0xc6/0xd0
> [  720.070383]  [<ffffffff811b7e5d>] ext3_invalidatepage+0x3d/0x40
> [  720.070388]  [<ffffffff810ff7a5>] do_invalidatepage+0x25/0x30
> [  720.070390]  [<ffffffff810ffa8a>] truncate_inode_page+0x9a/0xb0
> [  720.070393]  [<ffffffff810ffd80>] truncate_inode_pages_range+0x160/0x440
> [  720.070396]  [<ffffffff811bb950>] ? ext3_delete_inode+0x0/0xf0
> [  720.070399]  [<ffffffff81100075>] truncate_inode_pages+0x15/0x20
> [  720.070402]  [<ffffffff811bb96d>] ext3_delete_inode+0x1d/0xf0
> [  720.070405]  [<ffffffff811bb950>] ? ext3_delete_inode+0x0/0xf0
> [  720.070409]  [<ffffffff8115cac3>] generic_delete_inode+0xe3/0x1c0
> [  720.070412]  [<ffffffff8115cc05>] generic_drop_inode+0x65/0x80
> [  720.070415]  [<ffffffff8115b592>] iput+0x62/0x70
> [  720.070419]  [<ffffffff81151f82>] do_unlinkat+0x112/0x1d0
> [  720.070422]  [<ffffffff811555e5>] ? sys_getdents+0xb5/0xf0
> [  720.070425]  [<ffffffff811521b2>] sys_unlinkat+0x22/0x40
> [  720.070428]  [<ffffffff810131b2>] system_call_fastpath+0x16/0x1b
> [  840.070097] INFO: task flush-202:0:208 blocked for more than 120 seconds.
> [  840.070115] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  840.070125] flush-202:0   D ffff88000359ebc0     0   208      2 0x00000000
> [  840.070132]  ffff880002d698c0 0000000000000246 0000000000015bc0
> 0000000000015bc0
> [  840.070142]  ffff88007d444890 ffff880002d69fd8 0000000000015bc0
> ffff88007d4444d0
> [  840.070149]  0000000000015bc0 ffff880002d69fd8 0000000000015bc0
> ffff88007d444890
> [  840.070156] Call Trace:
> [  840.070170]  [<ffffffff8116e5d0>] ? sync_buffer+0x0/0x50
> [  840.070177]  [<ffffffff81558bb7>] io_schedule+0x47/0x70
> [  840.070182]  [<ffffffff8116e615>] sync_buffer+0x45/0x50
> [  840.070187]  [<ffffffff8155908a>] __wait_on_bit_lock+0x5a/0xc0
> [  840.070191]  [<ffffffff8116e5d0>] ? sync_buffer+0x0/0x50
> [  840.070196]  [<ffffffff8116eb60>] ? end_buffer_async_write+0x0/0x180
> [  840.070201]  [<ffffffff81559168>] out_of_line_wait_on_bit_lock+0x78/0x90
> [  840.070208]  [<ffffffff810850d0>] ? wake_bit_function+0x0/0x40
> [  840.070212]  [<ffffffff8116e796>] __lock_buffer+0x36/0x40
> [  840.070217]  [<ffffffff8116f473>] __block_write_full_page+0x383/0x3c0
> [  840.070222]  [<ffffffff8116eb60>] ? end_buffer_async_write+0x0/0x180
> [  840.070227]  [<ffffffff8116fde0>] block_write_full_page_endio+0xe0/0x120
> [  840.070232]  [<ffffffff811b70f0>] ? buffer_unmapped+0x0/0x20
> [  840.070237]  [<ffffffff8116fe35>] block_write_full_page+0x15/0x20
> [  840.070241]  [<ffffffff811b7bfd>] ext3_ordered_writepage+0x1dd/0x200
> [  840.070248]  [<ffffffff810fc687>] __writepage+0x17/0x40
> [  840.070254]  [<ffffffff810fd83f>] write_cache_pages+0x21f/0x4d0
> [  840.070258]  [<ffffffff810fc670>] ? __writepage+0x0/0x40
> [  840.070263]  [<ffffffff810fdb14>] generic_writepages+0x24/0x30
> [  840.070268]  [<ffffffff810fdb55>] do_writepages+0x35/0x40
> [  840.070273]  [<ffffffff81166976>] writeback_single_inode+0xf6/0x3d0
> [  840.070279]  [<ffffffff811675de>] writeback_inodes_wb+0x40e/0x5e0
> [  840.070283]  [<ffffffff811678ba>] wb_writeback+0x10a/0x1d0
> [  840.070289]  [<ffffffff81077719>] ? try_to_del_timer_sync+0x79/0xd0
> [  840.070294]  [<ffffffff81558e6d>] ? schedule_timeout+0x19d/0x300
> [  840.070298]  [<ffffffff81167bec>] wb_do_writeback+0x18c/0x1a0
> [  840.070303]  [<ffffffff81167c53>] bdi_writeback_task+0x53/0xe0
> [  840.070308]  [<ffffffff8110f546>] bdi_start_fn+0x86/0x100
> [  840.070312]  [<ffffffff8110f4c0>] ? bdi_start_fn+0x0/0x100
> [  840.070317]  [<ffffffff81084d16>] kthread+0x96/0xa0
> [  840.070322]  [<ffffffff810141ea>] child_rip+0xa/0x20
> [  840.070329]  [<ffffffff810133d1>] ? int_ret_from_sys_call+0x7/0x1b
> [  840.070333]  [<ffffffff81013b5d>] ? retint_restore_args+0x5/0x6
> [  840.070337]  [<ffffffff810141e0>] ? child_rip+0x0/0x20
> [  840.070346] INFO: task kjournald:1011 blocked for more than 120 seconds.
> [  840.070354] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  840.070363] kjournald     D ffff8800035bcbc0     0  1011      2 0x00000000
> [  840.070378]  ffff880002dc1a30 0000000000000246 0000000000015bc0
> 0000000000015bc0
> [  840.070385]  ffff8800574db1a0 ffff880002dc1fd8 0000000000015bc0
> ffff8800574dade0
> [  840.070392]  0000000000015bc0 ffff880002dc1fd8 0000000000015bc0
> ffff8800574db1a0
> [  840.070399] Call Trace:
> [  840.070404]  [<ffffffff81558bb7>] io_schedule+0x47/0x70
> [  840.070409]  [<ffffffff812a095e>] get_request_wait+0xce/0x1a0
> [  840.070414]  [<ffffffff81085090>] ? autoremove_wake_function+0x0/0x40
> [  840.070418]  [<ffffffff812a1045>] __make_request+0x95/0x4a0
> [  840.070423]  [<ffffffff810f6595>] ? mempool_alloc_slab+0x15/0x20
> [  840.070428]  [<ffffffff8100f37f>] ? xen_restore_fl_direct_end+0x0/0x1
> [  840.070434]  [<ffffffff8129f7a1>] generic_make_request+0x1b1/0x4f0
> [  840.070438]  [<ffffffff810f6595>] ? mempool_alloc_slab+0x15/0x20
> [  840.070443]  [<ffffffff8129fb60>] submit_bio+0x80/0x110
> [  840.070448]  [<ffffffff8116d399>] submit_bh+0xf9/0x140
> [  840.070463]  [<ffffffff8121495c>] journal_submit_data_buffers+0x24c/0x320
> [  840.070466]  [<ffffffff81214d02>] journal_commit_transaction+0x2d2/0xe40
> [  840.070470]  [<ffffffff8100f37f>] ? xen_restore_fl_direct_end+0x0/0x1
> [  840.070473]  [<ffffffff8155ab5e>] ? _spin_unlock_irqrestore+0x1e/0x30
> [  840.070476]  [<ffffffff81077719>] ? try_to_del_timer_sync+0x79/0xd0
> [  840.070479]  [<ffffffff8100f37f>] ? xen_restore_fl_direct_end+0x0/0x1
> [  840.070482]  [<ffffffff8155ab5e>] ? _spin_unlock_irqrestore+0x1e/0x30
> [  840.070485]  [<ffffffff81218c1d>] kjournald+0xed/0x250
> [  840.070488]  [<ffffffff81085090>] ? autoremove_wake_function+0x0/0x40
> [  840.070491]  [<ffffffff81218b30>] ? kjournald+0x0/0x250
> [  840.070494]  [<ffffffff81084d16>] kthread+0x96/0xa0
> [  840.070497]  [<ffffffff810141ea>] child_rip+0xa/0x20
> [  840.070500]  [<ffffffff810133d1>] ? int_ret_from_sys_call+0x7/0x1b
> [  840.070503]  [<ffffffff81013b5d>] ? retint_restore_args+0x5/0x6
> [  840.070506]  [<ffffffff810141e0>] ? child_rip+0x0/0x20
> [  840.070508] INFO: task rm:1455 blocked for more than 120 seconds.
> [  840.070514] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  840.070519] rm            D ffff8800035dabc0     0  1455    980 0x00000000
> [  840.070524]  ffff880058bedb68 0000000000000286 0000000000015bc0
> 0000000000015bc0
> [  840.070528]  ffff880002d39ab0 ffff880058bedfd8 0000000000015bc0
> ffff880002d396f0
> [  840.070533]  0000000000015bc0 ffff880058bedfd8 0000000000015bc0
> ffff880002d39ab0
> [  840.070538] Call Trace:
> [  840.070541]  [<ffffffff8116e5d0>] ? sync_buffer+0x0/0x50
> [  840.070544]  [<ffffffff81558bb7>] io_schedule+0x47/0x70
> [  840.070547]  [<ffffffff8116e615>] sync_buffer+0x45/0x50
> [  840.070550]  [<ffffffff8155908a>] __wait_on_bit_lock+0x5a/0xc0
> [  840.070553]  [<ffffffff8116e5d0>] ? sync_buffer+0x0/0x50
> [  840.070556]  [<ffffffff81559168>] out_of_line_wait_on_bit_lock+0x78/0x90
> [  840.070560]  [<ffffffff810850d0>] ? wake_bit_function+0x0/0x40
> [  840.070563]  [<ffffffff8116d259>] ? try_to_free_buffers+0x79/0xc0
> [  840.070566]  [<ffffffff8116e796>] __lock_buffer+0x36/0x40
> [  840.070569]  [<ffffffff812136d6>] journal_invalidatepage+0xc6/0xd0
> [  840.070572]  [<ffffffff811b7e5d>] ext3_invalidatepage+0x3d/0x40
> [  840.070575]  [<ffffffff810ff7a5>] do_invalidatepage+0x25/0x30
> [  840.070578]  [<ffffffff810ffa8a>] truncate_inode_page+0x9a/0xb0
> [  840.070581]  [<ffffffff810ffd80>] truncate_inode_pages_range+0x160/0x440
> [  840.070584]  [<ffffffff811bb950>] ? ext3_delete_inode+0x0/0xf0
> [  840.070587]  [<ffffffff81100075>] truncate_inode_pages+0x15/0x20
> [  840.070590]  [<ffffffff811bb96d>] ext3_delete_inode+0x1d/0xf0
> [  840.070593]  [<ffffffff811bb950>] ? ext3_delete_inode+0x0/0xf0
> [  840.070597]  [<ffffffff8115cac3>] generic_delete_inode+0xe3/0x1c0
> [  840.070600]  [<ffffffff8115cc05>] generic_drop_inode+0x65/0x80
> [  840.070603]  [<ffffffff8115b592>] iput+0x62/0x70
> [  840.070606]  [<ffffffff81151f82>] do_unlinkat+0x112/0x1d0
> [  840.070610]  [<ffffffff811555e5>] ? sys_getdents+0xb5/0xf0
> [  840.070613]  [<ffffffff811521b2>] sys_unlinkat+0x22/0x40
> [  840.070616]  [<ffffffff810131b2>] system_call_fastpath+0x16/0x1b
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
