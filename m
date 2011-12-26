Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab1LZW1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 17:27:19 -0500
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60159 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab1LZW1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 17:27:17 -0500
Message-ID: <4EF8F4B5.6000900@cs.wisc.edu>
Date: Mon, 26 Dec 2011 16:27:01 -0600
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
CC: linux-scsi@vger.kernel.org, netdev@vger.kernel.org, kxie@chelsio.com,
        davem@davemloft.net, JBottomley@parallels.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libcxgbi: do not print a message when memory allocation
 fails
References: <1323877583-6844-1-git-send-email-cascardo@linux.vnet.ibm.com>
In-Reply-To: <1323877583-6844-1-git-send-email-cascardo@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 09:46 AM, Thadeu Lima de Souza Cascardo wrote:
> In alloc_pdu, libcxgbi tries to allocate a skb with GFP_ATOMIC, which
> may potentially fail. When it happens, the current code prints a warning
> message.
> 
> When the system is under IO stress, this failure may happen lots of
> times and it usually scares users.
> 
> Instead of printing the warning message, the code now increases the
> tx_dropped statistics for the ethernet interface wich is doing the iscsi
> task.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
> ---
>  drivers/scsi/cxgbi/libcxgbi.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
> index c10f74a..3422bc2 100644
> --- a/drivers/scsi/cxgbi/libcxgbi.c
> +++ b/drivers/scsi/cxgbi/libcxgbi.c
> @@ -1862,8 +1862,9 @@ int cxgbi_conn_alloc_pdu(struct iscsi_task *task, u8 opcode)
>  
>  	tdata->skb = alloc_skb(cdev->skb_tx_rsvd + headroom, GFP_ATOMIC);
>  	if (!tdata->skb) {
> -		pr_warn("alloc skb %u+%u, opcode 0x%x failed.\n",
> -			cdev->skb_tx_rsvd, headroom, opcode);
> +		struct cxgbi_sock *csk = cconn->cep->csk;
> +		struct net_device *ndev = cdev->ports[csk->port_id];
> +		ndev->stats.tx_dropped++;
>  		return -ENOMEM;
>  	}
>  

Looks ok to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
