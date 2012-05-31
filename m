Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158Ab2EaNx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 09:53:27 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:42565 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757409Ab2EaNx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 09:53:26 -0400
Date: Thu, 31 May 2012 15:53:53 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] initcall sequence adjust for 3 funcs
Message-ID: <20120531135353.GD14515@aftab.osrc.amd.com>
References: <DE8DF0795D48FD4CA783C40EC82923351FEE95@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923351FEE95@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just minor nitpicks below:

On Thu, May 31, 2012 at 12:59:05PM +0000, Liu, Jinsong wrote:
> From eb5ff1bef5dd3116fa2624b594b853e9334ccbce Mon Sep 17 00:00:00 2001
> From: root <root@ljsromley.bj.intel.com>
> Date: Fri, 1 Jun 2012 03:56:25 +0800
> Subject: [PATCH 2/2] initcall sequence adjust for 3 funcs

Change subject line to

Subject: [PATCH 2/2] x86, MCE, AMD: Adjust initcall sequence for xen

> there are 3 funcs need to be _initcalled in a logic sequence:
> 1. xen_late_init_mcelog
> 2. mcheck_init_device
> 3. threshold_init_device
> 
> xen_late_init_mcelog need register xen_mce_chrdev_device before
> native mce_chrdev_device registeration if running under xen platform;
> 
> mcheck_init_device should be inited before threshold_init_device to
> initialize mce_device, otherwise a NULL pointer would occur and panic.
> 
> so we use following _initcalls
> 1. device_initcall(xen_late_init_mcelog);
> 2. device_initcall_sync(mcheck_init_device);
> 3. late_initcall(threshold_init_device);
> 
> when running under xen platform, 1,2,3 would take effect;
> when running under baremetal, 2,3 would take effect;
> 
> Reported-by: Borislav Petkov <bp@amd64.org>
> Suggested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce_amd.c |   22 +++++++++++++++++++++-
>  1 files changed, 21 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> index f4873a6..6647858 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> @@ -777,4 +777,24 @@ static __init int threshold_init_device(void)
>  
>  	return 0;
>  }
> -device_initcall(threshold_init_device);
> +/*
> + * there are 3 funcs need to be _initcalled in a logic sequence:

			which need...

> + * 1. xen_late_init_mcelog
> + * 2. mcheck_init_device
> + * 3. threshold_init_device
> + *
> + * xen_late_init_mcelog need register xen_mce_chrdev_device before

			  s/need/must/

> + * native mce_chrdev_device registeration if running under xen platform;

				registration

> + *
> + * mcheck_init_device should be inited before threshold_init_device to
> + * initialize mce_device, otherwise a NULL pointer would occur and panic.

					a NULL ptr dereference will cause panic.

> + *
> + * so we use following _initcalls
> + * 1. device_initcall(xen_late_init_mcelog);
> + * 2. device_initcall_sync(mcheck_init_device);
> + * 3. late_initcall(threshold_init_device);
> + *
> + * when running under xen platform, 1,2,3 would take effect;
> + * when running under baremetal, 2,3 would take effect;

change both lines above to say:

"when running under xen, the initcall order is 1,2,3;
on baremetal, we skip 1 and we do only 2 and 3."

The rest looks ok and it tests fine here.

Once you've changed the minor stuff above, you can slap my

Acked-and-tested-by: Borislav Petkov <borislav.petkov@amd.com>

@Tony: if you have any objections, please scream now! :-)

Thanks Jinsong!

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
