Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab2BFQx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:53:57 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:47797 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab2BFQxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:53:55 -0500
Date: Mon, 6 Feb 2012 11:50:40 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 41/91] xen/smp: Warn user why they keel over - nosmp or
 noapic and what to use instead.
Message-ID: <20120206165040.GB23240@phenom.dumpdata.com>
References: <0635750f5f06ed2ca212b91fcb5c4483@local>
 <20120205220951.204993240@pcw.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120205220951.204993240@pcw.home.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020205.4F300587.007A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 05, 2012 at 11:10:30PM +0100, Willy Tarreau wrote:
> 2.6.27-longterm review patch.  If anyone has any objections, please let us know.

Please drop this patch. The 2.6.27 did not have dom0 functionality so it
will never hit this error path.

> 
> ------------------
> 
> commit ed467e69f16e6b480e2face7bc5963834d025f91 upstream.
> 
> We have hit a couple of customer bugs where they would like to
> use those parameters to run an UP kernel - but both of those
> options turn of important sources of interrupt information so
> we end up not being able to boot. The correct way is to
> pass in 'dom0_max_vcpus=1' on the Xen hypervisor line and
> the kernel will patch itself to be a UP kernel.
> 
> Fixes bug: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=637308
> 
> Acked-by: Ian Campbell <Ian.Campbell@eu.citrix.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  arch/x86/xen/smp.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> Index: longterm-2.6.27/arch/x86/xen/smp.c
> ===================================================================
> --- longterm-2.6.27.orig/arch/x86/xen/smp.c	2012-02-05 22:34:33.783914838 +0100
> +++ longterm-2.6.27/arch/x86/xen/smp.c	2012-02-05 22:34:40.668915455 +0100
> @@ -33,6 +33,7 @@
>  #include <xen/page.h>
>  #include <xen/events.h>
>  
> +#include <xen/hvc-console.h>
>  #include "xen-ops.h"
>  #include "mmu.h"
>  
> @@ -182,6 +183,15 @@
>  {
>  	unsigned cpu;
>  
> +	if (skip_ioapic_setup) {
> +		char *m = (max_cpus == 0) ?
> +			"The nosmp parameter is incompatible with Xen; " \
> +			"use Xen dom0_max_vcpus=1 parameter" :
> +			"The noapic parameter is incompatible with Xen";
> +
> +		xen_raw_printk(m);
> +		panic(m);
> +	}
>  	xen_init_lock_cpu(0);
>  
>  	smp_store_cpu_info(0);
> 
