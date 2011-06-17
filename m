Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab1FQBIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 21:08:40 -0400
Received: from gate.crashing.org ([63.228.1.57]:43403 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260Ab1FQBIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 21:08:38 -0400
Subject: [PATCH 2/5] powerpc/pseries: Factor HVSI header struct in packet
 definitions
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Jun 2011 11:08:24 +1000
Message-ID: <1308272904.2516.106.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Embed the struct hvsi_header in the various packet definitions
rather than open coding it multiple times. Will help provide
stronger type checking.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/include/asm/hvsi.h |   16 ++-------
 drivers/tty/hvc/hvsi.c          |   66 +++++++++++++++++++-------------------
 2 files changed, 37 insertions(+), 45 deletions(-)

diff --git a/arch/powerpc/include/asm/hvsi.h b/arch/powerpc/include/asm/hvsi.h
index f13125a..ab2ddd7 100644
--- a/arch/powerpc/include/asm/hvsi.h
+++ b/arch/powerpc/include/asm/hvsi.h
@@ -29,16 +29,12 @@ struct hvsi_header {
 } __attribute__((packed));
 
 struct hvsi_data {
-	uint8_t  type;
-	uint8_t  len;
-	uint16_t seqno;
+	struct hvsi_header hdr;
 	uint8_t  data[HVSI_MAX_OUTGOING_DATA];
 } __attribute__((packed));
 
 struct hvsi_control {
-	uint8_t  type;
-	uint8_t  len;
-	uint16_t seqno;
+	struct hvsi_header hdr;
 	uint16_t verb;
 	/* optional depending on verb: */
 	uint32_t word;
@@ -46,16 +42,12 @@ struct hvsi_control {
 } __attribute__((packed));
 
 struct hvsi_query {
-	uint8_t  type;
-	uint8_t  len;
-	uint16_t seqno;
+	struct hvsi_header hdr;
 	uint16_t verb;
 } __attribute__((packed));
 
 struct hvsi_query_response {
-	uint8_t  type;
-	uint8_t  len;
-	uint16_t seqno;
+	struct hvsi_header hdr;
 	uint16_t verb;
 	uint16_t query_seqno;
 	union {
diff --git a/drivers/tty/hvc/hvsi.c b/drivers/tty/hvc/hvsi.c
index 0b35793..c94e2f5 100644
--- a/drivers/tty/hvc/hvsi.c
+++ b/drivers/tty/hvc/hvsi.c
@@ -295,18 +295,18 @@ static int hvsi_version_respond(struct hvsi_struct *hp, uint16_t query_seqno)
 	struct hvsi_query_response packet __ALIGNED__;
 	int wrote;
 
-	packet.type = VS_QUERY_RESPONSE_PACKET_HEADER;
-	packet.len = sizeof(struct hvsi_query_response);
-	packet.seqno = atomic_inc_return(&hp->seqno);
+	packet.hdr.type = VS_QUERY_RESPONSE_PACKET_HEADER;
+	packet.hdr.len = sizeof(struct hvsi_query_response);
+	packet.hdr.seqno = atomic_inc_return(&hp->seqno);
 	packet.verb = VSV_SEND_VERSION_NUMBER;
 	packet.u.version = HVSI_VERSION;
 	packet.query_seqno = query_seqno+1;
 
-	pr_debug("%s: sending %i bytes\n", __func__, packet.len);
-	dbg_dump_hex((uint8_t*)&packet, packet.len);
+	pr_debug("%s: sending %i bytes\n", __func__, packet.hdr.len);
+	dbg_dump_hex((uint8_t*)&packet, packet.hdr.len);
 
-	wrote = hvc_put_chars(hp->vtermno, (char *)&packet, packet.len);
-	if (wrote != packet.len) {
+	wrote = hvc_put_chars(hp->vtermno, (char *)&packet, packet.hdr.len);
+	if (wrote != packet.hdr.len) {
 		printk(KERN_ERR "hvsi%i: couldn't send query response!\n",
 			hp->index);
 		return -EIO;
@@ -321,7 +321,7 @@ static void hvsi_recv_query(struct hvsi_struct *hp, uint8_t *packet)
 
 	switch (hp->state) {
 		case HVSI_WAIT_FOR_VER_QUERY:
-			hvsi_version_respond(hp, query->seqno);
+			hvsi_version_respond(hp, query->hdr.seqno);
 			__set_state(hp, HVSI_OPEN);
 			break;
 		default:
@@ -579,16 +579,16 @@ static int hvsi_query(struct hvsi_struct *hp, uint16_t verb)
 	struct hvsi_query packet __ALIGNED__;
 	int wrote;
 
-	packet.type = VS_QUERY_PACKET_HEADER;
-	packet.len = sizeof(struct hvsi_query);
-	packet.seqno = atomic_inc_return(&hp->seqno);
+	packet.hdr.type = VS_QUERY_PACKET_HEADER;
+	packet.hdr.len = sizeof(struct hvsi_query);
+	packet.hdr.seqno = atomic_inc_return(&hp->seqno);
 	packet.verb = verb;
 
-	pr_debug("%s: sending %i bytes\n", __func__, packet.len);
-	dbg_dump_hex((uint8_t*)&packet, packet.len);
+	pr_debug("%s: sending %i bytes\n", __func__, packet.hdr.len);
+	dbg_dump_hex((uint8_t*)&packet, packet.hdr.len);
 
-	wrote = hvc_put_chars(hp->vtermno, (char *)&packet, packet.len);
-	if (wrote != packet.len) {
+	wrote = hvc_put_chars(hp->vtermno, (char *)&packet, packet.hdr.len);
+	if (wrote != packet.hdr.len) {
 		printk(KERN_ERR "hvsi%i: couldn't send query (%i)!\n", hp->index,
 			wrote);
 		return -EIO;
@@ -622,20 +622,20 @@ static int hvsi_set_mctrl(struct hvsi_struct *hp, uint16_t mctrl)
 	struct hvsi_control packet __ALIGNED__;
 	int wrote;
 
-	packet.type = VS_CONTROL_PACKET_HEADER,
-	packet.seqno = atomic_inc_return(&hp->seqno);
-	packet.len = sizeof(struct hvsi_control);
+	packet.hdr.type = VS_CONTROL_PACKET_HEADER,
+	packet.hdr.seqno = atomic_inc_return(&hp->seqno);
+	packet.hdr.len = sizeof(struct hvsi_control);
 	packet.verb = VSV_SET_MODEM_CTL;
 	packet.mask = HVSI_TSDTR;
 
 	if (mctrl & TIOCM_DTR)
 		packet.word = HVSI_TSDTR;
 
-	pr_debug("%s: sending %i bytes\n", __func__, packet.len);
-	dbg_dump_hex((uint8_t*)&packet, packet.len);
+	pr_debug("%s: sending %i bytes\n", __func__, packet.hdr.len);
+	dbg_dump_hex((uint8_t*)&packet, packet.hdr.len);
 
-	wrote = hvc_put_chars(hp->vtermno, (char *)&packet, packet.len);
-	if (wrote != packet.len) {
+	wrote = hvc_put_chars(hp->vtermno, (char *)&packet, packet.hdr.len);
+	if (wrote != packet.hdr.len) {
 		printk(KERN_ERR "hvsi%i: couldn't set DTR!\n", hp->index);
 		return -EIO;
 	}
@@ -705,13 +705,13 @@ static int hvsi_put_chars(struct hvsi_struct *hp, const char *buf, int count)
 
 	BUG_ON(count > HVSI_MAX_OUTGOING_DATA);
 
-	packet.type = VS_DATA_PACKET_HEADER;
-	packet.seqno = atomic_inc_return(&hp->seqno);
-	packet.len = count + sizeof(struct hvsi_header);
+	packet.hdr.type = VS_DATA_PACKET_HEADER;
+	packet.hdr.seqno = atomic_inc_return(&hp->seqno);
+	packet.hdr.len = count + sizeof(struct hvsi_header);
 	memcpy(&packet.data, buf, count);
 
-	ret = hvc_put_chars(hp->vtermno, (char *)&packet, packet.len);
-	if (ret == packet.len) {
+	ret = hvc_put_chars(hp->vtermno, (char *)&packet, packet.hdr.len);
+	if (ret == packet.hdr.len) {
 		/* return the number of chars written, not the packet length */
 		return count;
 	}
@@ -722,15 +722,15 @@ static void hvsi_close_protocol(struct hvsi_struct *hp)
 {
 	struct hvsi_control packet __ALIGNED__;
 
-	packet.type = VS_CONTROL_PACKET_HEADER;
-	packet.seqno = atomic_inc_return(&hp->seqno);
-	packet.len = 6;
+	packet.hdr.type = VS_CONTROL_PACKET_HEADER;
+	packet.hdr.seqno = atomic_inc_return(&hp->seqno);
+	packet.hdr.len = 6;
 	packet.verb = VSV_CLOSE_PROTOCOL;
 
-	pr_debug("%s: sending %i bytes\n", __func__, packet.len);
-	dbg_dump_hex((uint8_t*)&packet, packet.len);
+	pr_debug("%s: sending %i bytes\n", __func__, packet.hdr.len);
+	dbg_dump_hex((uint8_t*)&packet, packet.hdr.len);
 
-	hvc_put_chars(hp->vtermno, (char *)&packet, packet.len);
+	hvc_put_chars(hp->vtermno, (char *)&packet, packet.hdr.len);
 }
 
 static int hvsi_open(struct tty_struct *tty, struct file *filp)


