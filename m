Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964972Ab2CENzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:55:11 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34900 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428Ab2CENxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:33 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        William Hubbs <w.d.hubbs@gmail.com>,
        Chris Brannon <chris@the-brannons.com>,
        Kirk Reiser <kirk@braille.uwo.ca>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 24/68] TTY: speakup, do not use serialP
Date: Mon,  5 Mar 2012 14:52:11 +0100
Message-Id: <1330955575-26641-25-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The structures there are going away. And speakup has enough troubles
already.

So define a structure similar to what 8250 does: old_serial_port.
There define an array of speed, port base and so on needed for
configuration. Then use this structure instead of serial_state defined
in serialP.h.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: William Hubbs <w.d.hubbs@gmail.com>
Cc: Chris Brannon <chris@the-brannons.com>
Cc: Kirk Reiser <kirk@braille.uwo.ca>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
---
 drivers/staging/speakup/serialio.c |   11 +++++------
 drivers/staging/speakup/serialio.h |   13 ++++++++++++-
 drivers/staging/speakup/spk_priv.h |    2 +-
 drivers/staging/speakup/synth.c    |    2 +-
 4 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/speakup/serialio.c b/drivers/staging/speakup/serialio.c
index 7f3d87b..a97d3d5 100644
--- a/drivers/staging/speakup/serialio.c
+++ b/drivers/staging/speakup/serialio.c
@@ -8,21 +8,20 @@
 
 static void start_serial_interrupt(int irq);
 
-static struct serial_state rs_table[] = {
+static const struct old_serial_port rs_table[] = {
 	SERIAL_PORT_DFNS
 };
-static struct serial_state *serstate;
+static const struct old_serial_port *serstate;
 static int timeouts;
 
-struct serial_state *spk_serial_init(int index)
+const struct old_serial_port *spk_serial_init(int index)
 {
 	int baud = 9600, quot = 0;
 	unsigned int cval = 0;
 	int cflag = CREAD | HUPCL | CLOCAL | B9600 | CS8;
-	struct serial_state *ser = NULL;
+	const struct old_serial_port *ser = rs_table + index;
 	int err;
 
-	ser = rs_table + index;
 	/*	Divisor, bytesize and parity */
 	quot = ser->baud_base / baud;
 	cval = cflag & (CSIZE | CSTOPB);
@@ -41,7 +40,7 @@ struct serial_state *spk_serial_init(int index)
 		__release_region(&ioport_resource, ser->port, 8);
 		err = synth_request_region(ser->port, 8);
 		if (err) {
-			pr_warn("Unable to allocate port at %lx, errno %i",
+			pr_warn("Unable to allocate port at %x, errno %i",
 				ser->port, err);
 			return NULL;
 		}
diff --git a/drivers/staging/speakup/serialio.h b/drivers/staging/speakup/serialio.h
index d785b1f..614271f 100644
--- a/drivers/staging/speakup/serialio.h
+++ b/drivers/staging/speakup/serialio.h
@@ -4,11 +4,22 @@
 #include <linux/serial.h>	/* for rs_table, serial constants &
 				   serial_uart_config */
 #include <linux/serial_reg.h>	/* for more serial constants */
-#include <linux/serialP.h>	/* for struct serial_state */
 #ifndef __sparc__
 #include <asm/serial.h>
 #endif
 
+/*
+ * this is cut&paste from 8250.h. Get rid of the structure, the definitions
+ * and this whole broken driver.
+ */
+struct old_serial_port {
+	unsigned int uart; /* unused */
+	unsigned int baud_base;
+	unsigned int port;
+	unsigned int irq;
+	unsigned int flags; /* unused */
+};
+
 /* countdown values for serial timeouts in us */
 #define SPK_SERIAL_TIMEOUT 100000
 /* countdown values transmitter/dsr timeouts in us */
diff --git a/drivers/staging/speakup/spk_priv.h b/drivers/staging/speakup/spk_priv.h
index 16ace4a..a47c5b7 100644
--- a/drivers/staging/speakup/spk_priv.h
+++ b/drivers/staging/speakup/spk_priv.h
@@ -44,7 +44,7 @@
 
 #define KT_SPKUP 15
 
-extern struct serial_state *spk_serial_init(int index);
+extern const struct old_serial_port *spk_serial_init(int index);
 extern void stop_serial_interrupt(void);
 extern int wait_for_xmitr(void);
 extern unsigned char spk_serial_in(void);
diff --git a/drivers/staging/speakup/synth.c b/drivers/staging/speakup/synth.c
index 2222d691..331eae7 100644
--- a/drivers/staging/speakup/synth.c
+++ b/drivers/staging/speakup/synth.c
@@ -34,7 +34,7 @@ static int do_synth_init(struct spk_synth *in_synth);
 
 int serial_synth_probe(struct spk_synth *synth)
 {
-	struct serial_state *ser;
+	const struct old_serial_port *ser;
 	int failed = 0;
 
 	if ((synth->ser >= SPK_LO_TTY) && (synth->ser <= SPK_HI_TTY)) {
-- 
1.7.9.2


