Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab2DEIsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 04:48:13 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48748 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab2DEIsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 04:48:10 -0400
Date: Thu, 5 Apr 2012 10:48:08 +0200
From: Domenico Andreoli <cavokz@gmail.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Arnd Bergman <arnd.bergmann@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: common clk: fix clk_register_fixed_rate() under memory pressure
Message-ID: <20120405084808.GA21060@glitch>
Mail-Followup-To: Mike Turquette <mturquette@linaro.org>,
	Arnd Bergman <arnd.bergmann@linaro.org>,
	Rob Herring <rob.herring@calxeda.com>, Andrew Lunn <andrew@lunn.ch>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Domenico Andreoli <cavokz@gmail.com>

Under memory pressure clk_register_fixed_rate() fails to manage
allocation errors and prepares land for a later WARN_ON at best.

This fix leaves parent_names correctly initialized or NULL, intermediate
half initialized states are cleaned up and not propagated to the clock
framework.

Signed-off-by: Domenico Andreoli <cavokz@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Arnd Bergman <arnd.bergmann@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Andrew Lunn <andrew@lunn.ch>

---
 drivers/clk/clk-fixed-rate.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: b/drivers/clk/clk-fixed-rate.c
===================================================================
--- a/drivers/clk/clk-fixed-rate.c
+++ b/drivers/clk/clk-fixed-rate.c
@@ -67,8 +67,11 @@ struct clk *clk_register_fixed_rate(stru
 
 		parent_names[0] = kmalloc(len, GFP_KERNEL);
 
-		if (!parent_names[0])
+		if (!parent_names[0]) {
+			kfree(parent_names);
+			parent_names = NULL;
 			goto out;
+		}
 
 		strncpy(parent_names[0], parent_name, len);
 	}
@@ -77,6 +80,6 @@ out:
 	return clk_register(dev, name,
 			&clk_fixed_rate_ops, &fixed->hw,
 			parent_names,
-			(parent_name ? 1 : 0),
+			(parent_names ? 1 : 0),
 			flags);
 }
