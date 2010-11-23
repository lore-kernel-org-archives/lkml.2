Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab0KWKXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 05:23:09 -0500
Received: from mailfw02.zoner.fi ([84.34.147.249]:65126 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab0KWKXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 05:23:06 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] Decompressors: Check for write errors in decompress_unlzma.c
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alain Knaff <alain@knaff.lu>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>
From: Lasse Collin <lasse.collin@tukaani.org>
Date: Tue, 23 Nov 2010 12:22:38 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011231222.38849.lasse.collin@tukaani.org>
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lasse Collin <lasse.collin@tukaani.org>

The return value of wr->flush() is not checked in write_byte().
This means that the decompressor won't stop even if the caller
doesn't want more data. This can happen e.g. with corrupt
LZMA-compressed initramfs. Returning the error quickly allows
the user to see the error message quicker.

There is a similar missing check for wr.flush() near the end
of unlzma().

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
---

--- linux-2.6.37-rc3/lib/decompress_unlzma.c.orig	2010-11-23 11:10:07.000000000 +0200
+++ linux-2.6.37-rc3/lib/decompress_unlzma.c	2010-11-23 11:11:58.000000000 +0200
@@ -319,32 +319,38 @@ static inline uint8_t INIT peek_old_byte
 
 }
 
-static inline void INIT write_byte(struct writer *wr, uint8_t byte)
+static inline int INIT write_byte(struct writer *wr, uint8_t byte)
 {
 	wr->buffer[wr->buffer_pos++] = wr->previous_byte = byte;
 	if (wr->flush && wr->buffer_pos == wr->header->dict_size) {
 		wr->buffer_pos = 0;
 		wr->global_pos += wr->header->dict_size;
-		wr->flush((char *)wr->buffer, wr->header->dict_size);
+		if (wr->flush((char *)wr->buffer, wr->header->dict_size)
+				!= wr->header->dict_size)
+			return -1;
 	}
+	return 0;
 }
 
 
-static inline void INIT copy_byte(struct writer *wr, uint32_t offs)
+static inline int INIT copy_byte(struct writer *wr, uint32_t offs)
 {
-	write_byte(wr, peek_old_byte(wr, offs));
+	return write_byte(wr, peek_old_byte(wr, offs));
 }
 
-static inline void INIT copy_bytes(struct writer *wr,
+static inline int INIT copy_bytes(struct writer *wr,
 					 uint32_t rep0, int len)
 {
 	do {
-		copy_byte(wr, rep0);
+		if (copy_byte(wr, rep0))
+			return -1;
 		len--;
 	} while (len != 0 && wr->buffer_pos < wr->header->dst_size);
+
+	return len;
 }
 
-static inline void INIT process_bit0(struct writer *wr, struct rc *rc,
+static inline int INIT process_bit0(struct writer *wr, struct rc *rc,
 				     struct cstate *cst, uint16_t *p,
 				     int pos_state, uint16_t *prob,
 				     int lc, uint32_t literal_pos_mask) {
@@ -378,16 +384,17 @@ static inline void INIT process_bit0(str
 		uint16_t *prob_lit = prob + mi;
 		rc_get_bit(rc, prob_lit, &mi);
 	}
-	write_byte(wr, mi);
 	if (cst->state < 4)
 		cst->state = 0;
 	else if (cst->state < 10)
 		cst->state -= 3;
 	else
 		cst->state -= 6;
+
+	return write_byte(wr, mi);
 }
 
-static inline void INIT process_bit1(struct writer *wr, struct rc *rc,
+static inline int INIT process_bit1(struct writer *wr, struct rc *rc,
 					    struct cstate *cst, uint16_t *p,
 					    int pos_state, uint16_t *prob) {
   int offset;
@@ -418,8 +425,7 @@ static inline void INIT process_bit1(str
 
 				cst->state = cst->state < LZMA_NUM_LIT_STATES ?
 					9 : 11;
-				copy_byte(wr, cst->rep0);
-				return;
+				return copy_byte(wr, cst->rep0);
 			} else {
 				rc_update_bit_1(rc, prob);
 			}
@@ -521,12 +527,12 @@ static inline void INIT process_bit1(str
 		} else
 			cst->rep0 = pos_slot;
 		if (++(cst->rep0) == 0)
-			return;
+			return 0;
 	}
 
 	len += LZMA_MATCH_MIN_LEN;
 
-	copy_bytes(wr, cst->rep0, len);
+	return copy_bytes(wr, cst->rep0, len);
 }
 
 
@@ -629,11 +635,17 @@ STATIC inline int INIT unlzma(unsigned c
 		int pos_state =	get_pos(&wr) & pos_state_mask;
 		uint16_t *prob = p + LZMA_IS_MATCH +
 			(cst.state << LZMA_NUM_POS_BITS_MAX) + pos_state;
-		if (rc_is_bit_0(&rc, prob))
-			process_bit0(&wr, &rc, &cst, p, pos_state, prob,
-				     lc, literal_pos_mask);
-		else {
-			process_bit1(&wr, &rc, &cst, p, pos_state, prob);
+		if (rc_is_bit_0(&rc, prob)) {
+			if (process_bit0(&wr, &rc, &cst, p, pos_state, prob,
+					lc, literal_pos_mask)) {
+				error("LZMA data is corrupt");
+				goto exit_3;
+			}
+		} else {
+			if (process_bit1(&wr, &rc, &cst, p, pos_state, prob)) {
+				error("LZMA data is corrupt");
+				goto exit_3;
+			}
 			if (cst.rep0 == 0)
 				break;
 		}
@@ -643,9 +655,8 @@ STATIC inline int INIT unlzma(unsigned c
 
 	if (posp)
 		*posp = rc.ptr-rc.buffer;
-	if (wr.flush)
-		wr.flush(wr.buffer, wr.buffer_pos);
-	ret = 0;
+	if (!wr.flush || wr.flush(wr.buffer, wr.buffer_pos) == wr.buffer_pos)
+		ret = 0;
 exit_3:
 	large_free(p);
 exit_2:
