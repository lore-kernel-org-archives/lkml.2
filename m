Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150Ab1FQBJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 21:09:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:43400 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755101Ab1FQBJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 21:09:19 -0400
Subject: [PATCH 5/5] powerpc/pseries: Move hvsi support into a library
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Jun 2011 11:08:56 +1000
Message-ID: <1308272936.2516.109.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will allow a different backend to share it

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/include/asm/hvsi.h |   34 +++
 drivers/tty/hvc/Makefile        |    2 +-
 drivers/tty/hvc/hvc_vio.c       |  405 ++-----------------------------------
 drivers/tty/hvc/hvsi_lib.c      |  426 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 482 insertions(+), 385 deletions(-)
 create mode 100644 drivers/tty/hvc/hvsi_lib.c

diff --git a/arch/powerpc/include/asm/hvsi.h b/arch/powerpc/include/asm/hvsi.h
index ab2ddd7..91e0453 100644
--- a/arch/powerpc/include/asm/hvsi.h
+++ b/arch/powerpc/include/asm/hvsi.h
@@ -56,5 +56,39 @@ struct hvsi_query_response {
 	} u;
 } __attribute__((packed));
 
+/* hvsi lib struct definitions */
+#define HVSI_INBUF_SIZE		255
+struct tty_struct;
+struct hvsi_priv {
+	unsigned int	inbuf_len;	/* data in input buffer */
+	unsigned char	inbuf[HVSI_INBUF_SIZE];
+	unsigned int	inbuf_cur;	/* Cursor in input buffer */
+	unsigned int	inbuf_pktlen;	/* packet lenght from cursor */
+	atomic_t	seqno;		/* packet sequence number */
+	unsigned int	opened:1;	/* driver opened */
+	unsigned int	established:1;	/* protocol established */
+	unsigned int 	is_console:1;	/* used as a kernel console device */
+	unsigned int	mctrl_update:1;	/* modem control updated */
+	unsigned short	mctrl;		/* modem control */
+	struct tty_struct *tty;		/* tty structure */
+	int (*get_chars)(uint32_t termno, char *buf, int count);
+	int (*put_chars)(uint32_t termno, const char *buf, int count);
+	uint32_t	termno;
+};
+
+/* hvsi lib functions */
+struct hvc_struct;
+extern void hvsi_init(struct hvsi_priv *pv,
+		      int (*get_chars)(uint32_t termno, char *buf, int count),
+		      int (*put_chars)(uint32_t termno, const char *buf,
+				       int count),
+		      int termno, int is_console);
+extern int hvsi_open(struct hvsi_priv *pv, struct hvc_struct *hp);
+extern void hvsi_close(struct hvsi_priv *pv, struct hvc_struct *hp);
+extern int hvsi_read_mctrl(struct hvsi_priv *pv);
+extern int hvsi_write_mctrl(struct hvsi_priv *pv, int dtr);
+extern void hvsi_establish(struct hvsi_priv *pv);
+extern int hvsi_get_chars(struct hvsi_priv *pv, char *buf, int count);
+extern int hvsi_put_chars(struct hvsi_priv *pv, const char *buf, int count);
 
 #endif /* _HVSI_H */
diff --git a/drivers/tty/hvc/Makefile b/drivers/tty/hvc/Makefile
index 69a444b..e292053 100644
--- a/drivers/tty/hvc/Makefile
+++ b/drivers/tty/hvc/Makefile
@@ -1,4 +1,4 @@
-obj-$(CONFIG_HVC_CONSOLE)	+= hvc_vio.o
+obj-$(CONFIG_HVC_CONSOLE)	+= hvc_vio.o hvsi_lib.o
 obj-$(CONFIG_HVC_OLD_HVSI)	+= hvsi.o
 obj-$(CONFIG_HVC_ISERIES)	+= hvc_iseries.o
 obj-$(CONFIG_HVC_RTAS)		+= hvc_rtas.o
diff --git a/drivers/tty/hvc/hvc_vio.c b/drivers/tty/hvc/hvc_vio.c
index d4e0850..ade73fa 100644
--- a/drivers/tty/hvc/hvc_vio.c
+++ b/drivers/tty/hvc/hvc_vio.c
@@ -67,22 +67,10 @@ typedef enum hv_protocol {
 	HV_PROTOCOL_HVSI
 } hv_protocol_t;
 
