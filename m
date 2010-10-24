Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013Ab0JXViE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 17:38:04 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53329 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932938Ab0JXViC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 17:38:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=EU5SVfFQniqWodK6dN5B90wBGvNZoOh+D5AC+3GK8JbknC1I7qIM/B4eNIk/2c4JNZ
         5XuRFBwvUC45KwNqlFvaDHUo/EZvVQAKPr79fBdeCBCc+0oStehYDjsXWhgjuxKpFcke
         OyCz/j+X7Awv8514azl+3/0Uem3Kb/5pgl8oA=
From: Nicolas Palix <npalix.work@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>, Nicolas Palix <npalix.work@gmail.com>,
        Julia Lawall <julia@diku.dk>, Michal Marek <mmarek@suse.cz>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Gilles Muller <Gilles.Muller@lip6.fr>, Sam Ravnborg <sam@ravnborg.org>,
        Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, cocci@diku.dk
Cc: Julia Lawall <julia@diku.dk>
Subject: [PATCH 1/4] Coccinelle: Find nested lock+irqsave functions that use the same flags variables.
Date: Sun, 24 Oct 2010 23:37:31 +0200
Message-Id: <1287956254-15563-1-git-send-email-npalix.work@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Nicolas Palix <npalix.work@gmail.com>
---
 scripts/coccinelle/locks/flags.cocci |   80 ++++++++++++++++++++++++++++++++++
 1 files changed, 80 insertions(+), 0 deletions(-)
 create mode 100644 scripts/coccinelle/locks/flags.cocci

diff --git a/scripts/coccinelle/locks/flags.cocci b/scripts/coccinelle/locks/flags.cocci
new file mode 100644
index 0000000..b4344d8
--- /dev/null
+++ b/scripts/coccinelle/locks/flags.cocci
@@ -0,0 +1,80 @@
+/// Find nested lock+irqsave functions that use the same flags variables
+///
+// Confidence: High
+// Copyright: (C) 2010 Nicolas Palix, DIKU.  GPLv2.
+// Copyright: (C) 2010 Julia Lawall, DIKU.  GPLv2.
+// Copyright: (C) 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
+// URL: http://coccinelle.lip6.fr/
+// Comments:
+// Options: -no_includes -include_headers
+
+virtual context
+virtual org
+virtual report
+
+@r@
+expression lock1,lock2,flags;
+position p1,p2;
+@@
+
+(
+spin_lock_irqsave@p1(lock1,flags)
+|
+read_lock_irqsave@p1(lock1,flags)
+|
+write_lock_irqsave@p1(lock1,flags)
+)
+... when != flags
+(
+spin_lock_irqsave(lock1,flags)
+|
+read_lock_irqsave(lock1,flags)
+|
+write_lock_irqsave(lock1,flags)
+|
+spin_lock_irqsave@p2(lock2,flags)
+|
+read_lock_irqsave@p2(lock2,flags)
+|
+write_lock_irqsave@p2(lock2,flags)
+)
+
+@d@
+expression f <= r.flags;
+expression lock1,lock2,flags;
+position r.p1, r.p2;
+@@
+
+(
+*spin_lock_irqsave@p1(lock1,flags)
+|
+*read_lock_irqsave@p1(lock1,flags)
+|
+*write_lock_irqsave@p1(lock1,flags)
+)
+... when != f
+(
+*spin_lock_irqsave@p2(lock2,flags)
+|
+*read_lock_irqsave@p2(lock2,flags)
+|
+*write_lock_irqsave@p2(lock2,flags)
+)
+
+// ----------------------------------------------------------------------
+
+@script:python depends on d && org@
+p1 << r.p1;
+p2 << r.p2;
+@@
+
+cocci.print_main("original lock",p1)
+cocci.print_secs("nested lock+irqsave that reuses flags",p2)
+
+@script:python depends on d && report@
+p1 << r.p1;
+p2 << r.p2;
+@@
+
+msg="ERROR: nested lock+irqsave that reuses flags from %s." % (p1[0].line)
+coccilib.report.print_report(p2[0], msg)
-- 
1.7.0.4

