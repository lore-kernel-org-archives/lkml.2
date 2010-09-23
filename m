Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab0IWNN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 09:13:26 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38839 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab0IWNNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 09:13:25 -0400
Date: Thu, 23 Sep 2010 09:13:02 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Michael Neuling <mikey@neuling.org>
Cc: michael@ellerman.id.au, Neil Horman <nhorman@gmail.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Arjen Van De Ven <arjanvandeven@gmail.com>, arjan@linux.intel.com
Subject: Re: [PATCH] irqbalance, powerpc: add IRQs without settable SMP
 affinity to banned list
Message-ID: <20100923131302.GA6560@shamino.rdu.redhat.com>
References: <12972.1285135457@neuling.org>
 <1285230159.30617.2.camel@concordia>
 <1243.1285239440@neuling.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243.1285239440@neuling.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 08:57:20PM +1000, Michael Neuling wrote:
> 
> > > +		if (fwrite(line, strlen(line) - 1, 1, file) == 0)
> > 
> > if (fputs(line, file) == EOF)
> 
> Good point thanks... new patch below
> 
> Mikey
> 
> irqbalance, powerpc: add IRQs without settable SMP affinity to banned list
> 
> On pseries powerpc, IPIs are registered with an IRQ number so
> /proc/interrupts looks like this on a 2 core/2 thread machine:
> 
>            CPU0       CPU1       CPU2       CPU3
>  16:    3164282    3290514    1138794     983121   XICS             Level        IPI
>  18:    2605674          0     304994          0   XICS             Level        lan0
>  30:     400057          0     169209          0   XICS             Level        ibmvscsi
> LOC:     133734      77250     106425      91951   Local timer interrupts
> SPU:          0          0          0          0   Spurious interrupts
> CNT:          0          0          0          0   Performance monitoring interrupts
> MCE:          0          0          0          0   Machine check exceptions
> 
> Unfortunately this means irqbalance attempts to set the affinity of IPIs
> which is not possible.  So in the above case, when irqbalance is in
> performance mode due to heavy IPI, lan0 and ibmvscsi activity, it
> sometimes attempts to put the IPIs on one core (CPU0&1) and lan0 and
> ibmvscsi on the other core (CPU2&3).  This is suboptimal as we want lan0
> and ibmvscsi to be on separate cores and IPIs to be ignored.
> 
> When irqblance attempts writes to the IPI smp_affinity (ie.
> /proc/irq/16/smp_affinity in the above example) it fails but irqbalance
> ignores currently ignores this.
> 
> This patch catches these write fails and in this case adds that IRQ
> number to the banned IRQ list.  This will catch the above IPI case and
> any other IRQ where the SMP affinity can't be set.
> 
> Tested on POWER6, POWER7 and x86.
> 
> Signed-off-by: Michael Neuling <mikey@neuling.org>
> 
> Index: irqbalance/irqlist.c
> ===================================================================
> --- irqbalance.orig/irqlist.c
> +++ irqbalance/irqlist.c
> @@ -67,7 +67,7 @@
>  	DIR *dir;
>  	struct dirent *entry;
>  	char *c, *c2;
> -	int nr , count = 0;
> +	int nr , count = 0, can_set = 1;
>  	char buf[PATH_MAX];
>  	sprintf(buf, "/proc/irq/%i", number);
>  	dir = opendir(buf);
> @@ -80,7 +80,7 @@
>  			size_t size = 0;
>  			FILE *file;
>  			sprintf(buf, "/proc/irq/%i/smp_affinity", number);
> -			file = fopen(buf, "r");
> +			file = fopen(buf, "r+");
>  			if (!file)
>  				continue;
>  			if (getline(&line, &size, file)==0) {
> @@ -89,7 +89,14 @@
>  				continue;
>  			}
>  			cpumask_parse_user(line, strlen(line), irq->mask);
> -			fclose(file);
> +			/*
> +			 * Check that we can write the affinity, if
> +			 * not take it out of the list.
> +			 */
> +			if (fputs(line, file) == EOF)
> +				can_set = 0;
This is maybe a nit, but writing to the affinity file can fail for a few
different reasons, some of them permanent, some transient.  For instance, if
we're in a memory constrained condition temporarily irq_affinity_proc_write
might return -ENOMEM.  Might it be better to modify this code so that, instead
of using fputs to merge the various errors into an EOF, we use some other write
method that lets us better determine the error and selectively ban the interrupt
only for those errors which we consider permanent?

Otherwise this looks fine to me.

Thanks
Neil

