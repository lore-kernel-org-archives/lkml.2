Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab0HKTi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 15:38:29 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:47209 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756379Ab0HKTi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 15:38:28 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] [resend] Re: 6175ddf06b6172046a329e3abfd9c901a43efd2e breaks matroxfb console
Cc: brgerst@gmail.com, Kernel development list <linux-kernel@vger.kernel.org>
Content-Disposition: inline
From: Ondrej Zary <linux@rainbow-software.org>
Date: Wed, 11 Aug 2010 21:38:17 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008112138.19113.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 August 2010 23:42:29 H. Peter Anvin wrote:
> On 08/02/2010 02:35 PM, Ondrej Zary wrote:
> > The patch below fixes it for me. Is it correct on all architectures?
> >
> > --- linux-2.6.35-rc2/drivers/video/matrox/matroxfb_base.h	2010-06-06
> > 05:43:24.000000000 +0200 +++
> > linux-2.6.35-rc3/drivers/video/matrox/matroxfb_base.h	2010-08-02
> > 23:31:34.000000000 +0200 @@ -157,7 +157,7 @@ static inline void
> > mga_memcpy_toio(vaddr
> >  	 *  (3) It copes with unaligned source (destination is guaranteed to be
> > page *      aligned and length is guaranteed to be multiple of 4). */
> > -	memcpy_toio(va.vaddr, src, len);
> > +	iowrite32_rep(va.vaddr, src, len);
> >  #else
> >          u_int32_t __iomem* addr = va.vaddr;
>
> I don't think so; in particular I don't *think* non-x86 architectures
> will deal with the requirement that it handles an unaligned source.  As
> such, the #if would still be necessary; the #else clause could be
> replaced with a get_unaligned() ... iowrite32() loop.

Just tested the #else part on sparc and it seems to work fine - so I'm not going to touch (break) it.

> The other thing to watch out for is that "len" passed to iowrite32_rep()
> is a count of 32-bit words, whereas memcpy_toio() takes a byte count...
> you need to >> 2 there.

Thanks.

Here's v2 patch:


Fix incorrect use of memcpy_toio() in matroxfb that broke in 2.6.34.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.35-rc2/drivers/video/matrox/matroxfb_base.h	2010-06-06 05:43:24.000000000 +0200
+++ linux-2.6.35-rc3/drivers/video/matrox/matroxfb_base.h	2010-08-03 18:13:46.000000000 +0200
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
 


-- 
Ondrej Zary
