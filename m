Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab1DQPsA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 11:48:00 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33882 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab1DQPry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 11:47:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pSIfDRJ/3FpDsGfjEkwjGjXdX+1djk11EIHSncLpxV77oPDhsz/4VE6l1dp56eUmuQ
         pDcK+DQshqda/A0AIRE+sIZsS0d8OxcZ33QcwDre270MArEXIVG4I85PlkM8f9rDRpmX
         2TAqhKGeqOEsftjeaIY4eVAJ6LCFPmvOdFVBo=
Date: Sun, 17 Apr 2011 17:45:57 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Kyle Spaans <kspaans@uwaterloo.ca>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Ben Skeggs <bskeggs@redhat.com>, airlied@redhat.com,
        dri-devel@lists.freedesktop.org, mjg@redhat.com,
        maciej.rutecki@gmail.com, nouveau@lists.freedesktop.org,
        Nigel Cunningham <lkml@nigelcunningham.com.au>,
        Nick Piggin <npiggin@suse.de>
Subject: Re: 2.6.39-rc1 nouveau regression (bisected)
Message-ID: <20110417154557.GA2871@joi.lan>
References: <20110403181206.GA19291@comet.dominikbrodowski.net>
 <20110407151129.GA24977@comet.dominikbrodowski.net>
 <20110414170559.GA10768@comet.dominikbrodowski.net>
 <20110414190117.GA3493@joi.lan>
 <20110415061136.GA21979@isilmar-3.linta.de>
 <4DAA1453.5000604@nigelcunningham.com.au>
 <20110416235028.GA6096@taurine.csclub.uwaterloo.ca>
 <20110417151204.GA24519@taurine.csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110417151204.GA24519@taurine.csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 17, 2011 at 11:12:04AM -0400, Kyle Spaans wrote:
> On Sat, Apr 16, 2011 at 07:50:28PM -0400, Kyle Spaans wrote:
> > On Sun, Apr 17, 2011 at 08:12:35AM +1000, Nigel Cunningham wrote:
> > > On 15/04/11 16:11, Dominik Brodowski wrote:
> > > > On Thu, Apr 14, 2011 at 09:02:01PM +0200, Marcin Slusarz wrote:
> > > >> On Thu, Apr 14, 2011 at 07:05:59PM +0200, Dominik Brodowski wrote:
> > > >>> Thought about CCing Linus to show him that 2.6.39-rcX isn't as "calm"
> > > >>> to everyone, but then chose to CC Maciej instead: Would you be so kind and
> > > >>> add this to your regression list? Thanks!
> > > >>>
> > > >>> Since commit 38f1cff
> > > >>>
> > > >>>     From: Dave Airlie <airlied@redhat.com>
> > > >>>     Date: Wed, 16 Mar 2011 11:34:41 +1000
> > > >>>     Subject: [PATCH] Merge commit '5359533801e3dd3abca5b7d3d985b0b33fd9fe8b' into dr
> > > >>>
> > > >>>     This commit changed an internal radeon structure, that meant a new driver
> > > >>>     in -next had to be fixed up, merge in the commit and fix up the driver.
> > > >>>
> > > >>>     Also fixes a trivial nouveau merge.
> > > >>>
> > > >>>     Conflicts:
> > > >>>         drivers/gpu/drm/nouveau/nouveau_mem.c
> > > >>>
> > > >>> booting my atom/NM10/ION2 system crashes hard during boot, right after
> > > >>> blanking the screen, and before the initramfs gets loaded. I just
> > > >>> re-checked: both parent commits ( 5359533 and 4819d2e ) do indeed work
> > > >>> just fine, but the merge commit ( 38f1cff ) fails, same as tip ( 85f2e68 ).
> > > >> Can you activate netconsole and check whether kernel spits anything interesting?
> > > >> You might try to load nouveau module after boot - maybe something will be saved
> > > >> to /var/log or you could even ssh into the box and check dmesg...
> > > > Compiling it as a module seems to work fine. When I do so, no regression is
> > > > obvious from what gets reported in "dmesg". However, somehow I now do get
> > > > some output: The last message I see is
> > > >
> > > > [drm] nouveau 0000:01:00.0: allocated 1680x1050, fb 0x40.... b0 <some pointer value>
> > > >
> > > > Then, nothing more. However, it really is quite strange why this error only
> > > > appears in the CONFIG_NOUVEAU=y case, not in the =m case...
> > > Try disabling CONFIG_BOOT_LOGO. I reported on freedesktop.org that it is
> > > causing me an oops at boot, but my bug has been ignored there so far -
> > > perhaps I should have posted it here instead.
> > 
> > I'm getting the exact same symptoms on my Atom + ION hardware. Crashes before it
> > can write any logs if it's compiled in and the logo is selected, but boots fine
> > if compiled as a module or the logo is removed.
> > 
> > In my case I bisected and found 8969960 by Nick Piggin (change to mm/vmalloc.c)
> > to be the first bad one in 2.6.38+. This makes me think that it's not a bug in
> > nouveau, but maybe a bug in the order that things are initialized?
> 
> FWIW, reverting commit 89699605fe7cfd8611900346f61cb6cbf179b10a on 2.6.39-rc3+
> makes my system boot just fine with the nouveau drivers compiled into the
> kernel. I've seen some similar looking bugs on LKML that this regression may or
> may not be related to? It works fine on 2.6.38.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=33272
> http://lkml.org/lkml/2011/4/15/194
> 
> I'm still trying to figure out exactly where the kernel is crashing after
> printing
> [drm] nouveau 0000:03:00.0: allocated 1280x1024 fb: 0x40000000, b0 f4cf7600
> 
> Any thoughts on what else I should look for?

