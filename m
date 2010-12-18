Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751164Ab0LRFJp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 00:09:45 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:36919 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab0LRFJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 00:09:43 -0500
Date: Fri, 17 Dec 2010 21:09:39 -0800
From: Andres Salomon <dilinger@queued.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, dsd@laptop.org, pgf@laptop.org,
        James Cameron <quozl@laptop.org>
Subject: [PATCH] psmouse: disable the synaptics extension on OLPC machines.
Message-ID: <20101217210939.19b6111a@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


OLPC has switched to a Synaptics touchpad.  It turns out that it's
pretty useless in absolute mode.  This patch looks for an OLPC
system (via DMI tables), and refuses to init Synaptics mode in
that scenario (falling back to relative mode).

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/input/mouse/synaptics.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 2e300a4..75fbf33 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -744,15 +744,45 @@ static const struct dmi_system_id __initconst toshiba_dmi_table[] = {
 #endif
 };
 
+static bool broken_olpc_ec;
+
+static const struct dmi_system_id __initconst olpc_dmi_table[] = {
+#if defined(CONFIG_DMI) && defined(CONFIG_OLPC)
+	{
+		/* OLPC XO-1 or XO-1.5 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "OLPC"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "XO"),
+		},
+	},
+	{ }
+#endif
+};
+
 void __init synaptics_module_init(void)
 {
 	impaired_toshiba_kbc = dmi_check_system(toshiba_dmi_table);
+	broken_olpc_ec = dmi_check_system(olpc_dmi_table);
 }
 
 int synaptics_init(struct psmouse *psmouse)
 {
 	struct synaptics_data *priv;
 
+	/*
+	 * The OLPC XO has issues with Synaptics' absolute mode; similarly to
+	 * the HGPK, it quickly degrades and the hardware becomes jumpy and
+	 * overly sensitive.  Not only that, but the constant packet spew
+	 * (even at a lowered 40pps rate) overloads the EC such that key
+	 * presses on the keyboard are missed.  Given all of that, don't
+	 * even attempt to use Synaptics mode.  Relative mode seems to work
+	 * just fine.
+	 */
+	if (broken_olpc_ec) {
+		printk(KERN_INFO "synaptics: OLPC XO detected, not enabling Synaptics protocol.\n");
+		return -ENODEV;
+	}
+
 	psmouse->private = priv = kzalloc(sizeof(struct synaptics_data), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
-- 
1.7.2.3

