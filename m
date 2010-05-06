Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab0EFQGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 12:06:35 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:44607 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab0EFQGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 12:06:32 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Jerome Glisse <jglisse@redhat.com>, Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: linux-next - drm/ttm versus nouveau - WARNING and dead driver.
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1273161966_4019P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 06 May 2010 12:06:06 -0400
Message-ID: <7841.1273161966@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020201.4BE2E8EF.0030,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1273161966_4019P
Content-Type: text/plain; charset=us-ascii

Bisected down to:

82c5da6bf8b55a931b042fb531083863d26c8020 is the first bad commit
commit 82c5da6bf8b55a931b042fb531083863d26c8020
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Fri Apr 9 14:39:23 2010 +0200

    drm/ttm: ttm_fault callback to allow driver to handle bo placement V6
    
    On fault the driver is given the opportunity to perform any operation
    it sees fit in order to place the buffer into a CPU visible area of
    memory. This patch doesn't break TTM users, nouveau, vmwgfx and radeon
    should keep working properly. Future patch will take advantage of this
    infrastructure and remove the old path from TTM once driver are
    converted.
    
    V2 return VM_FAULT_NOPAGE if callback return -EBUSY or -ERESTARTSYS
    V3 balance io_mem_reserve and io_mem_free call, fault_reserve_notify
       is responsible to perform any necessary task for mapping to succeed
    V4 minor cleanup, atomic_t -> bool as member is protected by reserve
       mecanism from concurent access
    V5 the callback is now responsible for iomapping the bo and providing
       a virtual address this simplify TTM and will allow to get rid of
       TTM_MEMTYPE_FLAG_NEEDS_IOREMAP
    V6 use the bus addr data to decide to ioremap or this isn't needed
       but we don't necesarily need to ioremap in the callback but still
       allow driver to use static mapping
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

:040000 040000 f5cac8c7c44a55582dcb4acbd06f55cd661b2caa c87496434bf85c5489480ee5f32f4976111abaad M      drivers
:040000 040000 947f0bb5d6abb603468b264d62703b6609826346 a37a78017062943bf3142b2fa386cc221f13529a M      include

This causes my Dell Latitude laptop to not init the nouveau driver.
lspci says: 01:00.0 VGA compatible controller: nVidia Corporation G98M [Quadro NVS 160M] (rev a1)

I haven't been able to do a clean revert of this to test, as there's at least 2
dependent commits on top of it, one of which has enough other context that I
can't sort it out.