-#define HV_INBUF_SIZE		255
-
 struct hvterm_priv {
-	u32		termno;		/* HV term number */
-	hv_protocol_t	proto;		/* Raw data or HVSI packets */
-	unsigned int	inbuf_len;	/* Data in input buffer */
-	unsigned char	inbuf[HV_INBUF_SIZE];
-	unsigned int	inbuf_cur;	/* Cursor in input buffer */
-	unsigned int	inbuf_pktlen;	/* HVSI packet lenght from cursor */
-	atomic_t	seqno;		/* HVSI packet sequence number */
-	unsigned int	opened:1;	/* HVSI driver opened */
-	unsigned int	established:1;	/* HVSI protocol established */
-	unsigned int 	is_console:1;	/* Used as a kernel console device */
-	unsigned int	mctrl_update:1;	/* HVSI modem control updated */
-	unsigned short	mctrl;		/* HVSI modem control */
-	struct tty_struct *tty;		/* TTY structure */
+	u32			termno;	/* HV term number */
+	hv_protocol_t		proto;	/* Raw data or HVSI packets */
+	struct hvsi_priv	hvsi;	/* HVSI specific data */
 };
 static struct hvterm_priv *hvterm_privs[MAX_NR_HVC_CONSOLES];
 
@@ -139,348 +127,24 @@ static const struct hv_ops hvterm_raw_ops = {
 	.notifier_hangup = notifier_hangup_irq,
 };
 
