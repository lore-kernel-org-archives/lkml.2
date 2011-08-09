Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361Ab1HIFQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 01:16:03 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.32]:64445 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751039Ab1HIFQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 01:16:02 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (PLAIN)
X-Authority-Analysis: v=1.1 cv=QcSFu2tMqX8VyBnwf4xZriMeG3TVj1s8v1Rcea0EwGI= c=1 sm=0 a=869cbtyjxWwA:10 a=Q5ddDJdZykAA:10 a=ozIaqLvjkoIA:10 a=8nJEP1OIZ-IA:10 a=r17jK6sfZkYSxad0qIwqKg==:17 a=YORvzBCaAAAA:8 a=vXkmktcHWjgQkTmhYysA:9 a=RgDCSG5CPbp3uQ7cDRwA:7 a=wPNLvfGTeEIA:10 a=VV2__AUApEoA:10 a=r17jK6sfZkYSxad0qIwqKg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 24.153.165.185
Message-ID: <4E40C28F.6070006@systemfabricworks.com>
Date: Tue, 09 Aug 2011 00:15:59 -0500
From: Bob Pearson <rpearson@systemfabricworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux@horizon.com,
        joakim.tjernlund@transmode.se, fzago@systemfabricworks.com,
        rpearson@systemfabricworks.com, akpm@linux-foundation.org
Subject: [patch v3 1/7] crc32: move-to-documentation.diff
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moved a nice but long comment from lib/crc32.c to Documentation/crc32.txt
where it will more likely get read.

Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>

---
 Documentation/crc32.txt |  129 ++++++++++++++++++++++++++++++++++++++++++++++++
 lib/crc32.c             |  127 -----------------------------------------------
 2 files changed, 129 insertions(+), 127 deletions(-)

