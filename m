Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432Ab1I1Wl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:41:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53978 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932401Ab1I1Wlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:41:52 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:35 2011
Message-Id: <20110928220134.912503295@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [091/244] iommu/amd: Make sure iommu->need_sync contains correct value
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit f1ca1512e765337a7c09eb875eedef8ea4e07654 upstream.

The value is only set to true but never set back to false,
which causes to many completion-wait commands to be sent to
hardware. Fix it with this patch.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/amd_iommu.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -531,7 +531,9 @@ static void build_inv_all(struct iommu_c
  * Writes the command to the IOMMUs command buffer and informs the
  * hardware about the new command.
  */
-static int iommu_queue_command(struct amd_iommu *iommu, struct iommu_cmd *cmd)
+static int iommu_queue_command_sync(struct amd_iommu *iommu,
+				    struct iommu_cmd *cmd,
+				    bool sync)
 {
 	u32 left, tail, head, next_tail;
 	unsigned long flags;
@@ -565,13 +567,18 @@ again:
 	copy_cmd_to_buffer(iommu, cmd, tail);
 
 	/* We need to sync now to make sure all commands are processed */
-	iommu->need_sync = true;
+	iommu->need_sync = sync;
 
 	spin_unlock_irqrestore(&iommu->lock, flags);
 
 	return 0;
 }
 
+static int iommu_queue_command(struct amd_iommu *iommu, struct iommu_cmd *cmd)
+{
+	return iommu_queue_command_sync(iommu, cmd, true);
+}
+
 /*
  * This function queues a completion wait command into the command
  * buffer of an IOMMU
@@ -587,7 +594,7 @@ static int iommu_completion_wait(struct
 
 	build_completion_wait(&cmd, (u64)&sem);
 
-	ret = iommu_queue_command(iommu, &cmd);
+	ret = iommu_queue_command_sync(iommu, &cmd, false);
 	if (ret)
 		return ret;
 


