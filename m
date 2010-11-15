Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab0KOOUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 09:20:21 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:52300 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862Ab0KOOUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 09:20:19 -0500
X-Auth-Info: QW+Jg3CBsmKPfeHRRompl20ujpFaSLUqGmLeunr0w+I=
Message-ID: <4CE141EA.5070702@grandegger.com>
Date: Mon, 15 Nov 2010 15:21:30 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Christian Pellegrin <chripell@fsfe.org>,
        Barry Song <21cnbao@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew.chih.howe.khor@intel.com,
        qi.wang@intel.com, margie.foster@intel.com, yong.y.wang@intel.com,
        Masayuki Ohtake <masa-korg@dsn.okisemi.com>, kok.howg.ewe@intel.com,
        joel.clark@intel.com
Subject: Re: [PATCH net-next-2.6 v2] can: Topcliff: PCH_CAN driver: Add Flow
 control,
References: <4CE0EFA7.9020007@dsn.okisemi.com>
In-Reply-To: <4CE0EFA7.9020007@dsn.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/15/2010 09:30 AM, Tomoya MORINAGA wrote:
>  * Add Flow control
>  * Fix Data copy issue (endianness)
>  * Add Macro prefix "PCH_"
>  * Separate interface register structure
>  * Some functions are unified.
>  * Change MessageObject indication(PCH_RX_OBJ_START, etc..)
>  * Enumerate LEC macro
>  * Move MSI processing from open/close to probe/remove processing
>  * Use BIT(x)
>  * and more...
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> ---
>  drivers/net/can/pch_can.c | 1348 ++++++++++++++++++++-------------------------
>  1 files changed, 595 insertions(+), 753 deletions(-)
> 
> diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
> index 6727182..6a38593 100644
> --- a/drivers/net/can/pch_can.c
> +++ b/drivers/net/can/pch_can.c
...
> -	if (status & PCH_LEC_ALL) {
> +	lec = status & PCH_LEC_ALL;
> +	switch (lec) {
> +	case PCH_STUF_ERR:
> +		cf->data[2] |= CAN_ERR_PROT_STUFF;
>  		priv->can.can_stats.bus_error++;
>  		stats->rx_errors++;
> -		switch (status & PCH_LEC_ALL) {
> -		case PCH_STUF_ERR:
> -			cf->data[2] |= CAN_ERR_PROT_STUFF;
> -			break;
> -		case PCH_FORM_ERR:
> -			cf->data[2] |= CAN_ERR_PROT_FORM;
> -			break;
> -		case PCH_ACK_ERR:
> -			cf->data[2] |= CAN_ERR_PROT_LOC_ACK |
> -				       CAN_ERR_PROT_LOC_ACK_DEL;
> -			break;
> -		case PCH_BIT1_ERR:
> -		case PCH_BIT0_ERR:
> -			cf->data[2] |= CAN_ERR_PROT_BIT;
> -			break;
> -		case PCH_CRC_ERR:
> -			cf->data[2] |= CAN_ERR_PROT_LOC_CRC_SEQ |
> -				       CAN_ERR_PROT_LOC_CRC_DEL;
> -			break;
> -		default:
> -			iowrite32(status | PCH_LEC_ALL, &priv->regs->stat);
> -			break;
> -		}
> -
> +		break;
> +	case PCH_FORM_ERR:
> +		cf->data[2] |= CAN_ERR_PROT_FORM;
> +		priv->can.can_stats.bus_error++;
> +		stats->rx_errors++;
> +		break;
> +	case PCH_ACK_ERR:
> +		cf->can_id |= CAN_ERR_ACK;
> +		priv->can.can_stats.bus_error++;
> +		stats->rx_errors++;
> +		break;
> +	case PCH_BIT1_ERR:
> +	case PCH_BIT0_ERR:
> +		cf->data[2] |= CAN_ERR_PROT_BIT;
> +		priv->can.can_stats.bus_error++;
> +		stats->rx_errors++;
> +		break;
> +	case PCH_CRC_ERR:
> +		cf->data[2] |= CAN_ERR_PROT_LOC_CRC_SEQ |
> +			       CAN_ERR_PROT_LOC_CRC_DEL;
> +		priv->can.can_stats.bus_error++;
> +		stats->rx_errors++;
> +		break;
> +	case PCH_LEC_ALL: /* Written by CPU. No error status */
> +		break;
>  	}

More comments to the lec handling below.

> +	cf->data[6] = ioread32(&priv->regs->errc) & PCH_TEC;
> +	cf->data[7] = (ioread32(&priv->regs->errc) & PCH_REC) >> 8;

Could be handle with just *one* register access.

...
>  static int pch_can_rx_poll(struct napi_struct *napi, int quota)
>  {
>  	struct net_device *ndev = napi->dev;
>  	struct pch_can_priv *priv = netdev_priv(ndev);
> -	struct net_device_stats *stats = &(priv->ndev->stats);
> -	u32 dlc;
>  	u32 int_stat;
>  	int rcv_pkts = 0;
>  	u32 reg_stat;
> -	unsigned long flags;
>  
>  	int_stat = pch_can_int_pending(priv);
>  	if (!int_stat)
> -		return 0;
> +		goto end;
>  
> -INT_STAT:
> -	if (int_stat == CAN_STATUS_INT) {
> +	if ((int_stat == PCH_STATUS_INT) && (quota > 0)) {
>  		reg_stat = ioread32(&priv->regs->stat);
>  		if (reg_stat & (PCH_BUS_OFF | PCH_LEC_ALL)) {
> -			if ((reg_stat & PCH_LEC_ALL) != PCH_LEC_ALL)
> +			if ((reg_stat & PCH_LEC_ALL) != PCH_LEC_ALL) {
>  				pch_can_error(ndev, reg_stat);
> +				quota--;
> +			}

Should be:

  		if (reg_stat & PCH_BUS_OFF ||
		    (reg_stat & PCH_LEC_ALL) != PCH_LEC_ALL) {

Your lec handling is still not correc, I believe. The driver needs to
write PCH_LEC_ALL to the "stat" register once in the initialization code
and then after each error observed (lec != PCH_LEC_ALL). I still do not
find such code. Could you show us the output of

  "# candump any,0:0,#FFFFFFFF"

when yo send CAN messages *without* a cable connected?.

Thanks,

Wolfgang.
