Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab2EYJOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 05:14:06 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:43601 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab2EYJOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 05:14:04 -0400
X-IronPort-AV: E=Sophos;i="4.75,655,1330905600"; 
   d="scan'208";a="12665535"
Date: Fri, 25 May 2012 10:13:47 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/4] xen/hvc: Check HVM_PARAM_CONSOLE_[EVTCHN|PFN]
 for correctness.
In-Reply-To: <20120524182403.GL24934@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.00.1205251013250.26786@kaball-desktop>
References: <1337795222-29946-1-git-send-email-konrad.wilk@oracle.com> <1337795222-29946-4-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.00.1205241148080.26786@kaball-desktop> <20120524182403.GL24934@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2012, Konrad Rzeszutek Wilk wrote:
> > I think that we should add a comment stating that even though mfn = 0
> > and evtchn = 0 are theoretically correct values, in practice they never
> > are and they mean that a legacy toolstack hasn't initialized the pv
> > console correctly.
> 
> Like this?

Yep

> >From 5842f5768599094758931b74190cdf93641a8e35 Mon Sep 17 00:00:00 2001
> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Date: Wed, 23 May 2012 12:56:59 -0400
> Subject: [PATCH] xen/hvc: Check HVM_PARAM_CONSOLE_[EVTCHN|PFN] for
>  correctness.
> 
> We need to make sure that those parameters are setup to be correct.
> As such the value of 0 is deemed invalid and we find that we
> bail out. The hypervisor sets by default all of them to be zero
> and when the hypercall is done does a simple:
> 
>  a.value = d->arch.hvm_domain.params[a.index];
> 
> Which means that if the Xen toolstack forgot to setup the proper
> HVM_PARAM_CONSOLE_EVTCHN (or the PFN one), we would get the
> default value of 0 and use that.
> 
> CC: stable@kernel.org
> Fixes-Oracle-Bug: 14091238
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

> ---
>  drivers/tty/hvc/hvc_xen.c |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
> index 3277f0e..944eaeb 100644
> --- a/drivers/tty/hvc/hvc_xen.c
> +++ b/drivers/tty/hvc/hvc_xen.c
> @@ -214,14 +214,19 @@ static int xen_hvm_console_init(void)
>  	/* already configured */
>  	if (info->intf != NULL)
>  		return 0;
> -
> +	/*
> +	 * If the toolstack (or the hypervisor) hasn't set these values, the
> +	 * default value is 0. Even though mfn = 0 and evtchn = 0 are
> +	 * theoretically correct values, in practice they never are and they
> +	 * mean that a legacy toolstack hasn't initialized the pv console correctly.
> +	 */
>  	r = hvm_get_parameter(HVM_PARAM_CONSOLE_EVTCHN, &v);
> -	if (r < 0)
> +	if (r < 0 || v == 0)
>  		goto err;
>  	info->evtchn = v;
>  	v = 0;
>  	r = hvm_get_parameter(HVM_PARAM_CONSOLE_PFN, &v);
> -	if (r < 0)
> +	if (r < 0 || v == 0)
>  		goto err;
>  	mfn = v;
>  	info->intf = ioremap(mfn << PAGE_SHIFT, PAGE_SIZE);
> -- 
> 1.7.7.5
> 