-static int hvterm_hvsi_send_packet(struct hvterm_priv *pv, struct hvsi_header *packet)
-{
-	packet->seqno = atomic_inc_return(&pv->seqno);
-
-	/* Assumes that always succeeds, works in practice */
-	return hvc_put_chars(pv->termno, (char *)packet, packet->len);
-}
-
-static void hvterm_hvsi_start_handshake(struct hvterm_priv *pv)
-{
-	struct hvsi_query q;
-
-	/* Reset state */
-	pv->established = 0;
-	atomic_set(&pv->seqno, 0);
-
-	pr_devel("HVSI@%x: Handshaking started\n", pv->termno);
-
-	/* Send version query */
-	q.hdr.type = VS_QUERY_PACKET_HEADER;
-	q.hdr.len = sizeof(struct hvsi_query);
-	q.verb = VSV_SEND_VERSION_NUMBER;
-	hvterm_hvsi_send_packet(pv, &q.hdr);
-}
-
-static int hvterm_hvsi_send_close(struct hvterm_priv *pv)
-{
-	struct hvsi_control ctrl;
-
-	pv->established = 0;
-
-	ctrl.hdr.type = VS_CONTROL_PACKET_HEADER;
-	ctrl.hdr.len = sizeof(struct hvsi_control);
-	ctrl.verb = VSV_CLOSE_PROTOCOL;
-	return hvterm_hvsi_send_packet(pv, &ctrl.hdr);
-}
-
-static void hvterm_cd_change(struct hvterm_priv *pv, int cd)
-{
-	if (cd)
-		pv->mctrl |= TIOCM_CD;
-	else {
-		pv->mctrl &= ~TIOCM_CD;
-
-		/* We copy the existing hvsi driver semantics
-		 * here which are to trigger a hangup when
-		 * we get a carrier loss.
-		 * Closing our connection to the server will
-		 * do just that.
-		 */
-		if (!pv->is_console && pv->opened) {
-			pr_devel("HVSI@%x Carrier lost, hanging up !\n",
-				 pv->termno);
-			hvterm_hvsi_send_close(pv);
-		}
-	}
-}
-
-static void hvterm_hvsi_got_control(struct hvterm_priv *pv)
-{
-	struct hvsi_control *pkt = (struct hvsi_control *)pv->inbuf;
-
-	switch (pkt->verb) {
-	case VSV_CLOSE_PROTOCOL:
-		/* We restart the handshaking */
-		hvterm_hvsi_start_handshake(pv);
-		break;
-	case VSV_MODEM_CTL_UPDATE:
-		/* Transition of carrier detect */
-		hvterm_cd_change(pv, pkt->word & HVSI_TSCD);
-		break;
-	}
-}
-
-static void hvterm_hvsi_got_query(struct hvterm_priv *pv)
-{
-	struct hvsi_query *pkt = (struct hvsi_query *)pv->inbuf;
-	struct hvsi_query_response r;
-
-	/* We only handle version queries */
-	if (pkt->verb != VSV_SEND_VERSION_NUMBER)
-		return;
-
-	pr_devel("HVSI@%x: Got version query, sending response...\n",
-		 pv->termno);
-
-	/* Send version response */
-	r.hdr.type = VS_QUERY_RESPONSE_PACKET_HEADER;
-	r.hdr.len = sizeof(struct hvsi_query_response);
-	r.verb = VSV_SEND_VERSION_NUMBER;
-	r.u.version = HVSI_VERSION;
-	r.query_seqno = pkt->hdr.seqno;
-	hvterm_hvsi_send_packet(pv, &r.hdr);
-
-	/* Assume protocol is open now */
-	pv->established = 1;
-}
-
-static void hvterm_hvsi_got_response(struct hvterm_priv *pv)
-{
-	struct hvsi_query_response *r = (struct hvsi_query_response *)pv->inbuf;
-
-	switch(r->verb) {
-	case VSV_SEND_MODEM_CTL_STATUS:
-		hvterm_cd_change(pv, r->u.mctrl_word & HVSI_TSCD);
-		pv->mctrl_update = 1;
-		break;
-	}
-}
-
-static int hvterm_hvsi_check_packet(struct hvterm_priv *pv)
-{
-	u8 len, type;
-
-	/* Check header validity. If it's invalid, we ditch
-	 * the whole buffer and hope we eventually resync
-	 */
-	if (pv->inbuf[0] < 0xfc) {
-		pv->inbuf_len = pv->inbuf_pktlen = 0;
-		return 0;
-	}
-	type = pv->inbuf[0];
-	len = pv->inbuf[1];
-
-	/* Packet incomplete ? */
-	if (pv->inbuf_len < len)
-		return 0;
-
-	pr_devel("HVSI@%x: Got packet type %x len %d bytes:\n",
-		 pv->termno, type, len);
-
-	/* We have a packet, yay ! Handle it */
-	switch(type) {
-	case VS_DATA_PACKET_HEADER:
-		pv->inbuf_pktlen = len - 4;
-		pv->inbuf_cur = 4;
-		return 1;
-	case VS_CONTROL_PACKET_HEADER:
-		hvterm_hvsi_got_control(pv);
-		break;
-	case VS_QUERY_PACKET_HEADER:
-		hvterm_hvsi_got_query(pv);
-		break;
-	case VS_QUERY_RESPONSE_PACKET_HEADER:
-		hvterm_hvsi_got_response(pv);
-		break;
-	}
-
-	/* Swallow packet and retry */
-	pv->inbuf_len -= len;
-	memmove(pv->inbuf, &pv->inbuf[len], pv->inbuf_len);
-	return 1;
-}
-
-static int hvterm_hvsi_get_packet(struct hvterm_priv *pv)
-{
-	/* If we have room in the buffer, ask HV for more */
-	if (pv->inbuf_len < HV_INBUF_SIZE)
-		pv->inbuf_len += hvc_get_chars(pv->termno,
-					       &pv->inbuf[pv->inbuf_len],
-					       HV_INBUF_SIZE - pv->inbuf_len);
-	/*
-	 * If we have at least 4 bytes in the buffer, check for
-	 * a full packet and retry
-	 */
-	if (pv->inbuf_len >= 4)
-		return hvterm_hvsi_check_packet(pv);
-	return 0;
-}
-
 static int hvterm_hvsi_get_chars(uint32_t vtermno, char *buf, int count)
 {
 	struct hvterm_priv *pv = hvterm_privs[vtermno];
-	unsigned int tries, read = 0;
 
 	if (WARN_ON(!pv))
 		return 0;
 
-	/* If we aren't open, dont do anything in order to avoid races
-	 * with connection establishment. The hvc core will call this
-	 * before we have returned from notifier_add(), and we need to
-	 * avoid multiple users playing with the receive buffer
-	 */
-	if (!pv->opened)
-		return 0;
-
-	/* We try twice, once with what data we have and once more
-	 * after we try to fetch some more from the hypervisor
-	 */
-	for (tries = 1; count && tries < 2; tries++) {
-		/* Consume existing data packet */
-		if (pv->inbuf_pktlen) {
-			unsigned int l = min(count, (int)pv->inbuf_pktlen);
-			memcpy(&buf[read], &pv->inbuf[pv->inbuf_cur], l);
-			pv->inbuf_cur += l;
-			pv->inbuf_pktlen -= l;
-			count -= l;
-			read += l;
-		}
-		if (count == 0)
-			break;
-
-		/* Data packet fully consumed, move down remaning data */
-		if (pv->inbuf_cur) {
-			pv->inbuf_len -= pv->inbuf_cur;
-			memmove(pv->inbuf, &pv->inbuf[pv->inbuf_cur], pv->inbuf_len);
-			pv->inbuf_cur = 0;
-		}
-
-		/* Try to get another packet */
-		if (hvterm_hvsi_get_packet(pv))
-			tries--;
-	}
-	if (!pv->established) {
-		pr_devel("HVSI@%x: returning -EPIPE\n", pv->termno);
-		return -EPIPE;
-	}
-	return read;
+	return hvsi_get_chars(&pv->hvsi, buf, count);
 }
 
 static int hvterm_hvsi_put_chars(uint32_t vtermno, const char *buf, int count)
 {
 	struct hvterm_priv *pv = hvterm_privs[vtermno];
-	struct hvsi_data dp;
-	int rc, adjcount = min(count, HVSI_MAX_OUTGOING_DATA);
 
 	if (WARN_ON(!pv))
 		return 0;
 
-	dp.hdr.type = VS_DATA_PACKET_HEADER;
-	dp.hdr.len = adjcount + sizeof(struct hvsi_header);
-	memcpy(dp.data, buf, adjcount);
-	rc = hvterm_hvsi_send_packet(pv, &dp.hdr);
-	if (rc <= 0)
-		return rc;
-	return adjcount;
-}
-
-static void maybe_msleep(unsigned long ms)
-{
-	/* During early boot, IRQs are disabled, use mdelay */
-	if (irqs_disabled())
-		mdelay(ms);
-	else
-		msleep(ms);
-}
-
-static int hvterm_hvsi_read_mctrl(struct hvterm_priv *pv)
-{
-	struct hvsi_query q;
-	int rc, timeout;
-
-	pr_devel("HVSI@%x: Querying modem control status...\n",
-		 pv->termno);
-
-	pv->mctrl_update = 0;
-	q.hdr.type = VS_QUERY_PACKET_HEADER;
-	q.hdr.len = sizeof(struct hvsi_query);
-	q.hdr.seqno = atomic_inc_return(&pv->seqno);
-	q.verb = VSV_SEND_MODEM_CTL_STATUS;
-	rc = hvterm_hvsi_send_packet(pv, &q.hdr);
-	if (rc <= 0) {
-		pr_devel("HVSI@%x: Error %d...\n", pv->termno, rc);
-		return rc;
-	}
-
-	/* Try for up to 1s */
-	for (timeout = 0; timeout < 1000; timeout++) {
-		if (!pv->established)
-			return -ENXIO;
-		if (pv->mctrl_update)
-			return 0;
-		if (!hvterm_hvsi_get_packet(pv))
-			maybe_msleep(1);
-	}
-	return -EIO;
-}
-
-static int hvterm_hvsi_write_mctrl(struct hvterm_priv *pv, int dtr)
-{
-	struct hvsi_control ctrl;
-
-	pr_devel("HVSI@%x: %s DTR...\n", pv->termno,
-		 dtr ? "Setting" : "Clearing");
-
-	ctrl.hdr.type = VS_CONTROL_PACKET_HEADER,
-	ctrl.hdr.len = sizeof(struct hvsi_control);
-	ctrl.verb = VSV_SET_MODEM_CTL;
-	ctrl.mask = HVSI_TSDTR;
-	ctrl.word = dtr ? HVSI_TSDTR : 0;
-	if (dtr)
-		pv->mctrl |= TIOCM_DTR;
-	else
-		pv->mctrl &= ~TIOCM_DTR;
-	return hvterm_hvsi_send_packet(pv, &ctrl.hdr);
-}
-
-static void hvterm_hvsi_establish(struct hvterm_priv *pv)
-{
-	int timeout;
-
-	/* Try for up to 10ms, there can be a packet to
-	 * start the process waiting for us...
-	 */
-	for (timeout = 0; timeout < 10; timeout++) {
-		if (pv->established)
-			goto established;
-		if (!hvterm_hvsi_get_packet(pv))
-			maybe_msleep(1);
-	}
-
-	/* Failed, send a close connection packet just
-	 * in case
-	 */
-	hvterm_hvsi_send_close(pv);
-
-	/* Then restart handshake */
-	hvterm_hvsi_start_handshake(pv);
-
-	/* Try for up to 100ms */
-	for (timeout = 0; timeout < 100; timeout++) {
-		if (pv->established)
-			goto established;
-		if (!hvterm_hvsi_get_packet(pv))
-			maybe_msleep(1);
-	}
-
-	if (!pv->established) {
-		pr_devel("HVSI@%x: Timeout handshaking, giving up !\n",
-			 pv->termno);
-		return;
-	}
- established:
-	/* Query modem control lines */
-	hvterm_hvsi_read_mctrl(pv);
-
-	/* Set our own DTR */
-	hvterm_hvsi_write_mctrl(pv, 1);
-
-	/* Set the opened flag so reads are allowed */
-	wmb();
-	pv->opened = 1;
+	return hvsi_put_chars(&pv->hvsi, buf, count);
 }
 
 static int hvterm_hvsi_open(struct hvc_struct *hp, int data)
