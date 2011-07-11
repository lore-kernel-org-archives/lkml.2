Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655Ab1GKOK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:10:57 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35619 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757512Ab1GKOK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:10:56 -0400
Subject: [PATCH 2/2] Input: lifebook - make dmi callback functions return 1
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Vojtech Pavlik <vojtech@suse.cz>, Alessandro Rubini <rubini@cvml.unipv.it>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
In-Reply-To: <1310393256.2415.2.camel@phoenix>
References: <1310393256.2415.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jul 2011 22:10:48 +0800
Message-ID: <1310393448.2415.5.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only care about if there is any successful match from the table (or no match at all),
we can make dmi_check_system return immediately if we have a successful match
instead of iterate thorough the whole table.

Make the dmi callback function return 1 then dmi_check_system
will return immediately if we have a successful match.

I think current implementation already assumes there is exactly one match
or no match at all. If there are multiple successful matches then it is a bug,
because new matches will override some variables such as lifebook_use_6byte_proto
and desired_serio_phys.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/mouse/lifebook.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/input/mouse/lifebook.c b/drivers/input/mouse/lifebook.c
index c31ad11..d21becb 100644
--- a/drivers/input/mouse/lifebook.c
+++ b/drivers/input/mouse/lifebook.c
@@ -30,10 +30,15 @@ static bool lifebook_present;
 
 static const char *desired_serio_phys;
 
+static int lifebook_found(const struct dmi_system_id *d)
+{
+	return 1;
+}
+
 static int lifebook_limit_serio3(const struct dmi_system_id *d)
 {
 	desired_serio_phys = "isa0060/serio3";
-	return 0;
+	return 1;
 }
 
 static bool lifebook_use_6byte_proto;
@@ -41,7 +46,7 @@ static bool lifebook_use_6byte_proto;
 static int lifebook_set_6byte_proto(const struct dmi_system_id *d)
 {
 	lifebook_use_6byte_proto = true;
-	return 0;
+	return 1;
 }
 
 static const struct dmi_system_id __initconst lifebook_dmi_table[] = {
@@ -50,42 +55,49 @@ static const struct dmi_system_id __initconst lifebook_dmi_table[] = {
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "FLORA-ie 55mi"),
 		},
+		.callback = lifebook_found,
 	},
 	{
 		/* LifeBook B */
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Lifebook B Series"),
 		},
+		.callback = lifebook_found,
 	},
 	{
 		/* LifeBook B */
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "LifeBook B Series"),
 		},
+		.callback = lifebook_found,
 	},
 	{
 		/* Lifebook B */
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK B Series"),
 		},
+		.callback = lifebook_found,
 	},
 	{
 		/* Lifebook B-2130 */
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "ZEPHYR"),
 		},
+		.callback = lifebook_found,
 	},
 	{
 		/* Lifebook B213x/B2150 */
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "LifeBook B2131/B2133/B2150"),
 		},
+		.callback = lifebook_found,
 	},
 	{
 		/* Zephyr */
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "ZEPHYR"),
 		},
+		.callback = lifebook_found,
 	},
 	{
 		/* Panasonic CF-18 */
@@ -122,6 +134,7 @@ static const struct dmi_system_id __initconst lifebook_dmi_table[] = {
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "LifeBook B142"),
 		},
+		.callback = lifebook_found,
 	},
 	{ }
 };
-- 
1.7.4.1



