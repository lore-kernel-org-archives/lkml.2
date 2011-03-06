Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab1CFTq1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 14:46:27 -0500
Received: from hylle01.itea.ntnu.no ([129.241.56.100]:39204 "EHLO
	hylle01.itea.ntnu.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab1CFTq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 14:46:26 -0500
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Mar 2011 14:46:26 EST
Date: Sun, 6 Mar 2011 20:42:39 +0100
From: Ole Henrik Jahren <olehenja@alumni.ntnu.no>
To: linux-kernel@vger.kernel.org
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Subject: [PATCH] avr32: fix deadlock when reading clock list in debugfs
Message-ID: <20110306194239.GA9342@siv.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When writing out /sys/kernel/debug/at32ap_clk, clock list lock is being
held while clk_get() is called. clk_get() attempts to take the same
lock, which results in deadlock. Introduce and call lock free version,
__clk_get(), instead.

Signed-off-by: Ole Henrik Jahren <olehenja@alumni.ntnu.no>
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
---
 arch/avr32/mach-at32ap/clock.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/avr32/mach-at32ap/clock.c b/arch/avr32/mach-at32ap/clock.c
index 442f08c..86925fd 100644
--- a/arch/avr32/mach-at32ap/clock.c
+++ b/arch/avr32/mach-at32ap/clock.c
@@ -35,22 +35,30 @@ void at32_clk_register(struct clk *clk)
 	spin_unlock(&clk_list_lock);
 }
 
-struct clk *clk_get(struct device *dev, const char *id)
+static struct clk *__clk_get(struct device *dev, const char *id)
 {
 	struct clk *clk;
 
-	spin_lock(&clk_list_lock);
-
 	list_for_each_entry(clk, &at32_clock_list, list) {
 		if (clk->dev == dev && strcmp(id, clk->name) == 0) {
-			spin_unlock(&clk_list_lock);
 			return clk;
 		}
 	}
 
-	spin_unlock(&clk_list_lock);
 	return ERR_PTR(-ENOENT);
 }
+
+struct clk *clk_get(struct device *dev, const char *id)
+{
+	struct clk *clk;
+
+	spin_lock(&clk_list_lock);
+	clk = __clk_get(dev, id);
+	spin_unlock(&clk_list_lock);
+
+	return clk;
+}
+
 EXPORT_SYMBOL(clk_get);
 
 void clk_put(struct clk *clk)
@@ -257,15 +265,15 @@ static int clk_show(struct seq_file *s, void *unused)
 	spin_lock(&clk_list_lock);
 
 	/* show clock tree as derived from the three oscillators */
-	clk = clk_get(NULL, "osc32k");
+	clk = __clk_get(NULL, "osc32k");
 	dump_clock(clk, &r);
 	clk_put(clk);
 
-	clk = clk_get(NULL, "osc0");
+	clk = __clk_get(NULL, "osc0");
 	dump_clock(clk, &r);
 	clk_put(clk);
 
-	clk = clk_get(NULL, "osc1");
+	clk = __clk_get(NULL, "osc1");
 	dump_clock(clk, &r);
 	clk_put(clk);
 
-- 
1.7.4

