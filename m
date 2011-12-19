Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab1LSNYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 08:24:00 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:39609
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752896Ab1LSNXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 08:23:51 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-SS: 13,
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>
CC: <cocci@diku.dk>, <linux-kernel@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/2] coccinelle: Add patch for replacing open-coded IS_ERR_OR_NULL
Date: Mon, 19 Dec 2011 14:24:23 +0100
Message-ID: <1324301063-16117-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1324301063-16117-1-git-send-email-lars@metafoo.de>
References: <1324301063-16117-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IS_ERR_OR_NULL function returns true if the passed parameter is either a
ERR_PTR or NULL. This patch adds a semantic patch which finds open-coded
instances of this check and replaces them.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 scripts/coccinelle/api/is_err_or_null.cocci |   98 +++++++++++++++++++++++++++
 1 files changed, 98 insertions(+), 0 deletions(-)
 create mode 100644 scripts/coccinelle/api/is_err_or_null.cocci

diff --git a/scripts/coccinelle/api/is_err_or_null.cocci b/scripts/coccinelle/api/is_err_or_null.cocci
new file mode 100644
index 0000000..04afd1e
--- /dev/null
+++ b/scripts/coccinelle/api/is_err_or_null.cocci
@@ -0,0 +1,98 @@
+///
+/// Use IS_ERR_OR_NULL function instead of open coding it
+///
+// Confidence: High
+// Options:
+//
+// Keywords: IS_ERR, IS_ERR_OR_NULL
+// Version min: 2.6.33
+//
+
+virtual context
+virtual patch
+virtual org
+virtual report
+
+// Since the logical or operator by itself is not commutative we need rules for
+// both cases as well as for their De Morgan equivalents.
+
+@depends on context@
+expression x;
+@@
+*(IS_ERR(x) || !x)
+
+@depends on context@
+expression x;
+@@
+*(!x || IS_ERR(x))
+
+@depends on context@
+expression x;
+@@
+*(!IS_ERR(x) && x)
+
+@depends on context@
+expression x;
+@@
+*(x && !IS_ERR(x))
+
+@depends on patch@
+expression x;
+@@
+-(IS_ERR(x) || !x)
++IS_ERR_OR_NULL(x)
+
+@depends on patch@
+expression x;
+@@
+-(!x || IS_ERR(x))
++IS_ERR_OR_NULL(x)
+
+@depends on patch@
+expression x;
+@@
+-(!IS_ERR(x) && x)
++ !IS_ERR_OR_NULL(x)
+
+@depends on patch@
+expression x;
+@@
+-(x && !IS_ERR(x))
++ !IS_ERR_OR_NULL(x)
+
+@r depends on org || report@
+expression x;
+position p;
+statement S;
+@@
+// We'll probably miss some some cases with this, but the if gives us an anchor
+// and we do not have to write a indivual rule for each case. patch and context
+// mode will report all cases
+ if(@p
+(
+ IS_ERR(x) || !x
+|
+ !x || IS_ERR(x)
+|
+ !IS_ERR(x) && x
+|
+ x && !IS_ERR(x)
+)
+ ) S
+
+@script:python depends on org@
+p << r.p;
+x << r.x;
+@@
+
+msg="IS_ERR_OR_NULL can be used with %s" % (x)
+msg_safe=msg.replace("[","@(").replace("]",")")
+coccilib.org.print_todo(p[0], msg_safe)
+
+@script:python depends on report@
+p << r.p;
+x << r.x;
+@@
+
+msg="IS_ERR_OR_NULL can be used with %s" % (x)
+coccilib.report.print_report(p[0], msg)
-- 
1.7.7.3


