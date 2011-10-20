Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab1JTVw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 17:52:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394Ab1JTVw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 17:52:57 -0400
Date: Thu, 20 Oct 2011 19:52:31 -0200
From: "Mauro Carvalho Chehab" <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] EDAC: Fix incorrect edac mode reporting in sb_edac
Message-ID: <20111020195231.16c561ad@redhat.com>
In-Reply-To: <cover.1319146957.git.mchehab@redhat.com>
References: <cover.1319146957.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark A. Grondona <mgrondona@llnl.gov>

The edac driver for Sandy Bridge was found to be reporting "FPM"
for edac_mode, which clearly doesn't make sense. It was found that
sb_edac.c:get_dimm_config was reusing a variable for both mem_type
and edac_type, and thus was overwriting the value after setting
it correctly. This patch fixes that issue.

Before the patch:
/sys/devices/system/edac/mc/mc0/csrow0/edac_mode:FPM
/sys/devices/system/edac/mc/mc0/csrow1/edac_mode:FPM
/sys/devices/system/edac/mc/mc0/csrow2/edac_mode:FPM
/sys/devices/system/edac/mc/mc0/csrow3/edac_mode:FPM

After:
/sys/devices/system/edac/mc/mc0/csrow0/edac_mode:S4ECD4ED
/sys/devices/system/edac/mc/mc0/csrow1/edac_mode:S4ECD4ED
/sys/devices/system/edac/mc/mc0/csrow2/edac_mode:S4ECD4ED
/sys/devices/system/edac/mc/mc0/csrow3/edac_mode:S4ECD4ED

Signed-off-by: Mark A. Grondona <mgrondona@llnl.gov>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 8118f12..7a402bf 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -559,6 +559,7 @@ static int get_dimm_config(const struct mem_ctl_info *mci)
 	unsigned long last_page = 0;
 	u32 reg;
 	enum edac_type mode;
+	enum mem_type mtype;
 
 	pci_read_config_dword(pvt->pci_br, SAD_TARGET, &reg);
 	pvt->sbridge_dev->source_id = SOURCE_ID(reg);
@@ -601,10 +602,10 @@ static int get_dimm_config(const struct mem_ctl_info *mci)
 	if (IS_RDIMM_ENABLED(reg)) {
 		/* FIXME: Can also be LRDIMM */
 		debugf0("Memory is registered\n");
-		mode = MEM_RDDR3;
+		mtype = MEM_RDDR3;
 	} else {
 		debugf0("Memory is unregistered\n");
-		mode = MEM_DDR3;
+		mtype = MEM_DDR3;
 	}
 
 	/* On all supported DDR3 DIMM types, there are 8 banks available */
@@ -643,7 +644,7 @@ static int get_dimm_config(const struct mem_ctl_info *mci)
 				csr->dtype = (banks == 8) ? DEV_X8 : DEV_X4;
 				csr->ce_count = 0;
 				csr->ue_count = 0;
-				csr->mtype = mode;
+				csr->mtype = mtype;
 				csr->edac_mode = mode;
 				csr->nr_channels = 1;
 		
