Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255Ab2BNDkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 22:40:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63772 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759043Ab2BNDkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 22:40:08 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=LmyTX4h6QxcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=70i18_JkQwiTONNaSksA:9 a=X6xZqjlP6YXxIweYbfsA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=nicvguR0pnOebbLorQ0A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120214034006.059833620@goodmis.org>
User-Agent: quilt/0.50-1
Date: Mon, 13 Feb 2012 22:39:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/9] tracing/softirq: Move __raise_softirq_irqoff() out of header
References: <20120214033909.904564921@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-softirq-Move-__raise_softirq_irqoff-out-of-h.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The __raise_softirq_irqoff() contains a tracepoint. As tracepoints in heade=
rs
can cause issues, and not to mention, bloats the kernel when they are
in a static inline, it is best to move the function that contains the
tracepoint out of the header and into softirq.c.

Link: http://lkml.kernel.org/r/20120118120711.GB14863@elte.hu

Suggested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/interrupt.h |    7 +------
 kernel/irq/chip.c         |    2 ++
 kernel/softirq.c          |    6 ++++++
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index a64b00e..3f830e0 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -20,7 +20,6 @@
 #include <linux/atomic.h>
 #include <asm/ptrace.h>
 #include <asm/system.h>
-#include <trace/events/irq.h>
=20
 /*
  * These correspond to the IORESOURCE_IRQ_* defines in
@@ -456,11 +455,7 @@ asmlinkage void do_softirq(void);
 asmlinkage void __do_softirq(void);
 extern void open_softirq(int nr, void (*action)(struct softirq_action *));
 extern void softirq_init(void);
-static inline void __raise_softirq_irqoff(unsigned int nr)
-{
-	trace_softirq_raise(nr);
-	or_softirq_pending(1UL << nr);
-}
+extern void __raise_softirq_irqoff(unsigned int nr);
=20
 extern void raise_softirq_irqoff(unsigned int nr);
 extern void raise_softirq(unsigned int nr);
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index f7c543a..fc41824 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -16,6 +16,8 @@
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
=20
+#include <trace/events/irq.h>
+
 #include "internals.h"
=20
 /**
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 4eb3a0f..06d4099 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -385,6 +385,12 @@ void raise_softirq(unsigned int nr)
 	local_irq_restore(flags);
 }
=20
+void __raise_softirq_irqoff(unsigned int nr)
+{
+	trace_softirq_raise(nr);
+	or_softirq_pending(1UL << nr);
+}
+
 void open_softirq(int nr, void (*action)(struct softirq_action *))
 {
 	softirq_vec[nr].action =3D action;
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPOdeWAAoJEIy3vGnGbaoAjowQAKqy7bUYm6P57At7ehu38NNZ
joiCzk8EooIER2S1mPWfkSaTypUoEzjvJk0KBjRWmp0Goq0nTmuuzNXQ759Fu8Ml
AACWRSQ5p+m2N5Ek6sja5NdmCdxMRqSiCDSn1RE1HotR5SdXaVJD5AJ7FosAH/dH
Gz6plwpW3iZ/DBb+RO2z80iT4stATK/lU4jxJmQ2DkiRVWuyVhbbM9M8Per8RRT6
L6my73eSSb5oAItfd22PAXWMIXkqY6yk2EOQhcRwUiBY6/Kvur7USg/TGyZh8rEH
2HFCBEb/oVAOw4YO7HZNjzhWq8zgFJRcN0vTthvHOEA18BT4+kOpy7MTLyzqTbbM
gcc0Vw2pmzu6ozSzsu+4HrySEwX69XLjlqTGoHP9tvVPad+2aKiaO1lkkdSZV3bM
wpP9FVmzA914oOIvGNKlyL7yTM/jGk9+MvbqT929VJr1H/21foLc3PN5cMgoouH5
RFUrdI16SSJ8T9WNwfF5WAl0zeCJ/S+MP+N64rJ4xvs5IlYLZbUdQDkpxI0Qux19
4Oi9c2CpBK67KLDIwAqu8/Y9FgwcEOEe8N79pqCx7dL0D05w0BXLs12ZDX/3r29R
51+ykIdECQLT04zKdVrDfOsRaFooxgzl8IAV9Ijgo5iDCcoxN3ggqoKrYqnRN1qt
xyUta48WZoyUgVTJxcTn
=1brB
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
