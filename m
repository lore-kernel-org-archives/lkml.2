Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab2HNBiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 21:38:21 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:40081 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab2HNBiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 21:38:20 -0400
Date: Mon, 13 Aug 2012 18:38:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, olaf@aepfle.de, apw@canonical.com,
        ben@decadent.org.uk
Subject: Re: [PATCH V2 02/18] Drivers: hv: Add KVP definitions for IP address
 injection
Message-ID: <20120814013815.GA29829@kroah.com>
References: <1344877584-21738-1-git-send-email-kys@microsoft.com>
 <1344877627-21779-1-git-send-email-kys@microsoft.com>
 <1344877627-21779-2-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344877627-21779-2-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 10:06:51AM -0700, K. Y. Srinivasan wrote:
> Add the necessary definitions for supporting the IP injection functionality.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: Olaf Hering <olaf@aepfle.de>
> Reviewed-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/hv/hv_util.c     |    4 +-
>  include/linux/hyperv.h   |   76 ++++++++++++++++++++++++++++++++++++++++++++-
>  tools/hv/hv_kvp_daemon.c |    2 +-
>  3 files changed, 77 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
> index d3ac6a4..a0667de 100644
> --- a/drivers/hv/hv_util.c
> +++ b/drivers/hv/hv_util.c
> @@ -263,7 +263,7 @@ static int util_probe(struct hv_device *dev,
>  		(struct hv_util_service *)dev_id->driver_data;
>  	int ret;
>  
> -	srv->recv_buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +	srv->recv_buffer = kmalloc(PAGE_SIZE * 2, GFP_KERNEL);
>  	if (!srv->recv_buffer)
>  		return -ENOMEM;
>  	if (srv->util_init) {
> @@ -274,7 +274,7 @@ static int util_probe(struct hv_device *dev,
>  		}
>  	}
>  
> -	ret = vmbus_open(dev->channel, 2 * PAGE_SIZE, 2 * PAGE_SIZE, NULL, 0,
> +	ret = vmbus_open(dev->channel, 4 * PAGE_SIZE, 4 * PAGE_SIZE, NULL, 0,
>  			srv->util_cb, dev->channel);
>  	if (ret)
>  		goto error;
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index 68ed7f7..11afc4e 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -122,12 +122,53 @@
>  #define REG_U32 4
>  #define REG_U64 8
>  
> +/*
> + * As we look at expanding the KVP functionality to include
> + * IP injection functionality, we need to maintain binary
> + * compatibility with older daemons.
> + *
> + * The KVP opcodes are defined by the host and it was unfortunate
> + * that I chose to treat the registration operation as part of the
> + * KVP operations defined by the host.
> + * Here is the level of compatibility
> + * (between the user level daemon and the kernel KVP driver) that we
> + * will implement:
> + *
> + * An older daemon will always be supported on a newer driver.
> + * A given user level daemon will require a minimal version of the
> + * kernel driver.
> + * If we cannot handle the version differences, we will fail gracefully
> + * (this can happen when we have a user level daemon that is more
> + * advanced than the KVP driver.
> + *
> + * We will use values used in this handshake for determining if we have
> + * workable user level daemon and the kernel driver. We begin by taking the
> + * registration opcode out of the KVP opcode namespace. We will however,
> + * maintain compatibility with the existing user-level daemon code.
> + */
> +
> +/*
> + * Daemon code not supporting IP injection (legacy daemon).
> + */
> +
> +#define KVP_OP_REGISTER	4

Huh?

> +/*
> + * Daemon code supporting IP injection.
> + * The KVP opcode field is used to communicate the
> + * registration information; so define a namespace that
> + * will be distinct from the host defined KVP opcode.
> + */
> +
> +#define KVP_OP_REGISTER1 100
> +
>  enum hv_kvp_exchg_op {
>  	KVP_OP_GET = 0,
>  	KVP_OP_SET,
>  	KVP_OP_DELETE,
>  	KVP_OP_ENUMERATE,
> -	KVP_OP_REGISTER,
> +	KVP_OP_GET_IP_INFO,
> +	KVP_OP_SET_IP_INFO,

So you overloaded the command and somehow think that is ok?  How is that
supposed to work?  Why not just always keep it there, but fail if it is
called as you know you have a mismatch?

Otherwise, again, you just broke older tools on a newer kernel.

Or am I missing something here?

confused,

greg k-h
