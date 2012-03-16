Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161841Ab2CPAax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 20:30:53 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58155 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161698Ab2CPAat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 20:30:49 -0400
Message-ID: <4F6289B3.2060204@gmail.com>
Date: Fri, 16 Mar 2012 01:30:43 +0100
From: Mircea Gherzan <mgherzan@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: alexandrasava18@gmail.com
CC: gregkh@linuxfoundation.org, pavan_savoy@ti.com, daniel.baluta@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ti-st: Enhange logging for Shared Transport - TI driver
References: <y> <4f623469.634cb40a.5d79.ffff841d@mx.google.com>
In-Reply-To: <4f623469.634cb40a.5d79.ffff841d@mx.google.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is what I get now (with no debug) when loading the btwilink module
that uses ti-st:

[  129.567382] (stk) :change remote baud rate command in firmware
[  129.573577] (stk) :skipping the wait event of change remote baud

This is:
 1. too "verbose" => these 2 prints should belong to debug
 2. poorly formated
 3. not telling me which driver generated this output
 4. not giving me the version of the firmware that was loaded.

To address 2 and 3, please remove the the "(stc)" / "(stk)" prefixes and
use instead the quite widespread prefix KBUILD_MODNAME ": "

Am 15.03.2012 19:26, schrieb alexandrasava18@gmail.com:
> From: Alexandra Sava <alexandrasava18@gmail.com>
>
> * added new module parameter named debug_mask to control displayed
> messages verbosity
> * the logging mechanism is enabled via CONFIG_TI_ST_DEBUG Kconfig option
>
> Signed-off-by: Alexandra Sava <alexandrasava18@gmail.com>
> ---
>  drivers/misc/ti-st/Kconfig   |    7 ++
>  drivers/misc/ti-st/debug.h   |   34 +++++++++
>  drivers/misc/ti-st/st_core.c |  153
+++++++++++++++++++-----------------------
>  drivers/misc/ti-st/st_kim.c  |  126 +++++++++++++++++-----------------
>  drivers/misc/ti-st/st_ll.c   |   28 ++++----
>  5 files changed, 187 insertions(+), 161 deletions(-)
>  create mode 100644 drivers/misc/ti-st/debug.h
>
> diff --git a/drivers/misc/ti-st/Kconfig b/drivers/misc/ti-st/Kconfig
> index abb5de1..6d4e6a3 100644
> --- a/drivers/misc/ti-st/Kconfig
> +++ b/drivers/misc/ti-st/Kconfig
> @@ -14,4 +14,11 @@ config TI_ST
>  	  are returned to relevant protocol drivers based on their
>  	  packet types.
>
> +if TI_ST
> +config TI_ST_DEBUG
> +	bool "Enable full debugging output for the Shared transport core driver"
> +	depends on TI_ST
> +	---help---
> +		Debugging support.

We probably do not need this: even though some debug statements might be
on the data path, the ARM cores used in ST-enabled setups feature decent
branch prediction.

