Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab2ADL6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 06:58:07 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:17108 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab2ADL6E convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:7:1>);
	Wed, 4 Jan 2012 06:58:04 -0500
Message-Id: <4F044D10020000780006A5B4@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 04 Jan 2012 11:58:56 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ian Campbell" <ian.campbell@citrix.com>
Cc: "Haogang Chen" <haogangchen@gmail.com>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        <virtualization@lists.linux-foundation.org>,
        <xen-devel@lists.xensource.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/2] xen/xenbus: don't reimplement
 kvasprintf via a fixed size buffer
References: <1325677158.25206.244.camel@zakaz.uk.xensource.com>
 <1325677192-10459-2-git-send-email-ian.campbell@citrix.com>
In-Reply-To: <1325677192-10459-2-git-send-email-ian.campbell@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 04.01.12 at 12:39, Ian Campbell <ian.campbell@citrix.com> wrote:
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>

Acked-by: Jan Beulich <jbeulich@suse.com>

> Cc: Haogang Chen <haogangchen@gmail.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: xen-devel@lists.xensource.com 
> Cc: virtualization@lists.linux-foundation.org 
> Cc: linux-kernel@vger.kernel.org 
> ---
>  drivers/xen/xenbus/xenbus_xs.c |   17 +++++++----------
>  1 files changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
> index 6f0121e..226d1ac 100644
> --- a/drivers/xen/xenbus/xenbus_xs.c
> +++ b/drivers/xen/xenbus/xenbus_xs.c
> @@ -532,21 +532,18 @@ int xenbus_printf(struct xenbus_transaction t,
>  {
>  	va_list ap;
>  	int ret;
> -#define PRINTF_BUFFER_SIZE 4096
> -	char *printf_buffer;
> -
> -	printf_buffer = kmalloc(PRINTF_BUFFER_SIZE, GFP_NOIO | __GFP_HIGH);
> -	if (printf_buffer == NULL)
> -		return -ENOMEM;
> +	char *buf;
>  
>  	va_start(ap, fmt);
> -	ret = vsnprintf(printf_buffer, PRINTF_BUFFER_SIZE, fmt, ap);
> +	buf = kvasprintf(GFP_NOIO | __GFP_HIGH, fmt, ap);
>  	va_end(ap);
>  
> -	BUG_ON(ret > PRINTF_BUFFER_SIZE-1);
> -	ret = xenbus_write(t, dir, node, printf_buffer);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	ret = xenbus_write(t, dir, node, buf);
>  
> -	kfree(printf_buffer);
> +	kfree(buf);
>  
>  	return ret;
>  }
> -- 
> 1.7.2.5
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com 
> http://lists.xensource.com/xen-devel 



