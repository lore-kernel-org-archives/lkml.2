Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab2DPUmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:42:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173Ab2DPUi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:38:59 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: [EDAC ABI v13 22/25] edac: Only expose csrows/channels on legacy API if they're populated
Date: Mon, 16 Apr 2012 17:38:46 -0300
Message-Id: <1334608729-30803-23-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
References: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch actually fixes a bug with the legacy API, where, at the
same csrow, some channels may have different DIMMs. This can happen
on FB-DIMM/RAMBUS and modern Intel controllers.

This is the case, for example, of Nehalem machines:

$ ./edac-ctl --layout
       +-----------------------------------+
       |                mc0                |
       | channel0  | channel1  | channel2  |
-------+-----------------------------------+
slot2: |     0 MB  |     0 MB  |     0 MB  |
slot1: |  1024 MB  |     0 MB  |     0 MB  |
slot0: |  1024 MB  |  1024 MB  |  1024 MB  |
-------+-----------------------------------+

Before this patch, non-filled memories were shown. Now, only what's
filled is there:

grep . /sys/devices/system/edac/mc/mc0/csrow*/ch?*
/sys/devices/system/edac/mc/mc0/csrow0/ch0_ce_count:0
/sys/devices/system/edac/mc/mc0/csrow0/ch0_dimm_label:CPU#0Channel#0_DIMM#0
/sys/devices/system/edac/mc/mc0/csrow0/ch1_ce_count:0
/sys/devices/system/edac/mc/mc0/csrow0/ch1_dimm_label:CPU#0Channel#0_DIMM#1
/sys/devices/system/edac/mc/mc0/csrow1/ch0_ce_count:0
/sys/devices/system/edac/mc/mc0/csrow1/ch0_dimm_label:CPU#0Channel#1_DIMM#0
/sys/devices/system/edac/mc/mc0/csrow2/ch0_ce_count:0
/sys/devices/system/edac/mc/mc0/csrow2/ch0_dimm_label:CPU#0Channel#2_DIMM#0

Thanks-to: Aristeu Rozanski Filho <arozansk@redhat.com>
Reviewed-by: Aristeu Rozanski <arozansk@redhat.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc_sysfs.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 38fccf2..354daec 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -347,6 +347,16 @@ static struct device_attribute *dynamic_csrow_ce_count_attr[] = {
 	&dev_attr_legacy_ch5_ce_count.attr
 };
 
+static inline int nr_pages_per_csrow(struct csrow_info *csrow)
+{
+	int chan, nr_pages = 0;
+
+	for (chan = 0; chan < csrow->nr_channels; chan++)
+		nr_pages += csrow->channels[chan].dimm->nr_pages;
+
+	return nr_pages;
+}
+
 /* Create a CSROW object under specifed edac_mc_device */
 static int edac_create_csrow_object(struct mem_ctl_info *mci,
 				    struct csrow_info *csrow, int index)
@@ -371,6 +381,9 @@ static int edac_create_csrow_object(struct mem_ctl_info *mci,
 		return err;
 
 	for (chan = 0; chan < csrow->nr_channels; chan++) {
+		/* Only expose populated DIMMs */
+		if (!csrow->channels[chan].dimm->nr_pages)
+			continue;
 		err = device_create_file(&csrow->dev,
 					 dynamic_csrow_dimm_attr[chan]);
 		if (err < 0)
@@ -405,6 +418,9 @@ static int edac_create_csrow_objects(struct mem_ctl_info *mci)
 	struct csrow_info *csrow;
 
 	for (i = 0; i < mci->nr_csrows; i++) {
+		csrow = &mci->csrows[i];
+		if (!nr_pages_per_csrow(csrow))
+			continue;
 		err = edac_create_csrow_object(mci, &mci->csrows[i], i);
 		if (err < 0)
 			goto error;
@@ -414,7 +430,11 @@ static int edac_create_csrow_objects(struct mem_ctl_info *mci)
 error:
 	for (--i; i >= 0; i--) {
 		csrow = &mci->csrows[i];
+		if (!nr_pages_per_csrow(csrow))
+			continue;
 		for (chan = csrow->nr_channels - 1; chan >= 0; chan--) {
+			if (!csrow->channels[chan].dimm->nr_pages)
+				continue;
 			device_remove_file(&csrow->dev,
 						dynamic_csrow_dimm_attr[chan]);
 			device_remove_file(&csrow->dev,
@@ -433,7 +453,11 @@ static void edac_delete_csrow_objects(struct mem_ctl_info *mci)
 
 	for (i = mci->nr_csrows - 1; i >= 0; i--) {
 		csrow = &mci->csrows[i];
+		if (!nr_pages_per_csrow(csrow))
+			continue;
 		for (chan = csrow->nr_channels - 1; chan >= 0; chan--) {
+			if (!csrow->channels[chan].dimm->nr_pages)
+				continue;
 			debugf1("Removing csrow %d channel %d sysfs nodes\n",
 				i, chan);
 			device_remove_file(&csrow->dev,
-- 
1.7.8

