Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab1IUOnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 10:43:52 -0400
Received: from mailfw02.zoner.fi ([84.34.147.249]:29702 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab1IUOnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 10:43:50 -0400
X-Greylist: delayed 714 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Sep 2011 10:43:50 EDT
Date: Wed, 21 Sep 2011 17:30:50 +0300
From: Lasse Collin <lasse.collin@tukaani.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: [PATCH] XZ: Fix incorrect XZ_BUF_ERROR
Message-ID: <20110921173050.5c064a57@tukaani.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lasse Collin <lasse.collin@tukaani.org>

xz_dec_run() could incorrectly return XZ_BUF_ERROR if
all of the following was true:

  - The caller knows how many bytes of output to expect
    and only provides that much output space.

  - When the last output bytes are decoded, the
    caller-provided input buffer ends right before
    the LZMA2 end of payload marker. So LZMA2 won't
    provide more output anymore, but it won't know it
    yet and thus won't return XZ_STREAM_END yet.

  - A BCJ filter is in use and it hasn't left any
    unfiltered bytes in the temp buffer. This can happen
    with any BCJ filter, but in practice it's more likely
    with filters other than the x86 BCJ.

This fixes <https://bugzilla.redhat.com/show_bug.cgi?id=735408>
where Squashfs thinks that a valid file system is corrupt.

This also fixes a similar bug in single-call mode where the
uncompressed size of a block using BCJ + LZMA2 was 0 bytes
and caller provided no output space. Many empty .xz files
don't contain any blocks and thus don't trigger this bug.

This also tweaks a closely related detail: xz_dec_bcj_run()
could call xz_dec_lzma2_run() to decode into temp buffer when
it was known to be useless. This was harmless although it
wasted a minuscule number of CPU cycles.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Cc: stable <stable@kernel.org>
---

 lib/xz/xz_dec_bcj.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff -uprN linux-3.0.orig/lib/xz/xz_dec_bcj.c linux-3.0/lib/xz/xz_dec_bcj.c
--- linux-3.0.orig/lib/xz/xz_dec_bcj.c	2011-07-22 05:17:23.000000000 +0300
+++ linux-3.0/lib/xz/xz_dec_bcj.c	2011-09-21 12:21:25.423439202 +0300
@@ -441,8 +441,12 @@ XZ_EXTERN enum xz_ret xz_dec_bcj_run(str
 	 * next filter in the chain. Apply the BCJ filter on the new data
 	 * in the output buffer. If everything cannot be filtered, copy it
 	 * to temp and rewind the output buffer position accordingly.
+	 *
+	 * This needs to be always run when temp.size == 0 to handle a special
+	 * case where the output buffer is full and the next filter has no
+	 * more output coming but hasn't returned XZ_STREAM_END yet.
 	 */
-	if (s->temp.size < b->out_size - b->out_pos) {
+	if (s->temp.size < b->out_size - b->out_pos || s->temp.size == 0) {
 		out_start = b->out_pos;
 		memcpy(b->out + b->out_pos, s->temp.buf, s->temp.size);
 		b->out_pos += s->temp.size;
@@ -465,16 +469,25 @@ XZ_EXTERN enum xz_ret xz_dec_bcj_run(str
 		s->temp.size = b->out_pos - out_start;
 		b->out_pos -= s->temp.size;
 		memcpy(s->temp.buf, b->out + b->out_pos, s->temp.size);
+
+		/*
+		 * If there wasn't enough input to the next filter to fill
+		 * the output buffer with unfiltered data, there's no point
+		 * to try decoding more data to temp.
+		 */
+		if (b->out_pos + s->temp.size < b->out_size)
+			return XZ_OK;
 	}
 
 	/*
-	 * If we have unfiltered data in temp, try to fill by decoding more
-	 * data from the next filter. Apply the BCJ filter on temp. Then we
-	 * hopefully can fill the actual output buffer by copying filtered
-	 * data from temp. A mix of filtered and unfiltered data may be left
-	 * in temp; it will be taken care on the next call to this function.
+	 * We have unfiltered data in temp. If the output buffer isn't full
+	 * yet, try to fill the temp buffer by decoding more data from the
+	 * next filter. Apply the BCJ filter on temp. Then we hopefully can
+	 * fill the actual output buffer by copying filtered data from temp.
+	 * A mix of filtered and unfiltered data may be left in temp; it will
+	 * be taken care on the next call to this function.
 	 */
-	if (s->temp.size > 0) {
+	if (b->out_pos < b->out_size) {
 		/* Make b->out{,_pos,_size} temporarily point to s->temp. */
 		s->out = b->out;
 		s->out_pos = b->out_pos;