> +endif # TI_ST
>  endmenu
> diff --git a/drivers/misc/ti-st/debug.h b/drivers/misc/ti-st/debug.h
> new file mode 100644
> index 0000000..68ffc74
> --- /dev/null
> +++ b/drivers/misc/ti-st/debug.h
> @@ -0,0 +1,34 @@
> +#ifndef TI_ST_DEBUG_H
> +#define TI_ST_DEBUG_H
> +
> +enum TI_ST_DEBUG_MASK {
> +	TI_ST_DBG_HCI_LL = 0x0001, /* HCI_LL protocol */
> +	TI_ST_DBG_KIM = 0x0002, /* GPIO control and firmware download */
> +	TI_ST_DBG_CORE = 0x0003, /* ST KIM driver and ST LL driver */

Bitwise OR between the first two.

> +	TI_ST_DBG_ALL = 0xffff /* enable all logs */
> +};
> +
> +extern unsigned short debug_mask;
> +
> +#define ti_st_info(fmt, ...)	\
> +	pr_info(fmt, ##__VA_ARGS__);
> +#define ti_st_err(fmt, ...)		\
> +	pr_err(fmt, ##__VA_ARGS__);
> +#define ti_st_warn(fmt, ...)	\
> +	pr_warn(fmt, ##__VA_ARGS__);
> +

Please use a standard prefix, see above.

> +
> +#ifdef CONFIG_TI_ST_DEBUG
> +#define ti_st_dbg(mask, fmt, ...)                  \
> +	({                              \
> +		if (debug_mask & mask)                     \

if (unlikely(...)), just in case we're on a data path.

> +			pr_debug(fmt, ##__VA_ARGS__);    \
> +	})
> +#else
> +static inline void ti_st_dbg(enum TI_ST_DEBUG_MASK dbg_mask,
> +							 const char *fmt, ...)
> +{
> +}
> +
> +#endif
> +#endif
> diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
> index 2b62232..245cf31 100644
> --- a/drivers/misc/ti-st/st_core.c
> +++ b/drivers/misc/ti-st/st_core.c
> @@ -1,4 +1,5 @@
>  /*
> +
>   *  Shared Transport Line discipline driver Core
>   *	This hooks up ST KIM driver and ST LL driver
>   *  Copyright (C) 2009-2010 Texas Instruments
> @@ -29,6 +30,7 @@
>  #include <linux/skbuff.h>
>
>  #include <linux/ti_wilink_st.h>
> +#include "debug.h"
>
>  /* function pointer pointing to either,
>   * st_kim_recv during registration to receive fw download responses
> @@ -40,7 +42,7 @@ void (*st_recv) (void*, const unsigned char*, long);
>  static void add_channel_to_table(struct st_data_s *st_gdata,
>  		struct st_proto_s *new_proto)
>  {
> -	pr_info("%s: id %d\n", __func__, new_proto->chnl_id);
> +	ti_st_dbg(TI_ST_DBG_CORE, "%s: id %d\n", __func__, new_proto->chnl_id);
>  	/* list now has the channel id as index itself */
>  	st_gdata->list[new_proto->chnl_id] = new_proto;
>  	st_gdata->is_registered[new_proto->chnl_id] = true;
> @@ -49,7 +51,7 @@ static void add_channel_to_table(struct st_data_s
*st_gdata,
>  static void remove_channel_from_table(struct st_data_s *st_gdata,
>  		struct st_proto_s *proto)
>  {
> -	pr_info("%s: id %d\n", __func__, proto->chnl_id);
> +	ti_st_dbg(TI_ST_DBG_CORE, "%s: id %d\n", __func__, proto->chnl_id);
>  /*	st_gdata->list[proto->chnl_id] = NULL; */
>  	st_gdata->is_registered[proto->chnl_id] = false;
>  }
> @@ -65,7 +67,7 @@ int st_get_uart_wr_room(struct st_data_s *st_gdata)
>  {
>  	struct tty_struct *tty;
>  	if (unlikely(st_gdata == NULL || st_gdata->tty == NULL)) {
> -		pr_err("tty unavailable to perform write");
> +		ti_st_err("tty unavailable to perform write");
>  		return -1;
>  	}
>  	tty = st_gdata->tty;
> @@ -84,7 +86,7 @@ int st_int_write(struct st_data_s *st_gdata,
>  {
>  	struct tty_struct *tty;
>  	if (unlikely(st_gdata == NULL || st_gdata->tty == NULL)) {
> -		pr_err("tty unavailable to perform write");
> +		ti_st_err("tty unavailable to perform write");
>  		return -EINVAL;
>  	}
>  	tty = st_gdata->tty;
> @@ -102,12 +104,12 @@ int st_int_write(struct st_data_s *st_gdata,
>   */
>  void st_send_frame(unsigned char chnl_id, struct st_data_s *st_gdata)
>  {
> -	pr_debug(" %s(prot:%d) ", __func__, chnl_id);
> +	ti_st_dbg(TI_ST_DBG_CORE, " %s(prot:%d) ", __func__, chnl_id);
>
>  	if (unlikely
>  	    (st_gdata == NULL || st_gdata->rx_skb == NULL
>  	     || st_gdata->is_registered[chnl_id] == false)) {
> -		pr_err("chnl_id %d not registered, no data to send?",
> +		ti_st_err("chnl_id %d not registered, no data to send?",
>  			   chnl_id);

Here there's no whitespace at the beginning of the format string...

>  		kfree_skb(st_gdata->rx_skb);
>  		return;
> @@ -122,12 +124,12 @@ void st_send_frame(unsigned char chnl_id, struct
st_data_s *st_gdata)
>  			(st_gdata->list[chnl_id]->recv
>  			(st_gdata->list[chnl_id]->priv_data, st_gdata->rx_skb)
>  			     != 0)) {
> -			pr_err(" proto stack %d's ->recv failed", chnl_id);
> +			ti_st_err(" proto stack %d's ->recv failed", chnl_id);

... but here the whitespace is there. IMHO, this kind of whitespace
should be removed.

>  			kfree_skb(st_gdata->rx_skb);
>  			return;
>  		}
>  	} else {
> -		pr_err(" proto stack %d's ->recv null", chnl_id);
> +		ti_st_err(" proto stack %d's ->recv null", chnl_id);
>  		kfree_skb(st_gdata->rx_skb);
>  	}
>  	return;
> @@ -143,14 +145,15 @@ void st_send_frame(unsigned char chnl_id, struct
st_data_s *st_gdata)
>  void st_reg_complete(struct st_data_s *st_gdata, char err)
>  {
>  	unsigned char i = 0;
> -	pr_info(" %s ", __func__);
> +
>  	for (i = 0; i < ST_MAX_CHANNELS; i++) {
>  		if (likely(st_gdata != NULL &&
>  			st_gdata->is_registered[i] == true &&
>  				st_gdata->list[i]->reg_complete_cb != NULL)) {
>  			st_gdata->list[i]->reg_complete_cb
>  				(st_gdata->list[i]->priv_data, err);
> -			pr_info("protocol %d's cb sent %d\n", i, err);
> +			ti_st_dbg(TI_ST_DBG_KIM, "protocol %d's cb "
> +						"sent %d\n", i, err);
>  			if (err) { /* cleanup registered protocol */
>  				st_gdata->protos_registered--;
>  				st_gdata->is_registered[i] = false;
> @@ -164,8 +167,6 @@ static inline int st_check_data_len(struct
st_data_s *st_gdata,
>  {
>  	int room = skb_tailroom(st_gdata->rx_skb);
>
> -	pr_debug("len %d room %d", len, room);
> -
>  	if (!len) {
>  		/* Received packet has only packet header and
>  		 * has zero length payload. So, ask ST CORE to
> @@ -177,7 +178,7 @@ static inline int st_check_data_len(struct
st_data_s *st_gdata,
>  		/* Received packet's payload length is larger.
>  		 * We can't accommodate it in created skb.
>  		 */
> -		pr_err("Data length is too large len %d room %d", len,
> +		ti_st_err("Data length is too large len %d room %d", len,
>  			   room);
>  		kfree_skb(st_gdata->rx_skb);
>  	} else {
> @@ -201,7 +202,7 @@ static inline int st_check_data_len(struct
st_data_s *st_gdata,
>
>  /**
>   * st_wakeup_ack - internal function for action when wake-up ack
> - *	received
> + * received
>   */
>  static inline void st_wakeup_ack(struct st_data_s *st_gdata,
>  	unsigned char cmd)
> @@ -244,15 +245,14 @@ void st_int_recv(void *disc_data,
>  	unsigned long flags;
>
>  	ptr = (char *)data;
> -	/* tty_receive sent null ? */
>  	if (unlikely(ptr == NULL) || (st_gdata == NULL)) {
> -		pr_err(" received null from TTY ");
> +		ti_st_err(" received null from TTY ");
>  		return;
>  	}
>
> -	pr_debug("count %ld rx_state %ld"
> -		   "rx_count %ld", count, st_gdata->rx_state,
> -		   st_gdata->rx_count);
> +	ti_st_dbg(TI_ST_DBG_CORE, "%s: count %ld rx_state %ld"
> +		"rx_count %ld", __func__, count, st_gdata->rx_state,
> +		st_gdata->rx_count);
>
>  	spin_lock_irqsave(&st_gdata->lock, flags);
>  	/* Decode received bytes here */
> @@ -271,7 +271,7 @@ void st_int_recv(void *disc_data,
>  			switch (st_gdata->rx_state) {
>  			/* Waiting for complete packet ? */
>  			case ST_W4_DATA:
> -				pr_debug("Complete pkt received");
> +				ti_st_dbg(TI_ST_DBG_CORE, "Complete pkt received");
>  				/* Ask ST CORE to forward
>  				 * the packet to protocol driver */
>  				st_send_frame(st_gdata->rx_chnl, st_gdata);
> @@ -285,32 +285,28 @@ void st_int_recv(void *disc_data,
>  				plen =
>  				&st_gdata->rx_skb->data
>  				[proto->offset_len_in_hdr];
> -				pr_debug("plen pointing to %x\n", *plen);
>  				if (proto->len_size == 1)/* 1 byte len field */
>  					payload_len = *(unsigned char *)plen;
>  				else if (proto->len_size == 2)
>  					payload_len =
>  					__le16_to_cpu(*(unsigned short *)plen);
>  				else
> -					pr_info("%s: invalid length "
> -					"for id %d\n",
> -					__func__, proto->chnl_id);
> +					ti_st_dbg(TI_ST_DBG_CORE, "%s: invalid length"
> +					"for id %d\n", __func__, proto->chnl_id);
> +
>  				st_check_data_len(st_gdata, proto->chnl_id,
>  						payload_len);
> -				pr_debug("off %d, pay len %d\n",
> -					proto->offset_len_in_hdr, payload_len);
>  				continue;
> -			}	/* end of switch rx_state */
> +			}
>  		}
>
> -		/* end of if rx_count */
>  		/* Check first byte of packet and identify module
>  		 * owner (BT/FM/GPS) */
>  		switch (*ptr) {
>  		case LL_SLEEP_IND:
>  		case LL_SLEEP_ACK:
>  		case LL_WAKE_UP_IND:
> -			pr_debug("PM packet");
> +			ti_st_dbg(TI_ST_DBG_CORE, "PM packet");
>  			/* this takes appropriate action based on
>  			 * sleep state received --
>  			 */
> @@ -327,8 +323,7 @@ void st_int_recv(void *disc_data,
>  			count--;
>  			continue;
>  		case LL_WAKE_UP_ACK:
> -			pr_debug("PM packet");
> -
> +			ti_st_dbg(TI_ST_DBG_CORE, "PM packet");
>  			spin_unlock_irqrestore(&st_gdata->lock, flags);
>  			/* wake up ack received */
>  			st_wakeup_ack(st_gdata, *ptr);
> @@ -341,10 +336,9 @@ void st_int_recv(void *disc_data,
>  		default:
>  			type = *ptr;
>  			if (st_gdata->list[type] == NULL) {
> -				pr_err("chip/interface misbehavior dropping"
> +				ti_st_err("chip/interface misbehavior dropping"
>  					" frame starting with 0x%02x", type);
>  				goto done;
> -
>  			}
>  			st_gdata->rx_skb = alloc_skb(
>  					st_gdata->list[type]->max_frame_size,
> @@ -352,19 +346,19 @@ void st_int_recv(void *disc_data,
>  			skb_reserve(st_gdata->rx_skb,
>  					st_gdata->list[type]->reserve);
>  			/* next 2 required for BT only */
> -			st_gdata->rx_skb->cb[0] = type; /*pkt_type*/
> -			st_gdata->rx_skb->cb[1] = 0; /*incoming*/
> +			st_gdata->rx_skb->cb[0] = type; /* pkt_type */
> +			st_gdata->rx_skb->cb[1] = 0; /* incoming */
>  			st_gdata->rx_chnl = *ptr;
>  			st_gdata->rx_state = ST_W4_HEADER;
>  			st_gdata->rx_count = st_gdata->list[type]->hdr_len;
> -			pr_debug("rx_count %ld\n", st_gdata->rx_count);
> +			ti_st_dbg(TI_ST_DBG_CORE, "%s: rx_count %ld\n", __func__,
> +						st_gdata->rx_count);
>  		};
>  		ptr++;
>  		count--;
>  	}
>  done:
>  	spin_unlock_irqrestore(&st_gdata->lock, flags);
> -	pr_debug("done %s", __func__);
>  	return;
>  }
>
> @@ -378,7 +372,6 @@ struct sk_buff *st_int_dequeue(struct st_data_s
*st_gdata)
>  {
>  	struct sk_buff *returning_skb;
>
> -	pr_debug("%s", __func__);
>  	if (st_gdata->tx_skb != NULL) {
>  		returning_skb = st_gdata->tx_skb;
>  		st_gdata->tx_skb = NULL;
> @@ -400,19 +393,18 @@ void st_int_enqueue(struct st_data_s *st_gdata,
struct sk_buff *skb)
>  {
>  	unsigned long flags = 0;
>
> -	pr_debug("%s", __func__);
>  	spin_lock_irqsave(&st_gdata->lock, flags);
>
>  	switch (st_ll_getstate(st_gdata)) {
>  	case ST_LL_AWAKE:
> -		pr_debug("ST LL is AWAKE, sending normally");
> +		ti_st_dbg(TI_ST_DBG_CORE, "ST LL is AWAKE, sending normally");
>  		skb_queue_tail(&st_gdata->txq, skb);
>  		break;
>  	case ST_LL_ASLEEP_TO_AWAKE:
>  		skb_queue_tail(&st_gdata->tx_waitq, skb);
>  		break;
>  	case ST_LL_AWAKE_TO_ASLEEP:
> -		pr_err("ST LL is illegal state(%ld),"
> +		ti_st_err("ST LL is illegal state(%ld),"
>  			   "purging received skb.", st_ll_getstate(st_gdata));
>  		kfree_skb(skb);
>  		break;
> @@ -421,14 +413,13 @@ void st_int_enqueue(struct st_data_s *st_gdata,
struct sk_buff *skb)
>  		st_ll_wakeup(st_gdata);
>  		break;
>  	default:
> -		pr_err("ST LL is illegal state(%ld),"
> +		ti_st_err("ST LL is illegal state(%ld),"
>  			   "purging received skb.", st_ll_getstate(st_gdata));
>  		kfree_skb(skb);
>  		break;
>  	}
>
>  	spin_unlock_irqrestore(&st_gdata->lock, flags);
> -	pr_debug("done %s", __func__);
>  	return;
>  }
>
> @@ -442,10 +433,10 @@ void st_tx_wakeup(struct st_data_s *st_data)
>  {
>  	struct sk_buff *skb;
>  	unsigned long flags;	/* for irq save flags */
> -	pr_debug("%s", __func__);
> +
>  	/* check for sending & set flag sending here */
>  	if (test_and_set_bit(ST_TX_SENDING, &st_data->tx_state)) {
> -		pr_debug("ST already sending");
> +		ti_st_dbg(TI_ST_DBG_CORE, "ST already sending");
>  		/* keep sending */
>  		set_bit(ST_TX_WAKEUP, &st_data->tx_state);
>  		return;
> @@ -499,25 +490,25 @@ void kim_st_list_protocols(struct st_data_s
*st_gdata, void *buf)
>   */
>  long st_register(struct st_proto_s *new_proto)
>  {
> -	struct st_data_s	*st_gdata;
> +	struct st_data_s *st_gdata;
>  	long err = 0;
>  	unsigned long flags = 0;
>
>  	st_kim_ref(&st_gdata, 0);
> -	pr_info("%s(%d) ", __func__, new_proto->chnl_id);
> +	ti_st_dbg(TI_ST_DBG_CORE, "%s(%d) ", __func__, new_proto->chnl_id);
>  	if (st_gdata == NULL || new_proto == NULL || new_proto->recv == NULL
>  	    || new_proto->reg_complete_cb == NULL) {
> -		pr_err("gdata/new_proto/recv or reg_complete_cb not ready");
> +		ti_st_err("gdata/new_proto/recv or reg_complete_cb not ready");
>  		return -EINVAL;
>  	}
>
>  	if (new_proto->chnl_id >= ST_MAX_CHANNELS) {
> -		pr_err("chnl_id %d not supported", new_proto->chnl_id);
> +		ti_st_err("chnl_id %d not supported", new_proto->chnl_id);
>  		return -EPROTONOSUPPORT;
>  	}
>
>  	if (st_gdata->is_registered[new_proto->chnl_id] == true) {
> -		pr_err("chnl_id %d already registered", new_proto->chnl_id);
> +		ti_st_err("chnl_id %d already registered", new_proto->chnl_id);
>  		return -EALREADY;
>  	}
>
> @@ -525,7 +516,8 @@ long st_register(struct st_proto_s *new_proto)
>  	spin_lock_irqsave(&st_gdata->lock, flags);
>
>  	if (test_bit(ST_REG_IN_PROGRESS, &st_gdata->st_state)) {
> -		pr_info(" ST_REG_IN_PROGRESS:%d ", new_proto->chnl_id);
> +		ti_st_dbg(TI_ST_DBG_CORE, " ST_REG_IN_PROGRESS:%d ",
> +				  new_proto->chnl_id);
>  		/* fw download in progress */
>
>  		add_channel_to_table(st_gdata, new_proto);
> @@ -536,7 +528,8 @@ long st_register(struct st_proto_s *new_proto)
>  		spin_unlock_irqrestore(&st_gdata->lock, flags);
>  		return -EINPROGRESS;
>  	} else if (st_gdata->protos_registered == ST_EMPTY) {
> -		pr_info(" chnl_id list empty :%d ", new_proto->chnl_id);
> +		ti_st_dbg(TI_ST_DBG_CORE, " chnl_id list empty :%d ",
> +				  new_proto->chnl_id);
>  		set_bit(ST_REG_IN_PROGRESS, &st_gdata->st_state);
>  		st_recv = st_kim_recv;
>
> @@ -554,7 +547,7 @@ long st_register(struct st_proto_s *new_proto)
>  			clear_bit(ST_REG_IN_PROGRESS, &st_gdata->st_state);
>  			if ((st_gdata->protos_registered != ST_EMPTY) &&
>  			    (test_bit(ST_REG_PENDING, &st_gdata->st_state))) {
> -				pr_err(" KIM failure complete callback ");
> +				ti_st_err(" KIM failure complete callback ");
>  				st_reg_complete(st_gdata, err);
>  				clear_bit(ST_REG_PENDING, &st_gdata->st_state);
>  			}
> @@ -566,12 +559,12 @@ long st_register(struct st_proto_s *new_proto)
>  		clear_bit(ST_REG_IN_PROGRESS, &st_gdata->st_state);
>  		st_recv = st_int_recv;
>
> -		/* this is where all pending registration
> +		/* this is where all pending registrations
>  		 * are signalled to be complete by calling callback functions
>  		 */
>  		if ((st_gdata->protos_registered != ST_EMPTY) &&
>  		    (test_bit(ST_REG_PENDING, &st_gdata->st_state))) {
> -			pr_debug(" call reg complete callback ");
> +			ti_st_dbg(TI_ST_DBG_CORE, " call reg complete callback ");
>  			st_reg_complete(st_gdata, 0);
>  		}
>  		clear_bit(ST_REG_PENDING, &st_gdata->st_state);
> @@ -580,7 +573,7 @@ long st_register(struct st_proto_s *new_proto)
>  		 * since the above check is old
>  		 */
>  		if (st_gdata->is_registered[new_proto->chnl_id] == true) {
> -			pr_err(" proto %d already registered ",
> +			ti_st_err(" proto %d already registered ",
>  				   new_proto->chnl_id);
>  			spin_unlock_irqrestore(&st_gdata->lock, flags);
>  			return -EALREADY;
> @@ -602,7 +595,6 @@ long st_register(struct st_proto_s *new_proto)
>  		spin_unlock_irqrestore(&st_gdata->lock, flags);
>  		return err;
>  	}
> -	pr_debug("done %s(%d) ", __func__, new_proto->chnl_id);
>  }
>  EXPORT_SYMBOL_GPL(st_register);
>
> @@ -615,18 +607,18 @@ long st_unregister(struct st_proto_s *proto)
>  	unsigned long flags = 0;
>  	struct st_data_s	*st_gdata;
>
> -	pr_debug("%s: %d ", __func__, proto->chnl_id);
> +	ti_st_dbg(TI_ST_DBG_CORE, "%s: %d ", __func__, proto->chnl_id);
>
>  	st_kim_ref(&st_gdata, 0);
> -	if (!st_gdata || proto->chnl_id >= ST_MAX_CHANNELS) {
> -		pr_err(" chnl_id %d not supported", proto->chnl_id);
> +	if (!st_gdata || !proto || proto->chnl_id >= ST_MAX_CHANNELS) {
> +		ti_st_err(" chnl_id %d not supported", proto->chnl_id);
>  		return -EPROTONOSUPPORT;
>  	}
>
>  	spin_lock_irqsave(&st_gdata->lock, flags);
>
>  	if (st_gdata->is_registered[proto->chnl_id] == false) {
> -		pr_err(" chnl_id %d not registered", proto->chnl_id);
> +		ti_st_err(" chnl_id %d not registered", proto->chnl_id);
>  		spin_unlock_irqrestore(&st_gdata->lock, flags);
>  		return -EPROTONOSUPPORT;
>  	}
> @@ -641,7 +633,7 @@ long st_unregister(struct st_proto_s *proto)
>
>  	if ((st_gdata->protos_registered == ST_EMPTY) &&
>  	    (!test_bit(ST_REG_PENDING, &st_gdata->st_state))) {
> -		pr_info(" all chnl_ids unregistered ");
> +		ti_st_dbg(TI_ST_DBG_CORE, " all chnl_ids unregistered ");
>
>  		/* stop traffic on tty */
>  		if (st_gdata->tty) {
> @@ -669,11 +661,11 @@ long st_write(struct sk_buff *skb)
>  	st_kim_ref(&st_gdata, 0);
>  	if (unlikely(skb == NULL || st_gdata == NULL
>  		|| st_gdata->tty == NULL)) {
> -		pr_err("data/tty unavailable to perform write");
> +		ti_st_err("data/tty unavailable to perform write");
>  		return -EINVAL;
>  	}
>
> -	pr_debug("%d to be written", skb->len);
> +	ti_st_dbg(TI_ST_DBG_CORE, "%d to be written", skb->len);
>  	len = skb->len;
>
>  	/* st_ll to decide where to enqueue the skb */
> @@ -696,7 +688,6 @@ static int st_tty_open(struct tty_struct *tty)
>  {
>  	int err = 0;
>  	struct st_data_s *st_gdata;
> -	pr_info("%s ", __func__);
>
>  	st_kim_ref(&st_gdata, 0);
>  	st_gdata->tty = tty;
> @@ -705,8 +696,7 @@ static int st_tty_open(struct tty_struct *tty)
>  	/* don't do an wakeup for now */
>  	clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
>
> -	/* mem already allocated
> -	 */
> +	/* mem already allocated */
>  	tty->receive_room = 65536;
>  	/* Flush any pending characters in the driver and discipline. */
>  	tty_ldisc_flush(tty);
> @@ -716,7 +706,6 @@ static int st_tty_open(struct tty_struct *tty)
>  	 * installation of N_TI_WL ldisc is complete
>  	 */
>  	st_kim_complete(st_gdata->kim_data);
> -	pr_debug("done %s", __func__);
>  	return err;
>  }
>
> @@ -726,8 +715,6 @@ static void st_tty_close(struct tty_struct *tty)
>  	unsigned long flags = 0;
>  	struct	st_data_s *st_gdata = tty->disc_data;
>
> -	pr_info("%s ", __func__);
> -
>  	/* TODO:
>  	 * if a protocol has been registered & line discipline
>  	 * un-installed for some reason - what should be done ?
> @@ -735,7 +722,7 @@ static void st_tty_close(struct tty_struct *tty)
>  	spin_lock_irqsave(&st_gdata->lock, flags);
>  	for (i = ST_BT; i < ST_MAX_CHANNELS; i++) {
>  		if (st_gdata->is_registered[i] == true)
> -			pr_err("%d not un-registered", i);
> +			ti_st_dbg(TI_ST_DBG_CORE, "%d not un-registered", i);
>  		st_gdata->list[i] = NULL;
>  		st_gdata->is_registered[i] = false;
>  	}
> @@ -761,8 +748,6 @@ static void st_tty_close(struct tty_struct *tty)
>  	kfree_skb(st_gdata->rx_skb);
>  	st_gdata->rx_skb = NULL;
>  	spin_unlock_irqrestore(&st_gdata->lock, flags);
> -
> -	pr_debug("%s: done ", __func__);
>  }
>
>  static void st_tty_receive(struct tty_struct *tty, const unsigned
char *data,
> @@ -778,7 +763,6 @@ static void st_tty_receive(struct tty_struct *tty,
const unsigned char *data,
>  	 * to KIM for validation
>  	 */
>  	st_recv(tty->disc_data, data, count);
> -	pr_debug("done %s", __func__);
>  }
>
>  /* wake-up function called in from the TTY layer
> @@ -787,7 +771,7 @@ static void st_tty_receive(struct tty_struct *tty,
const unsigned char *data,
>  static void st_tty_wakeup(struct tty_struct *tty)
>  {
>  	struct	st_data_s *st_gdata = tty->disc_data;
> -	pr_debug("%s ", __func__);
> +
>  	/* don't do an wakeup for now */
>  	clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
>
> @@ -798,7 +782,6 @@ static void st_tty_wakeup(struct tty_struct *tty)
>  static void st_tty_flush_buffer(struct tty_struct *tty)
>  {
>  	struct	st_data_s *st_gdata = tty->disc_data;
> -	pr_debug("%s ", __func__);
>
>  	kfree_skb(st_gdata->tx_skb);
>  	st_gdata->tx_skb = NULL;
> @@ -826,18 +809,18 @@ int st_core_init(struct st_data_s **core_data)
>
>  	err = tty_register_ldisc(N_TI_WL, &st_ldisc_ops);
>  	if (err) {
> -		pr_err("error registering %d line discipline %ld",
> -			   N_TI_WL, err);
> +		ti_st_err("error registering %d line discipline %ld",
> +					N_TI_WL, err);
>  		return err;
>  	}
> -	pr_debug("registered n_shared line discipline");
> +	ti_st_dbg(TI_ST_DBG_CORE, "registered n_shared line discipline");
>
>  	st_gdata = kzalloc(sizeof(struct st_data_s), GFP_KERNEL);
>  	if (!st_gdata) {
> -		pr_err("memory allocation failed");
> +		ti_st_err("memory allocation failed");
>  		err = tty_unregister_ldisc(N_TI_WL);
>  		if (err)
> -			pr_err("unable to un-register ldisc %ld", err);
> +			ti_st_err("unable to un-register ldisc %ld", err);
>  		err = -ENOMEM;
>  		return err;
>  	}
> @@ -853,11 +836,11 @@ int st_core_init(struct st_data_s **core_data)
>
>  	err = st_ll_init(st_gdata);
>  	if (err) {
> -		pr_err("error during st_ll initialization(%ld)", err);
> +		ti_st_err("error during st_ll initialization(%ld)", err);
>  		kfree(st_gdata);
>  		err = tty_unregister_ldisc(N_TI_WL);
>  		if (err)
> -			pr_err("unable to un-register ldisc");
> +			ti_st_err("unable to un-register ldisc");
>  		return err;
>  	}
>  	*core_data = st_gdata;
> @@ -870,7 +853,7 @@ void st_core_exit(struct st_data_s *st_gdata)
>  	/* internal module cleanup */
>  	err = st_ll_deinit(st_gdata);
>  	if (err)
> -		pr_err("error during deinit of ST LL %ld", err);
> +		ti_st_err("error during deinit of ST LL %ld", err);
>
>  	if (st_gdata != NULL) {
>  		/* Free ST Tx Qs and skbs */
> @@ -881,7 +864,7 @@ void st_core_exit(struct st_data_s *st_gdata)
>  		/* TTY ldisc cleanup */
>  		err = tty_unregister_ldisc(N_TI_WL);
>  		if (err)
> -			pr_err("unable to un-register ldisc %ld", err);
> +			ti_st_err("unable to un-register ldisc %ld", err);
>  		/* free the global data pointer */
>  		kfree(st_gdata);
>  	}
> diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
> index a7a861c..f6f6c30 100644
> --- a/drivers/misc/ti-st/st_kim.c
> +++ b/drivers/misc/ti-st/st_kim.c
> @@ -32,6 +32,7 @@
>  #include <linux/sched.h>
>  #include <linux/sysfs.h>
>  #include <linux/tty.h>
> +#include "debug.h"
>
>  #include <linux/skbuff.h>
>  #include <linux/ti_wilink_st.h>
> @@ -41,6 +42,10 @@
>  #define MAX_ST_DEVICES	3	/* Imagine 1 on each UART for now */
>  static struct platform_device *st_kim_devices[MAX_ST_DEVICES];
>
> +/* if CONFIG_TI_ST_DEBUG is defined, enable all logs by default */
> +unsigned short debug_mask = 0xffff;
> +module_param(debug_mask, ushort, 0644);
> +
>  /**********************************************************************/
>  /* internal functions */
>
> @@ -54,7 +59,9 @@ static struct platform_device
*st_kim_devices[MAX_ST_DEVICES];
>   */
>  static struct platform_device *st_get_plat_device(int id)
>  {
> -	return st_kim_devices[id];
> +	if (id < MAX_ST_DEVICES)
> +		return st_kim_devices[id];
> +	return NULL;
>  }
>
>  /**
> @@ -67,8 +74,8 @@ void validate_firmware_response(struct kim_data_s
*kim_gdata)
>  {
>  	struct sk_buff *skb = kim_gdata->rx_skb;
>  	if (unlikely(skb->data[5] != 0)) {
> -		pr_err("no proper response during fw download");
> -		pr_err("data6 %x", skb->data[5]);
> +		ti_st_err("no proper response during fw download");
> +		ti_st_err("response num: %x", skb->data[5]);
>  		kfree_skb(skb);
>  		return;		/* keep waiting for the proper response */
>  	}
> @@ -84,7 +91,7 @@ static inline int kim_check_data_len(struct
kim_data_s *kim_gdata, int len)
>  {
>  	register int room = skb_tailroom(kim_gdata->rx_skb);
>
> -	pr_debug("len %d room %d", len, room);
> +	ti_st_dbg(TI_ST_DBG_KIM, "%s: len %d room %d", __func__, len, room);
>
>  	if (!len) {
>  		validate_firmware_response(kim_gdata);
> @@ -92,8 +99,7 @@ static inline int kim_check_data_len(struct
kim_data_s *kim_gdata, int len)
>  		/* Received packet's payload length is larger.
>  		 * We can't accommodate it in created skb.
>  		 */
> -		pr_err("Data length is too large len %d room %d", len,
> -			   room);
> +		ti_st_err("Data length is too large len %d room %d", len, room);
>  		kfree_skb(kim_gdata->rx_skb);
>  	} else {
>  		/* Packet header has non-zero payload length and
> @@ -126,11 +132,10 @@ void kim_int_recv(struct kim_data_s *kim_gdata,
>  	int len = 0, type = 0;
>  	unsigned char *plen;
>
> -	pr_debug("%s", __func__);
>  	/* Decode received bytes here */
>  	ptr = data;
>  	if (unlikely(ptr == NULL)) {
> -		pr_err(" received null from TTY ");
> +		ti_st_err(" received null from TTY ");
>  		return;
>  	}
>
> @@ -149,7 +154,7 @@ void kim_int_recv(struct kim_data_s *kim_gdata,
>  			switch (kim_gdata->rx_state) {
>  				/* Waiting for complete packet ? */
>  			case ST_W4_DATA:
> -				pr_debug("Complete pkt received");
> +				ti_st_dbg(TI_ST_DBG_KIM, "Complete pkt received");
>  				validate_firmware_response(kim_gdata);
>  				kim_gdata->rx_state = ST_W4_PACKET_TYPE;
>  				kim_gdata->rx_skb = NULL;
> @@ -158,11 +163,11 @@ void kim_int_recv(struct kim_data_s *kim_gdata,
>  			case ST_W4_HEADER:
>  				plen =
>  				(unsigned char *)&kim_gdata->rx_skb->data[1];
> -				pr_debug("event hdr: plen 0x%02x\n", *plen);
> +				ti_st_dbg(TI_ST_DBG_KIM, "event hdr: plen 0x%02x\n", *plen);
>  				kim_check_data_len(kim_gdata, *plen);
>  				continue;
> -			}	/* end of switch */
> -		}		/* end of if rx_state */
> +			}
> +		}
>  		switch (*ptr) {
>  			/* Bluetooth event packet? */
>  		case 0x04:
> @@ -171,7 +176,7 @@ void kim_int_recv(struct kim_data_s *kim_gdata,
>  			type = *ptr;
>  			break;
>  		default:
> -			pr_info("unknown packet");
> +			ti_st_dbg(TI_ST_DBG_KIM, "%s: unknown packet", __func__);
>  			ptr++;
>  			count--;
>  			continue;
> @@ -181,7 +186,7 @@ void kim_int_recv(struct kim_data_s *kim_gdata,
>  		kim_gdata->rx_skb =
>  			alloc_skb(1024+8, GFP_ATOMIC);
>  		if (!kim_gdata->rx_skb) {
> -			pr_err("can't allocate mem for new packet");
> +			ti_st_err("can't allocate mem for new packet");
>  			kim_gdata->rx_state = ST_W4_PACKET_TYPE;
>  			kim_gdata->rx_count = 0;
>  			return;
> @@ -189,7 +194,6 @@ void kim_int_recv(struct kim_data_s *kim_gdata,
>  		skb_reserve(kim_gdata->rx_skb, 8);
>  		kim_gdata->rx_skb->cb[0] = 4;
>  		kim_gdata->rx_skb->cb[1] = 0;
> -
>  	}
>  	return;
>  }
> @@ -199,17 +203,15 @@ static long read_local_version(struct kim_data_s
*kim_gdata, char *bts_scr_name)
>  	unsigned short version = 0, chip = 0, min_ver = 0, maj_ver = 0;
>  	const char read_ver_cmd[] = { 0x01, 0x01, 0x10, 0x00 };
>
> -	pr_debug("%s", __func__);
> -
>  	INIT_COMPLETION(kim_gdata->kim_rcvd);
>  	if (4 != st_int_write(kim_gdata->core_data, read_ver_cmd, 4)) {
> -		pr_err("kim: couldn't write 4 bytes");
> +		ti_st_err("kim: couldn't write 4 bytes");
>  		return -EIO;
>  	}
>
>  	if (!wait_for_completion_timeout
>  	    (&kim_gdata->kim_rcvd, msecs_to_jiffies(CMD_RESP_TIME))) {
> -		pr_err(" waiting for ver info- timed out ");
> +		ti_st_err(" waiting for ver info - timed out ");
>  		return -ETIMEDOUT;
>  	}
>  	INIT_COMPLETION(kim_gdata->kim_rcvd);
> @@ -232,7 +234,8 @@ static long read_local_version(struct kim_data_s
*kim_gdata, char *bts_scr_name)
>  	kim_gdata->version.maj_ver = maj_ver;
>  	kim_gdata->version.min_ver = min_ver;
>
> -	pr_info("%s", bts_scr_name);
> +	ti_st_dbg(TI_ST_DBG_KIM, "local_version - %s", bts_scr_name);
> +
>  	return 0;
>  }
>
> @@ -245,14 +248,14 @@ void skip_change_remote_baud(unsigned char
**ptr, long *len)
>  		((struct bts_action *) cur_action)->size;
>
>  	if (((struct bts_action *) nxt_action)->type != ACTION_WAIT_EVENT) {
> -		pr_err("invalid action after change remote baud command");
> +		ti_st_err("invalid action after change remote baud command");
>  	} else {
>  		*ptr = *ptr + sizeof(struct bts_action) +
>  			((struct bts_action *)cur_action)->size;
>  		*len = *len - (sizeof(struct bts_action) +
>  				((struct bts_action *)cur_action)->size);
>  		/* warn user on not commenting these in firmware */
> -		pr_warn("skipping the wait event of change remote baud");
> +		ti_st_warn("skipping the wait event of change remote baud");
>  	}
>  }
>
> @@ -274,7 +277,7 @@ static long download_firmware(struct kim_data_s
*kim_gdata)
>
>  	err = read_local_version(kim_gdata, bts_scr_name);
>  	if (err != 0) {
> -		pr_err("kim: failed to read local ver");
> +		ti_st_err("kim: failed to read local ver");
>  		return err;
>  	}
>  	err =
> @@ -282,10 +285,11 @@ static long download_firmware(struct kim_data_s
*kim_gdata)
>  			     &kim_gdata->kim_pdev->dev);
>  	if (unlikely((err != 0) || (kim_gdata->fw_entry->data == NULL) ||
>  		     (kim_gdata->fw_entry->size == 0))) {
> -		pr_err(" request_firmware failed(errno %ld) for %s", err,
> -			   bts_scr_name);
> +		ti_st_err(" request_firmware failed(errno %ld) for %s", err,
> +			      bts_scr_name);
>  		return -EINVAL;
>  	}
> +
>  	ptr = (void *)kim_gdata->fw_entry->data;
>  	len = kim_gdata->fw_entry->size;
>  	/* bts_header to remove out magic number and
> @@ -295,21 +299,21 @@ static long download_firmware(struct kim_data_s
*kim_gdata)
>  	len -= sizeof(struct bts_header);
>
>  	while (len > 0 && ptr) {
> -		pr_debug(" action size %d, type %d ",
> -			   ((struct bts_action *)ptr)->size,
> -			   ((struct bts_action *)ptr)->type);
> +		ti_st_dbg(TI_ST_DBG_KIM, " action size %d, type %d ",
> +					((struct bts_action *)ptr)->size,
> +					((struct bts_action *)ptr)->type);
>
>  		switch (((struct bts_action *)ptr)->type) {
>  		case ACTION_SEND_COMMAND:	/* action send */
> -			pr_debug("S");
> +			ti_st_dbg(TI_ST_DBG_KIM, "%s: send command", __func__);
>  			action_ptr = &(((struct bts_action *)ptr)->data[0]);
>  			if (unlikely
>  			    (((struct hci_command *)action_ptr)->opcode ==
>  			     0xFF36)) {
>  				/* ignore remote change
>  				 * baud rate HCI VS command */
> -				pr_warn("change remote baud"
> -				    " rate command in firmware");
> +				ti_st_warn("change remote baud rate command"
> +						" in firmware");
>  				skip_change_remote_baud(&ptr, &len);
>  				break;
>  			}
> @@ -323,8 +327,8 @@ static long download_firmware(struct kim_data_s
*kim_gdata)
>  				wr_room_space =
>  					st_get_uart_wr_room(kim_gdata->core_data);
>  				if (wr_room_space < 0) {
> -					pr_err("Unable to get free "
> -							"space info from uart tx buffer");
> +					ti_st_err("Unable to get free space "
> +						"info from uart tx buffer");
>  					release_firmware(kim_gdata->fw_entry);
>  					return wr_room_space;
>  				}
> @@ -334,7 +338,7 @@ static long download_firmware(struct kim_data_s
*kim_gdata)
>
>  			/* Timeout happened ? */
>  			if (time_after_eq(jiffies, timeout)) {
> -				pr_err("Timeout while waiting for free "
> +				ti_st_err("Timeout while waiting for free "
>  						"free space in uart tx buffer");
>  				release_firmware(kim_gdata->fw_entry);
>  				return -ETIMEDOUT;
> @@ -361,19 +365,19 @@ static long download_firmware(struct kim_data_s
*kim_gdata)
>  			 * and requested command write size
>  			 */
>  			if (err != cmd_size) {
> -				pr_err("Number of bytes written to uart "
> -						"tx buffer are not matching with "
> +				ti_st_err("Number of bytes written to uart tx "
> +						"buffer are not matching with "
>  						"requested cmd write size");
>  				release_firmware(kim_gdata->fw_entry);
>  				return -EIO;
>  			}
>  			break;
>  		case ACTION_WAIT_EVENT:  /* wait */
> -			pr_debug("W");
> +			ti_st_dbg(TI_ST_DBG_KIM, "%s: wait event", __func__);
>  			if (!wait_for_completion_timeout
>  					(&kim_gdata->kim_rcvd,
>  					 msecs_to_jiffies(CMD_RESP_TIME))) {
> -				pr_err("response timeout during fw download ");
> +				ti_st_err("response timeout during fw download");
>  				/* timed out */
>  				release_firmware(kim_gdata->fw_entry);
>  				return -ETIMEDOUT;
> @@ -381,7 +385,7 @@ static long download_firmware(struct kim_data_s
*kim_gdata)
>  			INIT_COMPLETION(kim_gdata->kim_rcvd);
>  			break;
>  		case ACTION_DELAY:	/* sleep */
> -			pr_info("sleep command in scr");
> +			ti_st_dbg(TI_ST_DBG_KIM, "%s: sleep command", __func__);
>  			action_ptr = &(((struct bts_action *)ptr)->data[0]);
>  			mdelay(((struct bts_action_delay *)action_ptr)->msec);
>  			break;
> @@ -395,6 +399,7 @@ static long download_firmware(struct kim_data_s
*kim_gdata)
>  	}
>  	/* fw download complete */
>  	release_firmware(kim_gdata->fw_entry);
> +	ti_st_dbg(TI_ST_DBG_KIM, "firmware dld compleated");
>  	return 0;
>  }
>
> @@ -446,7 +451,6 @@ long st_kim_start(void *kim_data)
>  	struct ti_st_plat_data	*pdata;
>  	struct kim_data_s	*kim_gdata = (struct kim_data_s *)kim_data;
>
> -	pr_info(" %s", __func__);
>  	pdata = kim_gdata->kim_pdev->dev.platform_data;
>
>  	do {
> @@ -463,7 +467,6 @@ long st_kim_start(void *kim_data)
>  		INIT_COMPLETION(kim_gdata->ldisc_installed);
>  		/* send notification to UIM */
>  		kim_gdata->ldisc_install = 1;
> -		pr_info("ldisc_install = 1");
>  		sysfs_notify(&kim_gdata->kim_pdev->dev.kobj,
>  				NULL, "install");
>  		/* wait for ldisc to be installed */
> @@ -472,17 +475,17 @@ long st_kim_start(void *kim_data)
>  		if (!err) {
>  			/* ldisc installation timeout,
>  			 * flush uart, power cycle BT_EN */
> -			pr_err("ldisc installation timeout");
> +			ti_st_err("ldisc installation timeout");
>  			err = st_kim_stop(kim_gdata);
>  			continue;
>  		} else {
>  			/* ldisc installed now */
> -			pr_info("line discipline installed");
> +			ti_st_dbg(TI_ST_DBG_KIM, "line discipline installed");
>  			err = download_firmware(kim_gdata);
>  			if (err != 0) {
>  				/* ldisc installed but fw download failed,
>  				 * flush uart & power cycle BT_EN */
> -				pr_err("download firmware failed");
> +				ti_st_err("download firmware failed");
>  				err = st_kim_stop(kim_gdata);
>  				continue;
>  			} else {	/* on success don't retry */
> @@ -521,7 +524,6 @@ long st_kim_stop(void *kim_data)
>  	}
>
>  	/* send uninstall notification to UIM */
> -	pr_info("ldisc_install = 0");
>  	kim_gdata->ldisc_install = 0;
>  	sysfs_notify(&kim_gdata->kim_pdev->dev.kobj, NULL, "install");
>
> @@ -529,7 +531,7 @@ long st_kim_stop(void *kim_data)
>  	err = wait_for_completion_timeout(&kim_gdata->ldisc_installed,
>  			msecs_to_jiffies(LDISC_TIME));
>  	if (!err) {		/* timeout */
> -		pr_err(" timed out waiting for ldisc to be un-installed");
> +		ti_st_err("timed out waiting for ldisc to be un-installed");
>  		return -ETIMEDOUT;
>  	}
>
> @@ -578,9 +580,9 @@ static ssize_t store_dev_name(struct device *dev,
>  		struct device_attribute *attr, const char *buf, size_t count)
>  {
>  	struct kim_data_s *kim_data = dev_get_drvdata(dev);
> -	pr_debug("storing dev name >%s<", buf);
> +	ti_st_dbg(TI_ST_DBG_KIM, "storing dev name >%s<", buf);
>  	strncpy(kim_data->dev_name, buf, count);
> -	pr_debug("stored dev name >%s<", kim_data->dev_name);
> +	ti_st_dbg(TI_ST_DBG_KIM, "stored dev name >%s<", kim_data->dev_name);
>  	return count;
>  }
>
> @@ -588,9 +590,9 @@ static ssize_t store_baud_rate(struct device *dev,
>  		struct device_attribute *attr, const char *buf, size_t count)
>  {
>  	struct kim_data_s *kim_data = dev_get_drvdata(dev);
> -	pr_debug("storing baud rate >%s<", buf);
> +	ti_st_dbg(TI_ST_DBG_KIM, "storing baud rate >%s<", buf);
>  	sscanf(buf, "%ld", &kim_data->baud_rate);
> -	pr_debug("stored baud rate >%ld<", kim_data->baud_rate);
> +	ti_st_dbg(TI_ST_DBG_KIM, "stored baud rate >%ld<", kim_data->baud_rate);
>  	return count;
>  }
>  #endif	/* if DEBUG */
> @@ -718,14 +720,14 @@ static int kim_probe(struct platform_device *pdev)
>
>  	kim_gdata = kzalloc(sizeof(struct kim_data_s), GFP_ATOMIC);
>  	if (!kim_gdata) {
> -		pr_err("no mem to allocate");
> +		ti_st_err("no mem to allocate");
>  		return -ENOMEM;
>  	}
>  	dev_set_drvdata(&pdev->dev, kim_gdata);
>
>  	status = st_core_init(&kim_gdata->core_data);
>  	if (status != 0) {
> -		pr_err(" ST core init failed");
> +		ti_st_err(" ST core init failed");
>  		return -EIO;
>  	}
>  	/* refer to itself */
> @@ -735,14 +737,14 @@ static int kim_probe(struct platform_device *pdev)
>  	kim_gdata->nshutdown = pdata->nshutdown_gpio;
>  	status = gpio_request(kim_gdata->nshutdown, "kim");
>  	if (unlikely(status)) {
> -		pr_err(" gpio %ld request failed ", kim_gdata->nshutdown);
> +		ti_st_err(" gpio %ld request failed ", kim_gdata->nshutdown);
>  		return status;
>  	}
>
>  	/* Configure nShutdown GPIO as output=0 */
>  	status = gpio_direction_output(kim_gdata->nshutdown, 0);
>  	if (unlikely(status)) {
> -		pr_err(" unable to configure gpio %ld", kim_gdata->nshutdown);
> +		ti_st_err("unable to configure gpio %ld", kim_gdata->nshutdown);
>  		return status;
>  	}
>  	/* get reference of pdev for request_firmware
> @@ -753,7 +755,7 @@ static int kim_probe(struct platform_device *pdev)
>
>  	status = sysfs_create_group(&pdev->dev.kobj, &uim_attr_grp);
>  	if (status) {
> -		pr_err("failed to create sysfs entries");
> +		ti_st_err("failed to create sysfs entries");
>  		return status;
>  	}
>
> @@ -761,20 +763,20 @@ static int kim_probe(struct platform_device *pdev)
>  	strncpy(kim_gdata->dev_name, pdata->dev_name, UART_DEV_NAME_LEN);
>  	kim_gdata->flow_cntrl = pdata->flow_cntrl;
>  	kim_gdata->baud_rate = pdata->baud_rate;
> -	pr_info("sysfs entries created\n");
> +	ti_st_dbg(TI_ST_DBG_KIM, "sysfs entries created\n");
>
>  	kim_debugfs_dir = debugfs_create_dir("ti-st", NULL);
>  	if (IS_ERR(kim_debugfs_dir)) {
> -		pr_err(" debugfs entries creation failed ");
> +		ti_st_err(" debugfs entries creation failed ");
>  		kim_debugfs_dir = NULL;
>  		return -EIO;
>  	}
>
>  	debugfs_create_file("version", S_IRUGO, kim_debugfs_dir,
> -				kim_gdata, &version_debugfs_fops);
> +						kim_gdata, &version_debugfs_fops);
>  	debugfs_create_file("protocols", S_IRUGO, kim_debugfs_dir,
> -				kim_gdata, &list_debugfs_fops);
> -	pr_info(" debugfs entries created ");
> +						kim_gdata, &list_debugfs_fops);
> +	ti_st_dbg(TI_ST_DBG_KIM, " debugfs entries created ");
>  	return 0;
>  }
>
> @@ -790,11 +792,11 @@ static int kim_remove(struct platform_device *pdev)
>  	 * nShutdown gpio from the system
>  	 */
>  	gpio_free(pdata->nshutdown_gpio);
> -	pr_info("nshutdown GPIO Freed");
> +	ti_st_dbg(TI_ST_DBG_KIM, "nshutdown GPIO Freed");
>
>  	debugfs_remove_recursive(kim_debugfs_dir);
>  	sysfs_remove_group(&pdev->dev.kobj, &uim_attr_grp);
> -	pr_info("sysfs entries removed");
> +	ti_st_dbg(TI_ST_DBG_KIM, "sysfs entries removed");
>
>  	kim_gdata->kim_pdev = NULL;
>  	st_core_exit(kim_gdata->core_data);
> diff --git a/drivers/misc/ti-st/st_ll.c b/drivers/misc/ti-st/st_ll.c
> index 1ff460a..ccdad8b 100644
> --- a/drivers/misc/ti-st/st_ll.c
> +++ b/drivers/misc/ti-st/st_ll.c
> @@ -24,6 +24,7 @@
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
>  #include <linux/ti_wilink_st.h>
> +#include "debug.h"
>
>  /**********************************************************************/
>  /* internal functions */
> @@ -31,7 +32,7 @@ static void send_ll_cmd(struct st_data_s *st_data,
>  	unsigned char cmd)
>  {
>
> -	pr_debug("%s: writing %x", __func__, cmd);
> +	ti_st_dbg(TI_ST_DBG_HCI_LL, "%s: writing %x", __func__, cmd);
>  	st_int_write(st_data, &cmd, 1);
>  	return;
>  }
> @@ -41,11 +42,11 @@ static void ll_device_want_to_sleep(struct
st_data_s *st_data)
>  	struct kim_data_s	*kim_data;
>  	struct ti_st_plat_data	*pdata;
>
> -	pr_debug("%s", __func__);
> +	ti_st_dbg(TI_ST_DBG_HCI_LL, "%s", __func__);
>  	/* sanity check */
>  	if (st_data->ll_state != ST_LL_AWAKE)
> -		pr_err("ERR hcill: ST_LL_GO_TO_SLEEP_IND"
> -			  "in state %ld", st_data->ll_state);
> +		ti_st_err("ERR hcill: ST_LL_GO_TO_SLEEP_IND"
> +					"in state %ld", st_data->ll_state);
>
>  	send_ll_cmd(st_data, LL_SLEEP_ACK);
>  	/* update state */
> @@ -70,15 +71,15 @@ static void ll_device_want_to_wakeup(struct
st_data_s *st_data)
>  		break;
>  	case ST_LL_ASLEEP_TO_AWAKE:
>  		/* duplicate wake_ind */
> -		pr_err("duplicate wake_ind while waiting for Wake ack");
> +		ti_st_err("duplicate wake_ind while waiting for Wake ack");
>  		break;
>  	case ST_LL_AWAKE:
>  		/* duplicate wake_ind */
> -		pr_err("duplicate wake_ind already AWAKE");
> +		ti_st_err("duplicate wake_ind already AWAKE");
>  		break;
>  	case ST_LL_AWAKE_TO_ASLEEP:
>  		/* duplicate wake_ind */
> -		pr_err("duplicate wake_ind");
> +		ti_st_err("duplicate wake_ind");
>  		break;
>  	}
>  	/* update state */
> @@ -116,14 +117,13 @@ void st_ll_wakeup(struct st_data_s *ll)
>  		ll->ll_state = ST_LL_ASLEEP_TO_AWAKE;
>  	} else {
>  		/* don't send the duplicate wake_indication */
> -		pr_err(" Chip already AWAKE ");
> +		ti_st_err(" Chip already AWAKE ");
>  	}
>  }
>
>  /* called when ST Core wants the state */
>  unsigned long st_ll_getstate(struct st_data_s *ll)
>  {
> -	pr_debug(" returning state %ld", ll->ll_state);
>  	return ll->ll_state;
>  }
>
> @@ -133,22 +133,22 @@ unsigned long st_ll_sleep_state(struct st_data_s
*st_data,
>  {
>  	switch (cmd) {
>  	case LL_SLEEP_IND:	/* sleep ind */
> -		pr_debug("sleep indication recvd");
> +		ti_st_dbg(TI_ST_DBG_HCI_LL, "sleep indication recvd");
>  		ll_device_want_to_sleep(st_data);
>  		break;
>  	case LL_SLEEP_ACK:	/* sleep ack */
> -		pr_err("sleep ack rcvd: host shouldn't");
> +		ti_st_err("sleep ack rcvd: host shouldn't");
>  		break;
>  	case LL_WAKE_UP_IND:	/* wake ind */
> -		pr_debug("wake indication recvd");
> +		ti_st_dbg(TI_ST_DBG_HCI_LL, "wake indication recvd");
>  		ll_device_want_to_wakeup(st_data);
>  		break;
>  	case LL_WAKE_UP_ACK:	/* wake ack */
> -		pr_debug("wake ack rcvd");
> +		ti_st_dbg(TI_ST_DBG_HCI_LL, "wake ack rcvd");
>  		st_data->ll_state = ST_LL_AWAKE;
>  		break;
>  	default:
> -		pr_err(" unknown input/state ");
> +		ti_st_err(" unknown input/state ");
>  		return -EINVAL;
>  	}
>  	return 0;

