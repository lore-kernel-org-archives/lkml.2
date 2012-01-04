Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab2ADJY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 04:24:58 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:32464 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab2ADJY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 04:24:56 -0500
X-IronPort-AV: E=Sophos;i="4.71,455,1320624000"; 
   d="scan'208";a="9805231"
Subject: Re: [PATCH] XEN: xenbus: integer overflow in process_msg()
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Haogang Chen <haogangchen@gmail.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 4 Jan 2012 09:24:54 +0000
In-Reply-To: <1325619731-13936-1-git-send-email-haogangchen@gmail.com>
References: <1325619731-13936-1-git-send-email-haogangchen@gmail.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1325669095.25206.176.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-03 at 19:42 +0000, Haogang Chen wrote:
> There is a potential integer overflow in process_msg() that could result
> in cross-domain attack.
> 
> 	body = kmalloc(msg->hdr.len + 1, GFP_NOIO | __GFP_HIGH);
> 
> When a malicious guest passes 0xffffffff in msg->hdr.len, the subsequent
> call to xb_read() would write to a zero-length buffer.

The other end of this connection is always the xenstore backend daemon
so there is no guest (malicious or otherwise) which can do this. The
xenstore daemon is a trusted component in the system.

However this seem like a reasonable robustness improvement so we should
have it.

> This causes
> kernel oops in the receiving guest and hangs its xenbus kernel thread.
> The patch returns -EINVAL in that case.
> 
> Signed-off-by: Haogang Chen <haogangchen@gmail.com>

Acked-by: Ian Campbell <ian.campbell@citrix.com>

> ---
>  drivers/xen/xenbus/xenbus_xs.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
> index ede860f..e32aefb 100644
> --- a/drivers/xen/xenbus/xenbus_xs.c
> +++ b/drivers/xen/xenbus/xenbus_xs.c
> @@ -801,6 +801,12 @@ static int process_msg(void)
>  		goto out;
>  	}
>  
> +	if (msg->hdr.len == UINT_MAX) {
> +		kfree(msg);
> +		err = -EINVAL;
> +		goto out;
> +	}
> +
>  	body = kmalloc(msg->hdr.len + 1, GFP_NOIO | __GFP_HIGH);
>  	if (body == NULL) {
>  		kfree(msg);


