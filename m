Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab2E3OFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 10:05:24 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:13726 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754271Ab2E3OFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 10:05:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAAEoxk/CTtAn/2dsb2JhbABEtA2BB4IXAQEEATIBRgULCxguFBgxE4gGCbkbiwUBhGFgA5UXAYkfhlSCYoFd
Date: Wed, 30 May 2012 16:04:44 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68k: Use generic strncpy_from_user(), strlen_user(),
	and strnlen_user()
Message-ID: <20120530140444.GA10543@frolo.macqel>
References: <1338327216-15309-1-git-send-email-geert@linux-m68k.org> <20120530102226.GA28628@frolo.macqel> <CAMuHMdV5GVZR1BvGD3EncDFfPt=Bt9ndkKE8Mp7euE9KoSaGNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdV5GVZR1BvGD3EncDFfPt=Bt9ndkKE8Mp7euE9KoSaGNQ@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 01:20:02PM +0200, Geert Uytterhoeven wrote:
> On Wed, May 30, 2012 at 12:22 PM, Philippe De Muyter <phdm@macqel.be> wrote:
> > On Tue, May 29, 2012 at 11:33:36PM +0200, Geert Uytterhoeven wrote:
> >> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> >> ---
> >> Do we also want
> >>
> >>     select HAVE_EFFICIENT_UNALIGNED_ACCESS if (!COLDFIRE && !M68000)
> >
> > Sorry, I did not follow what happened to unaligned accesses, but
> > CPU32 family (at least 68340) crashes on unaligned accesses.
> 
> We don't seem to have CONFIG_M68340 in arch/m68k/Kconfig.cpu?

I have a local port here (but based on an ancient linux kernel, 2.6.2 IIRC)

> But Freescale's website confirms both 68340 and 68360 are CPU32.
> 
> arch/m68k/include/asm/unaligned.h assumes CPU32 (CONFIG_MCPU32)
> can do unaligned accesses:

That's not true.  Accessing a 16- or 32-bit word at an odd address
with a 68340 generates an Address Error Exception.  I remember
discovering a bug in the ppp kernel code because of that.

> 
> #if defined(CONFIG_COLDFIRE) || defined(CONFIG_M68000)
> #include <linux/unaligned/be_struct.h>
> #include <linux/unaligned/le_byteshift.h>
> #include <linux/unaligned/generic.h>
> 
> #define get_unaligned   __get_unaligned_be
> #define put_unaligned   __put_unaligned_be
> 
> #else
> /*
>  * The m68k can do unaligned accesses itself.
>  */
> #include <linux/unaligned/access_ok.h>
> #include <linux/unaligned/generic.h>
> 
> #define get_unaligned   __get_unaligned_be
> #define put_unaligned   __put_unaligned_be
> 
> #endif
> 
> Is this wrong?

I can't tell from reading just the lines above, but I think one should add
"|| defined(CONFIG_MCPU32)" at the end of the if condition.

I also think that the Coldfire 5272 can do unaligned accesses, but I
cannot test that at the moment.

> 
> However, for CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS,
> the question is not whether unaligned accesses are supported, but
> whether they are more efficient than byte copies when copying larger blocks.

OK, thanks

Philippe

-- 
Philippe De Muyter +32 2 6101532 Macq SA rue de l'Aeronef 2 B-1140 Bruxelles
