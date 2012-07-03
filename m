Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab2GCQKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 12:10:24 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:53761 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab2GCQKX convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Tue, 3 Jul 2012 12:10:23 -0400
Message-Id: <4FF335C6020000780008D613@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 03 Jul 2012 17:11:18 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "xen-devel" <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 4/4] xen/hvc: Fix up checks when the
 info is allocated.
References: <1341330038-21686-1-git-send-email-konrad.wilk@oracle.com>
 <1341330038-21686-5-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1341330038-21686-5-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 03.07.12 at 17:40, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> Coverity would complain about this - even thought it looks OK.
> 
> CID 401957
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/tty/hvc/hvc_xen.c |   15 ++++++---------
>  1 files changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
> index 944eaeb..fbf41be 100644
> --- a/drivers/tty/hvc/hvc_xen.c
> +++ b/drivers/tty/hvc/hvc_xen.c
> @@ -209,10 +209,8 @@ static int xen_hvm_console_init(void)
>  		info = kzalloc(sizeof(struct xencons_info), GFP_KERNEL | __GFP_ZERO);
>  		if (!info)
>  			return -ENOMEM;
> -	}
> -
> -	/* already configured */
> -	if (info->intf != NULL)
> +	} else if (info->intf != NULL) {
> +		/* already configured */
>  		return 0;

Is this patch perhaps stale? There appears to be a missing } here,
without which I can't see how this would have built, ...

>  	/*
>  	 * If the toolstack (or the hypervisor) hasn't set these values, the
> @@ -220,6 +218,7 @@ static int xen_hvm_console_init(void)
>  	 * theoretically correct values, in practice they never are and they
>  	 * mean that a legacy toolstack hasn't initialized the pv console correctly.
>  	 */
> +	 */

... and this one likely wouldn't build either.

Jan

>  	r = hvm_get_parameter(HVM_PARAM_CONSOLE_EVTCHN, &v);
>  	if (r < 0 || v == 0)
>  		goto err;
> @@ -259,12 +258,10 @@ static int xen_pv_console_init(void)
>  		info = kzalloc(sizeof(struct xencons_info), GFP_KERNEL | __GFP_ZERO);
>  		if (!info)
>  			return -ENOMEM;
> -	}
> -
> -	/* already configured */
> -	if (info->intf != NULL)
> +	} else if (info->intf != NULL) {
> +		/* already configured */
>  		return 0;
> -
> +	}
>  	info->evtchn = xen_start_info->console.domU.evtchn;
>  	info->intf = mfn_to_virt(xen_start_info->console.domU.mfn);
>  	info->vtermno = HVC_COOKIE;


