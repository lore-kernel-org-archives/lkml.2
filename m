Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab1LSNXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 08:23:51 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:39564
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752270Ab1LSNXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 08:23:49 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>
CC: <cocci@diku.dk>, <linux-kernel@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/2] coccinelle: Add patch for replacing open-coded PTR_RET
Date: Mon, 19 Dec 2011 14:24:22 +0100
Message-ID: <1324301063-16117-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PTR_RET function returns the error value of its parameter if it is an
ERR_PTR, otherwise it returns 0. This patch adds a semantic patch which finds
open-coded instances of this check and replaces them.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 scripts/coccinelle/api/ptr_ret.cocci |   55 ++++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)
 create mode 100644 scripts/coccinelle/api/ptr_ret.cocci

diff --git a/scripts/coccinelle/api/ptr_ret.cocci b/scripts/coccinelle/api/ptr_ret.cocci
new file mode 100644
index 0000000..dfd9b1f
--- /dev/null
+++ b/scripts/coccinelle/api/ptr_ret.cocci
@@ -0,0 +1,55 @@
+///
+/// Use PTR_RET function instead of open coding it
+///
+// Confidence: High
+// Options:
+//
+// Keywords: IS_ERR, PTR_ERR, PTR_RET
+// Version min: 2.6.39
+//
+
+virtual context
+virtual patch
+virtual org
+virtual report
+
+@depends on context@
+expression x;
+@@
+*if (IS_ERR(x))
+*	return PTR_ERR(x);
+*return 0;
+
+@depends on patch@
+expression x;
+@@
+-if (IS_ERR(x))
+-	return PTR_ERR(x);
+-return 0;
++return PTR_RET(x);
+
+@r depends on org || report@
+expression x;
+position p;
+@@
+
+ if (IS_ERR@p(x))
+	return PTR_ERR(x);
+ return 0;
+
+@script:python depends on org@
+p << r.p;
+x << r.x;
+@@
+
+msg="WARNING PTR_RET can be used with %s" % (x)
+msg_safe=msg.replace("[","@(").replace("]",")")
+coccilib.org.print_todo(p[0], msg_safe)
+
+@script:python depends on report@
+p << r.p;
+x << r.x;
+@@
+
+msg="WARNING: PTR_RET can be used with %s" % (x)
+coccilib.report.print_report(p[0], msg)
-- 
1.7.7.3


