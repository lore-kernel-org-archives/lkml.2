Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab1GZQJC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 12:09:02 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:14395 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab1GZQI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 12:08:56 -0400
Subject: [PATCH] hpsa: retry commands completing with status of
	UNSOLICITED_ABORT
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikem@beardog.cce.hp.com, stephenmcameron@gmail.com, thenzl@redhat.com,
        akpm@linux-foundation.org, stable@kernel.org
Date: Tue, 26 Jul 2011 11:08:52 -0500
Message-ID: <20110726160852.7394.78474.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

In a shared SAS setup, target devices may be reset by one of
several hosts, and outstanding commands on that device will be
completed to corresponding hosts with status of UNSOLICITED_ABORT.
Such commands should be retried instead of being treated as i/o
errors.  Also fixed a nearby spelling error.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 6bba23a..b64b29f 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1219,8 +1219,8 @@ static void complete_scsi_command(struct CommandList *cp)
 		dev_warn(&h->pdev->dev, "cp %p reports abort failed\n", cp);
 		break;
 	case CMD_UNSOLICITED_ABORT:
-		cmd->result = DID_RESET << 16;
-		dev_warn(&h->pdev->dev, "cp %p aborted do to an unsolicited "
+		cmd->result = DID_SOFT_ERROR << 16; /* retry the command */
+		dev_warn(&h->pdev->dev, "cp %p aborted due to an unsolicited "
 			"abort\n", cp);
 		break;
 	case CMD_TIMEOUT:

