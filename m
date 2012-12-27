Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab2L0MMB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 07:12:01 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:26478 "HELO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752644Ab2L0MLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 07:11:17 -0500
From: Andreas Larsson <andreas@gaisler.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH 1/6] of: Return -EEXIST from of_parse_phandle_with_args for holes in phandle list
Date: Thu, 27 Dec 2012 13:10:42 +0100
Message-Id: <1356610247-11491-2-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1356610247-11491-1-git-send-email-andreas@gaisler.com>
References: <1356610247-11491-1-git-send-email-andreas@gaisler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return value for an empty phandle was -EEXIST before commit 15c9a0ac, that
changed the return value in this case to -ENOENT. However, of_gpio_named_count
relies upon the return value to be -EEXIST and relies upon being able to
distinguish this case from the case of no list at all which also returns
-ENOENT.

Also change the of selftest to expect -EEXIST in this case.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---

I have not run-tested the selftest, not having appropriate hardware around for that.

 drivers/of/base.c     |    4 ++--
 drivers/of/selftest.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 2390ddb..986afd7 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1083,11 +1083,11 @@ int of_parse_phandle_with_args(const struct device_node *np, const char *list_na
 		 * All of the error cases above bail out of the loop, so at
 		 * this point, the parsing is successful. If the requested
 		 * index matches, then fill the out_args structure and return,
-		 * or return -ENOENT for an empty entry.
+		 * or return -EEXIST for an empty entry.
 		 */
 		if (cur_index == index) {
 			if (!phandle)
-				return -ENOENT;
+				return -EEXIST;
 
 			if (out_args) {
 				int i;
diff --git a/drivers/of/selftest.c b/drivers/of/selftest.c
index f24ffd7..b1c2ae9 100644
--- a/drivers/of/selftest.c
+++ b/drivers/of/selftest.c
@@ -54,7 +54,7 @@ static void __init of_selftest_parse_phandle_with_args(void)
 			passed &= (args.args[1] == 0);
 			break;
 		case 2:
-			passed &= (rc == -ENOENT);
+			passed &= (rc == -EEXIST);
 			break;
 		case 3:
 			passed &= !rc;
-- 
1.7.0.4

