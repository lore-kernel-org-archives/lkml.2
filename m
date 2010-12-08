Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab0LHRSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 12:18:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52984 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644Ab0LHRSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 12:18:08 -0500
Date: Wed, 8 Dec 2010 09:13:31 -0800
From: Greg KH <gregkh@suse.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [121/127] [S390] nmi: fix clock comparator revalidation
Message-ID: <20101208171331.GA12918@suse.de>
References: <20101208004456.GA23578@kroah.com>
 <20101208004436.427324416@clark.site>
 <20101208080428.GA2523@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101208080428.GA2523@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 09:04:28AM +0100, Heiko Carstens wrote:
> On Tue, Dec 07, 2010 at 04:45:07PM -0800, Greg KH wrote:
> > 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > 
> > commit e8129c642155616d9e2160a75f103e127c8c3708 upstream.
> > 
> > On each machine check all registers are revalidated. The save area for
> > the clock comparator however only contains the upper most seven bytes
> > of the former contents, if valid.
> > Therefore the machine check handler uses a store clock instruction to
> > get the current time and writes that to the clock comparator register
> > which in turn will generate an immediate timer interrupt.
> > However within the lowcore the expected time of the next timer
> > interrupt is stored. If the interrupt happens before that time the
> > handler won't be called. In turn the clock comparator won't be
> > reprogrammed and therefore the interrupt condition stays pending which
> > causes an interrupt loop until the expected time is reached.
> > 
> > On NOHZ machines this can result in unresponsive machines since the
> > time of the next expected interrupted can be a couple of days in the
> > future.
> > 
> > To fix this just revalidate the clock comparator register with the
> > expected value.
> > In addition the special handling for udelay must be changed as well.
> > 
> > Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> > Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> [...]
> 
> > ---
> >  arch/s390/kernel/nmi.c |   10 ++++------
> >  arch/s390/lib/delay.c  |   14 +++++++++-----
> >  2 files changed, 13 insertions(+), 11 deletions(-)
> > 
> > --- a/arch/s390/kernel/nmi.c
> > +++ b/arch/s390/kernel/nmi.c
> > @@ -95,7 +95,6 @@ EXPORT_SYMBOL_GPL(s390_handle_mcck);
> >  static int notrace s390_revalidate_registers(struct mci *mci)
> >  {
> >  	int kill_task;
> > -	u64 tmpclock;
> >  	u64 zero;
> >  	void *fpt_save_area, *fpt_creg_save_area;
> > 
> > @@ -214,11 +213,10 @@ static int notrace s390_revalidate_regis
> >  			: "0", "cc");
> >  #endif
> >  	/* Revalidate clock comparator register */
> > -	asm volatile(
> > -		"	stck	0(%1)\n"
> > -		"	sckc	0(%1)"
> > -		: "=m" (tmpclock) : "a" (&(tmpclock)) : "cc", "memory");
> > -
> > +	if (S390_lowcore.clock_comparator == -1)
> > +		set_clock_comparator(S390_lowcore.mcck_clock);
> ^^^
> This line won't compile on 2.6.32. That's why I sent a slightly different
> patch to -stable (and also the reason why I removed Martin's Sign-off) ;)

Ah, please be more clear that you are sending a modifed version for me
to apply instead of taking the upstream patch directly, which is the
default for me to do so in order to make sure nothing is incorrect.

> 
> Here is the version I sent to stable@kernel.org again:
> 
> Subject: [S390] nmi: fix clock comparator revalidation

I'll go replace the version I had with this one.

thanks,

greg k-h