[    1.038152] [drm] nouveau 0000:01:00.0: Detected 256MiB VRAM
[    1.194505] [TTM] Zone  kernel: Available graphics memory: 2013496 kiB.
[    1.194508] [ttm] Initializing pool allocator.
[    1.194896] ------------[ cut here ]------------
[    1.194903] WARNING: at arch/x86/mm/ioremap.c:111 __ioremap_caller+0x238/0x3f4()
[    1.194906] Hardware name: Latitude E6500                  
[    1.194908] Modules linked in:
[    1.194912] Pid: 1, comm: swapper Not tainted 2.6.34-rc5-mmotm0428 #1
[    1.194915] Call Trace:
[    1.194921]  [<ffffffff81038936>] warn_slowpath_common+0x80/0x98
[    1.194925]  [<ffffffff81038963>] warn_slowpath_null+0x15/0x17
[    1.194929]  [<ffffffff8102064a>] __ioremap_caller+0x238/0x3f4
[    1.194934]  [<ffffffff812b27ba>] ? ttm_mem_reg_ioremap+0x54/0x7b
[    1.194939]  [<ffffffff810d6aff>] ? kmem_cache_alloc_notrace+0x68/0xc0
[    1.194942]  [<ffffffff8102088f>] ioremap_nocache+0x12/0x14
[    1.194946]  [<ffffffff812b27ba>] ttm_mem_reg_ioremap+0x54/0x7b
[    1.194950]  [<ffffffff812b2b5c>] ttm_bo_move_memcpy+0x5e/0x3e0
[    1.194954]  [<ffffffff812a4d7d>] ? drm_mm_split_at_start+0x79/0x95
[    1.194959]  [<ffffffff8120ec2d>] ? do_raw_spin_unlock+0xd0/0xfa
[    1.194964]  [<ffffffff812c21cf>] nouveau_bo_move+0x19e/0x222
[    1.194968]  [<ffffffff812afe79>] ttm_bo_handle_move_mem+0x1b4/0x2c0
[    1.194972]  [<ffffffff812b1d9e>] ttm_bo_move_buffer+0xf4/0x14d
[    1.194976]  [<ffffffff81210b2d>] ? __list_add+0xb7/0xd2
[    1.194980]  [<ffffffff812b1ee3>] ttm_bo_validate+0xec/0x13e
[    1.194983]  [<ffffffff8120e900>] ? do_raw_write_unlock+0x7e/0xc8
[    1.194987]  [<ffffffff812b2315>] ttm_bo_init+0x3e0/0x419
[    1.194990]  [<ffffffff812c2957>] nouveau_bo_new+0x394/0x405
[    1.194994]  [<ffffffff812c2510>] ? nouveau_bo_del_ttm+0x0/0xb3
[    1.194997]  [<ffffffff812a4cca>] ? drm_mm_init+0x63/0x6b
[    1.195015]  [<ffffffff812ba319>] nouveau_mem_init+0x262/0x42f
[    1.195019]  [<ffffffff812b7e02>] nouveau_card_init+0xb09/0xe35
[    1.195023]  [<ffffffff812b86de>] nouveau_load+0x4e6/0x50c
[    1.195028]  [<ffffffff812a0fee>] drm_get_dev+0x3bf/0x4cc
[    1.195034]  [<ffffffff8158c3be>] nouveau_pci_probe+0x10/0x12
[    1.195039]  [<ffffffff8121d71b>] local_pci_probe+0x12/0x16
[    1.195043]  [<ffffffff8121db88>] pci_device_probe+0x60/0x8f
[    1.195048]  [<ffffffff813082e3>] ? driver_sysfs_add+0x47/0x6c
[    1.195052]  [<ffffffff81308462>] driver_probe_device+0xde/0x178
[    1.195056]  [<ffffffff81308558>] __driver_attach+0x5c/0x80
[    1.195060]  [<ffffffff813084fc>] ? __driver_attach+0x0/0x80
[    1.195063]  [<ffffffff813084fc>] ? __driver_attach+0x0/0x80
[    1.195067]  [<ffffffff81307a47>] bus_for_each_dev+0x54/0x89
[    1.195071]  [<ffffffff8130829a>] driver_attach+0x19/0x1b
[    1.195075]  [<ffffffff81307ee2>] bus_add_driver+0xb4/0x206
[    1.195079]  [<ffffffff81308857>] driver_register+0xb8/0x129
[    1.195083]  [<ffffffff8121ddbe>] __pci_register_driver+0x63/0xd3
[    1.195088]  [<ffffffff81b4f4c4>] ? nouveau_init+0x0/0x52
[    1.195092]  [<ffffffff8129ba89>] drm_init+0x6b/0xd1
[    1.195096]  [<ffffffff81b4f4c4>] ? nouveau_init+0x0/0x52
[    1.195100]  [<ffffffff81b4f514>] nouveau_init+0x50/0x52
[    1.195104]  [<ffffffff810001ef>] do_one_initcall+0x59/0x14e
[    1.195109]  [<ffffffff81b2e68a>] kernel_init+0x144/0x1ce
[    1.195113]  [<ffffffff81003414>] kernel_thread_helper+0x4/0x10
[    1.195117]  [<ffffffff81598a40>] ? restore_args+0x0/0x30
[    1.195121]  [<ffffffff81b2e546>] ? kernel_init+0x0/0x1ce
[    1.195125]  [<ffffffff81003410>] ? kernel_thread_helper+0x0/0x10
[    1.195192] ---[ end trace f31dec58d66d24a5 ]---
[    1.195323] [drm] nouveau 0000:01:00.0: failed to reserve VGA memory
[    1.195360] resource map sanity check conflict: 0x0 0xfffff 0xa0000 0xbffff PCI Bus 0000:00
[    1.195363] ------------[ cut here ]------------
[    1.195366] WARNING: at arch/x86/mm/ioremap.c:98 __ioremap_caller+0x13b/0x3f4()
[    1.195369] Hardware name: Latitude E6500                  
[    1.195371] Info: mapping multiple BARs. Your kernel is fine.
[    1.195373] Modules linked in:
[    1.195376] Pid: 1, comm: swapper Tainted: G        W   2.6.34-rc5-mmotm0428 #1
[    1.195378] Call Trace:
[    1.195382]  [<ffffffff81038936>] warn_slowpath_common+0x80/0x98
[    1.195386]  [<ffffffff810389e2>] warn_slowpath_fmt+0x41/0x43
[    1.195390]  [<ffffffff8102054d>] __ioremap_caller+0x13b/0x3f4
[    1.195394]  [<ffffffff812b27ba>] ? ttm_mem_reg_ioremap+0x54/0x7b
[    1.195399]  [<ffffffff81064ef0>] ? mark_held_locks+0x52/0x70
[    1.195403]  [<ffffffff810d6aff>] ? kmem_cache_alloc_notrace+0x68/0xc0
[    1.195407]  [<ffffffff8102088f>] ioremap_nocache+0x12/0x14
[    1.195410]  [<ffffffff812b27ba>] ttm_mem_reg_ioremap+0x54/0x7b
[    1.195414]  [<ffffffff812b2b5c>] ttm_bo_move_memcpy+0x5e/0x3e0
[    1.195418]  [<ffffffff812a4d7d>] ? drm_mm_split_at_start+0x79/0x95
[    1.195421]  [<ffffffff8120ec2d>] ? do_raw_spin_unlock+0xd0/0xfa
[    1.195425]  [<ffffffff812c21cf>] nouveau_bo_move+0x19e/0x222
[    1.195429]  [<ffffffff812afe79>] ttm_bo_handle_move_mem+0x1b4/0x2c0
[    1.195433]  [<ffffffff812b1d9e>] ttm_bo_move_buffer+0xf4/0x14d
[    1.195437]  [<ffffffff81210b2d>] ? __list_add+0xb7/0xd2
[    1.195441]  [<ffffffff812b1ee3>] ttm_bo_validate+0xec/0x13e
[    1.195445]  [<ffffffff8120e900>] ? do_raw_write_unlock+0x7e/0xc8
[    1.195448]  [<ffffffff812b2315>] ttm_bo_init+0x3e0/0x419
[    1.195452]  [<ffffffff812c2957>] nouveau_bo_new+0x394/0x405
[    1.195455]  [<ffffffff812c2510>] ? nouveau_bo_del_ttm+0x0/0xb3
[    1.195459]  [<ffffffff81064ef0>] ? mark_held_locks+0x52/0x70
[    1.195463]  [<ffffffff810d56ff>] ? trace_kmalloc+0x40/0xb4
[    1.195468]  [<ffffffff812ea53f>] nv50_instmem_populate+0x6d/0x11a
[    1.195473]  [<ffffffff812bb78a>] nouveau_gpuobj_new+0x252/0x34c
[    1.195477]  [<ffffffff812c0c36>] nouveau_sgdma_init+0x5f/0x241
[    1.195481]  [<ffffffff8121b8ae>] ? pci_find_capability+0x6d/0x7c
[    1.195485]  [<ffffffff812ba3e7>] nouveau_mem_init+0x330/0x42f
[    1.195489]  [<ffffffff812b7e02>] nouveau_card_init+0xb09/0xe35
[    1.195493]  [<ffffffff812b86de>] nouveau_load+0x4e6/0x50c
[    1.195497]  [<ffffffff812a0fee>] drm_get_dev+0x3bf/0x4cc
[    1.195501]  [<ffffffff8158c3be>] nouveau_pci_probe+0x10/0x12
[    1.195505]  [<ffffffff8121d71b>] local_pci_probe+0x12/0x16
[    1.195509]  [<ffffffff8121db88>] pci_device_probe+0x60/0x8f
[    1.195513]  [<ffffffff813082e3>] ? driver_sysfs_add+0x47/0x6c
[    1.195517]  [<ffffffff81308462>] driver_probe_device+0xde/0x178
[    1.195521]  [<ffffffff81308558>] __driver_attach+0x5c/0x80
[    1.195525]  [<ffffffff813084fc>] ? __driver_attach+0x0/0x80
[    1.195528]  [<ffffffff813084fc>] ? __driver_attach+0x0/0x80
[    1.195532]  [<ffffffff81307a47>] bus_for_each_dev+0x54/0x89
[    1.195536]  [<ffffffff8130829a>] driver_attach+0x19/0x1b
[    1.195540]  [<ffffffff81307ee2>] bus_add_driver+0xb4/0x206
[    1.195544]  [<ffffffff81308857>] driver_register+0xb8/0x129
[    1.195548]  [<ffffffff8121ddbe>] __pci_register_driver+0x63/0xd3
[    1.195552]  [<ffffffff81b4f4c4>] ? nouveau_init+0x0/0x52
[    1.195556]  [<ffffffff8129ba89>] drm_init+0x6b/0xd1
[    1.195560]  [<ffffffff81b4f4c4>] ? nouveau_init+0x0/0x52
[    1.195563]  [<ffffffff81b4f514>] nouveau_init+0x50/0x52
[    1.195567]  [<ffffffff810001ef>] do_one_initcall+0x59/0x14e
[    1.195571]  [<ffffffff81b2e68a>] kernel_init+0x144/0x1ce
[    1.195575]  [<ffffffff81003414>] kernel_thread_helper+0x4/0x10
[    1.195579]  [<ffffffff81598a40>] ? restore_args+0x0/0x30
[    1.195582]  [<ffffffff81b2e546>] ? kernel_init+0x0/0x1ce
[    1.195586]  [<ffffffff81003410>] ? kernel_thread_helper+0x0/0x10
[    1.195588] ---[ end trace f31dec58d66d24a6 ]---
[    1.195597] [drm] nouveau 0000:01:00.0: error getting PRAMIN backing pages: -12
[    1.195693] [drm] nouveau 0000:01:00.0: Error creating sgdma object: -12
[    1.195784] [drm] nouveau 0000:01:00.0: Error initialising PCI(E): -12
[    1.196854] nouveau 0000:01:00.0: PCI INT A disabled
[    1.196863] nouveau: probe of 0000:01:00.0 failed with error -12



--==_Exmh_1273161966_4019P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFL4ujucC3lWbTT17ARAqCfAKC7f0qhs8nSonDX2vmZDlRlun/g7wCfSo07
lI4bPFmyTGtaFROueXdcomk=
=zOwi
-----END PGP SIGNATURE-----

--==_Exmh_1273161966_4019P--

