Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab2A1Pd1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 10:33:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289Ab2A1Pc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 10:32:57 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RFCv2 04/16] drivers/edac: rename channel_info to csrow_channel_info
Date: Sat, 28 Jan 2012 13:32:39 -0200
Message-Id: <1327764771-28649-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327764771-28649-1-git-send-email-mchehab@redhat.com>
References: <1327764771-28649-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newer memory architectures use the term "channel" with a different
meaning.

On a traditional architecture, the memory controller directly
access the memory chips, via csrows and channels.

On some modern architectures like FBDIMM, there's a microcontroller
chip, called Advanced Memory Buffer (AMB) that serves as the interface
between the memory controller and the memory chips.

It is up to the AMB to talk with the csrows of the DRAM chips.

The bus that exchanges information between the memory controller and
the CPU is also called "channel", but it is not associated with
the csrow channel. The entire csrow concept is not even visible to the
memory controller, as using csrows is a task for the AMB.

The drivers that support such memories currently need to fake
information and to abuse on EDAC structures, as the subsystem
was conceived with the idea that the csrow would always be visible
by the CPU.

To make things a  little worse, they don't do it on a consistent
way, as the concepts are not clear enough.

In order to fix it, let's correct the concept of a channel inside
a csrow. Then, we can work to provide a way to represent the
memory on a way that would be more architecture-independent.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc.c |    6 +++---
 include/linux/edac.h   |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 5038239..8776f30 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -43,7 +43,7 @@ static LIST_HEAD(mc_devices);
 
 #ifdef CONFIG_EDAC_DEBUG
 
-static void edac_mc_dump_channel(struct channel_info *chan)
+static void edac_mc_dump_channel(struct csrow_channel_info *chan)
 {
 	debugf4("\tchannel = %p\n", chan);
 	debugf4("\tchannel->chan_idx = %d\n", chan->chan_idx);
@@ -160,7 +160,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
 {
 	struct mem_ctl_info *mci;
 	struct csrow_info *csi, *csrow;
-	struct channel_info *chi, *chp, *chan;
+	struct csrow_channel_info *chi, *chp, *chan;
 	void *pvt;
 	unsigned size;
 	int row, chn;
@@ -185,7 +185,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
 	 * rather than an imaginary chunk of memory located at address 0.
 	 */
 	csi = (struct csrow_info *)(((char *)mci) + ((unsigned long)csi));
-	chi = (struct channel_info *)(((char *)mci) + ((unsigned long)chi));
+	chi = (struct csrow_channel_info *)(((char *)mci) + ((unsigned long)chi));
 	pvt = sz_pvt ? (((char *)mci) + ((unsigned long)pvt)) : NULL;
 
 	/* setup index and various internal pointers */
diff --git a/include/linux/edac.h b/include/linux/edac.h
index 3ba99d7..6e3ab94 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -191,7 +191,7 @@ enum scrub_type {
  * Socket:		A physical connector on the motherboard that accepts
  *			a single memory stick.
  *
- * Channel:		Set of memory devices on a memory stick that must be
+ * Csrow-channel:	Set of memory devices on a memory stick that must be
  *			grouped in parallel with one or more additional
  *			channels from other memory sticks.  This parallel
  *			grouping of the output from multiple channels are
@@ -249,7 +249,7 @@ enum scrub_type {
  * PS - I enjoyed writing all that about as much as you enjoyed reading it.
  */
 
-struct channel_info {
+struct csrow_channel_info {
 	int chan_idx;		/* channel index */
 	u32 ce_count;		/* Correctable Errors for this CHANNEL */
 	char label[EDAC_MC_LABEL_LEN + 1];	/* DIMM label on motherboard */
@@ -276,7 +276,7 @@ struct csrow_info {
 
 	/* channel information for this csrow */
 	u32 nr_channels;
-	struct channel_info *channels;
+	struct csrow_channel_info *channels;
 };
 
 struct mcidev_sysfs_group {
-- 
1.7.8

