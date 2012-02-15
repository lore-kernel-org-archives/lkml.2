Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692Ab2BOM63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 07:58:29 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45996 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016Ab2BOM62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 07:58:28 -0500
Message-ID: <4F3BABF1.8050204@gmail.com>
Date: Wed, 15 Feb 2012 21:58:25 +0900
From: Akio Idehara <zbe64533@gmail.com>
MIME-Version: 1.0
To: linux-input@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix ALPS touchpad detection
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ALPS touchpad detection fails if some buttons of ALPS are pressed.
The reason is that the query response byte is different from what is expected.
This was tested on a Toshiba Portege R500.

Signed-off-by: Akio Idehara <zbe64533@gmail.com>
---
  Documentation/input/alps.txt |    3 ++-
  drivers/input/mouse/alps.c   |    5 +++--
  2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/input/alps.txt b/Documentation/input/alps.txt
index f274c28..2f95308 100644
--- a/Documentation/input/alps.txt
+++ b/Documentation/input/alps.txt
@@ -13,7 +13,8 @@ Detection

  All ALPS touchpads should respond to the "E6 report" command sequence:
  E8-E6-E6-E6-E9. An ALPS touchpad should respond with either 00-00-0A or
-00-00-64.
+00-00-64 if no buttons are pressed. The bits 0-2 of the first byte will be 1s
+if some buttons are pressed.

  If the E6 report is successful, the touchpad model is identified using the "E7
  report" sequence: E8-E7-E7-E7-E9. The response is the model signature and is
diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index bd87380..d161831 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -952,7 +952,8 @@ static const struct alps_model_info *alps_get_model(struct psmouse *psmouse, int

  	/*
  	 * First try "E6 report".
-	 * ALPS should return 0,0,10 or 0,0,100
+	 * ALPS should return 0,0,10 or 0,0,100 if no buttons are pressed.
+	 * The bits 0-2 of the first byte will be 1s if some buttons are pressed.
  	 */
  	param[0] = 0;
  	if (ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES) ||
@@ -968,7 +969,7 @@ static const struct alps_model_info *alps_get_model(struct psmouse *psmouse, int
  	psmouse_dbg(psmouse, "E6 report: %2.2x %2.2x %2.2x",
  		    param[0], param[1], param[2]);

-	if (param[0] != 0 || param[1] != 0 || (param[2] != 10 && param[2] != 100))
+	if ((param[0] & 0xf8) != 0 || param[1] != 0 || (param[2] != 10 && param[2] != 100))
  		return NULL;

  	/*
-- 
1.7.9
