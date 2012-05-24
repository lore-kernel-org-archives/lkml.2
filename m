Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab2EXKvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 06:51:36 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:41390 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985Ab2EXKvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 06:51:31 -0400
X-IronPort-AV: E=Sophos;i="4.75,649,1330905600"; 
   d="scan'208";a="12646484"
Date: Thu, 24 May 2012 11:51:14 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 3/4] xen/hvc: Check HVM_PARAM_CONSOLE_[EVTCHN|PFN] for
 correctness.
In-Reply-To: <1337795222-29946-4-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.00.1205241148080.26786@kaball-desktop>
References: <1337795222-29946-1-git-send-email-konrad.wilk@oracle.com> <1337795222-29946-4-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012, Konrad Rzeszutek Wilk wrote:
> We need to make sure that those parameters are setup to be correct.
> As such the value of 0 is deemed invalid and we find that we
> bail out. The hypervisor sets by default all of them to be zero
> and when the hypercall is done does a simple:
> 
>  a.value = d->arch.hvm_domain.params[a.index];
> 
> Which means that if the Xen toolstack forgot to setup the proper
> HVM_PARAM_CONSOLE_EVTCHN, we would get the default value of 0
> and use that.

I see, so the default value for v needs to be 0, because it's what the
hypervisor would return anyway if the parameter hasn't been set.


> CC: stable@kernel.org
> Fixes-Oracle-Bug: 14091238
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/tty/hvc/hvc_xen.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
> index 3277f0e..5fb1cb9 100644
> --- a/drivers/tty/hvc/hvc_xen.c
> +++ b/drivers/tty/hvc/hvc_xen.c
> @@ -216,12 +216,12 @@ static int xen_hvm_console_init(void)
>  		return 0;
>  
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

I think that we should add a comment stating that even though mfn = 0
and evtchn = 0 are theoretically correct values, in practice they never
are and they mean that a legacy toolstack hasn't initialized the pv
console correctly.
