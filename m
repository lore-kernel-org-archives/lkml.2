Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab1ECTyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 15:54:12 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:45623 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab1ECTyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:54:08 -0400
Subject: [PATCH 15/16] cciss: do not use bit 2 doorbell reset
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Date: Tue, 03 May 2011 14:54:07 -0500
Message-ID: <20110503195407.5154.55583.stgit@beardog.cce.hp.com>
In-Reply-To: <20110503194919.5154.78352.stgit@beardog.cce.hp.com>
References: <20110503194919.5154.78352.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

It causes NMIs which are undesirable at best, unsurvivable at worst.
Prefer the soft reset instead.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 865484e..9528e94 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4673,8 +4673,14 @@ static __devinit int cciss_kdump_hard_reset_controller(struct pci_dev *pdev)
 		use_doorbell = DOORBELL_CTLR_RESET2;
 	} else {
 		use_doorbell = misc_fw_support & MISC_FW_DOORBELL_RESET;
-		if (use_doorbell)
-			use_doorbell = DOORBELL_CTLR_RESET;
+		if (use_doorbell) {
+			dev_warn(&pdev->dev, "Controller claims that "
+				"'Bit 2 doorbell reset' is "
+				"supported, but not 'bit 5 doorbell reset'.  "
+				"Firmware update is recommended.\n");
+			rc = -ENOTSUPP; /* use the soft reset */
+			goto unmap_cfgtable;
+		}
 	}
 
 	rc = cciss_controller_hard_reset(pdev, vaddr, use_doorbell);

