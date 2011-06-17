Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab1FQBI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 21:08:28 -0400
Received: from gate.crashing.org ([63.228.1.57]:43388 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260Ab1FQBI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 21:08:26 -0400
Subject: [PATCH 1/5] powerpc/hvsi: Move HVSI protocol definitions to a
 header file
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Jun 2011 11:08:12 +1000
Message-ID: <1308272892.2516.105.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves various HVSI protocol definitions from the hvsi.c
driver to a header file that can be used later on by a udbg
implementation

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/include/asm/hvsi.h |   68 +++++++++++++++++++++++++++++++++++++++
 drivers/tty/hvc/hvsi.c          |   63 +-----------------------------------
 2 files changed, 69 insertions(+), 62 deletions(-)
 create mode 100644 arch/powerpc/include/asm/hvsi.h

diff --git a/arch/powerpc/include/asm/hvsi.h b/arch/powerpc/include/asm/hvsi.h
new file mode 100644
index 0000000..f13125a
--- /dev/null
+++ b/arch/powerpc/include/asm/hvsi.h
@@ -0,0 +1,68 @@
+#ifndef _HVSI_H
+#define _HVSI_H
+
+#define VS_DATA_PACKET_HEADER           0xff
+#define VS_CONTROL_PACKET_HEADER        0xfe
+#define VS_QUERY_PACKET_HEADER          0xfd
+#define VS_QUERY_RESPONSE_PACKET_HEADER 0xfc
+
+/* control verbs */
+#define VSV_SET_MODEM_CTL    1 /* to service processor only */
+#define VSV_MODEM_CTL_UPDATE 2 /* from service processor only */
+#define VSV_CLOSE_PROTOCOL   3
+
+/* query verbs */
+#define VSV_SEND_VERSION_NUMBER 1
+#define VSV_SEND_MODEM_CTL_STATUS 2
+
+/* yes, these masks are not consecutive. */
+#define HVSI_TSDTR 0x01
+#define HVSI_TSCD  0x20
+
+#define HVSI_MAX_OUTGOING_DATA 12
+#define HVSI_VERSION 1
+
+struct hvsi_header {
+	uint8_t  type;
+	uint8_t  len;
+	uint16_t seqno;
+} __attribute__((packed));
+
+struct hvsi_data {
+	uint8_t  type;
+	uint8_t  len;
+	uint16_t seqno;
+	uint8_t  data[HVSI_MAX_OUTGOING_DATA];
+} __attribute__((packed));
+
+struct hvsi_control {
+	uint8_t  type;
+	uint8_t  len;
+	uint16_t seqno;
+	uint16_t verb;
+	/* optional depending on verb: */
+	uint32_t word;
+	uint32_t mask;
+} __attribute__((packed));
+
+struct hvsi_query {
+	uint8_t  type;
+	uint8_t  len;
+	uint16_t seqno;
+	uint16_t verb;
+} __attribute__((packed));
+
+struct hvsi_query_response {
+	uint8_t  type;
+	uint8_t  len;
+	uint16_t seqno;
+	uint16_t verb;
+	uint16_t query_seqno;
+	union {
+		uint8_t  version;
+		uint32_t mctrl_word;
+	} u;
+} __attribute__((packed));
+
+
+#endif /* _HVSI_H */
diff --git a/drivers/tty/hvc/hvsi.c b/drivers/tty/hvc/hvsi.c
index 8a8d637..0b35793 100644
--- a/drivers/tty/hvc/hvsi.c
+++ b/drivers/tty/hvc/hvsi.c
@@ -49,6 +49,7 @@
 #include <asm/uaccess.h>
 #include <asm/vio.h>
 #include <asm/param.h>
+#include <asm/hvsi.h>
 
 #define HVSI_MAJOR	229
 #define HVSI_MINOR	128
@@ -109,68 +110,6 @@ enum HVSI_PROTOCOL_STATE {
 };
 #define HVSI_CONSOLE 0x1
 
-#define VS_DATA_PACKET_HEADER           0xff
-#define VS_CONTROL_PACKET_HEADER        0xfe
-#define VS_QUERY_PACKET_HEADER          0xfd
-#define VS_QUERY_RESPONSE_PACKET_HEADER 0xfc
-
-/* control verbs */
-#define VSV_SET_MODEM_CTL    1 /* to service processor only */
-#define VSV_MODEM_CTL_UPDATE 2 /* from service processor only */
-#define VSV_CLOSE_PROTOCOL   3
-
-/* query verbs */
-#define VSV_SEND_VERSION_NUMBER 1
-#define VSV_SEND_MODEM_CTL_STATUS 2
-
-/* yes, these masks are not consecutive. */
-#define HVSI_TSDTR 0x01
-#define HVSI_TSCD  0x20
-
-struct hvsi_header {
-	uint8_t  type;
-	uint8_t  len;
-	uint16_t seqno;
-} __attribute__((packed));
-
-struct hvsi_data {
-	uint8_t  type;
-	uint8_t  len;
-	uint16_t seqno;
-	uint8_t  data[HVSI_MAX_OUTGOING_DATA];
-} __attribute__((packed));
-
-struct hvsi_control {
-	uint8_t  type;
-	uint8_t  len;
-	uint16_t seqno;
-	uint16_t verb;
-	/* optional depending on verb: */
-	uint32_t word;
-	uint32_t mask;
-} __attribute__((packed));
-
-struct hvsi_query {
-	uint8_t  type;
-	uint8_t  len;
-	uint16_t seqno;
-	uint16_t verb;
-} __attribute__((packed));
-
-struct hvsi_query_response {
-	uint8_t  type;
-	uint8_t  len;
-	uint16_t seqno;
-	uint16_t verb;
-	uint16_t query_seqno;
-	union {
-		uint8_t  version;
-		uint32_t mctrl_word;
-	} u;
-} __attribute__((packed));
-
-
-
 static inline int is_console(struct hvsi_struct *hp)
 {
 	return hp->flags & HVSI_CONSOLE;



