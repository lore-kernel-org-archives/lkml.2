Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780Ab2GAOza (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 10:55:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41434 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634Ab2GAOz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 10:55:28 -0400
Date: Sun, 1 Jul 2012 07:55:14 -0700
From: "tip-bot for Eric W. Biederman" <ebiederm@xmission.com>
Message-ID: <tip-a1ee43a24ff87a165fe41dcc373d3b7912d0d3fa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, ebiederm@xmission.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, ebiederm@xmission.com
In-Reply-To: <87fwacb0jq.fsf_-_@xmission.com>
References: <87fwacb0jq.fsf_-_@xmission.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/boot] x86, boot: Don'
 t overlap the compressed and non-compressed image
Git-Commit-ID: a1ee43a24ff87a165fe41dcc373d3b7912d0d3fa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 01 Jul 2012 07:55:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a1ee43a24ff87a165fe41dcc373d3b7912d0d3fa
Gitweb:     http://git.kernel.org/tip/a1ee43a24ff87a165fe41dcc373d3b7912d0d3fa
Author:     Eric W. Biederman <ebiederm@xmission.com>
AuthorDate: Sun, 3 Jun 2012 13:30:49 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sat, 30 Jun 2012 19:20:39 -0700

x86, boot: Don't overlap the compressed and non-compressed image

In practice there is enough room in the _bss that this doesn't noticably
increase the amount of memory we use during boot, and it makes verifying
the code much simpler.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Link: http://lkml.kernel.org/r/87fwacb0jq.fsf_-_@xmission.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