@@ -494,46 +158,16 @@ static int hvterm_hvsi_open(struct hvc_struct *hp, int data)
 	if (rc)
 		return rc;
 
-	/* Keep track of the tty data structure */
-	pv->tty = tty_kref_get(hp->tty);
-
-	hvterm_hvsi_establish(pv);
-	return 0;
-}
-
-static void hvterm_hvsi_shutdown(struct hvc_struct *hp, struct hvterm_priv *pv)
-{
-	unsigned long flags;
-
-	if (!pv->is_console) {
-		pr_devel("HVSI@%x: Not a console, tearing down\n",
-			 pv->termno);
-
-		/* Clear opened, synchronize with khvcd */
-		spin_lock_irqsave(&hp->lock, flags);
-		pv->opened = 0;
-		spin_unlock_irqrestore(&hp->lock, flags);
-
-		/* Clear our own DTR */
-		if (!pv->tty || (pv->tty->termios->c_cflag & HUPCL))
-			hvterm_hvsi_write_mctrl(pv, 0);
-
-		/* Tear down the connection */
-		hvterm_hvsi_send_close(pv);
-	}
-
-	if (pv->tty)
-		tty_kref_put(pv->tty);
-	pv->tty = NULL;
+	return hvsi_open(&pv->hvsi, hp);
 }
 
 static void hvterm_hvsi_close(struct hvc_struct *hp, int data)
 {
 	struct hvterm_priv *pv = hvterm_privs[hp->vtermno];
 
-	pr_devel("HVSI@%x: close !\n", pv->termno);
+	pr_devel("HVSI@%x: do close !\n", pv->termno);
 
-	hvterm_hvsi_shutdown(hp, pv);
+	hvsi_close(&pv->hvsi, hp);
 
 	notifier_del_irq(hp, data);
 }