Index: infiniband/lib/crc32.c
===================================================================
--- infiniband.orig/lib/crc32.c
+++ infiniband/lib/crc32.c
@@ -208,133 +208,6 @@ u32 __pure crc32_be(u32 crc, unsigned ch
 EXPORT_SYMBOL(crc32_le);
 EXPORT_SYMBOL(crc32_be);

-/*
- * A brief CRC tutorial.
- *
- * A CRC is a long-division remainder.  You add the CRC to the message,
- * and the whole thing (message+CRC) is a multiple of the given
- * CRC polynomial.  To check the CRC, you can either check that the
- * CRC matches the recomputed value, *or* you can check that the
- * remainder computed on the message+CRC is 0.  This latter approach
- * is used by a lot of hardware implementations, and is why so many
- * protocols put the end-of-frame flag after the CRC.
- *
- * It's actually the same long division you learned in school, except that
- * - We're working in binary, so the digits are only 0 and 1, and
- * - When dividing polynomials, there are no carries.  Rather than add and
- *   subtract, we just xor.  Thus, we tend to get a bit sloppy about
- *   the difference between adding and subtracting.
- *
- * A 32-bit CRC polynomial is actually 33 bits long.  But since it's
- * 33 bits long, bit 32 is always going to be set, so usually the CRC
- * is written in hex with the most significant bit omitted.  (If you're
- * familiar with the IEEE 754 floating-point format, it's the same idea.)
- *
- * Note that a CRC is computed over a string of *bits*, so you have
- * to decide on the endianness of the bits within each byte.  To get
- * the best error-detecting properties, this should correspond to the
- * order they're actually sent.  For example, standard RS-232 serial is
- * little-endian; the most significant bit (sometimes used for parity)
- * is sent last.  And when appending a CRC word to a message, you should
- * do it in the right order, matching the endianness.
- *
- * Just like with ordinary division, the remainder is always smaller than
- * the divisor (the CRC polynomial) you're dividing by.  Each step of the
- * division, you take one more digit (bit) of the dividend and append it
- * to the current remainder.  Then you figure out the appropriate multiple
- * of the divisor to subtract to being the remainder back into range.
- * In binary, it's easy - it has to be either 0 or 1, and to make the
- * XOR cancel, it's just a copy of bit 32 of the remainder.
- *
- * When computing a CRC, we don't care about the quotient, so we can
- * throw the quotient bit away, but subtract the appropriate multiple of
- * the polynomial from the remainder and we're back to where we started,
- * ready to process the next bit.
- *
- * A big-endian CRC written this way would be coded like:
- * for (i = 0; i < input_bits; i++) {
- * 	multiple = remainder & 0x80000000 ? CRCPOLY : 0;
- * 	remainder = (remainder << 1 | next_input_bit()) ^ multiple;
- * }
- * Notice how, to get at bit 32 of the shifted remainder, we look
- * at bit 31 of the remainder *before* shifting it.
- *
- * But also notice how the next_input_bit() bits we're shifting into
- * the remainder don't actually affect any decision-making until
- * 32 bits later.  Thus, the first 32 cycles of this are pretty boring.
- * Also, to add the CRC to a message, we need a 32-bit-long hole for it at
- * the end, so we have to add 32 extra cycles shifting in zeros at the
- * end of every message,
- *
- * So the standard trick is to rearrage merging in the next_input_bit()
- * until the moment it's needed.  Then the first 32 cycles can be precomputed,
- * and merging in the final 32 zero bits to make room for the CRC can be
- * skipped entirely.
- * This changes the code to:
- * for (i = 0; i < input_bits; i++) {
- *      remainder ^= next_input_bit() << 31;
- * 	multiple = (remainder & 0x80000000) ? CRCPOLY : 0;
- * 	remainder = (remainder << 1) ^ multiple;
- * }
- * With this optimization, the little-endian code is simpler:
- * for (i = 0; i < input_bits; i++) {
- *      remainder ^= next_input_bit();
- * 	multiple = (remainder & 1) ? CRCPOLY : 0;
- * 	remainder = (remainder >> 1) ^ multiple;
- * }
- *
- * Note that the other details of endianness have been hidden in CRCPOLY
- * (which must be bit-reversed) and next_input_bit().
- *
- * However, as long as next_input_bit is returning the bits in a sensible
- * order, we can actually do the merging 8 or more bits at a time rather
- * than one bit at a time:
- * for (i = 0; i < input_bytes; i++) {
- * 	remainder ^= next_input_byte() << 24;
- * 	for (j = 0; j < 8; j++) {
- * 		multiple = (remainder & 0x80000000) ? CRCPOLY : 0;
- * 		remainder = (remainder << 1) ^ multiple;
- * 	}
- * }
- * Or in little-endian:
- * for (i = 0; i < input_bytes; i++) {
- * 	remainder ^= next_input_byte();
- * 	for (j = 0; j < 8; j++) {
- * 		multiple = (remainder & 1) ? CRCPOLY : 0;
- * 		remainder = (remainder << 1) ^ multiple;
- * 	}
- * }
- * If the input is a multiple of 32 bits, you can even XOR in a 32-bit
- * word at a time and increase the inner loop count to 32.
- *
- * You can also mix and match the two loop styles, for example doing the
- * bulk of a message byte-at-a-time and adding bit-at-a-time processing
- * for any fractional bytes at the end.
- *
- * The only remaining optimization is to the byte-at-a-time table method.
- * Here, rather than just shifting one bit of the remainder to decide
- * in the correct multiple to subtract, we can shift a byte at a time.
- * This produces a 40-bit (rather than a 33-bit) intermediate remainder,
- * but again the multiple of the polynomial to subtract depends only on
- * the high bits, the high 8 bits in this case.
- *
- * The multiple we need in that case is the low 32 bits of a 40-bit
- * value whose high 8 bits are given, and which is a multiple of the
- * generator polynomial.  This is simply the CRC-32 of the given
- * one-byte message.
- *
- * Two more details: normally, appending zero bits to a message which
- * is already a multiple of a polynomial produces a larger multiple of that
- * polynomial.  To enable a CRC to detect this condition, it's common to
- * invert the CRC before appending it.  This makes the remainder of the
- * message+crc come out not as zero, but some fixed non-zero value.
- *
- * The same problem applies to zero bits prepended to the message, and
- * a similar solution is used.  Instead of starting with a remainder of
- * 0, an initial remainder of all ones is used.  As long as you start
- * the same way on decoding, it doesn't make a difference.
- */
-
 #ifdef UNITTEST

 #include <stdlib.h>
Index: infiniband/Documentation/crc32.txt
===================================================================
--- /dev/null
+++ infiniband/Documentation/crc32.txt
@@ -0,0 +1,129 @@
+
+A brief CRC tutorial.
+
+A CRC is a long-division remainder.  You add the CRC to the message,
+and the whole thing (message+CRC) is a multiple of the given
+CRC polynomial.  To check the CRC, you can either check that the
+CRC matches the recomputed value, *or* you can check that the
+remainder computed on the message+CRC is 0.  This latter approach
+is used by a lot of hardware implementations, and is why so many
+protocols put the end-of-frame flag after the CRC.
+
+It's actually the same long division you learned in school, except that
+- We're working in binary, so the digits are only 0 and 1, and
+- When dividing polynomials, there are no carries.  Rather than add and
+  subtract, we just xor.  Thus, we tend to get a bit sloppy about
+  the difference between adding and subtracting.
+
+A 32-bit CRC polynomial is actually 33 bits long.  But since it's
+33 bits long, bit 32 is always going to be set, so usually the CRC
+is written in hex with the most significant bit omitted.  (If you're
+familiar with the IEEE 754 floating-point format, it's the same idea.)
+
+Note that a CRC is computed over a string of *bits*, so you have
+to decide on the endianness of the bits within each byte.  To get
+the best error-detecting properties, this should correspond to the
+order they're actually sent.  For example, standard RS-232 serial is
+little-endian; the most significant bit (sometimes used for parity)
+is sent last.  And when appending a CRC word to a message, you should
+do it in the right order, matching the endianness.
+
+Just like with ordinary division, the remainder is always smaller than
+the divisor (the CRC polynomial) you're dividing by.  Each step of the
+division, you take one more digit (bit) of the dividend and append it
+to the current remainder.  Then you figure out the appropriate multiple
+of the divisor to subtract to being the remainder back into range.
+In binary, it's easy - it has to be either 0 or 1, and to make the
+XOR cancel, it's just a copy of bit 32 of the remainder.
+
+When computing a CRC, we don't care about the quotient, so we can
+throw the quotient bit away, but subtract the appropriate multiple of
+the polynomial from the remainder and we're back to where we started,
+ready to process the next bit.
+
+A big-endian CRC written this way would be coded like:
+for (i = 0; i < input_bits; i++) {
+	multiple = remainder & 0x80000000 ? CRCPOLY : 0;
+	remainder = (remainder << 1 | next_input_bit()) ^ multiple;
+}
+
+Notice how, to get at bit 32 of the shifted remainder, we look
+at bit 31 of the remainder *before* shifting it.
+
+But also notice how the next_input_bit() bits we're shifting into
+the remainder don't actually affect any decision-making until
+32 bits later.  Thus, the first 32 cycles of this are pretty boring.
+Also, to add the CRC to a message, we need a 32-bit-long hole for it at
+the end, so we have to add 32 extra cycles shifting in zeros at the
+end of every message,
+
+So the standard trick is to rearrage merging in the next_input_bit()
+until the moment it's needed.  Then the first 32 cycles can be precomputed,
+and merging in the final 32 zero bits to make room for the CRC can be
+skipped entirely.
+This changes the code to:
+for (i = 0; i < input_bits; i++) {
+     remainder ^= next_input_bit() << 31;
+	multiple = (remainder & 0x80000000) ? CRCPOLY : 0;
+	remainder = (remainder << 1) ^ multiple;
+}
+
+With this optimization, the little-endian code is simpler:
+for (i = 0; i < input_bits; i++) {
+     remainder ^= next_input_bit();
+	multiple = (remainder & 1) ? CRCPOLY : 0;
+	remainder = (remainder >> 1) ^ multiple;
+}
+
+Note that the other details of endianness have been hidden in CRCPOLY
+(which must be bit-reversed) and next_input_bit().
+
+However, as long as next_input_bit is returning the bits in a sensible
+order, we can actually do the merging 8 or more bits at a time rather
+than one bit at a time:
+for (i = 0; i < input_bytes; i++) {
+	remainder ^= next_input_byte() << 24;
+	for (j = 0; j < 8; j++) {
+		multiple = (remainder & 0x80000000) ? CRCPOLY : 0;
+		remainder = (remainder << 1) ^ multiple;
+	}
+}
+Or in little-endian:
+for (i = 0; i < input_bytes; i++) {
+	remainder ^= next_input_byte();
+	for (j = 0; j < 8; j++) {
+		multiple = (remainder & 1) ? CRCPOLY : 0;
+		remainder = (remainder << 1) ^ multiple;
+	}
+}
+
+If the input is a multiple of 32 bits, you can even XOR in a 32-bit
+word at a time and increase the inner loop count to 32.
+
+You can also mix and match the two loop styles, for example doing the
+bulk of a message byte-at-a-time and adding bit-at-a-time processing
+for any fractional bytes at the end.
+
+The only remaining optimization is to the byte-at-a-time table method.
+Here, rather than just shifting one bit of the remainder to decide
+in the correct multiple to subtract, we can shift a byte at a time.
+This produces a 40-bit (rather than a 33-bit) intermediate remainder,
+but again the multiple of the polynomial to subtract depends only on
+the high bits, the high 8 bits in this case.
+
+The multiple we need in that case is the low 32 bits of a 40-bit
+value whose high 8 bits are given, and which is a multiple of the
+generator polynomial.  This is simply the CRC-32 of the given
+one-byte message.
+
+Two more details: normally, appending zero bits to a message which
+is already a multiple of a polynomial produces a larger multiple of that
+polynomial.  To enable a CRC to detect this condition, it's common to
+invert the CRC before appending it.  This makes the remainder of the
+message+crc come out not as zero, but some fixed non-zero value.
+
+The same problem applies to zero bits prepended to the message, and
+a similar solution is used.  Instead of starting with a remainder of
+0, an initial remainder of all ones is used.  As long as you start
+the same way on decoding, it doesn't make a difference.
+
