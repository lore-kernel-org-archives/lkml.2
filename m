Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab2KVSr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:47:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:34455 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761Ab2KVSrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:47:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,299,1352102400"; 
   d="scan'208";a="245772728"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: giometti@enneenne.com
Cc: Jacob Keller <jacob.e.keller@intel.com>, linuxpps@ml.enneenne.com,
        linux-kernel@vger.kernel.org, Rodolfo Giometti <giometti@linux.it>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net] pps: fix a use-after-free memory bug.
Date: Thu, 22 Nov 2012 03:22:28 -0800
Message-Id: <1353583348-12858-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

In the pps_core subsystem, the pps structure is being freed by
"pps_device_destruct" before the character device is removed by
pps_unregister_source. This was discovered by enabling SLUB memory
poisoning. The simple fix is to move kfree(pps) back into
pps_unregister_source instead of inside pps_device_destruct (which
definitely shouldn't be handling the freeing of the pps structure
anyways).

Nov 20 10:59:02 kernel: [   39.118453] =============================================================================
Nov 20 10:59:02 kernel: [   39.118455] BUG kmalloc-512 (Not tainted): Poison overwritten
Nov 20 10:59:02 kernel: [   39.118456] -----------------------------------------------------------------------------
Nov 20 10:59:02 kernel: [   39.118456]
Nov 20 10:59:02 kernel: [   39.118457] Disabling lock debugging due to kernel taint
Nov 20 10:59:02 kernel: [   39.118459] INFO: 0xffff88035c310e30-0xffff88035c310e30. First byte 0x6a instead of 0x6b
Nov 20 10:59:02 kernel: [   39.118469] INFO: Allocated in pps_register_source+0x4f/0x1b0 [pps_core] age=4056 cpu=14 pid=1034
Nov 20 10:59:02 kernel: [   39.118475] 	__slab_alloc+0x4a1/0x525
Nov 20 10:59:02 kernel: [   39.118481] 	kmem_cache_alloc_trace+0x128/0x160
Nov 20 10:59:02 kernel: [   39.118485] 	pps_register_source+0x4f/0x1b0 [pps_core]
Nov 20 10:59:02 kernel: [   39.118489] 	ptp_clock_register+0x2b4/0x360 [ptp]
Nov 20 10:59:02 kernel: [   39.118503] 	ixgbe_ptp_init+0x102/0x220 [ixgbe]
Nov 20 10:59:02 kernel: [   39.118510] 	ixgbe_open+0x4e4/0x550 [ixgbe]
Nov 20 10:59:02 kernel: [   39.118514] 	__dev_open+0x8f/0xf0
Nov 20 10:59:02 kernel: [   39.118516] 	__dev_change_flags+0xa1/0x180
Nov 20 10:59:02 kernel: [   39.118519] 	dev_change_flags+0x28/0x70
Nov 20 10:59:02 kernel: [   39.118522] 	devinet_ioctl+0x5d8/0x6f0
Nov 20 10:59:02 kernel: [   39.118524] 	inet_ioctl+0x75/0x90
Nov 20 10:59:02 kernel: [   39.118527] 	sock_do_ioctl+0x30/0x70
Nov 20 10:59:02 kernel: [   39.118528] 	sock_ioctl+0x7d/0x2b0
Nov 20 10:59:02 kernel: [   39.118531] 	do_vfs_ioctl+0x99/0x580
Nov 20 10:59:02 kernel: [   39.118533] 	sys_ioctl+0x91/0xb0
Nov 20 10:59:02 kernel: [   39.118536] 	system_call_fastpath+0x16/0x1b
Nov 20 10:59:02 kernel: [   39.118541] INFO: Freed in pps_device_destruct+0x5a/0x70 [pps_core] age=1 cpu=12 pid=1045
Nov 20 10:59:02 kernel: [   39.118543] 	__slab_free+0x3f/0x371
Nov 20 10:59:02 kernel: [   39.118546] 	kfree+0x10a/0x150
Nov 20 10:59:02 kernel: [   39.118549] 	pps_device_destruct+0x5a/0x70 [pps_core]
Nov 20 10:59:02 kernel: [   39.118553] 	device_release+0x3d/0xb0
Nov 20 10:59:02 kernel: [   39.118556] 	kobject_cleanup+0x82/0x1b0
Nov 20 10:59:02 kernel: [   39.118558] 	kobject_put+0x2b/0x60
Nov 20 10:59:02 kernel: [   39.118560] 	put_device+0x17/0x20
Nov 20 10:59:02 kernel: [   39.118562] 	device_unregister+0x2a/0x60
Nov 20 10:59:02 kernel: [   39.118564] 	device_destroy+0x3b/0x50
Nov 20 10:59:02 kernel: [   39.118567] 	pps_unregister_cdev+0x2a/0x40 [pps_core]
Nov 20 10:59:02 kernel: [   39.118571] 	pps_unregister_source+0xe/0x10 [pps_core]
Nov 20 10:59:02 kernel: [   39.118574] 	ptp_clock_unregister+0x44/0x70 [ptp]
Nov 20 10:59:02 kernel: [   39.118584] 	ixgbe_ptp_stop+0x31/0x70 [ixgbe]
Nov 20 10:59:02 kernel: [   39.118591] 	ixgbe_close+0x24/0x100 [ixgbe]
Nov 20 10:59:02 kernel: [   39.118593] 	__dev_close_many+0x7d/0xc0
Nov 20 10:59:02 kernel: [   39.118596] 	dev_close_many+0x88/0x100
Nov 20 10:59:02 kernel: [   39.118598] INFO: Slab 0xffffea000d70c400 objects=39 used=39 fp=0x          (null) flags=0x40000000004080
Nov 20 10:59:02 kernel: [   39.118600] INFO: Object 0xffff88035c310d20 @offset=3360 fp=0x          (null)
Nov 20 10:59:02 kernel: [   39.118600]
Nov 20 10:59:02 kernel: [   39.118603] Bytes b4 ffff88035c310d10: 28 f6 fb ff 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a  (.......ZZZZZZZZ
Nov 20 10:59:02 kernel: [   39.118605] Object ffff88035c310d20: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Nov 20 10:59:02 kernel: [   39.118607] Object ffff88035c310d30: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Nov 20 10:59:02 kernel: [   39.118608] Object ffff88035c310d40: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Nov 20 10:59:02 kernel: [   39.118609] Object ffff88035c310d50: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Nov 20 10:59:02 kernel: [   39.118610] Object ffff88035c310d60: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Nov 20 10:59:02 kernel: [   39.118611] Object ffff88035c310d70: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Nov 20 10:59:02 kernel: [   39.118613] Object ffff88035c310d80: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Nov 20 10:59:02 kernel: [   39.118614] Object ffff88035c310d90: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Nov 20 10:59:02 kernel: [   39.118615] Object ffff88035c310da0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Nov 20 10:59:02 kernel: [   39.118616] Object ffff88035c310db0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Nov 20 10:59:02 kernel: [   39.118617] Object ffff88035c310dc0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Nov 20 10:59:02 kernel: [   39.118618] Object ffff88035c310dd0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Nov 20 10:59:02 kernel: [   39.118619] Object ffff88035c310de0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Nov 20 10:59:02 kernel: [   39.118620] Object ffff88035c310df0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Nov 20 10:59:02 kernel: [   39.118621] Object ffff88035c310e00: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Nov 20 10:59:02 kernel: [   39.118623] Object ffff88035c310e10: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Nov 20 10:59:02 kernel: [   39.118624] Object ffff88035c310e20: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Nov 20 10:59:02 kernel: [   39.118625] Object ffff88035c310e30: 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  jkkkkkkkkkkkkkkk
Nov 20 10:59:02 kernel: [   39.118626] Object ffff88035c310e40: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Nov 20 10:59:02 kernel: [   39.118627] Object ffff88035c310e50: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Nov 20 10:59:02 kernel: [   39.118628] Object ffff88035c310e60: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Nov 20 10:59:02 kernel: [   39.118629] Object ffff88035c310e70: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Nov 20 10:59:02 kernel: [   39.118631] Object ffff88035c310e80: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Nov 20 10:59:02 kernel: [   39.118632] Object ffff88035c310e90: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Nov 20 10:59:02 kernel: [   39.118633] Object ffff88035c310ea0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Nov 20 10:59:02 kernel: [   39.118634] Object ffff88035c310eb0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Nov 20 10:59:02 kernel: [   39.118635] Object ffff88035c310ec0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Nov 20 10:59:02 kernel: [   39.118636] Object ffff88035c310ed0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Nov 20 10:59:02 kernel: [   39.118637] Object ffff88035c310ee0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Nov 20 10:59:02 kernel: [   39.118638] Object ffff88035c310ef0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Nov 20 10:59:02 kernel: [   39.118640] Object ffff88035c310f00: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Nov 20 10:59:02 kernel: [   39.118641] Object ffff88035c310f10: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  kkkkkkkkkkkkkkk.
Nov 20 10:59:02 kernel: [   39.118642] Redzone ffff88035c310f20: bb bb bb bb bb bb bb bb                          ........
Nov 20 10:59:02 kernel: [   39.118643] Padding ffff88035c311060: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
Nov 20 10:59:02 kernel: [   39.118646] Pid: 1049, comm: udevd Tainted: G    B        3.7.0-rc3-2012-11-19-broken-00001-g0d81b7e #6
Nov 20 10:59:02 kernel: [   39.118646] Call Trace:
Nov 20 10:59:02 kernel: [   39.118651]  [<ffffffff8117a12d>] ? print_section+0x3d/0x40
Nov 20 10:59:02 kernel: [   39.118654]  [<ffffffff8117ac7e>] print_trailer+0xfe/0x160
Nov 20 10:59:02 kernel: [   39.118657]  [<ffffffff8117b072>] check_bytes_and_report+0xe2/0x120
Nov 20 10:59:02 kernel: [   39.118660]  [<ffffffff8117b34f>] check_object+0x1cf/0x250
Nov 20 10:59:02 kernel: [   39.118664]  [<ffffffff8150c71b>] ? __alloc_skb+0x8b/0x2a0
Nov 20 10:59:02 kernel: [   39.118667]  [<ffffffff81621ce9>] alloc_debug_processing+0x67/0x109
Nov 20 10:59:02 kernel: [   39.118669]  [<ffffffff81622794>] __slab_alloc+0x4a1/0x525
Nov 20 10:59:02 kernel: [   39.118672]  [<ffffffff8150c71b>] ? __alloc_skb+0x8b/0x2a0
Nov 20 10:59:02 kernel: [   39.118674]  [<ffffffff8150c6e7>] ? __alloc_skb+0x57/0x2a0
Nov 20 10:59:02 kernel: [   39.118677]  [<ffffffff8150a9e7>] ? skb_release_data+0xf7/0x110
Nov 20 10:59:02 kernel: [   39.118680]  [<ffffffff8117fdbf>] __kmalloc_node_track_caller+0xaf/0x1f0
Nov 20 10:59:02 kernel: [   39.118683]  [<ffffffff8150c71b>] ? __alloc_skb+0x8b/0x2a0
Nov 20 10:59:02 kernel: [   39.118686]  [<ffffffff8150bc6c>] __kmalloc_reserve+0x3c/0xa0
Nov 20 10:59:02 kernel: [   39.118688]  [<ffffffff8150c6e7>] ? __alloc_skb+0x57/0x2a0
Nov 20 10:59:02 kernel: [   39.118691]  [<ffffffff8150c71b>] __alloc_skb+0x8b/0x2a0
Nov 20 10:59:02 kernel: [   39.118694]  [<ffffffff815040f0>] sock_alloc_send_pskb+0x1d0/0x340
Nov 20 10:59:02 kernel: [   39.118697]  [<ffffffff810bc822>] ? __module_text_address+0x12/0x60
Nov 20 10:59:02 kernel: [   39.118701]  [<ffffffff815b7bcc>] unix_dgram_sendmsg+0x1ac/0x640
Nov 20 10:59:02 kernel: [   39.118704]  [<ffffffff814ff550>] sock_sendmsg+0xb0/0xe0
Nov 20 10:59:02 kernel: [   39.118707]  [<ffffffff81502a3d>] sys_sendto+0x12d/0x180
Nov 20 10:59:02 kernel: [   39.118711]  [<ffffffff8115c473>] ? remove_vma+0x63/0x70
Nov 20 10:59:02 kernel: [   39.118717]  [<ffffffff810db44c>] ? __audit_syscall_entry+0xcc/0x300
Nov 20 10:59:02 kernel: [   39.118719]  [<ffffffff810dba6c>] ? __audit_syscall_exit+0x3ec/0x450
Nov 20 10:59:02 kernel: [   39.118722]  [<ffffffff816326d9>] system_call_fastpath+0x16/0x1b
Nov 20 10:59:02 kernel: [   39.118724] FIX kmalloc-512: Restoring 0xffff88035c310e30-0xffff88035c310e30=0x6b
Nov 20 10:59:02 kernel: [   39.118724]
Nov 20 10:59:02 kernel: [   39.118725] FIX kmalloc-512: Marking all objects used

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
CC: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/pps/kapi.c | 4 +---
 drivers/pps/pps.c  | 1 -
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
index f197e8e..3231176 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -150,9 +150,7 @@ void pps_unregister_source(struct pps_device *pps)
 {
 	pps_kc_remove(pps);
 	pps_unregister_cdev(pps);
-
-	/* don't have to kfree(pps) here because it will be done on
-	 * device destruction */
+	kfree(pps);
 }
 EXPORT_SYMBOL(pps_unregister_source);
 
diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index 2420d5a..00e46e7 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -281,7 +281,6 @@ static void pps_device_destruct(struct device *dev)
 	mutex_unlock(&pps_idr_lock);
 
 	kfree(dev);
-	kfree(pps);
 }
 
 int pps_register_cdev(struct pps_device *pps)
-- 
1.7.11.7

