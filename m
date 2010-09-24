Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab0IXG4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 02:56:37 -0400
Received: from ozlabs.org ([203.10.76.45]:44259 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab0IXG4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 02:56:36 -0400
From: Michael Neuling <mikey@neuling.org>
To: michael@ellerman.id.au
cc: Neil Horman <nhorman@tuxdriver.com>, Neil Horman <nhorman@gmail.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Arjen Van De Ven <arjanvandeven@gmail.com>, arjan@linux.intel.com
Subject: Re: [PATCH] irqbalance, powerpc: add IRQs without settable SMP affinity to banned list
In-reply-to: <1285304622.7637.55.camel@concordia>
References: <12972.1285135457@neuling.org> <1285230159.30617.2.camel@concordia> <1243.1285239440@neuling.org> <20100923131302.GA6560@shamino.rdu.redhat.com> <1285304622.7637.55.camel@concordia>
Comments: In-reply-to Michael Ellerman <michael@ellerman.id.au>
   message dated "Fri, 24 Sep 2010 15:03:42 +1000."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Fri, 24 Sep 2010 16:56:34 +1000
Message-ID: <25264.1285311394@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > >  			size_t size =3D 0;
> > >  			FILE *file;
> > >  			sprintf(buf, "/proc/irq/%i/smp_affinity", number);
> > > -			file =3D fopen(buf, "r");
> > > +			file =3D fopen(buf, "r+");
> > >  			if (!file)
> > >  				continue;
> > >  			if (getline(&line, &size, file)=3D=3D0) {
> > > @@ -89,7 +89,14 @@
> > >  				continue;
> > >  			}
> > >  			cpumask_parse_user(line, strlen(line), irq->mask);
> > > -			fclose(file);
> > > +			/*
> > > +			 * Check that we can write the affinity, if
> > > +			 * not take it out of the list.
> > > +			 */
> > > +			if (fputs(line, file) =3D=3D EOF)
> > > +				can_set =3D 0;
> 
> > This is maybe a nit, but writing to the affinity file can fail for a few
> > different reasons, some of them permanent, some transient.  For instance,=
>  if
> > we're in a memory constrained condition temporarily irq_affinity_proc_wri=
> te
> > might return -ENOMEM. =20
> 
> Yeah true, usually followed shortly by your kernel going so far into
> swap you never get it back, or OOMing, but I guess it's possible.
> 
> > Might it be better to modify this code so that, instead
> > of using fputs to merge the various errors into an EOF, we use some other=
>  write
> > method that lets us better determine the error and selectively ban the in=
> terrupt
> > only for those errors which we consider permanent?
> 
> Yep. It seems fputs() gives you know way to get the actual error from
> write(), so it looks we'll need to switch to open/write, but that's
> probably not so terrible.

fclose inherits the error from fputs and it sets errno correctly.  Below
uses this to catch only EIO errors and mark them for the banned list.

Mikey

irqbalance, powerpc: add IRQs without settable SMP affinity to banned list

On pseries powerpc, IPIs are registered with an IRQ number so
/proc/interrupts looks like this on a 2 core/2 thread machine:

           CPU0       CPU1       CPU2       CPU3
 16:    3164282    3290514    1138794     983121   XICS             Level        IPI
 18:    2605674          0     304994          0   XICS             Level        lan0
 30:     400057          0     169209          0   XICS             Level        ibmvscsi
LOC:     133734      77250     106425      91951   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
CNT:          0          0          0          0   Performance monitoring interrupts
MCE:          0          0          0          0   Machine check exceptions

Unfortunately this means irqbalance attempts to set the affinity of IPIs
which is not possible.  So in the above case, when irqbalance is in
performance mode due to heavy IPI, lan0 and ibmvscsi activity, it
sometimes attempts to put the IPIs on one core (CPU0&1) and lan0 and
ibmvscsi on the other core (CPU2&3).  This is suboptimal as we want lan0
and ibmvscsi to be on separate cores and IPIs to be ignored.

When irqblance attempts writes to the IPI smp_affinity (ie.
/proc/irq/16/smp_affinity in the above example) it fails with an EIO but
irqbalance currently ignores this.

This patch catches these write fails and in this case adds that IRQ
number to the banned IRQ list.  This will catch the above IPI case and
any other IRQ where the SMP affinity can't be set.

Tested on POWER6, POWER7 and x86.

Signed-off-by: Michael Neuling <mikey@neuling.org>
 
Index: irqbalance/irqlist.c
===================================================================
--- irqbalance.orig/irqlist.c
+++ irqbalance/irqlist.c
@@ -28,6 +28,7 @@
 #include <unistd.h>
 #include <sys/types.h>
 #include <dirent.h>
+#include <errno.h>
 
 #include "types.h"
 #include "irqbalance.h"
@@ -67,7 +68,7 @@
 	DIR *dir;
 	struct dirent *entry;
 	char *c, *c2;
-	int nr , count = 0;
+	int nr , count = 0, can_set = 1;
 	char buf[PATH_MAX];
 	sprintf(buf, "/proc/irq/%i", number);
 	dir = opendir(buf);
@@ -80,7 +81,7 @@
 			size_t size = 0;
 			FILE *file;
 			sprintf(buf, "/proc/irq/%i/smp_affinity", number);
-			file = fopen(buf, "r");
+			file = fopen(buf, "r+");
 			if (!file)
 				continue;
 			if (getline(&line, &size, file)==0) {
@@ -89,7 +90,13 @@
 				continue;
 			}
 			cpumask_parse_user(line, strlen(line), irq->mask);
-			fclose(file);
+			/*
+			 * Check that we can write the affinity, if
+			 * not take it out of the list.
+			 */
+			fputs(line, file);
+			if (fclose(file) && errno == EIO)
+				can_set = 0;
 			free(line);
 		} else if (strcmp(entry->d_name,"allowed_affinity")==0) {
 			char *line = NULL;
@@ -122,7 +129,7 @@
 			count++;
 
 	/* if there is no choice in the allowed mask, don't bother to balance */
-	if (count<2)
+	if ((count<2) || (can_set == 0))
 		 irq->balance_level = BALANCE_NONE;
 		
 
