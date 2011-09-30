Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150Ab1I3ILG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 04:11:06 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:26459 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757566Ab1I3IKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 04:10:53 -0400
X-IronPort-AV: E=Sophos;i="4.68,465,1312156800"; 
   d="scan'208";a="8143203"
Subject: Re: [Xen-devel] [PATCH 8/9] xen/enlighten: Fix compile warnings.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Dan Carpenter <error27@gmail.com>
Date: Fri, 30 Sep 2011 09:10:51 +0100
In-Reply-To: <1317325971-21603-9-git-send-email-konrad.wilk@oracle.com>
References: <1317325971-21603-1-git-send-email-konrad.wilk@oracle.com>
	 <1317325971-21603-9-git-send-email-konrad.wilk@oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 8bit
Message-ID: <1317370252.26672.224.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-29 at 20:52 +0100, Konrad Rzeszutek Wilk wrote:
> linux/arch/x86/xen/enlighten.c: In function ‘xen_start_kernel’:
> linux/arch/x86/xen/enlighten.c:226: warning: ‘cx’ may be used uninitialized in this function
> linux/arch/x86/xen/enlighten.c:240: note: ‘cx’ was declared here

Before 61f4237d5b005767a76f4f3694e68e6f78f392d9 we used to initialise cx
to zero before calling xen_cpuid.

947ccf9c3c30307b774af3666ee74fcd9f47f646 didn't put it back for some
reason.

Regardless I'm not sure how cx can be unused while {a,b,d}x apparently
are not. All four are passed to xen_cpuid(&ax, &bx, &cx, &dx) and even
if gcc were being clever and looking into xen_cpuid all four are in the
output constraints of the real cpuid asm call.

Oh, I see, ax and cx are also in the input side of the asm and ax is
initialised but cx is not and that is the use not the one later in
xen_init_cpuid_mask.

I think that even if cpuid leaf ax=1 happens not to use the subleaf
index in cx we'd be better to initialise cx=0 than use uninitialized_var
here.

Ian.

> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/enlighten.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 2d69617..9473861 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -237,7 +237,7 @@ static void xen_cpuid(unsigned int *ax, unsigned int *bx,
>  
>  static void __init xen_init_cpuid_mask(void)
>  {
> -	unsigned int ax, bx, cx, dx;
> +	unsigned int ax, bx, uninitialized_var(cx), dx;
>  	unsigned int xsave_mask;
>  
>  	cpuid_leaf1_edx_mask =


