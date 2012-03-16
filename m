Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab2CPVON (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 17:14:13 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56027 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab2CPVOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 17:14:07 -0400
Message-ID: <4F63AD19.6060203@gmail.com>
Date: Fri, 16 Mar 2012 22:14:01 +0100
From: Mircea Gherzan <mgherzan@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: alexandrasava18@gmail.com
CC: gregkh@linuxfoundation.org, pavan_savoy@ti.com, daniel.baluta@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] Enhance logging for Shared Transport - TI driver
References: <y> <9ea802684dee3b531a19f93424c77e22a955dd54.1331920050.git.alexandrasava18@gmail.com>
In-Reply-To: <9ea802684dee3b531a19f93424c77e22a955dd54.1331920050.git.alexandrasava18@gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.03.2012 18:58, schrieb alexandrasava18@gmail.com:
> From: Alexandra Sava <alexandrasava18@gmail.com>
> 
> * reduced verbosity
> * replaced pr_* with dev_* where possible
> * fixed yoda conditions
> 
> Signed-off-by: Alexandra Sava <alexandrasava18@gmail.com>
> Cc: Daniel Baluta <daniel.baluta@gmail.com>
> Cc: Mircea Gherzan <mgherzan@gmail.com>
> ---
> Changes since v1:
> * removed debug_mask module parameter

IMHO a debug mask or even just a debug switch is still needed.

> * removed custome logging functions

This is actually worse than the first iteration:
* no consistent prefix
* quite the same verbosity and no control over it.

Here's what I get now when loading btwilink:

[   30.473663] kim kim: sysfs entries created
[   30.478698] kim kim: debugfs entries created
[   30.491149] Bluetooth: Bluetooth Driver for TI WiLink - Version 1.0
[   30.508636] chnl_id list empty :4
[   30.677947] kim kim: Line discipline installed
[   31.621459] kim kim: Loaded TIInit_7.2.31.bts firmware
[   31.621459] Add new channel: id - 4
[   31.631134] Add new channel: id - 2
[   31.633911] Add new channel: id - 3
[   31.641052] chip/interface misbehavior dropping frame starting with 0x01
[   41.636505] Remove channel: id - 3
[   41.636505] Remove channel: id - 2
[   41.643951] Remove channel: id - 4
[   41.652465] chnl_id list empty :4
[   41.817138] kim kim: Line discipline installed
[   42.735137] kim kim: Loaded TIInit_7.2.31.bts firmware
[   42.740783] Add new channel: id - 4
[   42.744842] Add new channel: id - 2
[   42.748657] Add new channel: id - 3
[   42.753204] chip/interface misbehavior dropping frame starting with 0x01
[   52.776763] Remove channel: id - 3
[   52.780853] Remove channel: id - 2
[   52.782409] Remove channel: id - 4

And I would like too see only something like this:

[   30.491149] Bluetooth: Bluetooth Driver for TI WiLink - Version 1.0
[   30.677947] st_drv: Line discipline installed
[   31.621459] st_drv: Loaded TIInit_7.2.31.bts firmware


