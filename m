Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651Ab0JFJjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 05:39:08 -0400
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:17131 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932349Ab0JFJjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 05:39:06 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Oct 2010 05:39:06 EDT
Subject: [PATCH] Add generic exponentially weighted moving average function
To: linux-kernel@vger.kernel.org
From: Bruno Randolf <br1@einfach.org>
Date: Wed, 06 Oct 2010 18:32:25 +0900
Message-ID: <20101006093225.8739.14012.stgit@tt-desk>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SF-Loop: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a generic exponentially weighted moving average function. This
implementation makes use of a structure which keeps a scaled up internal
representation to reduce rounding errors.

The idea for this implementation comes from the rt2x00 driver (rt2x00link.c)
and i would like to use it in several places in the mac80211 and ath5k code.

Signed-off-by: Bruno Randolf <br1@einfach.org>

--
Is this the right place to add it? Who to CC:?
---
 include/linux/average.h |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/average.h

diff --git a/include/linux/average.h b/include/linux/average.h
new file mode 100644
index 0000000..2a00d3d
--- /dev/null
+++ b/include/linux/average.h
@@ -0,0 +1,32 @@
+#ifndef _LINUX_AVERAGE_H
+#define _LINUX_AVERAGE_H
+
+#define AVG_FACTOR	1000
+
+struct avg_val {
+	int value;
+	int internal;
+};
+
+/**
+ * moving_average -  Exponentially weighted moving average
+ * @avg: average structure
+ * @val: current value
+ * @samples: number of samples
+ *
+ * This implementation make use of a struct avg_val to prevent rounding
+ * errors.
+ */
+static inline struct avg_val
+moving_average(const struct avg_val avg, const int val, const int samples)
+{
+	struct avg_val ret;
+	ret.internal = avg.internal  ?
+		(((avg.internal * (samples - 1)) +
+			(val * AVG_FACTOR)) / samples) :
+		(val * AVG_FACTOR);
+	ret.value = ret.internal / AVG_FACTOR;
+	return ret;
+}
+
+#endif /* _LINUX_AVERAGE_H */

