Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab1EFANm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:13:42 -0400
Received: from kroah.org ([198.145.64.141]:32950 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892Ab1EFANi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:13:38 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:12:10 2011
Message-Id: <20110506001210.446717674@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:11:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lasse Collin <lasse.collin@tukaani.org>
Subject: [patch 32/38] XZ decompressor: Fix decoding of empty LZMA2 streams
In-Reply-To: <20110506001225.GA10547@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lasse Collin <lasse.collin@tukaani.org>

commit 646032e3b05b32d3f20cb108a030593d9d792eb5 upstream.

The old code considered valid empty LZMA2 streams to be corrupt.
Note that a typical empty .xz file has no LZMA2 data at all,
and thus most .xz files having no uncompressed data are handled
correctly even without this fix.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 lib/xz/xz_dec_lzma2.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/xz/xz_dec_lzma2.c
+++ b/lib/xz/xz_dec_lzma2.c
@@ -969,6 +969,9 @@ XZ_EXTERN enum xz_ret xz_dec_lzma2_run(s
 			 */
 			tmp = b->in[b->in_pos++];
 
+			if (tmp == 0x00)
+				return XZ_STREAM_END;
+
 			if (tmp >= 0xE0 || tmp == 0x01) {
 				s->lzma2.need_props = true;
 				s->lzma2.need_dict_reset = false;
@@ -1001,9 +1004,6 @@ XZ_EXTERN enum xz_ret xz_dec_lzma2_run(s
 						lzma_reset(s);
 				}
 			} else {
-				if (tmp == 0x00)
-					return XZ_STREAM_END;
-
 				if (tmp > 0x02)
 					return XZ_DATA_ERROR;
 


