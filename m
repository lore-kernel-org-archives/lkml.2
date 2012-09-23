Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab2IWBeX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 21:34:23 -0400
Received: from mail.digium.com ([216.207.245.2]:44187 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413Ab2IWBeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 21:34:20 -0400
Date: Sat, 22 Sep 2012 20:26:38 -0500
From: Shaun Ruffell <sruffell@digium.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Kim Phillips <kim.phillips@freescale.com>, linux-edac@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH] edac_mc: edac_mc_free() cannot assume mem_ctl_info is
 registered in sysfs.
Message-ID: <20120923012638.GA25216@digium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120923001522.GA8383@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix potential NULL pointer dereference in edac_unregister_sysfs() on
system boot introduced in 3.6-rc1. This patch is dependent on
Fengguang's "edac_mc: fix messy kfree calls in the error path".

Since commit 7a623c039 ("edac: rewrite the sysfs code to use struct
device") edac_mc_alloc() no longer initializes embedded kobjects in
struct mem_ctl_info. Therefore edac_mc_free() can no longer simply
decrement a kobject reference count to free the allocated memory
unless the memory controller driver module had also called
edac_mc_add_mc().

Now edac_mc_free() will check if the newly embedded struct device
has been registered with sysfs before using either the standard
device release functions or freeing the data structures itself with
logic pulled out of the error path of edac_mc_alloc().

The BUG this patch resolves for me:

  BUG: unable to handle kernel NULL pointer dereference at   (null)
  IP: [<c045e195>] __wake_up_common+0x1a/0x6a
  *pde = 7f0c6067
  Oops: 0000 [#1] SMP
  Modules linked in: parport_pc parport floppy e7xxx_edac(+) ide_cd_mod edac_core intel_rng cdrom microcode(+) dm_snapshot dm_zero dm_mirror dm_region_hash d
  Pid: 933, comm: modprobe Tainted: G        W    3.6.0-rc2-00111-gc1999ee #12 Dell Computer Corporation PowerEdge 2600             /0F0364
  EIP: 0060:[<c045e195>] EFLAGS: 00010093 CPU: 3
  EIP is at __wake_up_common+0x1a/0x6a
  EAX: f47b0984 EBX: fffffff4 ECX: 00000000 EDX: 00000003
  ESI: f47b0984 EDI: 00000282 EBP: f3dc7d38 ESP: f3dc7d1c
   DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
  CR0: 8005003b CR2: 00000000 CR3: 347d4000 CR4: 000007d0
  DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
  DR6: ffff0ff0 DR7: 00000400
  Process modprobe (pid: 933, ti=f3dc6000 task=f3db9520 task.ti=f3dc6000)
  Stack:
   00000000 00000000 00000003 c046701a f47b0980 f47b0984 00000282 f3dc7d54
   c046703f 00000000 00000000 f47b08b0 f47b08b0 00000000 f3dc7d74 c06961ce
   f3dc7d74 f3dc7d80 c05e2837 c094c4cc f47b08b0 f47b08b0 f3dc7d88 c068d56d
  Call Trace:
   [<c046701a>] ? complete_all+0x1a/0x50
   [<c046703f>] complete_all+0x3f/0x50
   [<c06961ce>] device_pm_remove+0x23/0xa2
   [<c05e2837>] ? kobject_put+0x5b/0x5d
   [<c068d56d>] device_del+0x34/0x142
   [<f8547884>] edac_unregister_sysfs+0x3b/0x5c [edac_core]
   [<f8545041>] edac_mc_free+0x29/0x2f [edac_core]
   [<f860163f>] e7xxx_probe1+0x268/0x311 [e7xxx_edac]
   [<c0603d00>] ? __pci_enable_device_flags+0x8f/0xd3
   [<f8601b0b>] e7xxx_init_one+0x56/0x61 [e7xxx_edac]
   [<c0604f85>] local_pci_probe+0x13/0x15
  ...

Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Shaohui Xie <Shaohui.Xie@freescale.com>
Signed-off-by: Shaun Ruffell <sruffell@digium.com>
---

Hi Linus, I did not bother to resend the third patch [1] since it's
not really *necessary* to boot my system. Fengguang's and this is
sufficient.

[1] http://marc.info/?l=linux-kernel&m=134764597921761&w=2

 drivers/edac/edac_mc.c | 59 +++++++++++++++++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 20 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 9037ffa..d5dc9da 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -199,6 +199,36 @@ void *edac_align_ptr(void **p, unsigned size, int n_elems)
 	return (void *)(((unsigned long)ptr) + align - r);
 }
 
+static void _edac_mc_free(struct mem_ctl_info *mci)
+{
+	int i, chn, row;
+	struct csrow_info *csr;
+	const unsigned int tot_dimms = mci->tot_dimms;
+	const unsigned int tot_channels = mci->num_cschannel;
+	const unsigned int tot_csrows = mci->nr_csrows;
+
+	if (mci->dimms) {
+		for (i = 0; i < tot_dimms; i++)
+			kfree(mci->dimms[i]);
+		kfree(mci->dimms);
+	}
+	if (mci->csrows) {
+		for (row = 0; row < tot_csrows; row++) {
+			csr = mci->csrows[row];
+			if (csr) {
+				if (csr->channels) {
+					for (chn = 0; chn < tot_channels; chn++)
+						kfree(csr->channels[chn]);
+					kfree(csr->channels);
+				}
+				kfree(csr);
+			}
+		}
+		kfree(mci->csrows);
+	}
+	kfree(mci);
+}
+
 /**
  * edac_mc_alloc: Allocate and partially fill a struct mem_ctl_info structure
  * @mc_num:		Memory controller number
@@ -413,26 +443,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
 	return mci;
 
 error:
-	if (mci->dimms) {
-		for (i = 0; i < tot_dimms; i++)
-			kfree(mci->dimms[i]);
-		kfree(mci->dimms);
-	}
-	if (mci->csrows) {
-		for (row = 0; row < tot_csrows; row++) {
-			csr = mci->csrows[row];
-			if (csr) {
-				if (csr->channels) {
-					for (chn = 0; chn < tot_channels; chn++)
-						kfree(csr->channels[chn]);
-					kfree(csr->channels);
-				}
-				kfree(csr);
-			}
-		}
-		kfree(mci->csrows);
-	}
-	kfree(mci);
+	_edac_mc_free(mci);
 
 	return NULL;
 }
@@ -447,6 +458,14 @@ void edac_mc_free(struct mem_ctl_info *mci)
 {
 	edac_dbg(1, "\n");
 
+	/* If we're not yet registered with sysfs free only what was allocated
+	 * in edac_mc_alloc().
+	 */
+	if (!device_is_registered(&mci->dev)) {
+		_edac_mc_free(mci);
+		return;
+	}
+
 	/* the mci instance is freed here, when the sysfs object is dropped */
 	edac_unregister_sysfs(mci);
 }
-- 
1.7.11.6
