Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab1DKXNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 19:13:43 -0400
Received: from kroah.org ([198.145.64.141]:42922 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199Ab1DKXNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 19:13:42 -0400
Date: Mon, 11 Apr 2011 15:57:10 -0700
From: Greg KH <greg@kroah.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Greg KH <gregkh@suse.de>, Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [05/35] powerpc/kdump: Fix race in kdump shutdown
Message-ID: <20110411225710.GB32589@kroah.com>
References: <20110326000509.GA29736@kroah.com>
 <20110326000456.346395018@clark.kroah.org>
 <AANLkTi=XPPxVYPB8fzr2Ent3QOsKF=JunhGL+ExEk_7f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=XPPxVYPB8fzr2Ent3QOsKF=JunhGL+ExEk_7f@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 07:27:06PM -0400, Paul Gortmaker wrote:
> On Fri, Mar 25, 2011 at 8:03 PM, Greg KH <gregkh@suse.de> wrote:
> > 2.6.33-longterm review patch.  If anyone has any objections, please let us know.
> >
> > ------------------
> >
> > From: Michael Neuling <mikey@neuling.org>
> >
> > commit 60adec6226bbcf061d4c2d10944fced209d1847d upstream.
> 
> Hi Greg,
> 
> It looks like this introduces an issue for ppc32 unless we also take
> the upstream c2be05481f612525 commit.  There is an e500 kexec
> patch in between that modifies context; here is the one I've tentatively
> queued for 2.6.34 without a dependency on the e500 patch context.
> 
> http://git.kernel.org/?p=linux/kernel/git/longterm/longterm-queue-2.6.34.git;a=blob;f=next_round/powerpc-Fix-default_machine_crash_shutdown-ifdef-bot.patch

Yes, I now have updated patches from Kamalesh in the tree to resolve
this.

thanks,

greg k-h

> 
> Paul.
> 
> >
> > When we are crashing, the crashing/primary CPU IPIs the secondaries to
> > turn off IRQs, go into real mode and wait in kexec_wait.  While this
> > is happening, the primary tears down all the MMU maps.  Unfortunately
> > the primary doesn't check to make sure the secondaries have entered
> > real mode before doing this.
> >
> > On PHYP machines, the secondaries can take a long time shutting down
> > the IRQ controller as RTAS calls are need.  These RTAS calls need to
> > be serialised which resilts in the secondaries contending in
> > lock_rtas() and hence taking a long time to shut down.
> >
> > We've hit this on large POWER7 machines, where some secondaries are
> > still waiting in lock_rtas(), when the primary tears down the HPTEs.
> >
> > This patch makes sure all secondaries are in real mode before the
> > primary tears down the MMU.  It uses the new kexec_state entry in the
> > paca.  It times out if the secondaries don't reach real mode after
> > 10sec.
> >
> > Signed-off-by: Michael Neuling <mikey@neuling.org>
> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> >
> > ---
> >  arch/powerpc/kernel/crash.c |   27 +++++++++++++++++++++++++++
> >  1 file changed, 27 insertions(+)
> >
> > --- a/arch/powerpc/kernel/crash.c
> > +++ b/arch/powerpc/kernel/crash.c
> > @@ -162,6 +162,32 @@ static void crash_kexec_prepare_cpus(int
> >        /* Leave the IPI callback set */
> >  }
> >
> > +/* wait for all the CPUs to hit real mode but timeout if they don't come in */
> > +static void crash_kexec_wait_realmode(int cpu)
> > +{
> > +       unsigned int msecs;
> > +       int i;
> > +
> > +       msecs = 10000;
> > +       for (i=0; i < NR_CPUS && msecs > 0; i++) {
> > +               if (i == cpu)
> > +                       continue;
> > +
> > +               while (paca[i].kexec_state < KEXEC_STATE_REAL_MODE) {
> > +                       barrier();
> > +                       if (!cpu_possible(i)) {
> > +                               break;
> > +                       }
> > +                       if (!cpu_online(i)) {
> > +                               break;
> > +                       }
> > +                       msecs--;
> > +                       mdelay(1);
> > +               }
> > +       }
> > +       mb();
> > +}
> > +
> >  /*
> >  * This function will be called by secondary cpus or by kexec cpu
> >  * if soft-reset is activated to stop some CPUs.
> > @@ -419,6 +445,7 @@ void default_machine_crash_shutdown(stru
> >        crash_kexec_prepare_cpus(crashing_cpu);
> >        cpu_set(crashing_cpu, cpus_in_crash);
> >        crash_kexec_stop_spus();
> > +       crash_kexec_wait_realmode(crashing_cpu);
> >        if (ppc_md.kexec_cpu_down)
> >                ppc_md.kexec_cpu_down(1, 0);
> >  }
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> _______________________________________________
> stable mailing list
> stable@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/stable
