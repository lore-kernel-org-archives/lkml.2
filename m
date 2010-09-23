Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab0IWK5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 06:57:24 -0400
Received: from ozlabs.org ([203.10.76.45]:60950 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754446Ab0IWK5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 06:57:22 -0400
From: Michael Neuling <mikey@neuling.org>
To: michael@ellerman.id.au
cc: Arjen Van De Ven <arjanvandeven@gmail.com>,
        Neil Horman <nhorman@gmail.com>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org, arjan@linux.intel.com,
        nhorman@tuxdriver.com
Subject: Re: [PATCH] irqbalance, powerpc: add IRQs without settable SMP affinity to banned list
In-reply-to: <1285230159.30617.2.camel@concordia>
References: <12972.1285135457@neuling.org> <1285230159.30617.2.camel@concordia>
Comments: In-reply-to Michael Ellerman <michael@ellerman.id.au>
   message dated "Thu, 23 Sep 2010 18:22:39 +1000."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Thu, 23 Sep 2010 20:57:20 +1000
Message-ID: <1243.1285239440@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > +		if (fwrite(line, strlen(line) - 1, 1, file) == 0)
> 
> if (fputs(line, file) == EOF)

Good point thanks... new patch below

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
/proc/irq/16/smp_affinity in the above example) it fails but irqbalance
ignores currently ignores this.

This patch catches these write fails and in this case adds that IRQ
number to the banned IRQ list.  This will catch the above IPI case and
any other IRQ where the SMP affinity can't be set.

Tested on POWER6, POWER7 and x86.

Signed-off-by: Michael Neuling <mikey@neuling.org>

Index: irqbalance/irqlist.c
===================================================================
--- irqbalance.orig/irqlist.c
+++ irqbalance/irqlist.c
@@ -67,7 +67,7 @@
 	DIR *dir;
 	struct dirent *entry;
 	char *c, *c2;
-	int nr , count = 0;
+	int nr , count = 0, can_set = 1;
 	char buf[PATH_MAX];
 	sprintf(buf, "/proc/irq/%i", number);
 	dir = opendir(buf);
@@ -80,7 +80,7 @@
 			size_t size = 0;
 			FILE *file;
 			sprintf(buf, "/proc/irq/%i/smp_affinity", number);
-			file = fopen(buf, "r");
+			file = fopen(buf, "r+");
 			if (!file)
 				continue;
 			if (getline(&line, &size, file)==0) {
@@ -89,7 +89,14 @@
 				continue;
 			}
 			cpumask_parse_user(line, strlen(line), irq->mask);
-			fclose(file);
+			/*
+			 * Check that we can write the affinity, if
+			 * not take it out of the list.
+			 */
+			if (fputs(line, file) == EOF)
+				can_set = 0;
+			if (fclose(file))
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
 		
 
