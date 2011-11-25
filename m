Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab1KYOpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 09:45:15 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:43192
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755468Ab1KYOpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 09:45:13 -0500
X-SpamScore: -3
X-BigFish: VS-3(zz1102Kzz1202hzzz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>
CC: <cocci@diku.dk>, <linux-kernel@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] coccinelle: Add patch to use kcalloc instead of kzalloc for array allocations
Date: Fri, 25 Nov 2011 15:46:08 +0100
Message-ID: <1322232368-28814-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a coccinelle patch to convert array allocations which use
kzalloc to kcalloc. The advantage of kcalloc is, that will take care of
integer overflows which could result from the multiplication and it is also
nicer to read.

The coccinelle patch does not convert array allocations using kmalloc, since
kcalloc will zero the allocated memory which is considered too much overhead
in some situations.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 scripts/coccinelle/api/alloc/kcalloc.cocci |   59 ++++++++++++++++++++++++++++
 1 files changed, 59 insertions(+), 0 deletions(-)
 create mode 100644 scripts/coccinelle/api/alloc/kcalloc.cocci

diff --git a/scripts/coccinelle/api/alloc/kcalloc.cocci b/scripts/coccinelle/api/alloc/kcalloc.cocci
new file mode 100644
index 0000000..b2a5893
--- /dev/null
+++ b/scripts/coccinelle/api/alloc/kcalloc.cocci
@@ -0,0 +1,59 @@
+///
+/// Use kcalloc instead of kzalloc to allocate array.
+/// The advantage of kcalloc is, that will prevent integer overflows which could
+/// result from the multiplication of number of elements and size and it is also
+/// a bit nicer to read.
+///
+// Confidence: High
+// Options: -no_includes -include_headers
+//
+// Keywords: kzalloc, kcalloc
+// Version min: < 2.6.12 kcalloc
+// Version min:   2.6.14 kzalloc
+//
+
+virtual context
+virtual patch
+virtual org
+virtual report
+
+//----------------------------------------------------------
+//  For patch mode
+//----------------------------------------------------------
+
+@depends on patch@
+expression E;
+expression E2;
+expression gfp;
+expression x;
+@@
+-x = kzalloc(sizeof(E2) * (E), gfp);
++x = kcalloc(E, sizeof(E2), gfp);
+
+//----------------------------------------------------------
+//  For org and report mode
+//----------------------------------------------------------
+
+@r depends on org || report@
+expression E;
+expression E2;
+expression gfp;
+position p;
+expression x;
+@@
+x = kzalloc@p(sizeof(E2) * (E), gfp);
+
+@script:python depends on org@
+p << r.p;
+x << r.x;
+@@
+
+coccilib.org.print_safe_todo(p[0], "%s" % x)
+
+@script:python depends on report@
+p << r.p;
+x << r.x;
+@@
+
+msg="WARNING: kcalloc should be used to allocate an array instead of kzalloc"
+coccilib.report.print_report(p[0], msg)
-- 
1.7.7.1


