Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab2LQVM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 16:12:58 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:43084 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab2LQVM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 16:12:57 -0500
Date: Mon, 17 Dec 2012 16:12:40 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Sander Eikelenboom <linux@eikelenboom.it>, fenghua.yu@intel.com
Cc: xen-devel <xen-devel@lists.xen.org>, linux-kernel@vger.kernel.org,
        hpa@linux.intel.com
Subject: Re: 3.8.0-rc0 on xen-unstable: RCU Stall during boot as dom0 kernel
 after IOAPIC
Message-ID: <20121217211240.GA13412@konrad-lan.dumpdata.com>
References: <1995613404.20121214165557@eikelenboom.it>
 <20121216173824.GA4518@phenom.dumpdata.com>
 <1782021524.20121217213217@eikelenboom.it>
 <20121217204634.GA13181@konrad-lan.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121217204634.GA13181@konrad-lan.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 03:46:34PM -0500, Konrad Rzeszutek Wilk wrote:
> On Mon, Dec 17, 2012 at 09:32:17PM +0100, Sander Eikelenboom wrote:
> > 
> > Sunday, December 16, 2012, 6:38:24 PM, you wrote:
> > 
> > > On Fri, Dec 14, 2012 at 04:55:57PM +0100, Sander Eikelenboom wrote:
> > >> Hi Konrad,
> > >> 
> > >> I just tried to boot a 3.8.0-rc0 kernel (last commit: 7313264b899bbf3988841296265a6e0e8a7b6521) as dom0 on my machine with current xen-unstable.
> > 
> > > Yeah, saw it over the Dec 11->Dec 12 merges and was out on
> > > vacation during that time (just got back).
> > 
> > > Did you by any chance try to do a git bisect to narrow down
> > > which merge it was?
> > 
> > Hi Konrad,
> 
> Hey Sander,
> 
> Thank you for doing the bisection.
> 
> Fenghua - any ideas what might be amiss in the Xen subsystem?
> I hadn't looked at the patchset of the CPU0 offlining/onlining
> so I am not completly up to speed on the particulars of the patches.

> > 30106c174311b8cfaaa3186c7f6f9c36c62d17da is the first bad commit
> > commit 30106c174311b8cfaaa3186c7f6f9c36c62d17da
> > Author: Fenghua Yu <fenghua.yu@intel.com>
> > Date:   Tue Nov 13 11:32:41 2012 -0800
> > 
> >     x86, hotplug: Support functions for CPU0 online/offline
> > 
> >     Add smp_store_boot_cpu_info() to store cpu info for BSP during boot time.
> > 
> >     Now smp_store_cpu_info() stores cpu info for bringing up BSP or AP after
> >     it's offline.
> > 
> >     Continue to online CPU0 in native_cpu_up().
> > 
> >     Continue to offline CPU0 in native_cpu_disable().
> > 
> >     Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> >     Link: http://lkml.kernel.org/r/1352835171-3958-5-git-send-email-fenghua.yu@intel.com
> >     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> > 

This patch:


diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 353c50f..4f7d259 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -254,7 +254,7 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 	}
 	xen_init_lock_cpu(0);
 
-	smp_store_cpu_info(0);
+	smp_store_boot_cpu_info();
 	cpu_data(0).x86_max_cores = 1;
 
 	for_each_possible_cpu(i) {

Would do the corresponding change in the Xen subsystem that the above
mentioned commit did. Perhaps that is all that is needed? I am going to
be able to test this and look in more details tomorrow.