>  drivers/misc/ti-st/st_core.c |   91 +++++++++++----------------------------
>  drivers/misc/ti-st/st_kim.c  |   98 +++++++++++++++++-------------------------
>  drivers/misc/ti-st/st_ll.c   |   17 +++-----
>  3 files changed, 70 insertions(+), 136 deletions(-)
> 
> diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
> index 2b62232..9a0e070 100644
> --- a/drivers/misc/ti-st/st_core.c
> +++ b/drivers/misc/ti-st/st_core.c
> @@ -19,7 +19,6 @@
>   *
>   */
>  
> -#define pr_fmt(fmt)	"(stc): " fmt
>  #include <linux/module.h>
>  #include <linux/kernel.h>
>  #include <linux/init.h>
> @@ -40,7 +39,7 @@ void (*st_recv) (void*, const unsigned char*, long);
>  static void add_channel_to_table(struct st_data_s *st_gdata,
>  		struct st_proto_s *new_proto)
>  {
> -	pr_info("%s: id %d\n", __func__, new_proto->chnl_id);
> +	pr_info("Add new channel: id - %d\n", new_proto->chnl_id);
>  	/* list now has the channel id as index itself */
>  	st_gdata->list[new_proto->chnl_id] = new_proto;
>  	st_gdata->is_registered[new_proto->chnl_id] = true;
> @@ -49,7 +48,7 @@ static void add_channel_to_table(struct st_data_s *st_gdata,
>  static void remove_channel_from_table(struct st_data_s *st_gdata,
>  		struct st_proto_s *proto)
>  {
> -	pr_info("%s: id %d\n", __func__, proto->chnl_id);
> +	pr_info("Remove channel: id - %d\n", proto->chnl_id);
>  /*	st_gdata->list[proto->chnl_id] = NULL; */
>  	st_gdata->is_registered[proto->chnl_id] = false;
>  }
> @@ -102,8 +101,6 @@ int st_int_write(struct st_data_s *st_gdata,
>   */
>  void st_send_frame(unsigned char chnl_id, struct st_data_s *st_gdata)
>  {
> -	pr_debug(" %s(prot:%d) ", __func__, chnl_id);
> -
>  	if (unlikely
>  	    (st_gdata == NULL || st_gdata->rx_skb == NULL
>  	     || st_gdata->is_registered[chnl_id] == false)) {
> @@ -122,12 +119,12 @@ void st_send_frame(unsigned char chnl_id, struct st_data_s *st_gdata)
>  			(st_gdata->list[chnl_id]->recv
>  			(st_gdata->list[chnl_id]->priv_data, st_gdata->rx_skb)
>  			     != 0)) {
> -			pr_err(" proto stack %d's ->recv failed", chnl_id);
> +			pr_err("proto stack %d's ->recv failed", chnl_id);
>  			kfree_skb(st_gdata->rx_skb);
>  			return;
>  		}
>  	} else {
> -		pr_err(" proto stack %d's ->recv null", chnl_id);
> +		pr_err("proto stack %d's ->recv null", chnl_id);
>  		kfree_skb(st_gdata->rx_skb);
>  	}
>  	return;
> @@ -143,14 +140,13 @@ void st_send_frame(unsigned char chnl_id, struct st_data_s *st_gdata)
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
>  			if (err) { /* cleanup registered protocol */
>  				st_gdata->protos_registered--;
>  				st_gdata->is_registered[i] = false;
> @@ -164,8 +160,6 @@ static inline int st_check_data_len(struct st_data_s *st_gdata,
>  {
>  	int room = skb_tailroom(st_gdata->rx_skb);
>  
> -	pr_debug("len %d room %d", len, room);
> -
>  	if (!len) {
>  		/* Received packet has only packet header and
>  		 * has zero length payload. So, ask ST CORE to
> @@ -177,7 +171,7 @@ static inline int st_check_data_len(struct st_data_s *st_gdata,
>  		/* Received packet's payload length is larger.
>  		 * We can't accommodate it in created skb.
>  		 */
> -		pr_err("Data length is too large len %d room %d", len,
> +		pr_err("Data length is too large: len - %d room - %d", len,
>  			   room);
>  		kfree_skb(st_gdata->rx_skb);
>  	} else {
> @@ -246,14 +240,10 @@ void st_int_recv(void *disc_data,
>  	ptr = (char *)data;
>  	/* tty_receive sent null ? */
>  	if (unlikely(ptr == NULL) || (st_gdata == NULL)) {
> -		pr_err(" received null from TTY ");
> +		pr_err("Received null from TTY");
>  		return;
>  	}
>  
> -	pr_debug("count %ld rx_state %ld"
> -		   "rx_count %ld", count, st_gdata->rx_state,
> -		   st_gdata->rx_count);
> -
>  	spin_lock_irqsave(&st_gdata->lock, flags);
>  	/* Decode received bytes here */
>  	while (count) {
> @@ -285,22 +275,16 @@ void st_int_recv(void *disc_data,
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
>  				st_check_data_len(st_gdata, proto->chnl_id,
>  						payload_len);
> -				pr_debug("off %d, pay len %d\n",
> -					proto->offset_len_in_hdr, payload_len);
>  				continue;
> -			}	/* end of switch rx_state */
> +			}
>  		}
>  
>  		/* end of if rx_count */
> @@ -310,7 +294,6 @@ void st_int_recv(void *disc_data,
>  		case LL_SLEEP_IND:
>  		case LL_SLEEP_ACK:
>  		case LL_WAKE_UP_IND:
> -			pr_debug("PM packet");
>  			/* this takes appropriate action based on
>  			 * sleep state received --
>  			 */
> @@ -327,8 +310,6 @@ void st_int_recv(void *disc_data,
>  			count--;
>  			continue;
>  		case LL_WAKE_UP_ACK:
> -			pr_debug("PM packet");
> -
>  			spin_unlock_irqrestore(&st_gdata->lock, flags);
>  			/* wake up ack received */
>  			st_wakeup_ack(st_gdata, *ptr);
> @@ -344,7 +325,6 @@ void st_int_recv(void *disc_data,
>  				pr_err("chip/interface misbehavior dropping"
>  					" frame starting with 0x%02x", type);
>  				goto done;
> -
>  			}
>  			st_gdata->rx_skb = alloc_skb(
>  					st_gdata->list[type]->max_frame_size,
> @@ -352,19 +332,17 @@ void st_int_recv(void *disc_data,
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
> @@ -378,7 +356,6 @@ struct sk_buff *st_int_dequeue(struct st_data_s *st_gdata)
>  {
>  	struct sk_buff *returning_skb;
>  
> -	pr_debug("%s", __func__);
>  	if (st_gdata->tx_skb != NULL) {
>  		returning_skb = st_gdata->tx_skb;
>  		st_gdata->tx_skb = NULL;
> @@ -400,7 +377,6 @@ void st_int_enqueue(struct st_data_s *st_gdata, struct sk_buff *skb)
>  {
>  	unsigned long flags = 0;
>  
> -	pr_debug("%s", __func__);
>  	spin_lock_irqsave(&st_gdata->lock, flags);
>  
>  	switch (st_ll_getstate(st_gdata)) {
> @@ -428,7 +404,6 @@ void st_int_enqueue(struct st_data_s *st_gdata, struct sk_buff *skb)
>  	}
>  
>  	spin_unlock_irqrestore(&st_gdata->lock, flags);
> -	pr_debug("done %s", __func__);
>  	return;
>  }
>  
> @@ -442,10 +417,9 @@ void st_tx_wakeup(struct st_data_s *st_data)
>  {
>  	struct sk_buff *skb;
>  	unsigned long flags;	/* for irq save flags */
> -	pr_debug("%s", __func__);
> +
>  	/* check for sending & set flag sending here */
>  	if (test_and_set_bit(ST_TX_SENDING, &st_data->tx_state)) {
> -		pr_debug("ST already sending");
>  		/* keep sending */
>  		set_bit(ST_TX_WAKEUP, &st_data->tx_state);
>  		return;
> @@ -504,7 +478,6 @@ long st_register(struct st_proto_s *new_proto)
>  	unsigned long flags = 0;
>  
>  	st_kim_ref(&st_gdata, 0);
> -	pr_info("%s(%d) ", __func__, new_proto->chnl_id);
>  	if (st_gdata == NULL || new_proto == NULL || new_proto->recv == NULL
>  	    || new_proto->reg_complete_cb == NULL) {
>  		pr_err("gdata/new_proto/recv or reg_complete_cb not ready");
> @@ -525,7 +498,7 @@ long st_register(struct st_proto_s *new_proto)
>  	spin_lock_irqsave(&st_gdata->lock, flags);
>  
>  	if (test_bit(ST_REG_IN_PROGRESS, &st_gdata->st_state)) {
> -		pr_info(" ST_REG_IN_PROGRESS:%d ", new_proto->chnl_id);
> +		pr_info("ST_REG_IN_PROGRESS:%d", new_proto->chnl_id);
>  		/* fw download in progress */
>  
>  		add_channel_to_table(st_gdata, new_proto);
> @@ -536,7 +509,7 @@ long st_register(struct st_proto_s *new_proto)
>  		spin_unlock_irqrestore(&st_gdata->lock, flags);
>  		return -EINPROGRESS;
>  	} else if (st_gdata->protos_registered == ST_EMPTY) {
> -		pr_info(" chnl_id list empty :%d ", new_proto->chnl_id);
> +		pr_info("chnl_id list empty :%d", new_proto->chnl_id);
>  		set_bit(ST_REG_IN_PROGRESS, &st_gdata->st_state);
>  		st_recv = st_kim_recv;
>  
> @@ -554,7 +527,7 @@ long st_register(struct st_proto_s *new_proto)
>  			clear_bit(ST_REG_IN_PROGRESS, &st_gdata->st_state);
>  			if ((st_gdata->protos_registered != ST_EMPTY) &&
>  			    (test_bit(ST_REG_PENDING, &st_gdata->st_state))) {
> -				pr_err(" KIM failure complete callback ");
> +				pr_err("KIM failure complete callback");
>  				st_reg_complete(st_gdata, err);
>  				clear_bit(ST_REG_PENDING, &st_gdata->st_state);
>  			}
> @@ -571,7 +544,6 @@ long st_register(struct st_proto_s *new_proto)
>  		 */
>  		if ((st_gdata->protos_registered != ST_EMPTY) &&
>  		    (test_bit(ST_REG_PENDING, &st_gdata->st_state))) {
> -			pr_debug(" call reg complete callback ");
>  			st_reg_complete(st_gdata, 0);
>  		}
>  		clear_bit(ST_REG_PENDING, &st_gdata->st_state);
> @@ -580,7 +552,7 @@ long st_register(struct st_proto_s *new_proto)
>  		 * since the above check is old
>  		 */
>  		if (st_gdata->is_registered[new_proto->chnl_id] == true) {
> -			pr_err(" proto %d already registered ",
> +			pr_err("proto %d already registered",
>  				   new_proto->chnl_id);
>  			spin_unlock_irqrestore(&st_gdata->lock, flags);
>  			return -EALREADY;
> @@ -602,7 +574,6 @@ long st_register(struct st_proto_s *new_proto)
>  		spin_unlock_irqrestore(&st_gdata->lock, flags);
>  		return err;
>  	}
> -	pr_debug("done %s(%d) ", __func__, new_proto->chnl_id);
>  }
>  EXPORT_SYMBOL_GPL(st_register);
>  
> @@ -615,18 +586,18 @@ long st_unregister(struct st_proto_s *proto)
>  	unsigned long flags = 0;
>  	struct st_data_s	*st_gdata;
>  
> -	pr_debug("%s: %d ", __func__, proto->chnl_id);
> +	pr_debug("Unregister protocol: chnl %d ", proto->chnl_id);
>  
>  	st_kim_ref(&st_gdata, 0);
>  	if (!st_gdata || proto->chnl_id >= ST_MAX_CHANNELS) {
> -		pr_err(" chnl_id %d not supported", proto->chnl_id);
> +		pr_err("chnl_id %d not supported", proto->chnl_id);
>  		return -EPROTONOSUPPORT;
>  	}
>  
>  	spin_lock_irqsave(&st_gdata->lock, flags);
>  
>  	if (st_gdata->is_registered[proto->chnl_id] == false) {
> -		pr_err(" chnl_id %d not registered", proto->chnl_id);
> +		pr_err("chnl_id %d not registered", proto->chnl_id);
>  		spin_unlock_irqrestore(&st_gdata->lock, flags);
>  		return -EPROTONOSUPPORT;
>  	}
> @@ -641,8 +612,6 @@ long st_unregister(struct st_proto_s *proto)
>  
>  	if ((st_gdata->protos_registered == ST_EMPTY) &&
>  	    (!test_bit(ST_REG_PENDING, &st_gdata->st_state))) {
> -		pr_info(" all chnl_ids unregistered ");
> -
>  		/* stop traffic on tty */
>  		if (st_gdata->tty) {
>  			tty_ldisc_flush(st_gdata->tty);
> @@ -673,7 +642,6 @@ long st_write(struct sk_buff *skb)
>  		return -EINVAL;
>  	}
>  
> -	pr_debug("%d to be written", skb->len);
>  	len = skb->len;
>  
>  	/* st_ll to decide where to enqueue the skb */
> @@ -696,7 +664,6 @@ static int st_tty_open(struct tty_struct *tty)
>  {
>  	int err = 0;
>  	struct st_data_s *st_gdata;
> -	pr_info("%s ", __func__);
>  
>  	st_kim_ref(&st_gdata, 0);
>  	st_gdata->tty = tty;
> @@ -716,7 +683,6 @@ static int st_tty_open(struct tty_struct *tty)
>  	 * installation of N_TI_WL ldisc is complete
>  	 */
>  	st_kim_complete(st_gdata->kim_data);
> -	pr_debug("done %s", __func__);
>  	return err;
>  }
>  
> @@ -726,8 +692,6 @@ static void st_tty_close(struct tty_struct *tty)
>  	unsigned long flags = 0;
>  	struct	st_data_s *st_gdata = tty->disc_data;
>  
> -	pr_info("%s ", __func__);
> -
>  	/* TODO:
>  	 * if a protocol has been registered & line discipline
>  	 * un-installed for some reason - what should be done ?
> @@ -762,7 +726,6 @@ static void st_tty_close(struct tty_struct *tty)
>  	st_gdata->rx_skb = NULL;
>  	spin_unlock_irqrestore(&st_gdata->lock, flags);
>  
> -	pr_debug("%s: done ", __func__);
>  }
>  
>  static void st_tty_receive(struct tty_struct *tty, const unsigned char *data,
> @@ -778,7 +741,6 @@ static void st_tty_receive(struct tty_struct *tty, const unsigned char *data,
>  	 * to KIM for validation
>  	 */
>  	st_recv(tty->disc_data, data, count);
> -	pr_debug("done %s", __func__);
>  }
>  
>  /* wake-up function called in from the TTY layer
> @@ -787,7 +749,7 @@ static void st_tty_receive(struct tty_struct *tty, const unsigned char *data,
>  static void st_tty_wakeup(struct tty_struct *tty)
>  {
>  	struct	st_data_s *st_gdata = tty->disc_data;
> -	pr_debug("%s ", __func__);
> +
>  	/* don't do an wakeup for now */
>  	clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
>  
> @@ -798,7 +760,6 @@ static void st_tty_wakeup(struct tty_struct *tty)
>  static void st_tty_flush_buffer(struct tty_struct *tty)
>  {
>  	struct	st_data_s *st_gdata = tty->disc_data;
> -	pr_debug("%s ", __func__);
>  
>  	kfree_skb(st_gdata->tx_skb);
>  	st_gdata->tx_skb = NULL;
> @@ -826,18 +787,16 @@ int st_core_init(struct st_data_s **core_data)
>  
>  	err = tty_register_ldisc(N_TI_WL, &st_ldisc_ops);
>  	if (err) {
> -		pr_err("error registering %d line discipline %ld",
> -			   N_TI_WL, err);
> +		pr_err("error registering %d line discipline", N_TI_WL);
>  		return err;
>  	}
> -	pr_debug("registered n_shared line discipline");
>  
>  	st_gdata = kzalloc(sizeof(struct st_data_s), GFP_KERNEL);
>  	if (!st_gdata) {
> -		pr_err("memory allocation failed");
> +		pr_err("%s: memory allocation failed", __func__);
>  		err = tty_unregister_ldisc(N_TI_WL);
>  		if (err)
> -			pr_err("unable to un-register ldisc %ld", err);
> +			pr_err("unable to un-register ldisc");
>  		err = -ENOMEM;
>  		return err;
>  	}
> @@ -853,7 +812,7 @@ int st_core_init(struct st_data_s **core_data)
>  
>  	err = st_ll_init(st_gdata);
>  	if (err) {
> -		pr_err("error during st_ll initialization(%ld)", err);
> +		pr_err("error during st_ll initialization");
>  		kfree(st_gdata);
>  		err = tty_unregister_ldisc(N_TI_WL);
>  		if (err)
> @@ -870,7 +829,7 @@ void st_core_exit(struct st_data_s *st_gdata)
>  	/* internal module cleanup */
>  	err = st_ll_deinit(st_gdata);
>  	if (err)
> -		pr_err("error during deinit of ST LL %ld", err);
> +		pr_err("error during deinit of ST LL");
>  
>  	if (st_gdata != NULL) {
>  		/* Free ST Tx Qs and skbs */
> @@ -881,7 +840,7 @@ void st_core_exit(struct st_data_s *st_gdata)
>  		/* TTY ldisc cleanup */
>  		err = tty_unregister_ldisc(N_TI_WL);
>  		if (err)
> -			pr_err("unable to un-register ldisc %ld", err);
> +			pr_err("unable to un-register ldisc");
>  		/* free the global data pointer */
>  		kfree(st_gdata);
>  	}
> diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
> index a7a861c..26df5c0 100644
> --- a/drivers/misc/ti-st/st_kim.c
> +++ b/drivers/misc/ti-st/st_kim.c
> @@ -20,7 +20,6 @@
>   *
>   */
>  
> -#define pr_fmt(fmt) "(stk) :" fmt
>  #include <linux/platform_device.h>
>  #include <linux/jiffies.h>
>  #include <linux/firmware.h>
> @@ -67,8 +66,7 @@ void validate_firmware_response(struct kim_data_s *kim_gdata)
>  {
>  	struct sk_buff *skb = kim_gdata->rx_skb;
>  	if (unlikely(skb->data[5] != 0)) {
> -		pr_err("no proper response during fw download");
> -		pr_err("data6 %x", skb->data[5]);
> +		dev_err(&kim_gdata->kim_pdev->dev, "No proper response during fw download");
>  		kfree_skb(skb);
>  		return;		/* keep waiting for the proper response */
>  	}
> @@ -84,16 +82,14 @@ static inline int kim_check_data_len(struct kim_data_s *kim_gdata, int len)
>  {
>  	register int room = skb_tailroom(kim_gdata->rx_skb);
>  
> -	pr_debug("len %d room %d", len, room);
> -
>  	if (!len) {
>  		validate_firmware_response(kim_gdata);
>  	} else if (len > room) {
>  		/* Received packet's payload length is larger.
>  		 * We can't accommodate it in created skb.
>  		 */
> -		pr_err("Data length is too large len %d room %d", len,
> -			   room);
> +		dev_err(&kim_gdata->kim_pdev->dev, "Data length is too large:"
> +				"len - %d room - %d", len, room);
>  		kfree_skb(kim_gdata->rx_skb);
>  	} else {
>  		/* Packet header has non-zero payload length and
> @@ -126,11 +122,10 @@ void kim_int_recv(struct kim_data_s *kim_gdata,
>  	int len = 0, type = 0;
>  	unsigned char *plen;
>  
> -	pr_debug("%s", __func__);
>  	/* Decode received bytes here */
>  	ptr = data;
>  	if (unlikely(ptr == NULL)) {
> -		pr_err(" received null from TTY ");
> +		dev_err(&kim_gdata->kim_pdev->dev, "Received null from TTY");
>  		return;
>  	}
>  
> @@ -149,7 +144,6 @@ void kim_int_recv(struct kim_data_s *kim_gdata,
>  			switch (kim_gdata->rx_state) {
>  				/* Waiting for complete packet ? */
>  			case ST_W4_DATA:
> -				pr_debug("Complete pkt received");
>  				validate_firmware_response(kim_gdata);
>  				kim_gdata->rx_state = ST_W4_PACKET_TYPE;
>  				kim_gdata->rx_skb = NULL;
> @@ -158,11 +152,10 @@ void kim_int_recv(struct kim_data_s *kim_gdata,
>  			case ST_W4_HEADER:
>  				plen =
>  				(unsigned char *)&kim_gdata->rx_skb->data[1];
> -				pr_debug("event hdr: plen 0x%02x\n", *plen);
>  				kim_check_data_len(kim_gdata, *plen);
>  				continue;
> -			}	/* end of switch */
> -		}		/* end of if rx_state */
> +			}
> +		}
>  		switch (*ptr) {
>  			/* Bluetooth event packet? */
>  		case 0x04:
> @@ -171,7 +164,6 @@ void kim_int_recv(struct kim_data_s *kim_gdata,
>  			type = *ptr;
>  			break;
>  		default:
> -			pr_info("unknown packet");
>  			ptr++;
>  			count--;
>  			continue;
> @@ -181,7 +173,8 @@ void kim_int_recv(struct kim_data_s *kim_gdata,
>  		kim_gdata->rx_skb =
>  			alloc_skb(1024+8, GFP_ATOMIC);
>  		if (!kim_gdata->rx_skb) {
> -			pr_err("can't allocate mem for new packet");
> +			dev_err(&kim_gdata->kim_pdev->dev, "%s: Can't allocate mem for "
> +					"new packet", __func__);
>  			kim_gdata->rx_state = ST_W4_PACKET_TYPE;
>  			kim_gdata->rx_count = 0;
>  			return;
> @@ -199,17 +192,15 @@ static long read_local_version(struct kim_data_s *kim_gdata, char *bts_scr_name)
>  	unsigned short version = 0, chip = 0, min_ver = 0, maj_ver = 0;
>  	const char read_ver_cmd[] = { 0x01, 0x01, 0x10, 0x00 };
>  
> -	pr_debug("%s", __func__);
> -
>  	INIT_COMPLETION(kim_gdata->kim_rcvd);
> -	if (4 != st_int_write(kim_gdata->core_data, read_ver_cmd, 4)) {
> -		pr_err("kim: couldn't write 4 bytes");
> +	if (st_int_write(kim_gdata->core_data, read_ver_cmd, 4) != 4) {
> +		dev_err(&kim_gdata->kim_pdev->dev, "Failed to write 4 bytes");
>  		return -EIO;
>  	}
>  
>  	if (!wait_for_completion_timeout
>  	    (&kim_gdata->kim_rcvd, msecs_to_jiffies(CMD_RESP_TIME))) {
> -		pr_err(" waiting for ver info- timed out ");
> +		dev_err(&kim_gdata->kim_pdev->dev, "Time out waiting for ver info");
>  		return -ETIMEDOUT;
>  	}
>  	INIT_COMPLETION(kim_gdata->kim_rcvd);
> @@ -232,7 +223,6 @@ static long read_local_version(struct kim_data_s *kim_gdata, char *bts_scr_name)
>  	kim_gdata->version.maj_ver = maj_ver;
>  	kim_gdata->version.min_ver = min_ver;
>  
> -	pr_info("%s", bts_scr_name);
>  	return 0;
>  }
>  
> @@ -245,14 +235,14 @@ void skip_change_remote_baud(unsigned char **ptr, long *len)
>  		((struct bts_action *) cur_action)->size;
>  
>  	if (((struct bts_action *) nxt_action)->type != ACTION_WAIT_EVENT) {
> -		pr_err("invalid action after change remote baud command");
> +		pr_debug("Invalid action after change remote baud command");
>  	} else {
>  		*ptr = *ptr + sizeof(struct bts_action) +
>  			((struct bts_action *)cur_action)->size;
>  		*len = *len - (sizeof(struct bts_action) +
>  				((struct bts_action *)cur_action)->size);
>  		/* warn user on not commenting these in firmware */
> -		pr_warn("skipping the wait event of change remote baud");
> +		pr_debug("Skipping the wait event of change remote baud");
>  	}
>  }
>  
> @@ -274,7 +264,7 @@ static long download_firmware(struct kim_data_s *kim_gdata)
>  
>  	err = read_local_version(kim_gdata, bts_scr_name);
>  	if (err != 0) {
> -		pr_err("kim: failed to read local ver");
> +		dev_err(&kim_gdata->kim_pdev->dev, "Failed to read local ver");
>  		return err;
>  	}
>  	err =
> @@ -282,7 +272,7 @@ static long download_firmware(struct kim_data_s *kim_gdata)
>  			     &kim_gdata->kim_pdev->dev);
>  	if (unlikely((err != 0) || (kim_gdata->fw_entry->data == NULL) ||
>  		     (kim_gdata->fw_entry->size == 0))) {
> -		pr_err(" request_firmware failed(errno %ld) for %s", err,
> +		dev_err(&kim_gdata->kim_pdev->dev, "Firmware download failed for %s",
>  			   bts_scr_name);
>  		return -EINVAL;
>  	}
> @@ -295,21 +285,14 @@ static long download_firmware(struct kim_data_s *kim_gdata)
>  	len -= sizeof(struct bts_header);
>  
>  	while (len > 0 && ptr) {
> -		pr_debug(" action size %d, type %d ",
> -			   ((struct bts_action *)ptr)->size,
> -			   ((struct bts_action *)ptr)->type);
> -
>  		switch (((struct bts_action *)ptr)->type) {
>  		case ACTION_SEND_COMMAND:	/* action send */
> -			pr_debug("S");
>  			action_ptr = &(((struct bts_action *)ptr)->data[0]);
>  			if (unlikely
>  			    (((struct hci_command *)action_ptr)->opcode ==
>  			     0xFF36)) {
>  				/* ignore remote change
>  				 * baud rate HCI VS command */
> -				pr_warn("change remote baud"
> -				    " rate command in firmware");
>  				skip_change_remote_baud(&ptr, &len);
>  				break;
>  			}
> @@ -323,7 +306,7 @@ static long download_firmware(struct kim_data_s *kim_gdata)
>  				wr_room_space =
>  					st_get_uart_wr_room(kim_gdata->core_data);
>  				if (wr_room_space < 0) {
> -					pr_err("Unable to get free "
> +					dev_err(&kim_gdata->kim_pdev->dev, "Unable to get free "
>  							"space info from uart tx buffer");
>  					release_firmware(kim_gdata->fw_entry);
>  					return wr_room_space;
> @@ -334,8 +317,8 @@ static long download_firmware(struct kim_data_s *kim_gdata)
>  
>  			/* Timeout happened ? */
>  			if (time_after_eq(jiffies, timeout)) {
> -				pr_err("Timeout while waiting for free "
> -						"free space in uart tx buffer");
> +				dev_err(&kim_gdata->kim_pdev->dev, "Timeout while waiting"
> +						"for free free space in uart tx buffer");
>  				release_firmware(kim_gdata->fw_entry);
>  				return -ETIMEDOUT;
>  			}
> @@ -361,19 +344,19 @@ static long download_firmware(struct kim_data_s *kim_gdata)
>  			 * and requested command write size
>  			 */
>  			if (err != cmd_size) {
> -				pr_err("Number of bytes written to uart "
> -						"tx buffer are not matching with "
> +				dev_err(&kim_gdata->kim_pdev->dev, "Number of bytes written "
> +						"to uart tx buffer are not matching with "
>  						"requested cmd write size");
>  				release_firmware(kim_gdata->fw_entry);
>  				return -EIO;
>  			}
>  			break;
>  		case ACTION_WAIT_EVENT:  /* wait */
> -			pr_debug("W");
>  			if (!wait_for_completion_timeout
>  					(&kim_gdata->kim_rcvd,
>  					 msecs_to_jiffies(CMD_RESP_TIME))) {
> -				pr_err("response timeout during fw download ");
> +				dev_err(&kim_gdata->kim_pdev->dev, "Response timeout during "
> +						"fw download");
>  				/* timed out */
>  				release_firmware(kim_gdata->fw_entry);
>  				return -ETIMEDOUT;
> @@ -381,7 +364,6 @@ static long download_firmware(struct kim_data_s *kim_gdata)
>  			INIT_COMPLETION(kim_gdata->kim_rcvd);
>  			break;
>  		case ACTION_DELAY:	/* sleep */
> -			pr_info("sleep command in scr");
>  			action_ptr = &(((struct bts_action *)ptr)->data[0]);
>  			mdelay(((struct bts_action_delay *)action_ptr)->msec);
>  			break;
> @@ -393,6 +375,8 @@ static long download_firmware(struct kim_data_s *kim_gdata)
>  		    ptr + sizeof(struct bts_action) +
>  		    ((struct bts_action *)ptr)->size;
>  	}
> +
> +	dev_info(&kim_gdata->kim_pdev->dev, "Loaded %s firmware", bts_scr_name);
>  	/* fw download complete */
>  	release_firmware(kim_gdata->fw_entry);
>  	return 0;
> @@ -446,7 +430,6 @@ long st_kim_start(void *kim_data)
>  	struct ti_st_plat_data	*pdata;
>  	struct kim_data_s	*kim_gdata = (struct kim_data_s *)kim_data;
>  
> -	pr_info(" %s", __func__);
>  	pdata = kim_gdata->kim_pdev->dev.platform_data;
>  
>  	do {
> @@ -463,26 +446,24 @@ long st_kim_start(void *kim_data)
>  		INIT_COMPLETION(kim_gdata->ldisc_installed);
>  		/* send notification to UIM */
>  		kim_gdata->ldisc_install = 1;
> -		pr_info("ldisc_install = 1");
> -		sysfs_notify(&kim_gdata->kim_pdev->dev.kobj,
> -				NULL, "install");
> +		sysfs_notify(&kim_gdata->kim_pdev->dev.kobj, NULL, "install");
>  		/* wait for ldisc to be installed */
>  		err = wait_for_completion_timeout(&kim_gdata->ldisc_installed,
>  				msecs_to_jiffies(LDISC_TIME));
>  		if (!err) {
>  			/* ldisc installation timeout,
>  			 * flush uart, power cycle BT_EN */
> -			pr_err("ldisc installation timeout");
> +			dev_err(&kim_gdata->kim_pdev->dev, "Ldisc installation timeout");
>  			err = st_kim_stop(kim_gdata);
>  			continue;
>  		} else {
>  			/* ldisc installed now */
> -			pr_info("line discipline installed");
> +			dev_info(&kim_gdata->kim_pdev->dev, "Line discipline installed");
>  			err = download_firmware(kim_gdata);
>  			if (err != 0) {
>  				/* ldisc installed but fw download failed,
>  				 * flush uart & power cycle BT_EN */
> -				pr_err("download firmware failed");
> +				dev_err(&kim_gdata->kim_pdev->dev, "Download firmware failed");
>  				err = st_kim_stop(kim_gdata);
>  				continue;
>  			} else {	/* on success don't retry */
> @@ -521,7 +502,6 @@ long st_kim_stop(void *kim_data)
>  	}
>  
>  	/* send uninstall notification to UIM */
> -	pr_info("ldisc_install = 0");
>  	kim_gdata->ldisc_install = 0;
>  	sysfs_notify(&kim_gdata->kim_pdev->dev.kobj, NULL, "install");
>  
> @@ -529,7 +509,7 @@ long st_kim_stop(void *kim_data)
>  	err = wait_for_completion_timeout(&kim_gdata->ldisc_installed,
>  			msecs_to_jiffies(LDISC_TIME));
>  	if (!err) {		/* timeout */
> -		pr_err(" timed out waiting for ldisc to be un-installed");
> +		dev_err(&kim_gdata->kim_pdev->dev, "Timed out waiting for ldisc to be un-installed");
>  		return -ETIMEDOUT;
>  	}
>  
> @@ -718,14 +698,14 @@ static int kim_probe(struct platform_device *pdev)
>  
>  	kim_gdata = kzalloc(sizeof(struct kim_data_s), GFP_ATOMIC);
>  	if (!kim_gdata) {
> -		pr_err("no mem to allocate");
> +		dev_err(&pdev->dev, "%s: No mem to allocate", __func__);
>  		return -ENOMEM;
>  	}
>  	dev_set_drvdata(&pdev->dev, kim_gdata);
>  
>  	status = st_core_init(&kim_gdata->core_data);
>  	if (status != 0) {
> -		pr_err(" ST core init failed");
> +		dev_err(&pdev->dev, "ST core init failed");
>  		return -EIO;
>  	}
>  	/* refer to itself */
> @@ -735,14 +715,14 @@ static int kim_probe(struct platform_device *pdev)
>  	kim_gdata->nshutdown = pdata->nshutdown_gpio;
>  	status = gpio_request(kim_gdata->nshutdown, "kim");
>  	if (unlikely(status)) {
> -		pr_err(" gpio %ld request failed ", kim_gdata->nshutdown);
> +		dev_err(&pdev->dev, "Gpio %ld request failed ", kim_gdata->nshutdown);
>  		return status;
>  	}
>  
>  	/* Configure nShutdown GPIO as output=0 */
>  	status = gpio_direction_output(kim_gdata->nshutdown, 0);
>  	if (unlikely(status)) {
> -		pr_err(" unable to configure gpio %ld", kim_gdata->nshutdown);
> +		dev_err(&pdev->dev, "Unable to configure gpio %ld", kim_gdata->nshutdown);
>  		return status;
>  	}
>  	/* get reference of pdev for request_firmware
> @@ -753,7 +733,7 @@ static int kim_probe(struct platform_device *pdev)
>  
>  	status = sysfs_create_group(&pdev->dev.kobj, &uim_attr_grp);
>  	if (status) {
> -		pr_err("failed to create sysfs entries");
> +		dev_err(&pdev->dev, "Failed to create sysfs entries");
>  		return status;
>  	}
>  
> @@ -761,11 +741,11 @@ static int kim_probe(struct platform_device *pdev)
>  	strncpy(kim_gdata->dev_name, pdata->dev_name, UART_DEV_NAME_LEN);
>  	kim_gdata->flow_cntrl = pdata->flow_cntrl;
>  	kim_gdata->baud_rate = pdata->baud_rate;
> -	pr_info("sysfs entries created\n");
> +	dev_info(&pdev->dev, "sysfs entries created\n");
>  
>  	kim_debugfs_dir = debugfs_create_dir("ti-st", NULL);
>  	if (IS_ERR(kim_debugfs_dir)) {
> -		pr_err(" debugfs entries creation failed ");
> +		dev_err(&pdev->dev, "Failed to create debugfs entries");
>  		kim_debugfs_dir = NULL;
>  		return -EIO;
>  	}
> @@ -774,7 +754,7 @@ static int kim_probe(struct platform_device *pdev)
>  				kim_gdata, &version_debugfs_fops);
>  	debugfs_create_file("protocols", S_IRUGO, kim_debugfs_dir,
>  				kim_gdata, &list_debugfs_fops);
> -	pr_info(" debugfs entries created ");
> +	dev_info(&pdev->dev, "debugfs entries created");
>  	return 0;
>  }
>  
> @@ -790,11 +770,11 @@ static int kim_remove(struct platform_device *pdev)
>  	 * nShutdown gpio from the system
>  	 */
>  	gpio_free(pdata->nshutdown_gpio);
> -	pr_info("nshutdown GPIO Freed");
> +	dev_info(&pdev->dev, "nshutdown GPIO Freed");
>  
>  	debugfs_remove_recursive(kim_debugfs_dir);
>  	sysfs_remove_group(&pdev->dev.kobj, &uim_attr_grp);
> -	pr_info("sysfs entries removed");
> +	dev_info(&pdev->dev, "sysfs entries removed");
>  
>  	kim_gdata->kim_pdev = NULL;
>  	st_core_exit(kim_gdata->core_data);
> diff --git a/drivers/misc/ti-st/st_ll.c b/drivers/misc/ti-st/st_ll.c
> index 1ff460a..0f502d4 100644
> --- a/drivers/misc/ti-st/st_ll.c
> +++ b/drivers/misc/ti-st/st_ll.c
> @@ -19,7 +19,6 @@
>   *
>   */
>  
> -#define pr_fmt(fmt) "(stll) :" fmt
>  #include <linux/skbuff.h>
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
> @@ -30,8 +29,6 @@
>  static void send_ll_cmd(struct st_data_s *st_data,
>  	unsigned char cmd)
>  {
> -
> -	pr_debug("%s: writing %x", __func__, cmd);
>  	st_int_write(st_data, &cmd, 1);
>  	return;
>  }
> @@ -41,7 +38,6 @@ static void ll_device_want_to_sleep(struct st_data_s *st_data)
>  	struct kim_data_s	*kim_data;
>  	struct ti_st_plat_data	*pdata;
>  
> -	pr_debug("%s", __func__);
>  	/* sanity check */
>  	if (st_data->ll_state != ST_LL_AWAKE)
>  		pr_err("ERR hcill: ST_LL_GO_TO_SLEEP_IND"
> @@ -70,15 +66,15 @@ static void ll_device_want_to_wakeup(struct st_data_s *st_data)
>  		break;
>  	case ST_LL_ASLEEP_TO_AWAKE:
>  		/* duplicate wake_ind */
> -		pr_err("duplicate wake_ind while waiting for Wake ack");
> +		pr_debug("duplicate wake_ind while waiting for Wake ack");
>  		break;
>  	case ST_LL_AWAKE:
>  		/* duplicate wake_ind */
> -		pr_err("duplicate wake_ind already AWAKE");
> +		pr_debug("duplicate wake_ind already AWAKE");
>  		break;
>  	case ST_LL_AWAKE_TO_ASLEEP:
>  		/* duplicate wake_ind */
> -		pr_err("duplicate wake_ind");
> +		pr_debug("duplicate wake_ind");
>  		break;
>  	}
>  	/* update state */
> @@ -116,14 +112,13 @@ void st_ll_wakeup(struct st_data_s *ll)
>  		ll->ll_state = ST_LL_ASLEEP_TO_AWAKE;
>  	} else {
>  		/* don't send the duplicate wake_indication */
> -		pr_err(" Chip already AWAKE ");
> +		pr_debug("Chip already AWAKE");
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
> @@ -137,7 +132,7 @@ unsigned long st_ll_sleep_state(struct st_data_s *st_data,
>  		ll_device_want_to_sleep(st_data);
>  		break;
>  	case LL_SLEEP_ACK:	/* sleep ack */
> -		pr_err("sleep ack rcvd: host shouldn't");
> +		pr_debug("sleep ack rcvd: host shouldn't");
>  		break;
>  	case LL_WAKE_UP_IND:	/* wake ind */
>  		pr_debug("wake indication recvd");
> @@ -148,7 +143,7 @@ unsigned long st_ll_sleep_state(struct st_data_s *st_data,
>  		st_data->ll_state = ST_LL_AWAKE;
>  		break;
>  	default:
> -		pr_err(" unknown input/state ");
> +		pr_err("unknown input/state");
>  		return -EINVAL;
>  	}
>  	return 0;


-- 
Ing. Mircea Gherzan