@@ -542,9 +176,9 @@ void hvterm_hvsi_hangup(struct hvc_struct *hp, int data)
 {
 	struct hvterm_priv *pv = hvterm_privs[hp->vtermno];
 
-	pr_devel("HVSI@%x: hangup !\n", pv->termno);
+	pr_devel("HVSI@%x: do hangup !\n", pv->termno);
 
-	hvterm_hvsi_shutdown(hp, pv);
+	hvsi_close(&pv->hvsi, hp);
 
 	notifier_hangup_irq(hp, data);
 }
@@ -555,7 +189,7 @@ static int hvterm_hvsi_tiocmget(struct hvc_struct *hp)
 
 	if (!pv)
 		return -EINVAL;
-	return pv->mctrl;
+	return pv->hvsi.mctrl;
 }
 
 static int hvterm_hvsi_tiocmset(struct hvc_struct *hp, unsigned int set,
@@ -567,9 +201,9 @@ static int hvterm_hvsi_tiocmset(struct hvc_struct *hp, unsigned int set,
 		 pv->termno, set, clear);
 
 	if (set & TIOCM_DTR)
-		hvterm_hvsi_write_mctrl(pv, 1);
+		hvsi_write_mctrl(&pv->hvsi, 1);
 	else if (clear & TIOCM_DTR)
-		hvterm_hvsi_write_mctrl(pv, 0);
+		hvsi_write_mctrl(&pv->hvsi, 0);
 
 	return 0;
 }
@@ -633,6 +267,8 @@ static int __devinit hvc_vio_probe(struct vio_dev *vdev,
 		pv->termno = vdev->unit_address;
 		pv->proto = proto;
 		hvterm_privs[termno] = pv;
+		hvsi_init(&pv->hvsi, hvc_get_chars, hvc_put_chars,
+			  pv->termno, 0);
 	}
 
 	hp = hvc_alloc(termno, vdev->irq, ops, MAX_VIO_PUT_CHARS);
@@ -770,7 +406,6 @@ void __init hvc_vio_init_early(void)
 	if (termno == NULL)
 		goto out;
 	hvterm_priv0.termno = *termno;
-	hvterm_priv0.is_console = 1;
 	hvterm_privs[0] = &hvterm_priv0;
 
 	/* Check the protocol */
@@ -781,8 +416,10 @@ void __init hvc_vio_init_early(void)
 	else if (of_device_is_compatible(stdout_node, "hvterm-protocol")) {
 		hvterm_priv0.proto = HV_PROTOCOL_HVSI;
 		ops = &hvterm_hvsi_ops;
+		hvsi_init(&hvterm_priv0.hvsi, hvc_get_chars, hvc_put_chars,
+			  hvterm_priv0.termno, 1);
 		/* HVSI, perform the handshake now */
-		hvterm_hvsi_establish(&hvterm_priv0);
+		hvsi_establish(&hvterm_priv0.hvsi);
 	} else
 		goto out;
 	udbg_putc = udbg_hvc_putc;
@@ -810,7 +447,6 @@ void __init udbg_init_debug_lpar(void)
 	hvterm_privs[0] = &hvterm_priv0;
 	hvterm_priv0.termno = 0;
 	hvterm_priv0.proto = HV_PROTOCOL_RAW;
-	hvterm_priv0.is_console = 1;
 	udbg_putc = udbg_hvc_putc;
 	udbg_getc = udbg_hvc_getc;
 	udbg_getc_poll = udbg_hvc_getc_poll;
@@ -823,10 +459,11 @@ void __init udbg_init_debug_lpar_hvsi(void)
 	hvterm_privs[0] = &hvterm_priv0;
 	hvterm_priv0.termno = CONFIG_PPC_EARLY_DEBUG_HVSI_VTERMNO;
 	hvterm_priv0.proto = HV_PROTOCOL_HVSI;
-	hvterm_priv0.is_console = 1;
 	udbg_putc = udbg_hvc_putc;
 	udbg_getc = udbg_hvc_getc;
 	udbg_getc_poll = udbg_hvc_getc_poll;
-	hvterm_hvsi_establish(&hvterm_priv0);
+	hvsi_init(&hvterm_priv0.hvsi, hvc_get_chars, hvc_put_chars,
+		  hvterm_priv0.termno, 1);
+	hvsi_establish(&hvterm_priv0.hvsi);
 }
 #endif /* CONFIG_PPC_EARLY_DEBUG_LPAR_HVSI */
