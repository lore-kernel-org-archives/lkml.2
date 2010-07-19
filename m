Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966441Ab0GSSmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:42:36 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:44120 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966371Ab0GSSk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:40:57 -0400
Subject: [PATCH 21/26] cciss: sanitize max commands
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Mon, 19 Jul 2010 13:46:28 -0500
Message-ID: <20100719184628.7908.39198.stgit@beardog.cce.hp.com>
In-Reply-To: <20100719184141.7908.26971.stgit@beardog.cce.hp.com>
References: <20100719184141.7908.26971.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: sanitize max commands
Some controllers might try to tell us they support 0 commands
in performant mode.  This is a lie told by buggy firmware.
We have to be wary of this lest we try to allocate a negative
number of command blocks, which will be treated as unsigned,
and get an out of memory condition.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index b3060ec..6d4c4f2 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4112,13 +4112,25 @@ static int __devinit cciss_find_cfgtables(ctlr_info_t *h)
 	return 0;
 }
 
+static void __devinit cciss_get_max_perf_mode_cmds(struct ctlr_info *h)
+{
+	h->max_commands = readl(&(h->cfgtable->MaxPerformantModeCommands));
+	if (h->max_commands < 16) {
+		dev_warn(&h->pdev->dev, "Controller reports "
+			"max supported commands of %d, an obvious lie. "
+			"Using 16.  Ensure that firmware is up to date.\n",
+			h->max_commands);
+		h->max_commands = 16;
+	}
+}
+
 /* Interrogate the hardware for some limits:
  * max commands, max SG elements without chaining, and with chaining,
  * SG chain block size, etc.
  */
 static void __devinit cciss_find_board_params(ctlr_info_t *h)
 {
-	h->max_commands = readl(&(h->cfgtable->MaxPerformantModeCommands));
+	cciss_get_max_perf_mode_cmds(h);
 	h->nr_cmds = h->max_commands - 4; /* Allow room for some ioctls */
 	h->maxsgentries = readl(&(h->cfgtable->MaxSGElements));
 	/*

