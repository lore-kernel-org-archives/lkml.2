Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab1DSRFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 13:05:30 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63944 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab1DSRF2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 13:05:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DOj43a6EFvgJ3Uyt3VH+0ve0jnEd5zodeKnpGURTUfTNcseCWCzaOQ6MpG9Pn4wAnJ
         jHI4NUnDQOxPMhsNTegofGJT9REFvjDNBLqVYlVBTPSShpEFHaJuRHu12uoHVjZ2DGdZ
         jtqb8h2yI1YNaD0vWA9plGSBkqPwDlOJNlYQY=
MIME-Version: 1.0
In-Reply-To: <1303228009.3171.18.camel@mulgrave.site>
References: <20110415135144.GE8828@tiehlicka.suse.cz>
	<alpine.LSU.2.00.1104171952040.22679@sister.anvils>
	<20110418100131.GD8925@tiehlicka.suse.cz>
	<20110418135637.5baac204.akpm@linux-foundation.org>
	<20110419111004.GE21689@tiehlicka.suse.cz>
	<1303228009.3171.18.camel@mulgrave.site>
Date: Tue, 19 Apr 2011 20:05:27 +0300
X-Google-Sender-Auth: GA6HwfTy1VhcELrssSPHa6oMhCg
Message-ID: <BANLkTimYrD_Sby_u-fPSwn-RJJyEVavU5w@mail.gmail.com>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to expand_upwards
From: Pekka Enberg <penberg@kernel.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 6:46 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> It compiles OK, but crashes on boot in fsck.  The crash is definitely mm
> but looks to be a slab problem (it's a null deref on a spinlock in
> add_partial(), which seems unrelated to this patch).
>
> [   15.628000] sd 1:0:2:0: [sdc] Attached SCSI disk
> done.
> [   16.632000] EXT3-fs: barriers not enabled
> [   16.640000] kjournald starting.  Commit interval 5 seconds
> [   16.640000] EXT3-fs (sda3): mounted filesystem with ordered data mode
> Begin: Running /scripts/local-bottom ... done.
> done.
> Begin: Running /scripts/init-bottom ... done.
> INIT: version 2.88 booting
> Setting hostname to 'ion'...done.
> Starting the hotplug events dispatcher: udevd[   22.008000] udev[211]: starting version 164
> .
> Synthesizing the initial hotplug events...done.
> Waiting for /dev to be fully populated...done.
> Activating swap:swapon on /dev/sda2
> swapon: /dev/sda2: found swap signature: version 1, page-size 4, same byte order
> swapon: /dev/sda2: pagesize=4096, swapsize=1028157440, devsize=1028160000
> [   28.780000] Adding 1004056k swap on /dev/sda2.  Priority:-1 extents:1 across:1004056k
> .
> Will now check root file system:fsck from util-linux-ng 2.17.2
> [/sbin/fsck.ext3 (1) -- /] fsck.ext3 -a -C0 /dev/sda3
> /dev/sda3 has been mounted 37 times without being checked, check forced.
> [  257.192000] Backtrace:===========                                \ 42.8%
> [  257.192000]  [<0000000040214f78>] add_partial+0x28/0x98
> [  257.192000]  [<0000000040217ff8>] __slab_free+0x1d0/0x1d8
> [  257.192000]  [<000000004021825c>] kmem_cache_free+0xc4/0x128
> [  257.192000]  [<00000000401fd1a4>] remove_vma+0x8c/0xc0
> [  257.192000]  [<00000000401fd3a8>] exit_mmap+0x1d0/0x220
> [  257.192000]  [<0000000040156514>] mmput+0xd4/0x200
> [  257.192000]  [<000000004015c7b8>] exit_mm+0x100/0x2c0
> [  257.192000]  [<000000004015ef40>] do_exit+0x778/0x9d8
> [  257.192000]  [<000000004015f1ec>] do_group_exit+0x4c/0xe0
> [  257.192000]  [<000000004015f298>] sys_exit_group+0x18/0x28
> [  257.192000]  [<0000000040106034>] syscall_exit+0x0/0x14
> [  257.192000]
> [  257.192000]
> [  257.192000] Kernel Fault: Code=26 regs=00000040bf1807d0 (Addr=0000000000000000)
> [  257.192000]
> [  257.192000]      YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
> [  257.192000] PSW: 00001000000001001111000000001110 Not tainted
> [  257.192000] r00-03  000000ff0804f00e 0000000040769e40 0000000040214f78 0000000000000000
> [  257.192000] r04-07  0000000040746e40 0000000000000001 0000004080ded370 0000000000000001
> [  257.192000] r08-11  0000000040654150 0000000000000000 0000000000000001 0000000000000001
> [  257.192000] r12-15  0000000000000000 00000000ffffffff 0000000000000024 0000000000000000
> [  257.192000] r16-19  00000000fb4ead9c 00000000fb4eac54 0000000000000000 0000000000000000
> [  257.192000] r20-23  000000000800000e 0000000000000001 000000007bbb7180 00000000401fd1a4
> [  257.192000] r24-27  0000000000000001 0000004080ded370 0000000000000000 0000000040746e40
> [  257.192000] r28-31  000000007ec0a908 00000040bf1807a0 00000040bf1807d0 0000000000000016
> [  257.192000] sr00-03  00000000002d9000 0000000000000000 0000000000000000 00000000002d9000
> [  257.192000] sr04-07  0000000000000000 0000000000000000 0000000000000000 0000000000000000
> [  257.192000]
> [  257.192000] IASQ: 0000000000000000 0000000000000000 IAOQ: 000000004011bbc0 000000004011bbc4
> [  257.192000]  IIR: 0f4015dc    ISR: 0000000000000000  IOR: 0000000000000000
> [  257.192000]  CPU:        0   CR30: 00000040bf180000 CR31: fffffff0f0e098e0
> [  257.192000]  ORIG_R28: 0000000040769e40
> [  257.192000]  IAOQ[0]: _raw_spin_lock+0x0/0x20
> [  257.192000]  IAOQ[1]: _raw_spin_lock+0x4/0x20
> [  257.192000]  RP(r2): add_partial+0x28/0x98
> [  257.192000] Backtrace:
> [  257.192000]  [<0000000040214f78>] add_partial+0x28/0x98
> [  257.192000]  [<0000000040217ff8>] __slab_free+0x1d0/0x1d8
> [  257.192000]  [<000000004021825c>] kmem_cache_free+0xc4/0x128
> [  257.192000]  [<00000000401fd1a4>] remove_vma+0x8c/0xc0
> [  257.192000]  [<00000000401fd3a8>] exit_mmap+0x1d0/0x220
> [  257.192000]  [<0000000040156514>] mmput+0xd4/0x200
> [  257.192000]  [<000000004015c7b8>] exit_mm+0x100/0x2c0
> [  257.192000]  [<000000004015ef40>] do_exit+0x778/0x9d8
> [  257.192000]  [<000000004015f1ec>] do_group_exit+0x4c/0xe0
> [  257.192000]  [<000000004015f298>] sys_exit_group+0x18/0x28
> [  257.192000]  [<0000000040106034>] syscall_exit+0x0/0x14
> [  257.192000]
> [  257.192000] Kernel panic - not syncing: Kernel Fault
> [  257.192000] Backtrace:
> [  257.192000]  [<000000004011f984>] show_stack+0x14/0x20
> [  257.192000]  [<000000004011f9a8>] dump_stack+0x18/0x28
> [  257.192000]  [<000000004015946c>] panic+0xd4/0x368
> [  257.192000]  [<0000000040120024>] parisc_terminate+0x14c/0x170
> [  257.192000]  [<000000004012059c>] handle_interruption+0x2ac/0x8f8
> [  257.192000]  [<000000004011bbc0>] _raw_spin_lock+0x0/0x20
> [  257.192000]
> [  257.192000] Rebooting in 5 seconds..
>
> It seems to be a random intermittent mm crash because the next reboot
> crashed with the same trace but after the fsck had completed and the
> third came up to the login prompt.

Looks like a genuine SLUB problem on parisc. Christoph?
