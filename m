Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586Ab0LJANI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 19:13:08 -0500
Received: from novprvoes0310.provo.novell.com ([137.65.248.74]:46008 "EHLO
	novprvoes0310.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754288Ab0LJANG convert rfc822-to-8bit
	(ORCPT <rfc822;groupwise-ksrinivasan@novell.com:6:1>);
	Thu, 9 Dec 2010 19:13:06 -0500
Message-Id: <4D013908.E57C.0030.1@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Thu, 09 Dec 2010 17:13:01 -0700
From: "Ky Srinivasan" <ksrinivasan@novell.com>
To: <zbr@ioremap.net>, <devel@linuxdriverproject.org>,
        <virtualization@lists.osdl.org>, <hjanssen@microsoft.com>,
        <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
Cc: "Haiyang Zhang" <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/1] Properly check return values of kmalloc and
 vmbus_recvpacket
References: <1291926209-17120-1-git-send-email-hjanssen@microsoft.com>
In-Reply-To: <1291926209-17120-1-git-send-email-hjanssen@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>>> On 12/9/2010 at  3:23 PM, in message
<1291926209-17120-1-git-send-email-hjanssen@microsoft.com>, Hank Janssen
<hjanssen@microsoft.com> wrote: 
> Correct ugly oversight, we need to check the return values of kmalloc
> and vmbus_recvpacket and return if they fail. I also tightened up the
> call to kmalloc. 
> 
> Thanks to Evgeniy Polyakov <zbr@ioremap.net>  for pointing this out.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> 
> ---
>  drivers/staging/hv/hv_utils.c |   48 ++++++++++++++++++++++++++++------------
>  1 files changed, 33 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/staging/hv/hv_utils.c b/drivers/staging/hv/hv_utils.c
> index 53e1e29..ac68575 100644
> --- a/drivers/staging/hv/hv_utils.c
> +++ b/drivers/staging/hv/hv_utils.c
> @@ -43,21 +43,27 @@ static void shutdown_onchannelcallback(void *context)
>  {
>  	struct vmbus_channel *channel = context;
>  	u8 *buf;
> -	u32 buflen, recvlen;
> +	u32 recvlen;
>  	u64 requestid;
>  	u8  execute_shutdown = false;
> +	int ret = 0;
>  
>  	struct shutdown_msg_data *shutdown_msg;
>  
>  	struct icmsg_hdr *icmsghdrp;
>  	struct icmsg_negotiate *negop = NULL;
>  
> -	buflen = PAGE_SIZE;
> -	buf = kmalloc(buflen, GFP_ATOMIC);
> +	buf = kmalloc(PAGE_SIZE, GFP_ATOMIC);
>  
> -	vmbus_recvpacket(channel, buf, buflen, &recvlen, &requestid);
> +	if (!buf) {
> +		printk(KERN_INFO
> +		       "Unable to allocate memory for shutdown_onchannelcallback");
> +		return;
> +	}
> +
> +	ret = vmbus_recvpacket(channel, buf, PAGE_SIZE, &recvlen, &requestid);
>  
> -	if (recvlen > 0) {
> +	if (ret == 0 && recvlen > 0) {
>  		DPRINT_DBG(VMBUS, "shutdown packet: len=%d, requestid=%lld",
>  			   recvlen, requestid);
>  
> @@ -151,17 +157,23 @@ static void timesync_onchannelcallback(void *context)
>  {
>  	struct vmbus_channel *channel = context;
>  	u8 *buf;
> -	u32 buflen, recvlen;
> +	u32 recvlen;
>  	u64 requestid;
>  	struct icmsg_hdr *icmsghdrp;
>  	struct ictimesync_data *timedatap;
> +	int ret = 0;
>  
> -	buflen = PAGE_SIZE;
> -	buf = kmalloc(buflen, GFP_ATOMIC);
> +	buf = kmalloc(PAGE_SIZE, GFP_ATOMIC);
>  
> -	vmbus_recvpacket(channel, buf, buflen, &recvlen, &requestid);
> +	if (!buf) {
> +		printk(KERN_INFO
> +		       "Unable to allocate memory for timesync_onchannelcallback");
> +		return;
> +	}
>  
> -	if (recvlen > 0) {
> +	ret = vmbus_recvpacket(channel, buf, PAGE_SIZE, &recvlen, &requestid);
> +
> +	if (ret == 0 && recvlen > 0) {
>  		DPRINT_DBG(VMBUS, "timesync packet: recvlen=%d, requestid=%lld",
>  			recvlen, requestid);
>  
> @@ -197,17 +209,23 @@ static void heartbeat_onchannelcallback(void *context)
>  {
>  	struct vmbus_channel *channel = context;
>  	u8 *buf;
> -	u32 buflen, recvlen;
> +	u32 recvlen;
>  	u64 requestid;
>  	struct icmsg_hdr *icmsghdrp;
>  	struct heartbeat_msg_data *heartbeat_msg;
> +	int ret = 0;
> +
> +	buf = kmalloc(PAGE_SIZE, GFP_ATOMIC);
>  
> -	buflen = PAGE_SIZE;
> -	buf = kmalloc(buflen, GFP_ATOMIC);
> +	if (!buf) {
> +		printk(KERN_INFO
> +		    "Unable to allocate memory for heartbeat_onchannelcallback");
> +		return;
> +	}
>  
> -	vmbus_recvpacket(channel, buf, buflen, &recvlen, &requestid);
> +	ret = vmbus_recvpacket(channel, buf, PAGE_SIZE, &recvlen, &requestid);
>  
> -	if (recvlen > 0) {
> +	if (ret == 0 && recvlen > 0) {
>  		DPRINT_DBG(VMBUS, "heartbeat packet: len=%d, requestid=%lld",
>  			   recvlen, requestid);
>  
I am wondering if it might be better to allocate a page during module startup for dealing with some of these services. Since the protocol guarantees that there cannot be more than one outstanding request from the host side, having a pre-allocated receive buffer would be a more robust solution - we don't have to allocate memory when we cannot afford to sleep and thereby don't have to deal with a class of failure conditions that are not easy to deal with. For instance not being able to shut the guest down because of low memory situation would be bad.

Regards,

K. Y 