diff --git a/drivers/tty/hvc/hvsi_lib.c b/drivers/tty/hvc/hvsi_lib.c
new file mode 100644
index 0000000..9401fcb
--- /dev/null
+++ b/drivers/tty/hvc/hvsi_lib.c
@@ -0,0 +1,426 @@
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/console.h>
+#include <asm/hvsi.h>
+
+#include "hvc_console.h"
+
+static int hvsi_send_packet(struct hvsi_priv *pv, struct hvsi_header *packet)
+{
+	packet->seqno = atomic_inc_return(&pv->seqno);
+
+	/* Assumes that always succeeds, works in practice */
+	return pv->put_chars(pv->termno, (char *)packet, packet->len);
+}
+
+static void hvsi_start_handshake(struct hvsi_priv *pv)
+{
+	struct hvsi_query q;
+
+	/* Reset state */
+	pv->established = 0;
+	atomic_set(&pv->seqno, 0);
+
+	pr_devel("HVSI@%x: Handshaking started\n", pv->termno);
+
+	/* Send version query */
+	q.hdr.type = VS_QUERY_PACKET_HEADER;
+	q.hdr.len = sizeof(struct hvsi_query);
+	q.verb = VSV_SEND_VERSION_NUMBER;
+	hvsi_send_packet(pv, &q.hdr);
+}
+
+static int hvsi_send_close(struct hvsi_priv *pv)
+{
+	struct hvsi_control ctrl;
+
+	pv->established = 0;
+
+	ctrl.hdr.type = VS_CONTROL_PACKET_HEADER;
+	ctrl.hdr.len = sizeof(struct hvsi_control);
+	ctrl.verb = VSV_CLOSE_PROTOCOL;
+	return hvsi_send_packet(pv, &ctrl.hdr);
+}
+
+static void hvsi_cd_change(struct hvsi_priv *pv, int cd)
+{
+	if (cd)
+		pv->mctrl |= TIOCM_CD;
+	else {
+		pv->mctrl &= ~TIOCM_CD;
+
+		/* We copy the existing hvsi driver semantics
+		 * here which are to trigger a hangup when
+		 * we get a carrier loss.
+		 * Closing our connection to the server will
+		 * do just that.
+		 */
+		if (!pv->is_console && pv->opened) {
+			pr_devel("HVSI@%x Carrier lost, hanging up !\n",
+				 pv->termno);
+			hvsi_send_close(pv);
+		}
+	}
+}
+
+static void hvsi_got_control(struct hvsi_priv *pv)
+{
+	struct hvsi_control *pkt = (struct hvsi_control *)pv->inbuf;
+
+	switch (pkt->verb) {
+	case VSV_CLOSE_PROTOCOL:
+		/* We restart the handshaking */
+		hvsi_start_handshake(pv);
+		break;
+	case VSV_MODEM_CTL_UPDATE:
+		/* Transition of carrier detect */
+		hvsi_cd_change(pv, pkt->word & HVSI_TSCD);
+		break;
+	}
+}
+
+static void hvsi_got_query(struct hvsi_priv *pv)
+{
+	struct hvsi_query *pkt = (struct hvsi_query *)pv->inbuf;
+	struct hvsi_query_response r;
+
+	/* We only handle version queries */
+	if (pkt->verb != VSV_SEND_VERSION_NUMBER)
+		return;
+
+	pr_devel("HVSI@%x: Got version query, sending response...\n",
+		 pv->termno);
+
+	/* Send version response */
+	r.hdr.type = VS_QUERY_RESPONSE_PACKET_HEADER;
+	r.hdr.len = sizeof(struct hvsi_query_response);
+	r.verb = VSV_SEND_VERSION_NUMBER;
+	r.u.version = HVSI_VERSION;
+	r.query_seqno = pkt->hdr.seqno;
+	hvsi_send_packet(pv, &r.hdr);
+
+	/* Assume protocol is open now */
+	pv->established = 1;
+}
+
+static void hvsi_got_response(struct hvsi_priv *pv)
+{
+	struct hvsi_query_response *r =
+		(struct hvsi_query_response *)pv->inbuf;
+
+	switch(r->verb) {
+	case VSV_SEND_MODEM_CTL_STATUS:
+		hvsi_cd_change(pv, r->u.mctrl_word & HVSI_TSCD);
+		pv->mctrl_update = 1;
+		break;
+	}
+}
+
+static int hvsi_check_packet(struct hvsi_priv *pv)
+{
+	u8 len, type;
+
+	/* Check header validity. If it's invalid, we ditch
+	 * the whole buffer and hope we eventually resync
+	 */
+	if (pv->inbuf[0] < 0xfc) {
+		pv->inbuf_len = pv->inbuf_pktlen = 0;
+		return 0;
+	}
+	type = pv->inbuf[0];
+	len = pv->inbuf[1];
+
+	/* Packet incomplete ? */
+	if (pv->inbuf_len < len)
+		return 0;
+
+	pr_devel("HVSI@%x: Got packet type %x len %d bytes:\n",
+		 pv->termno, type, len);
+
+	/* We have a packet, yay ! Handle it */
+	switch(type) {
+	case VS_DATA_PACKET_HEADER:
+		pv->inbuf_pktlen = len - 4;
+		pv->inbuf_cur = 4;
+		return 1;
+	case VS_CONTROL_PACKET_HEADER:
+		hvsi_got_control(pv);
+		break;
+	case VS_QUERY_PACKET_HEADER:
+		hvsi_got_query(pv);
+		break;
+	case VS_QUERY_RESPONSE_PACKET_HEADER:
+		hvsi_got_response(pv);
+		break;
+	}
+
+	/* Swallow packet and retry */
+	pv->inbuf_len -= len;
+	memmove(pv->inbuf, &pv->inbuf[len], pv->inbuf_len);
+	return 1;
+}
+
+static int hvsi_get_packet(struct hvsi_priv *pv)
+{
+	/* If we have room in the buffer, ask HV for more */
+	if (pv->inbuf_len < HVSI_INBUF_SIZE)
+		pv->inbuf_len += pv->get_chars(pv->termno,
+					     &pv->inbuf[pv->inbuf_len],
+					     HVSI_INBUF_SIZE - pv->inbuf_len);
+	/*
+	 * If we have at least 4 bytes in the buffer, check for
+	 * a full packet and retry
+	 */
+	if (pv->inbuf_len >= 4)
+		return hvsi_check_packet(pv);
+	return 0;
+}
+
+int hvsi_get_chars(struct hvsi_priv *pv, char *buf, int count)
+{
+	unsigned int tries, read = 0;
+
+	if (WARN_ON(!pv))
+		return 0;
+
+	/* If we aren't open, don't do anything in order to avoid races
+	 * with connection establishment. The hvc core will call this
+	 * before we have returned from notifier_add(), and we need to
+	 * avoid multiple users playing with the receive buffer
+	 */
+	if (!pv->opened)
+		return 0;
+
+	/* We try twice, once with what data we have and once more
+	 * after we try to fetch some more from the hypervisor
+	 */
+	for (tries = 1; count && tries < 2; tries++) {
+		/* Consume existing data packet */
+		if (pv->inbuf_pktlen) {
+			unsigned int l = min(count, (int)pv->inbuf_pktlen);
+			memcpy(&buf[read], &pv->inbuf[pv->inbuf_cur], l);
+			pv->inbuf_cur += l;
+			pv->inbuf_pktlen -= l;
+			count -= l;
+			read += l;
+		}
+		if (count == 0)
+			break;
+
+		/* Data packet fully consumed, move down remaning data */
+		if (pv->inbuf_cur) {
+			pv->inbuf_len -= pv->inbuf_cur;
+			memmove(pv->inbuf, &pv->inbuf[pv->inbuf_cur],
+				pv->inbuf_len);
+			pv->inbuf_cur = 0;
+		}
+
+		/* Try to get another packet */
+		if (hvsi_get_packet(pv))
+			tries--;
+	}
+	if (!pv->established) {
+		pr_devel("HVSI@%x: returning -EPIPE\n", pv->termno);
+		return -EPIPE;
+	}
+	return read;
+}
+
+int hvsi_put_chars(struct hvsi_priv *pv, const char *buf, int count)
+{
+	struct hvsi_data dp;
+	int rc, adjcount = min(count, HVSI_MAX_OUTGOING_DATA);
+
+	if (WARN_ON(!pv))
+		return 0;
+
+	dp.hdr.type = VS_DATA_PACKET_HEADER;
+	dp.hdr.len = adjcount + sizeof(struct hvsi_header);
+	memcpy(dp.data, buf, adjcount);
+	rc = hvsi_send_packet(pv, &dp.hdr);
+	if (rc <= 0)
+		return rc;
+	return adjcount;
+}
+
+static void maybe_msleep(unsigned long ms)
+{
+	/* During early boot, IRQs are disabled, use mdelay */
+	if (irqs_disabled())
+		mdelay(ms);
+	else
+		msleep(ms);
+}
+
+int hvsi_read_mctrl(struct hvsi_priv *pv)
+{
+	struct hvsi_query q;
+	int rc, timeout;
+
+	pr_devel("HVSI@%x: Querying modem control status...\n",
+		 pv->termno);
+
+	pv->mctrl_update = 0;
+	q.hdr.type = VS_QUERY_PACKET_HEADER;
+	q.hdr.len = sizeof(struct hvsi_query);
+	q.hdr.seqno = atomic_inc_return(&pv->seqno);
+	q.verb = VSV_SEND_MODEM_CTL_STATUS;
+	rc = hvsi_send_packet(pv, &q.hdr);
+	if (rc <= 0) {
+		pr_devel("HVSI@%x: Error %d...\n", pv->termno, rc);
+		return rc;
+	}
+
+	/* Try for up to 200ms */
+	for (timeout = 0; timeout < 20; timeout++) {
+		if (!pv->established)
+			return -ENXIO;
+		if (pv->mctrl_update)
+			return 0;
+		if (!hvsi_get_packet(pv))
+			maybe_msleep(10);
+	}
+	return -EIO;
+}
+
+int hvsi_write_mctrl(struct hvsi_priv *pv, int dtr)
+{
+	struct hvsi_control ctrl;
+	unsigned short mctrl;
+
+	mctrl = pv->mctrl;
+	if (dtr)
+		mctrl |= TIOCM_DTR;
+	else
+		mctrl &= ~TIOCM_DTR;
+	if (mctrl == pv->mctrl)
+		return 0;
+	pv->mctrl = mctrl;
+
+	pr_devel("HVSI@%x: %s DTR...\n", pv->termno,
+		 dtr ? "Setting" : "Clearing");
+
+	ctrl.hdr.type = VS_CONTROL_PACKET_HEADER,
+	ctrl.hdr.len = sizeof(struct hvsi_control);
+	ctrl.verb = VSV_SET_MODEM_CTL;
+	ctrl.mask = HVSI_TSDTR;
+	ctrl.word = dtr ? HVSI_TSDTR : 0;
+	return hvsi_send_packet(pv, &ctrl.hdr);
+}
+
+void hvsi_establish(struct hvsi_priv *pv)
+{
+	int timeout;
+
+	pr_devel("HVSI@%x: Establishing...\n", pv->termno);
+
+	/* Try for up to 200ms, there can be a packet to
+	 * start the process waiting for us...
+	 */
+	for (timeout = 0; timeout < 20; timeout++) {
+		if (pv->established)
+			goto established;
+		if (!hvsi_get_packet(pv))
+			maybe_msleep(10);
+	}
+
+	/* Failed, send a close connection packet just
+	 * in case
+	 */
+	pr_devel("HVSI@%x:   ... sending close\n", pv->termno);
+
+	hvsi_send_close(pv);
+
+	/* Then restart handshake */
+
+	pr_devel("HVSI@%x:   ... restarting handshake\n", pv->termno);
+
+	hvsi_start_handshake(pv);
+
+	pr_devel("HVSI@%x:   ... waiting handshake\n", pv->termno);
+
+	/* Try for up to 200s */
+	for (timeout = 0; timeout < 20; timeout++) {
+		if (pv->established)
+			goto established;
+		if (!hvsi_get_packet(pv))
+			maybe_msleep(10);
+	}
+
+	if (!pv->established) {
+		pr_devel("HVSI@%x: Timeout handshaking, giving up !\n",
+			 pv->termno);
+		return;
+	}
+ established:
+	/* Query modem control lines */
+
+	pr_devel("HVSI@%x:   ... established, reading mctrl\n", pv->termno);
+
+	hvsi_read_mctrl(pv);
+
+	/* Set our own DTR */
+
+	pr_devel("HVSI@%x:   ... setting mctrl\n", pv->termno);
+
+	hvsi_write_mctrl(pv, 1);
+
+	/* Set the opened flag so reads are allowed */
+	wmb();
+	pv->opened = 1;
+}
+
+int hvsi_open(struct hvsi_priv *pv, struct hvc_struct *hp)
+{
+	pr_devel("HVSI@%x: open !\n", pv->termno);
+
+	/* Keep track of the tty data structure */
+	pv->tty = tty_kref_get(hp->tty);
+
+	hvsi_establish(pv);
+
+	return 0;
+}
+
+void hvsi_close(struct hvsi_priv *pv, struct hvc_struct *hp)
+{
+	unsigned long flags;
+
+	pr_devel("HVSI@%x: close !\n", pv->termno);
+
+	if (!pv->is_console) {
+		pr_devel("HVSI@%x: Not a console, tearing down\n",
+			 pv->termno);
+
+		/* Clear opened, synchronize with khvcd */
+		spin_lock_irqsave(&hp->lock, flags);
+		pv->opened = 0;
+		spin_unlock_irqrestore(&hp->lock, flags);
+
+		/* Clear our own DTR */
+		if (!pv->tty || (pv->tty->termios->c_cflag & HUPCL))
+			hvsi_write_mctrl(pv, 0);
+
+		/* Tear down the connection */
+		hvsi_send_close(pv);
+	}
+
+	if (pv->tty)
+		tty_kref_put(pv->tty);
+	pv->tty = NULL;
+}
+
+void hvsi_init(struct hvsi_priv *pv,
+	       int (*get_chars)(uint32_t termno, char *buf, int count),
+	       int (*put_chars)(uint32_t termno, const char *buf,
+				int count),
+	       int termno, int is_console)
+{
+	memset(pv, 0, sizeof(*pv));
+	pv->get_chars = get_chars;
+	pv->put_chars = put_chars;
+	pv->termno = termno;
+	pv->is_console = is_console;
+}


