Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab1B1Qhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:37:32 -0500
Received: from kroah.org ([198.145.64.141]:48023 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347Ab1B1Qh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:37:26 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:08 2011
Message-Id: <20110228162408.400206817@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:22:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takahiro Yasui <tyasui@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
        maximilian attems <max@stro.at>
Subject: [27/68] dm raid1: fix null pointer dereference in suspend
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Takahiro Yasui <tyasui@redhat.com>

commit 558569aa9d83e016295bac77d900342908d7fd85 upstream.

When suspending a failed mirror, bios are completed by mirror_end_io() and
__rh_lookup() in dm_rh_dec() returns NULL where a non-NULL return value is
required by design.  Fix this by not changing the state of the recovery failed
region from DM_RH_RECOVERING to DM_RH_NOSYNC in dm_rh_recovery_end().

Issue

On 2.6.33-rc1 kernel, I hit the bug when I suspended the failed
mirror by dmsetup command.

BUG: unable to handle kernel NULL pointer dereference at 00000020
IP: [<f94f38e2>] dm_rh_dec+0x35/0xa1 [dm_region_hash]
...
EIP: 0060:[<f94f38e2>] EFLAGS: 00010046 CPU: 0
EIP is at dm_rh_dec+0x35/0xa1 [dm_region_hash]
EAX: 00000286 EBX: 00000000 ECX: 00000286 EDX: 00000000
ESI: eff79eac EDI: eff79e80 EBP: f6915cd4 ESP: f6915cc4
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process dmsetup (pid: 2849, ti=f6914000 task=eff03e80 task.ti=f6914000)
 ...
Call Trace:
 [<f9530af6>] ? mirror_end_io+0x53/0x1b1 [dm_mirror]
 [<f9413104>] ? clone_endio+0x4d/0xa2 [dm_mod]
 [<f9530aa3>] ? mirror_end_io+0x0/0x1b1 [dm_mirror]
 [<f94130b7>] ? clone_endio+0x0/0xa2 [dm_mod]
 [<c02d6bcb>] ? bio_endio+0x28/0x2b
 [<f952f303>] ? hold_bio+0x2d/0x62 [dm_mirror]
 [<f952f942>] ? mirror_presuspend+0xeb/0xf7 [dm_mirror]
 [<c02aa3e2>] ? vmap_page_range+0xb/0xd
 [<f9414c8d>] ? suspend_targets+0x2d/0x3b [dm_mod]
 [<f9414ca9>] ? dm_table_presuspend_targets+0xe/0x10 [dm_mod]
 [<f941456f>] ? dm_suspend+0x4d/0x150 [dm_mod]
 [<f941767d>] ? dev_suspend+0x55/0x18a [dm_mod]
 [<c0343762>] ? _copy_from_user+0x42/0x56
 [<f9417fb0>] ? dm_ctl_ioctl+0x22c/0x281 [dm_mod]
 [<f9417628>] ? dev_suspend+0x0/0x18a [dm_mod]
 [<f9417d84>] ? dm_ctl_ioctl+0x0/0x281 [dm_mod]
 [<c02c3c4b>] ? vfs_ioctl+0x22/0x85
 [<c02c422c>] ? do_vfs_ioctl+0x4cb/0x516
 [<c02c42b7>] ? sys_ioctl+0x40/0x5a
 [<c0202858>] ? sysenter_do_call+0x12/0x28

Analysis

When recovery process of a region failed, dm_rh_recovery_end() function
changes the state of the region from RM_RH_RECOVERING to DM_RH_NOSYNC.
When recovery_complete() is executed between dm_rh_update_states() and
dm_writes() in do_mirror(), bios are processed with the region state,
DM_RH_NOSYNC. However, the region data is freed without checking its
pending count when dm_rh_update_states() is called next time.

When bios are finished by mirror_end_io(), __rh_lookup() in dm_rh_dec()
returns NULL even though a valid return value are expected.

Solution

Remove the state change of the recovery failed region from DM_RH_RECOVERING
to DM_RH_NOSYNC in dm_rh_recovery_end(). We can remove the state change
because:

  - If the region data has been released by dm_rh_update_states(),
    a new region data is created with the state of DM_RH_NOSYNC, and
    bios are processed according to the DM_RH_NOSYNC state.

  - If the region data has not been released by dm_rh_update_states(),
    a state of the region is DM_RH_RECOVERING and bios are put in the
    delayed_bio list.

The flag change from DM_RH_RECOVERING to DM_RH_NOSYNC in dm_rh_recovery_end()
was added in the following commit:
  dm raid1: handle resync failures
  author  Jonathan Brassow <jbrassow@redhat.com>
    Thu, 12 Jul 2007 16:29:04 +0000 (17:29 +0100)
  http://git.kernel.org/linus/f44db678edcc6f4c2779ac43f63f0b9dfa28b724

Signed-off-by: Takahiro Yasui <tyasui@redhat.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-region-hash.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-region-hash.c
+++ b/drivers/md/dm-region-hash.c
@@ -643,10 +643,9 @@ void dm_rh_recovery_end(struct dm_region
 	spin_lock_irq(&rh->region_lock);
 	if (success)
 		list_add(&reg->list, &reg->rh->recovered_regions);
-	else {
-		reg->state = DM_RH_NOSYNC;
+	else
 		list_add(&reg->list, &reg->rh->failed_recovered_regions);
-	}
+
 	spin_unlock_irq(&rh->region_lock);
 
 	rh->wakeup_workers(rh->context);


