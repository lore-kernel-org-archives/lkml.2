Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab0EZGvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 02:51:43 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:48099 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab0EZGvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 02:51:42 -0400
Date: Wed, 26 May 2010 12:21:29 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Millton Miller <miltonm@bga.com>
Cc: Michael Neuling <mikey@neuling.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, shaggy@linux.vnet.ibm.com,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Gibson <dwg@au1.ibm.com>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [Patch 1/4] Allow arch-specific cleanup before breakpoint
	unregistration
Message-ID: <20100526065129.GA3746@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20100525083055.342788418@linux.vnet.ibm.com> <20100525091356.GB29003@in.ibm.com> <1274787559_8162@mail4.comsite.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274787559_8162@mail4.comsite.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 06:39:19AM -0500, Millton Miller wrote:
> On Tue, 25 May 2010 at 14:43:56 +0530, K.Prasad wrote:
> > Certain architectures (such as PowerPC Book III S) have a need to cleanup
> > data-structures before the breakpoint is unregistered. This patch introduces
> > an arch-specific hook in release_bp_slot() along with a weak definition in
> > the form of a stub funciton.
> > 
> > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> > ---
> >  kernel/hw_breakpoint.c |   12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> 
> 
> My understanding is weak function definitions must appear in a different C
> file than their call sites to work on some toolchains.
> 

Atleast, there are quite a few precedents inside the Linux kernel for
__weak functions being invoked from the file in which they are defined
(arch_hwblk_init, arch_enable_nonboot_cpus_begin and hw_perf_disable to
name a few).
Moreover the online GCC docs haven't any such constraints mentioned.

> Andrew, can you confirm the above statement?
> 
> > Index: linux-2.6.ppc64_test/kernel/hw_breakpoint.c
> > ===================================================================
> > --- linux-2.6.ppc64_test.orig/kernel/hw_breakpoint.c
> > +++ linux-2.6.ppc64_test/kernel/hw_breakpoint.c
> > @@ -242,6 +242,17 @@  toggle_bp_slot(struct perf_event *bp, bo
> >  }
> >  
> >  /*
> > + * Function to perform processor-specific cleanup during unregistration
> > + */
> > +__weak void arch_unregister_hw_breakpoint(struct perf_event *bp)
> > +{
> > +	/*
> > +	 * A weak stub function here for those archs that don't define
> > +	 * it inside arch/.../kernel/hw_breakpoint.c
> > +	 */
> > +}
> > +
> > +/*
> >   * Contraints to check before allowing this new breakpoint counter:
> >   *
> >   *  == Non-pinned counter == (Considered as pinned for now)
> > @@ -339,6 +350,7 @@  void release_bp_slot(struct perf_event *
> >  {
> >  	mutex_lock(&nr_bp_mutex);
> >  
> > +	arch_unregister_hw_breakpoint(bp);
> >  	__release_bp_slot(bp);
> >  
> >  	mutex_unlock(&nr_bp_mutex);
> > 
> 
> 
> Since the weak version is empty, should it just be delcared (in
> a header, put the comment there) and not defined?
>

The initial thinking behind defining it in the .c file was, for one,
the function need not be moved (from .h to .c) when other architectures
have a need to populate them. Secondly, given that powerpc (which has a
'strong' definition for arch_unregister_hw_breakpoint()) includes the
header file (in which this can be moved to) I wasn't sure about
possible conflicts.

> milton
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev

Thanks,
K.Prasad

