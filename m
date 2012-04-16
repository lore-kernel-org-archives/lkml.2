Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab2DPUj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:39:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755956Ab2DPUjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:39:24 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ranganathan Desikan <ravi@jetztechnologies.com>,
        "Arvind R." <arvino55@gmail.com>
Subject: [EDAC ABI v13 19/25] i82975x_edac: Test nr_pages earlier to save a few CPU cycles
Date: Mon, 16 Apr 2012 17:38:43 -0300
Message-Id: <1334608729-30803-20-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
References: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid test nr_pages twice, and initializing some data that won't
be used.

Cleanup patch only.

Reported-by: Aristeu Rozanski Filho <arozansk@redhat.com>
Reviewed-by: Aristeu Rozanski <arozansk@redhat.com>
Cc: Ranganathan Desikan <ravi@jetztechnologies.com>
Cc: "Arvind R." <arvino55@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i82975x_edac.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
index ae2a857..df99606 100644
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -410,6 +410,9 @@ static void i82975x_init_csrows(struct mem_ctl_info *mci,
 			cumul_size);
 
 		nr_pages = cumul_size - last_cumul_size;
+		if (!nr_pages)
+			continue;
+
 		/*
 		 * Initialise dram labels
 		 * index values:
@@ -420,9 +423,6 @@ static void i82975x_init_csrows(struct mem_ctl_info *mci,
 		for (chan = 0; chan < csrow->nr_channels; chan++) {
 			dimm = mci->csrows[index].channels[chan].dimm;
 
-			if (!nr_pages)
-				continue;
-
 			dimm->nr_pages = nr_pages / csrow->nr_channels;
 			strncpy(csrow->channels[chan].dimm->label,
 					labels[(index >> 1) + (chan * 2)],
@@ -433,9 +433,6 @@ static void i82975x_init_csrows(struct mem_ctl_info *mci,
 			dimm->edac_mode = EDAC_SECDED; /* only supported */
 		}
 
-		if (!nr_pages)
-			continue;	/* not populated */
-
 		csrow->first_page = last_cumul_size;
 		csrow->last_page = cumul_size - 1;
 		last_cumul_size = cumul_size;
-- 
1.7.8

