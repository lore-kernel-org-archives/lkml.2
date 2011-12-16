Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032Ab1LPCWI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 21:22:08 -0500
Received: from shutemov.name ([188.40.19.243]:52599 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756376Ab1LPCWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 21:22:07 -0500
Date: Fri, 16 Dec 2011 04:22:05 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>,
        Siarhei Siamashka <siarhei.siamashka@nokia.com>,
        Valdis.Kletnieks@vt.edu, Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, Aaro Koskinen <aaro.koskinen@nokia.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] [RESEND] Handle instruction cache maintenance fault
 properly
Message-ID: <20111216022205.GA28787@shutemov.name>
References: <AANLkTilVp0xvAJNns3TEe4SzEUpN8hMC9DdwmwW7i9yX@mail.gmail.com>
 <20111215215649.GJ24496@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111215215649.GJ24496@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 10:56:49PM +0100, Uwe Kleine-König wrote:
> Hello,
> 
> On Tue, May 11, 2010 at 01:33:14PM +0300, Kirill A. Shutemov wrote:
> > Between "clean D line..." and "invalidate I line" operations in
> > v7_coherent_user_range(), the memory page may get swapped out.
> > And the fault on "invalidate I line" could not be properly handled
> > causing the oops.
> > 
> > In ARMv6 "external abort on linefetch" replaced by "instruction cache
> > maintenance fault". Let's handle it as translation fault. It fixes the
> > issue.
> > 
> > I'm not sure if it's reasonable to check arch version in run-time.
> > Let's do it in compile time for now.
> > 
> > Signed-off-by: Siarhei Siamashka <siarhei.siamashka@nokia.com>
> > Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> I found this patch in Catalin's stack that I picked up to get support
> for Cortex-M3. Is this still relevant?

It's in upstream. See 8c0b742.

> 
> Best regards
> Uwe
> 
> > Sorry for resend. I've made mistake in maillist address.
> > 
> > ---
> >  arch/arm/mm/fault.c |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
> > index 9d40c34..7f193ea 100644
> > --- a/arch/arm/mm/fault.c
> > +++ b/arch/arm/mm/fault.c
> > @@ -463,7 +463,12 @@ static struct fsr_info {
> >  	{ do_bad,		SIGILL,	 BUS_ADRALN,	"alignment exception"		   },
> >  	{ do_bad,		SIGKILL, 0,		"terminal exception"		   },
> >  	{ do_bad,		SIGILL,	 BUS_ADRALN,	"alignment exception"		   },
> > +/* Do we need runtime check ? */
> > +#if __LINUX_ARM_ARCH__ < 6
> >  	{ do_bad,		SIGBUS,	 0,		"external abort on linefetch"	   },
> > +#else
> > +	{ do_translation_fault,	SIGSEGV, SEGV_MAPPER,	"I-cache maintenance
> > fault"	   },
> > +#endif
> >  	{ do_translation_fault,	SIGSEGV, SEGV_MAPERR,	"section translation
> > fault"	   },
> >  	{ do_bad,		SIGBUS,	 0,		"external abort on linefetch"	   },
> >  	{ do_page_fault,	SIGSEGV, SEGV_MAPERR,	"page translation fault"	   },
> > -- 
> > 1.7.0.4
> > 
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> > 
> 
> -- 
> Pengutronix e.K.                           | Uwe Kleine-König            |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |

-- 
 Kirill A. Shutemov