I reproduced this bug today, and reverting 89699605fe7cfd8611900346f61cb6cbf179b10a
does not fix it for me. Here's the backtrace:

Entering kdb (current=0xffff8801becb0000, pid 1) on processor 6 Oops: (null)
due to oops @ 0xffffffff81255081
CPU 6 <d>Modules linked in:
<c>
<d>Pid: 1, comm: swapper Not tainted 2.6.39-rc2-nv+ #640<c> System manufacturer System Product Name<c>/P6T SE<c>
<d>RIP: 0010:[<ffffffff81255081>]  [<ffffffff81255081>] iowrite32+0x12/0x34
<d>RSP: 0000:ffff8801becab4b0  EFLAGS: 00010296
<d>RAX: 00000000ffffffff RBX: ffff8801bd334800 RCX: 00000000000016fc
<d>RDX: 00000000ffffffff RSI: ffffc900100bbf4c RDI: ffffc900100bbf4c
<d>RBP: ffff8801becab4b0 R08: 0000000000000002 R09: 0000000000000001
<d>R10: 00000000000000bb R11: ffff8801becab540 R12: ffff8801bd336000
<d>R13: ffff8801bd334818 R14: ffff8801bd600000 R15: 0000000000000020
<d>FS:  0000000000000000(0000) GS:ffff8801bfd80000(0000) knlGS:0000000000000000
<d>CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
<d>CR2: ffffc900100bbf4c CR3: 0000000001a2b000 CR4: 00000000000006e0
<d>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
<d>DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff8801becaa000, task ffff8801becb0000)
<0>Stack:
<c> ffff8801becab4c0<c> ffffffff812f5bd5<c> ffff8801becab4f0<c> ffffffff8130f1f8<c>
<c> ffff8801bd336000<c> ffffc90012a00000<c> ffff8801becab620<c> 0000000000000000<c>
<c> ffff8801becab590<c> ffffffff8127b4c8<c> ffff8801becb0000<c> ffffffff814c8c44<c>
<0>Call Trace:
<0> [<ffffffff812f5bd5>] nouveau_bo_wr32+0x21/0x27
<0> [<ffffffff8130f1f8>] nouveau_fbcon_sync+0x19b/0x26e
<0> [<ffffffff8127b4c8>] cfb_imageblit+0x80/0x450
<0> [<ffffffff814c8c44>] ? __mutex_unlock_slowpath+0x100/0x124
<0> [<ffffffff8109e999>] ? trace_hardirqs_on_caller+0x118/0x13c
<0> [<ffffffff8130f32d>] ? nouveau_fbcon_imageblit+0x62/0xd8
<0> [<ffffffff8130f398>] nouveau_fbcon_imageblit+0xcd/0xd8
<0> [<ffffffff8126ed90>] fb_show_logo+0x5ea/0x73a
<0> [<ffffffff8130f529>] ? nouveau_fbcon_fillrect+0xae/0xd8
<0> [<ffffffff8127900d>] ? bit_clear_margins+0x141/0x14e
<0> [<ffffffff81275f19>] fbcon_switch+0x3fd/0x475
<0> [<ffffffff812c1039>] redraw_screen+0x125/0x1fd
<0> [<ffffffff812c16bb>] bind_con_driver+0x5aa/0x637
<0> [<ffffffff812c1780>] take_over_console+0x38/0x45
<0> [<ffffffff812780e7>] fbcon_takeover+0x57/0x91
<0> [<ffffffff812788c5>] fbcon_event_notify+0x32d/0x65a
<0> [<ffffffff814cdd38>] notifier_call_chain+0x74/0xa1
<0> [<ffffffff81092f9d>] __blocking_notifier_call_chain+0x71/0x8e
<0> [<ffffffff81092fc9>] blocking_notifier_call_chain+0xf/0x11
<0> [<ffffffff8126c74a>] fb_notifier_call_chain+0x16/0x18
<0> [<ffffffff8126d8ca>] register_framebuffer+0x25a/0x271
<0> [<ffffffff812cc770>] drm_fb_helper_single_fb_probe+0x1bd/0x26f
<0> [<ffffffff812ccdc5>] drm_fb_helper_initial_config+0x4a8/0x4bf
<0> [<ffffffff8109e734>] ? mark_held_locks+0x52/0x70
<0> [<ffffffff8130fa88>] nouveau_fbcon_init+0xd4/0xe0
<0> [<ffffffff812ef1eb>] nouveau_card_init+0x109e/0x11b9
<0> [<ffffffff812ef833>] nouveau_load+0x52d/0x56c
<0> [<ffffffff812d9a1e>] drm_get_pci_dev+0x16a/0x26f
<0> [<ffffffff814babf4>] nouveau_pci_probe+0x10/0x12
<0> [<ffffffff812621f7>] local_pci_probe+0x12/0x16
<0> [<ffffffff812629f8>] pci_device_probe+0x60/0x8f
<0> [<ffffffff81367fc4>] ? driver_sysfs_add+0x6b/0x90
<0> [<ffffffff8136810c>] driver_probe_device+0xa7/0x136
<0> [<ffffffff813681f7>] __driver_attach+0x5c/0x80
<0> [<ffffffff8136819b>] ? driver_probe_device+0x136/0x136
<0> [<ffffffff81367914>] bus_for_each_dev+0x54/0x89
<0> [<ffffffff81367f57>] driver_attach+0x19/0x1b
<0> [<ffffffff8136724a>] bus_add_driver+0xcd/0x219
<0> [<ffffffff81368768>] driver_register+0x99/0x10a
<0> [<ffffffff81262c68>] __pci_register_driver+0x63/0xd3
<0> [<ffffffff812d9ba6>] drm_pci_init+0x83/0xe8
<0> [<ffffffff81ad1ab9>] ? ttm_init+0x62/0x62

It crashes on:
nouveau_bo_wr32(chan->notifier_bo, chan->m2mf_ntfy + 3, 0xffffffff);
in nouveau_fbcon_sync.

Marcin
