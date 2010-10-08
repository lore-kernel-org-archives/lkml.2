Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057Ab0JHT7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 15:59:34 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:28787 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab0JHT7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 15:59:31 -0400
Subject: [PATCH 04/13] hpsa: limit commands allocated on reset_devices
To: axboe@kernel.dk, James.Bottomley@HansenPartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, thenzl@redhat.com, mike.miller@hp.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 08 Oct 2010 15:06:21 -0500
Message-ID: <20101008200621.24279.97587.stgit@beardog.cce.hp.com>
In-Reply-To: <20101008200453.24279.6638.stgit@beardog.cce.hp.com>
References: <20101008200453.24279.6638.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

This is to conserve memory in a memory-limited kdump scenario

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 542cb2b..ba2becc 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3493,6 +3493,11 @@ static int __devinit hpsa_find_cfgtables(struct ctlr_info *h)
 static void __devinit hpsa_get_max_perf_mode_cmds(struct ctlr_info *h)
 {
 	h->max_commands = readl(&(h->cfgtable->MaxPerformantModeCommands));
+
+	/* Limit commands in memory limited kdump scenario. */
+	if (reset_devices && h->max_commands > 32)
+		h->max_commands = 32;
+
 	if (h->max_commands < 16) {
 		dev_warn(&h->pdev->dev, "Controller reports "
 			"max supported commands of %d, an obvious lie. "

