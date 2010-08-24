Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934275Ab0HXXgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:36:03 -0400
Received: from kroah.org ([198.145.64.141]:40394 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932668Ab0HXW6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:58:43 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:15 2010
Message-Id: <20100824224214.990032189@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:41:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ondrej Zary <linux@rainbow-software.org>,
        Brian Gerst <brgerst@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Petr Vandrovec <vandrove@vc.cvut.cz>,
        Jean Delvare <khali@linux-fr.org>
Subject: [34/91] matroxfb: fix incorrect use of memcpy_toio()
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ondrej Zary <linux@rainbow-software.org>

commit c81476df1b4241aefba4ff83a7701b3a926bd7ce upstream.

Screen is completely corrupted since 2.6.34.  Bisection revealed that it's
caused by commit 6175ddf06b61720 ("x86: Clean up mem*io functions.").

H.  Peter Anvin explained that memcpy_toio() does not copy data in 32bit
chunks anymore on x86.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Petr Vandrovec <vandrove@vc.cvut.cz>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/matrox/matroxfb_base.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/video/matrox/matroxfb_base.h
+++ b/drivers/video/matrox/matroxfb_base.h
@@ -151,13 +151,13 @@ static inline void mga_writel(vaddr_t va
 static inline void mga_memcpy_toio(vaddr_t va, const void* src, int len) {
 #if defined(__alpha__) || defined(__i386__) || defined(__x86_64__)
 	/*
-	 * memcpy_toio works for us if:
+	 * iowrite32_rep works for us if:
 	 *  (1) Copies data as 32bit quantities, not byte after byte,
 	 *  (2) Performs LE ordered stores, and
 	 *  (3) It copes with unaligned source (destination is guaranteed to be page
 	 *      aligned and length is guaranteed to be multiple of 4).
 	 */
-	memcpy_toio(va.vaddr, src, len);
+	iowrite32_rep(va.vaddr, src, len >> 2);
 #else
         u_int32_t __iomem* addr = va.vaddr;
 


