Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab2L1T7k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:59:40 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54875 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754203Ab2L1TQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:16:51 -0500
Message-Id: <20121228190332.977358570@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:03:44 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>
Subject: [ 014/173] hwmon: (coretemp) Improve support for TjMax detection on Atom CPUs
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 41e58a1f2b90c88d94b4bd84beb9927a4c2704e9 upstream.

Atom CPUs don't have a register to retrieve TjMax. Detection so far was
incomplete. Use the X86 model ID to improve it.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/coretemp.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -190,6 +190,24 @@ static ssize_t show_temp(struct device *
 	return tdata->valid ? sprintf(buf, "%d\n", tdata->temp) : -EAGAIN;
 }
 
+struct tjmax {
+	char const *id;
+	int tjmax;
+};
+
+static struct tjmax __cpuinitconst tjmax_table[] = {
+	{ "CPU D410", 100000 },
+	{ "CPU D425", 100000 },
+	{ "CPU D510", 100000 },
+	{ "CPU D525", 100000 },
+	{ "CPU N450", 100000 },
+	{ "CPU N455", 100000 },
+	{ "CPU N470", 100000 },
+	{ "CPU N475", 100000 },
+	{ "CPU  230", 100000 },
+	{ "CPU  330", 125000 },
+};
+
 static int adjust_tjmax(struct cpuinfo_x86 *c, u32 id, struct device *dev)
 {
 	/* The 100C is default for both mobile and non mobile CPUs */
@@ -200,6 +218,13 @@ static int adjust_tjmax(struct cpuinfo_x
 	int err;
 	u32 eax, edx;
 	struct pci_dev *host_bridge;
+	int i;
+
+	/* explicit tjmax table entries override heuristics */
+	for (i = 0; i < ARRAY_SIZE(tjmax_table); i++) {
+		if (strstr(c->x86_model_id, tjmax_table[i].id))
+			return tjmax_table[i].tjmax;
+	}
 
 	/* Early chips have no MSR for TjMax */
 


