Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab1ACUjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 15:39:20 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:20168 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753358Ab1ACUjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 15:39:17 -0500
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275bhz32i637h668h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LEGS1B-01-1J3-02
X-M-MSG: 
Date: Mon, 3 Jan 2011 21:39:09 +0100
From: Robert Richter <robert.richter@amd.com>
To: "graalfs@linux.vnet.ibm.com" <graalfs@linux.vnet.ibm.com>
CC: "mingo@elte.hu" <mingo@elte.hu>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Maran Pakkirisamy <maranp@linux.vnet.ibm.com>
Subject: Re: [patch 4/4] Handle memory unmap while hardware sampling is
 running
Message-ID: <20110103203909.GT4739@erda.amd.com>
References: <20101220130541.446049933@linux.vnet.ibm.com>
 <20101220130629.974963910@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20101220130629.974963910@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.12.10 08:05:45, graalfs@linux.vnet.ibm.com wrote:
> From: graalfs@linux.vnet.ibm.com
> 
> During memory unmap hardware sampling is deactivated.
> After all samples have been collected hardware sampling is reactivated again.

Do you mean you switch off the profiler for each buffer sync? This
happens per default every 100ms. Why is this needed? Which memory is
unmapped?

This hooks in the sync_buffer() are ugly. We must try to find a better
solution here.

There is oprofile_put_buff() that allows to write directly to the the
event buffer which is used in powerpc/cell.

-Robert

>  
> Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
> Signed-off-by: Maran Pakkirisamy <maranp@linux.vnet.ibm.com>
> Signed-off-by: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
> ---
>  arch/s390/oprofile/hwsampler_files.c |    2 +-
>  drivers/oprofile/buffer_sync.c       |   13 +++++++++++++
>  2 files changed, 14 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/oprofile/buffer_sync.c
> ===================================================================
> --- linux-2.6.orig/drivers/oprofile/buffer_sync.c
> +++ linux-2.6/drivers/oprofile/buffer_sync.c
> @@ -32,6 +32,11 @@
>  #include <linux/sched.h>
>  #include <linux/gfp.h>
>  
> +#ifdef CONFIG_OPROFILE_HWSAMPLING_MODE
> +#include <asm/hwsampler.h>
> +extern unsigned long oprofile_hwsampler;
> +#endif
> +
>  #include "oprofile_stats.h"
>  #include "event_buffer.h"
>  #include "cpu_buffer.h"
> @@ -513,6 +518,10 @@ void sync_buffer(int cpu)
>  
>  	mutex_lock(&buffer_mutex);
>  
> +#ifdef CONFIG_OPROFILE_HWSAMPLING_MODE
> +	if (oprofile_hwsampler)
> +		hwsampler_deactivate(cpu);
> +#endif
>  	add_cpu_switch(cpu);
>  
>  	op_cpu_buffer_reset(cpu);
> @@ -569,6 +578,10 @@ void sync_buffer(int cpu)
>  
>  	mark_done(cpu);
>  
> +#ifdef CONFIG_OPROFILE_HWSAMPLING_MODE
> +	if (oprofile_hwsampler)
> +		hwsampler_activate(cpu);
> +#endif
>  	mutex_unlock(&buffer_mutex);
>  }
>  
> Index: linux-2.6/arch/s390/oprofile/hwsampler_files.c
> ===================================================================
> --- linux-2.6.orig/arch/s390/oprofile/hwsampler_files.c
> +++ linux-2.6/arch/s390/oprofile/hwsampler_files.c
> @@ -22,7 +22,7 @@ unsigned long oprofile_max_interval;
>  static unsigned long oprofile_sdbt_blocks = DEFAULT_SDBT_BLOCKS;
>  static unsigned long oprofile_sdb_blocks = DEFAULT_SDB_BLOCKS;
>  
> -static unsigned long oprofile_hwsampler;
> +unsigned long oprofile_hwsampler;
>  
>  static int oprofile_hwsampler_start(void)
>  {
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

