Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab0HBVfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 17:35:21 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:56156 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751255Ab0HBVfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 17:35:20 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 6175ddf06b6172046a329e3abfd9c901a43efd2e breaks matroxfb console
Date: Mon, 2 Aug 2010 23:35:10 +0200
User-Agent: KMail/1.9.10
Cc: brgerst@gmail.com, Kernel development list <linux-kernel@vger.kernel.org>
References: <201008022150.01037.linux@rainbow-software.org> <201008022314.26743.linux@rainbow-software.org> <4C573575.8040701@zytor.com>
In-Reply-To: <4C573575.8040701@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008022335.12191.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 August 2010 23:15:33 H. Peter Anvin wrote:
> On 08/02/2010 02:14 PM, Ondrej Zary wrote:
> > On Monday 02 August 2010 23:04:28 H. Peter Anvin wrote:
> >> On 08/02/2010 12:49 PM, Ondrej Zary wrote:
> >>> Hello,
> >>> matroxfb (at least with Mystique and Mystique 220) stopped working in
> >>> 2.6.34 - the screen is completely corrupted. Bisection shows that
> >>> 6175ddf06b6172046a329e3abfd9c901a43efd2e is first bad commit.
> >>>
> >>> Reverting 6175ddf06b6172046a329e3abfd9c901a43efd2e in 2.6.34 fixes the
> >>> problem (1c5b9069e12e20d2fe883076ae0bf73966492108 must be reverted
> >>> first).
> >>
> >> Sounds like another driver which used memcpy_toio() when it should have
> >> used iowrite32_rep() or __iowrite32_copy().
> >>
> >> Hmm... is __iowrite32_copy() and iowrite32_rep() redundant?  If so, we
> >> should get rid of the former.
> >
> > There is a wrapper in drivers/video/matrox/matroxfb_base.h (see below)
> > with some comment. So this commit changed one of the three points?
> >
> > static inline void mga_memcpy_toio(vaddr_t va, const void* src, int len)
> > { #if defined(__alpha__) || defined(__i386__) || defined(__x86_64__) /*
> >          * memcpy_toio works for us if:
> >          *  (1) Copies data as 32bit quantities, not byte after byte,
> >          *  (2) Performs LE ordered stores, and
> >          *  (3) It copes with unaligned source (destination is guaranteed
> > to be page *      aligned and length is guaranteed to be multiple of 4).
> > */
> >         memcpy_toio(va.vaddr, src, len);
> > #else
>
> Yes, point (1) is not guaranteed by memcpy_toio().

Now I wonder how many drivers will this break...

The patch below fixes it for me. Is it correct on all architectures?

--- linux-2.6.35-rc2/drivers/video/matrox/matroxfb_base.h	2010-06-06 05:43:24.000000000 +0200
+++ linux-2.6.35-rc3/drivers/video/matrox/matroxfb_base.h	2010-08-02 23:31:34.000000000 +0200
@@ -157,7 +157,7 @@ static inline void mga_memcpy_toio(vaddr
 	 *  (3) It copes with unaligned source (destination is guaranteed to be page
 	 *      aligned and length is guaranteed to be multiple of 4).
 	 */
-	memcpy_toio(va.vaddr, src, len);
+	iowrite32_rep(va.vaddr, src, len);
 #else
         u_int32_t __iomem* addr = va.vaddr;
 


-- 
Ondrej Zary
