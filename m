Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab2IVBGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 21:06:43 -0400
Received: from mail.digium.com ([216.207.245.2]:32788 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468Ab2IVBGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 21:06:41 -0400
Date: Fri, 21 Sep 2012 19:59:05 -0500
From: Shaun Ruffell <sruffell@digium.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Kim Phillips <kim.phillips@freescale.com>, linux-edac@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Linux 3.6-rc6
Message-ID: <20120922005905.GA8335@digium.com>
References: <CA+55aFxMmqG32dJXhUe7N+aS=M1q_5hf7iTfsnPKDU4d610EoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxMmqG32dJXhUe7N+aS=M1q_5hf7iTfsnPKDU4d610EoQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2012 at 03:59:09PM -0700, Linus Torvalds wrote:
> 
> Please do test things out, I'd really like to be able to do the final
> 3.6 soonish..

Linus,

Just a heads up in case you are about to tag v3.6.

v3.6-rc6 still has a regression with edac_mc_alloc()/edac_mc_free()
introduced in commit de3910eb79ac8c0f29a11224661c0ebaaf813039.
edac_mc_free() assumes that struct mem_ctl_info is registered in
sysfs but there are error paths where this is not always the case.

I posted patches [1,2,3] that resolve the issue for me. Shaohui Xie
also hit the issue and posted a slightly different patch [4]. The
patches are currently waiting for Mauro, who I understand is
catching up since returning from San Diego, to check them out.

[1] http://marc.info/?l=linux-kernel&m=134764595921752&w=2
[2] http://marc.info/?l=linux-kernel&m=134764594721747&w=2
[3] http://marc.info/?l=linux-kernel&m=134764597921761&w=2
[4] http://marc.info/?l=linux-kernel&m=134753579818528&w=2

Without the patches I'll always hit on boot:

[  36.703479] BUG: unable to handle kernel NULL pointer dereference at   (null)
[  36.703479] IP: [<c045e195>] __wake_up_common+0x1a/0x6a
[  36.703479] *pde = 7f0c6067
[  36.703479] Oops: 0000 [#1] SMP
[  36.703479] Modules linked in: parport_pc parport floppy e7xxx_edac(+) ide_cd_mod edac_core intel_rng cdrom microcode(+) dm_snapshot dm_zero dm_mirror dm_region_hash d
[  36.703479] Pid: 933, comm: modprobe Tainted: G        W    3.6.0-rc2-00111-gc1999ee #12 Dell Computer Corporation PowerEdge 2600             /0F0364
[  36.703479] EIP: 0060:[<c045e195>] EFLAGS: 00010093 CPU: 3
[  36.703479] EIP is at __wake_up_common+0x1a/0x6a
[  36.703479] EAX: f47b0984 EBX: fffffff4 ECX: 00000000 EDX: 00000003
[  36.703479] ESI: f47b0984 EDI: 00000282 EBP: f3dc7d38 ESP: f3dc7d1c
[  36.703479]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  36.703479] CR0: 8005003b CR2: 00000000 CR3: 347d4000 CR4: 000007d0
[  36.703479] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  36.703479] DR6: ffff0ff0 DR7: 00000400
[  36.703479] Process modprobe (pid: 933, ti=f3dc6000 task=f3db9520 task.ti=f3dc6000)
[  36.703479] Stack:
[  36.703479]  00000000 00000000 00000003 c046701a f47b0980 f47b0984 00000282 f3dc7d54
[  36.703479]  c046703f 00000000 00000000 f47b08b0 f47b08b0 00000000 f3dc7d74 c06961ce
[  36.703479]  f3dc7d74 f3dc7d80 c05e2837 c094c4cc f47b08b0 f47b08b0 f3dc7d88 c068d56d
[  36.703479] Call Trace:
[  36.703479]  [<c046701a>] ? complete_all+0x1a/0x50
[  36.703479]  [<c046703f>] complete_all+0x3f/0x50
[  36.703479]  [<c06961ce>] device_pm_remove+0x23/0xa2
[  36.703479]  [<c05e2837>] ? kobject_put+0x5b/0x5d
[  36.703479]  [<c068d56d>] device_del+0x34/0x142
[  36.703479]  [<f8547884>] edac_unregister_sysfs+0x3b/0x5c [edac_core]
[  36.703479]  [<f8545041>] edac_mc_free+0x29/0x2f [edac_core]
[  36.703479]  [<f860163f>] e7xxx_probe1+0x268/0x311 [e7xxx_edac]
[  36.703479]  [<c0603d00>] ? __pci_enable_device_flags+0x8f/0xd3
[  36.703479]  [<f8601b0b>] e7xxx_init_one+0x56/0x61 [e7xxx_edac]
[  36.703479]  [<c0604f85>] local_pci_probe+0x13/0x15
...

Cheers,
Shaun
