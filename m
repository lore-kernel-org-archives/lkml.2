Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab1IMDzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 23:55:16 -0400
Received: from smp.if.uj.edu.pl ([149.156.82.206]:43461 "EHLO smp.if.uj.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801Ab1IMDzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 23:55:13 -0400
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Sep 2011 23:55:12 EDT
Date: Tue, 13 Sep 2011 05:49:55 +0200
From: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
To: Dave Airlie <airlied@redhat.com>
Cc: Alex Deucher <alexander.deucher@amd.com>, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Ben Skeggs <bskeggs@redhat.com>, Keith Packard <keithp@keithp.com>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel.daenzer@amd.com>,
        dri-devel@lists.freedesktop.org
Subject: [BUG] drm/radeon: locking problems with page_flip
Message-ID: <20110913034955.GJ23706@smp.if.uj.edu.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_smp.if.uj.edu.pl-13088-1315885800-0001-2"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_smp.if.uj.edu.pl-13088-1315885800-0001-2
Content-Type: multipart/mixed; boundary="a7XSrSxqzVsaECgU"
Content-Disposition: inline


--a7XSrSxqzVsaECgU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello everybody,

I yeasterday discovered pretty nasty issue in radeon / drm code,
and page_flip locking code on my ThinkPad T43.

This is Intel 32 bit machine.

With r300 class GPU.

# lspci  | grep VGA
01:00.0 VGA compatible controller: ATI Technologies Inc M22 [Mobility Radeo=
n X300]
# lspci -v | grep -A 10 VGA
01:00.0 VGA compatible controller: ATI Technologies Inc M22 [Mobility Radeo=
n X300] (prog-if 00 [VGA controller])
	Subsystem: IBM Device 056e
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at c0000000 (32-bit, prefetchable) [size=3D128M]
	I/O ports at 2000 [size=3D256]
	Memory at b0100000 (32-bit, non-prefetchable) [size=3D64K]
	[virtual] Expansion ROM at b0120000 [disabled] [size=3D128K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Express Endpoint, MSI 00
	Capabilities: [80] MSI: Enable- Count=3D1/1 Maskable- 64bit+
	Kernel driver in use: radeon
# lspci -n
01:00.0 0300: 1002:5460

(however kernel do not had MSI support compiled in)

# uname -a
Linux sredniczarny 3.1.0-rc5-t43-prod-00079-ged2888e-dirty #11 SMP Sat Sep =
10 21:12:02 CEST 2011 i686 GNU/Linux

# gcc -v
gcc version 4.6.1 (Debian 4.6.1-10)=20

compiled with -march=3Dpentium-m

# cat /proc/cmdline=20
BOOT_IMAGE=3D/vmlinuz-3.1.0-rc5-t43-prod-00079-ged2888e-dirty \
root=3D/dev/mapper/sredniczarny-root ro \
resume=3D/dev/mapper/sredniczarny-swap_1 \
thinkpad_acpi.fan_control=3D1 \
threadirqs pcie_aspm=3Dforce pci=3Duse_crs apic loapic


# ver_linux
Linux sredniczarny 3.1.0-rc5-t43-prod-00079-ged2888e-dirty #11 SMP Sat Sep =
10 21:12:02 CEST 2011 i686 GNU/Linux
=20
Gnu C                  4.6.1
Gnu make               3.81
binutils               2.21.53.20110910
1.11
util-linux             ./scripts/ver_linux: 23: ./scripts/ver_linux: fdform=
at: not found
mount                  support
module-init-tools      found
Linux C Library        2.13
Dynamic linker (ldd)   2.13
Procps                 3.2.8
Console-tools          0.2.3
oprofile               0.9.6
Sh-utils               8.5
Modules Loaded         usb_storage nls_utf8 nls_cp437 vfat fat pci_stub vbo=
xpci vboxnetadp vboxnetflt vboxdrv pktcdvd ebtable_nat ebtables acpi_cpufre=
q mperf xt_CHECKSUM lib80211_crypt_ccmp uinput nfsd hdaps radeonfb fb_ddc r=
adeon sr_mod i2c_i801 cdrom ipw2200 ttm libipw drm_kms_helper drm i2c_algo_=
bit intel_agp cfbfillrect intel_gtt cfbcopyarea agpgart cfbimgblt raid456 a=
sync_memcpy async_pq async_xor xor async_raid6_recov async_tx raid6_pq pata=
_acpi
#


I was using xfce4 for about an hour (with compositing),
and I then got this

[ 2388.033247] BUG: sleeping function called from invalid context at kernel=
/mutex.c:271
[ 2388.033254] in_atomic(): 1, irqs_disabled(): 1, pid: 4883, name: Xorg
[ 2388.033258] 2 locks held by Xorg/4883:
[ 2388.033261]  #0:  (&dev->mode_config.mutex){+.+.+.}, at: [<f8be18d3>] dr=
m_mode_page_flip_ioctl+0x43/0x1f0 [drm]
[ 2388.033291]  #1:  (&(&dev->event_lock)->rlock#2){......}, at: [<f93d904d=
>] radeon_crtc_page_flip+0xcd/0x560 [radeon]
[ 2388.033329] irq event stamp: 122016268
[ 2388.033331] hardirqs last  enabled at (122016267): [<c1649ec1>] _raw_spi=
n_unlock_irqrestore+0x31/0x60
[ 2388.033341] hardirqs last disabled at (122016268): [<c164a37d>] _raw_spi=
n_lock_irqsave+0x1d/0x60
[ 2388.033347] softirqs last  enabled at (122016074): [<c104fbbc>] irq_exit=
+0xac/0xb0
[ 2388.033355] softirqs last disabled at (122016073): [<c10245f6>] smp_apic=
_timer_interrupt+0x56/0x90
[ 2388.033364] Pid: 4883, comm: Xorg Not tainted 3.1.0-rc5-t43-prod-00079-g=
ed2888e-dirty #11
[ 2388.033368] Call Trace:
[ 2388.033374]  [<c10245f6>] ? smp_apic_timer_interrupt+0x56/0x90
[ 2388.033380]  [<c10381f6>] __might_sleep+0xe6/0x120
[ 2388.033384]  [<c1647e4e>] mutex_lock_nested+0x1e/0x2f0
[ 2388.033389]  [<c164a3b7>] ? _raw_spin_lock_irqsave+0x57/0x60
[ 2388.033409]  [<f93d90a5>] radeon_crtc_page_flip+0x125/0x560 [radeon]
[ 2388.033426]  [<f8be1a4b>] ? drm_mode_page_flip_ioctl+0x1bb/0x1f0 [drm]
[ 2388.033440]  [<f8be19dd>] drm_mode_page_flip_ioctl+0x14d/0x1f0 [drm]
[ 2388.033451]  [<f8bd3143>] drm_ioctl+0x1e3/0x500 [drm]
[ 2388.033469]  [<f8be1890>] ? drm_mode_gamma_get_ioctl+0xd0/0xd0 [drm]
[ 2388.033479]  [<c107886b>] ? trace_hardirqs_off+0xb/0x10
[ 2388.033485]  [<c125e79f>] ? do_raw_spin_lock+0x3f/0x130
[ 2388.033489]  [<c1649ec1>] ? _raw_spin_unlock_irqrestore+0x31/0x60
[ 2388.033501]  [<f8bd2f60>] ? drm_copy_field+0x70/0x70 [drm]
[ 2388.033507]  [<c110380f>] do_vfs_ioctl+0x7f/0x5b0
[ 2388.033518]  [<f8bd3869>] ? drm_read+0x69/0x170 [drm]
[ 2388.033523]  [<c10f4502>] ? fget_light+0x2e2/0x340
[ 2388.033528]  [<c1103d6d>] sys_ioctl+0x2d/0x60
[ 2388.033533]  [<c164ac98>] sysenter_do_call+0x12/0x38
[ 2388.033565]=20
[ 2388.033566] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
[ 2388.033569] [ INFO: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected ]
[ 2388.033573] 3.1.0-rc5-t43-prod-00079-ged2888e-dirty #11
[ 2388.033575] ------------------------------------------------------
[ 2388.033579] Xorg/4883 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
[ 2388.033581]  (&dev->struct_mutex){+.+.+.}, at: [<f93d90a5>] radeon_crtc_=
page_flip+0x125/0x560 [radeon]
[ 2388.033602]=20
[ 2388.033603] and this task is already holding:
[ 2388.033606]  (&(&dev->event_lock)->rlock#2){......}, at: [<f93d904d>] ra=
deon_crtc_page_flip+0xcd/0x560 [radeon]
[ 2388.033627] which would create a new lock dependency:
[ 2388.033630]  (&(&dev->event_lock)->rlock#2){......} -> (&dev->struct_mut=
ex){+.+.+.}
[ 2388.033639]=20
[ 2388.033639] but this new dependency connects a SOFTIRQ-irq-safe lock:
[ 2388.033642]  (&(&dev->vblank_time_lock)->rlock){..-...}
[ 2388.033646] ... which became SOFTIRQ-irq-safe at:
[ 2388.033649]   [<c107b93b>] __lock_acquire+0x57b/0x1790
[ 2388.033654]   [<c107d067>] lock_acquire+0x87/0xb0
[ 2388.033659]   [<c164a3b0>] _raw_spin_lock_irqsave+0x50/0x60
[ 2388.033664]   [<f8bd57f6>] vblank_disable_and_save+0x26/0x1a0 [drm]
[ 2388.033674]   [<f8bd5a25>] vblank_disable_fn+0xb5/0xd0 [drm]
[ 2388.033684]   [<c105602f>] run_timer_softirq+0x10f/0x240
[ 2388.033690]   [<c104f840>] __do_softirq+0x90/0x140
[ 2388.033695]   [<c104f9e7>] run_ksoftirqd+0xf7/0x1b0
[ 2388.033700]   [<c10659b8>] kthread+0x68/0x70
[ 2388.033706]   [<c164b23a>] kernel_thread_helper+0x6/0x10
[ 2388.033711]=20
[ 2388.033712] to a SOFTIRQ-irq-unsafe lock:
[ 2388.033714]  (&dev->struct_mutex){+.+.+.}
[ 2388.033718] ... which became SOFTIRQ-irq-unsafe at:
[ 2388.033720] ...  [<c107b98b>] __lock_acquire+0x5cb/0x1790
[ 2388.033726]   [<c107d067>] lock_acquire+0x87/0xb0
[ 2388.033731]   [<c1647e8d>] mutex_lock_nested+0x5d/0x2f0
[ 2388.033736]   [<f8bd88d0>] drm_get_minor+0x90/0x2c0 [drm]
[ 2388.033746]   [<f8bdacba>] drm_get_pci_dev+0xea/0x260 [drm]
[ 2388.033757]   [<f944af77>] radeon_pci_probe+0xbf/0xc6 [radeon]
[ 2388.033776]   [<c12767ad>] pci_device_probe+0x8d/0x120
[ 2388.033783]   [<c1317446>] driver_probe_device+0x66/0x180
[ 2388.033790]   [<c13175f1>] __driver_attach+0x91/0xa0
[ 2388.033794]   [<c1316661>] bus_for_each_dev+0x41/0x70
[ 2388.033799]   [<c131716c>] driver_attach+0x1c/0x20
[ 2388.033803]   [<c1316e57>] bus_add_driver+0x1a7/0x280
[ 2388.033808]   [<c1317ac5>] driver_register+0x65/0x120
[ 2388.033813]   [<c1276522>] __pci_register_driver+0x52/0xd0
[ 2388.033817]   [<f8bdaf3f>] drm_pci_init+0x10f/0x120 [drm]
[ 2388.033828]   [<f94810d4>] 0xf94810d4
[ 2388.033837]   [<c100302f>] do_one_initcall+0x2f/0x180
[ 2388.033842]   [<c1086606>] sys_init_module+0xb06/0x1c50
[ 2388.033848]   [<c164ac98>] sysenter_do_call+0x12/0x38
[ 2388.033853]=20
[ 2388.033854] other info that might help us debug this:
[ 2388.033855]=20
[ 2388.033858] Chain exists of:
[ 2388.033858]   &(&dev->vblank_time_lock)->rlock --> &(&dev->event_lock)->=
rlock --> &dev->struct_mutex
[ 2388.033867]=20
[ 2388.033869]  Possible interrupt unsafe locking scenario:
[ 2388.033870]=20
[ 2388.033872]        CPU0                    CPU1
[ 2388.033874]        ----                    ----
[ 2388.033876]   lock(&dev->struct_mutex);
[ 2388.033880]                                local_irq_disable();
[ 2388.033883]                                lock(&(&dev->vblank_time_lock=
)->rlock);
[ 2388.033887]                                lock(&(&dev->event_lock)->rlo=
ck);
[ 2388.033892]   <Interrupt>
[ 2388.033893]     lock(&(&dev->vblank_time_lock)->rlock);
[ 2388.033898]=20
[ 2388.033898]  *** DEADLOCK ***
[ 2388.033899]=20
[ 2388.033902] 2 locks held by Xorg/4883:
[ 2388.033904]  #0:  (&dev->mode_config.mutex){+.+.+.}, at: [<f8be18d3>] dr=
m_mode_page_flip_ioctl+0x43/0x1f0 [drm]
[ 2388.033919]  #1:  (&(&dev->event_lock)->rlock#2){......}, at: [<f93d904d=
>] radeon_crtc_page_flip+0xcd/0x560 [radeon]
[ 2388.033942]=20
[ 2388.033943] the dependencies between SOFTIRQ-irq-safe lock and the holdi=
ng lock:
[ 2388.033960]  -> (&(&dev->vblank_time_lock)->rlock){..-...} ops: 261 {
[ 2388.033967]     IN-SOFTIRQ-W at:
[ 2388.033970]                                          [<c107b93b>] __lock=
_acquire+0x57b/0x1790
[ 2388.033976]                                          [<c107d067>] lock_a=
cquire+0x87/0xb0
[ 2388.033982]                                          [<c164a3b0>] _raw_s=
pin_lock_irqsave+0x50/0x60
[ 2388.033987]                                          [<f8bd57f6>] vblank=
_disable_and_save+0x26/0x1a0 [drm]
[ 2388.033999]                                          [<f8bd5a25>] vblank=
_disable_fn+0xb5/0xd0 [drm]
[ 2388.034009]                                          [<c105602f>] run_ti=
mer_softirq+0x10f/0x240
[ 2388.034015]                                          [<c104f840>] __do_s=
oftirq+0x90/0x140
[ 2388.034021]                                          [<c104f9e7>] run_ks=
oftirqd+0xf7/0x1b0
[ 2388.034026]                                          [<c10659b8>] kthrea=
d+0x68/0x70
[ 2388.034032]                                          [<c164b23a>] kernel=
_thread_helper+0x6/0x10
[ 2388.034037]     INITIAL USE at:
[ 2388.034041]                                         [<c107b662>] __lock_=
acquire+0x2a2/0x1790
[ 2388.034047]                                         [<c107d067>] lock_ac=
quire+0x87/0xb0
[ 2388.034052]                                         [<c164a3b0>] _raw_sp=
in_lock_irqsave+0x50/0x60
[ 2388.034058]                                         [<f8bd5ad0>] drm_vbl=
ank_get+0x90/0x260 [drm]
[ 2388.034068]                                         [<f8bd69ad>] drm_vbl=
ank_pre_modeset+0x4d/0x70 [drm]
[ 2388.034080]                                         [<f93cc431>] radeon_=
crtc_dpms+0x101/0x460 [radeon]
[ 2388.034097]                                         [<f8c45626>] drm_hel=
per_disable_unused_functions+0x136/0x150 [drm_kms_helper]
[ 2388.034106]                                         [<f8c4514e>] drm_fb_=
helper_initial_config+0x1e/0x220 [drm_kms_helper]
[ 2388.034113]                                         [<f93e2730>] radeon_=
fbdev_init+0x90/0x100 [radeon]
[ 2388.034133]                                         [<f93db60f>] radeon_=
modeset_init+0x3af/0x930 [radeon]
[ 2388.034152]                                         [<f93b565e>] radeon_=
driver_load_kms+0xce/0x120 [radeon]
[ 2388.034168]                                         [<f8bdad1b>] drm_get=
_pci_dev+0x14b/0x260 [drm]
[ 2388.034180]                                         [<f944af77>] radeon_=
pci_probe+0xbf/0xc6 [radeon]
[ 2388.034199]                                         [<c12767ad>] pci_dev=
ice_probe+0x8d/0x120
[ 2388.034205]                                         [<c1317446>] driver_=
probe_device+0x66/0x180
[ 2388.034211]                                         [<c13175f1>] __drive=
r_attach+0x91/0xa0
[ 2388.034216]                                         [<c1316661>] bus_for=
_each_dev+0x41/0x70
[ 2388.034222]                                         [<c131716c>] driver_=
attach+0x1c/0x20
[ 2388.034227]                                         [<c1316e57>] bus_add=
_driver+0x1a7/0x280
[ 2388.034232]                                         [<c1317ac5>] driver_=
register+0x65/0x120
[ 2388.034238]                                         [<c1276522>] __pci_r=
egister_driver+0x52/0xd0
[ 2388.034243]                                         [<f8bdaf3f>] drm_pci=
_init+0x10f/0x120 [drm]
[ 2388.034255]                                         [<f94810d4>] 0xf9481=
0d4
[ 2388.034260]                                         [<c100302f>] do_one_=
initcall+0x2f/0x180
[ 2388.034265]                                         [<c1086606>] sys_ini=
t_module+0xb06/0x1c50
[ 2388.034271]                                         [<c164ac98>] sysente=
r_do_call+0x12/0x38
[ 2388.034276]   }
[ 2388.034278]   ... key      at: [<f8bef284>] __key.32947+0x0/0xffff6b4a [=
drm]
[ 2388.034289]   ... acquired at:
[ 2388.034291]    [<c107d067>] lock_acquire+0x87/0xb0
[ 2388.034296]    [<c164a3b0>] _raw_spin_lock_irqsave+0x50/0x60
[ 2388.034301]    [<f8bd732a>] drm_handle_vblank_events+0x2a/0x150 [drm]
[ 2388.034312]    [<f8bd75a4>] drm_handle_vblank+0x154/0x1d0 [drm]
[ 2388.034322]    [<f93ea67a>] r100_irq_process+0x3fa/0x5e0 [radeon]
[ 2388.034341]    [<f93e4282>] radeon_driver_irq_handler_kms+0x12/0x20 [rad=
eon]
[ 2388.034360]    [<c109d431>] irq_forced_thread_fn+0x21/0x50
[ 2388.034365]    [<c109d34b>] irq_thread+0x11b/0x1a0
[ 2388.034369]    [<c10659b8>] kthread+0x68/0x70
[ 2388.034374]    [<c164b23a>] kernel_thread_helper+0x6/0x10
[ 2388.034379]=20
[ 2388.034381] -> (&(&dev->event_lock)->rlock#2){......} ops: 267 {
[ 2388.034388]    INITIAL USE at:
[ 2388.034391]                                       [<c107b662>] __lock_ac=
quire+0x2a2/0x1790
[ 2388.034397]                                       [<c107d067>] lock_acqu=
ire+0x87/0xb0
[ 2388.034403]                                       [<c164a3b0>] _raw_spin=
_lock_irqsave+0x50/0x60
[ 2388.034408]                                       [<f8bd732a>] drm_handl=
e_vblank_events+0x2a/0x150 [drm]
[ 2388.034420]                                       [<f8bd75a4>] drm_handl=
e_vblank+0x154/0x1d0 [drm]
[ 2388.034430]                                       [<f93ea67a>] r100_irq_=
process+0x3fa/0x5e0 [radeon]
[ 2388.034450]                                       [<f93e4282>] radeon_dr=
iver_irq_handler_kms+0x12/0x20 [radeon]
[ 2388.034469]                                       [<c109d431>] irq_force=
d_thread_fn+0x21/0x50
[ 2388.034474]                                       [<c109d34b>] irq_threa=
d+0x11b/0x1a0
[ 2388.034479]                                       [<c10659b8>] kthread+0=
x68/0x70
[ 2388.034484]                                       [<c164b23a>] kernel_th=
read_helper+0x6/0x10
[ 2388.034490]  }
[ 2388.034492]  ... key      at: [<f8bef30c>] __key.32935+0x0/0xffff6ac2 [d=
rm]
[ 2388.034503]  ... acquired at:
[ 2388.034505]    [<c1079c24>] check_irq_usage+0x54/0xd0
[ 2388.034510]    [<c107c0f7>] __lock_acquire+0xd37/0x1790
[ 2388.034515]    [<c107d067>] lock_acquire+0x87/0xb0
[ 2388.034519]    [<c1647e8d>] mutex_lock_nested+0x5d/0x2f0
[ 2388.034524]    [<f93d90a5>] radeon_crtc_page_flip+0x125/0x560 [radeon]
[ 2388.034542]    [<f8be19dd>] drm_mode_page_flip_ioctl+0x14d/0x1f0 [drm]
[ 2388.034553]    [<f8bd3143>] drm_ioctl+0x1e3/0x500 [drm]
[ 2388.034563]    [<c110380f>] do_vfs_ioctl+0x7f/0x5b0
[ 2388.034567]    [<c1103d6d>] sys_ioctl+0x2d/0x60
[ 2388.034571]    [<c164ac98>] sysenter_do_call+0x12/0x38
[ 2388.034576]=20
[ 2388.034578]=20
[ 2388.034579] the dependencies between the lock to be acquired and SOFTIRQ=
-irq-unsafe lock:
[ 2388.034595] -> (&dev->struct_mutex){+.+.+.} ops: 2595394 {
[ 2388.034602]    HARDIRQ-ON-W at:
[ 2388.034605]                                        [<c107b95f>] __lock_a=
cquire+0x59f/0x1790
[ 2388.034611]                                        [<c107d067>] lock_acq=
uire+0x87/0xb0
[ 2388.034616]                                        [<c1647e8d>] mutex_lo=
ck_nested+0x5d/0x2f0
[ 2388.034621]                                        [<f8bd88d0>] drm_get_=
minor+0x90/0x2c0 [drm]
[ 2388.034632]                                        [<f8bdacba>] drm_get_=
pci_dev+0xea/0x260 [drm]
[ 2388.034643]                                        [<f944af77>] radeon_p=
ci_probe+0xbf/0xc6 [radeon]
[ 2388.034663]                                        [<c12767ad>] pci_devi=
ce_probe+0x8d/0x120
[ 2388.034669]                                        [<c1317446>] driver_p=
robe_device+0x66/0x180
[ 2388.034674]                                        [<c13175f1>] __driver=
_attach+0x91/0xa0
[ 2388.034680]                                        [<c1316661>] bus_for_=
each_dev+0x41/0x70
[ 2388.034685]                                        [<c131716c>] driver_a=
ttach+0x1c/0x20
[ 2388.034690]                                        [<c1316e57>] bus_add_=
driver+0x1a7/0x280
[ 2388.034696]                                        [<c1317ac5>] driver_r=
egister+0x65/0x120
[ 2388.034701]                                        [<c1276522>] __pci_re=
gister_driver+0x52/0xd0
[ 2388.034707]                                        [<f8bdaf3f>] drm_pci_=
init+0x10f/0x120 [drm]
[ 2388.034718]                                        [<f94810d4>] 0xf94810=
d4
[ 2388.034723]                                        [<c100302f>] do_one_i=
nitcall+0x2f/0x180
[ 2388.034728]                                        [<c1086606>] sys_init=
_module+0xb06/0x1c50
[ 2388.034734]                                        [<c164ac98>] sysenter=
_do_call+0x12/0x38
[ 2388.034740]    SOFTIRQ-ON-W at:
[ 2388.034743]                                        [<c107b98b>] __lock_a=
cquire+0x5cb/0x1790
[ 2388.034749]                                        [<c107d067>] lock_acq=
uire+0x87/0xb0
[ 2388.034754]                                        [<c1647e8d>] mutex_lo=
ck_nested+0x5d/0x2f0
[ 2388.034759]                                        [<f8bd88d0>] drm_get_=
minor+0x90/0x2c0 [drm]
[ 2388.034770]                                        [<f8bdacba>] drm_get_=
pci_dev+0xea/0x260 [drm]
[ 2388.034781]                                        [<f944af77>] radeon_p=
ci_probe+0xbf/0xc6 [radeon]
[ 2388.034801]                                        [<c12767ad>] pci_devi=
ce_probe+0x8d/0x120
[ 2388.034807]                                        [<c1317446>] driver_p=
robe_device+0x66/0x180
[ 2388.034812]                                        [<c13175f1>] __driver=
_attach+0x91/0xa0
[ 2388.034818]                                        [<c1316661>] bus_for_=
each_dev+0x41/0x70
[ 2388.034823]                                        [<c131716c>] driver_a=
ttach+0x1c/0x20
[ 2388.034828]                                        [<c1316e57>] bus_add_=
driver+0x1a7/0x280
[ 2388.034834]                                        [<c1317ac5>] driver_r=
egister+0x65/0x120
[ 2388.034839]                                        [<c1276522>] __pci_re=
gister_driver+0x52/0xd0
[ 2388.034845]                                        [<f8bdaf3f>] drm_pci_=
init+0x10f/0x120 [drm]
[ 2388.034856]                                        [<f94810d4>] 0xf94810=
d4
[ 2388.034861]                                        [<c100302f>] do_one_i=
nitcall+0x2f/0x180
[ 2388.034866]                                        [<c1086606>] sys_init=
_module+0xb06/0x1c50
[ 2388.034872]                                        [<c164ac98>] sysenter=
_do_call+0x12/0x38
[ 2388.034878]    RECLAIM_FS-ON-W at:
[ 2388.034881]                                           [<c107a276>] mark_=
held_locks+0x66/0xf0
[ 2388.034887]                                           [<c107aa4f>] lockd=
ep_trace_alloc+0x7f/0xe0
[ 2388.034892]                                           [<c10e79a8>] kmem_=
cache_alloc+0x28/0x1a0
[ 2388.034898]                                           [<f8bd84da>] drm_m=
aster_create+0x1a/0x90 [drm]
[ 2388.034910]                                           [<f8bd3c5f>] drm_o=
pen+0x25f/0x530 [drm]
[ 2388.034920]                                           [<f8bd4669>] drm_s=
tub_open+0xf9/0x1a0 [drm]
[ 2388.034930]                                           [<c10f6d82>] chrde=
v_open+0xd2/0x1d0
[ 2388.034936]                                           [<c10f07a4>] __den=
try_open.isra.15+0x104/0x2d0
[ 2388.034942]                                           [<c10f1d4c>] namei=
data_to_filp+0x5c/0x70
[ 2388.034948]                                           [<c1100807>] do_la=
st+0x407/0x7f0
[ 2388.034954]                                           [<c1100ccd>] path_=
openat+0x9d/0x350
[ 2388.034960]                                           [<c1100fcc>] do_fi=
lp_open+0x2c/0x80
[ 2388.034965]                                           [<c10f1e48>] do_sy=
s_open+0xe8/0x1b0
[ 2388.034970]                                           [<c10f1f39>] sys_o=
pen+0x29/0x40
[ 2388.034976]                                           [<c164ac98>] sysen=
ter_do_call+0x12/0x38
[ 2388.034981]    INITIAL USE at:
[ 2388.034984]                                       [<c107b662>] __lock_ac=
quire+0x2a2/0x1790
[ 2388.034990]                                       [<c107d067>] lock_acqu=
ire+0x87/0xb0
[ 2388.034996]                                       [<c1647e8d>] mutex_loc=
k_nested+0x5d/0x2f0
[ 2388.035001]                                       [<f8bd88d0>] drm_get_m=
inor+0x90/0x2c0 [drm]
[ 2388.035012]                                       [<f8bdacba>] drm_get_p=
ci_dev+0xea/0x260 [drm]
[ 2388.035023]                                       [<f944af77>] radeon_pc=
i_probe+0xbf/0xc6 [radeon]
[ 2388.035043]                                       [<c12767ad>] pci_devic=
e_probe+0x8d/0x120
[ 2388.035048]                                       [<c1317446>] driver_pr=
obe_device+0x66/0x180
[ 2388.035054]                                       [<c13175f1>] __driver_=
attach+0x91/0xa0
[ 2388.035059]                                       [<c1316661>] bus_for_e=
ach_dev+0x41/0x70
[ 2388.035065]                                       [<c131716c>] driver_at=
tach+0x1c/0x20
[ 2388.035070]                                       [<c1316e57>] bus_add_d=
river+0x1a7/0x280
[ 2388.035075]                                       [<c1317ac5>] driver_re=
gister+0x65/0x120
[ 2388.035081]                                       [<c1276522>] __pci_reg=
ister_driver+0x52/0xd0
[ 2388.035086]                                       [<f8bdaf3f>] drm_pci_i=
nit+0x10f/0x120 [drm]
[ 2388.035098]                                       [<f94810d4>] 0xf94810d4
[ 2388.035103]                                       [<c100302f>] do_one_in=
itcall+0x2f/0x180
[ 2388.035108]                                       [<c1086606>] sys_init_=
module+0xb06/0x1c50
[ 2388.035114]                                       [<c164ac98>] sysenter_=
do_call+0x12/0x38
[ 2388.035119]  }
[ 2388.035121]  ... key      at: [<f8bef314>] __key.32936+0x0/0xffff6aba [d=
rm]
[ 2388.035132]  ... acquired at:
[ 2388.035134]    [<c1079c24>] check_irq_usage+0x54/0xd0
[ 2388.035139]    [<c107c0f7>] __lock_acquire+0xd37/0x1790
[ 2388.035143]    [<c107d067>] lock_acquire+0x87/0xb0
[ 2388.035148]    [<c1647e8d>] mutex_lock_nested+0x5d/0x2f0
[ 2388.035153]    [<f93d90a5>] radeon_crtc_page_flip+0x125/0x560 [radeon]
[ 2388.035171]    [<f8be19dd>] drm_mode_page_flip_ioctl+0x14d/0x1f0 [drm]
[ 2388.035182]    [<f8bd3143>] drm_ioctl+0x1e3/0x500 [drm]
[ 2388.035192]    [<c110380f>] do_vfs_ioctl+0x7f/0x5b0
[ 2388.035196]    [<c1103d6d>] sys_ioctl+0x2d/0x60
[ 2388.035200]    [<c164ac98>] sysenter_do_call+0x12/0x38
[ 2388.035205]=20
[ 2388.035207]=20
[ 2388.035208] stack backtrace:
[ 2388.035211] Pid: 4883, comm: Xorg Not tainted 3.1.0-rc5-t43-prod-00079-g=
ed2888e-dirty #11
[ 2388.035214] Call Trace:
[ 2388.035220]  [<c1640007>] ? printk+0x18/0x1a
[ 2388.035225]  [<c1079bc3>] check_usage+0x3d3/0x3e0
[ 2388.035231]  [<c10853cb>] ? __module_text_address+0xb/0x60
[ 2388.035235]  [<c107823c>] ? __bfs+0xfc/0x1f0
[ 2388.035240]  [<c1079c24>] check_irq_usage+0x54/0xd0
[ 2388.035245]  [<c107c0f7>] __lock_acquire+0xd37/0x1790
[ 2388.035250]  [<c100d8db>] ? show_trace+0x1b/0x30
[ 2388.035255]  [<c163edc4>] ? dump_stack+0x6e/0x75
[ 2388.035259]  [<c107d067>] lock_acquire+0x87/0xb0
[ 2388.035277]  [<f93d90a5>] ? radeon_crtc_page_flip+0x125/0x560 [radeon]
[ 2388.035282]  [<c1647e8d>] mutex_lock_nested+0x5d/0x2f0
[ 2388.035300]  [<f93d90a5>] ? radeon_crtc_page_flip+0x125/0x560 [radeon]
[ 2388.035305]  [<c164a3b7>] ? _raw_spin_lock_irqsave+0x57/0x60
[ 2388.035324]  [<f93d90a5>] radeon_crtc_page_flip+0x125/0x560 [radeon]
[ 2388.035336]  [<f8be1a4b>] ? drm_mode_page_flip_ioctl+0x1bb/0x1f0 [drm]
[ 2388.035347]  [<f8be19dd>] drm_mode_page_flip_ioctl+0x14d/0x1f0 [drm]
[ 2388.035357]  [<f8bd3143>] drm_ioctl+0x1e3/0x500 [drm]
[ 2388.035369]  [<f8be1890>] ? drm_mode_gamma_get_ioctl+0xd0/0xd0 [drm]
[ 2388.035375]  [<c107886b>] ? trace_hardirqs_off+0xb/0x10
[ 2388.035379]  [<c125e79f>] ? do_raw_spin_lock+0x3f/0x130
[ 2388.035384]  [<c1649ec1>] ? _raw_spin_unlock_irqrestore+0x31/0x60
[ 2388.035394]  [<f8bd2f60>] ? drm_copy_field+0x70/0x70 [drm]
[ 2388.035398]  [<c110380f>] do_vfs_ioctl+0x7f/0x5b0
[ 2388.035407]  [<f8bd3869>] ? drm_read+0x69/0x170 [drm]
[ 2388.035412]  [<c10f4502>] ? fget_light+0x2e2/0x340
[ 2388.035416]  [<c1103d6d>] sys_ioctl+0x2d/0x60
[ 2388.035421]  [<c164ac98>] sysenter_do_call+0x12/0x38


then about 400 second of nothing, and then again

[ 2718.766103] BUG: sleeping function called from invalid context at kernel=
/mutex.c:271
[ 2718.766111] in_atomic(): 1, irqs_disabled(): 1, pid: 4883, name: Xorg
[ 2718.766114] INFO: lockdep is turned off.
[ 2718.766117] irq event stamp: 122016268
[ 2718.766119] hardirqs last  enabled at (122016267): [<c1649ec1>] _raw_spi=
n_unlock_irqrestore+0x31/0x60
[ 2718.766132] hardirqs last disabled at (122016268): [<c164a37d>] _raw_spi=
n_lock_irqsave+0x1d/0x60
[ 2718.766138] softirqs last  enabled at (122016074): [<c104fbbc>] irq_exit=
+0xac/0xb0
[ 2718.766146] softirqs last disabled at (122016073): [<c10245f6>] smp_apic=
_timer_interrupt+0x56/0x90
[ 2718.766155] Pid: 4883, comm: Xorg Not tainted 3.1.0-rc5-t43-prod-00079-g=
ed2888e-dirty #11
[ 2718.766158] Call Trace:
[ 2718.766164]  [<c10245f6>] ? smp_apic_timer_interrupt+0x56/0x90
[ 2718.766170]  [<c10381f6>] __might_sleep+0xe6/0x120
[ 2718.766175]  [<c1647e4e>] mutex_lock_nested+0x1e/0x2f0
[ 2718.766180]  [<c164a3b7>] ? _raw_spin_lock_irqsave+0x57/0x60
[ 2718.766213]  [<f93d90a5>] radeon_crtc_page_flip+0x125/0x560 [radeon]
[ 2718.766220]  [<c125e79f>] ? do_raw_spin_lock+0x3f/0x130
[ 2718.766240]  [<f8be1a4b>] ? drm_mode_page_flip_ioctl+0x1bb/0x1f0 [drm]
[ 2718.766252]  [<f8be19dd>] drm_mode_page_flip_ioctl+0x14d/0x1f0 [drm]
[ 2718.766262]  [<f8bd3143>] drm_ioctl+0x1e3/0x500 [drm]
[ 2718.766273]  [<f8be1890>] ? drm_mode_gamma_get_ioctl+0xd0/0xd0 [drm]
[ 2718.766279]  [<c125e79f>] ? do_raw_spin_lock+0x3f/0x130
[ 2718.766289]  [<f8bd3846>] ? drm_read+0x46/0x170 [drm]
[ 2718.766298]  [<f8bd3869>] ? drm_read+0x69/0x170 [drm]
[ 2718.766307]  [<f8bd2f60>] ? drm_copy_field+0x70/0x70 [drm]
[ 2718.766313]  [<c110380f>] do_vfs_ioctl+0x7f/0x5b0
[ 2718.766323]  [<f8bd3869>] ? drm_read+0x69/0x170 [drm]
[ 2718.766328]  [<c10f4395>] ? fget_light+0x175/0x340
[ 2718.766334]  [<c10fc965>] ? path_put+0x15/0x20
[ 2718.766338]  [<c1103d6d>] sys_ioctl+0x2d/0x60
[ 2718.766343]  [<c164ac98>] sysenter_do_call+0x12/0x38

and again 2 second later

and then about 100 times again every one or two seconds for about
7 minutes.
=2E..
[ 2720.955224] BUG: sleeping function called from invalid context at kernel=
/mutex.c:271
=2E..
[ 2721.972288] BUG: sleeping function called from invalid context at kernel=
/mutex.c:271
=2E..
[ 2723.069126] BUG: sleeping function called from invalid context at kernel=
/mutex.c:271
=2E..
[ 2724.195377] BUG: sleeping function called from invalid context at kernel=
/mutex.c:271
=2E..

Rest of message exactly the same (including call trace and *irq enable/disa=
ble infos'

irq event stamp: 122016268

constantly for all this entries.



I somehow managed to switch to text console
(read hit Ctrl-Alt-F1 and wait 5 minutes).

Then i suspendd system from root, and resumed, and after a while again=20

[ 5511.610325] BUG: sleeping function called from invalid context at kernel=
/mutex.c:271
[ 5511.610332] in_atomic(): 1, irqs_disabled(): 1, pid: 4883, name: Xorg
[ 5511.610335] INFO: lockdep is turned off.
[ 5511.610338] irq event stamp: 122016268
[ 5511.610341] hardirqs last  enabled at (122016267): [<c1649ec1>] _raw_spi=
n_unlock_irqrestore+0x31/0x60
[ 5511.610353] hardirqs last disabled at (122016268): [<c164a37d>] _raw_spi=
n_lock_irqsave+0x1d/0x60
[ 5511.610359] softirqs last  enabled at (122016074): [<c104fbbc>] irq_exit=
+0xac/0xb0
[ 5511.610367] softirqs last disabled at (122016073): [<c10245f6>] smp_apic=
_timer_interrupt+0x56/0x90
[ 5511.610376] Pid: 4883, comm: Xorg Not tainted 3.1.0-rc5-t43-prod-00079-g=
ed2888e-dirty #11
[ 5511.610379] Call Trace:
[ 5511.610385]  [<c10245f6>] ? smp_apic_timer_interrupt+0x56/0x90
=2E..

started appearing every second.
[ 5516.460928] BUG: sleeping function called from invalid context at kernel=
/mutex.c:271
=2E..
[ 5517.520232] BUG: sleeping function called from invalid context at kernel=
/mutex.c:271
=2E..
[ 5518.580410] BUG: sleeping function called from invalid context at kernel=
/mutex.c:271
=2E..
[ 5519.640420] BUG: sleeping function called from invalid context at kernel=
/mutex.c:271
=2E..

Everything including call stack and other info was still the same.
including Pid and irq event stamp.


In totaly I had about 14301 call traces in kernel log.


For some reasone, few of the call traces have additionally prinkt
at the bottom of the call trace, like this:
=2E..
[ 8836.910011]  [<c1103d6d>] sys_ioctl+0x2d/0x60
[ 8836.910011]  [<c164ac98>] sysenter_do_call+0x12/0x38
[ 8836.910011]  [<c1640000>] ? printk+0x11/0x1a

This additionall bottom have 1179 of all 14301 call traces.

Additionally there are few other vartiations:

In 40 cases I got this:

[ 9036.646048] Call Trace:
[ 9036.646058]  [<c10245f6>] ? smp_apic_timer_interrupt+0x56/0x90
[ 9036.646070]  [<c10381f6>] __might_sleep+0xe6/0x120
[ 9036.646080]  [<c1647e4e>] mutex_lock_nested+0x1e/0x2f0
[ 9036.646090]  [<c164a3b7>] ? _raw_spin_lock_irqsave+0x57/0x60
[ 9036.646139]  [<f93d90a5>] radeon_crtc_page_flip+0x125/0x560 [radeon]
[ 9036.646152]  [<c125e79f>] ? do_raw_spin_lock+0x3f/0x130
[ 9036.646183]  [<f8be1a4b>] ? drm_mode_page_flip_ioctl+0x1bb/0x1f0 [drm]
[ 9036.646208]  [<f8be19dd>] drm_mode_page_flip_ioctl+0x14d/0x1f0 [drm]
[ 9036.646230]  [<f8bd3143>] drm_ioctl+0x1e3/0x500 [drm]
[ 9036.646255]  [<f8be1890>] ? drm_mode_gamma_get_ioctl+0xd0/0xd0 [drm]
[ 9036.646267]  [<c1037b8a>] ? check_preempt_curr+0x6a/0x80
[ 9036.646277]  [<c125e79f>] ? do_raw_spin_lock+0x3f/0x130
[ 9036.646287]  [<c106f8b5>] ? ktime_get+0x65/0x100
[ 9036.646296]  [<c1023e96>] ? lapic_next_event+0x16/0x20
[ 9036.646307]  [<c1075701>] ? clockevents_program_event+0x81/0x120
[ 9036.646317]  [<c107698f>] ? tick_dev_program_event+0x3f/0x160
[ 9036.646338]  [<f8bd2f60>] ? drm_copy_field+0x70/0x70 [drm]
[ 9036.646349]  [<c110380f>] do_vfs_ioctl+0x7f/0x5b0
[ 9036.646359]  [<c1076acc>] ? tick_program_event+0x1c/0x20
[ 9036.646370]  [<c106a6d2>] ? hrtimer_interrupt+0x152/0x260
[ 9036.646381]  [<c10f4395>] ? fget_light+0x175/0x340
[ 9036.646391]  [<c10fc965>] ? path_put+0x15/0x20
[ 9036.646400]  [<c1103d6d>] sys_ioctl+0x2d/0x60
[ 9036.646411]  [<c164ac98>] sysenter_do_call+0x12/0x38


And 83 like this

[ 9344.357819] Call Trace:
[ 9344.357824]  [<c10245f6>] ? smp_apic_timer_interrupt+0x56/0x90
[ 9344.357830]  [<c10381f6>] __might_sleep+0xe6/0x120
[ 9344.357835]  [<c1647e4e>] mutex_lock_nested+0x1e/0x2f0
[ 9344.357840]  [<c164a3b7>] ? _raw_spin_lock_irqsave+0x57/0x60
[ 9344.357870]  [<f93d90a5>] radeon_crtc_page_flip+0x125/0x560 [radeon]
[ 9344.357877]  [<c125e79f>] ? do_raw_spin_lock+0x3f/0x130
[ 9344.357896]  [<f8be1a4b>] ? drm_mode_page_flip_ioctl+0x1bb/0x1f0 [drm]
[ 9344.357907]  [<f8be19dd>] drm_mode_page_flip_ioctl+0x14d/0x1f0 [drm]
[ 9344.357917]  [<f8bd3143>] drm_ioctl+0x1e3/0x500 [drm]
[ 9344.357929]  [<f8be1890>] ? drm_mode_gamma_get_ioctl+0xd0/0xd0 [drm]
[ 9344.357935]  [<c1036f94>] ? finish_task_switch+0x74/0xd0
[ 9344.357941]  [<c107a4cb>] ? trace_hardirqs_on+0xb/0x10
[ 9344.357946]  [<c1649e72>] ? _raw_spin_unlock_irq+0x22/0x40
[ 9344.357951]  [<c1036f94>] ? finish_task_switch+0x74/0xd0
[ 9344.357955]  [<c1036f52>] ? finish_task_switch+0x32/0xd0
[ 9344.357965]  [<f8bd2f60>] ? drm_copy_field+0x70/0x70 [drm]
[ 9344.357970]  [<c110380f>] do_vfs_ioctl+0x7f/0x5b0
[ 9344.357980]  [<f8bd3869>] ? drm_read+0x69/0x170 [drm]
[ 9344.357985]  [<c107886b>] ? trace_hardirqs_off+0xb/0x10
[ 9344.357990]  [<c10f4395>] ? fget_light+0x175/0x340
[ 9344.357996]  [<c10fc965>] ? path_put+0x15/0x20
[ 9344.358000]  [<c1103d6d>] sys_ioctl+0x2d/0x60
[ 9344.358005]  [<c164ac98>] sysenter_do_call+0x12/0x38
[ 9344.358012]  [<c1640000>] ? printk+0x11/0x1a


All other parameters and information in the BUG section
was the same.

I do not know what will say lockdep about this other call traaces,
as it automatically switches off after first discovered problem.

In all cases system started to become extreamly unresponsive,
Xorg server was essentially doing nothing, keyboard
was dead, and when I was trying to switch to console
it took few minutes (unknown reason - there was no cpu
load, no heavy io, no swap usage at the system at all).
Killing screensaver didn't help in anyway.

I had also xview opened with VERY big image (pgm),
and killed it too, after some time I had pretty responsive
system. still in the same Xorg / xfce session I DISABLED
compositing, but after a while problem started reapering again.
Strange.

I inspected cpu and mem usage, but nothing strange
really was happening.

When I was trying to go back to X console,
sometimes it worked, but sometimes
I got a strange black screen,
which was actually flickering irregularry.

Now, I restarted whole Xorg (without rebooting system),
and have xfce (without compositing), and no problem yet
for few hours.

I do not know if this is regression ( i mostly use gnome).
I also know that on my hardware, xfce with compositiing
on 3.0.0 (distro kernel from debian) was extreamly slow
(opening new window made xorg hang for 10 second).
However it was working without any bugs.
It however can be still the same problem, difference being
just the fact that this hand-compiled in 3.1.0-rcX
have enabled more debuging options including hang-task
detection and lockdep, etc.

Xorg.log doesn't show anything interesting.
Maybe this

=2E..
[ 79310.436] (++) using VT number 8

[ 79310.587] (II) Loading /usr/lib/xorg/modules/drivers/radeon_drv.so
[ 79310.587] (II) [KMS] Kernel modesetting enabled.
[ 79310.587] (**) RADEON(0): Depth 24, (--) framebuffer bpp 32
[ 79310.587] (II) RADEON(0): Pixel depth =3D 24 bits stored in 4 bytes (32 =
bpp pixmaps)
[ 79310.587] (=3D=3D) RADEON(0): Default visual is TrueColor
[ 79310.587] (**) RADEON(0): Option "AccelDFS" "on"
[ 79310.587] (**) RADEON(0): Option "ColorTiling" "on"
[ 79310.587] (**) RADEON(0): Option "AccelMethod" "EXA"
[ 79310.587] (**) RADEON(0): Option "DRI" "true"
[ 79310.588] (=3D=3D) RADEON(0): RGB weight 888
[ 79310.588] (II) RADEON(0): Using 8 bits per RGB (8 bit DAC)
[ 79310.588] (--) RADEON(0): Chipset: "ATI Radeon Mobility X300 (M22) 5460 =
(PCIE)" (ChipID =3D 0x5460)
[ 79310.588] (II) RADEON(0): PCIE card detected
[ 79310.588] drmOpenDevice: node name is /dev/dri/card0
[ 79310.588] drmOpenDevice: open result is 9, (OK)
[ 79310.588] drmOpenByBusid: Searching for BusID pci:0000:01:00.0
[ 79310.588] drmOpenDevice: node name is /dev/dri/card0
[ 79310.588] drmOpenDevice: open result is 9, (OK)
[ 79310.588] drmOpenByBusid: drmOpenMinor returns 9
[ 79310.588] drmOpenByBusid: drmGetBusid reports pci:0000:01:00.0
[ 79310.588] (II) Loading sub module "exa"
[ 79310.588] (II) LoadModule: "exa"
[ 79310.589] (II) Loading /usr/lib/xorg/modules/libexa.so
[ 79310.715] (II) Module exa: vendor=3D"X.Org Foundation"
[ 79310.715]    compiled for 1.11.0, module version =3D 2.5.0
[ 79310.715]    ABI class: X.Org Video Driver, version 11.0
[ 79310.715] (II) RADEON(0): KMS Color Tiling: enabled
[ 79310.715] (II) RADEON(0): KMS Pageflipping: enabled
[ 79310.715] (II) RADEON(0): SwapBuffers wait for vsync: enabled
[ 79310.801] (II) RADEON(0): Output VGA-0 has no monitor section
[ 79310.805] (II) RADEON(0): Output DVI-0 has no monitor section
[ 79310.806] (II) RADEON(0): Output LVDS using monitor section Integrated L=
CD
[ 79310.826] (II) RADEON(0): Output S-video has no monitor section
[ 79310.835] (II) RADEON(0): EDID for output VGA-0
[ 79310.839] (II) RADEON(0): EDID for output DVI-0
[ 79310.840] (II) RADEON(0): EDID for output LVDS
[ 79310.840] (II) RADEON(0): Printing probed modes for output LVDS
[ 79310.840] (II) RADEON(0): Modeline "1400x1050"x50.0   84.96  1400 1432 1=
496 1600  1050 1051 1052 1062 (53.1 kHz)
[ 79310.840] (II) RADEON(0): Modeline "1280x1024"x59.9  109.00  1280 1368 1=
496 1712  1024 1027 1034 1063 -hsync +vsync (63.7 kHz)
[ 79310.840] (II) RADEON(0): Modeline "1280x960"x59.9  101.25  1280 1360 14=
88 1696  960 963 967 996 -hsync +vsync (59.7 kHz)
[ 79310.840] (II) RADEON(0): Modeline "1280x854"x59.9   89.25  1280 1352 14=
80 1680  854 857 867 887 -hsync +vsync (53.1 kHz)
[ 79310.840] (II) RADEON(0): Modeline "1280x800"x59.8   83.50  1280 1352 14=
80 1680  800 803 809 831 -hsync +vsync (49.7 kHz)
[ 79310.840] (II) RADEON(0): Modeline "1280x720"x59.9   74.50  1280 1344 14=
72 1664  720 723 728 748 -hsync +vsync (44.8 kHz)
[ 79310.840] (II) RADEON(0): Modeline "1152x768"x59.8   71.75  1152 1216 13=
28 1504  768 771 781 798 -hsync +vsync (47.7 kHz)
[ 79310.840] (II) RADEON(0): Modeline "1024x768"x59.9   63.50  1024 1072 11=
76 1328  768 771 775 798 -hsync +vsync (47.8 kHz)
[ 79310.840] (II) RADEON(0): Modeline "800x600"x59.9   38.25  800 832 912 1=
024  600 603 607 624 -hsync +vsync (37.4 kHz)
[ 79310.840] (II) RADEON(0): Modeline "848x480"x59.7   31.50  848 872 952 1=
056  480 483 493 500 -hsync +vsync (29.8 kHz)
[ 79310.840] (II) RADEON(0): Modeline "720x480"x59.7   26.75  720 744 808 8=
96  480 483 493 500 -hsync +vsync (29.9 kHz)
[ 79310.840] (II) RADEON(0): Modeline "640x480"x59.4   23.75  640 664 720 8=
00  480 483 487 500 -hsync +vsync (29.7 kHz)
[ 79310.864] (II) RADEON(0): EDID for output S-video
[ 79310.864] (II) RADEON(0): Output VGA-0 disconnected
[ 79310.864] (II) RADEON(0): Output DVI-0 disconnected
[ 79310.864] (II) RADEON(0): Output LVDS connected
[ 79310.864] (II) RADEON(0): Output S-video disconnected
[ 79310.864] (II) RADEON(0): Using exact sizes for initial modes
[ 79310.864] (II) RADEON(0): Output LVDS using initial mode 1400x1050
[ 79310.864] (II) RADEON(0): Using default gamma of (1.0, 1.0, 1.0) unless =
otherwise stated.
[ 79310.864] (II) RADEON(0): mem size init: gart size :1fdff000 vram size: =
s:4000000 visible:3a1c000
[ 79310.864] (II) RADEON(0): EXA: Driver will allow EXA pixmaps in VRAM
[ 79310.864] (=3D=3D) RADEON(0): DPI set to (96, 96)
[ 79310.864] (II) Loading sub module "fb"
[ 79310.864] (II) LoadModule: "fb"
[ 79310.864] (II) Loading /usr/lib/xorg/modules/libfb.so
[ 79310.905] (II) Module fb: vendor=3D"X.Org Foundation"
[ 79310.905]    compiled for 1.11.0, module version =3D 1.0.0
[ 79310.905]    ABI class: X.Org ANSI C Emulation, version 0.4
[ 79310.905] (II) Loading sub module "ramdac"
[ 79310.905] (II) LoadModule: "ramdac"
[ 79310.905] (II) Module "ramdac" already built-in
[ 79310.905] (--) Depth 24 pixmap format is 32 bpp
[ 79310.906] (II) RADEON(0): [DRI2] Setup complete
[ 79310.906] (II) RADEON(0): [DRI2]   DRI driver: r300
[ 79310.906] (II) RADEON(0): Front buffer size: 18600K
[ 79310.906] (II) RADEON(0): VRAM usage limit set to 36813K
[ 79310.906] (=3D=3D) RADEON(0): Backing store disabled
[ 79310.906] (II) RADEON(0): Direct rendering enabled
[ 79310.953] (II) RADEON(0): Render acceleration enabled for R300/R400/R500=
 type cards.
[ 79310.953] (II) RADEON(0): Setting EXA maxPitchBytes
[ 79310.953] (II) EXA(0): Driver allocated offscreen pixmaps
[ 79310.953] (II) EXA(0): Driver registered support for the following opera=
tions:
[ 79310.953] (II)         Solid
[ 79310.953] (II)         Copy
[ 79310.953] (II)         Composite (RENDER acceleration)
[ 79310.953] (II)         UploadToScreen
[ 79310.954] (II)         DownloadFromScreen
[ 79310.954] (II) RADEON(0): Acceleration enabled
[ 79310.954] (=3D=3D) RADEON(0): DPMS enabled
[ 79310.954] (=3D=3D) RADEON(0): Silken mouse enabled
[ 79311.035] (II) RADEON(0): Set up textured video
[ 79311.035] (II) RADEON(0): RandR 1.2 enabled, ignore the following RandR =
disabled message.
=2E..
[ 79311.126] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
[ 79311.126] (II) AIGLX: enabled GLX_INTEL_swap_event
[ 79311.126] (II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_con=
trol
[ 79311.126] (II) AIGLX: enabled GLX_SGI_make_current_read
[ 79311.126] (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objec=
ts
[ 79311.128] (II) AIGLX: Loaded and initialized r300
[ 79311.128] (II) GLX: Initialized DRI2 GL provider for screen 0
[ 79311.183] (II) RADEON(0): Setting screen physical size to 370 x 277
[ 79311.183] (II) RADEON(0): Allocate new frame buffer 1400x1056 stride 1408
[ 79311.183] (II) RADEON(0): VRAM usage limit set to 48326K


Other relevant software ( I use Debian/GNU Linux, unstable)

ii  libdrm-radeon1                                        2.4.26-1         =
                          Userspace interface to radeon-specific kernel DRM=
 services -- runtime
ii  libdrm2                                               2.4.26-1         =
                          Userspace interface to kernel DRM services -- run=
time
ii  xorg                                                  1:7.6+8          =
                          X.Org X Window System
ii  xserver-xorg                                          1:7.6+8          =
                          X.Org X server
ii  xserver-xorg-core                                     2:1.11.0-1       =
                          Xorg X server - core server
ii  xserver-xorg-input-all                                1:7.6+8          =
                          X.Org X server -- input driver metapackage
ii  xserver-xorg-input-evdev                              1:2.6.0-2+b2     =
                          X.Org X server -- evdev input driver
ii  xserver-xorg-input-synaptics                          1.4.1-1+b1       =
                          Synaptics TouchPad driver for X.Org server
ii  xserver-xorg-video-fbdev                              1:0.4.2-4+b2     =
                          X.Org X server -- fbdev display driver
ii  xserver-xorg-video-radeon                             1:6.14.2-2       =
                          X.Org X server -- AMD/ATI Radeon display driver
ii  libegl1-mesa                                          7.11-5           =
                          free implementation of the EGL API -- runtime
ii  libegl1-mesa-drivers                                  7.11-5           =
                          free implementation of the EGL API -- hardware dr=
ivers
ii  libgl1-mesa-dri                                       7.11-5           =
                          free implementation of the OpenGL API -- DRI modu=
les
ii  libgl1-mesa-glx                                       7.11-5           =
                          free implementation of the OpenGL API -- GLX runt=
ime
ii  libglapi-mesa                                         7.11-5           =
                          free implementation of the GL API -- shared libra=
ry
ii  libglu1-mesa                                          7.11-5           =
                          Mesa OpenGL utility library (GLU)
ii  libopenvg1-mesa                                       7.11-5           =
                          free implementation of the OpenVG API -- runtime
ii  libosmesa6                                            7.11-5           =
                          Mesa Off-screen rendering extension
ii  mesa-utils                                            8.0.1-2+b1       =
                          Miscellaneous Mesa GL utilities
ii  xfwm4                                                 4.8.1-4          =
                          window manager of the Xfce project
ii  xfce4                                                 4.8.0.3          =
                          Meta-package for the Xfce Lightweight Desktop Env=
ironment
ii  xfdesktop4                                            4.8.2-2          =
                          xfce desktop background, icons and root menu mana=
ger


I was using clear xfce profile. It was create maybe
5 days ago.

Kernel config attached.

Regards,
Witek

--=20
Witold Baryluk

--a7XSrSxqzVsaECgU
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="config-3.1.0-rc5-t43-prod-00079-ged2888e-dirty.gz"
Content-Transfer-Encoding: base64

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

--a7XSrSxqzVsaECgU--

--=_smp.if.uj.edu.pl-13088-1315885800-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk5u0uIACgkQ7ZLFFOttZ4IUyQCgu92aCrWc3GLklX90X+ffYY9c
KbgAn2KSmci4JdeWCnU4OrZ9PEKrZDhz
=UCEC
-----END PGP SIGNATURE-----

--=_smp.if.uj.edu.pl-13088-1315885800-0001-2--
