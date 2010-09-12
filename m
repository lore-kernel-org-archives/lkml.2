Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab0ILQc5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 12:32:57 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33373 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab0ILQc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 12:32:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=XTZPa7potlEOtVbKB+ITk2iskHNaL4Opv1j+fd9MRXK30dBz6IcUEaWp2zTPByyERP
         bK8ENdZWrwcnhVHO6lO9QgvpN1/Wm95kPr2GXWlBL9XcvbxncFWaodMKvm581Um/Id0j
         1RON+SG+3V/2+O7ohY4DGQivTtwpGVqhxA2ps=
Date: Sun, 12 Sep 2010 18:26:28 +0200
From: Ole Henrik Jahren <olehenja@alumni.ntnu.no>
To: kernel@avr32linux.org
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] avr32: fix deadlock when reading clock list in debugfs
Message-ID: <20100912162628.GA15423@siv>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ole Henrik Jahren <olehenja@alumni.ntnu.no>

clk_show() already has clk_list_lock. Make a version of clk_get(),
clk_get_locked(), that does not attempt to take the lock a second time.

Signed-off-by: Ole Henrik Jahren <olehenja@alumni.ntnu.no>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 arch/avr32/mach-at32ap/clock.c |   27 ++++++++++++++++++++-------
 1 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/avr32/mach-at32ap/clock.c b/arch/avr32/mach-at32ap/clock.c
index 442f08c..3951993 100644
--- a/arch/avr32/mach-at32ap/clock.c
+++ b/arch/avr32/mach-at32ap/clock.c
@@ -35,22 +35,30 @@ void at32_clk_register(struct clk *clk)
 	spin_unlock(&clk_list_lock);
 }
 
-struct clk *clk_get(struct device *dev, const char *id)
+static struct clk *__clk_get(struct device *dev, const char *id, int locked)
 {
 	struct clk *clk;
 
-	spin_lock(&clk_list_lock);
+	if (!locked)
+		spin_lock(&clk_list_lock);
 
 	list_for_each_entry(clk, &at32_clock_list, list) {
 		if (clk->dev == dev && strcmp(id, clk->name) == 0) {
-			spin_unlock(&clk_list_lock);
+			if (!locked)
+				spin_unlock(&clk_list_lock);
 			return clk;
 		}
 	}
 
-	spin_unlock(&clk_list_lock);
+	if (!locked)
+		spin_unlock(&clk_list_lock);
 	return ERR_PTR(-ENOENT);
 }
+
+struct clk *clk_get(struct device *dev, const char *id)
+{
+	return __clk_get(dev, id, 0);
+}
 EXPORT_SYMBOL(clk_get);
 
 void clk_put(struct clk *clk)
@@ -227,6 +235,11 @@ dump_clock(struct clk *parent, struct clkinf *r)
 	r->nest = nest;
 }
 
+static struct clk *clk_get_locked(struct device *dev, const char *id)
+{
+	return __clk_get(dev, id, 1);
+}
+
 static int clk_show(struct seq_file *s, void *unused)
 {
 	struct clkinf	r;
@@ -257,15 +270,15 @@ static int clk_show(struct seq_file *s, void *unused)
 	spin_lock(&clk_list_lock);
 
 	/* show clock tree as derived from the three oscillators */
-	clk = clk_get(NULL, "osc32k");
+	clk = clk_get_locked(NULL, "osc32k");
 	dump_clock(clk, &r);
 	clk_put(clk);
 
-	clk = clk_get(NULL, "osc0");
+	clk = clk_get_locked(NULL, "osc0");
 	dump_clock(clk, &r);
 	clk_put(clk);
 
-	clk = clk_get(NULL, "osc1");
+	clk = clk_get_locked(NULL, "osc1");
 	dump_clock(clk, &r);
 	clk_put(clk);
 
-- 
1.7.2.2

