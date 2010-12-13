Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab0LMWH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 17:07:28 -0500
Received: from novprvoes0310.provo.novell.com ([137.65.248.74]:46171 "EHLO
	novprvoes0310.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755994Ab0LMWH1 convert rfc822-to-8bit
	(ORCPT <rfc822;groupwise-ksrinivasan@novell.com:7:1>);
	Mon, 13 Dec 2010 17:07:27 -0500
Message-Id: <4D0636AC0200003000091D33@novprvoes0310.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Mon, 13 Dec 2010 15:07:24 -0700
From: "Ky Srinivasan" <ksrinivasan@novell.com>
To: <devel@linuxdriverproject.org>, <virtualization@lists.osdl.org>,
        <hjanssen@microsoft.com>, <gregkh@suse.de>,
        <linux-kernel@vger.kernel.org>
Cc: "Jesper Juhl" <jj@chaosbits.net>, "Evgeniy Polyakov" <zbr@ioremap.net>,
        "Haiyang Zhang" <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/1] hv: Use only one receive buffer per channel
 and kmalloc on initialize
References: <1292272498-29483-1-git-send-email-hjanssen@microsoft.com>
In-Reply-To: <1292272498-29483-1-git-send-email-hjanssen@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>>> On 12/13/2010 at  3:34 PM, in message
<1292272498-29483-1-git-send-email-hjanssen@microsoft.com>, Hank Janssen
<hjanssen@microsoft.com> wrote: 
> Correct issue with not checking kmalloc return value.
> This fix now only uses one receive buffer for all hv_utils 
> channels, and will do only one kmalloc on init and will return
> with a -ENOMEM if kmalloc fails on initialize.
> 
> Thanks to Evgeniy Polyakov <zbr@ioremap.net> for pointing this out.
> And thanks to Jesper Juhl <jj@chaosbits.net> and Ky Srinivasan 
> <ksrinivasan@novell.com> for suggesting a better implementation of
> my original patch.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> Cc: Evgeniy Polyakov <zbr@ioremap.net>
> Cc: Jesper Juhl <jj@chaosbits.net>
> Cc: Ky Srinivasan <ksrinivasan@novell.com>
> 
> ---
>  drivers/staging/hv/hv_utils.c |   84 +++++++++++++++++++++-------------------
>  1 files changed, 44 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/staging/hv/hv_utils.c b/drivers/staging/hv/hv_utils.c
> index 53e1e29..e0ecc23 100644
> --- a/drivers/staging/hv/hv_utils.c
> +++ b/drivers/staging/hv/hv_utils.c
> @@ -38,12 +38,14 @@
>  #include "vmbus_api.h"
>  #include "utils.h"
>  
> +static u8 *shut_txf_buf;
> +static u8 *time_txf_buf;
> +static u8 *hbeat_txf_buf;
>  
>  static void shutdown_onchannelcallback(void *context)
>  {
>  	struct vmbus_channel *channel = context;
> -	u8 *buf;
> -	u32 buflen, recvlen;
> +	u32 recvlen;
>  	u64 requestid;
>  	u8  execute_shutdown = false;
>  
> @@ -52,24 +54,23 @@ static void shutdown_onchannelcallback(void *context)
>  	struct icmsg_hdr *icmsghdrp;
>  	struct icmsg_negotiate *negop = NULL;
>  
> -	buflen = PAGE_SIZE;
> -	buf = kmalloc(buflen, GFP_ATOMIC);
> -
> -	vmbus_recvpacket(channel, buf, buflen, &recvlen, &requestid);
> +	vmbus_recvpacket(channel, shut_txf_buf,
> +			 PAGE_SIZE, &recvlen, &requestid);
Even if vmbus_recvpacket were to fail, why don't we just shut the guest down; after all we already know that is the intent of the host.

Regards,

K. Y
>  
>  	if (recvlen > 0) {
>  		DPRINT_DBG(VMBUS, "shutdown packet: len=%d, requestid=%lld",
>  			   recvlen, requestid);
>  
> -		icmsghdrp = (struct icmsg_hdr *)&buf[
> +		icmsghdrp = (struct icmsg_hdr *)&shut_txf_buf[
>  			sizeof(struct vmbuspipe_hdr)];
>  
>  		if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
> -			prep_negotiate_resp(icmsghdrp, negop, buf);
> +			prep_negotiate_resp(icmsghdrp, negop, shut_txf_buf);
>  		} else {
> -			shutdown_msg = (struct shutdown_msg_data *)&buf[
> -				sizeof(struct vmbuspipe_hdr) +
> -				sizeof(struct icmsg_hdr)];
> +			shutdown_msg =
> +				(struct shutdown_msg_data *)&shut_txf_buf[
> +					sizeof(struct vmbuspipe_hdr) +
> +					sizeof(struct icmsg_hdr)];
>  
>  			switch (shutdown_msg->flags) {
>  			case 0:
> @@ -93,13 +94,11 @@ static void shutdown_onchannelcallback(void *context)
>  		icmsghdrp->icflags = ICMSGHDRFLAG_TRANSACTION
>  			| ICMSGHDRFLAG_RESPONSE;
>  
> -		vmbus_sendpacket(channel, buf,
> +		vmbus_sendpacket(channel, shut_txf_buf,
>  				       recvlen, requestid,
>  				       VmbusPacketTypeDataInBand, 0);
>  	}
>  
> -	kfree(buf);
> -
>  	if (execute_shutdown == true)
>  		orderly_poweroff(false);
>  }
> @@ -150,28 +149,25 @@ static inline void adj_guesttime(u64 hosttime, u8 
> flags)
>  static void timesync_onchannelcallback(void *context)
>  {
>  	struct vmbus_channel *channel = context;
> -	u8 *buf;
> -	u32 buflen, recvlen;
> +	u32 recvlen;
>  	u64 requestid;
>  	struct icmsg_hdr *icmsghdrp;
>  	struct ictimesync_data *timedatap;
>  
> -	buflen = PAGE_SIZE;
> -	buf = kmalloc(buflen, GFP_ATOMIC);
> -
> -	vmbus_recvpacket(channel, buf, buflen, &recvlen, &requestid);
> +	vmbus_recvpacket(channel, time_txf_buf,
> +			 PAGE_SIZE, &recvlen, &requestid);
>  
>  	if (recvlen > 0) {
>  		DPRINT_DBG(VMBUS, "timesync packet: recvlen=%d, requestid=%lld",
>  			recvlen, requestid);
>  
> -		icmsghdrp = (struct icmsg_hdr *)&buf[
> +		icmsghdrp = (struct icmsg_hdr *)&time_txf_buf[
>  				sizeof(struct vmbuspipe_hdr)];
>  
>  		if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
> -			prep_negotiate_resp(icmsghdrp, NULL, buf);
> +			prep_negotiate_resp(icmsghdrp, NULL, time_txf_buf);
>  		} else {
> -			timedatap = (struct ictimesync_data *)&buf[
> +			timedatap = (struct ictimesync_data *)&time_txf_buf[
>  				sizeof(struct vmbuspipe_hdr) +
>  				sizeof(struct icmsg_hdr)];
>  			adj_guesttime(timedatap->parenttime, timedatap->flags);
> @@ -180,12 +176,10 @@ static void timesync_onchannelcallback(void *context)
>  		icmsghdrp->icflags = ICMSGHDRFLAG_TRANSACTION
>  			| ICMSGHDRFLAG_RESPONSE;
>  
> -		vmbus_sendpacket(channel, buf,
> +		vmbus_sendpacket(channel, time_txf_buf,
>  				recvlen, requestid,
>  				VmbusPacketTypeDataInBand, 0);
>  	}
> -
> -	kfree(buf);
>  }
>  
>  /*
> @@ -196,30 +190,28 @@ static void timesync_onchannelcallback(void *context)
>  static void heartbeat_onchannelcallback(void *context)
>  {
>  	struct vmbus_channel *channel = context;
> -	u8 *buf;
> -	u32 buflen, recvlen;
> +	u32 recvlen;
>  	u64 requestid;
>  	struct icmsg_hdr *icmsghdrp;
>  	struct heartbeat_msg_data *heartbeat_msg;
>  
> -	buflen = PAGE_SIZE;
> -	buf = kmalloc(buflen, GFP_ATOMIC);
> -
> -	vmbus_recvpacket(channel, buf, buflen, &recvlen, &requestid);
> +	vmbus_recvpacket(channel, hbeat_txf_buf,
> +			 PAGE_SIZE, &recvlen, &requestid);
>  
>  	if (recvlen > 0) {
>  		DPRINT_DBG(VMBUS, "heartbeat packet: len=%d, requestid=%lld",
>  			   recvlen, requestid);
>  
> -		icmsghdrp = (struct icmsg_hdr *)&buf[
> +		icmsghdrp = (struct icmsg_hdr *)&hbeat_txf_buf[
>  				sizeof(struct vmbuspipe_hdr)];
>  
>  		if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
> -			prep_negotiate_resp(icmsghdrp, NULL, buf);
> +			prep_negotiate_resp(icmsghdrp, NULL, hbeat_txf_buf);
>  		} else {
> -			heartbeat_msg = (struct heartbeat_msg_data *)&buf[
> -				sizeof(struct vmbuspipe_hdr) +
> -				sizeof(struct icmsg_hdr)];
> +			heartbeat_msg =
> +				(struct heartbeat_msg_data *)&hbeat_txf_buf[
> +					sizeof(struct vmbuspipe_hdr) +
> +					sizeof(struct icmsg_hdr)];
>  
>  			DPRINT_DBG(VMBUS, "heartbeat seq = %lld",
>  				   heartbeat_msg->seq_num);
> @@ -230,12 +222,10 @@ static void heartbeat_onchannelcallback(void *context)
>  		icmsghdrp->icflags = ICMSGHDRFLAG_TRANSACTION
>  			| ICMSGHDRFLAG_RESPONSE;
>  
> -		vmbus_sendpacket(channel, buf,
> +		vmbus_sendpacket(channel, hbeat_txf_buf,
>  				       recvlen, requestid,
>  				       VmbusPacketTypeDataInBand, 0);
>  	}
> -
> -	kfree(buf);
>  }
>  
>  static const struct pci_device_id __initconst
> @@ -268,6 +258,16 @@ static int __init init_hyperv_utils(void)
>  	if (!dmi_check_system(hv_utils_dmi_table))
>  		return -ENODEV;
>  
> +	shut_txf_buf = kmalloc(PAGE_SIZE, GFP_ATOMIC);
> +	time_txf_buf = kmalloc(PAGE_SIZE, GFP_ATOMIC);
> +	hbeat_txf_buf = kmalloc(PAGE_SIZE, GFP_ATOMIC);
> +
> +	if (!shut_txf_buf || !time_txf_buf || !hbeat_txf_buf) {
> +		printk(KERN_INFO
> +		       "Unable to allocate memory for receive buffer\n");
> +		return -ENOMEM;
> +	}
> +
>  	hv_cb_utils[HV_SHUTDOWN_MSG].channel->onchannel_callback =
>  		&shutdown_onchannelcallback;
>  	hv_cb_utils[HV_SHUTDOWN_MSG].callback = &shutdown_onchannelcallback;
> @@ -298,6 +298,10 @@ static void exit_hyperv_utils(void)
>  	hv_cb_utils[HV_HEARTBEAT_MSG].channel->onchannel_callback =
>  		&chn_cb_negotiate;
>  	hv_cb_utils[HV_HEARTBEAT_MSG].callback = &chn_cb_negotiate;
> +
> +	kfree(shut_txf_buf);
> +	kfree(time_txf_buf);
> +	kfree(hbeat_txf_buf);
>  }
>  
>  module_init(init_hyperv_utils);

