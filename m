Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030406Ab2HQJro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 05:47:44 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36049 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653Ab2HQJrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 05:47:43 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH] BUG: clk_find() misses some clocks
Date: Fri, 17 Aug 2012 11:47:23 +0200
Message-Id: <1345196843-23059-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if a clock is declared like that:
CLKDEV_CON_DEV_ID("pioA", "fffff400.gpio", &pioAB_clk)
(so, dev_id AND con_id are defined)
and the driver looks for a dev_id (but no specific con_id) like that:
clock = clk_get(&pdev->dev, NULL);

The clock won't be found:

if (dev_id)
	best_possible += 2; /* dev_id != NULL */
if (con_id)
	best_possible += 1; /* con_id == NULL */
/* => so best possible == 2 */

list_for_each_entry(p, &clocks, node) {
	match = 0;
/*
 * checking p->dev_id = "fffff400.gpio" and p->con_id = "pioA"
 * against dev_id = "fffff400.gpio" and con_id = NULL
 */
	if (p->dev_id) { /* ok, p->dev_id exists */
	 /* and, we are lucky, there's a match ! \o/ */
		if (!dev_id || strcmp(p->dev_id, dev_id))
			continue;
		match += 2;
	}
/* so we have match == 2 */

	if (p->con_id) {
		/* p->con_id is not null */
		if (!con_id || strcmp(p->con_id, con_id))
		/*
		 * too bad !! con_id is null !
		 * even if we have best_possible == match
		 * our clock won't be selected
		 */
			continue;
		match += 1;
	}

	if (match > best_found) {
		cl = p;
		if (match != best_possible)
			best_found = match;
		else
			break;
	}
}

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/clk/clkdev.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index d423c9b..e28b120 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -114,13 +114,13 @@ static struct clk_lookup *clk_find(const char *dev_id, const char *con_id)
 
 	list_for_each_entry(p, &clocks, node) {
 		match = 0;
-		if (p->dev_id) {
-			if (!dev_id || strcmp(p->dev_id, dev_id))
+		if (p->dev_id && dev_id) {
+			if (strcmp(p->dev_id, dev_id))
 				continue;
 			match += 2;
 		}
-		if (p->con_id) {
-			if (!con_id || strcmp(p->con_id, con_id))
+		if (p->con_id && con_id) {
+			if (strcmp(p->con_id, con_id))
 				continue;
 			match += 1;
 		}
-- 
1.7.2.5

