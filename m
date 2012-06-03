Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab2FCUbP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 16:31:15 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51547 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377Ab2FCUbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 16:31:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: hacklu <embedway.linux@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4FCB602B.70907@zytor.com> (H. Peter Anvin's message of "Sun, 03
	Jun 2012 06:01:31 -0700")
References: <4FB492F7.8050401@gmail.com> <87ipf9gtsb.fsf@xmission.com>
	<4FCAD590.8000506@zytor.com> <87obp0bxdv.fsf@xmission.com>
	<4FCB602B.70907@zytor.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Sun, 03 Jun 2012 13:30:49 -0700
Message-ID: <87fwacb0jq.fsf_-_@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+lLtqQd6LozqIBG5Y3ESJ8XEylMEftzQY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4908]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_XMDrugObfuBody_14 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
Subject: [PATCH 1/2] x86, boot: Don't overlap the compressed and non-compressed image
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In practice there is enough room in the _bss that this doesn't noticably
increase the amount of memory we use during boot, and it makes verifying
the code much simpler.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86/boot/compressed/misc.c    |   75 ------------------------------------
 arch/x86/boot/compressed/mkpiggy.c |    5 +--
 2 files changed, 1 insertions(+), 79 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 7116dcb..5b04b66 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -18,81 +18,6 @@
  */
 
 /*
- * Getting to provable safe in place decompression is hard.
- * Worst case behaviours need to be analyzed.
- * Background information:
- *
- * The file layout is:
- *    magic[2]
- *    method[1]
- *    flags[1]
- *    timestamp[4]
- *    extraflags[1]
- *    os[1]
- *    compressed data blocks[N]
- *    crc[4] orig_len[4]
- *
- * resulting in 18 bytes of non compressed data overhead.
- *
- * Files divided into blocks
- * 1 bit (last block flag)
- * 2 bits (block type)
- *
- * 1 block occurs every 32K -1 bytes or when there 50% compression
- * has been achieved. The smallest block type encoding is always used.
- *
- * stored:
- *    32 bits length in bytes.
- *
- * fixed:
- *    magic fixed tree.
- *    symbols.
- *
- * dynamic:
- *    dynamic tree encoding.
- *    symbols.
- *
- *
- * The buffer for decompression in place is the length of the
- * uncompressed data, plus a small amount extra to keep the algorithm safe.
- * The compressed data is placed at the end of the buffer.  The output
- * pointer is placed at the start of the buffer and the input pointer
- * is placed where the compressed data starts.  Problems will occur
- * when the output pointer overruns the input pointer.
- *
- * The output pointer can only overrun the input pointer if the input
- * pointer is moving faster than the output pointer.  A condition only
- * triggered by data whose compressed form is larger than the uncompressed
- * form.
- *
- * The worst case at the block level is a growth of the compressed data
- * of 5 bytes per 32767 bytes.
- *
- * The worst case internal to a compressed block is very hard to figure.
- * The worst case can at least be boundined by having one bit that represents
- * 32764 bytes and then all of the rest of the bytes representing the very
- * very last byte.
- *
- * All of which is enough to compute an amount of extra data that is required
- * to be safe.  To avoid problems at the block level allocating 5 extra bytes
- * per 32767 bytes of data is sufficient.  To avoind problems internal to a
- * block adding an extra 32767 bytes (the worst case uncompressed block size)
- * is sufficient, to ensure that in the worst case the decompressed data for
- * block will stop the byte before the compressed data for a block begins.
- * To avoid problems with the compressed data's meta information an extra 18
- * bytes are needed.  Leading to the formula:
- *
- * extra_bytes = (uncompressed_size >> 12) + 32768 + 18 + decompressor_size.
- *
- * Adding 8 bytes per 32K is a bit excessive but much easier to calculate.
- * Adding 32768 instead of 32767 just makes for round numbers.
- * Adding the decompressor_size is necessary as it musht live after all
- * of the data as well.  Last I measured the decompressor is about 14K.
- * 10K of actual data and 4K of bss.
- *
- */
-
-/*
  * gzip declarations
  */
 #define STATIC		static
diff --git a/arch/x86/boot/compressed/mkpiggy.c b/arch/x86/boot/compressed/mkpiggy.c
index 958a641..3f4a68d 100644
--- a/arch/x86/boot/compressed/mkpiggy.c
+++ b/arch/x86/boot/compressed/mkpiggy.c
@@ -70,10 +70,7 @@ int main(int argc, char *argv[])
 	 * sizes, compute the necessary decompression offset...
 	 */
 
-	offs = (olen > ilen) ? olen - ilen : 0;
-	offs += olen >> 12;	/* Add 8 bytes for each 32K block */
-	offs += 64*1024 + 128;	/* Add 64K + 128 bytes slack */
-	offs = (offs+4095) & ~4095; /* Round to a 4K boundary */
+	offs = (olen+4096) & ~4095;  /* Round to a 4K boundary */
 
 	printf(".section \".rodata..compressed\",\"a\",@progbits\n");
 	printf(".globl z_input_len\n");
-- 
1.7.5.4

