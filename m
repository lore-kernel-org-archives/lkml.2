Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759794Ab2INSGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 14:06:07 -0400
Received: from mail.digium.com ([216.207.245.2]:50925 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956Ab2INSFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 14:05:34 -0400
From: Shaun Ruffell <sruffell@digium.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org
Subject: [PATCH v2 0/3] Fix edac_mc crash in e7xxx_edac error path.
Date: Fri, 14 Sep 2012 12:58:15 -0500
Message-Id: <1347645498-21215-1-git-send-email-sruffell@digium.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1345349484-31552-1-git-send-email-sruffell@digium.com>
References: <1345349484-31552-1-git-send-email-sruffell@digium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2:
Use '!device_is_registered(&mci->dev)' instead of 'if (!mci->bus.name)' to
check if mem_ctl_info has been registered with sysfs.

v1:

With kernel version 3.6-rc2 on a Dell Poweredge 2600 I experienced a NULL
pointer dereference that did not occur with on 3.5. I believe the error is
related to commit de3910eb79a "edac: change the mem allocation scheme to make
Documentation/kobject.txt happy" [1] and the fact that my system is going
through an error path in the e7xxx_edac driver.

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=de3910eb79ac8c0f29a11224661c0ebaaf813039

This is the OOPS:

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


Fengguang Wu (1):
  edac_mc: fix kfree calls in the error path

Shaun Ruffell (2):
  edac: edac_mc_free() cannot assume mem_ctl_info is registered in
    sysfs.
  edac: edac_mc no longer deals with kobjects directly.

 drivers/edac/edac_mc.c | 64 ++++++++++++++++++++++++++++++--------------------
 include/linux/edac.h   |  1 -
 2 files changed, 39 insertions(+), 26 deletions(-)

-- 
1.7.11.2

